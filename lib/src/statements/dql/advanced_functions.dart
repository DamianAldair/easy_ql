part of 'select.dart';

/// The COALESCE() function is the preferred standard for handling potential
/// NULL values.
///
/// The COALESCE() function returns the first non-NULL value in a list of
/// values.
///
/// From [W3Schools](https://www.w3schools.com/Sql/sql_isnull.asp#:~:text=REMOVE%20ADS-,The%20COALESCE()%20Function,-The%20COALESCE()).
class Coalesce extends ExpressionColumn {
  /// Creates a [Coalesce] function.
  Coalesce(
    List<dynamic> values, {
    super.alias,
  })  : assert(values.isNotEmpty),
        super(() {
          final effectiveValues = values.map((v) {
            if (v is SelectColumnBase) return v.toString();
            return v.toSqlValue();
          });
          final formattedValues = effectiveValues.join(', ');
          return 'COALESCE($formattedValues)';
        }());
}
