/// A marker interface implemented by all [EasyQl] exceptions.
abstract interface class EasyQlException implements Exception {
  @override
  String toString() => runtimeType.toString();
}

/// Exception thrown when the [EasyQl] instance has not been configured.
///
/// Use `EasyQl().configureFor`.
class NotConfiguredEasyQlInstanceException implements EasyQlException {
  /// Creates a new [NotConfiguredEasyQlInstanceException].
  const NotConfiguredEasyQlInstanceException();

  @override
  String toString() =>
      '${super.toString()}: EasyQl instance has not been configured. Please, use EasyQl().configureFor.';
}

/// Exception thrown when the statement is not supported/implemented by
/// the configured RDBMS.
class UnimplementedStatementException
    implements EasyQlException, UnimplementedError {
  /// Creates a new [UnimplementedStatementException].
  const UnimplementedStatementException(
    this.statement, [
    this.stackTrace,
  ]);

  @override
  final StackTrace? stackTrace;

  @override
  String? get message => '$statement is not supported/implemented.';

  /// Unsupported/unimplemented statement.
  final String statement;
  @override
  String toString() => '${super.toString()}: $message';
}
