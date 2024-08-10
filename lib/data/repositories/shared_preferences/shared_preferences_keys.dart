enum SharedPreferencesKey {
  isFirst('isFirst'),
  originalLang('original_lang'),
  translateLang('translate_lang'),
  appLanguage('app_language'),
  ticket('ticket'),
  ticketGetDate('ticketGetDate'),
  noticedEnable('notice_enabled'),
  isEnabledSlideHint('is_enabled_slide_hint'),
  shuffledDate('shuffled_date'),
  ;

  const SharedPreferencesKey(this.value);
  final String value;
}
