import '../configuration/easy_ql.dart';
import '../statements/dql/select.dart';
import '../utils/internal_extensions.dart';
import 'conditions.dart';
import 'constraints.dart';
import 'data_type.dart';
import 'order_type.dart';

/// Represents a table column
class TableColumn<T extends DataType> {
  /// Create a [TableColumn].
  const TableColumn(
    this.name, {
    required this.type,
    this.precision,
    this.primaryKey = false,
    this.primaryKeyOrder,
    this.primaryKeyConflictClause,
    this.nullable = false,
    this.nullConflictClause,
    this.unique = false,
    this.uniqueConflictClause,
    this.defaultValue,
    // this.check,
    this.references,
  }) : assert(precision == null || precision != 0);

  /// Column name.
  final String name;

  /// Column data type.
  final DataType type;

  /// Precision for VARCHAR, etc.
  final int? precision;

  /// Specifies if the column is a primary key
  final bool primaryKey;

  /// If [TableColumn.primaryKey] is specified, specifies the primary key order.
  final OrderType? primaryKeyOrder;

  /// Specifies the conflict resolution algorithm to use where there is
  /// a primary key conflict.
  final ConflictClause? primaryKeyConflictClause;

  /// Specifies if the column can be nullable (the opposite of NOT NULL)
  final bool nullable;

  /// Specifies the conflict resolution algorithm to use if the value is not
  /// provided.
  final ConflictClause? nullConflictClause;

  /// Specifies if the column contains unique values.
  final bool unique;

  /// Specifies the conflict resolution algorithm to use where there is
  /// a UNIQUE constraint conflict.
  final ConflictClause? uniqueConflictClause;

  /// Specifies the default value if a value is not provided.
  final Default? defaultValue;

  // /// The CHECK constraint is used to ensure that the values in the column
  // /// satisfies a specific condition.
  // final Check? check;

  /// The FOREIGN KEY constraint establishes a link between two tables,
  /// and prevents action that will destroy the link between them.
  final ForeignKeyReference? references;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final otherTableColumn = other as TableColumn;
    return type == otherTableColumn.type && name == otherTableColumn.name;
  }

  @override
  int get hashCode => Object.hash(type.toString(), name);

  @override
  String toString() {
    final parts = <String>[
      name.quoted(),
      type.toString(),
      if (precision != null) '($precision)',
      if (primaryKey) 'PRIMARY KEY',
      if (primaryKey && primaryKeyOrder != null) primaryKeyOrder.toString(),
      if (primaryKey && primaryKeyConflictClause != null)
        primaryKeyConflictClause.toString(),
      if (easyQl.configuration is SqliteConfiguration &&
          type == DataType.autoincrementalInteger)
        'AUTOINCREMENT',
      if (!nullable) 'NOT NULL',
      if (!nullable && nullConflictClause != null)
        nullConflictClause.toString(),
      if (unique) 'UNIQUE',
      if (unique && uniqueConflictClause != null)
        uniqueConflictClause.toString(),
      // if (check != null) check.toString(),
      if (defaultValue != null) defaultValue.toString(),
      if (references != null) references.toString(),
    ];
    return parts.join(' ');
  }
}

/// The ON CONFLICT clause is a non-standard extension specific to SQLite that
/// can appear in many other SQL commands. It is given its own section in this
/// document because it is not part of standard SQL and therefore might
/// not be familiar.
///
/// There are five conflict resolution algorithm choices: ROLLBACK, ABORT,
/// FAIL, IGNORE, and REPLACE. The default conflict resolution algorithm
/// is ABORT.
///
/// From [SQLite Cloud](https://docs.sqlitecloud.io/docs/sqlite/lang_conflict).
enum ConflictClause {
  /// When an applicable constraint violation occurs, the ROLLBACK resolution
  /// algorithm aborts the current SQL statement with an SQLITE_CONSTRAINT
  /// error and rolls back the current transaction. If no transaction is active
  /// (other than the implied transaction that is created on every command)
  /// then the ROLLBACK resolution algorithm works the same as the ABORT
  /// algorithm.
  rollback,

  /// When an applicable constraint violation occurs, the ABORT resolution
  /// algorithm aborts the current SQL statement with an SQLITE_CONSTRAINT
  /// error and backs out any changes made by the current SQL statement;
  /// but changes caused by prior SQL statements within the same transaction
  /// are preserved and the transaction remains active. This is the default
  /// behavior and the behavior specified by the SQL standard.
  abort,

  /// When an applicable constraint violation occurs, the FAIL resolution
  /// algorithm aborts the current SQL statement with an SQLITE_CONSTRAINT
  /// error. But the FAIL resolution does not back out prior changes of the SQL
  /// statement that failed nor does it end the transaction. For example,
  /// if an UPDATE statement encountered a constraint violation on the 100th
  /// row that it attempts to update, then the first 99 row changes are
  /// preserved but changes to rows 100 and beyond never occur.
  ///
  /// The FAIL behavior only works for uniqueness, NOT NULL,
  /// and CHECK constraints. A foreign key constraint violation causes an ABORT.
  fail,

  /// When an applicable constraint violation occurs, the IGNORE resolution
  /// algorithm skips the one row that contains the constraint violation and
  /// continues processing subsequent rows of the SQL statement as if nothing
  /// went wrong. Other rows before and after the row that contained the
  /// constraint violation are inserted or updated normally. No error is
  /// returned for uniqueness, NOT NULL, and UNIQUE constraint errors when the
  /// IGNORE conflict resolution algorithm is used. However, the IGNORE conflict
  /// resolution algorithm works like ABORT for foreign key constraint errors.
  ignore,

