part of 'select.dart';

/// SQL JOINs are fundamental commands used to combine rows from two or more
/// tables based on related columns. They enable powerful data retrieval across
/// relational databases, essential for reporting, analytics, and application
/// development.
///
/// From [Snowflake](https://www.snowflake.com/en/developers/guides/sql-joins/).
class Join {
  /// CROSS JOIN command creates all possible row combinations from two tables.
  ///
  /// From [LearnSQL](https://learnsql.com/blog/cross-join/).
  const Join.cross(
    this._table, {
    this.alias,
  })  : _type = 'CROSS',
        _on = null;

  /// The INNER JOIN command returns rows that have matching values in both
  /// tables.
  ///
  /// From [W3Schools](https://www.w3schools.com/Sql/sql_ref_join.asp).
  const Join.inner(
    this._table, {
    this.alias,
    required Condition on,
  })  : _type = 'INNER',
        _on = on;

  /// The FULL OUTER JOIN command returns all rows when there is a match in
  /// either left table or right table.
  ///
  /// From [W3Schools](https://www.w3schools.com/Sql/sql_ref_join.asp).
  const Join.full(
    this._table, {
    this.alias,
    required Condition on,
  })  : _type = 'FULL OUTER',
        _on = on;

  /// The LEFT JOIN command returns all rows from the left table, and the
  /// matching rows from the right table. The result is NULL from the right
  /// side, if there is no match.
  ///
  /// From [W3Schools](https://www.w3schools.com/Sql/sql_ref_join.asp).
  const Join.left(
    this._table, {
    this.alias,
    required Condition on,
  })  : _type = 'LEFT',
        _on = on;

  /// The RIGHT JOIN command returns all rows from the right table, and the
  /// matching records from the left table. The result is NULL from the left
  /// side, when there is no match.
  ///
  /// From [W3Schools](https://www.w3schools.com/Sql/sql_ref_join.asp).
  const Join.right(
    this._table, {
    this.alias,
    required Condition on,
  })  : _type = 'RIGHT',
        _on = on;

  final String _type;

  final String _table;

  /// Table alias.
  final String? alias;

  final Condition? _on;

  @override
  String toString() {
    final parts = <String>[
      _type,
      'JOIN',
      _table.quoted(),
      if (alias != null) ...[
        'AS',
        alias!.quoted(),
      ],
      if (_on != null) ...[
        'ON',
        _on!.toString(),
      ],
    ];
    return parts.join(' ');
  }
}
