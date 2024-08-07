import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_repository.dart';
import 'package:worbbing/domain/entities/notice_data_model.dart';
import 'package:worbbing/domain/repositories/notification_repository.dart';
import 'package:worbbing/domain/repositories/word_list_repository.dart';
import 'package:worbbing/domain/usecases/notice/update_notification_usecase.dart';
import 'package:worbbing/domain/usecases/word/get_random_word_usecase.dart';
import 'package:worbbing/models/word_model.dart';

class ShuffleNotificationUsecase {
  ShuffleNotificationUsecase(this.wordListRepository,
      this.notificationRepository, this.sharedPreferencesRepository);
  final WordListRepository wordListRepository;
  final NotificationRepository notificationRepository;
  final SharedPreferencesRepository sharedPreferencesRepository;

  Future<void> execute() async {
    /// 1日に1回のみ
    final shuffledDate = sharedPreferencesRepository
            .fetch<String>(SharedPreferencesKey.shuffledDate) ??
        DateTime.now().toIso8601String();
    if (DateTime.parse(shuffledDate).day == DateTime.now().day) return;
    await sharedPreferencesRepository.save<String>(
      SharedPreferencesKey.shuffledDate,
      DateTime.now().toIso8601String(),
    );

    final List<NoticeDataModel> list =
        await notificationRepository.getAllNotices();
    for (int i = 0; i < list.length; i++) {
      final WordModel? newWord =
          await GetRandomWordUsecase(wordListRepository).execute();
      if (newWord == null) continue;
      final NoticeDataModel newNotice = list[i].copyWith(
          original: newWord.originalWord, translated: newWord.translatedWord);
      await UpdateNotificationUsecase(notificationRepository,
              wordListRepository, sharedPreferencesRepository)
          .execute(newNotice);
    }
    print("shuffleNotifications");
  }
}
