import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_repository.dart';
import 'package:worbbing/domain/entities/notice_data_model.dart';
import 'package:worbbing/domain/repositories/notification_repository.dart';
import 'package:worbbing/domain/repositories/word_list_repository.dart';
import 'package:worbbing/domain/usecases/notice/set_schedule_usecase.dart';

class SwitchEnableNotificationUsecase {
  final SharedPreferencesRepository sharedPreferencesRepository;
  final NotificationRepository notificationRepository;
  final WordListRepository wordListRepository;

  SwitchEnableNotificationUsecase(this.sharedPreferencesRepository,
      this.notificationRepository, this.wordListRepository);

  Future<void> execute() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    final currentIsEnabled = sharedPreferencesRepository
            .fetch<bool>(SharedPreferencesKey.noticedEnable) ??
        false;
    final switchedIsEnabled = !currentIsEnabled;
    await sharedPreferencesRepository.save<bool>(
        SharedPreferencesKey.noticedEnable, switchedIsEnabled);

    if (switchedIsEnabled) {
      List<NoticeDataModel> noticeList =
          await notificationRepository.getAllNotices();

      /// それぞれの通知を設定
      for (NoticeDataModel notice in noticeList) {
        SetScheduleUsecase(wordListRepository).execute(notice);
      }
    } else {
      await flutterLocalNotificationsPlugin.cancelAll();
    }
  }
}
