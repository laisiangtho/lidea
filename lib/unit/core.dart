import 'package:flutter/cupertino.dart';

import 'notify.dart';

abstract class UnitCore extends Notify {
  // String _message = 'Initializing';
  // String get message => _message;
  // set message(String value) => notifyIf<String>(_message, _message = value);

  final ValueNotifier<String> message = ValueNotifier('Initializing');

  // bool _nodeFocus = false;
  // bool get nodeFocus => _nodeFocus;
  // set nodeFocus(bool value) => notifyIf<bool>(_nodeFocus, _nodeFocus = value);

  // String _searchQuery = '';
  // String get searchQuery => _searchQuery;
  // set searchQuery(String value) => notifyIf<String>(_searchQuery, _searchQuery = value);

  // String _suggestQuery = '';
  // String get suggestQuery => _suggestQuery;
  // set suggestQuery(String value) => notifyIf<String>(_suggestQuery, _suggestQuery = value);

  // late void Function({int at, String? to, Object? args, bool routePush}) navigate;
}
