import 'dart:async';

import 'package:flutter/material.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/presentation/widgets/registration_bottom_sheet.dart';
import 'package:worbbing/repository/sqflite_repository.dart';
import 'package:worbbing/models/notice_model.dart';
import 'package:worbbing/pages/account_page.dart';
import 'package:worbbing/pages/config_page.dart';
import 'package:worbbing/pages/registration_page.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/list_tile.dart';
import 'package:worbbing/presentation/widgets/tag_select.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  int tagState = 0;

  Future<List<WordModel>> dataFuture =
      SqfliteRepository.instance.queryAllRowsNoticeDuration();

  @override
  void initState() {
    super.initState();
  }

  void handleTapFAB(BuildContext context) async {
    await showModalBottomSheet(
        backgroundColor: MyTheme.grey,
        enableDrag: false,
        isScrollControlled: true,
        context: context,
        builder: (context) => const RegistrationBottomSheet());
    handleReload();
  }

  Future<void> handleReload() async {
    //durationが短すぎるとエラーになる
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      switch (tagState) {
        case 0:
          dataFuture = SqfliteRepository.instance.queryAllRowsNoticeDuration();
        case 1:
          dataFuture = SqfliteRepository.instance.queryAllRowsAlphabet();
        case 2:
          dataFuture = SqfliteRepository.instance.queryAllRowsRegistration();
        case 3:
          dataFuture = SqfliteRepository.instance.queryAllRowsFlag();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyTheme.grey,
          elevation: 0,
          title: Image.asset(
            'assets/images/worbbing_logo.png',
            width: 200,
          ),
          leadingWidth: 40,
          leading: IconButton(
              padding: const EdgeInsets.only(top: 5, left: 10),
              onPressed: () {
                //
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const ConfigPage()),
                );
              },
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
                size: 30,
              )),
          actions: [
            IconButton(
                padding: const EdgeInsets.only(top: 5, right: 10),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const AccountPage()),
                  );
                },
                icon: const Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 30,
                )),
          ],
        ),

        /// floating Action Button
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 5, right: 10.0),
            // child: IconButton(
            //   onPressed: () => handleTapFAB(context),
            //   icon: const Icon(Icons.add),
            // ),
            child: _customFloatingActionButton()),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: MyTheme.grey,
                  border: const Border(
                      bottom: BorderSide(color: Colors.white, width: 3))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /// tag
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      tagSelect('Notice', tagState, 0, () {
                        setState(() {
                          tagState = 0;
                        });
                        handleReload();
                      }),
                      tagSelect('Alphabet', tagState, 1, () {
                        setState(() {
                          tagState = 1;
                        });
                        handleReload();
                      }),
                      tagSelect('Register', tagState, 2, () {
                        setState(() {
                          tagState = 2;
                        });
                        handleReload();
                      }),
                      tagSelect('Flagged', tagState, 3, () {
                        setState(() {
                          tagState = 3;
                        });
                        handleReload();
                      }),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
// list
            Expanded(
              child: FutureBuilder<List<WordModel>>(
                future: dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: SizedBox(child: CircularProgressIndicator()));
                  }

                  if (snapshot.hasError) {
                    return const Text('エラーが発生しました');
                  }

                  final wordList = snapshot.data!;

                  final DateTime currentDateTime = DateTime.now();
                  NoticeModel noticeDurationList = NoticeModel();
                  int noticeDurationTime;
                  int forgettingDuration;
                  DateTime updateDateTime;

                  // change list expired top of list
                  if (tagState == 0) {
                    for (var i = 0; i < wordList.length; i++) {
                      noticeDurationTime = noticeDurationList
                          .noticeDuration[wordList[i].noticeDuration];
                      updateDateTime = wordList[i].updateDate;
                      forgettingDuration =
                          currentDateTime.difference(updateDateTime).inDays;
                      if (forgettingDuration >= noticeDurationTime &&
                          noticeDurationTime != 00) {
                        // insert top of array
                        var insertData = wordList.removeAt(i);
                        wordList.insert(0, insertData);
                      }
                    }
                  }
                  return ListView.separated(
                    separatorBuilder: (context, index) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            MyTheme.lemon,
                            MyTheme.grey,
                            MyTheme.grey,
                            MyTheme.orange,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      height: 1,
                    ),
                    padding: EdgeInsets.zero,
                    itemCount: wordList.length,
                    itemBuilder: (context, index) {
                      final item = wordList[index];
                      return Column(
                        children: [
                          WordListTile(
                            onDragEnd: handleReload,
                            wordModel: item,
                          ),
                          // under space
                          if (index == wordList.length - 1)
                            Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        MyTheme.lemon,
                                        MyTheme.grey,
                                        MyTheme.grey,
                                        MyTheme.orange,
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 100,
                                ),
                              ],
                            )
                        ],
                      );
                    },
                  );
                },
              ),
            )
          ],
        ));
  }

  Widget _customFloatingActionButton() {
    return Stack(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(65),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(20.0, 15.0),
                blurRadius: 15.0,
                spreadRadius: 50.0,
              ),
            ],
          ),
        ),
        Transform.rotate(
          angle: 1.5,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.zero,
              color: MyTheme.grey,
            ),
          ),
        ),
        Transform.rotate(
          angle: 1.2,
          child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.zero,
                color: MyTheme.orange,
              ),
              child: FloatingActionButton(
                  elevation: 0,
                  backgroundColor: MyTheme.orange,
                  // FAB onPressed
                  onPressed: () {
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //       builder: (context) => const RegistrationPage()),
                    // );
                    handleTapFAB(context);
                  },
                  child: Transform.rotate(
                    angle: -1.2,
                    child: const Icon(
                      Icons.add,
                      size: 32,
                    ),
                  ))),
        ),
      ],
    );
  }
}
