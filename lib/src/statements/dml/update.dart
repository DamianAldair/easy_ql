import 'package:meta/meta.dart';

import '../../models/columns.dart';
import '../../models/conditions.dart';
import '../../utils/internal_extensions.dart';
import '../statement.dart';
import 'dml.dart';

@internal
class UpdateBase extends Statement {
  const UpdateBase({
    required String? table,
    ConflictClause? or,
    required Map<String, Object?> values,
    Condition? where,
  })  : _updateConflictClause = or,
        _table = table,
        _values = values,
        _condition = where;

  final ConflictClause? _updateConflictClause;

  final String? _table;

  final Map<String, Object?> _values;

  final Condition? _condition;

  List<String> _gatParts() {
    final updateCommand = <String>[
      'UPDATE',
      if (_updateConflictClause != null)
        'OR ${_updateConflictClause!.name.toUpperCase()}',
      if (_table != null) _table!.quoted(),
      'SET',
    ];

    final values = _values.entries.map(
      (entry) {
        final column = entry.key.quoted();
        final value = entry.value.toSqlValue();
        return '$column = $value';
      },
    );

    final parts = <String>[
      updateCommand.join(' '),
      values.join(',\n'),
    ];

    if (_condition != null) {
      parts.addAll([
        'WHERE',
        _condition.toString(),
      ]);
    }

    return parts;
  }

  @override
  String toString() => _gatParts().join('\n');
}

/// If the UPDATE statement does not have a WHERE clause, all rows in the table
/// are modified by the UPDATE. Otherwise, the UPDATE affects only those rows
/// for which the WHERE clause boolean expression is true. It is not an error
/// if the WHERE clause does not evaluate to true for any row in the
/// table - this just means that the UPDATE statement affects zero rows.
///
/// From [SQLite](https://www.sqlite.org/lang_update.html).
class Update extends UpdateBase with Returning {
  /// Creates an [Update] statement.
  Update(
    String table, {
    super.or,
    required super.values,
    super.where,
    Iterable<String>? returning,
  }) : super(table: table) {
    super.returning = returning;
  }

  @override
  String toString() {
    final parts = <String>[
      ..._gatParts(),
      if (returning != null) returningFragment(),
    ];

    return parts.join('\n');
  }
}
