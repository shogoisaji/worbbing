import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:worbbing/domain/repositories/word_list_repository.dart';
import 'package:worbbing/domain/usecases/word/get_random_word_usecase.dart';
import 'package:worbbing/models/word_model.dart';

class ShowSampleNotificationUsecase {
  ShowSampleNotificationUsecase(this.wordListRepository);
  final WordListRepository wordListRepository;

  Future<void> execute() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    WordModel? word = await GetRandomWordUsecase(wordListRepository).execute();
    if (word == null) {
      return;
    }
    await flutterLocalNotificationsPlugin.show(
      2147483647,
      word.originalWord,
      word.translatedWord,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'show notification',
          'show notification',
          channelDescription: 'show notification',
          icon: 'drawable/notice_icon',
          importance: Importance.max,
          priority: Priority.max,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: 'notice_tap',
    );
  }
}
