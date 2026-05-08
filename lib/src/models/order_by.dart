import '../utils/internal_extensions.dart';
import 'order_type.dart';

/// The ORDER BY command is used to sort the result set in ascending or
/// descending order.
///
/// The ORDER BY command sorts the result set in ascending order by default.
/// To sort the records in descending order, use the DESC keyword.
///
/// From [W3Schools](https://www.w3schools.com/sql/sql_ref_order_by.asp).
class OrderBy {
  /// Creates an [OrderBy].
  const OrderBy(
    this.column, [
    this.orderType,
  ]);

  /// Column name.
  final String column;

  /// Used to sort the data.
  final OrderType? orderType;

  @override
  String toString() {
    final parts = <String>[
      column.quoted(),
      if (orderType != null) orderType.toString(),
    ];
    return parts.join(' ');
  }
}
