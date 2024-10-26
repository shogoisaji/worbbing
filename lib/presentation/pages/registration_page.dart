import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:worbbing/core/exceptions/database_exception.dart';
import 'package:worbbing/core/exceptions/registration_page_exception.dart';
import 'package:worbbing/data/repositories/sqflite/word_list_repository_impl.dart';
import 'package:worbbing/domain/entities/word_model.dart';
import 'package:worbbing/domain/usecases/app/speak_word_usecase.dart';
import 'package:worbbing/domain/usecases/word/add_word_usecase.dart';
import 'package:worbbing/l10n/l10n.dart';
import 'package:worbbing/presentation/widgets/error_dialog.dart';
import 'package:worbbing/presentation/widgets/language_selector.dart';
import 'package:worbbing/providers/ticket_state.dart';
import 'package:worbbing/domain/entities/translate_language.dart';
import 'package:worbbing/domain/entities/translated_api_response.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/view_model/registration_page_view_model.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/custom_text_field.dart';
import 'package:worbbing/presentation/widgets/kati_button.dart';
import 'package:worbbing/presentation/widgets/language_dropdown_vertical.dart';
import 'package:worbbing/presentation/widgets/ticket_widget.dart';
import 'package:worbbing/presentation/widgets/translate_suggest_dialog.dart';

class RegistrationPage extends HookConsumerWidget {
  final String? initialText;

  const RegistrationPage({Key? key, this.initialText}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final ticket = ref.watch(ticketStateProvider);
    final viewModel = ref.watch(registrationPageViewModelProvider);

    final l10n = L10n.of(context)!;

    final originalWordController =
        useTextEditingController(text: initialText ?? "");
    final translatedController = useTextEditingController();
    final exampleController = useTextEditingController();
    final exampleTranslatedController = useTextEditingController();

    final focusNode = useFocusNode();

    final originalColor = useState(MyTheme.lemon);
    final translateColor = useState(MyTheme.orange);
    final isTranslateLangError = useState(false);
    final translateComment = useState("");

    final animationController =
        useAnimationController(duration: const Duration(milliseconds: 600));
    final originalAnimationController =
        useAnimationController(duration: const Duration(milliseconds: 150));
    final translateAnimationController =
        useAnimationController(duration: const Duration(milliseconds: 150));
    final animation = useMemoized(() => CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ));

    Future<void> handleTapSpeak(String word, TranslateLanguage lang) async {
      await ref.read(speakWordUsecaseProvider.notifier).execute(word, lang);
    }

