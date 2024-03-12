part of 'main.dart';

class RouteMainDelegate extends RouterDelegate<Uri>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Uri> {
  /// ? will be replaced with RouteType.key
  final String keyName = 'main-route?';
  String _routePath = '';

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  RouteMainDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    notifier.addListener(notifyListeners);
  }
  RouteChangeNotifier get notifier => RouteChangeNotifier();

  List<RouteType> get routes {
    return [];
  }

  List<RouteType> get _mapping {
    return notifier.mapping(routes: routes);
  }

  late Iterable<Page> _routeMapped = _mapping.isEmpty ? [pageUnknown] : _pageMap(_mapping);

  Iterable<Page> get _pages {
    if (_routePath != notifier.uri.path) {
      _routePath = notifier.uri.path;
      _routeMapped = _pageMap(_mapping);
    }
    return _routeMapped;
  }

  List<Page> _pageMap(List<RouteType> routes) => routes.map(pageGenerator).toList();

  // Platform.isIOS -> CupertinoPage: MaterialPage
  Page pageGenerator(RouteType page) {
    // final key = keyName.replaceFirst('?', page.key);
    // debugPrint('page -> name: $key');
    // debugPrint('page -> label: ${page.label}');
    // debugPrint('page -> path: ${notifier.uri.path}');
    return MaterialPage(
      key: ValueKey(keyName.replaceFirst('?', page.key)),
      // key: page.key(keyName),
      // key: ValueKey(page.key(keyName)),
      name: notifier.uri.path,
      arguments: notifier.uri.queryParameters,
      maintainState: true,
      child: page.child,
    );
  }

  Page get pageUnknown {
    return const MaterialPage(
      fullscreenDialog: true,
      child: RouteMessengerWidget(
        message: 'No page',
      ),
    );
  }

  @override
  // Platform.isIOS -> CupertinoApp.router: MaterialApp.router
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: List.of(_pages),
      onPopPage: onPopPage,
      onGenerateRoute: onGenerateRoute,
      onUnknownRoute: onUnknownRoute,
      // initialRoute: '/book',
      // onGenerateInitialRoutes: (a, route) {
      //   debugPrint('onGenerateInitialRoutes: $route');
      //   return [
      //     MaterialPageRoute(builder: (_) => const RouteMessengerWidget(message: 'a')),
      //     MaterialPageRoute(builder: (_) => const RouteMessengerWidget(message: 'b')),
      //   ];
      // },
      observers: [HeroController()],
    );
  }

  // Platform.isIOS -> CupertinoPageRoute: MaterialPageRoute
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final raw = notifier.mapping(
      // uri: notifier.route2Uri(settings),
      name: settings.name,
      routes: routes,
    );

    raw.removeWhere((e) => e.primaryNavigation);
    if (raw.isEmpty) {
      return onUnknownRoute(settings);
    }
    return MaterialPageRoute(
      builder: (context) => raw.last.child,
      settings: settings,
    );
  }

  Route<dynamic>? onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const RouteMessengerWidget(),
      settings: settings,
      fullscreenDialog: true,
    );
  }

  bool onPopPage(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) return false;
    popRoute();
    notifyListeners();
    return true;
  }

  @override
  Future<bool> popRoute() async {
    if (_mapping.length > 1) {
      _mapping.removeLast();
      notifyListeners();
      return true;
    }
    if (notifier.uri.path.isNotEmpty) {
      notifier.pop();
      return true;
    }

    // _mapping.map((e) {
    //   debugPrint('popRoute. ${e.key}');
    // });
    // if (_mapping.length > 1) {
    //   _mapping.removeLast();
    //   notifyListeners();
    //   return true;
    // }

    return confirmExit();
  }

  @override
  Uri get currentConfiguration {
    return notifier.uri;
  }

  @override
  Future<void> setNewRoutePath(Uri configuration) async {
    notifier.uri = configuration;
    notifier.setIndex();
    notifyListeners();
    // _setPath(pages);
  }

  // final _pages = <Page>[];
  // // @override
  // // List<Page> get currentConfiguration => List.of(_pages);

  // void _setPath(List<Page> pages) {
  //   _pages.clear();
  //   _pages.addAll(pages);

  //   // if (_pages.first.name != '/') {
  //   //   _pages.insert(0, _createPage(const RouteSettings(name: '/')));
  //   // }
  //   notifyListeners();
  // }

  // void pushNamed(String name, {dynamic arguments}) {
  //   // final Uri uri = Uri(path: name, queryParameters: arguments);
  //   // _pages.add(_createPage(RouteSettings(name: name, arguments: arguments)));
  //   _pages.add(_createPage(Uri(path: name, queryParameters: arguments)));
  //   notifier.pushNamed(name, arguments: arguments);
  //   notifyListeners();
  // }

  // Page _createPage(Uri uri) {
  //   final raw = notifier.mapping(uri: uri, routes: notifier.listOfMainRoute);
  //   if (raw.isNotEmpty) {
  //     return pageGenerator(raw).first;
  //   }
  //   return pageUnknown();
  // }

  Future<bool> confirmExit() async {
    final result = await showDialog<bool>(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Are you sure you want to exit the app?'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.pop(context, true),
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        );
      },
    );

    return result ?? true;
  }
}

