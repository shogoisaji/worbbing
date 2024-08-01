import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:worbbing/models/translate_language.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/presentation/widgets/ad_banner.dart';
import 'package:worbbing/presentation/widgets/kati_button.dart';
import 'package:worbbing/presentation/widgets/my_simple_dialog.dart';
import 'package:worbbing/repository/sqflite/sqflite_repository.dart';
import 'package:worbbing/pages/home_page.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/notice_block.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:worbbing/strings.dart';

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
  WordModel? wordModel;
  int forgettingDuration = 0;

  Future<void> _initialLoad() async {
    final loadModel = await SqfliteRepository.instance.queryRows(widget.id);
    final DateTime updateDateTime =
        DateTime.parse(loadModel.updateDate.toIso8601String());
    final DateTime currentDateTime = DateTime.now();
    forgettingDuration =
        (updateDateTime.difference(currentDateTime).inDays).abs();
    setState(() {
      wordModel = loadModel;
    });
  }

  @override
  void initState() {
    super.initState();
    _initialLoad();
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
                        _initialLoad();
                        if (!context1.mounted) return;
                        Navigator.pop(context1);
                      },
                      child: Text('Update',
                          style: TextStyle(
                              color: MyTheme.greyForOrange,
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
        .updateFlag(widget.id, !wordModel!.flag)
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
    _initialLoad();
  }

  Future<void> handleTapDelete() async {
    showDialog(
        context: context,
        builder: (BuildContext context2) => AlertDialog(
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              backgroundColor: MyTheme.grey,
              title: const Text(
                'Do you really want to delete it?',
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
                width: 30,
                height: 30,
              ),
            ),
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
            }),
        actions: [_buildFlag()],
        backgroundColor: Colors.transparent,
      ),
      body: wordModel == null
          ? const SizedBox.shrink()
          : SingleChildScrollView(
              child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        noticeBlock(
                            72, wordModel!.noticeDuration, MyTheme.lemon),
                        _buildDurationLabel(wordModel!),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  AdBanner(width: MediaQuery.of(context).size.width),
                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 42.0),
                    child: Column(
                      children: [
                        _detailWordContent(
                            ContentType.original, wordModel!.originalWord),
                        _detailWordContent(
                            ContentType.translated, wordModel!.translatedWord),
                        _detailWordContent(
                            ContentType.example, wordModel!.example ?? ''),
                        _detailWordContent(ContentType.exampleTranslated,
                            wordModel!.exampleTranslated ?? ''),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: LayoutBuilder(builder: (context, constraints) {
                            final width = constraints.maxWidth;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildDeleteButton(width * 0.46),
                                _buildEditButton(width * 0.46),
                              ],
                            );
                          }),
                        ),
                        const SizedBox(height: 32),
                        _buildRegistrationDate(),
                        const SizedBox(
                          height: 70,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
    final height = switch (type) {
      ContentType.original => 55.0,
      ContentType.translated => 55.0,
      ContentType.example => 80.0,
      ContentType.exampleTranslated => 80.0,
    };
    final fontSize = switch (type) {
      ContentType.original => 32.0,
      ContentType.translated => 24.0,
      ContentType.example => 22.0,
      ContentType.exampleTranslated => 20.0,
    };
    final titleColor = switch (type) {
      ContentType.original => MyTheme.lemon.withOpacity(0.7),
      ContentType.translated => Colors.orangeAccent.withOpacity(0.8),
      ContentType.example => MyTheme.lemon.withOpacity(0.7),
      ContentType.exampleTranslated => Colors.orangeAccent.withOpacity(0.8),
    };
    final language = switch (type) {
      ContentType.original => Container(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border:
                Border.all(color: MyTheme.blue.withOpacity(0.7), width: 1.0),
          ),
          child: Text(
            wordModel!.originalLang.string,
            style:
                TextStyle(color: MyTheme.blue.withOpacity(0.7), fontSize: 18),
          ),
        ),
      ContentType.translated => Container(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border:
                Border.all(color: MyTheme.blue.withOpacity(0.7), width: 1.0),
          ),
          child: Text(
            wordModel!.translatedLang.string,
            style:
                TextStyle(color: MyTheme.blue.withOpacity(0.7), fontSize: 18),
          ),
        ),
      ContentType.example => const SizedBox.shrink(),
      ContentType.exampleTranslated => const SizedBox.shrink(),
    };

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  type.string,
                  style: TextStyle(color: titleColor, fontSize: 18),
                ),
              ),
            ),
            language
          ],
        ),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: height,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.grey.shade600, width: 1.0))),
          child: AutoSizeText(
            word,
            maxLines: maxLines,
            style: TextStyle(color: Colors.white, fontSize: fontSize),
          ),
        ),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }

  Widget _buildEditButton(double width) {
    return KatiButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        handleTapEdit(
          wordModel!.id,
          wordModel!.originalWord,
          wordModel!.translatedWord,
          wordModel!.example ?? '',
          wordModel!.exampleTranslated ?? '',
        );
      },
      width: width,
      height: 65,
      elevation: 8,
      buttonRadius: 12,
      stageOffset: 5,
      inclinationRate: 0.7,
      buttonColor: MyTheme.orange,
      stageColor: Colors.blueGrey.shade800,
      stagePointColor: Colors.blueGrey.shade700,
      edgeLineColor: Colors.orange.shade300,
      edgeBorder: Border.all(color: Colors.white.withOpacity(0.5), width: 0.8),
      child: Align(
        alignment: const Alignment(0.8, 0.9),
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationX(0.5),
          child: Text(
            'Edit',
            style: TextStyle(
              fontSize: 27,
              color: MyTheme.greyForOrange,
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

  Widget _buildDeleteButton(double width) {
    return KatiButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        handleTapDelete();
      },
      width: width,
      height: 65,
      elevation: 8,
      buttonRadius: 12,
      stageOffset: 5,
      inclinationRate: 0.7,
      buttonColor: MyTheme.red,
      stageColor: Colors.blueGrey.shade800,
      stagePointColor: Colors.blueGrey.shade700,
      edgeLineColor: Colors.red.shade300,
      edgeBorder: Border.all(color: Colors.white.withOpacity(0.5), width: 0.8),
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

  Widget _buildFlag() {
    return GestureDetector(
      onTap: () async {
        HapticFeedback.lightImpact();
        await handleTapFlag();
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: (wordModel != null ? wordModel!.flag : false)
            ? Icon(Icons.flag_rounded, size: 49, color: MyTheme.lemon)
            : const Icon(Icons.outlined_flag_rounded,
                size: 46, color: Colors.grey),
      ),
    );
  }

  Widget _buildRegistrationDate() {
    return Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey.shade600, width: 1.0))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // change registration data
            Text('Registration Date',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
            const SizedBox(
              width: 12,
            ),
            Text(wordModel!.registrationDate.toIso8601String().toYMDString(),
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
          ],
        ));
  }

  Widget _buildDurationLabel(WordModel wordModel) {
    final DateTime updateDateTime =
        DateTime.parse(wordModel.updateDate.toIso8601String());
    final int forgettingDuration =
        (updateDateTime.difference(DateTime.now()).inDays).abs();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Last Update",
                  style: TextStyle(
                    height: 1.0,
                    color: Colors.grey.shade400,
                    fontSize: 13,
                  )),
              Text(updateDateTime.toIso8601String().toYMDString(),
                  style: TextStyle(
                    height: 1.0,
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  )),
            ],
          ),
        ),
        SizedBox(
          width: 100,
          height: 65,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(
                painter: DurationArrowPainter(),
              ),
              Align(
                alignment: const Alignment(0.0, -0.9),
                child: Text(forgettingDuration.toString(),
                    style: TextStyle(
                        height: 1.0,
                        color: MyTheme.orange,
                        fontSize: 42,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DurationArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double offset = 10.0;

    const text = TextSpan(
      text: 'Today',
      style: TextStyle(color: Colors.white, fontSize: 15),
    );
    final textPainter = TextPainter(
      text: text,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final textSize = textPainter.size;
    textPainter.paint(canvas,
        Offset(size.width - textSize.width, size.height - textSize.height - 1));

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    final tipPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(offset, offset * 0.8);
    path.lineTo(offset, size.height - offset);
    path.lineTo(size.width - offset - textSize.width, size.height - offset);

    final tipPath = Path();
    const arrowRate = 0.8;
    tipPath.moveTo(
        size.width - offset / 2 - textSize.width, size.height - offset);
    tipPath.relativeLineTo(-offset, -offset * arrowRate);
    tipPath.relativeLineTo(0, offset * 2 * arrowRate);
    tipPath.close();
    canvas.drawPath(path, paint);
    canvas.drawPath(tipPath, tipPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
