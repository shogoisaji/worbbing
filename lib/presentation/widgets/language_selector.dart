import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LanguageSelector<T> extends StatefulWidget {
  final String title;
  final Color color;
  final T initialLanguage;
  final List<T> languages;
  final Function(T) onSelect;
  final String Function(T) languageToString;
  const LanguageSelector(
      {super.key,
      required this.title,
      required this.initialLanguage,
      required this.color,
      required this.onSelect,
      required this.languages,
      required this.languageToString});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState<T> extends State<LanguageSelector<T>> {
  late T selectLang;

  @override
  void initState() {
    super.initState();
    selectLang = widget.initialLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 8, left: 18, right: 18),
        child: Container(
          padding:
              const EdgeInsets.only(top: 12, bottom: 0, left: 18, right: 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueGrey.shade800, Colors.blueGrey.shade900],
              begin: Alignment.topCenter,
              end: const Alignment(0.6, 1.0),
              stops: const [0.6, 2.0],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                width: 100,
                height: 3,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade600,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(widget.title,
                    style: TextStyle(fontSize: 28, color: widget.color)),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: widget.languages
                        .map((lang) => Center(
                              child: InkWell(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    selectLang = lang;
                                  });
                                  widget.onSelect(lang);
                                },
                                child: Center(
                                  child: Container(
                                    constraints: const BoxConstraints(
                                      maxWidth: 200,
                                    ),
                                    width: double.infinity,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 16),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: selectLang == lang
                                              ? widget.color
                                              : Colors.transparent,
                                          width: 2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(widget.languageToString(lang),
                                        style: const TextStyle(
                                            fontSize: 24, color: Colors.white)),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
