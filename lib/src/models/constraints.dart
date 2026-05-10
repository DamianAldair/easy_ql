import '../utils/internal_extensions.dart';
import 'conditions.dart';

/// Column constraint
abstract class ColumnConstraint {
  /// Create a [ColumnConstraint].
  const ColumnConstraint();

  @override
  String toString() => throw UnimplementedError();
}

// /// The CHECK constraint is used to ensure that the values in a column satisfies
// /// a specific condition.
// ///
// /// The CHECK constraint evaluates the data to TRUE or FALSE.
// /// If the data evaluates to TRUE, the operation is ok.
// /// If the data evaluates to FALSE,
// /// the entire INSERT or UPDATE operation is aborted, and an error is raised.
// ///
// /// From [W3Schools](https://www.w3schools.com/sql/sql_check.asp).
// class Check extends ColumnConstraint {
//   /// Create a [Check] constraint.
//   const Check(this.expression);

//   /// Expression to be evaluated.
//   final String expression;

//   @override
//   String toString() => 'CHECK ($expression)';
// }

/// The DEFAULT constraint is used to automatically insert a default value
/// for a column, if no value is specified.
///
/// The default value will be added to all new records
/// (if no other value is specified).
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_default.asp).
class Default extends ColumnConstraint {
  /// Create a [Default] constraint.
  const Default(this.value);

  /// Value to be added if no other value is specified.
  final Object value;

  @override
  String toString() => 'DEFAULT ${value.toSqlValue()}';
}

/// {@template ForeignKey}
/// The FOREIGN KEY constraint establishes a link between two tables,
/// and prevents action that will destroy the link between them.
///
/// A FOREIGN KEY is a column in a table that refers to the PRIMARY KEY
/// in another table.
///
/// The table with the foreign key column is called the child table,
/// and the table with the primary key column is called the referenced
/// or parent table.
///
/// The FOREIGN KEY constraint prevents invalid data from being inserted into
/// the foreign key column (in the child table), because the value has to exist
/// in the parent table.
///
/// The FOREIGN KEY constraint also prevents you from deleting a record
/// in the parent table, if related rows still exist in the child table.
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_foreignkey.asp).
/// {@endtemplate}
class ForeignKeyReference extends ColumnConstraint {
  /// Create a Foreign Key constraint.
  const ForeignKeyReference(
    this.referencedTable,
    this.referencedColumn, {
    this.onDelete,
    this.onUpdate,
  });

  /// Referenced table.
  final String referencedTable;

  /// Referenced columns.
  final String referencedColumn;

  /// {@template onDelete}
  /// The ON DELETE option specifies the action taken when a record,
  /// linked by a foreign key, is removed from another table.
  ///
  /// From [Codefinity](https://codefinity.com/courses/v2/5ac24d9d-4a16-45b3-8856-07dec028c5e9/3d6c4ab0-f470-4b5d-ad0e-5f76d28ca0af/3cd3d9b1-2ba8-4377-94b6-5330f28478b9).
  /// {@endtemplate}
  final ForeignKeyAction? onDelete;

  /// {@template onUpdate}
  /// The ON UPDATE option specifies the action taken when a record,
  /// linked by a foreign key, is modified from another table.
  /// {@endtemplate}
  final ForeignKeyAction? onUpdate;

  @override
  String toString() {
    final parts = <String>[
      'REFERENCES',
      referencedTable.quoted(),
      '(${referencedColumn.quoted()})',
      if (onDelete != null) 'ON DELETE $onDelete',
      if (onUpdate != null) 'ON UPDATE $onUpdate',
    ];
    return parts.join(' ');
  }
}

/// Table constraint
abstract class TableConstraint {
  /// Create a [TableConstraint].
  const TableConstraint({required this.name});

  /// Constraint name.
  final String? name;

  List<String>? get _nameParts => name == null
      ? null
      : <String>[
          'CONSTRAINT',
          name!.quoted(),
        ];

  @override
  String toString() => throw UnimplementedError();
}

