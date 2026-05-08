import '../../configuration/easy_ql.dart';
import '../../utils/internal_extensions.dart';
import '../statement.dart';

/// The TRUNCATE TABLE statement is used to delete the data inside a table,
/// but not the table itself.
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_drop_table.asp).
class Truncate extends Statement {
  final String _table;

  /// Creates de [Truncate] statement.
  const Truncate(this._table);

  @override
  String toString() => easyQl.configuration.truncateStatement(_table.quoted());
}
