class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);

  @override
  String toString() => 'DatabaseException: $message';
}

class DuplicateItemException extends DatabaseException {
  final String itemIdentifier;

  DuplicateItemException(this.itemIdentifier)
      : super('Duplicate item found: $itemIdentifier');
}
