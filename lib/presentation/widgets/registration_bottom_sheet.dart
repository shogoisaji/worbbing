import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';
import 'package:worbbing/application/api/translate_api.dart';
import 'package:worbbing/application/usecase/ticket_manager.dart';
import 'package:worbbing/models/translate_language.dart';
import 'package:worbbing/models/translated_response.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/kati_button.dart';
import 'package:worbbing/presentation/widgets/language_dropdown_vertical.dart';
import 'package:worbbing/presentation/widgets/my_simple_dialog.dart';
import 'package:worbbing/presentation/widgets/ticket_widget.dart';
import 'package:worbbing/presentation/widgets/two_way_dialog.dart';
import 'package:worbbing/repository/sqflite_repository.dart';
import 'package:lottie/lottie.dart';
import 'package:auto_size_text/auto_size_text.dart';

class RegistrationBottomSheet extends StatefulWidget {
  final TranslateLanguage initialOriginalLang;
  final TranslateLanguage initialTranslateLang;
  const RegistrationBottomSheet(
      {super.key,
      required this.initialOriginalLang,
      required this.initialTranslateLang});

  @override
  State<RegistrationBottomSheet> createState() =>
      _RegistrationBottomSheetState();
}

class _RegistrationBottomSheetState extends State<RegistrationBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  final TextEditingController _originalWordController = TextEditingController();
  final TextEditingController _translatedController = TextEditingController();
  final TextEditingController _exampleController = TextEditingController();
  final TextEditingController _exampleTranslatedController =
      TextEditingController();
  final FocusNode _focusNode = FocusNode();
  TranslateLanguage originalLanguage = TranslateLanguage.english;
  TranslateLanguage translateLanguage = TranslateLanguage.japanese;

  int ticket = 0;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _focusNode.requestFocus();
    originalLanguage = widget.initialOriginalLang;
    translateLanguage = widget.initialTranslateLang;
  }

  Future<void> translateWord() async {
    if (_originalWordController.text == "") return;
    if (ticket <= 0) {
      if (!mounted) return;
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
    setState(() {
      isLoading = true;
    });
    _animationController.forward();
    _translatedController.text = "";
    _exampleController.text = "";
    _exampleTranslatedController.text = "";

    /// focus を外す
    FocusScope.of(context).unfocus();
    _focusNode.unfocus();
    try {
      final res = await TranslateApi.postRequest(_originalWordController.text,
          originalLanguage.lowerString, translateLanguage.lowerString);
      final translatedModel = TranslatedResponse.fromJson(res);

      // / dialog test用
      // final translatedModel = TranslatedResponse(
      //     original: _originalWordController.text,
      //     type: TranslatedResponseType.suggestion,
      //     originalLang: originalLanguage,
      //     translateLang: translateLanguage,
      //     translated: ['translated', 'translated', 'translated'],
      //     example: 'example',
      //     exampleTranslated: 'exampleTranslated');
      if (translatedModel.type == TranslatedResponseType.suggestion) {
        if (!mounted) return;
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
                    // color: Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AutoSizeText(
                      _originalWordController.text,
                      style:
                          TextStyle(fontSize: 30, color: Colors.grey.shade400),
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
                      style: const TextStyle(fontSize: 30, color: Colors.black),
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
                      style: const TextStyle(fontSize: 30, color: Colors.black),
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
          await TicketManager.useTicket();

          _originalWordController.text = translatedModel.original;
          _translatedController.text =
              "${translatedModel.translated[0]}, ${translatedModel.translated[1]}, ${translatedModel.translated[2]}";
          _exampleController.text = translatedModel.example;
          _exampleTranslatedController.text = translatedModel.exampleTranslated;
        });
      } else {
        await TicketManager.useTicket();
        _originalWordController.text = translatedModel.original;
        _translatedController.text =
            "${translatedModel.translated[0]}, ${translatedModel.translated[1]}, ${translatedModel.translated[2]}";
        _exampleController.text = translatedModel.example;
        _exampleTranslatedController.text = translatedModel.exampleTranslated;
      }
    } catch (e) {
      if (!mounted) return;
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
      setState(() {
        isLoading = false;
        _animationController.reverse();
      });
    }
  }

  Future<int> loadTicket() async {
    final loadedTicket = await TicketManager.loadTicket();
    setState(() {
      ticket = loadedTicket;
    });
    return loadedTicket;
  }

  Future<void> saveWord() async {
    /// validation
    if (_originalWordController.text == "" ||
        _translatedController.text == "") {
      MySimpleDialog.show(
          context,
          const Text('Original & Translated\nare required fields',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              )),
          'OK', () {
        //
      });
      return;
    }
    final newWord = WordModel.createNewWord(
      originalWord: _originalWordController.text,
      translatedWord: _translatedController.text,
      example: _exampleController.text,
      exampleTranslated: _exampleTranslatedController.text,
      originalLang: originalLanguage,
      translatedLang: translateLanguage,
    );

    /// save sqflite
    String? result = await SqfliteRepository.instance.insertData(newWord);
    if (result == 'exist') {
      if (!mounted) return;
      await MySimpleDialog.show(
          context,
          Text('"${_originalWordController.text}" is\nalready registered.',
              style: const TextStyle(
                  overflow: TextOverflow.clip,
                  color: Colors.white,
                  fontSize: 24)),
          'OK', () {
        //
      });
    } else {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    _originalWordController.dispose();
    _translatedController.dispose();
    _exampleController.dispose();
    _exampleTranslatedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => IgnorePointer(
        ignoring: isLoading,
        child: SizedBox(
          width: w.clamp(300, 500),
          height: double.infinity,
          child: Stack(
            children: [
              isLoading
                  ? Center(
                      child: SizedBox(
                        width: 170,
                        height: 170,
                        child: Lottie.asset(
                          'assets/lottie/w_loading.json',
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              Stack(
                fit: StackFit.expand,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: SizedBox(
                        /// sheetが下がるアニメーション
                        height: h * 0.9 * (1 - _animation.value),
                        child: Scaffold(
                          backgroundColor: Colors.transparent,
                          body: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: w,
                              padding: const EdgeInsets.only(
                                top: 12,
                                bottom: 0,
                              ),
                              decoration: BoxDecoration(
                                color: MyTheme.grey,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          FutureBuilder<int>(
                                              future: loadTicket(),
                                              builder: (context, snapshot) {
                                                return TicketWidget(
                                                    count: snapshot.data ?? 0,
                                                    size: 65,
                                                    isEnableUseAnimation: true);
                                              }),
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
                                              Navigator.of(context).pop();
                                            },
                                            child: Icon(Icons.cancel_rounded,
                                                size: 46,
                                                color: MyTheme.orange),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32),
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 10),
                                          Align(
                                              alignment:
                                                  const Alignment(-0.95, 0.0),
                                              child: bodyText('Original',
                                                  MyTheme.lightGrey)),
                                          customTextField(
                                              _originalWordController,
                                              MyTheme.lemon,
                                              focusNode: _focusNode,
                                              isOriginalInput: true,
                                              isEnglish: true),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              LanguageDropdownVertical(
                                                originalLanguage:
                                                    originalLanguage,
                                                translateLanguage:
                                                    translateLanguage,
                                                onOriginalSelected:
                                                    (TranslateLanguage value) {
                                                  originalLanguage = value;
                                                },
                                                onTranslateSelected:
                                                    (TranslateLanguage value) {
                                                  translateLanguage = value;
                                                },
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Opacity(
                                                    opacity:
                                                        ticket == 0 ? 0.5 : 1,
                                                    child: TranslateButton(
                                                        isEnable: ticket != 0 &&
                                                            _originalWordController
                                                                    .text !=
                                                                "",
                                                        onPressed: () {
                                                          if (ticket == 0) {
                                                            // TODO: チケットがない場合の処理
                                                            return;
                                                          }
                                                          if (_originalWordController
                                                                  .text ==
                                                              "") {
                                                            return;
                                                          }
                                                          HapticFeedback
                                                              .lightImpact();
                                                          translateWord();
                                                        }),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Align(
                                              alignment:
                                                  const Alignment(-0.95, 0.0),
                                              child: bodyText('Translated',
                                                  MyTheme.lightGrey)),
                                          customTextField(_translatedController,
                                              MyTheme.orange,
                                              isEnglish: false),
                                          const SizedBox(height: 16),
                                          Align(
                                              alignment:
                                                  const Alignment(-0.95, 0.0),
                                              child: bodyText('Example',
                                                  MyTheme.lightGrey)),
                                          customTextField(
                                              _exampleController, MyTheme.lemon,
                                              lines: 2, isEnglish: true),
                                          const SizedBox(height: 16),
                                          Align(
                                              alignment:
                                                  const Alignment(-0.95, 0.0),
                                              child: bodyText(
                                                  'Translated Example',
                                                  MyTheme.lightGrey)),
                                          customTextField(
                                              _exampleTranslatedController,
                                              MyTheme.orange,
                                              lines: 2,
                                              isEnglish: false),
                                          const SizedBox(height: 200),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 28),
                              child: LayoutBuilder(
                                  builder: (context, constraints) {
                                const spaceWidth = 26.0;
                                const cancelWidth = 140.0;
                                final saveWidth = constraints.maxWidth -
                                    cancelWidth -
                                    spaceWidth;
                                return Row(
                                  children: [
                                    KatiButton(
                                      onPressed: () {
                                        HapticFeedback.lightImpact();
                                        Navigator.of(context).pop();
                                      },
                                      width: cancelWidth,
                                      height: 65,
                                      elevation: 8,
                                      buttonRadius: 12,
                                      stageOffset: 5,
                                      pushedElevationLevel: 0.8,
                                      inclinationRate: 0.9,
                                      buttonColor: Colors.grey.shade300,
                                      stageColor: Colors.blueGrey.shade600,
                                      stagePointColor: Colors.blueGrey.shade500,
                                      edgeLineColor: Colors.grey.shade100,
                                      edgeBorder: Border.all(
                                          color: Colors.white.withOpacity(0.5),
                                          width: 0.8),
                                      duration:
                                          const Duration(milliseconds: 200),
                                      child: Align(
                                        alignment: const Alignment(0.5, 0.8),
                                        child: Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.rotationX(0.5),
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontSize: 27,
                                              color: MyTheme.greyForOrange,
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                BoxShadow(
                                                  color: Colors.grey.shade800,
                                                  blurRadius: 1.0,
                                                  offset: const Offset(0, -1.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: spaceWidth),
                                    KatiButton(
                                      onPressed: () async {
                                        HapticFeedback.lightImpact();
                                        await saveWord();
                                      },
                                      width: saveWidth,
                                      height: 65,
                                      elevation: 8,
                                      buttonRadius: 12,
                                      stageOffset: 5,
                                      pushedElevationLevel: 0.8,
                                      inclinationRate: 0.9,
                                      edgeLineColor: Colors.orange.shade300,
                                      buttonColor: MyTheme.orange,
                                      stageColor: Colors.blueGrey.shade600,
                                      stagePointColor: Colors.blueGrey.shade500,
                                      edgeBorder: Border.all(
                                          color: Colors.white.withOpacity(0.5),
                                          width: 0.8),
                                      duration:
                                          const Duration(milliseconds: 200),
                                      child: Align(
                                        alignment: const Alignment(0.8, 0.8),
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
                                                  offset: const Offset(0, -1.0),
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
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customTextField(controller, color,
      {FocusNode? focusNode,
      bool isOriginalInput = false,
      int lines = 1,
      required bool isEnglish}) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      return Stack(
        children: [
          Transform.translate(
            offset: const Offset(6, 6),
            child: Transform.rotate(
                angle: 0.011,
                child: Container(
                  width: width - 10,
                  height: 70.0 * lines,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(color: color, width: 1.5),
                  ),
                )),
          ),
          GradientBorderContainer(
            width: width - 10,
            height: 70.0 * lines,
            bgColor: MyTheme.grey,
            borderColor: color,
            child: TextField(
                focusNode: focusNode,
                cursorColor: Colors.grey.shade100,
                maxLength: isOriginalInput ? 20 : null,
                maxLines: lines,
                keyboardType: isEnglish
                    ? TextInputType.visiblePassword
                    : TextInputType.text,
                decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.only(
                        top: isOriginalInput ? 8 : 14, left: 8, right: 8),
                    border: InputBorder.none),
                textAlign: TextAlign.center,
                controller: controller,
                style: TextStyle(
                  fontSize: isOriginalInput ? 30 : 24,
                  color: Colors.grey.shade100,
                  fontFamily: 'SawarabiGothic',
                )),
          )
        ],
      );
    });
  }
}

class GradientBorderContainer extends StatelessWidget {
  final Widget child;
  final Color bgColor;
  final Color borderColor;
  final double borderWidth;
  final double width;
  final double height;
  final double borderRadius;

  const GradientBorderContainer(
      {Key? key,
      required this.child,
      required this.borderColor,
      required this.width,
      required this.height,
      this.borderWidth = 1.5,
      this.borderRadius = 2.0,
      required this.bgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(
            color: borderColor,
          ),
          Container(
            padding: EdgeInsets.all(borderWidth),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: RadialGradient(
                colors: [Colors.white.withOpacity(0.8), Colors.transparent],
                center: const Alignment(0.0, -0.5),
                radius: width / 200,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(borderRadius - borderWidth),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class TranslateButton extends StatefulWidget {
  final bool isEnable;
  final Function onPressed;

  const TranslateButton(
      {Key? key, required this.onPressed, required this.isEnable})
      : super(key: key);

  @override
  State<TranslateButton> createState() => _TranslateButtonState();
}

class _TranslateButtonState extends State<TranslateButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  OverlayEntry? _overlayEntry;
  final GlobalKey _widgetKey = GlobalKey();

  void _showOverlay(BuildContext context) {
    final currentContext = _widgetKey.currentContext;
    if (currentContext == null) return;

    final RenderBox renderBox = currentContext.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
              top: position.dy,
              left: position.dx,
              child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: 1 - _animationController.value,
                      child: Transform.scale(
                        scale: 1 + 0.5 * _animationController.value,
                        child: Material(
                          color: Colors.transparent,
                          child: _buildKatiButton(),
                        ),
                      ),
                    );
                  }),
            ));
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400));
      _animationController.addStatusListener((status) {
        if (status == AnimationStatus.forward) {
          _showOverlay(context);
        } else if (status == AnimationStatus.completed) {
          _removeOverlay();
        } else {
          _removeOverlay();
        }
      });
    });
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildKatiButton(key: _widgetKey);
  }

  Widget _buildKatiButton({Key? key}) {
    return KatiButton(
      key: key,
      onPressed: () {
        widget.onPressed();
        if (!widget.isEnable) return;
        _animationController.reset();
        _animationController.forward();
      },
      width: 150,
      height: 80,
      elevation: 10,
      buttonRadius: 16,
      stageOffset: 6,
      pushedElevationLevel: widget.isEnable ? 0.8 : 0.2,
      stageColor: Colors.blueGrey.shade700,
      buttonColor: Colors.grey.shade400,
      stagePointColor: Colors.blueGrey.shade400,
      edgeLineColor: Colors.blue.shade100.withOpacity(0.5),
      edgeBorder: Border.all(color: Colors.white.withOpacity(0.5), width: 0.8),
      duration: const Duration(milliseconds: 200),
      bgWidget:
          Lottie.asset(fit: BoxFit.cover, 'assets/lottie/move_gradient.json'),
      child: Stack(
        children: [
          Align(
            alignment: const Alignment(0.7, -0.9),
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
            alignment: const Alignment(0.4, 0.8),
            child: Transform(
              transform: Matrix4.rotationX((1 - 0.8) * 1.5),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: AutoSizeText(
                  'Translate',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
