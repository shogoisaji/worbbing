import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice_data_model.freezed.dart';
part 'notice_data_model.g.dart';

@freezed
class NoticeDataModel with _$NoticeDataModel {
  const factory NoticeDataModel({
    // ignore: invalid_annotation_target
    @JsonKey(name: 'notice_id') int? noticeId,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'word_id') required String wordId,
    required String original,
    required String translated,
    @TimeOfDayConverter() required TimeOfDay time,
  }) = _NoticeDataModel;

  factory NoticeDataModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeDataModelFromJson(json);
}

class TimeOfDayConverter implements JsonConverter<TimeOfDay, String> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(String json) {
    final parts = json.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  @override
  String toJson(TimeOfDay object) {
    return '${object.hour.toString().padLeft(2, '0')}:${object.minute.toString().padLeft(2, '0')}';
  }
}
