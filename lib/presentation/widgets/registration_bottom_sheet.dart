import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:worbbing/application/api/translate_api.dart';
import 'package:worbbing/application/usecase/gemini_translate_usecase.dart';
import 'package:worbbing/models/translated_response.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_button.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/two_way_dialog.dart';
import 'package:worbbing/repository/sqflite_repository.dart';

class RegistrationBottomSheet extends StatefulWidget {
  const RegistrationBottomSheet({super.key});

  @override
  State<RegistrationBottomSheet> createState() =>
      _RegistrationBottomSheetState();
}

class _RegistrationBottomSheetState extends State<RegistrationBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  final TextEditingController _inputWordController = TextEditingController();
  final TextEditingController _translatedController = TextEditingController();
  final TextEditingController _exampleController = TextEditingController();
  final TextEditingController _exampleTranslatedController =
      TextEditingController();
  final FocusNode _focusNode = FocusNode();

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
  }

  Future<void> translateWord() async {
    if (_inputWordController.text == "") return;
    setState(() {
      isLoading = true;
    });
    _animationController.forward();

    /// focus を外す
    FocusScope.of(context).unfocus();
    try {
      final res = await TranslateApi.postRequest(_inputWordController.text);
      final translatedResponse = jsonDecode(res);
      final inputTranslatedModel =
          TranslatedResponse.fromJson(translatedResponse['input']);
      if (inputTranslatedModel.translated[0] == '-') {
        _translatedController.text = '-';
      } else {
        _translatedController.text =
            "${inputTranslatedModel.translated[0]}, ${inputTranslatedModel.translated[1]}, ${inputTranslatedModel.translated[2]}";
      }
      _exampleController.text = inputTranslatedModel.example;
      _exampleTranslatedController.text =
          inputTranslatedModel.exampleTranslated;
      if (translatedResponse['suggestion'] != null) {
        final suggestionTranslatedModel =
            TranslatedResponse.fromJson(translatedResponse['suggestion']);
        if (!mounted) return;
        TwoWayDialog.show(
            context,
            'もしかして',
            const Icon(Icons.check),
            "${suggestionTranslatedModel.original}\n${suggestionTranslatedModel.translated[0]}",
            'いいえ',
            'はい', () {
          //
        }, () {
          _inputWordController.text = suggestionTranslatedModel.original;
          _translatedController.text =
              "${suggestionTranslatedModel.translated[0]}, ${suggestionTranslatedModel.translated[1]}, ${suggestionTranslatedModel.translated[2]}";
          _exampleController.text = suggestionTranslatedModel.example;
          _exampleTranslatedController.text =
              suggestionTranslatedModel.exampleTranslated;
        });
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

  Future<List<TranslatedResponse>> translateWithGemini(String inputWord) async {
    final res = await TranslateApi.postRequest(inputWord);
    print('res:$res');
    final gemini = Gemini();
    final translatedResponseList =
        await gemini.translateWithGemini(inputWord).catchError((e) {
      throw Exception('error:$e');
    });
    return translatedResponseList;
  }

  Future<void> saveWord() async {
    /// validation
    if (_inputWordController.text == "" || _translatedController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade400,
          content: const Center(
            child:
                Text('English & 日本語 は入力必須です', style: TextStyle(fontSize: 18)),
          ),
        ),
      );
      return;
    }
    final newWord = WordModel.createNewWord(
      originalWord: _inputWordController.text,
      translatedWord: _translatedController.text,
      example: _exampleController.text,
      exampleTranslated: _exampleTranslatedController.text,
    );

    /// save sqflite
    String? result = await SqfliteRepository.instance.insertData(newWord);
    if (result == 'exist') {
      if (!mounted) return;
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero),
                backgroundColor: const Color.fromARGB(255, 206, 206, 206),
                title: subText('Already registered', Colors.black),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      backgroundColor: MyTheme.orange,
                    ),
                    onPressed: () {
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: subText('OK', Colors.white),
                  ),
                ],
              ));
      return;
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
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
              const Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(),
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
                                                  Navigator.of(context).pop();
                                                },
                                                icon: Icon(Icons.cancel_rounded,
                                                    size: 46,
                                                    color: MyTheme.orange),
                                              ),
                                            ),
                                            const Center(
                                              child: Text(
                                                '単語登録',
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
                                    child:
                                        bodyText('English', MyTheme.lightGrey)),
                                _customTextField(
                                    _inputWordController, MyTheme.lemon,
                                    focusNode: _focusNode,
                                    isInput: true,
                                    isEnglish: true),
                                IconButton(
                                    onPressed: () {
                                      translateWord();
                                    },
                                    icon: Icon(Icons.check,
                                        color: MyTheme.lemon)),
                                const SizedBox(height: 16),
                                Align(
                                    alignment: const Alignment(-0.95, 0.0),
                                    child: bodyText('日本語', MyTheme.lightGrey)),
                                _customTextField(
                                    _translatedController, MyTheme.lemon,
                                    isEnglish: false),
                                const SizedBox(height: 16),
                                Align(
                                    alignment: const Alignment(-0.95, 0.0),
                                    child: bodyText('例文', MyTheme.lightGrey)),
                                _customTextField(
                                    _exampleController, MyTheme.orange,
                                    lines: 2, isEnglish: true),
                                const SizedBox(height: 16),
                                Align(
                                    alignment: const Alignment(-0.95, 0.0),
                                    child: bodyText('例文翻訳', MyTheme.lightGrey)),
                                _customTextField(_exampleTranslatedController,
                                    MyTheme.orange,
                                    lines: 2, isEnglish: false),
                                const SizedBox(height: 32),
                                customButton(
                                    Text('SAVE',
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6),
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

  Widget _customTextField(controller, color,
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
