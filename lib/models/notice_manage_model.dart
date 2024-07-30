import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:worbbing/models/notice_data_model.dart';

part 'notice_manage_model.freezed.dart';
part 'notice_manage_model.g.dart';

@freezed
class NoticeManageModel with _$NoticeManageModel {
  const factory NoticeManageModel({
    @JsonKey(name: 'notice_enable') @Default(false) bool noticeEnable,
    @JsonKey(name: 'notice_list') @Default([]) List<NoticeDataModel> noticeList,
  }) = _NoticeManageModel;

  factory NoticeManageModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeManageModelFromJson(json);
}
