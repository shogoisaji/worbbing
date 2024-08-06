import 'package:worbbing/models/notice_data_model.dart';

abstract class NotificationRepository {
  Future<List<NoticeDataModel>> getAllNotice({bool isDesc = true});
  Future<NoticeDataModel> getNoticeById(int id);
  Future<void> deleteNotice(int id);
  Future<void> updateNotice(NoticeDataModel noticeDataModel);
  Future<int> getTotalNotice();
}
