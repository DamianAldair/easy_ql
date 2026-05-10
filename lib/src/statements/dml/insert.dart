import '../../models/columns.dart';
import '../../models/conditions.dart';
import '../../utils/internal_extensions.dart';
import '../statement.dart';
import 'dml.dart';

/// The INSERT INTO command is used to insert new rows in a table.
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_ref_insert_into.asp).
class Insert extends Statement with Returning {
  /// The INSERT ... DEFAULT VALUES statement inserts a single new row into the
  /// named table. Each column of the new row is populated with its default
  /// value, or with a NULL if no default value is specified as part of
  /// the column definition in the CREATE TABLE statement.
  /// The upsert-clause is not supported after DEFAULT VALUES.
  ///
  /// From [SQLite](https://www.sqlite.org/lang_insert.html).
  Insert.defaultValuesInto(
    this._table, {
    ConflictClause? or,
    Iterable<String>? returning,
  })  : _defaultValues = true,
        _insertConflictClause = or,
        _columns = null,
        _subquery = null,
        _values = null,
        _onConflict = null {
    super.returning = returning;
  }

  ///  A new entry is inserted into the table for each row of data returned by
  /// executing the SELECT statement. If a column-list is specified, the number
  /// of columns in the result of the SELECT must be the same as the number of
  /// items in the column-list. Otherwise, if no column-list is specified,
  /// the number of columns in the result of the SELECT must be the same as the
  /// number of columns in the table. Any SELECT statement, including compound
  /// SELECTs and SELECT statements with ORDER BY and/or LIMIT clauses, may be
  /// used in an INSERT statement of this form.
  ///
  /// To avoid a parsing ambiguity, the SELECT statement should always contain a
  /// WHERE clause, even if that clause is simply "WHERE true",
  /// if the upsert-clause is present. Without the WHERE clause, the parser
  /// does not know if the token "ON" is part of a join constraint on the SELECT,
  /// or the beginning of the upsert-clause.
  ///
  /// From [SQLite](https://www.sqlite.org/lang_insert.html).
  Insert.fromSubqueryInto(
    this._table, {
    ConflictClause? or,
    Iterable<String>? columns,
    required String subquery,
    OnConflict? onConflict,
    Iterable<String>? returning,
  })  : _defaultValues = false,
        _insertConflictClause = or,
        _columns = columns,
        _subquery = subquery,
        _values = null,
        _onConflict = onConflict {
    super.returning = returning;
  }

  /// The form with the "VALUES" keyword creates one or more new rows in an
  /// existing table. If the column-name list after table-name is omitted then
  /// the number of values inserted into each row must be the same as the number
  /// of columns in the table. In this case the result of evaluating the
  /// left-most expression from each term of the VALUES list is inserted into
  /// the left-most column of each new row, and so forth for each subsequent
  /// expression. If a column-name list is specified, then the number of values
  /// in each term of the VALUE list must match the number of specified columns.
  /// Each of the named columns of the new row is populated with the results of
  /// evaluating the corresponding VALUES expression. Table columns that do not
  /// appear in the column list are populated with the default column value
  /// (specified as part of the CREATE TABLE statement), or with NULL
  /// if no default value is specified.
  ///
  /// From [SQLite](https://www.sqlite.org/lang_insert.html).
  Insert.into(
    this._table, {
    ConflictClause? or,
    Iterable<String>? columns,
    required Iterable<Iterable<Object?>> values,
    OnConflict? onConflict,
    Iterable<String>? returning,
  })  : _defaultValues = false,
        _insertConflictClause = or,
        _columns = columns,
        _subquery = null,
        _values = values,
        _onConflict = onConflict {
    super.returning = returning;
  }

  final ConflictClause? _insertConflictClause;

  final String _table;

  final bool _defaultValues;

  final Iterable<String>? _columns;

  final String? _subquery;

  final Iterable<Iterable<Object?>>? _values;

  final OnConflict? _onConflict;

