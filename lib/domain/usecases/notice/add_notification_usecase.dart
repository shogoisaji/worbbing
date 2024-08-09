import 'package:flutter/material.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_repository.dart';
import 'package:worbbing/domain/entities/notice_data_model.dart';
import 'package:worbbing/domain/repositories/notification_repository.dart';
import 'package:worbbing/domain/repositories/word_list_repository.dart';
import 'package:worbbing/domain/usecases/notice/set_schedule_usecase.dart';

class AddNotificationUsecase {
  final NotificationRepository notificationRepository;
  final WordListRepository wordListRepository;
  final SharedPreferencesRepository sharedPreferencesRepository;

  AddNotificationUsecase(this.notificationRepository, this.wordListRepository,
      this.sharedPreferencesRepository);

  Future<NoticeDataModel?> execute(TimeOfDay time) async {
    final word = await wordListRepository.getRandomWord();
    if (word == null) return null;
    final NoticeDataModel notice = NoticeDataModel(
      noticeId: null,
      wordId: word.id,
      original: word.originalWord,
      translated: word.translatedWord,
      time: time,
    );
    final id = await notificationRepository.addNotice(notice);
    final isEnabled = sharedPreferencesRepository
            .fetch<bool>(SharedPreferencesKey.noticedEnable) ??
        false;
    if (isEnabled) {
      await SetScheduleUsecase(wordListRepository)
          .execute(notice.copyWith(noticeId: id));
    }
    return notice.copyWith(noticeId: id);
  }
}
