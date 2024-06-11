import 'package:flutter/material.dart';
import 'package:worbbing/application/usecase/gemini_translate_usecase.dart';
import 'package:worbbing/models/translated_response.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_button.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
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
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _focusNode.requestFocus();
  }

  Future<void> translateWord() async {
    if (_inputWordController.text == "") {
      return;
    }
    final translatedResponse =
        await translateWithGemini(_inputWordController.text);
    if (translatedResponse == null) return;
    print('translatedResponse:$translatedResponse');
    _translatedController.text = translatedResponse.translated[0];
    _exampleController.text = translatedResponse.example;
    _exampleTranslatedController.text = translatedResponse.exampleTranslated;
  }

  Future<TranslatedResponse?> translateWithGemini(String inputWord) async {
    final gemini = Gemini();
    final translatedResponse =
        await gemini.translateWithGemini(inputWord).catchError((e) {
      debugPrint('error:$e');
      return null;
    });
    return translatedResponse;
  }

  Future<void> saveWord() async {
    /// validation
    if (_inputWordController.text == "" || _translatedController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SizedBox(
        height: h * 0.85,
        child: Scaffold(
          body: Container(
            width: w,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
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
                  const Text(
                    '単語登録',
                    style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  _customTextField(_inputWordController, MyTheme.lemon,
                      focusNode: _focusNode, isInput: true),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            translateWord();
                          },
                          icon: Icon(Icons.check, color: MyTheme.lemon)),
                      const SizedBox(width: 16),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.close, color: MyTheme.lemon)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: bodyText('English', MyTheme.lightGrey)),
                  _customTextField(_translatedController, MyTheme.lemon),
                  const SizedBox(height: 16),
                  bodyText('English', MyTheme.lightGrey),
                  _customTextField(_exampleController, MyTheme.orange),
                  bodyText('English', MyTheme.lightGrey),
                  _customTextField(
                      _exampleTranslatedController, MyTheme.orange),
                  const SizedBox(height: 32),
                  customButton(
                      Text('SAVE',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 28,
                              fontWeight: FontWeight.bold)), () async {
                    await saveWord();
                  }),
                  const SizedBox(height: 300),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _customTextField(controller, color,
      {FocusNode? focusNode, bool isInput = false}) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      return Stack(
        children: [
          Transform.translate(
            offset: const Offset(6, 6),
            child: Transform.rotate(
                angle: 0.02,
                child: Container(width: width - 10, height: 70, color: color)),
          ),
          Container(
            width: width - 10,
            height: 70,
            color: Colors.white,
            child: TextField(
                focusNode: focusNode,
                maxLength: isInput ? 16 : null,
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(top: 14, bottom: 0),
                    border: InputBorder.none),
                textAlign: TextAlign.center,
                controller: controller,
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                )),
          )
        ],
      );
    });
  }
}
