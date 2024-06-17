import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice_model.freezed.dart';
part 'notice_model.g.dart';

@freezed
class NoticeModel with _$NoticeModel {
  const factory NoticeModel({
    @Default(false) bool noticeEnable,
    @Default(1) int selectedWordCount,
    @Default(false) bool time1Enable,
    @Default(false) bool time2Enable,
    @Default(false) bool time3Enable,
    @TimeOfDayConverter()
    @Default(TimeOfDay(hour: 0, minute: 0))
    TimeOfDay selectedTime1,
    @TimeOfDayConverter()
    @Default(TimeOfDay(hour: 0, minute: 0))
    TimeOfDay selectedTime2,
    @TimeOfDayConverter()
    @Default(TimeOfDay(hour: 0, minute: 0))
    TimeOfDay selectedTime3,
  }) = _NoticeModel;

  factory NoticeModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeModelFromJson(json);
}

class TimeOfDayConverter
    implements JsonConverter<TimeOfDay, Map<String, dynamic>> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(Map<String, dynamic> json) {
    return TimeOfDay(hour: json['hour'] as int, minute: json['minute'] as int);
  }

  @override
  Map<String, int> toJson(TimeOfDay time) => {
        'hour': time.hour,
        'minute': time.minute,
      };
}
