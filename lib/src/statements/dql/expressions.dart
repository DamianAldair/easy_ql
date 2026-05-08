part of 'select.dart';

/// The CASE expression is used to define different results based on specified
/// conditions in an SQL statement.
///
/// The CASE expression goes through the conditions and stops at the first match
/// (like an if-then-else statement). So, once a condition is true, it will stop
/// processing and return the result. If no conditions are true, it returns the
/// value in the ELSE clause. If there is no ELSE clause and no conditions are
/// true, it returns NULL.
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_case.asp).
class Case extends ExpressionColumn {
  /// Creates a [Case] function.
  Case(
    Map<Condition, Object?> conditionsAndResults, {
    Object? orElse,
    super.alias,
  }) : super(() {
          final parts = <String>['CASE'];
          for (final entry in conditionsAndResults.entries) {
            final c = entry.key.toString();
            final r = entry.value.toSqlValue();
            parts.add('\tWHEN $c THEN $r');
          }
          if (orElse != null) {
            parts.add('\tELSE ${orElse.toSqlValue()}');
          }
          parts.add('END');
          return parts.join('\n');
        }());
}
