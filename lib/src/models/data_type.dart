import '../configuration/easy_ql.dart';

/// SQL data type for wrapping and parsing
enum DataType {
  /// SQL BOOLEAN
  boolean,

  /// SQL INTEGER
  integer,

  /// SQL BIG INTEGER
  bigInteger,

  /// SQL AUTOINCREMENTAL INTEGER
  ///
  /// Some RDBMS may not supports this type.
  autoincrementalInteger,

  /// SQL DOUBLE
  doublePrecision,

  /// SQL REAL
  real,

  /// SQL CHAR
  char,

  /// SQL VARCHAR
  ///
  /// Some RDBMS may have this type deprecated in favor of TEXT.
  varchar,

  /// SQL TEXT
  text,

  /// SQL DATETIME, TIMESTAMP, etc.
  dateTime,
  ;

  @override
  String toString() {
    final typeConf = easyQl.configuration.sqlTypeConfiguration;
    return switch (this) {
      DataType.boolean => typeConf.boolean,
      DataType.integer => typeConf.integer,
      DataType.bigInteger => typeConf.bigInteger,
      DataType.autoincrementalInteger => typeConf.autoincrementalInteger,
      DataType.doublePrecision => typeConf.doublePrecision,
      DataType.real => typeConf.real,
      DataType.char => typeConf.char,
      DataType.varchar => typeConf.varchar,
      DataType.text => typeConf.text,
      DataType.dateTime => typeConf.dateTime,
    };
  }
}
