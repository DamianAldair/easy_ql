import '../statements/dql/select.dart';
import '../utils/internal_extensions.dart';

/// SQL condition.
abstract class Condition {
  /// Creates a [Condition].
  const Condition();

  @override
  String toString() => throw UnimplementedError();
}

/// Custom SQL condition.
class RawCondition extends Condition {
  /// Creates a [RawCondition].
  const RawCondition(this._expression);

  final String _expression;

  @override
  String toString() => _expression;
}

/// The AND command is used with WHERE to only include rows where
/// both conditions is true.
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_ref_and.asp).
class And extends Condition {
  /// Creates an operator AND.
  const And(this._conditions) : assert(_conditions.length > 0);

  /// [Condition]s.
  final Iterable<Condition> _conditions;

  @override
  String toString() {
    final parsed = _conditions.map((c) => c.toString()).join(' AND ');
    return '($parsed)';
  }
}

/// The OR command is used with WHERE to include rows where either
/// condition is true.
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_ref_or.asp).
class Or extends Condition {
  /// Creates an operator OR.
  const Or(this._conditions) : assert(_conditions.length > 0);

  /// [Condition]s.
  final Iterable<Condition> _conditions;

  @override
  String toString() {
    final parsed = _conditions.map((c) => c.toString()).join(' OR ');
    return '($parsed)';
  }
}

/// The NOT command is used with WHERE to only include rows where a condition
/// is not true.
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_ref_not.asp).
class Not extends Condition {
  /// Creates an operator NOT.
  const Not(this._condition);

  /// [Condition] to be .
  final Condition _condition;

  @override
  String toString() => 'NOT(${_condition.toString()})';
}

/// SQL comparison operators are symbols used to perform operations with
/// data values.
///
/// SQL comparison operators are used in SQL statements like SELECT, WHERE,
/// LIKE, etc.
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_operators.asp).
class Comparison extends Condition {
  /// Creates a Comparison.
  const Comparison(
    this._column,
    this._operator,
    this._value,
  );

  /// Column name.
  final String _column;

  /// Operator.
  final String _operator;

  /// Value to be compared.
  final Object? _value;

  @override
  String toString() {
    final quotedColumn = _column.quoted();
    final sqlValue = _value.toSqlValue();
    return '$quotedColumn $_operator $sqlValue';
  }
}

/// {@template in_operator}
/// The IN operator is used in the WHERE clause to check if a specified column's
/// value matches any value within a provided list.
///
/// The IN operator functions as a shorthand for multiple OR conditions,
/// making queries shorter and more readable.
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_ref_in.asp).
/// {@endtemplate}
class _In extends Condition {
  const _In({
    required this.column,
    required this.not,
  });

  final bool not;

  /// Column name.
  final String column;

  String get _parsedValues => throw UnimplementedError();

  @override
  String toString() {
    final parts = <String>[
      column.quoted(),
      if (not) 'NOT',
      'IN',
      '($_parsedValues)',
    ];
    return parts.join(' ');
  }
}

/// {@macro in_operator}
class InIterable extends _In {
  /// Creates an IN operator.
  const InIterable(
    String column,
    this._values,
  ) : super(
          column: column,
          not: false,
        );

  /// Provided value list.
  final Iterable<Object?> _values;

  @override
  String get _parsedValues => _values.map((v) => v.toSqlValue()).join(', ');
}

/// {@macro in_operator}
class NotInIterable extends _In {
  /// Creates an NOT IN operator.
  const NotInIterable(
    String column,
    this._values,
  ) : super(
          column: column,
          not: true,
        );

  /// Provided value list.
  final Iterable<Object?> _values;

  @override
  String get _parsedValues => _values.map((v) => v.toSqlValue()).join(', ');
}

/// {@macro in_operator}
class In extends _In {
  /// Creates an IN operator.
  const In(
    String column,
    this._subquery,
  ) : super(
          column: column,
          not: false,
        );

  /// SELECT statement.
  final Select _subquery;