    void handleTapOriginalLang() {
      final color = MyTheme.lemon;
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return LanguageSelector<TranslateLanguage>(
              title: l10n.original_language,
              initialLanguage: viewModel.originalLanguage,
              color: color,
              onSelect: (dynamic lang) {
                ref
                    .read(registrationPageViewModelProvider.notifier)
                    .setOriginalLanguage(lang as TranslateLanguage);
              },
              languages: TranslateLanguage.values,
              languageToString: (dynamic lang) =>
                  (lang as TranslateLanguage).upperString,
            );
          });
    }

    void handleTapTranslateLang(TranslateLanguage lang) {
      final color = MyTheme.orange;
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return LanguageSelector<TranslateLanguage>(
                title: l10n.translate_language,
                initialLanguage: viewModel.translateLanguage,
                color: color,
                onSelect: (dynamic lang) {
                  ref
                      .read(registrationPageViewModelProvider.notifier)
                      .setTranslateLanguage(lang as TranslateLanguage);
                },
                languages: TranslateLanguage.values,
                languageToString: (dynamic lang) =>
                    (lang as TranslateLanguage).upperString);
          });
    }

    useEffect(() {
      focusNode.requestFocus();
      return null;
    }, []);

    useEffect(() {
      if (viewModel.isLoading) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
      return null;
    }, [viewModel.isLoading]);

    Future<void> shakeAnimation(AnimationController controller,
        {int times = 2}) async {
      for (int i = 0; i < times; i++) {
        originalColor.value = MyTheme.red;
        await controller.forward();
        await controller.reverse();
        originalColor.value = MyTheme.lemon;
      }
    }

    Future<void> handleTranslateAi() async {
      translateComment.value = "";
      bool hasError = false;
      if (originalWordController.text.isEmpty) {
        shakeAnimation(originalAnimationController);
        hasError = true;
      }
      if (viewModel.originalLanguage == viewModel.translateLanguage) {
        isTranslateLangError.value = true;
        Future.delayed(const Duration(milliseconds: 100), () {
          isTranslateLangError.value = false;
        });
        hasError = true;
      }
      if (hasError) {
        return;
      }
      focusNode.unfocus();
      try {
        final res = await ref
            .read(registrationPageViewModelProvider.notifier)
            .translateOriginalWord(
                context, ticket, originalWordController.text);
        if (res == null) {
          print("res is null");
          return;
        }
        if (res.comment != null) {
          translateComment.value = res.comment!;
        }

        /// 提案の場合
        if (res.type == TranslatedResponseType.suggestion) {
          if (!context.mounted) return;
          TranslateSuggestDialog.execute(
              context, originalWordController.text, res, () {
            translateComment.value = "";
            ref.read(ticketStateProvider.notifier).useTicket();
            originalWordController.text = res.original;
            translatedController.text =
                res.translated.map((e) => e.toString()).join(", ");
            exampleController.text = res.example;
            exampleTranslatedController.text = res.exampleTranslated;
          });

          /// 正しく翻訳された場合
        } else {
          ref.read(ticketStateProvider.notifier).useTicket();
          originalWordController.text = res.original;
          translatedController.text =
              res.translated.map((e) => e.toString()).join(", ");
          exampleController.text = res.example;
          exampleTranslatedController.text = res.exampleTranslated;
          if (!context.mounted) return;
        }
      } on TranslateException catch (e) {
        if (!context.mounted) return;
        if (e.message != null) {
          ErrorDialog.show(
              context: context, text: "Failed to translate\n\n⚠️${e.message}");
        } else {
          ErrorDialog.show(context: context, text: "Failed to translate");
        }
      } on Exception catch (_) {
        if (!context.mounted) return;
        ErrorDialog.show(context: context, text: "Failed to translate");
      }
    }

    Future<void> saveWord() async {
      bool isOriginalEmpty = originalWordController.text.isEmpty;
      bool isTranslatedEmpty = translatedController.text.isEmpty;

      if (isOriginalEmpty || isTranslatedEmpty) {
        await Future.wait([
          if (isOriginalEmpty) ...[
            Future(() => originalColor.value = MyTheme.red),
            shakeAnimation(originalAnimationController),
          ],
          if (isTranslatedEmpty) ...[
            Future(() => translateColor.value = MyTheme.red),
            shakeAnimation(translateAnimationController),
          ],
        ]);

        if (isOriginalEmpty) {
          originalColor.value = MyTheme.lemon;
        }
        if (isTranslatedEmpty) {
          translateColor.value = MyTheme.orange;
        }
        return;
      }
      final newWord = WordModel.createNewWord(
        originalWord: originalWordController.text,
        translatedWord: translatedController.text,
        example: exampleController.text,
        exampleTranslated: exampleTranslatedController.text,
        originalLang: viewModel.originalLanguage,
        translatedLang: viewModel.translateLanguage,
      );
      try {
        await AddWordUsecase(
          ref.read(wordListRepositoryProvider),
        ).execute(newWord);

        if (!context.mounted) return;
        context.pop();
      } on DuplicateItemException catch (_) {
        if (!context.mounted) return;
        ErrorDialog.show(
            context: context,
            text: l10n.exist_word(originalWordController.text));
      } catch (e) {
        if (!context.mounted) return;
        ErrorDialog.show(context: context, text: l10n.save_failed);
      }
    }

    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) => IgnorePointer(
            ignoring: viewModel.isLoading,
            child: Scaffold(
                backgroundColor: Colors.transparent,
                resizeToAvoidBottomInset: false,
                body: Stack(children: [
                  viewModel.isLoading
                      ? buildLoading(h, w)
                      : const SizedBox.shrink(),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height *
                              0.9 *
                              (1 - animation.value),
                          child: Stack(fit: StackFit.expand, children: [
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.9,
                                        child: Scaffold(
                                            backgroundColor: Colors.transparent,
                                            body: Stack(
                                                fit: StackFit.expand,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 12,
                                                        bottom: 0,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: MyTheme.grey,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          topRight:
                                                              Radius.circular(
                                                                  20),
                                                        ),
                                                      ),
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            buildTopTitle(
                                                                context,
                                                                ticket,
                                                                l10n.registration),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          32),
                                                              child: Column(
                                                                children: [
                                                                  const SizedBox(
                                                                      height:
                                                                          10),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                6.0),
                                                                        child: bodyText(
                                                                            l10n.original,
                                                                            MyTheme.lightGrey),
                                                                      ),
                                                                      InkWell(
                                                                        onTap: () => handleTapSpeak(
                                                                            originalWordController.text,
                                                                            viewModel.originalLanguage),
                                                                        child:
                                                                            const Padding(
                                                                          padding: EdgeInsets.symmetric(
                                                                              horizontal: 6,
                                                                              vertical: 9),
                                                                          child:
                                                                              FaIcon(
                                                                            FontAwesomeIcons.volumeHigh,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                16,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  CustomTextField(
                                                                    textController:
                                                                        originalWordController,
                                                                    animationController:
                                                                        originalAnimationController,
                                                                    color: originalColor
                                                                        .value,
                                                                    focusNode:
                                                                        focusNode,
                                                                    isOriginalInput:
                                                                        true,
                                                                    isEnglish:
                                                                        true,
                                                                    onChange:
                                                                        () {
                                                                      translateComment
                                                                          .value = "";
                                                                    },
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          12),
                                                                  translateComment
                                                                          .value
                                                                          .isNotEmpty
                                                                      ? Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 8.0),
                                                                          child:
                                                                              Text(
                                                                            translateComment.value,
                                                                            style:
                                                                                TextStyle(fontSize: 16, color: MyTheme.lemon.withOpacity(0.7)),
                                                                          ),
                                                                        )
                                                                      : const SizedBox
                                                                          .shrink(),
                                                                  const SizedBox(
                                                                      height:
                                                                          12),
                                                                  LayoutBuilder(
                                                                      builder:
                                                                          (context,
                                                                              constraints) {
                                                                    const spaceRate =
                                                                        [
                                                                      6,
                                                                      1,
                                                                      7
                                                                    ];
                                                                    final rowWidth =
                                                                        constraints
                                                                            .maxWidth;
                                                                    final langSelectWidth = rowWidth *
                                                                        spaceRate[
                                                                            0] /
                                                                        spaceRate.reduce((a,
                                                                                b) =>
                                                                            a +
                                                                            b);
                                                                    final buttonWidth = rowWidth *
                                                                        spaceRate[
                                                                            2] /
                                                                        spaceRate.reduce((a,
                                                                                b) =>
                                                                            a +
                                                                            b);
                                                                    return Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        LanguageDropdownVertical(
                                                                          originalLanguage:
                                                                              viewModel.originalLanguage,
                                                                          translateLanguage:
                                                                              viewModel.translateLanguage,
                                                                          onTapOriginal:
                                                                              () {
                                                                            handleTapOriginalLang();
                                                                          },
                                                                          onTapTranslate:
                                                                              () {
                                                                            handleTapTranslateLang(viewModel.translateLanguage);
                                                                          },
                                                                          isError:
                                                                              isTranslateLangError.value,
                                                                          width:
                                                                              langSelectWidth,
                                                                        ),
                                                                        TranslateButton(
                                                                            width:
                                                                                buttonWidth,
                                                                            isEnabled:
                                                                                ticket != 0 && originalWordController.text != "",
                                                                            onPressed: () {
                                                                              HapticFeedback.lightImpact();
                                                                              handleTranslateAi();
                                                                            }),
                                                                      ],
                                                                    );
                                                                  }),
                                                                  const SizedBox(
                                                                      height:
                                                                          12),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                6.0),
                                                                        child: bodyText(
                                                                            l10n.translated,
                                                                            MyTheme.lightGrey),
                                                                      ),
                                                                      InkWell(
                                                                        onTap: () => handleTapSpeak(
                                                                            translatedController.text,
                                                                            viewModel.translateLanguage),
                                                                        child:
                                                                            const Padding(
                                                                          padding: EdgeInsets.symmetric(
                                                                              horizontal: 6,
                                                                              vertical: 9),
                                                                          child:
                                                                              FaIcon(
                                                                            FontAwesomeIcons.volumeHigh,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                16,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  CustomTextField(
                                                                      textController:
                                                                          translatedController,
                                                                      animationController:
                                                                          translateAnimationController,
                                                                      color: translateColor
                                                                          .value,
                                                                      isEnglish:
                                                                          false),
                                                                  const SizedBox(
                                                                      height:
                                                                          16),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                6.0),
                                                                        child: bodyText(
                                                                            l10n.example,
                                                                            MyTheme.lightGrey),
                                                                      ),
                                                                      InkWell(
                                                                        onTap: () => handleTapSpeak(
                                                                            exampleController.text,
                                                                            viewModel.originalLanguage),
                                                                        child:
                                                                            const Padding(
                                                                          padding: EdgeInsets.symmetric(
                                                                              horizontal: 6,
                                                                              vertical: 9),
                                                                          child:
                                                                              FaIcon(
                                                                            FontAwesomeIcons.volumeHigh,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                16,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  CustomTextField(
                                                                      textController:
                                                                          exampleController,
                                                                      color: MyTheme
                                                                          .lemon,
                                                                      lines: 2,
                                                                      isEnglish:
                                                                          true),
                                                                  const SizedBox(
                                                                      height:
                                                                          16),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                6.0),
                                                                        child: bodyText(
                                                                            l10n.translated_example,
                                                                            MyTheme.lightGrey),
                                                                      ),
                                                                      InkWell(
                                                                        onTap: () => handleTapSpeak(
                                                                            exampleTranslatedController.text,
                                                                            viewModel.translateLanguage),
                                                                        child:
                                                                            const Padding(
                                                                          padding: EdgeInsets.symmetric(
                                                                              horizontal: 6,
                                                                              vertical: 9),
                                                                          child:
                                                                              FaIcon(
                                                                            FontAwesomeIcons.volumeHigh,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                16,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  CustomTextField(
                                                                      textController:
                                                                          exampleTranslatedController,
                                                                      color: MyTheme
                                                                          .orange,
                                                                      lines: 2,
                                                                      isEnglish:
                                                                          false),
                                                                  const SizedBox(
                                                                      height:
                                                                          200),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ]))))),
                          ]))),
                  _buildUnderButtons(
                    context,
                    () {
                      context.pop();
                    },
                    () async {
                      await saveWord();
                    },
                    l10n.cancel,
                    l10n.save,
                  )
                ]))));
  }

  Widget buildLoading(double h, double w) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.transparent,
        width: w,
        height: h * 0.7,
        child: Lottie.asset(
          fit: BoxFit.fitWidth,
          'assets/lottie/t.json',
          // 'assets/lottie/w_loading.json',
        ),
      ),
    );
  }

  Widget buildTopTitle(BuildContext context, int ticket, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TicketWidget(
            count: ticket,
            size: 65,
            isEnabledUseAnimation: true,
            bgColor: MyTheme.grey,
          ),
          Expanded(
            child: AutoSizeText(
              title,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              context.pop();
            },
            child: Icon(Icons.cancel_rounded, size: 46, color: MyTheme.orange),
          ),
        ],
      ),
    );
  }

  Widget _buildUnderButtons(BuildContext context, VoidCallback onCancel,
      VoidCallback onSave, String cancel, String save) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            width: double.infinity,
            height: 90 + MediaQuery.of(context).padding.bottom,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade800,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, -2),
                  blurRadius: 7,
                ),
              ],
            ),
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: LayoutBuilder(builder: (context, constraints) {
                    const widthRate = [6, 1, 8];
                    final cancelWidth = constraints.maxWidth *
                        widthRate[0] /
                        widthRate.reduce((a, b) => a + b);
                    final spaceWidth = constraints.maxWidth *
                        widthRate[1] /
                        widthRate.reduce((a, b) => a + b);
                    final saveWidth = constraints.maxWidth *
                        widthRate[2] /
                        widthRate.reduce((a, b) => a + b);
                    return Row(
                      children: [
                        KatiButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            onCancel();
                          },
                          width: cancelWidth,
                          height: 65,
                          elevation: 8,
                          buttonRadius: 12,
                          stageOffset: 5,
                          inclinationRate: 0.9,
                          buttonColor: Colors.grey.shade300,
                          stageColor: Colors.blueGrey.shade600,
                          stagePointColor: Colors.blueGrey.shade500,
                          edgeLineColor: Colors.grey.shade100,
                          edgeBorder: Border.all(
                              color: Colors.white.withOpacity(0.5), width: 0.8),
                          child: Align(
                            alignment: const Alignment(0.4, 0.85),
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationX(0.5),
                              child: Text(
                                cancel,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: MyTheme.greyForOrange,
                                  fontWeight: FontWeight.w500,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.grey.shade800,
                                      blurRadius: 1.0,
                                      offset: const Offset(0, -0.7),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: spaceWidth),
                        KatiButton(
                          onPressed: () async {
                            HapticFeedback.lightImpact();
                            onSave();
                          },
                          width: saveWidth,
                          height: 65,
                          elevation: 8,
                          buttonRadius: 12,
                          stageOffset: 5,
                          inclinationRate: 0.9,
                          edgeLineColor: Colors.orange.shade300,
                          buttonColor: MyTheme.orange,
                          stageColor: Colors.blueGrey.shade600,
                          stagePointColor: Colors.blueGrey.shade500,
                          edgeBorder: Border.all(
                              color: Colors.white.withOpacity(0.5), width: 0.8),
                          child: Align(
                            alignment: const Alignment(0.75, 0.8),
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationX(0.5),
                              child: Text(
                                save,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: MyTheme.greyForOrange,
                                  fontWeight: FontWeight.w500,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.grey.shade800,
                                      blurRadius: 1.0,
                                      offset: const Offset(0, -0.7),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            )));
  }
}

// class LanguageSelector extends StatefulWidget {
//   final String title;
//   final TranslateLanguage initialLanguage;
//   final Color color;
//   final Function(T) onSelect;
//   const LanguageSelector(
//       {super.key,
//       required this.title,
//       required this.initialLanguage,
//       required this.color,
//       required this.onSelect});

//   @override
//   State<LanguageSelector> createState() => _LanguageSelectorState();
// }

// class _LanguageSelectorState extends State<LanguageSelector> {
//   late TranslateLanguage selectLang;

//   @override
//   void initState() {
//     super.initState();
//     selectLang = widget.initialLanguage;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.only(top: 0, bottom: 8, left: 18, right: 18),
//         child: Container(
//           padding:
//               const EdgeInsets.only(top: 12, bottom: 0, left: 18, right: 18),
//           decoration: BoxDecoration(
//             color: Colors.blueGrey.shade800.withOpacity(0.9),
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Column(
//             children: [
//               Container(
//                 width: 100,
//                 height: 3,
//                 margin: const EdgeInsets.only(bottom: 12),
//                 padding: const EdgeInsets.symmetric(vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.blueGrey.shade600,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.blueGrey.shade700,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 alignment: Alignment.center,
//                 child: Text(widget.title,
//                     style: TextStyle(fontSize: 28, color: widget.color)),
//               ),
//               const SizedBox(height: 12),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: TranslateLanguage.values
//                         .map((lang) => Center(
//                               child: InkWell(
//                                 onTap: () {
//                                   HapticFeedback.lightImpact();
//                                   setState(() {
//                                     selectLang = lang;
//                                   });
//                                   widget.onSelect(lang);
//                                 },
//                                 child: Center(
//                                   child: Container(
//                                     constraints: const BoxConstraints(
//                                       maxWidth: 200,
//                                     ),
//                                     width: double.infinity,
//                                     margin:
//                                         const EdgeInsets.symmetric(vertical: 2),
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 6, horizontal: 16),
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                           color: selectLang == lang
//                                               ? widget.color
//                                               : Colors.transparent,
//                                           width: 2),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     alignment: Alignment.center,
//                                     child: Text(lang.upperString,
//                                         style: const TextStyle(
//                                             fontSize: 24, color: Colors.white)),
//                                   ),
//                                 ),
//                               ),
//                             ))
//                         .toList(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class TranslateButton extends StatefulWidget {
  final double width;
  final bool isEnabled;
  final Function onPressed;

  const TranslateButton(
      {Key? key,
      required this.onPressed,
      required this.isEnabled,
      required this.width})
      : super(key: key);

  @override
  State<TranslateButton> createState() => _TranslateButtonState();
}

class _TranslateButtonState extends State<TranslateButton>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  OverlayEntry? overlayEntry;
  final GlobalKey widgetKey = GlobalKey();

  void showOverlay(BuildContext context) {
    final currentContext = widgetKey.currentContext;
    if (currentContext == null) return;

    final RenderBox renderBox = currentContext.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
              top: position.dy,
              left: position.dx,
              child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: 1 - animationController.value,
                      child: Transform.scale(
                        scale: 1 + 0.5 * animationController.value,
                        child: Material(
                          color: Colors.transparent,
                          child: buildKatiButton(),
                        ),
                      ),
                    );
                  }),
            ));
    Overlay.of(context).insert(overlayEntry!);
  }

  void removeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      animationController = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400));
      animationController.addStatusListener((status) {
        if (status == AnimationStatus.forward) {
          showOverlay(context);
        } else if (status == AnimationStatus.completed) {
          removeOverlay();
        } else {
          removeOverlay();
        }
      });
    });
  }

  @override
  void dispose() {
    removeOverlay();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
          alignment: Alignment.centerRight,
          child: buildKatiButton(key: widgetKey)),
    );
  }

  Widget buildKatiButton({Key? key}) {
    return KatiButton(
      key: key,
      onPressed: () async {
        widget.onPressed();
        if (!widget.isEnabled) return;
        await animationController.forward();
        animationController.reset();
      },
      width: widget.width.clamp(50, 300),
      height: 85,
      elevation: 9,
      buttonRadius: 16,
      stageOffset: 6,
      inclinationRate: 0.8,
      pushedElevationLevel: widget.isEnabled ? 0.7 : 0.2,
      stageColor: Colors.blueGrey.shade700,
      buttonColor: Colors.grey.shade400,
      stagePointColor: Colors.blueGrey.shade400,
      edgeLineColor: Colors.blue.shade100.withOpacity(0.5),
      edgeBorder: Border.all(color: Colors.white.withOpacity(0.5), width: 0.8),
      bgWidget: Lottie.asset(
          width: widget.width.clamp(50, 200),
          fit: BoxFit.cover,
          'assets/lottie/move_gradient.json'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(1.0, -0.9),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationX((1 - 0.8) * 1.5),
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'with',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      WidgetSpan(child: SizedBox(width: 1)),
                      TextSpan(
                        text: 'AI',
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(1.0, 1.0),
              child: Transform(
                transform: Matrix4.rotationX((1 - 0.8) * 1.5),
                child: const AutoSizeText(
                  'Translate',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
