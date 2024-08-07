import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:worbbing/domain/entities/notice_data_model.dart';
import 'package:worbbing/domain/repositories/word_list_repository.dart';
import 'package:worbbing/models/word_model.dart';

import 'package:timezone/timezone.dart' as tz;

class SetScheduleUsecase {
  SetScheduleUsecase(this.wordListRepository);
  final WordListRepository wordListRepository;

  Future<void> execute(NoticeDataModel noticeDataModel) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (noticeDataModel.noticeId == null) {
      throw Exception('noticeId is null');
    }

    WordModel? word = await wordListRepository.getRandomWord();

    if (word == null) {
      return;
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      noticeDataModel.noticeId!,
      word.originalWord,
      word.translatedWord,
      _nextInstance(noticeDataModel.time),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'worbbing schedule notice',
          'worbbing schedule notice',
          channelDescription: 'worbbing schedule notice',
          icon: 'drawable/notice_icon',
          importance: Importance.max,
          priority: Priority.max,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exact,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstance(TimeOfDay selectedTime) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
        now.day, selectedTime.hour, selectedTime.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
