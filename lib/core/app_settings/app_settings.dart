import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_repository.dart';
import 'package:worbbing/domain/entities/translate_language.dart';

part 'app_settings.g.dart';

class AppSettings {
  bool isEnabledSlideHint;
  TranslateLanguage originalLanguage;
  TranslateLanguage translateLanguage;

  AppSettings({
    required this.isEnabledSlideHint,
    required this.originalLanguage,
    required this.translateLanguage,
  });

  AppSettings copyWith({
    bool? isEnabledSlideHint,
    TranslateLanguage? originalLanguage,
    TranslateLanguage? translateLanguage,
  }) =>
      AppSettings(
        isEnabledSlideHint: isEnabledSlideHint ?? this.isEnabledSlideHint,
        originalLanguage: originalLanguage ?? this.originalLanguage,
        translateLanguage: translateLanguage ?? this.translateLanguage,
      );
}

@Riverpod(keepAlive: true)
class AppSettingsState extends _$AppSettingsState {
  @override
  AppSettings build() {
    return AppSettings(
      isEnabledSlideHint: ref
              .read(sharedPreferencesRepositoryProvider)
              .fetch(SharedPreferencesKey.isEnabledSlideHint) ??
          true,
      originalLanguage: ref
              .read(sharedPreferencesRepositoryProvider)
              .fetch(SharedPreferencesKey.originalLang) ??
          TranslateLanguage.english,
      translateLanguage: ref
              .read(sharedPreferencesRepositoryProvider)
              .fetch(SharedPreferencesKey.translateLang) ??
          TranslateLanguage.japanese,
    );
  }

  void switchSlideHintState() async {
    final switchedState = !state.isEnabledSlideHint;
    await ref
        .read(sharedPreferencesRepositoryProvider)
        .save(SharedPreferencesKey.isEnabledSlideHint, switchedState);
    state = state.copyWith(isEnabledSlideHint: switchedState);
  }
}
