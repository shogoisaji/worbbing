import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:worbbing/application/words_notification.dart';
import 'package:worbbing/pages/main_page.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/words_count_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

// shared preferences save data
  void saveData(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) prefs.setBool(key, value);
    if (value is TimeOfDay) {
      prefs.setInt('${key}hour', value.hour);
      prefs.setInt('${key}minute', value.minute);
    }
    if (value is String) prefs.setString(key, value);
    print('saved');
    print(' → $key');
    print(' → $value');
  }

// shared preferences load data
  void loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationState = prefs.getBool('notificationState') ?? false;
      selectedWordsCount = prefs.getInt('selectedWordsCount') ?? 1;
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
    print('loaded');
    print(' → notificationState : $notificationState');
    print(' → selectedWordsCount : $selectedWordsCount');
    print(' → time1State : $time1State');
    print(' → time2State : $time2State');
    print(' → time3State : $time3State');
    print(' → selectedTime1 : $selectedTime1');
    print(' → selectedTime2 : $selectedTime2');
    print(' → selectedTime3 : $selectedTime3');
  }

// update words count
  void updateWordsCount(int newValue) async {
    setState(() {
      selectedWordsCount = newValue;
      saveData('selectedWordsCount', newValue);
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

// time select
  Future<void> _selectTime(BuildContext context, int timeTypeNumber) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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
                          saveData('notificationState', notificationState);
                        });
                        if (notificationState) {
                          await WordsNotification().requestPermissions();
                          if (time1State) {
                            await WordsNotification().scheduleNotification(
                                10, selectedWordsCount, selectedTime1);
                          }
                          if (time2State) {
                            await WordsNotification().scheduleNotification(
                                20, selectedWordsCount, selectedTime1);
                          }
                          if (time3State) {
                            await WordsNotification().scheduleNotification(
                                30, selectedWordsCount, selectedTime1);
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
                                // Positioned(
                                //     top: 3,
                                //     left: 15,
                                //     child: titleText(
                                //         selectedWordsCount, Colors.black, 32)),
                                Positioned(
                                  top: 5,
                                  right: 15,
                                  child: WordsCountDropdownWidget(
                                    selectedWordsCount: selectedWordsCount,
                                    onItemSelected: updateWordsCount,
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
                                saveData('time1State', time1State);
                              });
                              if (notificationState && time1State) {
                                await WordsNotification().scheduleNotification(
                                    10, selectedWordsCount, selectedTime1);
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
                              setState(() {
                                time2State = !time2State;
                                saveData('time2State', time2State);
                              });
                              if (notificationState && time2State) {
                                await WordsNotification().scheduleNotification(
                                    20, selectedWordsCount, selectedTime2);
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
                              setState(() {
                                time3State = !time3State;
                                saveData('time3State', time3State);
                              });
                              if (notificationState && time3State) {
                                await WordsNotification().scheduleNotification(
                                    30, selectedWordsCount, selectedTime3);
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
          const SizedBox(
            height: 70,
          ),
          // sample notification bottom
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
              await WordsNotification().nowShowNotification(selectedWordsCount);
            },
            child: SizedBox(
              width: 230,
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
