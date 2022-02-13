part of 'main.dart';

// controller = new ScrollController()..addListener(_scrollListener);
// controller = new ScrollController()..addListener((){
//   if (controller is ScrollEndNotification){
//     debugPrint('addListener end');
//   }
//   if (controller is UserScrollNotification) {

//     debugPrint('addListener.position ${controller.position}');
//   }
// });
// controller.position.isScrollingNotifier.addListener(() {
//   if(!controller.position.isScrollingNotifier.value) {
//     debugPrint('scroll is stopped');
//   } else {
//     debugPrint('scroll is started');
//   }
// });

class ViewPage extends StatelessWidget {
  final ScrollController? controller;
  final Widget child;
  final int depth;
  final bool Function(ScrollNotification)? onNotification;

  /// depth is useful on NestedScrollView
  const ViewPage({
    Key? key,
    this.controller,
    this.depth: 0,
    this.onNotification,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return ChangeNotifierProvider<ViewScrollNotify>(
    //   create: (context) => ViewScrollNotify(),
    //   // we use `builder` to obtain a new `BuildContext` that has access to the provider
    //   builder: (context,e) {
    //     // No longer throws
    //     // return Text(context.watch<ViewScrollNotify>()),
    //     return ScrollConfiguration(
    //       behavior: ScrollPageBehavior(),
    //       child: NotificationListener<ScrollNotification>(
    //         onNotification: (notification) => _notification(context,notification),
    //         child: child
    //       )
    //     );
    //   },
    // );
    return ScrollConfiguration(
      key: key,
      behavior: const ViewScrollBehavior(),
      child: NotificationListener<ScrollNotification>(
        onNotification: onNotification ??
            (ScrollNotification notification) {
              return _notification(context, notification);
            },
        // onNotification: (ScrollNotification notification) {
        //   return _notification(context, notification);
        // },
        child: child,
      ),
    );
  }

  bool _notification(BuildContext context, dynamic scroll) {
    if (scroll == null) return true;
    if (controller == null) return true;
    // if (controller.hasClients && scroll.depth == depth) controller.notification.value = scroll;
    // if (controller!.hasClients && scroll.depth == depth) return true;

    // While the widget tree was being built, laid out, and painted, a new frame was scheduled to rebuild the widget tree.
    // final notify = context.read<ViewScrollNotify>();
    final notify = Provider.of<ViewScrollNotify>(context, listen: false);
    // final nav = Provider.of<NotifyNavigationScroll>(context, listen: false);
    Future.microtask(
      () {
        notify.notification = scroll;

        if (scroll is ScrollStartNotification) {
          // notify.metrics = scroll.metrics;
          notify.isUpdating = false;
          notify.isEnded = true;
        } else if (scroll is ScrollUpdateNotification) {
          // notify.metrics = scroll.metrics;
          notify.isUpdating = true;
          notify.isEnded = false;
          notify.scrollUpdate(scroll.metrics);
        } else if (scroll is ScrollEndNotification) {
          // notify.metrics = scroll.metrics;
          notify.isUpdating = false;
          notify.isEnded = true;
          notify.scrollEnd(scroll.metrics);
        } else if (scroll is UserScrollNotification) {
          notify.direction = scroll.direction.index;
        }
        notify.metrics = scroll.metrics;
      },
    );
    // Future.delayed(Duration.zero, () {});

    return false;
  }
}

class ViewScrollBehavior extends ScrollBehavior {
  const ViewScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.android:
        // return const BouncingScrollPhysics();
        return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const ClampingScrollPhysics();
    }
  }

  @override
  Widget buildViewportChrome(BuildContext _, Widget child, AxisDirection _a) => child;
}
