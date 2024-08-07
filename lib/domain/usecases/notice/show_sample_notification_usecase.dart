import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:worbbing/core/exceptions/permission_exception.dart';
import 'package:worbbing/domain/entities/word_model.dart';
import 'package:worbbing/domain/repositories/word_list_repository.dart';
import 'package:worbbing/domain/usecases/permission/notification_permission.dart';
import 'package:worbbing/domain/usecases/word/get_random_word_usecase.dart';

class ShowSampleNotificationUsecase {
  ShowSampleNotificationUsecase(this.wordListRepository);
  final WordListRepository wordListRepository;

  Future<void> execute() async {
    final bool isPermitted =
        await NotificationPermissionUsecase().checkNotificationPermissions();
    if (!isPermitted) throw NotificationPermissionDeniedException();

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
