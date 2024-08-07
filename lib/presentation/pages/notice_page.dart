import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_repository.dart';
import 'package:worbbing/data/repositories/sqflite/notification_repository_impl.dart';
import 'package:worbbing/data/repositories/sqflite/word_list_repository_impl.dart';
import 'package:worbbing/domain/entities/notice_data_model.dart';
import 'package:worbbing/domain/usecases/notice/show_sample_notification_usecase.dart';
import 'package:worbbing/domain/usecases/notice/update_notification_usecase.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/view_model/notice_page_view_model.dart';
import 'package:worbbing/presentation/widgets/ad_banner.dart';
import 'package:worbbing/presentation/widgets/error_dialog.dart';
import 'package:worbbing/presentation/widgets/kati_button.dart';
import 'package:worbbing/presentation/widgets/yes_no_dialog.dart';

const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

class NoticePage extends HookConsumerWidget {
  const NoticePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(noticePageViewModelProvider);
    final viewModel = switch (asyncValue) {
      AsyncError() => const NoticePageState(),
      AsyncLoading() => const NoticePageState(),
      AsyncData(:final value) => value,
      _ => const NoticePageState(),
    };

    Future<void> handleSwitchNotice() async {
      await ref.read(noticePageViewModelProvider.notifier).handleSwitchNotice();
    }

