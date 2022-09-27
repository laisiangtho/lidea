library lidea.route;

import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';

part 'delegate.dart';
part 'notifier.dart';
part 'parser.dart';
part 'type.dart';
part 'nested.dart';
part 'messenger.dart';

/// Todo
/// * [ ] passing arguments
/// * [x] add dynamic pages on parent
/// * [ ] keepAlive
/// * [x] Deep Link
/// * [x] Remain on current state when switching bottom navigation
/// * [x] RouteType regex `{:int :string :any}

// class NavigatorRouteManager {
//   final NavigatorRouterMainDelegate delegate;

//   NavigatorRouteManager({required this.delegate});

//   NavigatorRouteChangeNotifier get state => delegate.state;

//   void pushNamed(String name, {dynamic arguments}) {
//     state.pushNamed(name, arguments: arguments);
//   }

//   void popNamed() {
//     state.popNamed();
//   }
// }

/// get is good and preferred then making variable
/// ```dart
/// // good and preferred
/// AppRouteNotifier get routes => Routes.of(context)
/// // this get setState whenever changes are made
/// late final routes = Routes.of(context)
/// ```
class NavigatorRouteManager<T extends Listenable> extends InheritedNotifier<T> {
  const NavigatorRouteManager({
    Key? key,
    required T notifier,
    required Widget child,
  }) : super(key: key, notifier: notifier, child: child);
}
// class NavigatorRoutes<T> extends InheritedNotifier<NavigatorRouterMainDelegate> {
//   const NavigatorRoutes({
//     Key? key,
//     required NavigatorRouterMainDelegate notifier,
//     required Widget child,
//   }) : super(key: key, notifier: notifier, child: child);

//   static NavigatorRoutes inheritedWidget(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<NavigatorRoutes>()!;
//   }

//   static NavigatorRouterMainDelegate of(BuildContext context) {
//     return NavigatorRoutes.inheritedWidget(context).notifier!;
//   }

//   static NavigatorRouteChangeNotifier state(BuildContext context) {
//     return NavigatorRoutes.of(context).state;
//   }
// }



// class NavigatorFadeAnimationPage extends Page {
//   final Widget child;

//   const NavigatorFadeAnimationPage({LocalKey? key, required this.child}) : super(key: key);

//   @override
//   Route createRoute(BuildContext context) {
//     return PageRouteBuilder(
//       settings: this,
//       pageBuilder: (context, animation, animation2) {
//         var curveTween = CurveTween(curve: Curves.easeIn);
//         return FadeTransition(
//           opacity: animation.drive(curveTween),
//           child: child,
//         );
//       },
//     );
//   }
// }
