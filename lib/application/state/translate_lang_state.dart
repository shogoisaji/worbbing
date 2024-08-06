import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:worbbing/domain/entities/translate_language.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_repository.dart';

part 'translate_lang_state.g.dart';

@Riverpod(keepAlive: true)
class TranslateLangState extends _$TranslateLangState {
  @override
  Map<String, TranslateLanguage> build() {
    final original = ref
            .read(sharedPreferencesRepositoryProvider)
            .fetch<String>(SharedPreferencesKey.originalLang) ??
        TranslateLanguage.english.lowerString;
    final translate = ref
            .read(sharedPreferencesRepositoryProvider)
            .fetch<String>(SharedPreferencesKey.translateLang) ??
        TranslateLanguage.english.lowerString;
    return {
      'original': TranslateLanguageExtension.fromString(original),
      'translate': TranslateLanguageExtension.fromString(translate),
    };
  }

  void changeOriginalLang(TranslateLanguage originalLang) {
    ref
        .read(sharedPreferencesRepositoryProvider)
        .save(SharedPreferencesKey.originalLang, originalLang.lowerString);
    state = {
      'original': originalLang,
      'translate': state['translate'] ?? TranslateLanguage.japanese,
    };
  }

  void changeTranslateLang(TranslateLanguage translateLang) {
    ref
        .read(sharedPreferencesRepositoryProvider)
        .save(SharedPreferencesKey.translateLang, translateLang.lowerString);
    state = {
      'original': state['original'] ?? TranslateLanguage.english,
      'translate': translateLang,
    };
  }
}
