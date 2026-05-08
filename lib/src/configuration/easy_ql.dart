import 'package:meta/meta.dart';

import '../utils/exceptions.dart';
import 'configurations/base_configuration.dart';
import 'configurations/date_and_time.dart';
import 'configurations/quote_identifier.dart';

export 'configurations/postgres_configuration.dart';
export 'configurations/sqlite_configuration.dart';

/// Easy Query Language
///
/// SQL made easy with Dart and for Dart.
class EasyQl {
  static final EasyQl _instance = EasyQl._();
  EasyQl._();

  /// Easy Query Language
  ///
  /// SQL made easy with Dart and for Dart.
  factory EasyQl() => _instance;

  EasyQlConfiguration? _conf;
  late final QuoteIdentifier _quoteIdentifier;
  late final DateAndTimeDataType _dateAndTimeDataType;

  /// Configure [EasyQl] instance to work whit a specific DBMS.
  void configureFor(
    EasyQlConfiguration baseConfiguration, {
    QuoteIdentifier quoteIdentifier = QuoteIdentifier.squareBrackets,
    DateAndTimeDataType dateAndTimeDataType = DateAndTimeDataType.dateTime,
  }) {
    _conf = baseConfiguration;
    _quoteIdentifier = quoteIdentifier;
    _dateAndTimeDataType = dateAndTimeDataType;
  }

  /// Gets the [EasyQlConfiguration] with which [EasyQl] was initialized.
  @internal
  EasyQlConfiguration get configuration => _conf!;

  /// Current quote identifier
  @internal
  QuoteIdentifier get quoteIdentifier => _quoteIdentifier;

  /// Current [DateTime] parsing option.
  @internal
  DateAndTimeDataType get dateAndTimeDataType => _dateAndTimeDataType;
}

/// An instance of [EasyQl], use it after configuring this using
/// `EasyQl().configureFor`, otherwise [NotConfiguredEasyQlInstanceException]
/// will be thrown.
///
/// It streamlines the way you interact with [EasyQl].
@internal
EasyQl get easyQl {
  final instance = EasyQl();
  if (instance._conf == null) {
    throw const NotConfiguredEasyQlInstanceException();
  }
  return instance;
}
