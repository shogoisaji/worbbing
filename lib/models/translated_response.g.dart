// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translated_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TranslatedResponseImpl _$$TranslatedResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$TranslatedResponseImpl(
      original: json['original'] as String,
      translated: (json['translated'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      example: json['example'] as String,
      exampleTranslated: json['example_translated'] as String,
      type: $enumDecode(_$TranslatedResponseTypeEnumMap, json['type']),
      originalLang:
          $enumDecode(_$TranslateLanguageEnumMap, json['original_lang']),
      translateLang:
          $enumDecode(_$TranslateLanguageEnumMap, json['translate_lang']),
    );

Map<String, dynamic> _$$TranslatedResponseImplToJson(
        _$TranslatedResponseImpl instance) =>
    <String, dynamic>{
      'original': instance.original,
      'translated': instance.translated,
      'example': instance.example,
      'example_translated': instance.exampleTranslated,
      'type': _$TranslatedResponseTypeEnumMap[instance.type]!,
      'original_lang': _$TranslateLanguageEnumMap[instance.originalLang]!,
      'translate_lang': _$TranslateLanguageEnumMap[instance.translateLang]!,
    };

const _$TranslatedResponseTypeEnumMap = {
  TranslatedResponseType.translated: 'translated',
  TranslatedResponseType.suggestion: 'suggestion',
};

const _$TranslateLanguageEnumMap = {
  TranslateLanguage.english: 'english',
  TranslateLanguage.japanese: 'japanese',
  TranslateLanguage.chinese: 'chinese',
  TranslateLanguage.korean: 'korean',
  TranslateLanguage.spanish: 'spanish',
  TranslateLanguage.french: 'french',
  TranslateLanguage.german: 'german',
  TranslateLanguage.italian: 'italian',
  TranslateLanguage.portuguese: 'portuguese',
};