  @override
  String toString() {
    final insertCommand = <String>[
      'INSERT',
      if (_insertConflictClause != null)
        'OR ${_insertConflictClause!.name.toUpperCase()}',
      'INTO',
      _table.quoted(),
    ];

    final parts = <String>[
      insertCommand.join(' '),
    ];

    if (_defaultValues) {
      insertCommand.add('DEFAULT VALUES');
    } else {
      if (_columns != null) {
        final columnsStr = _columns!.map((c) => c.quoted()).join(', ');
        final formattedColumns = '($columnsStr)';
        parts.add(formattedColumns);
      }

      final String effectiveValues;

      if (_subquery != null) {
        effectiveValues = '($_subquery)';
      } else {
        final rows = _values!.map(
          (valueRow) {
            final parsedValues = valueRow.map((vr) => vr.toSqlValue());
            final formattedValues = parsedValues.join(', ');
            return '($formattedValues)';
          },
        );
        final formattedRows = rows.join(',\n');

        effectiveValues = <String>[
          'VALUES',
          formattedRows,
        ].join('\n');
      }

      parts.add(effectiveValues);
    }

    if (_onConflict != null) parts.add(_onConflict.toString());

    if (returning != null) parts.add(returningFragment());

    return parts.join('\n');
  }
}

/// UPSERT is a clause added to INSERT that causes the INSERT to behave as an
/// UPDATE or a no-op if the INSERT would violate a uniqueness constraint.
/// UPSERT is not standard SQL. UPSERT in SQLite follows the syntax established
/// by PostgreSQL, with generalizations.
///
/// From [SQLite](https://www.sqlite.org/lang_upsert.html).
class OnConflict {
  /// Creates an [OnConflict], ON CONFLICT ... DO syntax.
  const OnConflict({
    this.columns,
    this.where,
    required this.then,
  });

  /// Indexed columns
  final Iterable<String>? columns;

  /// Expression to be evaluated.
  final Condition? where;

  /// Operation to be performed instead.
  final ConflictResolver then;

  @override
  String toString() {
    final conflictTarget = <String>[
      'ON CONFLICT',
    ];

    if (columns != null) {
      final columnsStr = columns!.map((c) => c.quoted()).join(', ');
      final formattedColumns = '($columnsStr)';
      conflictTarget.add(formattedColumns);
    }

    if (where != null) {
      conflictTarget.addAll([
        'WHERE',
        where!.toString(),
      ]);
    }

    final parts = <String>[
      conflictTarget.join(' '),
      then.toString(),
    ];

    return parts.join(' ');
  }
}

/// {@template conflict-resolver}
/// If the insert operation would cause the conflict target uniqueness
/// constraint to fail, then the insert is omitted and the corresponding
/// DO NOTHING or DO UPDATE operation is performed instead. The ON CONFLICT
/// clauses are checked in the order specified. If the last ON CONFLICT clause
/// omits the conflict target, then it will fire if any uniqueness constraint
/// fails which is not captured by prior ON CONFLICT clauses.
///
/// From [SQLite](https://www.sqlite.org/lang_upsert.html).
/// {@endtemplate}
abstract class ConflictResolver {
  /// {@macro conflict-resolver}
  const ConflictResolver();

  @override
  String toString() => throw UnimplementedError();
}

/// {@macro conflict-resolver}
class DoNothing extends ConflictResolver {
  /// {@macro conflict-resolver}
  const DoNothing();

  @override
  String toString() => 'DO NOTHING';
}

/// {@macro conflict-resolver}
class DoUpdate extends ConflictResolver {
  /// {@macro conflict-resolver}
  const DoUpdate({
    required Map<String, Object?> values,
    required Condition? where,
  })  : _values = values,
        _condition = where;

  final Map<String, Object?> _values;

  final Condition? _condition;

  @override
  String toString() {
    final updateStatement = UpdateBase(
      table: null,
      values: _values,
      where: _condition,
    );

    return 'DO $updateStatement';
  }
}
