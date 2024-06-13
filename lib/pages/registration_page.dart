import 'package:flutter/material.dart';
import 'package:worbbing/models/translate_language.dart';
import 'package:worbbing/models/translated_response.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/repository/sqflite_repository.dart';
import 'package:worbbing/pages/home_page.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_button.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/registration_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worbbing/application/usecase/gemini_translate_usecase.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({
    super.key,
  });

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _originalController = TextEditingController();
  final TextEditingController _translatedController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();
  int flag = 0;
  final int CREDIT = 20;
  late SharedPreferences prefs;
  DateTime resetDate = DateTime.now();
  int translateCredit = 0;
  bool googleResponse = false;
  String googleTranslateUrl =
      "https://translation.googleapis.com/language/translate/v2";

  @override
  void initState() {
    super.initState();
    initPrefs();
    _loadDate();
    // _originalController = TextEditingController();
    // _translatedController = TextEditingController();
    // _memoController = TextEditingController();
  }

  _loadDate() async {
    translateCredit = await checkResetCredit();
    debugPrint('translateCredit:$translateCredit');
    setState(() {});
  }

  @override
  void dispose() {
    _originalController.dispose();
    _translatedController.dispose();
    _memoController.dispose();

    super.dispose();
  }

// <shared preferences data list>
  // 'resetDate'
  // 'translateCredit'

// shared preferences init
  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

// shared preferences check credit
  Future<int> checkResetCredit() async {
    final prefs = await SharedPreferences.getInstance();
    DateTime today = DateTime.now();
    // have credit
    if (prefs.getString('resetDate') != null) {
      resetDate = DateTime.parse(prefs.getString('resetDate')!);
      debugPrint('resetDate:$resetDate');
      debugPrint('today    :$today');
      // already reset credit today
      if (today.difference(resetDate).inDays == 0) {
        debugPrint('already reset credit today');
        translateCredit = prefs.getInt('translateCredit') ?? 0;
        // reset credit
      } else {
        translateCredit = CREDIT;
        resetDate = today;
        prefs.setString('resetDate', today.toIso8601String());
        prefs.setInt('translateCredit', translateCredit);
        debugPrint('reset credit');
      }
      // init credit
    } else {
      translateCredit = CREDIT;
      resetDate = today;
      debugPrint('init credit');
      prefs.setString('resetDate', resetDate.toIso8601String());
      prefs.setInt('translateCredit', translateCredit);
    }
    return translateCredit;
  }

  // use credit
  Future<bool> useCredit() async {
    final prefs = await SharedPreferences.getInstance();
    translateCredit = prefs.getInt('translateCredit') ?? 0;
    if (translateCredit == 0) return false;
    translateCredit--;
    prefs.setInt('translateCredit', translateCredit);
    debugPrint('use credit:$translateCredit');
    return true;
  }

  Future<void> translateWord(String inputWord) async {
    final translatedResponse = await translateWithGemini(inputWord);
    if (translatedResponse == null) return;
    print('translatedResponse:$translatedResponse');
    _translatedController.text = translatedResponse.translated[0];
  }

  Future<TranslatedResponse?> translateWithGemini(String inputWord) async {
    final gemini = Gemini();
    final translatedResponse =
        await gemini.translateWithGemini(inputWord).catchError((e) {
      debugPrint('error:$e');
      return null;
    });
    return translatedResponse[0];
  }

  Future<void> saveWord() async {
    /// validation
    if (_originalController.text == "" || _translatedController.text == "") {
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
      originalWord: _originalController.text,
      translatedWord: _translatedController.text,
      originalLang: TranslateLanguage.english,
      translatedLang: TranslateLanguage.japanese,
      flag: flag != 0,
    );

    /// save sqflite
    String? result = await SqfliteRepository.instance.insertData(newWord);
    if (result == 'exist') {
      if (!context.mounted) return;
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
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 50,
            ),
            // title
            SizedBox(
              width: double.infinity,
              height: 80,
              child: Stack(
                children: [
                  Align(
                    alignment: const Alignment(-0.89, -0.1),
                    child: InkWell(
                        child: Image.asset(
                          'assets/images/custom_arrow.png',
                          width: 35,
                          height: 35,
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );
                        }),
                  ),
                  Align(
                    alignment: const Alignment(0.05, 0),
                    child: Image.asset(
                      'assets/images/registration.png',
                      width: 200,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 300,
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  // change flag state
                  setState(() {
                    if (flag == 0) {
                      flag = 1;
                    } else {
                      flag = 0;
                    }
                  });
                },
                icon: flag == 1
                    ? Icon(Icons.flag, size: 48, color: MyTheme.lemon)
                    : const Icon(Icons.flag_outlined,
                        size: 48, color: Colors.white24),
              ),
            ),
            SizedBox(
              width: 300,
              child: bodyText('English', MyTheme.lightGrey),
            ),
            originalTextField(_originalController),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    translateWord(_originalController.text);
                  },
                  child: Image.asset(
                    'assets/images/google_translate.png',
                    width: 50,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 30),
                  child: bodyText(translateCredit.toString(), MyTheme.grey),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  bodyText('日本語', MyTheme.lightGrey),
                  if (googleResponse)
                    bodyText('powered by Google 翻訳', MyTheme.grey),
                ],
              ),
            ),
            translatedTextField(_translatedController),
            const SizedBox(
              height: 40,
            ),
            Container(
              width: 300,
              alignment: Alignment.topLeft,
              child: bodyText('Memo', MyTheme.lightGrey),
            ),
            memoTextField(_memoController),
            const SizedBox(
              height: 50,
            ),
            customButton(
                Text('SAVE',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 28,
                        fontWeight: FontWeight.bold)), () async {
              await saveWord();
            }),
            const SizedBox(
              height: 70,
            )
          ]),
        ),
      ),
    );
  }
}
