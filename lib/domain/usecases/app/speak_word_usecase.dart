import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_repository.dart';
import 'package:worbbing/domain/entities/translate_language.dart';

part 'speak_word_usecase.g.dart';

@Riverpod(keepAlive: true)
class SpeakWordUsecase extends _$SpeakWordUsecase with WidgetsBindingObserver {
  late final FlutterTts _tts;
  @override
  FlutterTts build() {
    _tts = FlutterTts();
    WidgetsBinding.instance.addObserver(this);
    return _tts;
  }

  Future<void> execute(String word, TranslateLanguage lang) async {
    await _tts.stop();
    final volume = ref
            .read(sharedPreferencesRepositoryProvider)
            .fetch<double>(SharedPreferencesKey.speakVolume) ??
        0.1;
    await state.setVolume(volume);
    await state.setSpeechRate(0.4);
    await state.setPitch(1.0);
    await state.setLanguage(lang.tts);
    await state.speak(word);
  }

  Future<void> setVolume(double volume) async {
    await ref
        .read(sharedPreferencesRepositoryProvider)
        .save<double>(SharedPreferencesKey.speakVolume, volume);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      dispose();
    }
  }

  void dispose() {
    _tts.stop();
    WidgetsBinding.instance.removeObserver(this);
    print('disposed');
  }
}
