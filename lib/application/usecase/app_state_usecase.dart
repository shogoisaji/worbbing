import 'package:worbbing/repository/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_repository.dart';

class AppStateUsecase {
  AppStateUsecase();

  bool isFirst() {
    return SharedPreferencesRepository()
            .fetch<bool>(SharedPreferencesKey.isFirst) ??
        true;
  }

  void changeFirst() {
    SharedPreferencesRepository()
        .save<bool>(SharedPreferencesKey.isFirst, false);
  }
}
