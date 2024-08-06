enum SharedPreferencesKey {
  isFirst('isFirst'),
  originalLang('original_lang'),
  translateLang('translate_lang'),
  ticket('ticket'),
  ticketGetDate('ticketGetDate'),
  noticeEnable('notice_enable'),
  isEnableSlideHint('is_enable_slide_hint'),
  shuffledDate('shuffled_date'),
  ;

  const SharedPreferencesKey(this.value);
  final String value;
}
