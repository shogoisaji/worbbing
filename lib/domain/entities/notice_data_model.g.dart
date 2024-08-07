// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoticeDataModelImpl _$$NoticeDataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NoticeDataModelImpl(
      noticeId: (json['notice_id'] as num?)?.toInt(),
      wordId: json['word_id'] as String,
      original: json['original'] as String,
      translated: json['translated'] as String,
      time: const TimeOfDayConverter().fromJson(json['time'] as String),
    );

Map<String, dynamic> _$$NoticeDataModelImplToJson(
        _$NoticeDataModelImpl instance) =>
    <String, dynamic>{
      'notice_id': instance.noticeId,
      'word_id': instance.wordId,
      'original': instance.original,
      'translated': instance.translated,
      'time': const TimeOfDayConverter().toJson(instance.time),
    };
