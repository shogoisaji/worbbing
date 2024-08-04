import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:worbbing/models/translate_language.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_repository.dart';
import 'package:worbbing/repository/sqflite/sqflite_repository.dart';

final settingPageViewModelProvider = ChangeNotifierProvider((_) {
  return SettingPageViewModel();
});

class SettingPageViewModel extends ChangeNotifier {
  SettingPageViewModel() {
    loadProperties();
  }

  int? _totalWords;
  Map<int, int>? _noticeCount;
  String? _version;
  bool _enableSlideHint = true;
  TranslateLanguage? _originalLanguage;
  TranslateLanguage? _translateLanguage;

  int? get totalWords => _totalWords;
  Map<int, int>? get noticeCount => _noticeCount;
  String? get version => _version;
  bool get enableSlideHint => _enableSlideHint;
  TranslateLanguage? get originalLanguage => _originalLanguage;
  TranslateLanguage? get translateLanguage => _translateLanguage;

  Future<void> loadProperties() async {
    _loadLanguages();
    _loadVersion();
    _loadTotalWords();
    _loadNoticeCount();
    _loadSlideHint();
  }

  Future<void> _loadNoticeCount() async {
    _noticeCount = await SqfliteRepository.instance.countNoticeDuration();
    notifyListeners();
  }

  Future<void> _loadTotalWords() async {
    final totalWords = await SqfliteRepository.instance.totalWords();
    _totalWords = totalWords;
    notifyListeners();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo.version;
    notifyListeners();
  }

  void _loadSlideHint() {
    _enableSlideHint = SharedPreferencesRepository().fetch<bool>(
          SharedPreferencesKey.isEnableSlideHint,
        ) ??
        true;
  }

  void switchSlideHint() {
    _enableSlideHint = !_enableSlideHint;
    SharedPreferencesRepository().save<bool>(
      SharedPreferencesKey.isEnableSlideHint,
      _enableSlideHint,
    );
    notifyListeners();
  }

  void _loadLanguages() {
    _originalLanguage = getOriginalLanguage();
    _translateLanguage = getTranslateLanguage();
  }

  TranslateLanguage getOriginalLanguage() {
    final loadedOriginalString = SharedPreferencesRepository().fetch<String>(
          SharedPreferencesKey.originalLang,
        ) ??
        "english";

    final originalLanguage = TranslateLanguage.values
        .firstWhere((e) => e.lowerString == loadedOriginalString);
    return originalLanguage;
  }

  TranslateLanguage getTranslateLanguage() {
    final loadedTranslateString = SharedPreferencesRepository().fetch<String>(
          SharedPreferencesKey.translateLang,
        ) ??
        "japanese";
    final translateLanguage = TranslateLanguage.values
        .firstWhere((e) => e.lowerString == loadedTranslateString);
    return translateLanguage;
  }

  void updateOriginalLanguage(TranslateLanguage value) async {
    SharedPreferencesRepository().save<String>(
      SharedPreferencesKey.originalLang,
      value.lowerString,
    );
    _originalLanguage = value;
    notifyListeners();
  }

  void updateTranslateLanguage(TranslateLanguage value) async {
    SharedPreferencesRepository().save<String>(
      SharedPreferencesKey.translateLang,
      value.lowerString,
    );
    _translateLanguage = value;
    notifyListeners();
  }
}
