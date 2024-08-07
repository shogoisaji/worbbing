import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_repository.dart';
import 'package:worbbing/data/repositories/sqflite/notification_repository_impl.dart';
import 'package:worbbing/data/repositories/sqflite/word_list_repository_impl.dart';
import 'package:worbbing/domain/entities/notice_data_model.dart';
import 'package:worbbing/domain/usecases/notice/add_notification_usecase.dart';
import 'package:worbbing/domain/usecases/notice/remove_notification_usecase.dart';
import 'package:worbbing/domain/usecases/notice/show_sample_notification_usecase.dart';
import 'package:worbbing/domain/usecases/notice/switch_enabale_notification_usecase.dart';
import 'package:worbbing/domain/usecases/notice/update_notification_usecase.dart';

part 'notice_page_view_model.g.dart';

class NoticePageState {
  final List<NoticeDataModel> noticeList;
  final bool isNoticeEnabled;

  const NoticePageState({
    this.noticeList = const [],
    required this.isNoticeEnabled,
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
  NoticePageState build() {
    return NoticePageState(
      isNoticeEnabled: ref
              .read(sharedPreferencesRepositoryProvider)
              .fetch<bool>(SharedPreferencesKey.noticedEnable) ??
          false,
    );
  }

  Future<void> getNoticeList() async {
    final list = await ref.read(notificationRepositoryProvider).getAllNotices();
    state = state.copyWith(noticeList: list);
  }

  Future<void> addNotice(TimeOfDay time) async {
    final NoticeDataModel? notice = await AddNotificationUsecase(
      ref.read(notificationRepositoryProvider),
      ref.read(wordListRepositoryProvider),
      ref.read(sharedPreferencesRepositoryProvider),
    ).execute(time);
    if (notice != null) {
      state = state.copyWith(noticeList: [...state.noticeList, notice]);
    }
  }

  Future<void> removeNotice(int noticeId) async {
    await RemoveNotificationUsecase(
      ref.read(notificationRepositoryProvider),
    ).execute(noticeId);
    getNoticeList();
  }

  Future<void> updateNotice(NoticeDataModel notice) async {
    await UpdateNotificationUsecase(
            ref.read(notificationRepositoryProvider),
            ref.read(wordListRepositoryProvider),
            ref.read(sharedPreferencesRepositoryProvider))
        .execute(notice);
    getNoticeList();
  }

  Future<void> handleSwitchNotice() async {
    await SwitchEnableNotificationUsecase(
      ref.read(sharedPreferencesRepositoryProvider),
      ref.read(notificationRepositoryProvider),
      ref.read(wordListRepositoryProvider),
    ).execute();
    state = state.copyWith(isNoticeEnabled: !state.isNoticeEnabled);
  }

  Future<void> showSampleNotice() async {
    await ShowSampleNotificationUsecase(ref.read(wordListRepositoryProvider))
        .execute();
  }
}
