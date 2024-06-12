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
    );

Map<String, dynamic> _$$TranslatedResponseImplToJson(
        _$TranslatedResponseImpl instance) =>
    <String, dynamic>{
      'original': instance.original,
      'translated': instance.translated,
      'example': instance.example,
      'example_translated': instance.exampleTranslated,
      'type': _$TranslatedResponseTypeEnumMap[instance.type]!,
    };

const _$TranslatedResponseTypeEnumMap = {
  TranslatedResponseType.translated: 'translated',
  TranslatedResponseType.suggestion: 'suggestion',
};
