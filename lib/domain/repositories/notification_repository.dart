import 'package:worbbing/domain/entities/notice_data_model.dart';

abstract class NotificationRepository {
  Future<List<NoticeDataModel>> getAllNotices({bool isDesc = true});
  Future<NoticeDataModel> getNoticeById(int id);
  Future<int> addNotice(NoticeDataModel notice);
  Future<void> deleteNotice(int id);
  Future<void> updateNotice(NoticeDataModel noticeDataModel);
  Future<int> getTotalNotice();
}
