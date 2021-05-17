import 'package:flutter/material.dart';
// import 'model.dart';
// import 'notify.dart';

class ViewPage extends StatelessWidget {
  // final ScrollController controller;
  final Widget child;
  final int depth;

  /// depth is useful on NestedScrollView
  ViewPage({
    Key? key,
    // required this.controller,
    this.depth:0,
    required this.child,
  });
  // : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      key: key,
      behavior: ScrollPageBehavior(),
      child: NotificationListener<ScrollNotification>(
        onNotification: _notification,
        child: child
      )
    );
  }

  bool _notification(ScrollNotification notification) {
    // Scrolln
    // print('ScrollPage $notification');
    // controller.setValueNotify(ValueNotifier<ScrollNotification>(notification));
    // controller.lateNotify = ValueNotifier<ScrollNotification>(notification);
    // if (controller.hasClients && notification.depth == depth) {
    //   controller.notification.value = notification;
    // }
    return false;
  }
}

class ScrollPageBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) => child;
}
