import 'select.dart';

/// {@template union}
/// The UNION command combines the result set of two or more SELECT statements
/// (only distinct values)
///
/// From [W3Schools](https://www.w3schools.com/Sql/sql_ref_union.asp).
/// {@endtemplate}
class Union {
  /// {@macro union}
  const Union(this._queries) : _all = false;

  /// The UNION ALL command combines the result set of two or more SELECT
  /// statements (allows duplicate values).
  ///
  /// From [W3Schools](https://www.w3schools.com/Sql/sql_ref_union_all.asp).
  const Union.all(this._queries) : _all = true;

  final bool _all;

  final Iterable<Select> _queries;

  @override
  String toString() {
    final unionParts = <String>[
      'UNION',
      if (_all) 'ALL',
    ];
    final unionKeyword = unionParts.join(' ');

    final formattedUnion =
        _queries.map((s) => s.toString()).join('\n\n$unionKeyword\n\n');

    return '($formattedUnion)';
  }
}
