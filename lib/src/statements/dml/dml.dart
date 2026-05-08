import '../../configuration/easy_ql.dart';
import '../../models/conditions.dart';
import '../../models/order_by.dart';
import '../../utils/internal_extensions.dart';
import '../statement.dart';

export 'delete.dart';
export 'insert.dart';
export 'update.dart';

/// Fragment for WHERE.
mixin Conditions on Statement {
  /// Conditions to apply in WHERE clause.
  late final Condition? condition;

  /// Fragment for WHERE.
  String whereFragment() {
    assert(condition != null);
    return 'WHERE $condition';
  }
}

/// Fragment for RETURNING.
mixin Returning on Statement {
  /// Columns to return using RETURNING.
  late final Iterable<String>? returning;

  /// Fragment for RETURNING.
  String returningFragment() {
    const returningKeyword = 'RETURNING';

    assert(returning != null);

    if (returning!.isEmpty) return '$returningKeyword *';

    final quotedColumns = returning!.map((c) => c.quoted()).join(', ');
    return '$returningKeyword $quotedColumns';
  }

  /// Used to sort the result set.
  late final Iterable<OrderBy>? orderBy;

  /// Fragment for ORDER BY.
  String orderByFragment() {
    final conf = easyQl.configuration;
    assert(
      conf.supportOrderByForReturning,
      '${conf.runtimeType} does not support ORDER BY',
    );

    final parsedColumns = orderBy!.map((c) => c.toString()).join(', ');
    return 'ORDER BY $parsedColumns';
  }

  /// Limit of returned columns using RETURNING.
  late final int? limit;

  /// Fragment for LIMIT.
  String limitFragment() {
    final conf = easyQl.configuration;
    assert(
      conf.supportLimitForReturning,
      '${conf.runtimeType} does not support LIMIT',
    );

    assert(limit != null);
    return 'LIMIT $limit';
  }
}

/// Fragment for SELECT.
mixin ResultSet on Statement {
  /// Used to sort the result set.
  late final Iterable<OrderBy>? orderBy;

  /// Fragment for ORDER BY.
  String orderByFragment() {
    assert(orderBy != null && orderBy!.isNotEmpty);

    final parsedColumns = orderBy!.map((c) => c.toString()).join(', ');
    return 'ORDER BY $parsedColumns';
  }

  /// Limit of returned columns using RETURNING.
  late final int? limit;

  /// Fragment for LIMIT.
  String limitFragment() {
    assert(limit != null);
    return 'LIMIT $limit';
  }
}
