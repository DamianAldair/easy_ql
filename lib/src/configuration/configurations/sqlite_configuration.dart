import '../../utils/exceptions.dart';
import '../../utils/internal_extensions.dart';
import 'base_configuration.dart';
import 'date_and_time.dart';

/// Configuration for EasyQl instance to be used with SQLite.
class SqliteConfiguration extends EasyQlConfiguration {
  /// Configuration for EasyQl instance to be used with SQLite.
  SqliteConfiguration()
      : super(
          quoteEscapingCharacterFrom: "'",
          quoteEscapingCharacterTo: "''",
          sqlTypeConfiguration: const SqlTypeConfiguration(
            boolean: 'BOOLEAN',
            integer: 'INTEGER',
            bigInteger: 'INTEGER',
            autoincrementalInteger: 'INTEGER',
            doublePrecision: 'DOUBLE',
            real: 'REAL',
            char: 'CHAR',
            varchar: 'VARCHAR',
            text: 'TEXT',
            dateTime: 'DATETIME',
          ),
          dartToSqlBooleanFormatter: (bool? value) => switch (value) {
            true => 1,
            false => 0,
            null => null,
          },
          dateAndTimeDataTypeFormatter:
              (DateAndTimeDataType dataType, DateTime dateTime) =>
                  switch (dataType) {
            DateAndTimeDataType.dateTime =>
              "DATETIME('${dateTime.toIso8601String()}')",
            DateAndTimeDataType.timestamp => throw UnimplementedError(
                'See: https://blog.sqlite.ai/handling-timestamps-in-sqlite#:~:text=Why%20is%20there%20no%20Timestamp%20data%20type%3F',
              ),
          },
          supportOrderByForReturning: true,
          supportLimitForReturning: true,
          truncateStatement: (_) =>
              throw const UnimplementedStatementException('TRUNCATE'),
          limitClause: (num rows) {
            if (rows is! int) {
              throw ArgumentError(
                'SQLite supports "rows" as "int" only.',
              );
            }
            return (null, 'LIMIT $rows');
          },
          offsetClause: (int rows) {
            return 'OFFSET $rows';
          },
          coalesceClause: (List<Object?> values) {
            assert(values.isNotEmpty);
            final valuesStr = values.map((v) => v.toSqlValue()).join(', ');
            return 'COALESCE ($valuesStr)';
          },
        );
}
