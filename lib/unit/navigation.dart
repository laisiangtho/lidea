import 'package:flutter/widgets.dart';
import 'package:lidea/unit/notify.dart';

class UnitNavigationObserver extends NavigatorObserver {
  UnitNavigationObserver(this._changeNotifier);

  final UnitNavigationNotify _changeNotifier;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previous) {
    Future.microtask(() {
      _changeNotifier.push(route, previous);
    });
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previous) {
    _changeNotifier.pop(route, previous);
  }
}

class UnitNavigationNotify extends Notify {
  int _index = 0;
  int get index => _index;
  set index(int value) {
    notifyIf<int>(index, _index = value);
  }

  String _name = '/';
  String get name => _name;
  set name(String? value) {
    if (value != null) {
      notifyIf<String>(name, _name = value);
    }
  }

  String _previous = '/';
  String get previous => _previous;
  set previous(String? value) {
    if (value != null) {
      notifyIf<String>(previous, _previous = value);
    }
  }

  //  route.settings.name
  void push(Route<dynamic> currentRoute, Route<dynamic>? previousRoute) {
    name = currentRoute.settings.name;
    previous = previousRoute?.settings.name;
  }

  void pop(Route<dynamic> previousRoute, Route<dynamic>? currentRoute) {
    name = currentRoute?.settings.name;
    previous = previousRoute.settings.name;
  }
}
