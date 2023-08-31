import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:worbbing/pages/detail_page.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/notice_block.dart';

class WordListTile extends StatefulWidget {
  final String originalWord;
  final String translatedWord;
  final int noticeDuration;
  final bool flag;
  final int id;

  static const HEIGHT = 90.0;

  WordListTile(
      {super.key,
      required this.originalWord,
      required this.translatedWord,
      required this.noticeDuration,
      required this.flag,
      required this.id});

  @override
  State<WordListTile> createState() => _WordListTileState();
}

class _WordListTileState extends State<WordListTile>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;

  double? _dragStartX;
  bool? _isOpening;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: WordListTile.HEIGHT,
      child: Stack(
        children: [
          SizedBox(
              width: double.infinity,
              height: WordListTile.HEIGHT,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailPage(id: widget.id)),
                            );
                          },
                          child: titleText(widget.originalWord, null, null))),
                  Row(
                    children: [
                      if (widget.flag)
                        const Icon(Icons.flag, color: Colors.white, size: 32),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: noticeBlock(
                              48, widget.noticeDuration, MyTheme.lemon)),
                    ],
                  )
                ],
              )),
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
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: const Offset(0, 0),
            ).animate(_animationController),
// slide page
            child: _DrawerPage(
              translatedWord: widget.translatedWord,
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
                final viewWidth = MediaQuery.of(context).size.width;
                if (startX <= viewWidth / 2) {
                  _dragStartX = startX;
                  _isOpening = _animationController.value != 1.0;
                }
              },
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                final dragStartX = _dragStartX;
                final isOpening = _isOpening;
                if (dragStartX == null || isOpening == null) return;

                final newX = details.localPosition.dx;

                _animationController.value = newX / viewWidth * 1.5;
              },
              onHorizontalDragEnd: (details) {
                _animationController.animateTo(0.0);
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

class _DrawerPage extends StatelessWidget {
  final translatedWord;
  // final HEIGHT = 80.0;
  const _DrawerPage({
    super.key,
    required this.translatedWord,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 250,
          height: WordListTile.HEIGHT,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              color: Colors.white),
        ),
        Positioned(
          right: 5,
          child: Container(
            width: 250,
            height: WordListTile.HEIGHT,
            // change translated word
            child: Center(child: titleText(translatedWord, Colors.black, null)),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: MyTheme.orange),
          ),
        ),
      ],
    );
  }
}
