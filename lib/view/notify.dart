import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ViewNotify {

  static ValueNotifier<int> navigation = ValueNotifier<int>(0);

  // static void navigationListener(Function(int) listener) {
  //   navigation.addListener(() => listener(navigation.value));
  // }
  // int _current = 0;

  // int? get current => _current;
  // set current(int? index) {
  //   _current = index!;
  //   notifyListeners();
  // }
}


class ViewScrollNotify extends ChangeNotifier {

  // notification is UserScrollNotification
  // dynamic _notification;

  // dynamic get notification => _notification;
  // set notification(dynamic value) {
  //   _notification = value!;
  //   notifyListeners();
  // }

  dynamic _notification;
  dynamic get notification => _notification;
  set notification(dynamic v) => notifyIf<dynamic>(_notification, _notification = v);

  ScrollMetrics? _metrics;
  ScrollMetrics? get metrics => _metrics;
  set metrics(ScrollMetrics? v) => notifyIf<ScrollMetrics?>(_metrics, _metrics = v);

  bool _isUpdating  = false;
  bool get isUpdating => _isUpdating;
  set isUpdating(bool v) => notifyIf<bool>(_isUpdating, _isUpdating = v);

  bool _isEnded  = true;
  bool get isEnded => _isEnded;
  set isEnded(bool v) => notifyIf<bool>(_isEnded, _isEnded = v);

  bool _isUser  = false;
  bool get isUser => _isUser;
  set isUser(bool v) => notifyIf<bool>(_isUser, _isUser = v);

  int _direction = 0;
  int get direction => _direction;
  set direction(int v) => notifyIf<int>(_direction, _direction = v);

  void notifyIf<T>(T element, T value) {
    if (value != element){
      notifyListeners();
    }
  }
}

// Consumer<ScrollNotify>(
//   // selector: (_, e) => ScrollNotify(),
//   // builder: (context, core, _)
//   builder: (BuildContext context, ScrollNotify scroll, Widget? child) {}
// )
    // if (notification == null) return;
    // if (notification is UserScrollNotification) {
    //   // NOTE: down
    //   // if (notification.direction == ScrollDirection.forward) direction.value = 2;
    //   // NOTE: up
    //   // if (notification.direction == ScrollDirection.reverse) direction.value = 1;
    //   // if (notification.direction == ScrollDirection.idle) direction.value = 0;
    //   // direction.value = notification.direction.index;
    //   direction.value = notification.direction.index;
    //   if (notification.direction == ScrollDirection.idle) {

    //     // _scrollEnd(notification.metrics);
    //     // if ([0.0, 1.0].contains(percentageShrink)) {
    //     //   return;
    //     // }

    //     // final offset = percentageShrink.round() == 1? -_delta: height - _delta;

    //     // controller.animateTo(
    //     //   controller.offset + offset,
    //     //   duration: Duration(milliseconds: 200),
    //     //   curve: Curves.linear,
    //     // );
    //   }
    // }
    // // if (notification is ScrollStartNotification) {}
    // if (notification is ScrollUpdateNotification) {
    //   // if (notification.depth > 0)
    //   // print(notification.depth);
    //   if (enableNotify.value) _scrollUpdate(notification.metrics);
    // }
    // if (notification is ScrollEndNotification) _scrollEnd(notification.metrics);