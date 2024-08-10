import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:worbbing/domain/entities/translate_language.dart';
import 'package:worbbing/presentation/theme/theme.dart';

enum LangType {
  original,
  translate,
}

class LanguageDropdownVertical extends StatefulWidget {
  final TranslateLanguage translateLanguage;
  final TranslateLanguage originalLanguage;
  final Function() onTapOriginal;
  final Function() onTapTranslate;
  final bool isError;
  final double width;

  const LanguageDropdownVertical({
    super.key,
    required this.onTapOriginal,
    required this.onTapTranslate,
    required this.originalLanguage,
    required this.translateLanguage,
    this.isError = false,
    this.width = 110,
  });

  @override
  _LanguageDropdownVerticalState createState() =>
      _LanguageDropdownVerticalState();
}

class _LanguageDropdownVerticalState extends State<LanguageDropdownVertical>
    with SingleTickerProviderStateMixin {
  late TranslateLanguage originalValue;
  late TranslateLanguage translateValue;

  late AnimationController _animationController;

  final AutoSizeGroup autoSizeGroup = AutoSizeGroup();

  void _callError() {
    _animationController.forward().then((_) {
      _animationController.reverse().then((_) {
        _animationController.forward().then((_) {
          _animationController.reverse();
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    originalValue = widget.originalLanguage;
    translateValue = widget.translateLanguage;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LanguageDropdownVertical oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isError) {
      _callError();
    }
    if (widget.originalLanguage != originalValue ||
        widget.translateLanguage != translateValue) {
      originalValue = widget.originalLanguage;
      translateValue = widget.translateLanguage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            width: widget.width,
            // height: 120,
            padding:
                const EdgeInsets.only(left: 2, right: 2, top: 3, bottom: 0.5),
            decoration: BoxDecoration(
              color: const Color(0xFF26262D),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: MyTheme.red.withOpacity(_animationController.value),
                  blurRadius: 3,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Container(
                width: double.infinity,
                // height: double.infinity,
                padding: const EdgeInsets.only(
                    left: 8, right: 12, top: 8, bottom: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF434D60),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextContainer(
                                    originalValue.upperString,
                                    widget.onTapOriginal,
                                    MyTheme.lemon),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextContainer(
                                    translateValue.upperString,
                                    widget.onTapTranslate,
                                    MyTheme.orange),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Center(
                        child: SvgPicture.asset(
                      'assets/svg/down_arrow.svg',
                      width: widget.width / 3.5,
                      height: widget.width / 3.5,
                    )),
                  ],
                )),
          );
        });
  }

  Widget _buildTextContainer(String text, Function() onTap, Color color) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: color, width: 1.5),
          ),
          child: AutoSizeText(text,
              group: autoSizeGroup,
              style: const TextStyle(color: Colors.white, fontSize: 20))),
    );
  }
}
