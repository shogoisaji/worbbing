import 'dart:async';
import 'dart:io';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:worbbing/application/database.dart';
import 'package:worbbing/application/words_notificaton.dart';
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
  bool time1State = false;
  bool time2State = false;
  bool time3State = false;
  TimeOfDay selectedTime1 = TimeOfDay.now();
  TimeOfDay selectedTime2 = TimeOfDay.now();
  TimeOfDay selectedTime3 = TimeOfDay.now();
  String selectedFrequency = '1';
  String selectedWordCount = '1';

// update frequency
  void updateFrequency(String newValue) {
    setState(() {
      selectedFrequency = newValue;
    });
  }

// update word count
  void updateWordCount(String newValue) async {
    setState(() {
      selectedWordCount = newValue;
    });
    if (notificationState) {
      if (notificationState && time1State) {
        await WordsNotification()
            .scheduleNotification(1, selectedWordCount, selectedTime1);
      }
      if (notificationState && time2State) {
        await WordsNotification()
            .scheduleNotification(2, selectedWordCount, selectedTime2);
      }
      if (notificationState && time3State) {
        await WordsNotification()
            .scheduleNotification(3, selectedWordCount, selectedTime3);
      }

      debugPrint("word count set");
    }
  }

// time select
  Future<void> _selectTime(BuildContext context, int timeType) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      switch (timeType) {
        case 1:
          setState(() {
            selectedTime1 = picked;
          });
          if (notificationState) {
            await WordsNotification().scheduleNotification(
                timeType, selectedWordCount, selectedTime1);
          }
        case 2:
          setState(() {
            selectedTime2 = picked;
          });
          if (notificationState) {
            await WordsNotification().scheduleNotification(
                timeType, selectedWordCount, selectedTime2);
          }
        case 3:
          setState(() {
            selectedTime3 = picked;
          });
          if (notificationState) {
            await WordsNotification().scheduleNotification(
                timeType, selectedWordCount, selectedTime3);
          }
      }
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
// notification
          Container(
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
                      onChanged: (bool value) async {
                        setState(() {
                          notificationState = value;
                        });
                        if (notificationState) {
                          await WordsNotification().requestPermissions();
                          if (time1State) {
                            await WordsNotification().scheduleNotification(
                                1, selectedWordCount, selectedTime1);
                          }
                          if (time2State) {
                            await WordsNotification().scheduleNotification(
                                2, selectedWordCount, selectedTime1);
                          }
                          if (time3State) {
                            await WordsNotification().scheduleNotification(
                                3, selectedWordCount, selectedTime1);
                          }
                          debugPrint("notificaton ON");
                        } else {
                          await flutterLocalNotificationsPlugin.cancelAll();
                          debugPrint("canceled all");
                        }
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                icon: Icon(
                                  notificationState
                                      ? Icons.alarm
                                      : Icons.alarm_off,
                                  size: 42,
                                ),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero),
                                backgroundColor:
                                    const Color.fromARGB(255, 206, 206, 206),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.only(
                                          bottom: 2, left: 8, right: 8),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                      ),
                                      backgroundColor: MyTheme.orange,
                                    ),
                                    child: subText('OK', Colors.white),
                                  )
                                ],
                                content: notificationState
                                    ? subText('Notification ON', Colors.black)
                                    : subText(
                                        'Notification OFF', Colors.black)),
                          );
                        }
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
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
// notification time1
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              setState(() {
                                time1State = !time1State;
                              });
                              if (notificationState && time1State) {
                                await WordsNotification().scheduleNotification(
                                    1, selectedWordCount, selectedTime1);
                              }
                              if (!time1State) {
                                await flutterLocalNotificationsPlugin.cancel(1);
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
                            onTap: () => _selectTime(context, 1),
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
                              setState(() {
                                time2State = !time2State;
                              });
                              if (notificationState && time2State) {
                                await WordsNotification().scheduleNotification(
                                    2, selectedWordCount, selectedTime2);
                              }
                              if (!time2State) {
                                await flutterLocalNotificationsPlugin.cancel(2);
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
                            onTap: () => _selectTime(context, 2),
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
                              setState(() {
                                time3State = !time3State;
                              });
                              if (notificationState && time3State) {
                                await WordsNotification().scheduleNotification(
                                    3, selectedWordCount, selectedTime3);
                              }
                              if (!time3State) {
                                await flutterLocalNotificationsPlugin.cancel(3);
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
                            onTap: () => _selectTime(context, 3),
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
          const SizedBox(
            height: 70,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.only(bottom: 2, left: 8, right: 8),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              backgroundColor: MyTheme.orange,
            ),
            onPressed: () async {
              await WordsNotification().requestPermissions();
              await WordsNotification().nowShowNotification(selectedWordCount);
            },
            child: SizedBox(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5.0, right: 10),
                    child: Icon(Icons.chat, color: Colors.black54, size: 24),
                  ),
                  subText('Notice Sample', Colors.black54),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
        ])));
  }
}
