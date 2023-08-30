import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    final WordListTile tile = WordListTile(
      originalWord: 'addmission',
      translatedWord: '入場',
      noticeDuration: 5,
      flag: true,
    );

    return Scaffold(
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
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  padding: EdgeInsets.only(top: 35),
                  color: MyTheme.grey,
                  child: Column(children: [
                    titleText('Word List', Colors.white, null),
// 3 tags
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        tagSelect('expiration', tagState, 0, () {
                          setState(() {
                            tagState = 0;
                          });
                        }),
                        tagSelect('a → z', tagState, 1, () {
                          setState(() {
                            tagState = 1;
                          });
                        }),
                        tagSelect('flag', tagState, 2, () {
                          setState(() {
                            tagState = 2;
                          });
                        }),
                      ],
                    )
                  ]),
                ),
// top right icons
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            //
                          },
                          icon: const Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size: 30,
                          )),
                    ],
                  ),
                ),
              ],
            ),
            tile,
            tile,
            tile,
            // wordListTile('addmission', '入場', 3, true),
            // wordListTile('addmission', '入場', 3, true),
          ],
        ));
  }
}
