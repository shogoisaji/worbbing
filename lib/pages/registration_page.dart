import 'package:flutter/material.dart';
import 'package:worbbing/application/database.dart';
import 'package:worbbing/application/date_format.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_button.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/registration_text_field.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _originalController = TextEditingController();
  TextEditingController _translatedController = TextEditingController();
  TextEditingController _memoController = TextEditingController();
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    final int noticeDuration = 1;
    final int updateCount = 0;
    final String originalWord = _originalController.text;
    final String translatedWord = _translatedController.text;
    final String updateDate = getCurrentDate();
    final String registrationDate = getCurrentDate();
    final String memo = _memoController.text;

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
                          width: 25,
                          height: 25,
                        ),
                        onTap: () {
                          Navigator.pop(context);
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
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              width: 300,
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  // change flag state
                  setState(() {
                    if (flag == false) {
                      flag = true;
                    } else {
                      flag = false;
                    }
                  });
                },
                icon: flag
                    ? Icon(Icons.flag, size: 48, color: MyTheme.lemon)
                    : const Icon(Icons.flag_outlined,
                        size: 48, color: Colors.white24),
              ),
            ),
            registrationTextField(_originalController),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: InkWell(
                onTap: () {
                  //
                },
                child: Image.asset(
                  'assets/images/deepL.png',
                  width: 50,
                ),
              ),
            ),
            registrationTextField(_translatedController),
            const SizedBox(
              height: 40,
            ),
            Container(
              width: 300,
              alignment: Alignment.topLeft,
              child: subText('Memo', Colors.white),
            ),
            registrationMemoTextField(_memoController),
            const SizedBox(
              height: 50,
            ),
            customButton(titleText('SAVE', Colors.black, null), () async {
              // save
              final List<dynamic> addData = [
                noticeDuration,
                updateCount,
                flag,
                originalWord,
                translatedWord,
                updateDate,
                registrationDate,
                memo,
              ];
              await DatabaseHelper.instance.addData(addData);
              if (context.mounted) {
                Navigator.pop(context);
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
