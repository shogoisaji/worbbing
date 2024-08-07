extension StringExtension on String {
  // "2024-03-11T21:26:34.764871" -> "2024.03.11"
  String toYMDString() {
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\..*');
    if (!regex.hasMatch(this)) {
      throw FormatException(
          "対象の文字列は「2024-03-11T21:26:34.764871」の形式である必要があります: $this");
    }
    final dateParts = split('T')[0].split('-');
    return "${dateParts[0]}.${dateParts[1]}.${dateParts[2]}";
  }

  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
