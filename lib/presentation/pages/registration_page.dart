import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:worbbing/core/exceptions/database_exception.dart';
import 'package:worbbing/core/exceptions/registration_page_exception.dart';
import 'package:worbbing/data/repositories/sqflite/word_list_repository_impl.dart';
import 'package:worbbing/domain/entities/word_model.dart';
import 'package:worbbing/domain/usecases/word/add_word_usecase.dart';
import 'package:worbbing/presentation/widgets/error_dialog.dart';
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

    final originalWordController =
        useTextEditingController(text: initialText ?? "");
    final translatedController = useTextEditingController();
    final exampleController = useTextEditingController();
    final exampleTranslatedController = useTextEditingController();

    final focusNode = useFocusNode();

    final originalColor = useState(MyTheme.lemon);
    final translateColor = useState(MyTheme.orange);
    final isTranslateLangError = useState(false);

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

    void handleTapOriginalLang() {
      final color = MyTheme.lemon;
      TranslateLanguage selectLang = viewModel.originalLanguage;
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return LanguageSelector(
              title: 'Original Language',
              initialLanguage: selectLang,
              color: color,
              onSelect: (lang) {
                ref
                    .read(registrationPageViewModelProvider.notifier)
                    .setOriginalLanguage(lang);
              },
            );
          });
    }

    void handleTapTranslateLang(TranslateLanguage lang) {
      final color = MyTheme.orange;
      TranslateLanguage selectLang = lang;
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return LanguageSelector(
              title: 'Translate Language',
              initialLanguage: selectLang,
              color: color,
              onSelect: (lang) {
                ref
                    .read(registrationPageViewModelProvider.notifier)
                    .setTranslateLanguage(lang);
              },
            );
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

        /// 提案の場合
        if (res.type == TranslatedResponseType.suggestion) {
          if (!context.mounted) return;
          TranslateSuggestDialog.execute(
              context, originalWordController.text, res, () {
            ref.read(ticketStateProvider.notifier).useTicket();
            originalWordController.text = res.original;
            translatedController.text =
                "${res.translated[0]}, ${res.translated[1]}, ${res.translated[2]}";
            exampleController.text = res.example;
            exampleTranslatedController.text = res.exampleTranslated;
          });

          /// 正しく翻訳された場合
        } else {
          ref.read(ticketStateProvider.notifier).useTicket();
          originalWordController.text = res.original;
          translatedController.text =
              "${res.translated[0]}, ${res.translated[1]}, ${res.translated[2]}";
          exampleController.text = res.example;
          exampleTranslatedController.text = res.exampleTranslated;
        }
      } on TranslateException catch (_) {
        if (!context.mounted) return;
        ErrorDialog.show(context: context, text: 'Failed to translate!');
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
            text: '"${originalWordController.text}" is\nalready registered.');
      } catch (e) {
        if (!context.mounted) return;
        ErrorDialog.show(context: context, text: 'Failed to save word!');
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
                                                                ticket),
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
                                                                  Align(
                                                                      alignment: const Alignment(
                                                                          -0.95,
                                                                          0.0),
                                                                      child: bodyText(
                                                                          'Original',
                                                                          MyTheme
                                                                              .lightGrey)),
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
                                                                          true),
                                                                  const SizedBox(
                                                                      height:
                                                                          24),
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
                                                                          8),
                                                                  Align(
                                                                      alignment: const Alignment(
                                                                          -0.95,
                                                                          0.0),
                                                                      child: bodyText(
                                                                          'Translated',
                                                                          MyTheme
                                                                              .lightGrey)),
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
                                                                  Align(
                                                                      alignment: const Alignment(
                                                                          -0.95,
                                                                          0.0),
                                                                      child: bodyText(
                                                                          'Example',
                                                                          MyTheme
                                                                              .lightGrey)),
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
                                                                  Align(
                                                                      alignment: const Alignment(
                                                                          -0.95,
                                                                          0.0),
                                                                      child: bodyText(
                                                                          'Translated Example',
                                                                          MyTheme
                                                                              .lightGrey)),
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
                  _buildUnderButtons(context, () {
                    context.pop();
                  }, () async {
                    await saveWord();
                  })
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

  Widget buildTopTitle(BuildContext context, int ticket) {
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
          const Expanded(
            child: AutoSizeText(
              'Registration',
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
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

  Widget _buildUnderButtons(
      BuildContext context, VoidCallback onCancel, VoidCallback onSave) {
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
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 26,
                                  color: MyTheme.greyForOrange,
                                  fontWeight: FontWeight.bold,
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
                                'Save',
                                style: TextStyle(
                                  fontSize: 28,
                                  color: MyTheme.greyForOrange,
                                  fontWeight: FontWeight.bold,
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

class LanguageSelector extends StatefulWidget {
  final String title;
  final TranslateLanguage initialLanguage;
  final Color color;
  final Function(TranslateLanguage) onSelect;
  const LanguageSelector(
      {super.key,
      required this.title,
      required this.initialLanguage,
      required this.color,
      required this.onSelect});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  late TranslateLanguage selectLang;

  @override
  void initState() {
    super.initState();
    selectLang = widget.initialLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Container(
          padding:
              const EdgeInsets.only(top: 18, bottom: 0, left: 18, right: 18),
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade800.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(widget.title,
                  style: TextStyle(fontSize: 28, color: widget.color)),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: TranslateLanguage.values
                        .map((lang) => Center(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    selectLang = lang;
                                  });
                                  widget.onSelect(lang);
                                },
                                child: Center(
                                  child: Container(
                                    constraints: const BoxConstraints(
                                      maxWidth: 200,
                                    ),
                                    width: double.infinity,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    decoration: BoxDecoration(
                                      border: selectLang == lang
                                          ? Border.all(
                                              color: widget.color, width: 2)
                                          : null,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(lang.upperString,
                                        style: const TextStyle(
                                            fontSize: 24, color: Colors.white)),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
