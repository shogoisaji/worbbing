import 'dart:async';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:worbbing/application/database.dart';
import 'package:worbbing/pages/main_page.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/frequency_dropdown.dart';
import 'package:worbbing/presentation/widgets/words_count_dropdown.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  bool notificationState = false;
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedFrequency = '1';
  String selectedWordCount = '1';

// permissions
  Future<void> _requestPermissions() async {
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

// test now show notification
  Future<void> _nowShowNotification() async {
    String notificationWord = '';
    List<Map> words = await DatabaseHelper.instance
        .getRandomWords(int.parse(selectedWordCount));
    words.forEach((row) {
      notificationWord += '・${row['original']}:${row['translated']} ';
    });
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

// notification
  Future<void> _scheduleNotification() async {
    String notificationWord = '';
    List<Map> words = await DatabaseHelper.instance
        .getRandomWords(int.parse(selectedWordCount));
    words.forEach((row) {
      notificationWord += '・${row['original']}:${row['translated']} ';
    });
    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'Worbbing',
      notificationWord,
      _nextInstance(),
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
  }

// notification time
  tz.TZDateTime _nextInstance() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
        now.day, selectedTime.hour, selectedTime.minute);
    // if (scheduledDate.isBefore(now)) {
    //   scheduledDate = scheduledDate.add(const Duration(minutes: 1));
    // }
    return scheduledDate;
  }

// update frequency
  void updateFrequency(String newValue) {
    setState(() {
      selectedFrequency = newValue;
    });
  }

// update word count
  void updateWordCount(String newValue) {
    setState(() {
      selectedWordCount = newValue;
    });
  }

// schedule time
  Widget scheduleTime(int index) {
    int hour = (selectedTime.hour + index * int.parse(selectedFrequency)) > 23
        ? (selectedTime.hour + index * int.parse(selectedFrequency)) - 24
        : (selectedTime.hour + index * int.parse(selectedFrequency));
    String text =
        '${hour.toString().padLeft(2, "0")}:${selectedTime.minute.toString().padLeft(2, "0")}';
    return mediumText(text, hour < 7 ? Colors.grey : Colors.white);
  }

// time select
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
          const SizedBox(
            height: 50,
          ),
          // title
          SizedBox(
            width: double.infinity,
            height: 80,
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(-0.89, -0.1),
                  child: InkWell(
                      child: Image.asset(
                        'assets/images/custom_arrow.png',
                        width: 35,
                        height: 35,
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const MainPage()),
                        );
                      }),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/config.png',
                    width: 200,
                  ),
                ),
              ],
            ),
          ),
          // body
// notification
          Container(
            // color: Colors.blue,
            margin: const EdgeInsets.only(top: 30),
            width: 300,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    mediumText('Notification', Colors.white),
                    Switch(
                      activeTrackColor: MyTheme.lemon,
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.white,
                      value: notificationState,
                      activeColor: MyTheme.grey,
                      onChanged: (bool value) {
                        setState(() {
                          notificationState = value;
                          if (notificationState) {
                            //
                          }
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  padding: EdgeInsets.only(top: 10, left: 25),
                  decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(
                            color: notificationState
                                ? Colors.white
                                : Colors.white30)),
                  ),
                  child: Column(
                    children: [
// frequency
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          mediumText(
                              'Frequency',
                              notificationState
                                  ? Colors.white
                                  : Colors.white30),
                          Container(
                            width: 70,
                            height: 50,
                            color: notificationState
                                ? Colors.white
                                : Colors.white30,
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 10,
                                  bottom: 3,
                                  child: mediumText(
                                    'h',
                                    Colors.black,
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: FrequencyDropdownWidget(
                                    onItemSelected: updateFrequency,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
// notification words count
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          mediumText(
                              'Words Count',
                              notificationState
                                  ? Colors.white
                                  : Colors.white30),
                          Container(
                            width: 70,
                            height: 50,
                            color: notificationState
                                ? Colors.white
                                : Colors.white30,
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 3,
                                  bottom: 3,
                                  child: bodyText(
                                    'wds',
                                    Colors.black,
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 15,
                                  child: WordsCountDropdownWidget(
                                    onItemSelected: updateWordCount,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      // notification time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          mediumText(
                              'Time',
                              notificationState
                                  ? Colors.white
                                  : Colors.white30),
                          GestureDetector(
                            onTap: () => _selectTime(context),
                            child: Container(
                              alignment: Alignment.center,
                              width: 90,
                              height: 50,
                              color: notificationState
                                  ? Colors.white
                                  : Colors.white30,
                              child: titleText(
                                  '${selectedTime.hour.toString().padLeft(2, "0")}:${selectedTime.minute.toString().padLeft(2, "0")}',
                                  Colors.black,
                                  null),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      // notification schedule
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          mediumText(
                              'Schedule',
                              notificationState
                                  ? Colors.white
                                  : Colors.white30),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // 24:00 ~ 6:00は除外
                      Stack(
                        children: [
                          Transform.translate(
                            offset: const Offset(5, 3.5),
                            child: Transform.rotate(
                              angle: 0.015,
                              child: Container(
                                width: 330,
                                height: 70,
                                color: MyTheme.lemon,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 7),
                            color: MyTheme.grey,
                            width: 330,
                            height: 70,
                            // color: Colors.blue,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 24 ~/ int.parse(selectedFrequency),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Transform.rotate(
                                    angle: 0.9,
                                    child: scheduleTime(index),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () async {
              await _requestPermissions();
              await _nowShowNotification();
            },
            child: Text('now show'),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () async {
              await _requestPermissions();
              await _scheduleNotification();
            },
            child: Text('schedule notice'),
          ),
        ])));
  }
}
