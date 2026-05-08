/// A marker abstract class implemented by all statement.
abstract class Statement {
  /// Creates de [Statement].
  const Statement();

  /// Converts the [Statement] to a SQL-formatted [String].
  @override
  String toString() => throw UnimplementedError();
}
