import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_repository.dart';

part 'app_settings.g.dart';

class AppSettings {
  bool isEnableSlideHint;

  AppSettings({
    required this.isEnableSlideHint,
  });

  AppSettings copyWith({
    bool? isEnableSlideHint,
  }) =>
      AppSettings(
        isEnableSlideHint: isEnableSlideHint ?? this.isEnableSlideHint,
      );
}

@Riverpod(keepAlive: true)
class AppSettingsState extends _$AppSettingsState {
  @override
  AppSettings build() {
    return AppSettings(
      isEnableSlideHint: ref
              .read(sharedPreferencesRepositoryProvider)
              .fetch(SharedPreferencesKey.isEnableSlideHint) ??
          true,
    );
  }

  void switchSlideHintState() async {
    final switchedState = !state.isEnableSlideHint;
    await ref
        .read(sharedPreferencesRepositoryProvider)
        .save(SharedPreferencesKey.isEnableSlideHint, switchedState);
    state = state.copyWith(isEnableSlideHint: switchedState);
  }
}
