// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoticeModelImpl _$$NoticeModelImplFromJson(Map<String, dynamic> json) =>
    _$NoticeModelImpl(
      noticeEnable: json['noticeEnable'] as bool? ?? false,
      selectedWordCount: (json['selectedWordCount'] as num?)?.toInt() ?? 1,
      time1Enable: json['time1Enable'] as bool? ?? false,
      time2Enable: json['time2Enable'] as bool? ?? false,
      time3Enable: json['time3Enable'] as bool? ?? false,
      selectedTime1: json['selectedTime1'] == null
          ? const TimeOfDay(hour: 0, minute: 0)
          : const TimeOfDayConverter()
              .fromJson(json['selectedTime1'] as Map<String, dynamic>),
      selectedTime2: json['selectedTime2'] == null
          ? const TimeOfDay(hour: 0, minute: 0)
          : const TimeOfDayConverter()
              .fromJson(json['selectedTime2'] as Map<String, dynamic>),
      selectedTime3: json['selectedTime3'] == null
          ? const TimeOfDay(hour: 0, minute: 0)
          : const TimeOfDayConverter()
              .fromJson(json['selectedTime3'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$NoticeModelImplToJson(_$NoticeModelImpl instance) =>
    <String, dynamic>{
      'noticeEnable': instance.noticeEnable,
      'selectedWordCount': instance.selectedWordCount,
      'time1Enable': instance.time1Enable,
      'time2Enable': instance.time2Enable,
      'time3Enable': instance.time3Enable,
      'selectedTime1':
          const TimeOfDayConverter().toJson(instance.selectedTime1),
      'selectedTime2':
          const TimeOfDayConverter().toJson(instance.selectedTime2),
      'selectedTime3':
          const TimeOfDayConverter().toJson(instance.selectedTime3),
    };
