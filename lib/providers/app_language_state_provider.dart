import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_repository.dart';

part 'app_language_state_provider.g.dart';

enum AppLanguage {
  english,
  japanese,
}

extension LanguageExtension on AppLanguage {
  static AppLanguage fromString(String value) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.name == value,
      orElse: () => AppLanguage.english,
    );
  }

  Locale get locale {
    switch (this) {
      case AppLanguage.english:
        return const Locale('en');
      case AppLanguage.japanese:
        return const Locale('ja');
    }
  }

  String get upperString {
    switch (this) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.japanese:
        return 'Japanese';
    }
  }
}

@Riverpod(keepAlive: true)
class AppLanguageState extends _$AppLanguageState {
  @override
  AppLanguage build() {
    final lang = ref
            .read(sharedPreferencesRepositoryProvider)
            .fetch<String>(SharedPreferencesKey.appLanguage) ??
        AppLanguage.english.name;
    return LanguageExtension.fromString(lang);
  }

  void setLang(AppLanguage lang) {
    state = lang;
  }
}
