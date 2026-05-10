import '../../models/columns.dart';
import '../../models/constraints.dart';
import '../../utils/internal_extensions.dart';
import '../statement.dart';
import 'ddl.dart';

/// The CREATE statement in SQL creates a component in a relational database
/// management system (RDBMS).
class Create extends Statement with Ddl {
  /// Creates a [Create.index] statement to create a INDEX.
  Create.index(
    this._name, {
    bool unique = false,
    bool ifNotExists = false,
    required String onTable,
    required Iterable<String> columns,
  })  : _unique = unique,
        _ifNotExists = ifNotExists,
        _onTable = onTable,
        _columns = columns,
        _subquery = null,
        _tableColumns = null,
        _constraints = null {
    ddlComponent = DdlComponent.index_;
  }

  /// Creates a [Create.view] statement to create a VIEW.
  Create.view(
    this._name, {
    bool ifNotExists = false,
    required String subquery,
  })  : _ifNotExists = ifNotExists,
        _unique = null,
        _onTable = null,
        _columns = null,
        _subquery = subquery,
        _tableColumns = null,
        _constraints = null {
    ddlComponent = DdlComponent.view;
  }

  /// Creates a [Create.table] statement to create a TABLE.
  Create.table(
    this._name, {
    bool ifNotExists = false,
    required Iterable<TableColumn> columns,
    Iterable<TableConstraint> constraints = const Iterable.empty(),
  })  : _ifNotExists = ifNotExists,
        _unique = null,
        _onTable = null,
        _columns = null,
        _subquery = null,
        _tableColumns = columns,
        _constraints = constraints {
    ddlComponent = DdlComponent.table;
  }

  /// Creates a [Create.tableFromSubquery] statement to create a TABLE
  /// from existing table.
  Create.tableFromSubquery({
    required String table,
    bool ifNotExists = false,
    required String subquery,
  })  : _name = table,
        _ifNotExists = ifNotExists,
        _unique = null,
        _onTable = null,
        _columns = null,
        _subquery = subquery,
        _tableColumns = null,
        _constraints = null {
    ddlComponent = DdlComponent.table;
  }

  /// Index/View/Table name.
  final String _name;

  /// Creare if not exists.
  final bool _ifNotExists;

  final bool? _unique;

  final String? _onTable;

  final Iterable<String>? _columns;

  final String? _subquery;

  final Iterable<TableColumn>? _tableColumns;

  final Iterable<TableConstraint>? _constraints;

  @override
  String toString() {
    final parts1 = <String>[
      'CREATE',
      if (_unique == true) 'UNIQUE',
      ddlComponent.toString(),
      if (_ifNotExists) 'IF NOT EXISTS',
      _name.quoted(),
    ].join(' ');

    switch (ddlComponent) {
      case DdlComponent.index_:
        final joinedColumns = _columns!.map((c) => c.quoted()).join(', ');

        final parts2 = <String>[
          'ON',
          _onTable!.quoted(),
          '($joinedColumns)',
        ].join(' ');

        return '$parts1\n$parts2';

      case DdlComponent.view:
        return '$parts1 AS\n$_subquery';

      case DdlComponent.table:
        if (_subquery != null) {
          return '$parts1 AS\n$_subquery';
        }

        final formattedColumns = _tableColumns!.map((c) => c.toString());
        final formattedConstrains = _constraints!.map((c) => c.toString());
        final formattedFields = [
          ...formattedColumns,
          ...formattedConstrains,
        ].join(',\n\t');

        final parts2 = '(\n\t$formattedFields\n)';

        return '$parts1 $parts2';
    }
  }
}
