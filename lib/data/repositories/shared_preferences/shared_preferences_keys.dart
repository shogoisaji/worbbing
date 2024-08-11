enum SharedPreferencesKey {
  isFirst('isFirst'),
  originalLang('original_lang'),
  translateLang('translate_lang'),
  appLanguage('app_language'),
  ticket('ticket'),
  ticketGetDate('ticket_get_date'),
  noticedEnable('notice_enabled'),
  isEnabledSlideHint('is_enabled_slide_hint'),
  shuffledDate('shuffled_date'),
  speakVolume('speak_volume'),
  ;

  const SharedPreferencesKey(this.value);
  final String value;
}
