import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:worbbing/application/state/translate_lang_state.dart';
import 'package:worbbing/application/utils/package_info_utils.dart';
import 'package:worbbing/models/translate_language.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_repository.dart';
import 'package:worbbing/repository/sqflite/sqflite_repository.dart';

part 'setting_page_state.g.dart';

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

      final originalLanguage = ref.read(translateLangStateProvider)['original'];
      final translateLanguage =
          ref.read(translateLangStateProvider)['translate'];
      final version = ref.read(packageInfoUtilsProvider).appVersion;
      final totalWords = await SqfliteRepository.instance.totalWords();
      final noticeCount =
          await SqfliteRepository.instance.countNoticeDuration();
      final enableSlideHint = _loadSlideHint();

      state = state.copyWith(
        isLoading: false,
        originalLanguage: originalLanguage,
        translateLanguage: translateLanguage,
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
              SharedPreferencesKey.isEnableSlideHint,
            ) ??
        true;
  }

  void switchSlideHint() {
    final enableSlideHint = !state.enableSlideHint;
    ref.read(sharedPreferencesRepositoryProvider).save<bool>(
          SharedPreferencesKey.isEnableSlideHint,
          enableSlideHint,
        );
    state = state.copyWith(enableSlideHint: enableSlideHint);
  }

  void updateOriginalLanguage(TranslateLanguage value) async {
    ref.read(translateLangStateProvider.notifier).changeOriginalLang(value);
    state = state.copyWith(originalLanguage: value);
  }

  void updateTranslateLanguage(TranslateLanguage value) async {
    ref.read(translateLangStateProvider.notifier).changeTranslateLang(value);
    state = state.copyWith(translateLanguage: value);
  }
}
