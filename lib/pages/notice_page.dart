import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:worbbing/application/usecase/words_notification.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_button.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/my_simple_dialog.dart';
import 'package:worbbing/presentation/widgets/words_count_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_settings/app_settings.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

class NoticePage extends StatefulWidget {
  const NoticePage({super.key});

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  bool notificationState = false;
  bool time1State = false;
  bool time2State = false;
  bool time3State = false;
  TimeOfDay selectedTime1 = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay selectedTime2 = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay selectedTime3 = const TimeOfDay(hour: 0, minute: 0);
  int selectedWordsCount = 1;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initPrefs();
    loadData();
  }

// <shared preferences data list>
  // 'notificationState'
  // 'selectedWordsCount'
  // 'time1State'
  // 'time2State'
  // 'time3State'
  // 'selectedTime1'
  // 'selectedTime2'
  // 'selectedTime3'

// shared preferences init
  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void handleTapSample() async {
    await WordsNotification().requestPermissions();
    final isEnable = await WordsNotification().checkNotificationPermissions();
    if (!isEnable) {
      await showNoticePermissionDialog();
      return;
    }
    if (!isEnable) {
      await showNoticePermissionDialog();
      return;
    }
    await WordsNotification().sampleNotification();
  }

// shared preferences save data
  void saveData<T>(String key, T value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is TimeOfDay) {
      prefs.setInt('${key}hour', value.hour);
      prefs.setInt('${key}minute', value.minute);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is int) {
      prefs.setInt(key, value);
    }
  }

// shared preferences load data
  void loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationState = prefs.getBool('notificationState') ?? false;
      selectedWordsCount = prefs.getInt('selectedWordCount') ?? 1;
      time1State = prefs.getBool('time1State') ?? false;
      time2State = prefs.getBool('time2State') ?? false;
      time3State = prefs.getBool('time3State') ?? false;
      selectedTime1 = TimeOfDay(
          hour: prefs.getInt('selectedTime1hour') ?? 0,
          minute: prefs.getInt('selectedTime1minute') ?? 0);
      selectedTime2 = TimeOfDay(
          hour: prefs.getInt('selectedTime2hour') ?? 0,
          minute: prefs.getInt('selectedTime2minute') ?? 0);
      selectedTime3 = TimeOfDay(
          hour: prefs.getInt('selectedTime3hour') ?? 0,
          minute: prefs.getInt('selectedTime3minute') ?? 0);
    });
  }

  /// update words count
  void updateWordCount(int newValue) async {
    setState(() {
      selectedWordsCount = newValue;
      saveData('selectedWordCount', newValue);
    });
    if (notificationState) {
      if (notificationState && time1State) {
        await WordsNotification()
            .scheduleNotification(10, selectedWordsCount, selectedTime1);
      }
      if (notificationState && time2State) {
        await WordsNotification()
            .scheduleNotification(20, selectedWordsCount, selectedTime2);
      }
      if (notificationState && time3State) {
        await WordsNotification()
            .scheduleNotification(30, selectedWordsCount, selectedTime3);
      }
    }
  }

  Future<void> showNoticePermissionDialog() async {
    MySimpleDialog.show(
        context,
        const Text(
          'Notification permission is OFF.\nPlease turn ON notification permission.',
          style: TextStyle(
              overflow: TextOverflow.clip, color: Colors.white, fontSize: 20),
        ),
        'Go Settings', () {
      AppSettings.openAppSettings();
    });
  }

