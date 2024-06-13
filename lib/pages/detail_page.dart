import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:worbbing/models/translate_language.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/repository/sqflite_repository.dart';
import 'package:worbbing/application/date_format.dart';
import 'package:worbbing/pages/home_page.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_button2.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/notice_block.dart';
import 'package:auto_size_text/auto_size_text.dart';

enum ContentType {
  original,
  translated,
  example,
  exampleTranslated,
}

extension ContentTypeExtension on ContentType {
  String get string {
    switch (this) {
      case ContentType.original:
        return 'Original';
      case ContentType.translated:
        return 'Translated';
      case ContentType.example:
        return 'Example';
      case ContentType.exampleTranslated:
        return 'Translated Example';
    }
  }
}

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
    _exampleTranslatedController.dispose();

    super.dispose();
  }

  void handleTapEdit(String id, String originalWord, String translatedWord,
      String example, String exampleTranslated) {
    _originalController.text = originalWord;
    _translatedController.text = translatedWord;
    _exampleController.text = example;
    _exampleTranslatedController.text = exampleTranslated;

    showDialog(
        context: context,
        builder: (BuildContext context1) => Stack(
              children: [
                AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                  backgroundColor: MyTheme.grey,
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        bodyText('Original', MyTheme.lemon.withOpacity(0.9)),
                        TextField(
                          keyboardType: TextInputType.visiblePassword,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                          controller: _originalController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        bodyText(
                            'Translated', Colors.orangeAccent.withOpacity(0.9)),
                        TextField(
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                          controller: _translatedController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        bodyText('Example', MyTheme.lemon.withOpacity(0.9)),
                        TextField(
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          controller: _exampleController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        bodyText('Translated Example',
                            Colors.orangeAccent.withOpacity(0.9)),
                        TextField(
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          controller: _exampleTranslatedController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(context1);
                      },
                      child: subText('Cancel', MyTheme.orange),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, bottom: 4, top: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        backgroundColor: MyTheme.orange,
                      ),
                      onPressed: () async {
                        HapticFeedback.lightImpact();
                        // update words
                        await SqfliteRepository.instance.updateWords(
                            id,
                            _originalController.text,
                            _translatedController.text,
                            _exampleController.text,
                            _exampleTranslatedController.text);
                        setState(() {});
                        if (context1.mounted) {
                          Navigator.pop(context1);
                          Navigator.of(context1).pushReplacement(
                            MaterialPageRoute(
                                builder: (context1) => const HomePage()),
                          );
                        }
                      },
                      child: const Text('Update',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24)),
                    ),
                  ],
                ),
              ],
            ));
  }

  Future<void> handleTapFlag() async {
    // change flag state
    await SqfliteRepository.instance
        .updateFlag(widget.id, !flag)
        .catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('データの更新に失敗しました'),
          backgroundColor: Colors.red.shade300,
        ),
      );
    });
    setState(() {
      if (!flag) {
        flag = true;
      } else {
        flag = false;
      }
    });
  }

  Future<void> handleTapDelete() async {
    showDialog(
        context: context,
        builder: (BuildContext context2) =>
            // deleteDialog(context, widget.id),
            AlertDialog(
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              backgroundColor: MyTheme.grey,
              title: const Text(
                'このデータを削除しますか?',
                style: TextStyle(
                    overflow: TextOverflow.clip,
                    color: Colors.white,
                    fontSize: 20),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context2);
                  },
                  child: subText('Cancel', MyTheme.red),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, bottom: 4, top: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    backgroundColor: MyTheme.red,
                  ),
                  onPressed: () async {
                    // Delete
                    await SqfliteRepository.instance.deleteRow(widget.id);
                    if (context2.mounted) {
                      Navigator.pop(context2);
                      Navigator.of(context2).pushReplacement(
                        MaterialPageRoute(
                            builder: (context2) => const HomePage()),
                      );
                    }
                  },
                  child: subText('Delete', Colors.white),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Image.asset(
            'assets/images/detail.png',
            width: 120,
          ),
        ),
        leading: InkWell(
            child: Align(
              child: Image.asset(
                'assets/images/custom_arrow.png',
                width: 35,
                height: 35,
              ),
            ),
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            }),
        backgroundColor: Colors.transparent,
      ),
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

          final wordModel = snapshot.data!;
          final formatRegistrationDate =
              formatForDisplay(wordModel.registrationDate.toIso8601String());
          final formatUpdateDate =
              formatForDisplay(wordModel.updateDate.toIso8601String());
          final DateTime updateDateTime =
              DateTime.parse(wordModel.updateDate.toIso8601String());
          final DateTime currentDateTime = DateTime.now();
          final int forgettingDuration =
              (updateDateTime.difference(currentDateTime).inDays).abs();

          flag = wordModel.flag;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    noticeBlock(72, wordModel.noticeDuration, MyTheme.lemon),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Column(
                        children: [
                          bodyText('Prev : ${formatUpdateDate.split(' ')[0]}',
                              Colors.grey.shade600),
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(color: Colors.grey)),
                            child: Row(
                              children: [
                                const Text('Forgetting\nDuration',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
                                // bodyText('Forgetting\n  Duration', Colors.white),
                                const SizedBox(
                                  width: 12,
                                ),
                                // change forgetting duration
                                Text(forgettingDuration.toString(),
                                    style: TextStyle(
                                        color: MyTheme.orange, fontSize: 34)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        HapticFeedback.lightImpact();
                        await handleTapFlag();
                      },
                      child: flag
                          ? Icon(Icons.flag_rounded,
                              size: 54, color: MyTheme.lemon)
                          : const Icon(Icons.outlined_flag_rounded,
                              size: 54, color: Colors.white24),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 42.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              // width: 50,
                              // color: Colors.red,
                              decoration: BoxDecoration(
                                border: Border.all(color: MyTheme.blue),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              margin: const EdgeInsets.only(
                                  top: 30.0,
                                  bottom: 16.0,
                                  left: 0.0,
                                  right: 24.0),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),

                              child: AutoSizeText(
                                  "${wordModel.originalLang.string} → ${wordModel.translatedLang.string}",
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: MyTheme.blue, fontSize: 20)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                handleTapEdit(
                                  wordModel.id,
                                  wordModel.originalWord,
                                  wordModel.translatedWord,
                                  wordModel.example ?? '',
                                  wordModel.exampleTranslated ?? '',
                                );
                              },
                              child: const Icon(
                                Icons.create,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                        ],
                      ),
                      _detailWordContent(
                          ContentType.original, wordModel.originalWord),
                      _detailWordContent(
                          ContentType.translated, wordModel.translatedWord),
                      _detailWordContent(
                          ContentType.example, wordModel.example ?? ''),
                      _detailWordContent(ContentType.exampleTranslated,
                          wordModel.exampleTranslated ?? ''),
                      Container(
                          margin: const EdgeInsets.only(top: 24),
                          alignment: Alignment.center,
                          width: 230,
                          height: 30,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.white, width: 1.0))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // change registration data
                              bodyText('Registration Date', Colors.white),
                              bodyText(formatRegistrationDate.split(' ')[0],
                                  Colors.white),
                            ],
                          )),
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          alignment: Alignment.center,
                          width: 230,
                          height: 30,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.white, width: 1.0))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // change update count
                              bodyText('Update Count', Colors.white),
                              Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  child: bodyText(
                                      wordModel.updateCount.toString(),
                                      Colors.white)),
                            ],
                          )),
                      const SizedBox(
                        height: 40,
                      ),
                      customButton2(
                          MyTheme.red, titleText('Delete', Colors.white, 20),
                          () async {
                        handleTapDelete();
                      }),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      )),
    );
  }

  Widget _detailWordContent(
    ContentType type,
    String word,
  ) {
    final maxLines = switch (type) {
      ContentType.original => 1,
      ContentType.translated => 1,
      ContentType.example => 2,
      ContentType.exampleTranslated => 2,
    };
    final fontSize = switch (type) {
      ContentType.original => 30.0,
      ContentType.translated => 30.0,
      ContentType.example => 20.0,
      ContentType.exampleTranslated => 20.0,
    };
    final titleColor = switch (type) {
      ContentType.original => MyTheme.lemon.withOpacity(0.6),
      ContentType.translated => Colors.orangeAccent.withOpacity(0.6),
      ContentType.example => MyTheme.lemon.withOpacity(0.6),
      ContentType.exampleTranslated => Colors.orangeAccent.withOpacity(0.6),
    };

    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          width: double.infinity,
          child: bodyText(type.string, titleColor),
        ),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 50,
          decoration: const BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.white, width: 1.0))),
          child: AutoSizeText(
            word,
            maxLines: maxLines,
            style: TextStyle(color: Colors.white, fontSize: fontSize),
          ),
        ),
        const SizedBox(
          height: 32,
        )
      ],
    );
  }
}
