enum TranslateLanguage {
  english,
  japanese,
  chinese,
  korean,
  spanish,
  french,
  german,
  italian,
  portuguese,
}

extension TranslateLanguageExtension on TranslateLanguage {
  static TranslateLanguage fromString(String value) {
    final lowercaseValue = value.toLowerCase();
    return TranslateLanguage.values.firstWhere(
      (lang) => lang.name == lowercaseValue,
      orElse: () => TranslateLanguage.english,
    );
  }

  // String get lowerString {
  //   return name.toLowerCase();
  // }

  String get upperString {
    switch (this) {
      case TranslateLanguage.english:
        return 'English';
      case TranslateLanguage.japanese:
        return 'Japanese';
      case TranslateLanguage.chinese:
        return 'Chinese';
      case TranslateLanguage.korean:
        return 'Korean';
      case TranslateLanguage.spanish:
        return 'Spanish';
      case TranslateLanguage.french:
        return 'French';
      case TranslateLanguage.german:
        return 'German';
      case TranslateLanguage.italian:
        return 'Italian';
      case TranslateLanguage.portuguese:
        return 'Portuguese';
    }
  }
}
