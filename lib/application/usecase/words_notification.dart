import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/repository/sqflite_repository.dart';
import 'package:worbbing/pages/config_page.dart';
import 'package:timezone/timezone.dart' as tz;

class WordsNotification {
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

  /// schedule notification
  Future<void> scheduleNotification(
      int notificationId, int selectedWordCount, TimeOfDay selectedTime) async {
    /// create notice word list
    List<WordModel> words =
        await SqfliteRepository.instance.getRandomWords(selectedWordCount);

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
}
