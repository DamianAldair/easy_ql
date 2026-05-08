import '../../utils/internal_extensions.dart';
import '../statement.dart';
import 'ddl.dart';

/// The DROP statement in SQL deletes a component in a relational database
/// management system (RDBMS).
class Drop extends Statement with Ddl {
  /// Creates a [Drop.index] statement to delete a INDEX.
  Drop.index(
    this._name, {
    bool ifExists = true,
  }) : _ifExists = ifExists {
    ddlComponent = DdlComponent.index_;
  }

  /// Creates a [Drop.view] statement to delete a VIEW.
  Drop.view(
    this._name, {
    bool ifExists = true,
  }) : _ifExists = ifExists {
    ddlComponent = DdlComponent.view;
  }

  /// Creates a [Drop.table] statement to delete a TABLE.
  Drop.table(
    this._name, {
    bool ifExists = true,
  }) : _ifExists = ifExists {
    ddlComponent = DdlComponent.table;
  }

  final String _name;
  final bool _ifExists;

  @override
  String toString() {
    final parts = <String>[
      'DROP',
      ddlComponent.toString(),
      if (_ifExists) 'IF EXISTS',
      _name.quoted(),
    ];
    return parts.join(' ');
  }
}
