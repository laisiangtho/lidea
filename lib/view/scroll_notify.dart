part of 'main.dart';

class ViewScrollNotify extends Notify {
  // notification is UserScrollNotification

  dynamic _notification;
  dynamic get notification => _notification;
  set notification(dynamic v) => notifyIf<dynamic>(_notification, _notification = v);

  ScrollMetrics? _metrics;
  ScrollMetrics? get metrics => _metrics;
  set metrics(ScrollMetrics? v) => notifyIf<ScrollMetrics?>(_metrics, _metrics = v);

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;
  set isUpdating(bool v) => notifyIf<bool>(_isUpdating, _isUpdating = v);

  bool _isEnded = true;
  bool get isEnded => _isEnded;
  set isEnded(bool v) => notifyIf<bool>(_isEnded, _isEnded = v);

  bool _isUser = false;
  bool get isUser => _isUser;
  set isUser(bool v) => notifyIf<bool>(_isUser, _isUser = v);

  int _direction = 0;
  int get direction => _direction;
  set direction(int v) => notifyIf<int>(_direction, _direction = v);

  // NOTE: Navigation ???
  double bottomPadding = kBottomNavigationBarHeight + 30;
  double reservedHeight = 0.0;
  double _heightFactor = 1.0;
  double get heightFactor => _heightFactor;
  set heightFactor(double v) => notifyIf<double>(_heightFactor, _heightFactor = v);

  double get height => (kHeightMax * heightFactor).toDouble();
  // double get height => (kHeight*heightFactor).toDouble().clamp(5.0, height);
  // int get milliseconds => [0.0, 1.0].contains(heightFactor) ? 200 : 0;

  double get kHeightMax => (kBottomNavigationBarHeight + reservedHeight).toDouble();
  // double get kStatusHeight => MediaQueryData.fromWindow(window).padding.top;
  // final double kHeightMin = 0.0;

  double _delta = 0.0;
  double _offset = 0.0;

  double get percentageStretch => (_delta / kHeightMax).toDouble();
  double get percentageShrink => (1.0 - percentageStretch).toDouble();

  void scrollUpdate(ScrollMetrics scroll) {
    final pixels = scroll.pixels;
    if (pixels < 0.0) return;

    if ((_delta == 0.0 && heightFactor == 0.0) || (_delta == kHeightMax && heightFactor == 1.0))
      return;
    double maxExtent = scroll.maxScrollExtent;
    double limit = maxExtent - kHeightMax;
    if (pixels >= limit) {
      if (_delta > 0.0) {
        _offset = pixels;
        final _deltaBottom = scroll.extentAfter.clamp(0.0, kHeightMax);
        _delta = min(_delta, _deltaBottom);
      }
    } else {
      _delta = (_delta + pixels - _offset).clamp(0.0, kHeightMax);
      _offset = pixels;
    }
    // if ((_delta == 0.0 && heightFactor == 0.0) || (_delta == heightFactor && heightFactor == 1.0)) return;
    heightFactor = percentageShrink;
  }

  void scrollEnd(ScrollMetrics scroll) {
    /// NOTE: do skip for its reached
    // if (_delta == 0.0 || _delta == kHeightMax) return;
    if ([0.0, kHeightMax].contains(_delta)) return;
    if ([0.0, 1.0].contains(percentageShrink)) return;

    // _delta = percentageShrink.round() == 1.0 ? 0.0 : kHeightMax;
    // heightFactor = percentageShrink;

    final tmp = (height / kHeightMax * 100).roundToDouble();
    // print('tmp: $tmp');
    // final isDown = percentageShrink.round() == 1.0;
    final isDown = percentageShrink < 0.4;

    Stream<double> sequence = streamCount(tmp, down: isDown);

    sequence.listen((double value) {
      if ([0.0, 1.0].contains(heightFactor)) {
        // print('sequence: skiped');
        return;
      }
      // _delta = value / 100;
      heightFactor = value / 100;
      // _delta = heightFactor * kHeightMax;
      // print('Xdelta: $xdelta delta: $_delta');
    });
  }

  // 55/56*100 height/kHeightMax*100 -> /100
  //
  Stream<double> streamCount(double n, {bool down = true}) async* {
    while (down ? n >= 0.0 : n <= 100) {
      await Future.delayed(const Duration(microseconds: 0));
      yield (down ? n-- : n++).roundToDouble();
    }
  }
}
