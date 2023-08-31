import 'package:flutter/material.dart';
import 'package:worbbing/application/database.dart';
import 'package:worbbing/pages/account_page.dart';
import 'package:worbbing/pages/config_page.dart';
import 'package:worbbing/pages/registration_page.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/list_tile.dart';
import 'package:worbbing/presentation/widgets/tag_select.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int tagState = 0;
  late final Future<List<Map<String, dynamic>>> dataFuture;

  @override
  void initState() {
    super.initState();

    dataFuture = DatabaseHelper.instance.queryAllRows();
  }

  @override
  Widget build(BuildContext context) {
    final WordListTile tile = WordListTile(
      originalWord: 'addmission',
      translatedWord: '入場',
      noticeDuration: 5,
      flag: true,
    );

    return Scaffold(
// floating Action Button
        floatingActionButton: Stack(
          children: [
            Transform.rotate(
              angle: 1.6,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.zero,
                  color: MyTheme.grey,
                ),
              ),
            ),
            Transform.rotate(
              angle: 1.2,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.zero,
                  color: MyTheme.orange,
                ),
                child: FloatingActionButton(
                  elevation: 0,
                  backgroundColor: MyTheme.orange,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationPage()),
                    );
                  },
                  child: Transform.rotate(
                    angle: -1.2,
                    child: const Icon(
                      Icons.add,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              height: 130,
              color: MyTheme.grey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            //
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ConfigPage()),
                            );
                          },
                          icon: const Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 30,
                          )),
                      titleText('Word List', Colors.white, null),
                      IconButton(
                          onPressed: () {
                            //
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AccountPage()),
                            );
                          },
                          icon: const Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size: 30,
                          )),
                      // 3 tags
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      tagSelect('Expired', tagState, 0, () {
                        setState(() {
                          tagState = 0;
                        });
                      }),
                      tagSelect('A → Z', tagState, 1, () {
                        setState(() {
                          tagState = 1;
                        });
                      }),
                      tagSelect('Flag', tagState, 2, () {
                        setState(() {
                          tagState = 2;
                        });
                      }),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: SizedBox(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator()));
                  }

                  if (snapshot.hasError) {
                    return const Text('エラーが発生しました');
                  }

                  final data = snapshot.data!;

                  return Container(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return Column(
                          children: [
                            WordListTile(
                              originalWord: item[DatabaseHelper.originalWord],
                              translatedWord:
                                  item[DatabaseHelper.translatedWord],
                              noticeDuration:
                                  item[DatabaseHelper.noticeDuration],
                              flag: item[DatabaseHelper.flag] != 0,
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
                                          Colors.transparent,
                                          MyTheme.grey,
                                          MyTheme.grey,
                                          Colors.transparent,
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
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }
}
