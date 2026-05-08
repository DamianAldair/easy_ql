import '../../configuration/easy_ql.dart';
import '../../models/conditions.dart';
import '../../models/order_by.dart';
import '../../utils/internal_extensions.dart';
import '../../utils/super_types.dart';
import '../statement.dart';

part 'advanced_functions.dart';
part 'aggregate_functions.dart';
part 'column.dart';
part 'expressions.dart';
part 'from_item.dart';
part 'join.dart';

/// The SELECT command is used to select data from a database.
/// The data returned is stored in a result table, called the result set.
///
/// From [W3Schools](https://www.w3schools.com/Sql/sql_ref_select.asp).
class Select extends Statement {
  /// Creates a [Select] command.
  Select.from(
    dynamic table, {
    this.joins = const Iterable<Join>.empty(),
    Iterable<dynamic> columns = const Iterable<dynamic>.empty(),
    this.distinct = false,
    this.where,
    this.groupBy = const Iterable<String>.empty(),
    this.having,
    this.orderBy = const Iterable<OrderBy>.empty(),
    this.limit,
    int? skip,
    dynamic into,
  }) : _offset = skip {
    _table = _normalizeTable(VariousTypes(table));
    _columns = columns.map((c) => _normalizeColumn(VariousTypes(c)));
    if (into != null) {
      _targetTable = _normalizeTable(VariousTypes(into));
    }
  }

  late final FromItem _table;

  /// Combine rows from two or more tables based on related columns.
  final Iterable<Join> joins;

  late final Iterable<SelectColumnBase> _columns;

  /// The SELECT DISTINCT command returns only distinct (different)
  /// values in the result set.
  ///
  /// From [W3Schools](https://www.w3schools.com/Sql/sql_ref_select_distinct.asp).
  final bool distinct;

  /// The WHERE command filters a result set to include only records that
  /// fulfill a specified condition.
  ///
  /// From [W3Schools](https://www.w3schools.com/Sql/sql_ref_where.asp).
  final Condition? where;

  /// The GROUP BY command is used to group the result set
  /// (used with aggregate functions: COUNT, MAX, MIN, SUM, AVG).
  ///
  /// From [W3Schools](https://www.w3schools.com/Sql/sql_ref_group_by.asp).
  final Iterable<String> groupBy;

  /// The HAVING command is used instead of WHERE with aggregate functions.
  ///
  /// From [W3Schools](https://www.w3schools.com/Sql/sql_ref_having.asp).
  final Condition? having;

  /// The ORDER BY command is used to sort the result set in ascending or
  /// descending order.
  ///
  /// The ORDER BY command sorts the result set in ascending order by default.
  /// To sort the records in descending order, use the DESC keyword.
  ///
  /// From [W3Schools](https://www.w3schools.com/Sql/sql_ref_order_by.asp).
  final Iterable<OrderBy> orderBy;

  /// The LIMIT, SELECT TOP or ROWNUM command is used to specify the number of
  /// records to return.
  ///
  /// From [W3Schools](https://www.w3schools.com/Sql/sql_ref_limit.asp).
  final int? limit;

  final int? _offset;

  late final Table? _targetTable;

  Table _normalizeTable(VariousTypes<String, Table> table) {
    if (table.isType<String>()) {
      return Table(table.getValueAs<String>());
    }
    if (table.isType<Table>()) {
      return table.getValueAs<Table>();
    }

    throw VariousTypes.argumentError;
  }

  SelectColumnBase _normalizeColumn(
    VariousTypes<String, SelectColumnBase> column,
  ) {
    if (column.isType<String>()) {
      return SelectColumn(column.getValueAs<String>());
    }
    if (column.isType<SelectColumnBase>()) {
      return column.getValueAs<SelectColumnBase>();
    }

    throw VariousTypes.argumentError;
  }

  @override
  String toString() {
    final parts = <String>[
      'SELECT',
      if (distinct) 'DISTINCT',
    ];

    final limitClause =
        limit == null ? null : easyQl.configuration.limitClause(limit!);

    final limitClause1 = limitClause?.$1;
    if (limitClause1 != null) {
      parts.add(limitClause1);
    }

    if (_columns.isEmpty) {
      parts.add('*');
    } else {
      final columns = _columns.map((c) => c.toString());
      final columnsStr = columns.join(',\n');
      parts.add(columnsStr);
    }

    if (_targetTable != null) {
      parts.addAll([
        'INTO',
        _targetTable.toString(),
      ]);
    }

    parts.addAll([
      'FROM',
      _table.toString(),
    ]);

    if (joins.isNotEmpty) {
      final formattedJoins = joins.map((j) => j.toString());
      parts.addAll(formattedJoins);
    }

    if (where != null) {
      parts.addAll([
        'WHERE',
        where!.toString(),
      ]);
    }

    if (groupBy.isNotEmpty) {
      final columnsStr = groupBy.map((c) => c.quoted()).join(', ');
      parts.add('GROUP BY $columnsStr');
    }

    if (having != null) {
      parts.addAll([
        'HAVING',
        having!.toString(),
      ]);
    }

    if (orderBy.isNotEmpty) {
      final columnsStr = orderBy.map((ob) => ob.toString()).join(', ');
      parts.add('ORDER BY $columnsStr');
    }

    final limitClause2 = limitClause?.$2;
    if (limitClause2 != null) {
      parts.add(limitClause2);
    }

    if (_offset != null) {
      parts.add(easyQl.configuration.offsetClause(_offset!));
    }

    return parts.join('\n');
  }
}
