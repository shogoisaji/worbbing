import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:worbbing/application/database.dart';
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
    String notificationWord = '';
    List<Map> words = await DatabaseHelper.instance
        .getRandomWords(int.parse(selectedWordCount));
    for (var row in words) {
      notificationWord += '・${row['original']}:${row['translated']} ';
    }
    await flutterLocalNotificationsPlugin.show(
      0,
      'Worbbing',
      notificationWord,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'show notification',
          'show notification',
          channelDescription: 'show notification',
          icon: 'mipmap/ic_launcher',
          importance: Importance.max,
          priority: Priority.max,
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
    String notificationWord = '';
    List<Map> words = await DatabaseHelper.instance
        .getRandomWords(int.parse(selectedWordCount));
    for (var row in words) {
      // notification body add text
      notificationWord += '・${row['original']}:${row['translated']} ';
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      'Worbbing',
      notificationWord,
      _nextInstance(selectedTime),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'schedule notification',
          'schedule notification',
          channelDescription: 'schedule notification',
          icon: 'mipmap/ic_launcher',
          importance: Importance.max,
          priority: Priority.max,
        ),
        iOS: DarwinNotificationDetails(
          badgeNumber: 1,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidAllowWhileIdle: true,
    );
    debugPrint(
        "notificaton set time$notificationId => ${selectedTime.hour}:${selectedTime.minute}");
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