// time select
  Future<void> _selectTime(BuildContext context, int timeTypeNumber) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dialOnly,
    );
    if (picked != null) {
      switch (timeTypeNumber) {
        case 10:
          setState(() {
            selectedTime1 = picked;
            saveData('selectedTime1', selectedTime1);
          });
          if (notificationState) {
            await WordsNotification().scheduleNotification(
                timeTypeNumber, selectedWordsCount, selectedTime1);
          }
        case 20:
          setState(() {
            selectedTime2 = picked;
            saveData('selectedTime2', selectedTime2);
          });
          if (notificationState) {
            await WordsNotification().scheduleNotification(
                timeTypeNumber, selectedWordsCount, selectedTime2);
          }
        case 30:
          setState(() {
            selectedTime3 = picked;
            saveData('selectedTime3', selectedTime3);
          });
          if (notificationState) {
            await WordsNotification().scheduleNotification(
                timeTypeNumber, selectedWordsCount, selectedTime3);
          }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/notice.png',
              width: 120,
            ),
          ),
          leading: InkWell(
              child: Align(
                child: Image.asset(
                  'assets/images/custom_arrow.png',
                  width: 35,
                  height: 35,
                ),
              ),
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              const SizedBox(
                height: 20,
              ),
// notification
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  width: 300,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Random word \nNotifications',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500)),
                          Switch(
                            activeTrackColor: MyTheme.lemon,
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.white,
                            value: notificationState,
                            activeColor: MyTheme.grey,
                            onChanged: (bool value) async {
                              HapticFeedback.lightImpact();
                              if (value) {
                                final isEnable = await WordsNotification()
                                    .checkNotificationPermissions();
                                if (!isEnable) {
                                  await showNoticePermissionDialog();
                                  return;
                                }
                              }
                              setState(() {
                                notificationState = value;
                                saveData(
                                    'notificationState', notificationState);
                              });
                              if (notificationState) {
                                if (time1State) {
                                  await WordsNotification()
                                      .scheduleNotification(10,
                                          selectedWordsCount, selectedTime1);
                                }
                                if (time2State) {
                                  await WordsNotification()
                                      .scheduleNotification(20,
                                          selectedWordsCount, selectedTime1);
                                }
                                if (time3State) {
                                  await WordsNotification()
                                      .scheduleNotification(30,
                                          selectedWordsCount, selectedTime1);
                                }
                              } else {
                                await flutterLocalNotificationsPlugin
                                    .cancelAll();
                              }
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // vertical line
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        padding: const EdgeInsets.only(top: 10, left: 25),
                        decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(
                                  color: notificationState
                                      ? Colors.white
                                      : Colors.white30)),
                        ),
                        child: Column(
                          children: [
                            // notification words count
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                mediumText(
                                    'Word Count',
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
                                      // Positioned(
                                      //     top: 3,
                                      //     left: 15,
                                      //     child: titleText(
                                      //         selectedWordsCount, Colors.black, 32)),
                                      Positioned(
                                        top: 5,
                                        right: 15,
                                        child: WordsCountDropdownWidget(
                                          selectedWordsCount:
                                              selectedWordsCount,
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
                            // notification time1
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    HapticFeedback.lightImpact();
                                    setState(() {
                                      time1State = !time1State;
                                      saveData('time1State', time1State);
                                    });
                                    if (notificationState && time1State) {
                                      await WordsNotification()
                                          .scheduleNotification(
                                              10,
                                              selectedWordsCount,
                                              selectedTime1);
                                    }
                                    if (!time1State) {
                                      await flutterLocalNotificationsPlugin
                                          .cancel(1);
                                      debugPrint('canceled time1');
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      if (notificationState && time1State)
                                        const Icon(Icons.radio_button_checked,
                                            color: Colors.white, size: 20)
                                      else
                                        Icon(Icons.circle_outlined,
                                            color: MyTheme.grey, size: 20),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 6.0, left: 10),
                                        child: mediumText(
                                            'Time1',
                                            notificationState && time1State
                                                ? Colors.white
                                                : Colors.white30),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _selectTime(context, 10),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 90,
                                    height: 50,
                                    color: notificationState && time1State
                                        ? Colors.white
                                        : Colors.white30,
                                    child: titleText(
                                        '${selectedTime1.hour.toString().padLeft(2, "0")}:${selectedTime1.minute.toString().padLeft(2, "0")}',
                                        Colors.black,
                                        null),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            // notification time2
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    HapticFeedback.lightImpact();
                                    setState(() {
                                      time2State = !time2State;
                                      saveData('time2State', time2State);
                                    });
                                    if (notificationState && time2State) {
                                      await WordsNotification()
                                          .scheduleNotification(
                                              20,
                                              selectedWordsCount,
                                              selectedTime2);
                                    }
                                    if (!time2State) {
                                      await flutterLocalNotificationsPlugin
                                          .cancel(2);
                                      debugPrint('canceled time2');
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      if (notificationState && time2State)
                                        const Icon(Icons.radio_button_checked,
                                            color: Colors.white, size: 20)
                                      else
                                        Icon(Icons.circle_outlined,
                                            color: MyTheme.grey, size: 20),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 6.0, left: 10),
                                        child: mediumText(
                                            'Time2',
                                            notificationState && time2State
                                                ? Colors.white
                                                : Colors.white30),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _selectTime(context, 20),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 90,
                                    height: 50,
                                    color: notificationState && time2State
                                        ? Colors.white
                                        : Colors.white30,
                                    child: titleText(
                                        '${selectedTime2.hour.toString().padLeft(2, "0")}:${selectedTime2.minute.toString().padLeft(2, "0")}',
                                        Colors.black,
                                        null),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            // notification time3
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    HapticFeedback.lightImpact();
                                    setState(() {
                                      time3State = !time3State;
                                      saveData('time3State', time3State);
                                    });
                                    if (notificationState && time3State) {
                                      await WordsNotification()
                                          .scheduleNotification(
                                              30,
                                              selectedWordsCount,
                                              selectedTime3);
                                    }
                                    if (!time3State) {
                                      await flutterLocalNotificationsPlugin
                                          .cancel(3);
                                      debugPrint('canceled time3');
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      if (notificationState && time3State)
                                        const Icon(Icons.radio_button_checked,
                                            color: Colors.white, size: 20)
                                      else
                                        Icon(Icons.circle_outlined,
                                            color: MyTheme.grey, size: 20),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 6.0, left: 10),
                                        child: mediumText(
                                            'Time3',
                                            notificationState && time3State
                                                ? Colors.white
                                                : Colors.white30),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _selectTime(context, 30),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 90,
                                    height: 50,
                                    color: notificationState && time3State
                                        ? Colors.white
                                        : Colors.white30,
                                    child: titleText(
                                        '${selectedTime3.hour.toString().padLeft(2, "0")}:${selectedTime3.minute.toString().padLeft(2, "0")}',
                                        Colors.black,
                                        null),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              customButton(
                  width: 190,
                  MyTheme.orange,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0, right: 5),
                        child: Icon(Icons.notifications_active_rounded,
                            color: Colors.grey.shade800, size: 28),
                      ),
                      Text('Sample',
                          style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                    ],
                  ), () async {
                handleTapSample();
              }),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     padding:
              //         const EdgeInsets.only(bottom: 2, left: 16, right: 16),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(3),
              //     ),
              //     backgroundColor: MyTheme.orange,
              //   ),
              //   onPressed: () {
              //     HapticFeedback.lightImpact();
              //     handleTapSample();
              //   },
              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     const Padding(
              //       padding: EdgeInsets.only(top: 5.0, right: 10),
              //       child: Icon(Icons.notifications_active_rounded,
              //           color: Colors.black, size: 24),
              //     ),
              //     subText('Notice Sample', Colors.black),
              //   ],
              // ),
              // ),
              const SizedBox(
                height: 100,
              ),
            ])));
  }
}