class RouteInnerDelegate extends RouterDelegate<Uri>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Uri> {
  String get keyName => 'inner-route?';

  /// Must be differ from other routes,
  /// each nested navigator should have unique routeName.
  /// But also needs to match exactly one of the root.
  String get rootName => 'nested';

  /// Used to check history, no need to override
  String _routePath = '';

  final RouteChangeNotifier notifier;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  RouteInnerDelegate(this.notifier) : navigatorKey = GlobalKey<NavigatorState>() {
    notifier.addListener(_listener);
  }

  void _listener() {
    notifyListeners();
    // debugPrint('_listener ${notifier.uri}');
  }

  /// Default return empty RouteType list, required to override
  // late List<RouteType> routes;
  // late RouteChangeNotifier asdf;
  // List<RouteType> routes = [];
  // RouteChangeNotifier asdf = RouteChangeNotifier();
  List<RouteType> get routes {
    return [];
  }

  List<RouteType> get _mapping {
    return notifier.mapping(routes: routes, root: rootName);
  }

  // List<RouteType> get _primary {
  //   return routes.where((e) => e.primaryNavigation).toList();
  // }

  late Iterable<Page> _routeMapped = _mapping.isEmpty ? [pageUnknown] : _pageMap(_mapping);

  Iterable<Page> get _pages {
    if (notifier.uri.path.startsWith(rootName) && _routePath != notifier.uri.path) {
      _routePath = notifier.uri.path;
      _routeMapped = _pageMap(_mapping);
    }
    return _routeMapped;
  }

  List<Page> _pageMap(List<RouteType> routes) => routes.map(pageGenerator).toList();

  // Platform.isIOS -> CupertinoPage: MaterialPage
  Page pageGenerator(RouteType page) {
    return MaterialPage(
      key: ValueKey(keyName.replaceFirst('?', page.key)),
      // key: page.key(keyName),
      // key: ValueKey(page.key(keyName)),
      name: notifier.uri.path,
      arguments: notifier.uri.queryParameters,
      maintainState: true,
      child: page.child,
    );
  }

  Page get pageUnknown {
    return const MaterialPage(
      fullscreenDialog: true,
      child: RouteMessengerWidget(
        message: 'No page',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: List.of(_pages),
      onPopPage: onPopPage,
      onGenerateRoute: onGenerateRoute,
      onUnknownRoute: onUnknownRoute,
      observers: [HeroController()],
    );
  }

  // Platform.isIOS -> CupertinoPageRoute: MaterialPageRoute
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final raw = notifier.mapping(
      // uri: notifier.route2Uri(settings),
      name: settings.name,
      routes: routes,
      root: rootName,
    );
    raw.removeWhere((e) => e.primaryNavigation);
    if (raw.isEmpty) {
      return onUnknownRoute(settings);
    }

    return MaterialPageRoute(
      builder: (context) => raw.last.child,
      settings: settings,
    );
  }