    Future<void> handleTapAdd() async {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.dialOnly,
      );
      if (pickedTime != null) {
        await ref
            .read(noticePageViewModelProvider.notifier)
            .addNotice(pickedTime)
            .catchError((e) {
          if (!context.mounted) return null;
          ErrorDialog.show(context: context, text: 'Failed to add Notice');
        });
      }
      HapticFeedback.lightImpact();
    }

    Future<void> removeTime(int noticeId) async {
      await ref
          .read(noticePageViewModelProvider.notifier)
          .removeNotice(noticeId)
          .catchError((e) {
        if (!context.mounted) return null;
        ErrorDialog.show(context: context, text: 'Failed to delete Notice');
      });
    }

    void handleTapRemove(NoticeDataModel notice) {
      YesNoDialog.show(
          context: context,
          title: 'Do you want to delete this data?',
          noText: 'Cancel',
          yesText: 'Delete',
          onNoPressed: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
          },
          onYesPressed: () async {
            HapticFeedback.lightImpact();
            await removeTime(notice.noticeId!);
            if (!context.mounted) return;
            Navigator.of(context).pop();
          });
    }

    Future<void> handleTapUpdate(NoticeDataModel notice) async {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.dialOnly,
      );
      if (pickedTime != null) {
        final newNotice = notice.copyWith(time: pickedTime);
        await UpdateNotificationUsecase(
                ref.read(notificationRepositoryProvider),
                ref.read(wordListRepositoryProvider),
                ref.read(sharedPreferencesRepositoryProvider))
            .execute(newNotice);
      }
      HapticFeedback.lightImpact();
    }

    void handleTapSample() async {
      await ShowSampleNotificationUsecase(ref.read(wordListRepositoryProvider))
          .execute();
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: MyTheme.bgGradient,
          ),
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              title: Image.asset(
                'assets/images/notice.png',
                width: 150,
              ),
              leading: InkWell(
                  child: Align(
                    child: Image.asset(
                      'assets/images/custom_arrow.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.pop();
                  }),
              backgroundColor: Colors.transparent,
            ),
            body: SafeArea(
                child: Center(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                        constraints: const BoxConstraints(maxWidth: 500),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 30),
                        child: Column(children: [
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
                                value: viewModel.isNoticeEnabled,
                                activeColor: MyTheme.grey,
                                onChanged: (bool value) async {
                                  HapticFeedback.lightImpact();
                                  await handleSwitchNotice();
                                },
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          // vertical line
                          Expanded(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 14),
                                  decoration: viewModel.isNoticeEnabled
                                      ? BoxDecoration(
                                          color: Colors.grey.shade900,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: MyTheme.lemon, width: 1.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: MyTheme.lemon
                                                  .withOpacity(0.8),
                                              blurRadius: 5.0,
                                            )
                                          ],
                                        )
                                      : BoxDecoration(
                                          color: Colors.grey.shade900,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.grey.shade100,
                                              width: 0.7),
                                        ),
                                  child: SingleChildScrollView(
                                    child: Column(children: [
                                      ...viewModel.noticeList
                                          .map((e) => _buildTimeContent(e,
                                              handleTapUpdate, handleTapRemove))
                                          .toList(),
                                      const SizedBox(
                                        height: 50,
                                      )
                                    ]),
                                  ),
                                ),
                                viewModel.isNoticeEnabled
                                    ? const SizedBox.shrink()
                                    : IgnorePointer(
                                        child: DecoratedBox(
                                            decoration: BoxDecoration(
                                          color: Colors.grey.shade900
                                              .withOpacity(0.6),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                      )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 42,
                          ),
                          LayoutBuilder(builder: (context, constraints) {
                            const space = 24.0;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildSampleButton(
                                    (constraints.maxWidth - space) * 0.5,
                                    handleTapSample),
                                _buildAddButton(
                                    (constraints.maxWidth - space) * 0.5,
                                    handleTapAdd),
                              ],
                            );
                          }),
                          const SizedBox(
                            height: 12,
                          ),
                        ])),
                  ),
                  AdBanner(width: MediaQuery.of(context).size.width)
                ],
              ),
            ))),
      ],
    );
  }

  Widget _buildTimeContent(NoticeDataModel notice,
      Function(NoticeDataModel) onTap, Function(NoticeDataModel) onTapDelete) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.only(top: 6, bottom: 6, left: 18, right: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.lightImpact();
          onTap(notice);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications_on_rounded,
                  color: Colors.grey.shade100,
                  size: 36,
                ),
                const SizedBox(width: 22),
                Text(
                  "${notice.time.hour.toString().padLeft(2, '0')}:${notice.time.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            IconButton(
                onPressed: () {
                  onTapDelete(notice);
                },
                icon: Icon(Icons.delete_rounded,
                    color: Colors.grey.shade300, size: 32))
          ],
        ),
      ),
    );
  }

  Widget _buildSampleButton(double width, Function() onTap) {
    return KatiButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      width: width,
      height: 65,
      elevation: 8,
      buttonRadius: 12,
      stageOffset: 5,
      inclinationRate: 0.9,
      buttonColor: Colors.grey.shade300,
      stageColor: Colors.blueGrey.shade800,
      stagePointColor: Colors.blueGrey.shade700,
      edgeLineColor: Colors.grey.shade100,
      edgeBorder: Border.all(color: Colors.white.withOpacity(0.5), width: 0.8),
      child: Align(
        alignment: const Alignment(0.7, 0.9),
        child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationX(0.5),
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(-0.93, -0.8),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0, right: 5),
                    child: Icon(Icons.notifications_active_rounded,
                        color: MyTheme.greyForOrange, size: 28),
                  ),
                ),
                Align(
                  alignment: const Alignment(0.8, 1.0),
                  child: Text(
                    'Sample',
                    style: TextStyle(
                      fontSize: 27,
                      color: MyTheme.greyForOrange,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        BoxShadow(
                          color: Colors.grey.shade800,
                          blurRadius: 1.0,
                          offset: const Offset(0, -0.8),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildAddButton(double width, Function() onTap) {
    return KatiButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      width: width,
      height: 65,
      elevation: 8,
      buttonRadius: 12,
      stageOffset: 5,
      inclinationRate: 0.9,
      buttonColor: MyTheme.orange,
      stageColor: Colors.blueGrey.shade800,
      stagePointColor: Colors.blueGrey.shade700,
      edgeLineColor: Colors.orange.shade300,
      edgeBorder: Border.all(color: Colors.white.withOpacity(0.5), width: 0.8),
      child: Align(
        alignment: const Alignment(0.7, 0.9),
        child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationX(0.5),
            child: Align(
              alignment: const Alignment(0.93, 1.0),
              child: Icon(Icons.add_rounded,
                  color: MyTheme.greyForOrange, size: 48),
            )),
      ),
    );
  }
}
