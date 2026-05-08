part of 'select.dart';

/// The MIN() function returns the smallest value of the selected column.
///
/// The MIN() function works with numeric, string, and date data types.
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_min_max.asp).
class Min extends ExpressionColumn {
  /// Creates a [Min] function.
  Min(
    String column, {
    super.alias,
  }) : super('MIN(${column.quoted()})');
}

/// The MAX() function returns the largest value of the selected column.
///
/// The MAX() function works with numeric, string, and date data types.
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_max.asp).
class Max extends ExpressionColumn {
  /// Creates a [Max] function.
  Max(
    String column, {
    super.alias,
  }) : super('MAX(${column.quoted()})');
}

/// The COUNT() function returns the number of rows that matches a
/// specified criterion.
///
/// The behavior of COUNT() depends on the argument used within the parentheses:
///  - COUNT(*) - Counts the total number of rows in a table
/// (including NULL values).
///  - COUNT(column) - Counts all non-null values in the column.
///  - COUNT(DISTINCT column) - Counts only the unique, non-null values
/// in the column.
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_count.asp).
class Count extends ExpressionColumn {
  /// Creates a [Count] function.
  Count({
    String? column,
    bool distinct = false,
    super.alias,
  }) : super(() {
          final value = column == null
              ? '*'
              : <String>[
                  if (distinct) 'DISTINCT',
                  column.quoted(),
                ].join(' ');
          return 'COUNT($value)';
        }());
}

/// The SUM() function is used to calculate the total sum of values within a
/// numeric column.
///
/// The SUM() function ignores NULL values in the column.
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_sum.asp).
class Sum extends ExpressionColumn {
  /// Creates a [Sum] function.
  Sum(
    String column, {
    super.alias,
  }) : super('SUM(${column.quoted()})');
}

/// The AVG() function returns the average value of a numeric column.
///
/// The AVG() function ignores NULL values in the column.
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_avg.asp).
class Avg extends ExpressionColumn {
  /// Creates a [Avg] function.
  Avg(
    String column, {
    super.alias,
  }) : super('AVG(${column.quoted()})');
}
