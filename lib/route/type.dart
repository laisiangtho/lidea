part of lidea.route;

class RouteType {
  /// Unique pathName
  final String name;

  /// Create unique key on sub :int, :str, :any
  // String? value;
  final dynamic arguments;
  final Widget? page;
  final List<RouteType> route;

  /// On main route used as Shell and on inner route used as BottomNavigation
  final bool primaryNavigation;
  final String label;
  final IconData icon;

  RouteType({
    this.name = '',
    // this.value,
    this.arguments,
    this.primaryNavigation = false,
    this.page,
    this.route = const [],
    this.label = '',
    this.icon = Icons.extension_outlined,
  });

  /// get Identity
  String get identity => name.isEmpty ? 'main' : name;

  /// is Nested
  bool get nested => route.isNotEmpty;

  /// Widget
  Widget get child => page ?? const RouteMessengerWidget();

  /// key identity
  String get key => '-$name-id-$identity';

  @override
  String toString() {
    return name;
  }
}