/// The PRIMARY KEY constraint uniquely identifies each record in a table.
///
/// A table can have only one primary key, which may consist of one single or of multiple fields.
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_ref_primary_key.asp).
class PrimaryKey extends TableConstraint {
  /// Create a [PrimaryKey] constraint.
  const PrimaryKey({
    super.name,
    required this.columns,
  }) : assert(columns.length > 0);

  /// Columns that will be Primary Keys.
  final Set<String> columns;

  @override
  String toString() {
    final formattedColumns = columns.map((c) => c.quoted()).join(', ');

    final parts = <String>[
      if (_nameParts != null) ..._nameParts!,
      'PRIMARY KEY',
      '($formattedColumns)',
    ];
    return parts.join(' ');
  }
}

/// {@macro ForeignKey}
class ForeignKey extends TableConstraint {
  /// Create a Foreign Key constraint.
  const ForeignKey({
    super.name,
    required this.columns,
    required this.referencedTable,
    required this.referencedColumns,
    this.onDelete,
    this.onUpdate,
  }) : assert(columns.length > 0);

  /// Columns that will be Foreign Keys.
  final Set<String> columns;

  /// Referenced table.
  final String referencedTable;

  /// Referenced columns.
  final Set<String> referencedColumns;

  /// {@macro onDelete}
  final ForeignKeyAction? onDelete;

  /// {@macro onUpdate}
  final ForeignKeyAction? onUpdate;

  @override
  String toString() {
    final formattedColumns = columns.map((c) => c.quoted()).join(', ');
    final formattedReferencedColumns =
        referencedColumns.map((c) => c.quoted()).join(', ');

    final parts = <String>[
      if (_nameParts != null) ..._nameParts!,
      'FOREIGN KEY',
      '($formattedColumns)',
      'REFERENCES',
      referencedTable.quoted(),
      '($formattedReferencedColumns)',
      if (onDelete != null) 'ON DELETE $onDelete',
      if (onUpdate != null) 'ON UPDATE $onUpdate',
    ];
    return parts.join(' ');
  }
}

/// The CHECK constraint is used to ensure that the values in a column satisfies
/// a specific condition.
///
/// The CHECK constraint evaluates the data to TRUE or FALSE. If the data
/// evaluates to TRUE, the operation is ok. If the data evaluates to FALSE,
/// the entire INSERT or UPDATE operation is aborted, and an error is raised.
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_check.asp).
class Check extends TableConstraint {
  /// Create a Check constraint.
  const Check(
    this._condition, {
    super.name,
  });

  final Condition _condition;

  @override
  String toString() => 'CHECK ($_condition)';
}

/// In relational databases, a foreign key establishes a relationship between
/// two tables. This relationship is strict and comes with certain rules or
/// constraints.
///
/// From [Codefinity](https://codefinity.com/courses/v2/5ac24d9d-4a16-45b3-8856-07dec028c5e9/3d6c4ab0-f470-4b5d-ad0e-5f76d28ca0af/3cd3d9b1-2ba8-4377-94b6-5330f28478b9).

enum ForeignKeyAction {
  /// Deleting the primary record will change the foreign key in the dependent
  /// records to NULL, rather than deleting those records.
  setNull,

  /// The SET DEFAULT action is similar to SET NULL.
  /// Deleting the primary record changes the foreign key in related records
  /// to a default value that you've specified, rather than to NULL.
  setDefault,

  /// When the primary record is deleted, all related records
  /// (those referencing it via a foreign key) are also removed.
  cascade,

  /// {@template ForeignKeyAction.restrict}
  /// You can't delete a primary record if there are related records in other
  /// tables. If you try, the action will be blocked,
  /// ensuring the integrity of the database.
  /// {@endtemplate}
  restrict,

  /// {@macro ForeignKeyAction.restrict}
  noAction,
  ;

  @override
  String toString() => switch (this) {
        ForeignKeyAction.setNull => 'SET NULL',
        ForeignKeyAction.setDefault => 'SET DEFAULT',
        ForeignKeyAction.cascade => 'CASCADE',
        ForeignKeyAction.restrict => 'RESTRICT',
        ForeignKeyAction.noAction => 'NO ACTION',
      };
}
