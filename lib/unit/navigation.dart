import 'package:flutter/widgets.dart';
import 'package:lidea/unit/notify.dart';

class UnitNavigationObserver extends NavigatorObserver {
  UnitNavigationObserver(this._changeNotifier);

  final UnitNavigationNotify _changeNotifier;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    Future.microtask(() {
      _changeNotifier.push(route, previousRoute);
    });
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _changeNotifier.pop(route, previousRoute);
  }
}

class UnitNavigationNotify extends Notify {
  String? name = '/';
  int _index = 0;

  int get index => _index;
  set index(int value) {
    notifyIf<int>(index, _index = value);
  }

  //  route.settings.name
  void push(Route<dynamic> current, Route<dynamic>? previous) {
    if (current.settings.name != null) {
      name = current.settings.name!;
      // debugPrint('push current ${current.settings.name}');

    }
    // if (previous != null) {
    //   debugPrint('push previous ${previous.settings.name}');
    // }
    notify();
  }

  void pop(Route<dynamic> current, Route<dynamic>? previous) {
    if (previous != null && previous.settings.name != null) {
      name = previous.settings.name;
    }
    // debugPrint('pop current ${current.settings.name} previous ${previous.settings.name}');
    notify();
  }
}
