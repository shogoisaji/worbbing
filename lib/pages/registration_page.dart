import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:worbbing/application/database.dart';
import 'package:worbbing/application/date_format.dart';
import 'package:worbbing/pages/main_page.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_button.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/registration_text_field.dart';
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _originalController = TextEditingController();
  TextEditingController _translatedController = TextEditingController();
  TextEditingController _memoController = TextEditingController();
  int flag = 0;
  bool googleResponse = false;
  bool deeplResponse = false;
  String deeplTranslateUrl = 'https://api-free.deepl.com/v2/translate';
  String googleTranslateUrl =
      "https://translation.googleapis.com/language/translate/v2";

  @override
  void initState() {
    super.initState();
    _originalController = TextEditingController();
    _translatedController = TextEditingController();
    _memoController = TextEditingController();
  }

  @override
  void dispose() {
    _originalController.dispose();
    _translatedController.dispose();
    _memoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int noticeDuration = 0;
    final int updateCount = 0;
    // final String originalWord = _originalController.text;
    // final String translatedWord = _translatedController.text;
    final String updateDate = getCurrentDate();
    final String registrationDate = getCurrentDate();
    // final String memo = _memoController.text;

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
                                builder: (context) => const MainPage()),
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
            InkWell(
              onTap: () async {
                http.Response response;
                if (_originalController.text.isEmpty) {
                  return;
                }
                await dotenv.load(fileName: ".env");
                final googleApiKey = dotenv.env['GOOGLE_API_KEY']!;
                Map<String, String> headers = {
                  'Content-Type': 'application/json',
                  'X-Goog-Api-Key': googleApiKey
                };
                Map<String, dynamic> body = {
                  "q": _originalController.text,
                  "target": "ja"
                };
                try {
                  response = await http.post(Uri.parse(googleTranslateUrl),
                      headers: headers, body: jsonEncode(body));
                  Map<String, dynamic> data = jsonDecode(response.body);
                  String translatedText =
                      data['data']['translations'][0]['translatedText'];
                  debugPrint('google_translate:$translatedText');
                  _translatedController.text = translatedText;
                } catch (e) {
                  debugPrint('error:$e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Center(
                        child:
                            Text('翻訳に失敗しました', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  );
                  return;
                }
                setState(() {
                  deeplResponse = false;
                  googleResponse = true;
                });
              },
              child: Image.asset(
                'assets/images/google_translate.png',
                width: 50,
              ),
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
                  if (deeplResponse)
                    bodyText('powered by Deep L', MyTheme.grey),
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
            customButton(titleText('SAVE', Colors.black.withOpacity(0.7), null),
                () async {
// original or translated word is empty then return
              if (_originalController.text == "" ||
                  _translatedController.text == "") {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Center(
                      child: Text('English & 日本語 は入力必須です',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                );
                return;
              }
// save
              final List<dynamic> addData = [
                noticeDuration,
                updateCount,
                flag,
                _originalController.text,
                _translatedController.text,
                updateDate,
                registrationDate,
                _memoController.text,
              ];
              String result = await DatabaseHelper.instance.addData(addData);
              if (result == 'exist') {
                if (context.mounted) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            backgroundColor:
                                const Color.fromARGB(255, 206, 206, 206),
                            title: subText('Already registered', Colors.black),
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
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
                }
                return;
              }
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const MainPage()),
                );
              }
              debugPrint('save');
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
