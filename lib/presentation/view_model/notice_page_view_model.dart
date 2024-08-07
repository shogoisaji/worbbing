import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_repository.dart';
import 'package:worbbing/data/repositories/sqflite/notification_repository_impl.dart';
import 'package:worbbing/data/repositories/sqflite/word_list_repository_impl.dart';
import 'package:worbbing/domain/entities/notice_data_model.dart';
import 'package:worbbing/domain/usecases/notice/add_notification_usecase.dart';
import 'package:worbbing/domain/usecases/notice/remove_notification_usecase.dart';
import 'package:worbbing/domain/usecases/permission/notification_permission.dart';

part 'notice_page_view_model.g.dart';

class NoticePageState {
  final List<NoticeDataModel> noticeList;
  final bool isNoticeEnabled;

  const NoticePageState({
    this.noticeList = const [],
    this.isNoticeEnabled = false,
  });

  NoticePageState copyWith({
    List<NoticeDataModel>? noticeList,
    bool? isNoticeEnabled,
  }) =>
      NoticePageState(
        noticeList: noticeList ?? this.noticeList,
        isNoticeEnabled: isNoticeEnabled ?? this.isNoticeEnabled,
      );
}

@riverpod
class NoticePageViewModel extends _$NoticePageViewModel {
  @override
  FutureOr<NoticePageState> build() async {
    final noticeList = await _getNoticeList();
    return NoticePageState(
      noticeList: noticeList,
      isNoticeEnabled: ref
          .read(sharedPreferencesRepositoryProvider)
          .fetch(SharedPreferencesKey.noticedEnable),
    );
  }

  Future<List<NoticeDataModel>> _getNoticeList() async {
    final list = await ref.read(notificationRepositoryProvider).getAllNotices();
    return list;
  }

  Future<void> addNotice(TimeOfDay time) async {
    await AddNotificationUsecase(
      ref.read(notificationRepositoryProvider),
      ref.read(wordListRepositoryProvider),
      ref.read(sharedPreferencesRepositoryProvider),
    ).execute(time);
  }

  Future<void> removeNotice(int noticeId) async {
    await RemoveNotificationUsecase(
      ref.read(notificationRepositoryProvider),
    ).execute(noticeId);
  }

  Future<void> updateNotice(NoticeDataModel notice) async {
    await ref.read(notificationRepositoryProvider).updateNotice(notice);
  }

  Future<void> handleSwitchNotice() async {
    final currentValue = ref
        .read(sharedPreferencesRepositoryProvider)
        .fetch(SharedPreferencesKey.noticedEnable);
    final switchedValue = !currentValue;
    if (switchedValue) {
      final isPermitted =
          await NotificationPermissionUsecase().checkNotificationPermissions();
      if (!isPermitted) {
        await NotificationPermissionUsecase().requestPermissions();
        return;
      }
    }
    ref
        .read(sharedPreferencesRepositoryProvider)
        .save<bool>(SharedPreferencesKey.noticedEnable, switchedValue);
    state = AsyncData(state.value!.copyWith(isNoticeEnabled: switchedValue));
  }
}
