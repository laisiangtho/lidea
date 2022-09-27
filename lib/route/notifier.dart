part of lidea.route;

class RouteChangeNotifier extends ChangeNotifier {
  int _viewIndex = 0;
  Uri uri = Uri(path: '');
  final List<Uri> history = [];

  /// Does not matter whether you lead with slash or not,
  /// since this is intended to support nested
  /// and navigator with flutter is not unique primarily
  /// therefore using slash prefix is not sensitive
  void pushNamed(String name, {Map<String, dynamic>? arguments}) {
    uri = Uri(
      path: removeLeadingSlash(name),
      queryParameters: arguments?.map((e, v) => MapEntry(e, v.toString())),
    );

    setIndex();
    notifyListeners();
  }

  void pop() {
    // pushNamed(uri.path.substring(0, uri.path.lastIndexOf('/')), arguments: uri.queryParameters);
    String name = '';
    if (uri.path.contains('/')) {
      history.removeWhere((e) => e.path == uri.path);
      name = uri.path.substring(0, uri.path.lastIndexOf('/'));
    }
    pushNamed(name);
  }

  int get viewIndex => _viewIndex;
  set viewIndex(int index) {
    final raw = routesPrimary.elementAt(index);

    String name = raw.name;
    final idh = history.indexWhere((e) => name.length > 1 && e.path.startsWith(name));
    // final idh = history.indexWhere((e) => name.isNotEmpty && e.path.startsWith(name));

    if (idh >= 0) {
      name = history.elementAt(idh).path;
    }
    if (uri.pathSegments.length > 1) {
      final idx = history.indexWhere((e) => e.pathSegments.first == uri.pathSegments.first);

      if (idx == -1) {
        history.add(uri);
      } else if (history.elementAt(idx).path != uri.path) {
        history[idx] = uri;
      }
    }

    pushNamed(name);
  }

  void setIndex() {
    // final value = routesMapped.isEmpty ? '' : routesMapped.first.name;
    _viewIndex = routesPrimary.indexWhere((e) {
      if (routesMapped.isEmpty) {
        return true;
      }
      return e.name == routesMapped.first.name;
      // return e.name == routesMapped.first.name;
    });
  }

  /// Default return empty RouteType list, required to override
  List<RouteType> get routes {
    return [];
  }

  late final _route = routes;

  List<RouteType> get routesMapped {
    return mapping(routes: _route);
  }

  List<RouteType> get routesPrimary {
    return _route.where((e) => e.primaryNavigation).toList();
  }

  /// Responsible mapping route
  List<RouteType> mapping({String? name, List<RouteType>? routes, String root = ''}) {
    name ??= uri.path;
    routes ??= _route;
    final segments = removeLeadingSlash(name).split('/');
    // final root = 'reader';

    final List<RouteType> raw = [];

    if (segments.isNotEmpty) {
      Iterable<RouteType> rawChildren = [];

      bool started = true;
      for (var val in segments) {
        if (rawChildren.isEmpty && started) {
          // rawChildren = routes.where((e) => e.name == name || e.name == '/$name');
          // debugPrint('mapping: $root $name');
          // '/'.replaceFirst('/', root)
          // rawChildren = routes.where((e) => e.name == name);
          // final asdf = root.isNotEmpty
          rawChildren = routes.where((e) {
            String eName = removeLeadingSlash(e.name);
            return (eName.isEmpty ? root : eName) == val;
            // return eName == val;
          });
        }

        final sub = rawChildren.where((e) {
          // final eName = e.name.replaceFirst('/', '').isEmpty ? root : e.name;
          String eName = removeLeadingSlash(e.name);
          eName = eName.isEmpty ? root : eName;
          if (eName == ':any') {
            return true;
          } else if (eName == ':int') {
            return int.tryParse(val) != null;
          } else if (eName == ':string') {
            return int.tryParse(val) == null;
          } else {
            return eName == val;
          }
        }).map((e) {
          // Create Page key unique
          // e.value = val;
          return e;
        });
        if (sub.isNotEmpty) {
          raw.addAll(sub);
          rawChildren = sub.first.route;
        }
        started = false;
      }
    }

    if (raw.isEmpty) {
      raw.addAll(routes.where((e) => e.name.isEmpty || e.name == root));
    }
    return raw;
  }

  // Uri route2Uri(RouteSettings settings) {
  //   return Uri(path: removeLeadingSlash(settings.name ?? ''));
  // }

  String removeLeadingSlash(String name) {
    return name.startsWith('/') ? name.replaceFirst('/', '', 0) : name;
  }

  /// Route map and return Single RouteType
  RouteType show(String name) {
    final raw = mapping(name: name);
    if (raw.isEmpty) {
      return RouteType();
    }
    return raw.last;
  }

  // NavigatorState navigator(BuildContext context, {bool rootNavigator = false}) {
  //   Navigator.maybeOf(context);
  //   return Navigator.of(context, rootNavigator: rootNavigator);
  // }

  /// showModalBottomSheet using route
  Future<T?> showSheetModal<T>({
    required BuildContext context,
    required String name,
    Object? arguments,
    bool isScrollControlled = true,
    bool useRootNavigator = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      barrierColor: Theme.of(context).shadowColor.withOpacity(0.5),
      routeSettings: RouteSettings(name: name, arguments: arguments),
      builder: (BuildContext _) => show(name).child,
    );
  }

  /// showBottomSheet  using route
  PersistentBottomSheetController<T> showSheetStack<T>({
    required BuildContext context,
    required String name,
    Object? arguments,
  }) {
    final raw = show(name);

    return showBottomSheet<T>(
      context: context,
      builder: (BuildContext context) => raw.child,
    );
  }
}

/*

  /// showModalBottomSheet using route
  Future<T?> showSheetModal<T>({
    required BuildContext context,
    required String name,
    bool isScrollControlled = true,
    bool useRootNavigator = true,
    Object? arguments,
  }) {
    final raw = mapping(
      uri: Uri(path: name),
      routes: _route,
    );
    routes.map((e) {
      debugPrint(e.name);
    });
    // final raw = mapping(
    //   uri: Uri(path: name),
    //   routes: _route,
    // );
    if (raw.isEmpty) {
      return showModalBottomSheet<T>(
        context: context,
        isScrollControlled: isScrollControlled,
        useRootNavigator: useRootNavigator,
        builder: (BuildContext context) {
          return const Text('No sheet');
        },
      );
    }
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      routeSettings: RouteSettings(name: name, arguments: arguments),
      builder: (BuildContext context) => raw.last.child,
    );
  }

  /// showBottomSheet
  PersistentBottomSheetController<T> showSheetStack<T>({
    required BuildContext context,
    required String name,
    Object? arguments,
  }) {
    final raw = mapping(
      uri: Uri(path: name),
      routes: _route,
    );
    routes.map((e) {
      debugPrint(e.name);
    });

    // if (raw.isEmpty) {
    //   return showModalBottomSheet<T>(
    //     context: context,
    //     isScrollControlled: isScrollControlled,
    //     useRootNavigator: useRootNavigator,
    //     builder: (BuildContext context) {
    //       return const Text('No sheet');
    //     },
    //   );
    // }
    // return showModalBottomSheet<T>(
    //   context: context,
    //   isScrollControlled: isScrollControlled,
    //   useRootNavigator: useRootNavigator,
    //   routeSettings: RouteSettings(name: name, arguments: arguments),
    //   builder: (BuildContext context) => raw.last.child,
    // );

    return showBottomSheet<T>(
      context: context,
      builder: (BuildContext context) => raw.last.child,
    );
  }

  void showModalSheetTest(String name, {Object? arguments}) {}
  */