import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:worbbing/models/notice_data_model.dart';
import 'package:worbbing/models/notice_manage_model.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_repository.dart';
import 'package:worbbing/repository/sqflite/notification_repository.dart';
import 'package:worbbing/repository/sqflite/sqflite_repository.dart';
import 'package:worbbing/pages/notice_page.dart';
import 'package:timezone/timezone.dart' as tz;

class NoticeUsecase {
  /// permissions
  Future<void> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            // badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            // badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestNotificationsPermission();
    }
  }

  Future<bool> checkNotificationPermissions() async {
    if (Platform.isIOS) {
      final IOSFlutterLocalNotificationsPlugin? iosImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      final settings = await iosImplementation?.checkPermissions();
      if (settings != null) {
        return settings.isAlertEnabled;
      }
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final bool? areEnabled =
          await androidImplementation?.areNotificationsEnabled();
      return areEnabled ?? false;
    }
    return false;
  }

  /// set next notification time
  tz.TZDateTime _nextInstance(TimeOfDay selectedTime) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
        now.day, selectedTime.hour, selectedTime.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  /// sample notification
  Future<void> sampleNotification() async {
    WordModel word = await SqfliteRepository.instance.getRandomWord();
    await flutterLocalNotificationsPlugin.show(
      2147483647,
      word.originalWord,
      word.translatedWord,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'show notification',
          'show notification',
          channelDescription: 'show notification',
          icon: 'drawable/notice_icon',
          importance: Importance.max,
          priority: Priority.max,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: 'notice_tap',
    );
  }

  /// スマートフォンへ通知を設定
  Future<void> setNotificationSchedule(NoticeDataModel noticeDataModel) async {
    if (noticeDataModel.noticeId == null) {
      throw Exception('noticeId is null');
    }

    WordModel word = await SqfliteRepository.instance.getRandomWord();

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

  /// 通知単語をシャッフル
  Future<void> shuffleNotifications() async {
    final List<NoticeDataModel> list =
        await NotificationRepository.instance.queryAllRows();
    for (int i = 0; i < list.length; i++) {
      final WordModel newWord =
          await SqfliteRepository.instance.getRandomWord();
      final NoticeDataModel newNotice = list[i].copyWith(
          original: newWord.originalWord, translated: newWord.translatedWord);
      await updateNotice(newNotice);
    }
  }

  Future<void> switchEnable(bool isEnable) async {
    await SharedPreferencesRepository()
        .save<bool>(SharedPreferencesKey.noticeEnable, isEnable);
    if (isEnable) {
      await setAllScheduleNotification();
    } else {
      await cancelAllNotification();
    }
  }

  Future<void> addNotice(TimeOfDay time) async {
    final word = await SqfliteRepository.instance.getRandomWord();
    final NoticeDataModel notice = NoticeDataModel(
      noticeId: null,
      wordId: word.id,
      original: word.originalWord,
      translated: word.translatedWord,
      time: time,
    );
    final id = await NotificationRepository.instance.insertData(notice);
    final isEnable = SharedPreferencesRepository().fetch<bool>(
          SharedPreferencesKey.noticeEnable,
        ) ??
        false;
    if (!isEnable) return;
    await setNotificationSchedule(notice.copyWith(noticeId: id));
  }

  Future<void> removeNotice(int noticeId) async {
    await NotificationRepository.instance.deleteRow(noticeId);
    await cancelNotification(noticeId);
  }

  Future<void> updateNotice(NoticeDataModel notice) async {
    await NotificationRepository.instance.updateNoticeTime(notice);
    await cancelNotification(notice.noticeId!);
    final isEnable = SharedPreferencesRepository().fetch<bool>(
          SharedPreferencesKey.noticeEnable,
        ) ??
        false;
    if (!isEnable) return;
    await setNotificationSchedule(notice);
  }

  /// 全ての通知を設定
  Future<void> setAllScheduleNotification() async {
    NoticeManageModel noticeList = await loadNoticeData();

    /// それぞれの通知を設定
    for (NoticeDataModel notice in noticeList.noticeList) {
      await setNotificationSchedule(notice);
    }
  }

  Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> cancelNotification(int noticeId) async {
    await flutterLocalNotificationsPlugin.cancel(noticeId);
  }

  Future<NoticeManageModel> loadNoticeData() async {
    final isEnable = SharedPreferencesRepository()
            .fetch<bool>(SharedPreferencesKey.noticeEnable) ??
        false;
    List<NoticeDataModel> noticeList =
        await NotificationRepository.instance.queryAllRows();
    return NoticeManageModel(noticeEnable: isEnable, noticeList: noticeList);
  }
}
