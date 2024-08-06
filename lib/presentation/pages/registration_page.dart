import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';
import 'package:worbbing/application/api/translate_api.dart';
import 'package:worbbing/application/state/ticket_state.dart';
import 'package:worbbing/application/state/translate_lang_state.dart';
import 'package:worbbing/domain/entities/translate_language.dart';
import 'package:worbbing/domain/entities/translated_api_response.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/custom_text_field.dart';
import 'package:worbbing/presentation/widgets/kati_button.dart';
import 'package:worbbing/presentation/widgets/language_dropdown_vertical.dart';
import 'package:worbbing/presentation/widgets/my_simple_dialog.dart';
import 'package:worbbing/presentation/widgets/ticket_widget.dart';
import 'package:worbbing/presentation/widgets/two_way_dialog.dart';
import 'package:worbbing/repository/sqflite/sqflite_repository.dart';
import 'package:lottie/lottie.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RegistrationPage extends HookConsumerWidget {
  final String? initialText;

  const RegistrationPage({Key? key, this.initialText}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final ticket = ref.watch(ticketStateProvider);
    final ticketNotifier = ref.read(ticketStateProvider.notifier);
    final originalWordController =
        useTextEditingController(text: initialText ?? "");
    final translatedController = useTextEditingController();
    final exampleController = useTextEditingController();
    final exampleTranslatedController = useTextEditingController();
    final focusNode = useFocusNode();

    final originalLanguage = useState<TranslateLanguage>(
        ref.read(translateLangStateProvider)['original']!);
    final translateLanguage = useState<TranslateLanguage>(
        ref.read(translateLangStateProvider)['translate']!);

    final originalColor = useState(MyTheme.lemon);
    final translateColor = useState(MyTheme.orange);
    final isLoading = useState(false);

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

    useEffect(() {
      focusNode.requestFocus();
      return null;
    }, []);

    Future<void> shakeAnimation(AnimationController controller,
        {int times = 2}) async {
      for (int i = 0; i < times; i++) {
        await controller.forward();
        await controller.reverse();
      }
    }

    Future<void> translateWord(int ticket) async {
      if (ticket <= 0) {
        if (!context.mounted) return;
        MySimpleDialog.show(
            context,
            const Row(
              children: [
                Text('No Ticket ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    )),
                Icon(Icons.sentiment_very_dissatisfied_rounded, size: 36)
              ],
            ),
            'OK', () {
          //
        });
        return;
      }
      if (originalWordController.text == "") {
        originalColor.value = MyTheme.red;
        await shakeAnimation(originalAnimationController);
        originalColor.value = MyTheme.lemon;
        return;
      }
      isLoading.value = true;
      animationController.forward();
      translatedController.text = "";
      exampleController.text = "";
      exampleTranslatedController.text = "";

      FocusScope.of(context).unfocus();
      focusNode.unfocus();
      try {
        final res = await TranslateApi.postRequest(
            originalWordController.text,
            originalLanguage.value.lowerString,
            translateLanguage.value.lowerString);
        final translatedModel = TranslatedApiResponse.fromJson(res);

        if (translatedModel.type == TranslatedResponseType.suggestion) {
          if (!context.mounted) return;
          await TwoWayDialog.show(
              context,
              'Maybe...this word?',
              RiveAnimatedIcon(
                  riveIcon: RiveIcon.graduate,
                  width: 70,
                  height: 70,
                  color: Colors.white,
                  loopAnimation: true,
                  onTap: () {},
                  onHover: (value) {}),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 1, left: 4),
                    child: bodyText('Input Original', Colors.grey.shade400),
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        originalWordController.text,
                        style: TextStyle(
                            fontSize: 30, color: Colors.grey.shade400),
                        minFontSize: 16,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 1, left: 4),
                    child: bodyText('Suggest Original', Colors.white),
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        translatedModel.original,
                        style:
                            const TextStyle(fontSize: 30, color: Colors.black),
                        minFontSize: 16,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 1, left: 4),
                    child: bodyText('Translated', Colors.white),
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        translatedModel.translated[0],
                        style:
                            const TextStyle(fontSize: 30, color: Colors.black),
                        minFontSize: 16,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
              leftButtonText: 'No',
              rightButtonText: 'Yes', onLeftButtonPressed: () {
            //
          }, onRightButtonPressed: () async {
            await ticketNotifier.useTicket();

            originalWordController.text = translatedModel.original;
            translatedController.text =
                "${translatedModel.translated[0]}, ${translatedModel.translated[1]}, ${translatedModel.translated[2]}";
            exampleController.text = translatedModel.example;
            exampleTranslatedController.text =
                translatedModel.exampleTranslated;
          });
        } else {
          await ticketNotifier.useTicket();
          originalWordController.text = translatedModel.original;
          translatedController.text =
              "${translatedModel.translated[0]}, ${translatedModel.translated[1]}, ${translatedModel.translated[2]}";
          exampleController.text = translatedModel.example;
          exampleTranslatedController.text = translatedModel.exampleTranslated;
        }
      } catch (e) {
        if (!context.mounted) return;
        MySimpleDialog.show(
            context,
            const Text('Failed to translate!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                )),
            'OK', () {
          //
        });
      } finally {
        isLoading.value = false;
        animationController.reverse();
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
        originalLang: originalLanguage.value,
        translatedLang: translateLanguage.value,
      );

      String? result = await SqfliteRepository.instance.insertData(newWord);
      if (result == 'exist') {
        if (!context.mounted) return;
        await MySimpleDialog.show(
            context,
            Text('"${originalWordController.text}" is\nalready registered.',
                style: const TextStyle(
                    overflow: TextOverflow.clip,
                    color: Colors.white,
                    fontSize: 24)),
            'OK', () {
          //
        });
      } else {
        if (context.mounted) {
          context.pop();
        }
      }
    }

    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) => IgnorePointer(
            ignoring: isLoading.value,
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(children: [
                  isLoading.value
                      ? _buildLoading(h, w)
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
                                                            _buildTopTitle(
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
                                                                    final rowWidth =
                                                                        constraints
                                                                            .maxWidth;
                                                                    return Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        LanguageDropdownVertical(
                                                                          originalLanguage:
                                                                              originalLanguage.value,
                                                                          translateLanguage:
                                                                              translateLanguage.value,
                                                                          onOriginalSelected:
                                                                              (TranslateLanguage value) {
                                                                            originalLanguage.value =
                                                                                value;
                                                                          },
                                                                          onTranslateSelected:
                                                                              (TranslateLanguage value) {
                                                                            translateLanguage.value =
                                                                                value;
                                                                          },
                                                                        ),
                                                                        TranslateButton(
                                                                            width: rowWidth -
                                                                                185, // 185: 左からの距離
                                                                            isEnable:
                                                                                ticket != 0 && originalWordController.text != "",
                                                                            onPressed: () {
                                                                              HapticFeedback.lightImpact();
                                                                              translateWord(ticket);
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
                                                  Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: Container(
                                                          width:
                                                              double.infinity,
                                                          height: 90 +
                                                              MediaQuery.of(
                                                                      context)
                                                                  .padding
                                                                  .bottom,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .blueGrey
                                                                .shade800,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.3),
                                                                offset:
                                                                    const Offset(
                                                                        0, -2),
                                                                blurRadius: 7,
                                                              ),
                                                            ],
                                                          ),
                                                          child: SafeArea(
                                                            child: Center(
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        28),
                                                                child: LayoutBuilder(
                                                                    builder:
                                                                        (context,
                                                                            constraints) {
                                                                  const widthRate =
                                                                      [5, 1, 8];
                                                                  final cancelWidth = constraints
                                                                          .maxWidth *
                                                                      widthRate[
                                                                          0] /
                                                                      widthRate.reduce(
                                                                          (a, b) =>
                                                                              a +
                                                                              b);
                                                                  final spaceWidth = constraints
                                                                          .maxWidth *
                                                                      widthRate[
                                                                          1] /
                                                                      widthRate.reduce(
                                                                          (a, b) =>
                                                                              a +
                                                                              b);
                                                                  final saveWidth = constraints
                                                                          .maxWidth *
                                                                      widthRate[
                                                                          2] /
                                                                      widthRate.reduce(
                                                                          (a, b) =>
                                                                              a +
                                                                              b);
                                                                  return Row(
                                                                    children: [
                                                                      KatiButton(
                                                                        onPressed:
                                                                            () {
                                                                          HapticFeedback
                                                                              .lightImpact();
                                                                          context
                                                                              .pop();
                                                                        },
                                                                        width:
                                                                            cancelWidth,
                                                                        height:
                                                                            65,
                                                                        elevation:
                                                                            8,
                                                                        buttonRadius:
                                                                            12,
                                                                        stageOffset:
                                                                            5,
                                                                        inclinationRate:
                                                                            0.9,
                                                                        buttonColor: Colors
                                                                            .grey
                                                                            .shade300,
                                                                        stageColor: Colors
                                                                            .blueGrey
                                                                            .shade600,
                                                                        stagePointColor: Colors
                                                                            .blueGrey
                                                                            .shade500,
                                                                        edgeLineColor: Colors
                                                                            .grey
                                                                            .shade100,
                                                                        edgeBorder: Border.all(
                                                                            color:
                                                                                Colors.white.withOpacity(0.5),
                                                                            width: 0.8),
                                                                        child:
                                                                            Align(
                                                                          alignment: const Alignment(
                                                                              0.5,
                                                                              0.85),
                                                                          child:
                                                                              Transform(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            transform:
                                                                                Matrix4.rotationX(0.5),
                                                                            child:
                                                                                Text(
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
                                                                      SizedBox(
                                                                          width:
                                                                              spaceWidth),
                                                                      KatiButton(
                                                                        onPressed:
                                                                            () async {
                                                                          HapticFeedback
                                                                              .lightImpact();
                                                                          await saveWord();
                                                                        },
                                                                        width:
                                                                            saveWidth,
                                                                        height:
                                                                            65,
                                                                        elevation:
                                                                            8,
                                                                        buttonRadius:
                                                                            12,
                                                                        stageOffset:
                                                                            5,
                                                                        inclinationRate:
                                                                            0.9,
                                                                        edgeLineColor: Colors
                                                                            .orange
                                                                            .shade300,
                                                                        buttonColor:
                                                                            MyTheme.orange,
                                                                        stageColor: Colors
                                                                            .blueGrey
                                                                            .shade600,
                                                                        stagePointColor: Colors
                                                                            .blueGrey
                                                                            .shade500,
                                                                        edgeBorder: Border.all(
                                                                            color:
                                                                                Colors.white.withOpacity(0.5),
                                                                            width: 0.8),
                                                                        child:
                                                                            Align(
                                                                          alignment: const Alignment(
                                                                              0.8,
                                                                              0.8),
                                                                          child:
                                                                              Transform(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            transform:
                                                                                Matrix4.rotationX(0.5),
                                                                            child:
                                                                                Text(
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
                                                          )))
                                                ])))))
                          ])))
                ]))));
  }

  Widget _buildLoading(double h, double w) {
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

  Widget _buildTopTitle(BuildContext context, int ticket) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TicketWidget(
            count: ticket,
            size: 65,
            isEnableUseAnimation: true,
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
}

class TranslateButton extends StatefulWidget {
  final double width;
  final bool isEnable;
  final Function onPressed;

  const TranslateButton(
      {Key? key,
      required this.onPressed,
      required this.isEnable,
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
        if (!widget.isEnable) return;
        await animationController.forward();
        animationController.reset();
      },
      width: widget.width.clamp(50, 200),
      height: 85,
      elevation: 9,
      buttonRadius: 16,
      stageOffset: 6,
      inclinationRate: 0.8,
      pushedElevationLevel: widget.isEnable ? 0.7 : 0.2,
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