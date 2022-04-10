part of lidea.view;

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

  /// Status bar height
  late final kHeightStatusBar = MediaQueryData.fromWindow(window).padding.top;

  // NOTE: Navigation ???
  final double kHeight = kBottomNavigationBarHeight;

  double _factor = 1.0;
  double get factor => _factor;
  set factor(double v) {
    if (0.0 <= v && v <= 1.0) {
      notifyIf<double>(_factor, _factor = v);
    }
  }

  /// disable/enable size notification
  bool _locked = false;

  /// check lock status
  bool get lock => _locked;

  /// set lock to disable/enable size notification
  set lock(bool v) => notifyIf<bool>(_locked, _locked = v);

  double _delta = 0.0;
  double _offset = 0.0;

  // [56,0]
  double get heightStretch => (kHeight * factor).toDouble();
  double get heightShrink => (1.0 - heightStretch).toDouble();

  // [1,0]
  double get factorStretch => (_delta / kHeight).toDouble();
  double get factorShrink => (1.0 - factorStretch).toDouble();

  /*
  void _scrollUpdate(ScrollMetrics scroll) {
    final pixels = scroll.pixels;

    _delta = (_delta + pixels - _offset).clamp(0.0, kHeight);
    _offset = pixels;

    // If scrolled down, size-notifiers value should be zero.
    // Can be imagined as [zero - false] | [one - true].
    if (scroll.axisDirection == AxisDirection.down && scroll.extentAfter == 0.0) {
      if (factor == 0.0) return;

      factor = 0.0;
      return;
    }

    // If scrolled up, size-notifiers value should be one.
    // Can be imagined as [zero - false] | [one - true].
    if (scroll.axisDirection == AxisDirection.up && scroll.extentBefore == 0.0) {
      if (factor == 1.0) return;

      factor = 1.0;
      return;
    }

    final isZeroValued = _delta == 0.0 && factor == 0.0;
    if (isZeroValued || (_delta == kHeight && factor == 1.0)) return;

    factor = percentageShrink;
  }
  */

  void scrollUpdate(ScrollMetrics scroll) {
    if (lock) {
      return _resetPosition();
    }

    final pixels = scroll.pixels;
    if (pixels < 0.0) return;

    double maxExtent = scroll.maxScrollExtent;

    double limit = maxExtent - kHeight;
    if (pixels >= limit) {
      // NOTE: getting to min height bottom
      final _minExtent = scroll.extentAfter.clamp(0.0, kHeight);
      _delta = min(_delta, _minExtent);
    } else if (_offset > 0.0) {
      _delta = (_delta + pixels - _offset).clamp(0.0, kHeight);
    }

    _offset = pixels;
    factor = factorShrink;
  }

  void scrollEnd(ScrollMetrics scroll) {
    if (lock) return;

    /// NOTE: do skip for its reached
    // if (_delta == 0.0 || _delta == kHeight) return;
    if ([0.0, kHeight].contains(_delta)) return;
    if ([0.0, 1.0].contains(factorShrink)) return;

    final _hgt = (heightStretch / kHeight * 100).roundToDouble();

    final isDown = factorShrink < 0.4;

    _streamCount(_hgt, down: isDown).listen((double value) {
      if ([0.0, 1.0].contains(factor)) return;

      factor = value / 100;
    });
    _resetPosition();
  }

  /// NOTE: session offset and delta need to reset to have smooth scrolling
  void _resetPosition() {
    if (_offset != 0.0) {
      _offset = 0.0;
    }
    if (_delta != 0.0) {
      _delta = 0.0;
    }
  }

  // 55/56*100 height/kHeight*100 -> /100
  //
  Stream<double> _streamCount(double n, {bool down = true}) async* {
    while (down ? n >= 0.0 : n <= 100) {
      await Future.delayed(const Duration(microseconds: 0));
      yield (down ? n-- : n++).roundToDouble();
    }
  }
}
