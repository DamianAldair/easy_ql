import 'date_and_time.dart';

/// Base configuration for EasyQl instance.
///
/// It can be:
/// - SQLite: [SqliteConfiguration]
/// - PostgreSQL: [PostgresConfiguration] (not developed yet)
/// - MySQL: [MysqlConfiguration] (not developed yet)
/// - SQL Server: [SqlserverConfiguration] (not developed yet)
abstract class EasyQlConfiguration {
  /// Base configuration for EasyQl instance.
  const EasyQlConfiguration({
    required this.quoteEscapingCharacterFrom,
    required this.quoteEscapingCharacterTo,
    required this.sqlTypeConfiguration,
    required this.dartToSqlBooleanFormatter,
    required this.dateAndTimeDataTypeFormatter,
    required this.supportOrderByForReturning,
    required this.supportLimitForReturning,
    required this.truncateStatement,
    required this.limitClause,
    required this.offsetClause,
    required this.coalesceClause,
    // required this.iif,
  });

  /// {@template quoteEscapingCharacter}
  /// Whether an identifier is quoted affects how its value is normalized
  /// (upper-cased, lower-cased, or used as-is) depending on the database
  /// platform.
  /// {@endtemplate}
  final String quoteEscapingCharacterFrom;

  /// {@macro quoteEscapingCharacter}
  final String quoteEscapingCharacterTo;

  /// Type configuration for the selected RDBMS.
  final SqlTypeConfiguration sqlTypeConfiguration;

  /// The SQL Boolean data type is not included in SQL Server or SQLite,
  /// they use the bit data type, which stores the values ​​0 and 1.
  /// Other databases, such as MySQL and PostgreSQL,
  /// include the Boolean data type, which accepts the values ​​TRUE and FALSE.
  ///
  /// Form [SQLShackSkip](https://www.sqlshack.com/sql-boolean-tutorial/#:~:text=The%20SQL%20Boolean%20data%20type,%2C%20FALSE%2C%20and%20NULL%20values.)
  final Object? Function(bool? value) dartToSqlBooleanFormatter;

  /// [DateAndTimeDataType] parser.
  final String Function(DateAndTimeDataType, DateTime)
      dateAndTimeDataTypeFormatter;

  /// ORDER BY support for RETURNING.
  final bool supportOrderByForReturning;

  /// LIMIT support for RETURNING.
  final bool supportLimitForReturning;

  /// The TRUNCATE TABLE command deletes the data inside a table,
  /// but not the table itself.
  ///
  /// Form [SQLShackSkip](https://www.w3schools.com/sql/sql_ref_drop_table.asp)
  final String Function(String tableName) truncateStatement;

  /// SQL TOP, LIMIT Clause
  /// When working with large data sets in SQL, limiting the number of rows
  /// returned by a query can improve performance and make the data more
  /// manageable. The SQL SELECT TOP and LIMIT statements
  /// accomplish this purpose by limiting the result set to a specified
  /// number of row groups.
  ///
  /// - SQL TOP Clause is used in SQL Server and Sybase to limit the number
  /// of records returned.
  /// - SQL LIMIT Clause is utilized in MySQL, PostgreSQL, and SQLite.
  ///
  /// From [GeeksforGeeks](https://www.geeksforgeeks.org/sql-top-limit-fetch-first-clause/).
  ///
  /// If `numberOfRows` is a double, must be between 0 and 1 and represents
  /// percentage.
  /// For example: 0.24 is 24%, so 0.24 is 24 PERCENT in SQL.
  /// (Compatible with SQL Server)
  /// Note: Rounding will be applied.
  /// 0.2431 will be 24% and 0.2498 will be 25%.
  final (String?, String?) Function(num rows) limitClause;

  /// The OFFSET-FETCH clause in SQL is a powerful tool used for pagination,
  /// allowing users to retrieve a subset of rows from a result set. It is
  /// especially useful when dealing with large datasets, enabling smooth
  /// navigation through data by skipping a certain number of rows and fetching
  /// only the required ones.
  ///
  /// From [GeeksforGeeks](https://www.geeksforgeeks.org/sql/sql-offset-fetch-clause/).
  final String Function(int rows) offsetClause;

  /// Operations involving NULL values can sometimes lead to unexpected results.
  ///
  /// From [W3Schools](https://www.w3schools.com/Sql/sql_isnull.asp).
  final String Function(List<Object?> values) coalesceClause;

  /// The function returns a value if a condition is TRUE,
  /// or another value if a condition is FALSE.
  ///
  /// - SQLite: IIF()
  /// - PostgreSQL: CASE WHEN-THEN-ELSE simplified
  /// - MySQL: IF()
  /// - SQL Server: IIF()
  // final String Function(
  //   String condition,
  //   Object? whenTrue,
  //   Object? whenFalse,
  // ) iif;
}

/// Type configuration for the selected RDBMS.
class SqlTypeConfiguration {
  /// Creates a [SqlTypeConfiguration].
  const SqlTypeConfiguration({
    required this.boolean,
    required this.integer,
    required this.bigInteger,
    required this.autoincrementalInteger,
    required this.doublePrecision,
    required this.real,
    required this.char,
    required this.varchar,
    required this.text,
    required this.dateTime,
  });

  /// SQL BOOLEAN
  final String boolean;

  /// SQL INTEGER
  final String integer;

  /// SQL BIG INTEGER
  final String bigInteger;

  /// SQL AUTOINCREMENTAL INTEGER
  ///
  /// Some RDBMS may not supports this type.
  final String autoincrementalInteger;

  /// SQL DOUBLE
  final String doublePrecision;

  /// SQL REAL
  final String real;

  /// SQL CHAR
  final String char;

  /// SQL VARCHAR
  ///
  /// Some RDBMS may have this type deprecated in favor of TEXT.
  final String varchar;

  /// SQL TEXT
  final String text;

  /// SQL DATETIME, TIMESTAMP, etc.
  final String dateTime;
}
