
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'model.dart';
import 'notify.dart';

// controller = new ScrollController()..addListener(_scrollListener);
// controller = new ScrollController()..addListener((){
//   if (controller is ScrollEndNotification){
//     print('addListener end');
//   }
//   if (controller is UserScrollNotification) {

//     print('addListener.position ${controller.position}');
//   }
// });
// controller.position.isScrollingNotifier.addListener(() {
//   if(!controller.position.isScrollingNotifier.value) {
//     print('scroll is stopped');
//   } else {
//     print('scroll is started');
//   }
// });
    
class ViewPage extends StatelessWidget {
  final ScrollController? controller;
  final Widget child;
  final int depth;

  /// depth is useful on NestedScrollView
  ViewPage({
    Key? key,
    this.controller,
    this.depth:0,
    required this.child,
  });
  // : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ViewScrollNotify>(
      create: (context) => ViewScrollNotify(),
      // we use `builder` to obtain a new `BuildContext` that has access to the provider
      builder: (context,e) {
        // No longer throws
        // return Text(context.watch<ScrollNotify>()),
        return ScrollConfiguration(
          behavior: ScrollPageBehavior(),
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) => _notification(context,notification),
            child: child
          )
        );
      },
    );
    // return ScrollConfiguration(
    //   key: key,
    //   behavior: ScrollPageBehavior(),
    //   child: NotificationListener<ScrollNotification>(
    //     onNotification: (ScrollNotification notification) => _notification(context,notification),
    //     child: child
    //   )
    // );
  }

  bool _notification(BuildContext context,dynamic scroll) {
    if (scroll == null) return true;
    // if (controller.hasClients && scroll.depth == depth) controller.notification.value = scroll;

    final notify = Provider.of<ViewScrollNotify>(context, listen: false);
    notify.notification = scroll;

    if (scroll is ScrollStartNotification) {
      // notify.metrics = scroll.metrics; 
      notify.isUpdating = false;
      notify.isEnded = true;
    } else if (scroll is ScrollUpdateNotification) {
      // notify.metrics = scroll.metrics; 
      notify.isUpdating = true;
      notify.isEnded = false;
    } else if (scroll is ScrollEndNotification) {
      // notify.metrics = scroll.metrics; 
      notify.isUpdating = false;
      notify.isEnded = true;
    } else if (scroll is UserScrollNotification) {
      notify.direction = scroll.direction.index;
    }

    notify.metrics = scroll.metrics; 
    return false;
  }
}

class ScrollPageBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) => child;
}
