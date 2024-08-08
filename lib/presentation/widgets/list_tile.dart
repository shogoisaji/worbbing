import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:worbbing/domain/entities/word_model.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/notice_block.dart';
import 'package:auto_size_text/auto_size_text.dart';

const _listTileHeight = 87.0;

class WordListTile extends StatefulWidget {
  final WordModel wordModel;
  final VoidCallback onWordUpdate;
  final VoidCallback onTapList;
  final bool isEnabledSlideHint;
  final VoidCallback onUpDuration;
  final VoidCallback onDownDuration;

  const WordListTile({
    super.key,
    required this.wordModel,
    required this.onWordUpdate,
    required this.onTapList,
    required this.isEnabledSlideHint,
    required this.onUpDuration,
    required this.onDownDuration,
  });

  @override
  State<WordListTile> createState() => _WordListTileState();
}

class _WordListTileState extends State<WordListTile>
    with SingleTickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();

  late final AnimationController _animationController;

  static const double _dragRangeX = 80.0;
  static const double _dragRangeY = 85.0;

  bool _isDragEnd = false;

  double? _dragStartX;
  double? _dragStartY;
  Widget _widget = const SizedBox.shrink();
  Color _color = MyTheme.lemon;

  onWordUpdate() {
    widget.onWordUpdate();
  }

  Widget _translatedWord() {
    return AutoSizeText(widget.wordModel.translatedWord,
        maxLines: 1, style: const TextStyle(color: Colors.black, fontSize: 26));
  }

  void _dragReset() {
    _dragStartX = null;
  }

  OverlayEntry? overlay;

  void _showHint(
    BuildContext context,
    Offset position,
  ) {
    if (overlay != null || !widget.isEnabledSlideHint) return;
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    final offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    overlay = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            HintWidget(position: offset, isDragEnd: _isDragEnd),
          ],
        );
      },
    );

    Overlay.of(context).insert(overlay!);
  }

  void removeOverlay() {
    overlay?.remove();
    overlay = null;
  }

  @override
  void initState() {
    super.initState();
    _widget = _translatedWord();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
  }

  @override
  void dispose() {
    _animationController.dispose();
    removeOverlay();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WordListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.wordModel != oldWidget.wordModel) {
      setState(() {
        _widget = _translatedWord();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: _key,
      height: _listTileHeight,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            color: _color,
            width: double.infinity,
            height: _listTileHeight,
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
              onTap: () async {
                HapticFeedback.lightImpact();
                widget.onTapList();
              },
              onHorizontalDragStart: (DragStartDetails details) {
                _dragReset();
                final startX = details.localPosition.dx;
                final startY = details.localPosition.dy;
                final viewWidth = MediaQuery.of(context).size.width;
                if (startX <= viewWidth / 1.5) {
                  _dragStartX = startX;
                  _dragStartY = startY;
                }
                _isDragEnd = false;
              },
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                final dragStartX = _dragStartX;
                final dragStartY = _dragStartY;
                if (dragStartX == null || dragStartY == null) return;

                final newX = details.localPosition.dx;
                final newY = details.localPosition.dy;
                final diffX = newX - dragStartX;
                final diffY = newY - dragStartY;

                if (diffX > _dragRangeX) {
                  _showHint(context, details.localPosition);
                }

                if (diffY > _dragRangeY && diffX > _dragRangeX) {
                  if (_color != MyTheme.blue) {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _color = MyTheme.blue;
                      _widget = const Icon(
                        Icons.thumb_down,
                        color: Colors.white,
                        size: 48,
                      );
                    });
                  }
                } else if (diffY < -_dragRangeY && diffX > _dragRangeX) {
                  if (_color != MyTheme.orange) {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _color = MyTheme.orange;
                      _widget = const Icon(
                        Icons.thumb_up,
                        color: Colors.white,
                        size: 48,
                      );
                    });
                  }
                } else {
                  if (_color != MyTheme.lemon) {
                    setState(() {
                      _color = MyTheme.lemon;
                      _widget = _translatedWord();
                    });
                  }
                }

                _animationController.value =
                    (newX - dragStartX) / viewWidth * 1;
              },
              onHorizontalDragEnd: (details) async {
                _animationController.animateTo(0.0);

                /// I don't understand the word
                if (_color == MyTheme.blue) {
                  widget.onDownDuration();

                  /// I understand the word
                } else if (_color == MyTheme.orange) {
                  widget.onUpDuration();
                }
                setState(() {
                  _color = MyTheme.lemon;
                  _widget = _translatedWord();
                  _isDragEnd = true;
                });
                overlay?.markNeedsBuild();
                Future.delayed(const Duration(milliseconds: 400), () {
                  removeOverlay();
                });
              },
              onHorizontalDragCancel: () {
                _dragReset();
                removeOverlay();
              },
            );
          }),
        ],
      ),
    );
  }
}

class _SlideCard extends StatelessWidget {
  final WordModel wordModel;
  const _SlideCard({
    required this.wordModel,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime currentDateTime = DateTime.now();
    final int forgettingDuration =
        currentDateTime.difference(wordModel.updateDate).inDays;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      width: MediaQuery.of(context).size.width,
      height: _listTileHeight,
      child: Stack(
        children: [
          Container(
              width: double.infinity,
              height: _listTileHeight,
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
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width - 150,
                          child:
                              titleText(wordModel.originalWord, null, null))),
                  Row(
                    children: [
                      if (wordModel.flag)
                        const Icon(Icons.flag_rounded,
                            color: Colors.white, size: 32),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: noticeBlock(
                              48,
                              wordModel.noticeDuration,
                              (forgettingDuration < wordModel.noticeDuration) ||
                                      (wordModel.noticeDuration == 99)
                                  ? MyTheme.lemon
                                  : MyTheme.orange,
                              forgettingDuration >= wordModel.noticeDuration)),
                    ],
                  )
                ],
              )),
        ],
      ),
    );
  }
}

class HintWidget extends StatefulWidget {
  final Offset position;
  final bool isDragEnd;
  const HintWidget(
      {super.key, required this.position, required this.isDragEnd});

  @override
  State<HintWidget> createState() => _HintWidgetState();
}

class _HintWidgetState extends State<HintWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final double _hintSize = 50.0;
  final double _spacerX = 30.0;
  final double _spacerY = 10.0;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400))
      ..forward();
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HintWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDragEnd != oldWidget.isDragEnd) {
      if (widget.isDragEnd) {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx + _spacerX,
      top: widget.position.dy - _hintSize - _spacerY,
      child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Opacity(
              opacity: _animation.value,
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/svg/good.svg',
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(height: _spacerY),
                  const SizedBox(height: _listTileHeight),
                  SizedBox(height: _spacerY),
                  SvgPicture.asset(
                    'assets/svg/bad.svg',
                    width: 50,
                    height: 50,
                  )
                ],
              ),
            );
          }),
    );
  }
}
