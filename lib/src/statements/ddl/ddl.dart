import 'package:meta/meta.dart';

import '../statement.dart';

export 'create.dart';
export 'drop.dart';
export 'truncate.dart';

/// Component to create in a relational database management system (RDBMS).
@internal
enum DdlComponent {
  /// For CREATE/DROP TABLE
  table,

  /// For CREATE/DROP VIEW
  view,

  /// For CREATE/DROP INDEX
  index_,
  ;

  @override
  String toString() => name.replaceAll('_', '').toUpperCase();
}

/// Includes [DdlComponent] to the [Statement].
@internal
mixin Ddl on Statement {
  /// [DdlComponent].
  late final DdlComponent ddlComponent;
}
