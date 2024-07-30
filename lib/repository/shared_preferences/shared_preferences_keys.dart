enum SharedPreferencesKey {
  isFirst('isFirst'),
  originalLang('original_lang'),
  translateLang('translate_lang'),
  ticket('ticket'),
  ticketGetDate('ticketGetDate'),
  noticeEnable('notice_enable'),
  ;

  const SharedPreferencesKey(this.value);
  final String value;
}
