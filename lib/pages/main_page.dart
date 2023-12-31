import 'dart:async';

import 'package:flutter/material.dart';
import 'package:worbbing/application/database.dart';
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
  late Future<List<Map<String, dynamic>>> dataFuture;

  @override
  void initState() {
    super.initState();

    // tag reload
    switch (tagState) {
      case 0:
        dataFuture = DatabaseHelper.instance.queryAllRowsNoticeDuration();
      case 1:
        dataFuture = DatabaseHelper.instance.queryAllRowsAlphabet();
      case 2:
        dataFuture = DatabaseHelper.instance.queryAllRowsRegistration();
      case 3:
        dataFuture = DatabaseHelper.instance.queryAllRowsFlag();
    }
  }

  Future<void> handleReload() async {
    //durationが短すぎるとエラーになる
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      switch (tagState) {
        case 0:
          dataFuture = DatabaseHelper.instance.queryAllRowsNoticeDuration();
        case 1:
          dataFuture = DatabaseHelper.instance.queryAllRowsAlphabet();
        case 2:
          dataFuture = DatabaseHelper.instance.queryAllRowsRegistration();
        case 3:
          dataFuture = DatabaseHelper.instance.queryAllRowsFlag();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
// floating Action Button
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 5, right: 10.0),
          child:
              // customFloatingActionButton(
              //     context, animationController, translateAnimation),
              Stack(
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
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => RegistrationPage()),
                          );
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
          ),
        ),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: MyTheme.grey,
                  border: const Border(
                      bottom: BorderSide(color: Colors.white, width: 3))),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
// icon
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            padding: const EdgeInsets.only(top: 5, left: 10),
                            onPressed: () {
                              //
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const ConfigPage()),
                              );
                            },
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.white,
                              size: 30,
                            )),
                        Image.asset(
                          'assets/images/worbbing_logo.png',
                          width: 200,
                        ),
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
                    const SizedBox(
                      height: 10,
                    ),
// tag
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
            ),
// list
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: SizedBox(child: CircularProgressIndicator()));
                  }

                  if (snapshot.hasError) {
                    return const Text('エラーが発生しました');
                  }

                  final data = snapshot.data!;
                  var editableList = List.from(data);

                  final DateTime currentDateTime = DateTime.now();
                  NoticeModel noticeDurationList = NoticeModel();
                  int noticeDurationTime;
                  int forgettingDuration;
                  DateTime updateDateTime;

                  // change list expired top of list
                  if (tagState == 0) {
                    for (var i = 0; i < editableList.length; i++) {
                      noticeDurationTime = noticeDurationList.noticeDuration[
                          editableList[i][DatabaseHelper.noticeDuration]];
                      updateDateTime = DateTime.parse(
                          editableList[i][DatabaseHelper.updateDate]);
                      forgettingDuration =
                          currentDateTime.difference(updateDateTime).inDays;
                      if (forgettingDuration >= noticeDurationTime &&
                          noticeDurationTime != 00) {
                        // insert top of array
                        var insertData = editableList.removeAt(i);
                        editableList.insert(0, insertData);
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
                    itemCount: editableList.length,
                    itemBuilder: (context, index) {
                      final item = editableList[index];
                      return Column(
                        children: [
                          WordListTile(
                            onDragEnd: handleReload,
                            id: item[DatabaseHelper.columnId],
                            originalWord: item[DatabaseHelper.originalWord],
                            translatedWord: item[DatabaseHelper.translatedWord],
                            noticeDuration: item[DatabaseHelper.noticeDuration],
                            flag: item[DatabaseHelper.flag] != 0,
                            updateDate: item[DatabaseHelper.updateDate],
                          ),
                          // under space
                          if (index == editableList.length - 1)
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
}
