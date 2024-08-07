import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:worbbing/domain/repositories/notification_repository.dart';

class RemoveNotificationUsecase {
  final NotificationRepository notificationRepository;
  RemoveNotificationUsecase(this.notificationRepository);

  Future<void> execute(int noticeId) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await notificationRepository.deleteNotice(noticeId);
    await flutterLocalNotificationsPlugin.cancel(noticeId);
  }
}
