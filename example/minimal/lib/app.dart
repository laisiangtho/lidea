import 'package:flutter/material.dart';
import 'package:lidea/view/keep_alive.dart';

import '/core/main.dart';
export '/core/main.dart';

// export 'state.dart';
part 'state.dart';

class App {
  // static ScrollNotifier notifier = ScrollNotifier();
  // static Routes routeDelegate = Routes();
  // static RouteNotifier route = routeDelegate.state;
  static final Core core = Core();

  /// Scroll notifier for factor, toggle
  /// + MediaQueryData, since modal bottom sheet does nothing
  static final ViewData view = core.viewData;

  /// Route core delegate (routeDelegate)
  static final RouteDelegate routeDelegate = core.routeDelegate;

  /// Route delegate notifier
  static final RouteNotifier route = routeDelegate.notifier;

  /// Data
  static final Data data = core.data;

  /// Theme, Locales
  static final Preference preference = core.preference;

  /// Social Sign in
  static final Authenticate authenticate = core.authenticate;
}

abstract class StateAbstract<T extends StatefulWidget> extends ViewStateWidget<T> {
  late final Map<String, dynamic>? args = state.asMap;
}

class StateAlive extends ViewKeepAlive {
  const StateAlive({super.key, required super.child});
}
