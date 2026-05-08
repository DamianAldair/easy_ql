part of 'select.dart';

/// {@template from}
/// The FROM command is used to specify which table to select or delete data
/// from.
///
/// From [W3Schools](https://www.w3schools.com/Sql/sql_ref_from.asp).
/// {@endtemplate}
abstract class FromItem {
  /// Creates a [FromItem].
  const FromItem({
    required String table,
    required String? alias,
  })  : _alias = alias,
        _table = table;

  final String _table;

  final String? _alias;

  @override
  String toString() {
    final parts = <String>[
      _table.quoted(),
      if (_alias != null) ...[
        'AS',
        _alias!.quoted(),
      ],
    ];
    return parts.join(' ');
  }
}

/// {@macro from}
class Table extends FromItem {
  /// Creates a [Table] to select.
  Table(
    String name, {
    super.alias,
  }) : super(table: name);
}

/// {@macro from}
class Subquery extends FromItem {
  /// Creates a [Subquery] to select.
  Subquery(
    Select subquery, {
    super.alias,
  }) : super(table: subquery.toString());
}
