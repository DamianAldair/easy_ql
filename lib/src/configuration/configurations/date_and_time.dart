/// Preference about [DateTime] parsing.
enum DateAndTimeDataType {
  /// A date and time combination.
  dateTime,

  /// TIMESTAMP values are stored as the number of seconds since
  /// the Unix epoch ('1970-01-01 00:00:00' UTC).
  timestamp,
}
