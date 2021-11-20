part of '../engine.dart';

// abstract class Engine with Notify {}
abstract class UtilEngine extends Notify {
  String _message = 'Initializing';
  String get message => _message;
  set message(String value) => notifyIf<String>(_message, _message = value);

  bool _nodeFocus = false;
  bool get nodeFocus => _nodeFocus;
  set nodeFocus(bool value) => notifyIf<bool>(_nodeFocus, _nodeFocus = value);

  // String _searchQuery = '';
  // String get searchQuery => _searchQuery;
  // set searchQuery(String value) => notifyIf<String>(_searchQuery, _searchQuery = value);

  late void Function({int at, String? to, Object? args, bool routePush}) navigate;
}
