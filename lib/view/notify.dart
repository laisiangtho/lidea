import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NotifyNavigationButton {

  static ValueNotifier<int> navigation = ValueNotifier<int>(0);
}

class NotifyViewScroll extends ChangeNotifier {

  // notification is UserScrollNotification

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

  // NOTE: Navigation
  double bottomPadding = 0.0;
  double _heightFactor = 1.0;
  double get heightFactor => _heightFactor;
  set heightFactor(double v) => notifyIf<double>(_heightFactor, _heightFactor = v);

  double get height => (kHeight*heightFactor).toDouble();
  // double get height => (kHeight*heightFactor).toDouble().clamp(5.0, height);
  int get milliseconds => [0.0, 1.0].contains(heightFactor)?200:0;

  double get kHeight => (kBottomNavigationBarHeight+bottomPadding).toDouble();

  double _delta = 0.0;
  double _offset = 0.0;

  double get percentageStretch => (_delta / kHeight).toDouble();
  double get percentageShrink => (1.0 - percentageStretch).toDouble();

  void scrollUpdate(ScrollMetrics scroll) {
    final pixels = scroll.pixels;
    if (pixels < 0.0) return;
    // if ([0.0, 1.0].contains(heightFactor)) return;
    if ((_delta == 0.0 && heightFactor == 0.0) || (_delta == kHeight && heightFactor == 1.0)) return;
    double maxExtent = scroll.maxScrollExtent, limit = maxExtent - kHeight;
    if (pixels >= limit ){
      if (_delta > 0.0 ) {
        _offset = pixels;
        final _deltaBottom = scroll.extentAfter.clamp(0.0, kHeight);
        _delta = min(_delta,_deltaBottom);
      }
    } else {
      _delta = (_delta + pixels - _offset).clamp(0.0, kHeight);
      _offset = pixels;
    }
    // if ((_delta == 0.0 && heightFactor == 0.0) || (_delta == heightFactor && heightFactor == 1.0)) return;
    heightFactor = percentageShrink;
  }

  void scrollEnd(ScrollMetrics scroll) {
    /// NOTE: do skip for its reached
    if (_delta == 0.0 || _delta == kHeight) return;

    if ([0.0, 1.0].contains(percentageShrink)) return;

    _delta = percentageShrink.round() == 1? 0.0:kHeight;
    heightFactor = percentageShrink;
  }

}
/*

class NotifyNavigationScroll extends ChangeNotifier {
  double bottomPadding;
  NotifyNavigationScroll({
    this.bottomPadding:0.0
  });

  void notifyIf<T>(T element, T value) {
    if (value != element){
      notifyListeners();
    }
  }

  double _heightFactor = 1.0;
  double get heightFactor => _heightFactor;
  set heightFactor(double v) => notifyIf<double>(_heightFactor, _heightFactor = v);

  double get height => (kHeight*heightFactor).toDouble();
  // double get height => (kHeight*heightFactor).toDouble().clamp(5.0, height);
  int get milliseconds => [0.0, 1.0].contains(heightFactor)?200:0;

  double get kHeight => (kBottomNavigationBarHeight+bottomPadding).toDouble();

  double _delta = 0.0;
  double _offset = 0.0;

  double get percentageStretch => (_delta / kHeight).toDouble();
  double get percentageShrink => (1.0 - percentageStretch).toDouble();

  void scrollUpdate(ScrollMetrics scroll) {
    final pixels = scroll.pixels;
    if (pixels < 0.0) return;
    // if ([0.0, 1.0].contains(heightFactor)) return;
    if ((_delta == 0.0 && heightFactor == 0.0) || (_delta == kHeight && heightFactor == 1.0)) return;
    double maxExtent = scroll.maxScrollExtent, limit = maxExtent - kHeight;
    if (pixels >= limit ){
      if (_delta > 0.0 ) {
        _offset = pixels;
        final _deltaBottom = scroll.extentAfter.clamp(0.0, kHeight);
        _delta = min(_delta,_deltaBottom);
      }
    } else {
      _delta = (_delta + pixels - _offset).clamp(0.0, kHeight);
      _offset = pixels;
    }
    // if ((_delta == 0.0 && heightFactor == 0.0) || (_delta == heightFactor && heightFactor == 1.0)) return;
    heightFactor = percentageShrink;
  }

  void scrollEnd(ScrollMetrics scroll) {
    /// NOTE: do skip for its reached
    if (_delta == 0.0 || _delta == kHeight) return;

    if ([0.0, 1.0].contains(percentageShrink)) return;

    _delta = percentageShrink.round() == 1? 0.0:kHeight;
    heightFactor = percentageShrink;
  }

}
*/
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