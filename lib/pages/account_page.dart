import 'package:flutter/material.dart';
import 'package:worbbing/models/notice_model.dart';
import 'package:worbbing/pages/config_page.dart';
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
                      width: 25,
                      height: 25,
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
              Align(
                  alignment: const Alignment(0.9, 0),
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ConfigPage()),
                        );
                      },
                      icon:
                          Icon(Icons.settings, color: Colors.white, size: 36))),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
            margin: EdgeInsets.only(top: 25),
            width: 300,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  mediumText('Total Words', Colors.white),
// total words
                  titleText(totalWords, MyTheme.orange, 36)
                ]),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white, width: 1)),
            )),
        Container(
            margin: EdgeInsets.only(top: 25),
            width: 300,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  mediumText('Current\nExpirations', Colors.white),
// total words
                  titleText(totalWords, MyTheme.orange, 36)
                ]),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white, width: 1)),
            )),
// Data for each noticeDuration
        Container(
          // color: Colors.blue,
          margin: const EdgeInsets.only(top: 40),
          padding: const EdgeInsets.only(left: 7),
          width: 330,
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: model.noticeDuration.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
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
            Text(
              'エビングハウスの\n忘却曲線について',
              style: TextStyle(fontSize: 14),
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
