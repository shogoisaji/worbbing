import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:worbbing/models/translate_language.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/presentation/widgets/ad_banner.dart';
import 'package:worbbing/presentation/widgets/kati_button.dart';
import 'package:worbbing/presentation/widgets/my_simple_dialog.dart';
import 'package:worbbing/repository/sqflite_repository.dart';
import 'package:worbbing/application/date_format.dart';
import 'package:worbbing/pages/home_page.dart';
import 'package:worbbing/presentation/theme/theme.dart';
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
                          Navigator.of(context1).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context2) => const HomePage()),
                            (route) => false,
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
      MySimpleDialog.show(
          context,
          const Text('Failed to update data',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              )),
          'OK', () {
        //
      });
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
                'Are you sure you want to delete this data?',
                style: TextStyle(
                    overflow: TextOverflow.clip,
                    color: Colors.white,
                    fontSize: 20),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
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
                    HapticFeedback.lightImpact();
                    await SqfliteRepository.instance.deleteRow(widget.id);
                    if (context2.mounted) {
                      Navigator.pop(context2);
                      Navigator.of(context2).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context2) => const HomePage()),
                        (route) => false,
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
        centerTitle: true,
        title: Image.asset(
          'assets/images/detail.png',
          width: 150,
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
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
            child: FutureBuilder<WordModel>(
          future: SqfliteRepository.instance.queryRows(widget.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
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
                            Text(
                                'Last Update\n${formatUpdateDate.split(' ')[0]}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    height: 1.0,
                                    color: Colors.grey.shade600,
                                    fontSize: 16)),
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
                  const SizedBox(height: 32),
                  AdBanner(width: MediaQuery.of(context).size.width),
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
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                margin: const EdgeInsets.only(
                                    top: 30.0,
                                    bottom: 16.0,
                                    left: 0.0,
                                    right: 24.0),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 12.0),

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
                            margin: const EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.shade600,
                                        width: 1.0))),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // change registration data
                                Text('Registration Date',
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 16)),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(formatRegistrationDate.split(' ')[0],
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 16)),
                              ],
                            )),
                        const SizedBox(
                          height: 40,
                        ),
                        _buildDeleteButton(),
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
      ),
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
      ContentType.original => MyTheme.lemon.withOpacity(0.7),
      ContentType.translated => Colors.orangeAccent.withOpacity(0.8),
      ContentType.example => MyTheme.lemon.withOpacity(0.7),
      ContentType.exampleTranslated => Colors.orangeAccent.withOpacity(0.8),
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

  Widget _buildDeleteButton() {
    return KatiButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        handleTapDelete();
      },
      width: 180,
      height: 65,
      elevation: 8,
      buttonRadius: 12,
      stageOffset: 5,
      pushedElevationLevel: 0.8,
      inclinationRate: 0.9,
      buttonColor: MyTheme.red,
      stageColor: Colors.blueGrey.shade800,
      stagePointColor: Colors.blueGrey.shade700,
      edgeLineColor: Colors.red.shade300,
      edgeBorder: Border.all(color: Colors.white.withOpacity(0.5), width: 0.8),
      duration: const Duration(milliseconds: 200),
      child: Align(
        alignment: const Alignment(0.8, 0.9),
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationX(0.5),
          child: Text(
            'Delete',
            style: TextStyle(
              fontSize: 27,
              color: Colors.grey.shade100,
              fontWeight: FontWeight.bold,
              shadows: [
                BoxShadow(
                  color: Colors.grey.shade500,
                  blurRadius: 1.0,
                  offset: const Offset(0, -0.8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
