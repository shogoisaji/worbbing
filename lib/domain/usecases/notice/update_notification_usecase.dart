import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_repository.dart';
import 'package:worbbing/domain/entities/notice_data_model.dart';
import 'package:worbbing/domain/repositories/notification_repository.dart';
import 'package:worbbing/domain/repositories/word_list_repository.dart';
import 'package:worbbing/domain/usecases/notice/set_schedule_usecase.dart';

class UpdateNotificationUsecase {
  final NotificationRepository notificationRepository;
  final WordListRepository wordListRepository;
  final SharedPreferencesRepository sharedPreferencesRepository;

  UpdateNotificationUsecase(this.notificationRepository,
      this.wordListRepository, this.sharedPreferencesRepository);

  Future<void> execute(NoticeDataModel notice) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await notificationRepository.updateNotice(notice);
    await flutterLocalNotificationsPlugin.cancel(notice.noticeId!);
    final isEnabled = sharedPreferencesRepository
            .fetch<bool>(SharedPreferencesKey.noticedEnable) ??
        false;
    if (!isEnabled) return;
    await SetScheduleUsecase(wordListRepository).execute(notice);
  }
}
