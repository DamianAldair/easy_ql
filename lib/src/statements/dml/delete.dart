import '../../models/conditions.dart';
import '../../models/order_by.dart';
import '../statement.dart';
import 'dml.dart';

/// The DELETE command is used to delete existing records in a table.
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_ref_delete.asp).
class Delete extends Statement with Conditions, Returning {
  /// Creates a [Delete.from] table statement to delete existing records in a table.
  Delete.from(
    this._table, {
    Condition? where,
    Iterable<String>? returning,
    Iterable<OrderBy>? orderBy,
    int? limit,
  }) {
    super.condition = where;
    super.returning = returning;
    super.orderBy = orderBy;
    super.limit = limit;
  }

  /// Table name.
  final String _table;

  @override
  String toString() {
    final parts = <String>[
      'DELETE FROM',
      _table,
      if (condition != null) whereFragment(),
      if (returning != null) ...[
        returningFragment(),
        if (orderBy != null) orderByFragment(),
        if (limit != null) limitFragment(),
      ],
    ];
    return parts.join(' ');
  }
}
