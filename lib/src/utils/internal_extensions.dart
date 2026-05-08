import 'package:decimal/decimal.dart';

import '../configuration/configurations/quote_identifier.dart';
import '../configuration/easy_ql.dart';

/// Escaped [String] Extension.
extension EscapedString on String {
  /// To get quoted [String] for table names, column names, etc.
  String quoted() {
    final parts = split('.');
    final quotedParts = parts.map((p) => p._singleQuoted());
    return quotedParts.join('.');
  }

  String _singleQuoted() {
    final identifier = easyQl.quoteIdentifier;
    return switch (identifier) {
      QuoteIdentifier.squareBrackets => '[$this]',
      QuoteIdentifier.doubleQuotes => '"${replaceAll('"', '""')}"',
    };
  }

  /// To get escaped [String].
  String escape() {
    final conf = easyQl.configuration;
    final from = conf.quoteEscapingCharacterFrom;
    final to = conf.quoteEscapingCharacterTo;
    final escaped = replaceAll(from, to);
    return "'$escaped'";
  }
}

/// Parser SQL value - Dart value.
extension SqlValue on Object? {
  /// Get parsed SQL value from Dart value.
  String toSqlValue() {
    if (this == null) return 'NULL';

    final conf = easyQl.configuration;

    if (this is bool) {
      return conf.dartToSqlBooleanFormatter(this as bool).toString();
    }
    if (this is num) return toString();
    if (this is Decimal) return toString();
    if (this is String) return (this as String).escape();
    if (this is DateTime) {
      return conf
          .dateAndTimeDataTypeFormatter(
            easyQl.dateAndTimeDataType,
            this as DateTime,
          )
          .toString();
    }

    throw FormatException('$runtimeType cannot be parsed as SQL value.');
  }
}
