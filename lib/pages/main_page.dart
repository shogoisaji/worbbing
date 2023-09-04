import 'package:flutter/material.dart';
import 'package:worbbing/application/database.dart';
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
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
// floating Action Button
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 5, right: 10.0),
          child: Stack(
            children: [
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
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const RegistrationPage()),
                      );
                    },
                    child: Transform.rotate(
                      angle: -1.2,
                      child: const Icon(
                        Icons.add,
                        size: 32,
                      ),
                    ),
                  ),
                ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            padding: const EdgeInsets.only(left: 10),
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
                        // titleText('Word List', Colors.white, null),
                        IconButton(
                            padding: const EdgeInsets.only(right: 10),
                            onPressed: () {
                              //
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
                      height: 5,
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
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
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
                          if (index == data.length - 1)
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
