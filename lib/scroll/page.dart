part of 'root.dart';

class ScrollPage extends StatelessWidget {
  final ScrollController controller;
  final Widget child;
  final int depth;

  /// depth is useful on NestedScrollView
  ScrollPage({
    Key key,
    this.controller,
    this.depth:0,
    @required this.child,
  }) : assert(child != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollPageBehavior(),
      child: NotificationListener<ScrollNotification>(
        onNotification: _notification,
        child: child,
      )
   );
  }

  bool _notification(ScrollNotification notification) {
    if (controller != null && controller.hasClients && notification.depth == depth) controller.notification.value = notification;
    return false;
  }
}

class ScrollPageBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) => child;
}
