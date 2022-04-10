part of lidea.view;

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
  final GlobalKey<NavigatorState> key;
  final bool canPop;

  /// used as queries or parent ViewNavigationArguments
  final Object? args;

  const ViewNavigationArguments({
    required this.key,
    this.canPop = false,
    this.args,
  });

  NavigatorState? get currentState => key.currentState;

  bool get hasParam => args != null;
  T? param<T>() => args as T?;

  // parent.key!.currentState!.pushNamedAndRemoveUntil('/home', (route) => false);
  // parent.key!.currentState!.pop();

  // late final ViewNavigationArguments arguments = widget.arguments as ViewNavigationArguments;
  // late final bool canPop = widget.arguments != null;
  // late final GlobalKey<NavigatorState> navigator = arguments.key!;

  // late final ViewNavigationArguments parent = arguments.args as ViewNavigationArguments;
  // late final bool canParent = widget.arguments != null;
}
