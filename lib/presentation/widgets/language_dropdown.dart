import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:worbbing/models/translate_language.dart';

class LanguageDropdownWidget extends StatefulWidget {
  final TranslateLanguage translateLanguage;
  final TranslateLanguage originalLanguage;
  final Function(TranslateLanguage) onOriginalSelected;
  final Function(TranslateLanguage) onTranslateSelected;
  final bool isHorizontal;

  const LanguageDropdownWidget({
    super.key,
    required this.onOriginalSelected,
    required this.onTranslateSelected,
    required this.originalLanguage,
    required this.translateLanguage,
    this.isHorizontal = false,
  });

  @override
  _LanguageDropdownWidgetState createState() => _LanguageDropdownWidgetState();
}

class _LanguageDropdownWidgetState extends State<LanguageDropdownWidget> {
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
      padding: const EdgeInsets.only(left: 6, right: 2, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: widget.isHorizontal ? Colors.transparent : Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: !widget.isHorizontal
          ? Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 120,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: OverflowBox(
                        maxHeight: double.infinity,
                        maxWidth: double.infinity,
                        child: DropdownButton<TranslateLanguage>(
                          onTap: () {
                            HapticFeedback.lightImpact();
                          },
                          dropdownColor: Colors.grey.shade700,
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.only(left: 10),
                          underline: const SizedBox.shrink(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
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
                                value.string,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 120,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: OverflowBox(
                        maxHeight: double.infinity,
                        maxWidth: double.infinity,
                        child: DropdownButton<TranslateLanguage>(
                          onTap: () {
                            HapticFeedback.lightImpact();
                          },
                          dropdownColor: Colors.grey.shade300,
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.only(left: 10),
                          underline: const SizedBox.shrink(),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
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
                                value.string,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const Center(
                    child: Icon(Icons.arrow_downward_rounded,
                        size: 32, color: Colors.white)),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 120,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: OverflowBox(
                    maxHeight: double.infinity,
                    maxWidth: double.infinity,
                    child: DropdownButton<TranslateLanguage>(
                      onTap: () {
                        HapticFeedback.lightImpact();
                      },
                      dropdownColor: Colors.grey.shade700,
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.only(left: 10),
                      underline: const SizedBox.shrink(),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
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
                            value.string,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const Center(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Icon(Icons.arrow_forward_rounded,
                      size: 32, color: Colors.white),
                )),
                Container(
                  width: 120,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: OverflowBox(
                    maxHeight: double.infinity,
                    maxWidth: double.infinity,
                    child: DropdownButton<TranslateLanguage>(
                      onTap: () {
                        HapticFeedback.lightImpact();
                      },
                      dropdownColor: Colors.grey.shade300,
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.only(left: 10),
                      underline: const SizedBox.shrink(),
                      style: const TextStyle(color: Colors.black, fontSize: 16),
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
                            value.string,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