  /// When a UNIQUE or PRIMARY KEY constraint violation occurs,
  /// the REPLACE algorithm deletes pre-existing rows that are causing
  /// the constraint violation prior to inserting or updating the current
  /// row and the command continues executing normally. If a NOT NULL constraint
  /// violation occurs, the REPLACE conflict resolution replaces the NULL value
  /// with the default value for that column, or if the column has no default
  /// value, then the ABORT algorithm is used. If a CHECK constraint or
  /// foreign key constraint violation occurs, the REPLACE conflict resolution
  /// algorithm works like ABORT.
  ///
  /// When the REPLACE conflict resolution strategy deletes rows in order to
  /// satisfy a constraint, delete triggers fire if and only if recursive
  /// triggers are enabled.
  ///
  /// The update hook is not invoked for rows that are deleted by the REPLACE
  /// conflict resolution strategy. Nor does REPLACE increment the change
  /// counter. The exceptional behaviors defined in this paragraph might change
  /// in a future releas
  replace,
  ;

  @override
  String toString() => 'ON CONFLICT ${name.toUpperCase()}';
}

/// Represents a column to be compared.
class Column {
  /// Creates a [Column].
  const Column(this._name);

  final String _name;

  /// {@template comparison_operators}
  /// SQL comparison operators are symbols used to perform operations with
  /// data values.
  ///
  /// SQL comparison operators are used in SQL statements like SELECT, WHERE,
  /// LIKE, etc.
  ///
  /// From [W3Schools](https://www.w3schools.com/sql/sql_operators.asp).
  /// {@endtemplate}
  Condition equals(Object? value) => Comparison(_name, '=', value);

  /// {@macro comparison_operators}
  Condition notEquals(Object? value) => Comparison(_name, '<>', value);

  /// {@macro comparison_operators}
  Condition greaterThan(Object? value) => Comparison(_name, '>', value);

  /// {@macro comparison_operators}
  Condition greaterThanOrEquals(Object? value) =>
      Comparison(_name, '>=', value);

  /// {@macro comparison_operators}
  Condition lessThan(Object? value) => Comparison(_name, '<', value);

  /// {@macro comparison_operators}
  Condition lessThanOrEquals(Object? value) => Comparison(_name, '<=', value);

  /// The LIKE command is used in a WHERE clause to search for
  /// a specified pattern in a column.
  ///
  /// You can use two wildcards with LIKE:
  ///  - % - Represents zero, one, or multiple characters
  ///  - _ - Represents a single character (MS Access uses a question mark (?) instead)
  ///
  /// From [W3Schools](https://www.w3schools.com/sql/sql_ref_like.asp).
  Condition like(String pattern) => Comparison(_name, 'LIKE', pattern);

  /// {@template in_operator}
  /// The IN operator is used in the WHERE clause to check if a specified column's
  /// value matches any value within a provided list.
  ///
  /// The IN operator functions as a shorthand for multiple OR conditions,
  /// making queries shorter and more readable.
  ///
  /// From [W3Schools](https://www.w3schools.com/sql/sql_ref_in.asp).
  /// {@endtemplate}
  Condition isContainedInIterable(Iterable<Object?> values) =>
      InIterable(_name, values);

  /// {@macro in_operator}
  Condition isNotContainedInIterable(Iterable<Object?> values) =>
      NotInIterable(_name, values);

  /// {@macro in_operator}
  Condition isContainedIn(Select subquery) => In(_name, subquery);

  /// {@macro in_operator}
  Condition isNotContainedIn(Select subquery) => NotIn(_name, subquery);

  /// The IS NULL command is used to test for empty values (NULL values).
  ///
  /// From [W3Schools](https://www.w3schools.com/sql/sql_ref_is_null.asp).
  Condition isNull() => IsNull(_name);

  /// The IS NOT NULL command is used to test for non-empty values
  /// (NOT NULL values).
  ///
  /// From [W3Schools](https://www.w3schools.com/sql/sql_ref_is_not_null.asp).
  Condition isNotNull() => IsNotNull(_name);

  /// {@template between}
  /// The BETWEEN command is used to select values within a given range.
  /// The values can be numbers, text, or dates.
  ///
  /// The BETWEEN command is inclusive: begin and end values are included.
  ///
  /// From [W3Schools](https://www.w3schools.com/sql/sql_ref_between.asp).
  /// {@endtemplate}
  Condition isBetween(Object value1, Object value2) =>
      Between(_name, value1, value2);

  /// {@macro between}
  Condition isNotBetween(Object value1, Object value2) =>
      NotBetween(_name, value1, value2);

  /// The ALL command returns true if all of the subquery values meet the
  /// condition.
  ///
  /// From [W3Schools](https://www.w3schools.com/sql/sql_ref_all.asp).
  Condition meetsAll(Select subquery) => All(subquery);

  /// The ANY command returns true if any of the subquery values meet the
  /// condition.
  ///
  /// From [W3Schools](https://www.w3schools.com/sql/sql_ref_any.asp).
  Condition meetsAny(Select subquery) => Any(subquery);

  /// Used to compare column values.
  Condition equalsColumn(String other) => ColumnEquality(_name, other);
}
