/// Whether an identifier is quoted affects how its value is normalized
/// (upper-cased, lower-cased, or used as-is) depending on the database
/// platform.
enum QuoteIdentifier {
  /// E.g. "table_name"
  doubleQuotes,

  /// E.g. [[table_name]]
  squareBrackets,
}
