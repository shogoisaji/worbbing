import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worbbing/models/notice_model.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/repository/sqflite_repository.dart';
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

  // notification time
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
    List<WordModel> words = await SqfliteRepository.instance.getRandomWords(1);
    await flutterLocalNotificationsPlugin.show(
      0,
      words[0].originalWord,
      words[0].translatedWord,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'show notification', 'show notification',
          channelDescription: 'show notification',
          //saved => /android/app/src/main/res/drawable/notice_icon.png
          icon: 'drawable/notice_icon',
          importance: Importance.max,
          priority: Priority.max,
          // actions: [AndroidNotificationAction('1', 'ok')]
        ),
        iOS: DarwinNotificationDetails(
            // badgeNumber: 1,
            ),
      ),
    );
  }

  Future<void> setScheduleDetail(
      int notificationId, int wordCount, TimeOfDay selectedTime) async {
    List<WordModel> words =
        await SqfliteRepository.instance.getRandomWords(wordCount);

    for (int row = 0; row < words.length; row++) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId + row,
        words[row].originalWord,
        words[row].translatedWord,
        _nextInstance(selectedTime),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'worbbing schedule notice',
            'worbbing schedule notice',
            channelDescription: 'worbbing schedule notice',
            //saved => /android/app/src/main/res/drawable/notice_icon.png
            icon: 'drawable/notice_icon',
            importance: Importance.max,
            priority: Priority.max,
          ),
          iOS: DarwinNotificationDetails(
              // badgeNumber: 1,
              ),
        ),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        androidAllowWhileIdle: true,
      );
    }
  }

  /// schedule notification
  Future<void> setScheduleNotification(NoticeModel noticeModel) async {
    /// shared preferencesに保存
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('noticeModel', jsonEncode(noticeModel.toJson()));

    const setTimeCount = 3;

    /// 一度全ての通知をキャンセル
    await flutterLocalNotificationsPlugin.cancelAll();

    /// 通知が無効なら処理を中断
    if (!noticeModel.noticeEnable) return;

    /// それぞれの通知を設定
    for (int i = 0; i < setTimeCount; i++) {
      switch (i) {
        case 0:
          if (!noticeModel.time1Enable) continue;
          await setScheduleDetail((i + 1) * 10, noticeModel.selectedWordCount,
              noticeModel.selectedTime1);
        case 1:
          if (!noticeModel.time2Enable) continue;
          await setScheduleDetail((i + 1) * 10, noticeModel.selectedWordCount,
              noticeModel.selectedTime2);
        case 2:
          if (!noticeModel.time3Enable) continue;
          await setScheduleDetail((i + 1) * 10, noticeModel.selectedWordCount,
              noticeModel.selectedTime3);
      }
    }
  }

  Future<NoticeModel> loadCurrentNoticeData() async {
    final prefs = await SharedPreferences.getInstance();
    final noticeModelJson = prefs.getString('noticeModel');
    if (noticeModelJson == null) {
      return const NoticeModel();
    }
    final noticeModel = NoticeModel.fromJson(jsonDecode(noticeModelJson));
    return noticeModel;
  }

  Future<void> saveNoticeData(NoticeModel noticeModel) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('noticeModel', jsonEncode(noticeModel.toJson()));
  }

  /// notice tap callback
  Future<void> shuffleNotification() async {
    final currentNoticeModel = await loadCurrentNoticeData();
    await setScheduleNotification(currentNoticeModel);
  }
}
