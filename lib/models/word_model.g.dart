// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WordModelImpl _$$WordModelImplFromJson(Map<String, dynamic> json) =>
    _$WordModelImpl(
      id: json['id'] as String,
      originalWord: json['original_word'] as String,
      translatedWord: json['translated_word'] as String,
      noticeDuration: (json['notice_duration'] as num).toInt(),
      updateCount: (json['update_count'] as num).toInt(),
      updateDate: DateTime.parse(json['update_date'] as String),
      registrationDate: DateTime.parse(json['registration_date'] as String),
      flag: json['flag'] as bool? ?? false,
      memo: json['memo'] as String?,
    );

Map<String, dynamic> _$$WordModelImplToJson(_$WordModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'original_word': instance.originalWord,
      'translated_word': instance.translatedWord,
      'notice_duration': instance.noticeDuration,
      'update_count': instance.updateCount,
      'update_date': instance.updateDate.toIso8601String(),
      'registration_date': instance.registrationDate.toIso8601String(),
      'flag': instance.flag,
      'memo': instance.memo,
    };
