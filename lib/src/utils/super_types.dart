import 'package:meta/meta.dart';

@internal
class VariousTypes<T1, T2> {
  const VariousTypes(this._value) : assert(_value is T1 || _value is T2);

  final dynamic _value;

  dynamic get value => _value;

  bool isType<T>() => _value is T;

  T getValueAs<T>() {
    assert(T == T1 || T == T2);
    return _value as T;
  }

  static ArgumentError get argumentError =>
      ArgumentError('Invalid type. Use the specified types.');
}
