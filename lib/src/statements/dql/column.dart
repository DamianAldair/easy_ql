part of 'select.dart';

/// {@template select}
/// Column names in the table you want to select data from.
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_select.asp#:~:text=Try%20it%20Yourself%20%C2%BB-,SELECT%20Syntax,-SELECT%20column1%2C).
/// {@endtemplate}
abstract class SelectColumnBase {
  /// Creates a [SelectColumnBase].
  const SelectColumnBase({
    required String toSelect,
    required bool quoted,
    required String? alias,
  })  : _alias = alias,
        _quoted = quoted,
        _toSelect = toSelect;

  final String _toSelect;

  final bool _quoted;

  final String? _alias;

  @override
  String toString() {
    final parts = <String>[
      _quoted ? _toSelect.quoted() : _toSelect,
      if (_alias != null) ...[
        'AS',
        _alias!.quoted(),
      ],
    ];
    return parts.join(' ');
  }
}

/// {@macro select}
class AllFields extends SelectColumnBase {
  /// Equals to *.
  const AllFields()
      : super(
          toSelect: '*',
          quoted: false,
          alias: null,
        );
}

/// {@macro select}
class SelectColumn extends SelectColumnBase {
  /// Simple table column.
  const SelectColumn(
    String name, {
    super.alias,
  }) : super(
          toSelect: name,
          quoted: true,
        );
}

/// {@macro select}
class SubqueryColumn extends SelectColumnBase {
  /// Subquery as column.
  SubqueryColumn(
    Select subquery, {
    super.alias,
  }) : super(
          toSelect: subquery.toString(),
          quoted: true,
        );
}

/// {@macro select}
class ExpressionColumn extends SelectColumnBase {
  /// Expression as column.
  const ExpressionColumn(
    String rawExpression, {
    super.alias,
  }) : super(
          toSelect: rawExpression,
          quoted: false,
        );
}
