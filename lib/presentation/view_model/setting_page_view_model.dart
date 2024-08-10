import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:worbbing/application/utils/package_info_utils.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_repository.dart';
import 'package:worbbing/data/repositories/sqflite/word_list_repository_impl.dart';
import 'package:worbbing/domain/entities/translate_language.dart';
import 'package:worbbing/domain/usecases/word/count_notices_usecase.dart';
import 'package:worbbing/domain/usecases/word/get_total_words_usecase.dart';
import 'package:worbbing/providers/app_language_state_provider.dart';

part 'setting_page_view_model.g.dart';

class SettingPageState {
  final bool isLoading;
  final String? errorMessage;
  final int? totalWords;
  final Map<int, int>? noticeCount;
  final String? version;
  final bool enableSlideHint;
  final TranslateLanguage originalLanguage;
  final TranslateLanguage translateLanguage;

  SettingPageState({
    this.isLoading = false,
    this.errorMessage,
    this.totalWords,
    this.noticeCount,
    this.version,
    this.enableSlideHint = true,
    this.originalLanguage = TranslateLanguage.english,
    this.translateLanguage = TranslateLanguage.japanese,
  });

  SettingPageState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? version,
    int? totalWords,
    Map<int, int>? noticeCount,
    bool? enableSlideHint,
    TranslateLanguage? originalLanguage,
    TranslateLanguage? translateLanguage,
  }) {
    return SettingPageState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      version: version ?? this.version,
      totalWords: totalWords ?? this.totalWords,
      noticeCount: noticeCount ?? this.noticeCount,
      enableSlideHint: enableSlideHint ?? this.enableSlideHint,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      translateLanguage: translateLanguage ?? this.translateLanguage,
    );
  }
}

@riverpod
class SettingPageViewModel extends _$SettingPageViewModel {
  @override
  SettingPageState build() {
    state = SettingPageState();
    _initialize();
    return state;
  }

  Future<void> _initialize() async {
    try {
      state = state.copyWith(isLoading: true);

      final originalLanguage = ref
              .read(sharedPreferencesRepositoryProvider)
              .fetch<String>(SharedPreferencesKey.originalLang) ??
          TranslateLanguage.english.name;
      final translateLanguage = ref
              .read(sharedPreferencesRepositoryProvider)
              .fetch<String>(SharedPreferencesKey.translateLang) ??
          TranslateLanguage.japanese.name;
      final version = ref.read(packageInfoUtilsProvider).appVersion;
      final totalWords =
          await GetTotalWordsUsecase(ref.read(wordListRepositoryProvider))
              .execute();
      final noticeCount =
          await CountNoticesUsecase(ref.read(wordListRepositoryProvider))
              .execute();
      final enableSlideHint = _loadSlideHint();

      state = state.copyWith(
        isLoading: false,
        originalLanguage:
            TranslateLanguageExtension.fromString(originalLanguage),
        translateLanguage:
            TranslateLanguageExtension.fromString(translateLanguage),
        version: version,
        totalWords: totalWords,
        noticeCount: noticeCount,
        enableSlideHint: enableSlideHint,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
      );
    }
  }

  bool _loadSlideHint() {
    return ref.read(sharedPreferencesRepositoryProvider).fetch<bool>(
              SharedPreferencesKey.isEnabledSlideHint,
            ) ??
        true;
  }

  void switchSlideHint() {
    final enableSlideHint = !state.enableSlideHint;
    ref.read(sharedPreferencesRepositoryProvider).save<bool>(
          SharedPreferencesKey.isEnabledSlideHint,
          enableSlideHint,
        );
    state = state.copyWith(enableSlideHint: enableSlideHint);
  }

  void updateOriginalLanguage(TranslateLanguage value) async {
    ref.read(sharedPreferencesRepositoryProvider).save<String>(
          SharedPreferencesKey.originalLang,
          value.name,
        );
    state = state.copyWith(originalLanguage: value);
  }

  void updateTranslateLanguage(TranslateLanguage value) async {
    ref.read(sharedPreferencesRepositoryProvider).save<String>(
          SharedPreferencesKey.translateLang,
          value.name,
        );
    state = state.copyWith(translateLanguage: value);
  }

  void updateAppLanguage(AppLanguage value) async {
    ref.read(sharedPreferencesRepositoryProvider).save<String>(
          SharedPreferencesKey.appLanguage,
          value.name,
        );
    ref.read(appLanguageStateProvider.notifier).setLang(value);
  }
}
