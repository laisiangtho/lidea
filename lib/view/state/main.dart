import 'package:flutter/material.dart';
import '/view/scrolls/main.dart' show ScrollBottomNotifier;

// Theme.of(context) ??
class ViewState {
  final BuildContext context;

  /// NavigatorState and ModalRoute provider
  /// ```dart
  /// ModalRoute<Object?>? route = ModalRoute.of(context);
  /// NavigatorState navigator = Navigator.of(context);
  /// ThemeData theme = Theme.of(context);
  /// MediaQueryData media = MediaQuery.of(context);
  /// ```
  const ViewState(this.context);

  /// convert arguments as T
  T as<T>() => arguments as T;

  // Of.scroll.window = MediaQueryData.fromWindow(window);
  ModalRoute<Object?>? get route => ModalRoute.of(context);
  NavigatorState get navigator => Navigator.of(context);
  ThemeData get theme => Theme.of(context);
  TextTheme get textTheme => theme.textTheme;

  /// MediaQuery.of(context)
  /// hoping to achieve unnecessary rebuild,
  /// at the same time getting Updated data
  MediaQueryData get fromContext => MediaQuery.of(context);

  /// height Of Bottom SafeArea -> notches
  /// MediaQuery.of(context).viewPadding.bottom;
  /// MediaQuery.of(context).padding.bottom
  /// safeAreaTop
  /// safeAreaBottom heightOfDock heightOfStatusBar
  /// spaceTop spaceBottom heightAbove heightBelowNavigation
  /// paddingBottom paddingTop
  double get viewPaddingTop => fromContext.viewPadding.top;
  double get viewPaddingBottom => fromContext.viewPadding.bottom;

  /// screen Height
  /// MediaQuery.of(context).size.height
  double get height => fromContext.size.height;

  /// screen Width
  /// MediaQuery.of(context).size.width
  double get width => fromContext.size.width;

  /// MediaQueryData.fromWindow(window)
  /// hoping to achieve unnecessary rebuild,
  /// at the same time getting Updated data
  MediaQueryData get fromWindow =>
      MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.single);

  /// height Of Top SafeArea -> StatusBar
  /// MediaQueryData.fromWindow(window).padding.top;
  double get kHeightStatusBar => fromWindow.padding.top;

  // mediaWindow mediaContext
  RouteSettings get settings => route!.settings;
  String? get name => settings.name;
  Object? get arguments => settings.arguments;

  /// arguments as Map<String, dynamic>
  Map<String, dynamic> get asMap => arguments as Map<String, dynamic>;

  bool get hasArgumentsEmpty => route == null || arguments == null || asMap.isEmpty;
  bool get hasArguments => !hasArgumentsEmpty;
}

abstract class ViewStateWidget<T extends StatefulWidget> extends State<T> {
  // late final ViewState state = ViewState(context);

  late ViewState state = ViewState(context);

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback(_mediaData);
  }

  // void _mediaData(Duration timestamp) {
  //   state = ViewState(context);
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    state = ViewState(context);
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  // @override
  // void setState(fn) {
  //   if (mounted) super.setState(fn);
  // }
}

class ViewData {
  final ScrollBottomNotifier bottom = ScrollBottomNotifier();

  /// MediaQuery.of(context)
  /// MediaQueryData, since modal bottom sheet does not get viewPadding data
  /// hoping to achieve unnecessary rebuild,
  /// at the same time getting Updated data
  MediaQueryData fromContext = const MediaQueryData();
}
