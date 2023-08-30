String getCurrentDate() {
  final now = DateTime.now();
  // 2023-08-20T06:00:00.000Z
  return now.toIso8601String();
}

String formatForDisplay(String isoDateString) {
  final dateTime = DateTime.parse(isoDateString);
  final year = dateTime.year;
  final month = dateTime.month;
  final day = dateTime.day;
  final hour = dateTime.hour;
  final minute = dateTime.minute;

  return '$year.${month.toString().padLeft(1, '0')}.${day.toString().padLeft(1, '0')}  ${hour.toString().padLeft(1, '0')}:${minute.toString().padLeft(1, '0')}';
}
