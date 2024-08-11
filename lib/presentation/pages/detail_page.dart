import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:worbbing/core/utils/strings.dart';
import 'package:worbbing/domain/entities/translate_language.dart';
import 'package:worbbing/domain/entities/word_model.dart';
import 'package:worbbing/domain/usecases/app/speak_word_usecase.dart';
import 'package:worbbing/l10n/l10n.dart';
import 'package:worbbing/presentation/view_model/detail_page_view_model.dart';
import 'package:worbbing/presentation/widgets/ad_banner.dart';
import 'package:worbbing/presentation/widgets/error_dialog.dart';
import 'package:worbbing/presentation/widgets/kati_button.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/notice_block.dart';
import 'package:worbbing/presentation/widgets/yes_no_dialog.dart';

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

class DetailPage extends HookConsumerWidget {
  final WordModel wordModel;

  const DetailPage({Key? key, required this.wordModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(detailPageViewModelProvider(wordModel));
    final viewModelNotifier =
        ref.watch(detailPageViewModelProvider(wordModel).notifier);

    final l10n = L10n.of(context)!;

    final originalController = useTextEditingController();
    final translatedController = useTextEditingController();
    final exampleController = useTextEditingController();
    final exampleTranslatedController = useTextEditingController();

    int forgettingDuration = 0;

    void handleTapEdit() {
      originalController.text = wordModel.originalWord;
      translatedController.text = wordModel.translatedWord;
      exampleController.text = wordModel.example ?? '';
      exampleTranslatedController.text = wordModel.exampleTranslated ?? '';
      showDialog(
          context: context,
          builder: (BuildContext editContext) => Stack(
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
                          bodyText(
                              l10n.original, MyTheme.lemon.withOpacity(0.9)),
                          TextField(
                            keyboardType: TextInputType.visiblePassword,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black),
                            controller: originalController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          bodyText(l10n.translated,
                              Colors.orangeAccent.withOpacity(0.9)),
                          TextField(
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black),
                            controller: translatedController,
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
                              l10n.example, MyTheme.lemon.withOpacity(0.9)),
                          TextField(
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black),
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            controller: exampleController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          bodyText(l10n.translated_example,
                              Colors.orangeAccent.withOpacity(0.9)),
                          TextField(
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black),
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            controller: exampleTranslatedController,
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
                          Navigator.of(editContext).pop();
                        },
                        child: Text(l10n.cancel,
                            style:
                                TextStyle(color: MyTheme.orange, fontSize: 22)),
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
                          await viewModelNotifier.updateWord(
                            wordModel.copyWith(
                              originalWord: originalController.text,
                              translatedWord: translatedController.text,
                              example: exampleController.text,
                              exampleTranslated:
                                  exampleTranslatedController.text,
                            ),
                          );

                          if (!editContext.mounted) return;
                          Navigator.of(editContext).pop();
                        },
                        child: Text(l10n.update,
                            style: TextStyle(
                                color: MyTheme.grey,
                                // fontWeight: FontWeight.bold,
                                fontSize: 24)),
                      ),
                    ],
                  ),
                ],
              ));
    }

    Future<void> handleTapFlag() async {
      await viewModelNotifier.changeFlag();
    }

    Future<void> handleTapSpeak(String word, TranslateLanguage lang) async {
      await ref.read(speakWordUsecaseProvider.notifier).execute(word, lang);
    }

    void handleTapDelete() {
      YesNoDialog.show(
          context: context,
          title: l10n.delete_check,
          noText: l10n.cancel,
          yesText: l10n.delete,
          onNoPressed: () {},
          onYesPressed: () async {
            try {
              await viewModelNotifier.deleteWord();
              if (!context.mounted) return;
              context.pop();
            } catch (e) {
              if (!context.mounted) return;
              await ErrorDialog.show(
                context: context,
                text: l10n.failed_delete,
              );
            }
          });
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: MyTheme.bgGradient,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
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
                  context.pop();
                }),
            actions: [buildFlag(handleTapFlag, viewModel.wordModel.flag)],
            backgroundColor: Colors.transparent,
          ),
          body: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                    child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 18,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 135,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                              color: Colors.white.withOpacity(0.15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: noticeBlock(
                                      60,
                                      viewModel.wordModel.noticeDuration,
                                      (forgettingDuration <
                                                  viewModel.wordModel
                                                      .noticeDuration) ||
                                              (viewModel.wordModel
                                                      .noticeDuration ==
                                                  99)
                                          ? MyTheme.lemon
                                          : MyTheme.orange,
                                      false),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 3,
                            height: 100,
                            color: Colors.black,
                          ),
                          Container(
                            height: 100,
                            width: 135,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                                color: Colors.white.withOpacity(0.15)),
                            child: Center(
                              child: buildDurationLabel(
                                  wordModel, l10n.last_update, l10n.today),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      AdBanner(width: MediaQuery.of(context).size.width),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 42.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await handleTapSpeak(
                                    viewModel.wordModel.originalWord,
                                    viewModel.wordModel.originalLang);
                              },
                              child: detailWordContent(
                                  l10n,
                                  ContentType.original,
                                  viewModel.wordModel.originalWord,
                                  () => handleTapSpeak(
                                      viewModel.wordModel.originalWord,
                                      viewModel.wordModel.originalLang)),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            detailWordContent(
                                l10n,
                                ContentType.translated,
                                viewModel.wordModel.translatedWord,
                                () => handleTapSpeak(
                                    viewModel.wordModel.translatedWord,
                                    viewModel.wordModel.translatedLang)),
                            const SizedBox(
                              height: 30,
                            ),
                            detailWordContent(
                                l10n,
                                ContentType.example,
                                viewModel.wordModel.example ?? '',
                                () => handleTapSpeak(
                                    viewModel.wordModel.example ?? '',
                                    viewModel.wordModel.originalLang)),
                            const SizedBox(
                              height: 30,
                            ),
                            detailWordContent(
                                l10n,
                                ContentType.exampleTranslated,
                                viewModel.wordModel.exampleTranslated ?? '',
                                () => handleTapSpeak(
                                    viewModel.wordModel.exampleTranslated ?? '',
                                    viewModel.wordModel.translatedLang)),
                            const SizedBox(
                              height: 40,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: LayoutBuilder(
                                  builder: (context, constraints) {
                                final width = constraints.maxWidth;
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    buildDeleteButton(width * 0.46,
                                        handleTapDelete, l10n.delete),
                                    buildEditButton(
                                        width * 0.46, handleTapEdit, l10n.edit),
                                  ],
                                );
                              }),
                            ),
                            const SizedBox(height: 32),
                            buildRegistrationDate(l10n.registration_date),
                            const SizedBox(
                              height: 70,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget detailWordContent(
    L10n l10n,
    ContentType type,
    String word,
    VoidCallback onTap,
  ) {
    final title = switch (type) {
      ContentType.original => l10n.original,
      ContentType.translated => l10n.translated,
      ContentType.example => l10n.example,
      ContentType.exampleTranslated => l10n.translated_example,
    };
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
            wordModel.originalLang.upperString,
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
            wordModel.translatedLang.upperString,
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
                child: Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(color: titleColor, fontSize: 18),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ),
            language
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: height,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.grey.shade600, width: 1.0))),
                child: AutoSizeText(
                  word,
                  maxLines: maxLines,
                  style: TextStyle(color: Colors.white, fontSize: fontSize),
                ),
              ),
            ),
            GestureDetector(
              onTap: onTap,
              child: const Padding(
                padding: EdgeInsets.all(3),
                child: FaIcon(
                  FontAwesomeIcons.volumeHigh,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildEditButton(
      double width, VoidCallback handleTapEdit, String text) {
    return KatiButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        handleTapEdit();
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
        alignment: const Alignment(0.75, 0.9),
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationX(0.5),
          child: Text(
            text,
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

  Widget buildDeleteButton(
      double width, VoidCallback handleTapDelete, String text) {
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
        alignment: const Alignment(0.65, 0.9),
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationX(0.5),
          child: Text(
            text,
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

  Widget buildFlag(VoidCallback handleTapFlag, bool flag) {
    return GestureDetector(
      onTap: () async {
        HapticFeedback.lightImpact();
        handleTapFlag();
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: flag
            ? Icon(Icons.flag_rounded, size: 49, color: MyTheme.lemon)
            : const Icon(Icons.outlined_flag_rounded,
                size: 46, color: Colors.grey),
      ),
    );
  }

  Widget buildRegistrationDate(String text) {
    return Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey.shade600, width: 1.0))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // change registration data
            Text(text,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
            const SizedBox(
              width: 12,
            ),
            Text(wordModel.registrationDate.toIso8601String().toYMDString(),
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
          ],
        ));
  }

  Widget buildDurationLabel(
      WordModel wordModel, String lastUpdate, String today) {
    final DateTime updateDateTime =
        DateTime.parse(wordModel.updateDate.toIso8601String());
    final int forgettingDuration =
        (updateDateTime.difference(DateTime.now()).inDays).abs();
    return SizedBox(
      width: 85,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(lastUpdate,
                  softWrap: false,
                  style: TextStyle(
                    height: 1.0,
                    color: Colors.grey.shade300,
                    fontSize: 13,
                    overflow: TextOverflow.fade,
                  )),
              Text(
                updateDateTime.toIso8601String().toYMDString(),
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 12,
                ),
              ),
              CustomPaint(
                size: const Size(80, 55),
                painter: DurationArrowPainter(today),
              )
            ],
          ),
          Align(
            alignment: const Alignment(0.0, 0.15),
            child: Text(forgettingDuration.toString(),
                style: TextStyle(
                    height: 1.0,
                    color: MyTheme.orange,
                    fontSize: 32,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class DurationArrowPainter extends CustomPainter {
  final String today;
  DurationArrowPainter(this.today);
  @override
  void paint(Canvas canvas, Size size) {
    const double offset = 8.0;

    final text = TextSpan(
      text: today,
      style: TextStyle(color: Colors.grey.shade300, fontSize: 15),
    );
    final textPainter = TextPainter(
      text: text,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final textSize = textPainter.size;
    textPainter.paint(canvas,
        Offset(size.width - textSize.width, size.height - textSize.height));

    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    final tipPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(offset, offset * 0.3);
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