  @override
  String get _parsedValues => _subquery.toString();
}

/// {@macro in_operator}
class NotIn extends _In {
  /// Creates an NOT IN operator.
  const NotIn(
    String column,
    this._subquery,
  ) : super(
          column: column,
          not: true,
        );

  /// SELECT statement.
  final Select _subquery;

  @override
  String get _parsedValues => _subquery.toString();
}

class _IsNull extends Condition {
  const _IsNull({
    required this.column,
    required this.not,
  });

  final bool not;

  /// Column name.
  final String column;

  @override
  String toString() {
    final parts = <String>[
      column.quoted(),
      'IS',
      if (not) 'NOT',
      'NULL',
    ];
    return parts.join(' ');
  }
}

/// The IS NULL command is used to test for empty values (NULL values).
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_ref_is_null.asp).
class IsNull extends _IsNull {
  /// Command IS NULL.
  const IsNull(String column)
      : super(
          column: column,
          not: false,
        );
}

/// The IS NOT NULL command is used to test for non-empty values
/// (NOT NULL values).
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_ref_is_not_null.asp).
class IsNotNull extends _IsNull {
  /// Command IS NOT NULL.
  const IsNotNull(String column)
      : super(
          column: column,
          not: true,
        );
}

/// {@template between}
/// The BETWEEN command is used to select values within a given range.
/// The values can be numbers, text, or dates.
///
/// The BETWEEN command is inclusive: begin and end values are included.
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_ref_between.asp).
/// {@endtemplate}
class _Between extends Condition {
  const _Between({
    required this.column,
    required this.not,
    required this.value1,
    required this.value2,
  });

  final bool not;

  /// Column name.
  final String column;

  /// First value of a given range.
  final Object value1;

  /// Second value of a given range.
  final Object value2;

  @override
  String toString() {
    assert(
      (value1 is num && value2 is num) ||
          (value1 is String && value2 is String) ||
          (value1 is DateTime && value2 is DateTime),
    );

    final parts = <String>[
      column.quoted(),
      if (not) 'NOT',
      'BETWEEN',
      value1.toSqlValue(),
      'AND',
      value2.toSqlValue(),
    ];
    return parts.join(' ');
  }
}

/// {@macro between}
class Between extends _Between {
  /// Creates a BETWEEN operator.
  const Between(
    String column,
    Object value1,
    Object value2,
  ) : super(
          column: column,
          not: false,
          value1: value1,
          value2: value2,
        );
}

/// {@macro between}
class NotBetween extends _Between {
  /// Creates a BETWEEN operator.
  const NotBetween(
    String column,
    Object value1,
    Object value2,
  ) : super(
          column: column,
          not: true,
          value1: value1,
          value2: value2,
        );
}

/// The EXISTS command tests for the existence of any record in a subquery,
/// and returns true if the subquery returns one or more records.
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_ref_exists.asp).
class Exists extends Condition {
  /// Creates an [Exists] command.
  const Exists(this._subquery);

  /// SELECT statement.
  final Select _subquery;

  @override
  String toString() => 'EXISTS ($_subquery)';
}

/// The ALL command returns true if all of the subquery values meet the
/// condition.
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_ref_all.asp).
class All extends Condition {
  /// Creates an [All] command.
  const All(this._subquery);

  /// SELECT statement.
  final Select _subquery;

  @override
  String toString() => 'ALL ($_subquery)';
}

/// The ANY command returns true if any of the subquery values meet the
/// condition.
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_ref_any.asp).
class Any extends Condition {
  /// Creates an [Any] command.
  const Any(this._subquery);

  /// SELECT statement.
  final Select _subquery;

  @override
  String toString() => 'ANY ($_subquery)';
}

/// Used to compare column values.
class ColumnEquality extends Condition {
  /// Creates an [ColumnEquality] command.
  const ColumnEquality(
    this._column,
    this._otherColumn,
  );

  final String _column;
  final String _otherColumn;

  @override
  String toString() => '${_column.quoted()} = ${_otherColumn.quoted()}';
}
