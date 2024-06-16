import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';
import 'package:worbbing/application/api/translate_api.dart';
import 'package:worbbing/application/usecase/ticket_manager.dart';
import 'package:worbbing/models/translate_language.dart';
import 'package:worbbing/models/translated_response.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_button.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/language_dropdown.dart';
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
      await TicketManager.useTicket();
      if (translatedModel.type == TranslatedResponseType.suggestion) {
        if (!mounted) return;
        await TwoWayDialog.show(
            context,
            'Maybe...',
            RiveAnimatedIcon(
                riveIcon: RiveIcon.graduate,
                width: 70,
                height: 70,
                color: Colors.black,
                loopAnimation: true,
                onTap: () {},
                onHover: (value) {}),
            Row(
              children: [
                Center(
                    child: Icon(Icons.arrow_downward_rounded,
                        size: 40, color: MyTheme.grey)),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 6),
                        child: AutoSizeText(
                          translatedModel.original,
                          style: const TextStyle(
                              fontSize: 30, color: Colors.black),
                          minFontSize: 16,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        child: AutoSizeText(
                          translatedModel.translated[0],
                          style: const TextStyle(
                              fontSize: 30, color: Colors.black),
                          minFontSize: 16,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
            'No',
            'Yes', () {
          //
        }, () {
          _originalWordController.text = translatedModel.original;
          _translatedController.text =
              "${translatedModel.translated[0]}, ${translatedModel.translated[1]}, ${translatedModel.translated[2]}";
          _exampleController.text = translatedModel.example;
          _exampleTranslatedController.text = translatedModel.exampleTranslated;
        });
      } else {
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
      builder: (context, child) => GestureDetector(
        onTap: () {
          if (isLoading) return;
          Navigator.of(context).pop();
        },
        child: Container(
          width: w,
          height: double.infinity,
          color: Colors.transparent,
          child: Stack(
            // fit: StackFit.expand,
            children: [
              isLoading
                  ? Center(
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Lottie.asset('assets/lottie/w_loading.json'),
                      ),
                    )
                  : const SizedBox.shrink(),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: h * 0.9 * (1 - _animation.value),
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },

                    /// TestField focus 時にfocusに合わせて上下の位置を調整してくれる（キーボードで隠れない）のでScaffoldを使っている
                    child: Stack(
                      children: [
                        Center(
                          child: Scaffold(
                            body: IgnorePointer(
                              ignoring: isLoading,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: w,
                                  padding: const EdgeInsets.only(
                                    top: 12,
                                    bottom: 0,
                                  ),
                                  constraints:
                                      const BoxConstraints(maxWidth: 400),
                                  decoration: BoxDecoration(
                                    color: MyTheme.grey,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: SizedBox(
                                                  height: 60,
                                                  // color: Colors.green,
                                                  child: Stack(
                                                    fit: StackFit.expand,
                                                    children: [
                                                      Positioned(
                                                        top: 0,
                                                        right: -10,
                                                        child: IconButton(
                                                          onPressed: () {
                                                            HapticFeedback
                                                                .lightImpact();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          icon: Icon(
                                                              Icons
                                                                  .cancel_rounded,
                                                              size: 46,
                                                              color: MyTheme
                                                                  .orange),
                                                        ),
                                                      ),
                                                      const Center(
                                                        child: Text(
                                                          'Registration',
                                                          style: TextStyle(
                                                              fontSize: 32,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Align(
                                              alignment:
                                                  const Alignment(-0.95, 0.0),
                                              child: bodyText('Original',
                                                  MyTheme.lightGrey)),
                                          customTextField(
                                              _originalWordController,
                                              MyTheme.lemon,
                                              focusNode: _focusNode,
                                              isInput: true,
                                              isEnglish: true),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              LanguageDropdownWidget(
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
                                                  FutureBuilder<int>(
                                                      future: loadTicket(),
                                                      builder:
                                                          (context, snapshot) {
                                                        return TicketWidget(
                                                            count:
                                                                snapshot.data ??
                                                                    0,
                                                            size: 50);
                                                      }),
                                                  InkWell(
                                                    onTap: () {
                                                      HapticFeedback
                                                          .lightImpact();
                                                      translateWord();
                                                    },
                                                    child: Image.asset(
                                                        'assets/images/translate.png',
                                                        width: 100,
                                                        height: 100),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Align(
                                              alignment:
                                                  const Alignment(-0.95, 0.0),
                                              child: bodyText('Translated',
                                                  MyTheme.lightGrey)),
                                          customTextField(_translatedController,
                                              MyTheme.lemon,
                                              isEnglish: false),
                                          const SizedBox(height: 16),
                                          Align(
                                              alignment:
                                                  const Alignment(-0.95, 0.0),
                                              child: bodyText('Example',
                                                  MyTheme.lightGrey)),
                                          customTextField(_exampleController,
                                              MyTheme.orange,
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
                              height: 120,
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
                              // alignment: Alignment.bottomCenter,
                              child: SafeArea(
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      customButton(
                                          Colors.grey.shade400,
                                          Text('CANCEL',
                                              style: TextStyle(
                                                  color: Colors.grey.shade800,
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold)),
                                          () {
                                        Navigator.of(context).pop();
                                      }),
                                      customButton(
                                          MyTheme.orange,
                                          Text('SAVE',
                                              style: TextStyle(
                                                  color: Colors.grey.shade800,
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold)),
                                          () async {
                                        await saveWord();
                                      }),
                                    ],
                                  ),
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customTextField(controller, color,
      {FocusNode? focusNode,
      bool isInput = false,
      int lines = 1,
      required bool isEnglish}) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      return Stack(
        children: [
          Transform.translate(
            offset: const Offset(6, 6),
            child: Transform.rotate(
                angle: 0.02,
                child: Container(
                    width: width - 10, height: 70.0 * lines, color: color)),
          ),
          Container(
            width: width - 10,
            height: 70.0 * lines,
            color: Colors.white,
            child: TextField(
                focusNode: focusNode,
                maxLength: isInput ? 20 : null,
                maxLines: lines,
                keyboardType: isEnglish
                    ? TextInputType.visiblePassword
                    : TextInputType.text,
                decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.only(
                        top: 14, bottom: isInput ? 0 : 4, left: 8, right: 8),
                    border: InputBorder.none),
                textAlign: TextAlign.center,
                controller: controller,
                style: TextStyle(
                  fontSize: isInput ? 30 : 24,
                  color: Colors.black,
                )),
          )
        ],
      );
    });
  }
}
