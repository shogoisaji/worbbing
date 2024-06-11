// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translated_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TranslatedResponseImpl _$$TranslatedResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$TranslatedResponseImpl(
      sourceLanguage: json['source_language'] as String,
      targetLanguage: json['target_language'] as String,
      original: json['original'] as String,
      translated: (json['translated'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      example: json['example'] as String,
      exampleTranslated: json['example_translated'] as String,
      suggestion: json['suggestion'] as String?,
    );

Map<String, dynamic> _$$TranslatedResponseImplToJson(
        _$TranslatedResponseImpl instance) =>
    <String, dynamic>{
      'source_language': instance.sourceLanguage,
      'target_language': instance.targetLanguage,
      'original': instance.original,
      'translated': instance.translated,
      'example': instance.example,
      'example_translated': instance.exampleTranslated,
      'suggestion': instance.suggestion,
    };
