// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_manage_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoticeManageModelImpl _$$NoticeManageModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NoticeManageModelImpl(
      noticeEnable: json['notice_enable'] as bool? ?? false,
      noticeList: (json['notice_list'] as List<dynamic>?)
              ?.map((e) => NoticeDataModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$NoticeManageModelImplToJson(
        _$NoticeManageModelImpl instance) =>
    <String, dynamic>{
      'notice_enable': instance.noticeEnable,
      'notice_list': instance.noticeList,
    };
