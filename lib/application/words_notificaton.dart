import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:worbbing/repository/sqflite_repository.dart';
import 'package:worbbing/pages/config_page.dart';
import 'package:timezone/timezone.dart' as tz;

class WordsNotification {
  // permissions
  Future<void> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestPermission();
    }
  }

// sample notification
  Future<void> nowShowNotification(String selectedWordCount) async {
    List<Map> words = await SqfliteRepository.instance
        .getRandomWords(int.parse(selectedWordCount));
    await flutterLocalNotificationsPlugin.show(
      0,
      words[0]['original'],
      words[0]['translated'],
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
          badgeNumber: 1,
        ),
      ),
    );
  }

// schedule notification
  Future<void> scheduleNotification(int notificationId,
      String selectedWordCount, TimeOfDay selectedTime) async {
    // creat notice list
    List<Map> words = await SqfliteRepository.instance
        .getRandomWords(int.parse(selectedWordCount));

    for (int row = 0; row < words.length; row++) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId + row,
        words[row]['original'],
        words[row]['translated'],
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
            badgeNumber: 1,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        androidAllowWhileIdle: true,
      );
      debugPrint(
          "notificaton set time${notificationId + row} => ${selectedTime.hour}:${selectedTime.minute}");
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
