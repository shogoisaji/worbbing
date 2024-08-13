import 'package:worbbing/domain/entities/translate_language.dart';

enum TranslatedResponseType {
  translated,
  suggestion,
}

class TranslatedApiResponse {
  final String original;
  final List<String> translated;
  final String example;
  final String exampleTranslated;
  final String? comment;
  final TranslatedResponseType type;
  final TranslateLanguage originalLang;
  final TranslateLanguage translateLang;

  TranslatedApiResponse({
    required this.original,
    required this.translated,
    required this.example,
    required this.exampleTranslated,
    this.comment,
    required this.type,
    required this.originalLang,
    required this.translateLang,
  });

  factory TranslatedApiResponse.fromJson(Map<String, dynamic> json) {
    return TranslatedApiResponse(
      original: json['original'] as String,
      translated: List<String>.from(json['translated']),
      example: json['example'] as String,
      exampleTranslated: json['example_translated'] as String,
      comment: json['comment'] as String?,
      type: TranslatedResponseType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => TranslatedResponseType.translated,
      ),
      originalLang:
          TranslateLanguageExtension.fromString(json['original_lang']),
      translateLang:
          TranslateLanguageExtension.fromString(json['translate_lang']),
    );
  }
}