  Route<dynamic>? onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => const RouteMessengerWidget(),
      settings: settings,
      fullscreenDialog: true,
    );
  }

  bool onPopPage(Route<dynamic> route, dynamic result) {
    if (notifier.uri.path.startsWith(rootName) && notifier.uri.pathSegments.length > 1) {
      notifier.pop();
    }
    notifyListeners();
    // debugPrint('inner-onPopPage $result');
    return route.didPop(result);
  }

  // This is not required for inner router delegate because it does not
  // parse route
  @override
  Future<void> setNewRoutePath(Uri configuration) async {}

  // @override
  // Uri get currentConfiguration {
  //   return notifier.uri;
  // }
}

class RouteNestDelegate extends RouterDelegate<Uri>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Uri> {
  /// add question mark to differ from other routes,
  /// eg nested-route?
  // final String keyName;

  /// Must be differ from other routes,
  /// each nested navigator should have unique routeName.
  /// But also needs to match exactly one of the root.
  final String root;

  /// Used to check history, no need to override
  String _routePath = '';

  /// Parent route delegation
  final RouteChangeNotifier notifier;

  /// Default return empty RouteType list, required to override
  // late List<RouteType> routes;
  // late RouteChangeNotifier asdf;
  // List<RouteType> routes = [];
  // RouteChangeNotifier asdf = RouteChangeNotifier();
  // List<RouteType> get routes {
  //   return [];
  // }
  final List<RouteType> routes;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  RouteNestDelegate({
    required this.notifier,
    required this.routes,
    this.root = '',
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    notifier.addListener(_listener);
  }

  /// root-route
  String get keyName => '$root-route?';

  void _listener() {
    notifyListeners();
  }

  List<RouteType> get _mapping {
    return notifier.mapping(routes: routes, root: root);
  }

  // List<RouteType> get _primary {
  //   return routes.where((e) => e.primaryNavigation).toList();
  // }

  late Iterable<Page> _routeMapped = _mapping.isEmpty ? [pageUnknown] : _pageMap(_mapping);

  Iterable<Page> get _pages {
    if (notifier.uri.path.startsWith(root) && _routePath != notifier.uri.path) {
      _routePath = notifier.uri.path;
      _routeMapped = _pageMap(_mapping);
    }
    return _routeMapped;
  }

  List<Page> _pageMap(List<RouteType> routes) => routes.map(pageGenerator).toList();

  // Platform.isIOS -> CupertinoPage: MaterialPage
  Page pageGenerator(RouteType page) {
    // final key = keyName.replaceFirst('?', page.key);
    // debugPrint('page -> key: $key');
    // debugPrint('page -> label: ${page.label}');
    return MaterialPage(
      key: ValueKey(keyName.replaceFirst('?', page.key)),
      // key: page.key(keyName),
      // key: ValueKey(page.key(keyName)),
      name: notifier.uri.path,
      arguments: notifier.uri.queryParameters,
      maintainState: true,
      child: page.child,
    );
  }

  Page get pageUnknown {
    return const MaterialPage(
      fullscreenDialog: true,
      child: RouteMessengerWidget(
        message: 'No page',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: List.of(_pages),
      onPopPage: onPopPage,
      onGenerateRoute: onGenerateRoute,
      onUnknownRoute: onUnknownRoute,
      observers: [HeroController()],
    );
  }

  // Platform.isIOS -> CupertinoPageRoute: MaterialPageRoute
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final raw = notifier.mapping(
      // uri: notifier.route2Uri(settings),
      name: settings.name,
      routes: routes,
      root: root,
    );
    raw.removeWhere((e) => e.primaryNavigation);
    if (raw.isEmpty) {
      return onUnknownRoute(settings);
    }

    return MaterialPageRoute(
      builder: (context) => raw.last.child,
      settings: settings,
    );
  }

  Route<dynamic>? onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => const RouteMessengerWidget(),
      settings: settings,
      fullscreenDialog: true,
    );
  }

  bool onPopPage(Route<dynamic> route, dynamic result) {
    if (notifier.uri.path.startsWith(root) && notifier.uri.pathSegments.length > 1) {
      notifier.pop();
    }
    notifyListeners();
    // debugPrint('inner-onPopPage $result');
    return route.didPop(result);
  }

  // This is not required for inner router delegate because it does not
  // parse route
  @override
  Future<void> setNewRoutePath(Uri configuration) async {}

  // @override
  // Uri get currentConfiguration {
  //   return notifier.uri;
  // }
}
