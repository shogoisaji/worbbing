import 'package:flutter/material.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/repository/sqflite_repository.dart';
import 'package:worbbing/models/notice_model.dart';
import 'package:worbbing/pages/ebbinghaus_page.dart';
import 'package:worbbing/pages/home_page.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_button.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/notice_block.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // final model = NoticeModel();

  late Future<int> totalWords;
  late Future<Map<int, int>> countNotice;

  @override
  void initState() {
    super.initState();
    totalWords = SqfliteRepository.instance.totalWords();
    countNotice = SqfliteRepository.instance.countNoticeDuration();
  }

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
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    }),
              ),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/settings.png',
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
            width: 250,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white, width: 1)),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  mediumText('Total Words', Colors.white),
// total words
                  FutureBuilder(
                      future: totalWords,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child:
                                  SizedBox(child: CircularProgressIndicator()));
                        }

                        if (snapshot.hasError) {
                          return const Text('エラーが発生しました');
                        }

                        final data = snapshot.data!;

                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: titleText(data.toString(), MyTheme.orange, 36),
                        );
                      })
                ])),
        FutureBuilder(
            future: countNotice,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: SizedBox(child: CircularProgressIndicator()));
              }

              if (snapshot.hasError) {
                return const Text('エラーが発生しました');
              }

              final data = snapshot.data!;

              return Container(
                margin: const EdgeInsets.only(top: 50),
                width: 350, //(noticeBlock+14padding)*7
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: noticeDurationList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Column(
                        children: [
                          noticeBlock(
                              36, noticeDurationList[index], MyTheme.lemon),
                          const SizedBox(
                            height: 8,
                          ),
                          mediumText(
                              data[noticeDurationList[index]] == null
                                  ? "0"
                                  : data[noticeDurationList[index]].toString(),
                              Colors.white)
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
        const SizedBox(
          height: 50,
        ),
        customButton(
            Text(
              'エビングハウスの\n忘却曲線について',
              style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EbbinghausPage()),
          );
        }),
      ]),
    ));
  }
}
