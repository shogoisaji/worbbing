import 'package:flutter/material.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/repository/sqflite_repository.dart';
import 'package:worbbing/application/date_format.dart';
import 'package:worbbing/pages/main_page.dart';
import 'package:worbbing/models/notice_model.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_button2.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/notice_block.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.id});
  final String id;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

TextEditingController _originalController = TextEditingController();
TextEditingController _translatedController = TextEditingController();
TextEditingController _exampleController = TextEditingController();
TextEditingController _exampleTranslatedController = TextEditingController();

class _DetailPageState extends State<DetailPage> {
  NoticeModel noticeDurationList = NoticeModel();
  bool flag = false;
  @override
  void initState() {
    super.initState();
    _originalController = TextEditingController();
    _translatedController = TextEditingController();
    _exampleController = TextEditingController();
    _exampleTranslatedController = TextEditingController();
  }

  @override
  void dispose() {
    _originalController.dispose();
    _translatedController.dispose();
    _exampleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
            child: FutureBuilder<WordModel>(
          future: SqfliteRepository.instance.queryRows(widget.id),
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
            final formatRegistrationDate =
                formatForDisplay(data.registrationDate.toIso8601String());
            final formatUpdateDate =
                formatForDisplay(data.updateDate.toIso8601String());
            final DateTime updateDateTime =
                DateTime.parse(data.updateDate.toIso8601String());
            final DateTime currentDateTime = DateTime.now();
            final int forgettingDuration =
                (updateDateTime.difference(currentDateTime).inDays).abs();

            flag = data.flag;
            final notice =
                noticeDurationList.noticeDuration[data.noticeDuration];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/detail.png',
                          width: 200,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        bodyText('NoticeDuration', MyTheme.grey),
                        const SizedBox(
                          height: 8,
                        ),
                        noticeBlock(72, notice, MyTheme.lemon),
                      ],
                    ),
                    Column(
                      children: [
                        bodyText('Previous Update', MyTheme.grey),
                        bodyText(formatUpdateDate.split(' ')[0], MyTheme.grey),
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          child: Row(
                            children: [
                              bodyText('Forgetting\n  Duration', Colors.white),
                              const SizedBox(
                                width: 10,
                              ),
                              // change forgetting duration
                              titleText(forgettingDuration.toString(),
                                  MyTheme.orange, null),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () async {
                            // change flag state
                            setState(() {
                              if (!flag) {
                                flag = true;
                              } else {
                                flag = false;
                              }
                            });
                            await SqfliteRepository.instance
                                .updateFlag(widget.id, flag);
                          },
                          icon: flag == 1
                              ? Icon(Icons.flag, size: 48, color: MyTheme.lemon)
                              : const Icon(Icons.flag_outlined,
                                  size: 48, color: Colors.white24),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                      ],
                    ),
                  ],
                ),
// original word
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  width: 300,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      bodyText('English', MyTheme.grey),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              //
                              _originalController.text = data.originalWord;
                              _translatedController.text = data.translatedWord;
                              _exampleController.text = data.example ?? '';
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context1) =>
                                      AlertDialog(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero),
                                        backgroundColor: const Color.fromARGB(
                                            255, 206, 206, 206),
                                        content: SizedBox(
                                          height: 300,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                subText(
                                                    'English', Colors.black54),
                                                TextField(
                                                  keyboardType: TextInputType
                                                      .visiblePassword,
                                                  style: const TextStyle(
                                                      fontSize: 20),
                                                  controller:
                                                      _originalController,
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                subText('日本語', Colors.black54),
                                                TextField(
                                                  style: const TextStyle(
                                                      fontSize: 20),
                                                  controller:
                                                      _translatedController,
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                subText('Memo', Colors.black54),
                                                TextField(
                                                  style: const TextStyle(
                                                      fontSize: 20),
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  maxLines: 3,
                                                  controller:
                                                      _exampleController,
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context1);
                                            },
                                            child: subText(
                                                'Cancel', MyTheme.orange),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.all(8),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.zero,
                                              ),
                                              backgroundColor: MyTheme.orange,
                                            ),
                                            onPressed: () async {
// update words
                                              debugPrint('update words');
                                              await SqfliteRepository.instance
                                                  .updateWords(
                                                      data.id,
                                                      _originalController.text,
                                                      _translatedController
                                                          .text,
                                                      _exampleController.text,
                                                      _exampleTranslatedController
                                                          .text);
                                              setState(() {});
                                              if (context1.mounted) {
                                                Navigator.pop(context1);
                                                Navigator.of(context1)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context1) =>
                                                          const MainPage()),
                                                );
                                              }
                                            },
                                            child:
                                                subText('Update', Colors.white),
                                          ),
                                        ],
                                      ));
                            },
                            icon: const Icon(
                              Icons.create,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 300,
                  height: 50,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.white, width: 1.0))),
                  child: titleText(data.originalWord, Colors.white, null),
                ),
// translated word
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  alignment: Alignment.topLeft,
                  width: 300,
                  child: bodyText('日本語', MyTheme.grey),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 300,
                  height: 50,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.white, width: 1.0))),
                  child: titleText(data.translatedWord, Colors.white, null),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  width: 300,
                  alignment: Alignment.topLeft,
                  child: bodyText('Memo', Colors.grey),
                ),
                Stack(
                  children: [
                    Transform.translate(
                      offset: const Offset(6, 5),
                      child: Transform.rotate(
                          angle: 0.02,
                          child: Container(
                              width: 300, height: 100, color: MyTheme.orange)),
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: 300,
                        height: 100,
                        color: Colors.white,
                        child: bodyText2(data.example ?? '', Colors.black)),
                  ],
                ),

                Container(
                    margin: const EdgeInsets.only(top: 40),
                    alignment: Alignment.center,
                    width: 230,
                    height: 30,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.white, width: 1.0))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // change registration data
                        bodyText('Registration Date', Colors.white),
                        bodyText(
                            formatRegistrationDate.split(' ')[0], Colors.white),
                      ],
                    )),
                Container(
                    margin: const EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    width: 230,
                    height: 30,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.white, width: 1.0))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // change update count
                        bodyText('Update Count', Colors.white),
                        Container(
                            alignment: Alignment.center,
                            width: 50,
                            child: bodyText(
                                data.updateCount.toString(), Colors.white)),
                      ],
                    )),
                const SizedBox(
                  height: 40,
                ),
                customButton2(
                    MyTheme.red, titleText('Delete', Colors.white, 20),
                    () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context2) =>
                          // deleteDialog(context, widget.id),
                          AlertDialog(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            backgroundColor:
                                const Color.fromARGB(255, 206, 206, 206),
                            title: subText('Really?', Colors.black),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context2);
                                },
                                child: subText('Cancel', MyTheme.red),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  backgroundColor: MyTheme.red,
                                ),
                                onPressed: () async {
// Delete
                                  await SqfliteRepository.instance
                                      .deleteRow(widget.id);
                                  if (context2.mounted) {
                                    Navigator.pop(context2);
                                    Navigator.of(context2).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context2) =>
                                              const MainPage()),
                                    );
                                  }
                                },
                                child: subText('Delete', Colors.white),
                              ),
                            ],
                          ));
                }),
                const SizedBox(
                  height: 100,
                ),
              ],
            );
          },
        )),
      ),
    );
  }
}
