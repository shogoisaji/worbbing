class RegistrationPageException implements Exception {
  final String message;
  RegistrationPageException(this.message);

  @override
  String toString() => 'RegistrationPageException: $message';
}

class InputNullException extends RegistrationPageException {
  final List<String> input;
  InputNullException(this.input) : super('Input is null');

  List<String> nullTypes() => input;
}

class TranslateException implements Exception {
  final String? message;
  TranslateException(this.message);

  @override
  String toString() => 'TranslateException: $message';
}
