import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:worbbing/core/exceptions/registration_page_exception.dart';
import 'package:worbbing/data/datasources/api/translate_api.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_repository.dart';
import 'package:worbbing/data/repositories/sqflite/word_list_repository_impl.dart';
import 'package:worbbing/domain/entities/translate_language.dart';
import 'package:worbbing/domain/entities/translated_api_response.dart';
import 'package:worbbing/domain/entities/word_model.dart';
import 'package:worbbing/domain/usecases/word/add_word_usecase.dart';
import 'package:worbbing/presentation/widgets/error_dialog.dart';
import 'package:worbbing/providers/app_language_state_provider.dart';

part 'registration_page_view_model.g.dart';

class RegistrationPageState {
  final bool isLoading;
  final String original;
  final TranslateLanguage originalLanguage;
  final TranslateLanguage translateLanguage;

  const RegistrationPageState({
    required this.isLoading,
    required this.original,
    required this.originalLanguage,
    required this.translateLanguage,
  });

  copyWith({
    bool? isLoading,
    String? original,
    TranslateLanguage? originalLanguage,
    TranslateLanguage? translateLanguage,
  }) {
    return RegistrationPageState(
      isLoading: isLoading ?? this.isLoading,
      original: original ?? this.original,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      translateLanguage: translateLanguage ?? this.translateLanguage,
    );
  }
}

@riverpod
class RegistrationPageViewModel extends _$RegistrationPageViewModel {
  @override
  RegistrationPageState build() {
    final pref = ref.read(sharedPreferencesRepositoryProvider);
    final originalLanguage =
        pref.fetch<String>(SharedPreferencesKey.originalLang) ?? "english";
    final translateLanguage =
        pref.fetch<String>(SharedPreferencesKey.translateLang) ?? "japanese";
    return RegistrationPageState(
      isLoading: false,
      original: "",
      originalLanguage: TranslateLanguageExtension.fromString(originalLanguage),
      translateLanguage:
          TranslateLanguageExtension.fromString(translateLanguage),
    );
  }

  setOriginal(String original) {
    state = state.copyWith(original: original);
  }

  void setOriginalLanguage(TranslateLanguage originalLanguage) {
    state = state.copyWith(originalLanguage: originalLanguage);
  }

  void setTranslateLanguage(TranslateLanguage translateLanguage) {
    state = state.copyWith(translateLanguage: translateLanguage);
  }

  Future<void> addWord(WordModel newWord) async {
    final usecase = AddWordUsecase(ref.read(wordListRepositoryProvider));
    try {
      await usecase.execute(newWord);
    } catch (e) {
      rethrow;
    }
  }

  Future<TranslatedApiResponse?> translateOriginalWord(
      BuildContext context, int ticket, String input) async {
    if (ticket <= 0) {
      if (!context.mounted) return null;
      ErrorDialog.show(context: context, text: 'No Ticket');
      return null;
    }
    state = state.copyWith(isLoading: true);

    final appLang = ref.read(appLanguageStateProvider).name;

    try {
      final res = await TranslateApi.postRequest(input,
          state.originalLanguage.name, state.translateLanguage.name, appLang);
      final translatedModel = TranslatedApiResponse.fromJson(res);

      return translatedModel;
    } catch (e) {
      throw TranslateException();
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
