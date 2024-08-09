import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:worbbing/domain/entities/translate_language.dart';
import 'package:worbbing/presentation/theme/theme.dart';

class LanguageDropdownVertical extends StatefulWidget {
  final TranslateLanguage translateLanguage;
  final TranslateLanguage originalLanguage;
  final Function(TranslateLanguage) onOriginalSelected;
  final Function(TranslateLanguage) onTranslateSelected;

  const LanguageDropdownVertical({
    super.key,
    required this.onOriginalSelected,
    required this.onTranslateSelected,
    required this.originalLanguage,
    required this.translateLanguage,
  });

  @override
  _LanguageDropdownVerticalState createState() =>
      _LanguageDropdownVerticalState();
}

class _LanguageDropdownVerticalState extends State<LanguageDropdownVertical> {
  late TranslateLanguage originalValue;
  late TranslateLanguage translateValue;

  @override
  void initState() {
    super.initState();
    originalValue = widget.originalLanguage;
    translateValue = widget.translateLanguage;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      originalValue = widget.originalLanguage;
      translateValue = widget.translateLanguage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 2, right: 2, top: 3, bottom: 0.5),
      decoration: BoxDecoration(
        color: const Color(0xFF26262D),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
          padding: const EdgeInsets.only(left: 7, right: 5, top: 7, bottom: 7),
          decoration: BoxDecoration(
            color: const Color(0xFF434D60),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 110,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: MyTheme.lemon, width: 1.5),
                    ),
                    child: OverflowBox(
                      maxHeight: double.infinity,
                      maxWidth: double.infinity,
                      child: DropdownButton<TranslateLanguage>(
                        onTap: () {
                          HapticFeedback.lightImpact();
                        },
                        dropdownColor: Colors.grey.shade800,
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.only(left: 24),
                        underline: const SizedBox.shrink(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                        iconEnabledColor: Colors.transparent,
                        value: originalValue,
                        onChanged: (TranslateLanguage? newValue) {
                          HapticFeedback.lightImpact();
                          setState(() {
                            originalValue = newValue!;
                            widget.onOriginalSelected(newValue);
                          });
                        },
                        items: TranslateLanguage.values
                            .map<DropdownMenuItem<TranslateLanguage>>(
                                (TranslateLanguage value) {
                          return DropdownMenuItem<TranslateLanguage>(
                            value: value,
                            child: Text(
                              value.upperString,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 110,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: MyTheme.orange, width: 1.5),
                    ),
                    child: OverflowBox(
                      maxHeight: double.infinity,
                      maxWidth: double.infinity,
                      child: DropdownButton<TranslateLanguage>(
                        onTap: () {
                          HapticFeedback.lightImpact();
                        },
                        dropdownColor: Colors.grey.shade600,
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.only(left: 24),
                        underline: const SizedBox.shrink(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                        iconEnabledColor: Colors.transparent,
                        value: translateValue,
                        onChanged: (TranslateLanguage? newValue) {
                          HapticFeedback.lightImpact();
                          setState(() {
                            translateValue = newValue!;
                            widget.onTranslateSelected(newValue);
                          });
                        },
                        items: TranslateLanguage.values
                            .map<DropdownMenuItem<TranslateLanguage>>(
                                (TranslateLanguage value) {
                          return DropdownMenuItem<TranslateLanguage>(
                            value: value,
                            child: Text(
                              value.upperString,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 5),
              Center(
                  child: SvgPicture.asset(
                'assets/svg/down_arrow.svg',
                width: 48,
                height: 52,
              )),
            ],
          )),
    );
  }
}
