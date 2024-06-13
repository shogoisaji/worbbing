import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';
import 'package:worbbing/application/api/translate_api.dart';
import 'package:worbbing/models/translate_language.dart';
import 'package:worbbing/models/translated_response.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_button.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/language_dropdown.dart';
import 'package:worbbing/presentation/widgets/two_way_dialog.dart';
import 'package:worbbing/repository/sqflite_repository.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  // Future<List<TranslateLanguage>> loadPreferences() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final loadedOriginalString = prefs.getString("original_lang") ?? "english";
  //   final loadedTranslateString =
  //       prefs.getString("translate_lang") ?? "japanese";
  //   final original = TranslateLanguage.values
  //       .firstWhere((e) => e.lowerString == loadedOriginalString);
  //   final translate = TranslateLanguage.values
  //       .firstWhere((e) => e.lowerString == loadedTranslateString);
  //   setState(() {
  //     originalLanguage = original;
  //     translateLanguage = translate;
  //   });
  //   return [original, translate];
  // }

  Future<void> translateWord() async {
    if (_originalWordController.text == "") return;
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
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/a.svg',
                      width: 30,
                      height: 30,
                      colorFilter: ColorFilter.mode(
                          Colors.grey.shade800, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 6),
                        child: AutoSizeText(
                          translatedModel.original,
                          style: const TextStyle(fontSize: 30),
                          minFontSize: 16,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/a_j.svg',
                      width: 30,
                      height: 30,
                      colorFilter: ColorFilter.mode(
                          Colors.grey.shade800, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        child: AutoSizeText(
                          translatedModel.translated[0],
                          style: const TextStyle(fontSize: 30),
                          minFontSize: 16,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
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
      debugPrint('error:$e');
    } finally {
      setState(() {
        isLoading = false;
        _animationController.reverse();
      });
    }
  }

  // Future<List<TranslatedResponse>> translateWithGemini(String inputWord) async {
  //   await TranslateApi.postRequest(inputWord);
  //   final gemini = Gemini();
  //   final translatedResponseList =
  //       await gemini.translateWithGemini(inputWord).catchError((e) {
  //     throw Exception('error:$e');
  //   });
  //   return translatedResponseList;
  // }

  Future<void> saveWord() async {
    /// validation
    if (_originalWordController.text == "" ||
        _translatedController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade400,
          content: const Center(
            child: Text('Original & Translated は入力必須です',
                style: TextStyle(fontSize: 18)),
          ),
        ),
      );
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

      showDialog(
          context: context,
          builder: (BuildContext context2) =>
              // deleteDialog(context, widget.id),
              AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero),
                backgroundColor: MyTheme.grey,
                title: Text(
                  '"${_originalWordController.text}" is\nalready registered.',
                  style: const TextStyle(
                      overflow: TextOverflow.clip,
                      color: Colors.white,
                      fontSize: 24),
                ),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(
                          left: 12, right: 12, bottom: 4, top: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                      backgroundColor: MyTheme.lemon,
                    ),
                    onPressed: () async {
                      //
                    },
                    child: subText('OK', Colors.black),
                  ),
                ],
              ));
    }
    if (mounted) {
      Navigator.of(context).pop();
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
          height: h,
          color: Colors.transparent,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Lottie.asset('assets/lottie/w_loading.json'),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: h * 0.9 * (1 - _animation.value),
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Scaffold(
                      body: IgnorePointer(
                        ignoring: isLoading,
                        child: Container(
                          width: w,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 32),
                          constraints: const BoxConstraints(maxWidth: 400),
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
                                                  HapticFeedback.lightImpact();
                                                  Navigator.of(context).pop();
                                                },
                                                icon: Icon(Icons.cancel_rounded,
                                                    size: 46,
                                                    color: MyTheme.orange),
                                              ),
                                            ),
                                            const Center(
                                              child: Text(
                                                'Registration',
                                                style: TextStyle(
                                                    fontSize: 32,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                    alignment: const Alignment(-0.95, 0.0),
                                    child: bodyText(
                                        'Original', MyTheme.lightGrey)),
                                customTextField(
                                    _originalWordController, MyTheme.lemon,
                                    focusNode: _focusNode,
                                    isInput: true,
                                    isEnglish: true),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    LanguageDropdownWidget(
                                      originalLanguage: originalLanguage,
                                      translateLanguage: translateLanguage,
                                      onOriginalSelected:
                                          (TranslateLanguage value) {
                                        originalLanguage = value;
                                      },
                                      onTranslateSelected:
                                          (TranslateLanguage value) {
                                        translateLanguage = value;
                                      },
                                    ),
                                    InkWell(
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                        translateWord();
                                      },
                                      child: Image.asset(
                                          'assets/images/translate.png',
                                          width: 100,
                                          height: 100),
                                    ),
                                  ],
                                ),
                                Align(
                                    alignment: const Alignment(-0.95, 0.0),
                                    child: bodyText(
                                        'Translated', MyTheme.lightGrey)),
                                customTextField(
                                    _translatedController, MyTheme.lemon,
                                    isEnglish: false),
                                const SizedBox(height: 16),
                                Align(
                                    alignment: const Alignment(-0.95, 0.0),
                                    child:
                                        bodyText('Example', MyTheme.lightGrey)),
                                customTextField(
                                    _exampleController, MyTheme.orange,
                                    lines: 2, isEnglish: true),
                                const SizedBox(height: 16),
                                Align(
                                    alignment: const Alignment(-0.95, 0.0),
                                    child: bodyText('Translated Example',
                                        MyTheme.lightGrey)),
                                customTextField(_exampleTranslatedController,
                                    MyTheme.orange,
                                    lines: 2, isEnglish: false),
                                const SizedBox(height: 32),
                                customButton(
                                    Text('SAVE',
                                        style: TextStyle(
                                            color: Colors.grey.shade800,
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold)),
                                    () async {
                                  await saveWord();
                                }),
                                const SizedBox(height: 100),
                              ],
                            ),
                          ),
                        ),
                      ),
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
