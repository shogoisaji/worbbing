import 'package:flutter/material.dart';
import 'package:worbbing/models/notice_model.dart';
import 'package:worbbing/pages/ebbinghaus_page.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_button.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/notice_block.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final model = NoticeModel();
  final totalWords = '254';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                      Navigator.pop(context);
                    }),
              ),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/account.png',
                  width: 200,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
            margin: const EdgeInsets.only(top: 25),
            width: 300,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white, width: 1)),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  mediumText('Total Words', Colors.white),
// total words
                  titleText(totalWords, MyTheme.orange, 36)
                ])),
        Container(
            margin: const EdgeInsets.only(top: 25),
            width: 300,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white, width: 1)),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  mediumText('Current Expired', Colors.white),
// total words
                  titleText(totalWords, MyTheme.orange, 36)
                ])),
// Data for each noticeDuration
        Container(
          margin: const EdgeInsets.only(top: 50),
          width: 350, //(noticeBlock+14padding)*7
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: model.noticeDuration.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(7.0),
                child: Column(
                  children: [
                    noticeBlock(36, model.noticeDuration[index], MyTheme.lemon),
                    const SizedBox(
                      height: 8,
                    ),
                    mediumText(
                        model.noticeDuration[index].toString(), Colors.white)
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        customButton(
            const Text(
              'エビングハウスの\n忘却曲線について',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EbbinghausPage()),
          );
        }),
      ]),
    ));
  }
}
