import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:worbbing/application/usecase/notice_usecase.dart';
import 'package:worbbing/models/notice_model.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_button.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/my_simple_dialog.dart';
import 'package:worbbing/presentation/widgets/words_count_dropdown.dart';
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
  NoticeModel noticeModel = const NoticeModel();

  @override
  void initState() {
    super.initState();
    loadSchedule();
  }

  void handleTapSample() async {
    await NoticeUsecase().requestPermissions();
    final isEnable = await NoticeUsecase().checkNotificationPermissions();
    if (!isEnable) {
      await showNoticePermissionDialog();
      return;
    }
    if (!isEnable) {
      await showNoticePermissionDialog();
      return;
    }
    await NoticeUsecase().sampleNotification();
  }

  Future<void> handleChangeSwitch(bool value) async {
    if (value) {
      final isEnable = await NoticeUsecase().checkNotificationPermissions();
      if (!isEnable) {
        await showNoticePermissionDialog();
        return;
      }
    }
    final newNotice = noticeModel.copyWith(noticeEnable: value);
    await NoticeUsecase().setScheduleNotification(newNotice);
    setState(() {
      noticeModel = newNotice;
    });
  }

  Future<void> handleTapTimeRadioButton(int timeTypeNumber) async {
    switch (timeTypeNumber) {
      case 10:
        final newNotice =
            noticeModel.copyWith(time1Enable: !noticeModel.time1Enable);
        await NoticeUsecase().setScheduleNotification(newNotice);
        setState(() {
          noticeModel = newNotice;
        });
      case 20:
        final newNotice =
            noticeModel.copyWith(time2Enable: !noticeModel.time2Enable);
        await NoticeUsecase().setScheduleNotification(newNotice);
        setState(() {
          noticeModel = newNotice;
        });
      case 30:
        final newNotice =
            noticeModel.copyWith(time3Enable: !noticeModel.time3Enable);
        await NoticeUsecase().setScheduleNotification(newNotice);
        setState(() {
          noticeModel = newNotice;
        });
    }
  }

  Future<void> loadSchedule() async {
    final loadedNoticeModel = await NoticeUsecase().loadCurrentNoticeData();
    setState(() {
      noticeModel = loadedNoticeModel;
    });
  }

  /// update words count
  void updateWordCount(int newValue) async {
    final newNotice = noticeModel.copyWith(selectedWordCount: newValue);
    await NoticeUsecase().setScheduleNotification(newNotice);
    setState(() {
      noticeModel = newNotice;
    });
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
          final newNotice = noticeModel.copyWith(selectedTime1: picked);
          await NoticeUsecase().setScheduleNotification(newNotice);
          setState(() {
            noticeModel = newNotice;
          });
        case 20:
          final newNotice = noticeModel.copyWith(selectedTime2: picked);
          await NoticeUsecase().setScheduleNotification(newNotice);
          setState(() {
            noticeModel = newNotice;
          });
        case 30:
          final newNotice = noticeModel.copyWith(selectedTime3: picked);
          await NoticeUsecase().setScheduleNotification(newNotice);
          setState(() {
            noticeModel = newNotice;
          });
      }
    }
    HapticFeedback.lightImpact();
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
                            value: noticeModel.noticeEnable,
                            activeColor: MyTheme.grey,
                            onChanged: (bool value) async {
                              HapticFeedback.lightImpact();
                              await handleChangeSwitch(value);
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
                                  color: noticeModel.noticeEnable
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
                                    noticeModel.noticeEnable
                                        ? Colors.white
                                        : Colors.white30),
                                Container(
                                  width: 70,
                                  height: 50,
                                  color: noticeModel.noticeEnable
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
                                          selectedWordsCount:
                                              noticeModel.selectedWordCount,
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
                                    handleTapTimeRadioButton(10);
                                  },
                                  child: Row(
                                    children: [
                                      if (noticeModel.noticeEnable &&
                                          noticeModel.time1Enable)
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
                                            noticeModel.noticeEnable &&
                                                    noticeModel.time1Enable
                                                ? Colors.white
                                                : Colors.white30),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    _selectTime(context, 10);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    height: 50,
                                    color: noticeModel.noticeEnable &&
                                            noticeModel.time1Enable
                                        ? Colors.white
                                        : Colors.white30,
                                    child: titleText(
                                        '${noticeModel.selectedTime1.hour.toString().padLeft(2, "0")}:${noticeModel.selectedTime1.minute.toString().padLeft(2, "0")}',
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
                                    handleTapTimeRadioButton(20);
                                  },
                                  child: Row(
                                    children: [
                                      if (noticeModel.noticeEnable &&
                                          noticeModel.time2Enable)
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
                                            noticeModel.noticeEnable &&
                                                    noticeModel.time2Enable
                                                ? Colors.white
                                                : Colors.white30),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    _selectTime(context, 20);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    height: 50,
                                    color: noticeModel.noticeEnable &&
                                            noticeModel.time2Enable
                                        ? Colors.white
                                        : Colors.white30,
                                    child: titleText(
                                        '${noticeModel.selectedTime2.hour.toString().padLeft(2, "0")}:${noticeModel.selectedTime2.minute.toString().padLeft(2, "0")}',
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
                                    handleTapTimeRadioButton(30);
                                  },
                                  child: Row(
                                    children: [
                                      if (noticeModel.noticeEnable &&
                                          noticeModel.time3Enable)
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
                                            noticeModel.noticeEnable &&
                                                    noticeModel.time3Enable
                                                ? Colors.white
                                                : Colors.white30),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    _selectTime(context, 30);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    height: 50,
                                    color: noticeModel.noticeEnable &&
                                            noticeModel.time3Enable
                                        ? Colors.white
                                        : Colors.white30,
                                    child: titleText(
                                        '${noticeModel.selectedTime3.hour.toString().padLeft(2, "0")}:${noticeModel.selectedTime3.minute.toString().padLeft(2, "0")}',
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
                              fontSize: 24,
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
