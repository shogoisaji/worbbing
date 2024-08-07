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
      (lang) => lang.lowerString == lowercaseValue,
      orElse: () => TranslateLanguage.english,
    );
  }

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

  String get lowerString {
    return name.toLowerCase();
    // switch (this) {
    //   case TranslateLanguage.english:
    //     return 'english';
    //   case TranslateLanguage.japanese:
    //     return 'japanese';
    //   case TranslateLanguage.chinese:
    //     return 'chinese';
    //   case TranslateLanguage.korean:
    //     return 'korean';
    //   case TranslateLanguage.spanish:
    //     return 'spanish';
    //   case TranslateLanguage.french:
    //     return 'french';
    //   case TranslateLanguage.german:
    //     return 'german';
    //   case TranslateLanguage.italian:
    //     return 'italian';
    //   case TranslateLanguage.portuguese:
    //     return 'portuguese';
    // }
  }
}
