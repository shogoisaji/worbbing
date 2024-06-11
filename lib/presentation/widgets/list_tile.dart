import 'package:flutter/material.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/repository/sqflite_repository.dart';
import 'package:worbbing/models/notice_model.dart';
import 'package:worbbing/pages/detail_page.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/notice_block.dart';

class WordListTile extends StatefulWidget {
  final WordModel wordModel;
  final Function onDragEnd;

  static const HEIGHT = 90.0;

  const WordListTile({
    super.key,
    required this.wordModel,
    required this.onDragEnd,
  });

  @override
  State<WordListTile> createState() => _WordListTileState();
}

class _WordListTileState extends State<WordListTile>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;

  double? _dragStartX;
  double? _dragStartY;
  bool? _isOpening;
  Widget? _widget;

  Color? _color;

  onDragEnd() {
    widget.onDragEnd();
  }

  @override
  void initState() {
    super.initState();
    _color = MyTheme.lemon;
    _widget = titleText(widget.wordModel.translatedWord, Colors.black, null);
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: WordListTile.HEIGHT,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            color: _color,
            width: double.infinity,
            height: WordListTile.HEIGHT,
            child: _widget,
          ),
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.002, 0),
              end: const Offset(1, 0),
            ).animate(_animationController),
// slide page
            child: _SlideCard(
              wordModel: widget.wordModel,
            ),
          ),
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            final viewWidth = constraints.maxWidth;
            return GestureDetector(
              onHorizontalDragDown: (DragDownDetails details) {
                _clear();
              },
              onHorizontalDragStart: (DragStartDetails details) {
                final startX = details.localPosition.dx;
                final startY = details.localPosition.dy;
                final viewWidth = MediaQuery.of(context).size.width;
                if (startX <= viewWidth / 1.5) {
                  _dragStartX = startX;
                  _dragStartY = startY;
                  _isOpening = _animationController.value != 1.0;
                }
              },
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                final dragStartX = _dragStartX;
                final dragStartY = _dragStartY;
                final isOpening = _isOpening;
                if (dragStartX == null ||
                    dragStartY == null ||
                    isOpening == null) return;

                final newX = details.localPosition.dx;
                final newY = details.localPosition.dy;
                final diffX = newX - dragStartX;
                final diffY = newY - dragStartY;

                if (diffY > 100 && diffX > 80) {
                  setState(() {
                    _color = MyTheme.blue;
                    _widget = const Icon(
                      Icons.thumb_down,
                      color: Colors.white,
                      size: 48,
                    );
                  });
                } else if (diffY < -100 && diffX > 80) {
                  setState(() {
                    _color = MyTheme.orange;
                    _widget = const Icon(
                      Icons.thumb_up,
                      color: Colors.white,
                      size: 48,
                    );
                  });
                } else {
                  setState(() {
                    _color = MyTheme.lemon;
                    _widget = titleText(
                        widget.wordModel.translatedWord, Colors.black, 28);
                  });
                }

                _animationController.value =
                    (newX - dragStartX) / viewWidth * 1;
              },
              onHorizontalDragEnd: (details) async {
                _animationController.animateTo(0.0);

                /// I don't understand the word
                if (_color == MyTheme.blue) {
                  await SqfliteRepository.instance
                      .downDuration(widget.wordModel.id);
                  widget.onDragEnd();

                  /// I understand the word
                } else if (_color == MyTheme.orange) {
                  await SqfliteRepository.instance
                      .upDuration(widget.wordModel.id);
                  widget.onDragEnd();
                }
                setState(() {
                  _color = MyTheme.lemon;
                  _widget = titleText(
                      widget.wordModel.translatedWord, Colors.black, null);
                });
              },
              onHorizontalDragCancel: () {
                _clear();
              },
            );
          }),
        ],
      ),
    );
  }

  void _clear() {
    _dragStartX = null;
    _isOpening = null;
  }
}

class _SlideCard extends StatelessWidget {
  final WordModel wordModel;
  const _SlideCard({
    super.key,
    required this.wordModel,
  });

  @override
  Widget build(BuildContext context) {
    NoticeModel noticeDurationList = NoticeModel();
    final DateTime currentDateTime = DateTime.now();
    final int forgettingDuration =
        currentDateTime.difference(wordModel.updateDate).inDays;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      width: MediaQuery.of(context).size.width,
      height: WordListTile.HEIGHT,
      child: Stack(
        children: [
          Container(
              width: double.infinity,
              height: WordListTile.HEIGHT,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.1),
                    Colors.transparent,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailPage(id: wordModel.id)),
                            );
                          },
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width - 150,
                              child: titleText(
                                  wordModel.originalWord, null, null)))),
                  Row(
                    children: [
                      if (wordModel.flag)
                        const Icon(Icons.flag, color: Colors.white, size: 32),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: noticeBlock(
                              48,
                              wordModel.noticeDuration,
                              (forgettingDuration < wordModel.noticeDuration) ||
                                      (wordModel.noticeDuration == 00)
                                  ? MyTheme.lemon
                                  : MyTheme.orange)),
                    ],
                  )
                ],
              )),
        ],
      ),
    );
  }
}
