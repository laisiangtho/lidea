part of 'main.dart';

class ViewNavigationModel {
  final int key;
  final String? description;
  final String? name;
  final IconData? icon;
  final void Function()? action;

  const ViewNavigationModel({
    this.key = 0,
    this.name,
    this.icon,
    this.description,
    this.action,
  });
}
// Navigate Navigator NavigationBottomType NavigationArgumentType

/// readonly Navigator
///
/// route where the route came from using [ViewNavigationModel]
class ViewNavigationArguments {
  final bool canPop;
  final Object? args;
  final Object? route;
  final GlobalKey<NavigatorState>? navigator;

  const ViewNavigationArguments({
    this.canPop = false,
    this.args,
    this.route,
    required this.navigator,
  });
}
