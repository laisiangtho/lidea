part of view.scrolls;

class ScrollBottomNavigation {
  final ScrollBottomNotifier notifier;

  final ScrollBottomListener listener;
  final double? height;
  final double? pointer;
  ScrollBottomNavigation({
    required this.listener,
    required this.notifier,
    this.height,
    this.pointer,
  }) {
    listener.height = height ?? kBottomNavigationBarHeight;
    listener.pointer = pointer ?? kBottomNavigationBarHeight;
    listener.factor.addListener(() {
      notifier.factor.value = listener.factor.value;
    });
    notifier.toggle.addListener(() {
      listener.lock.value = notifier.lock;
    });
    notifier.id.addListener(_toggle);
  }

  // _reset toShow
  bool get _reset => notifier.factor.value != listener.factor.value;
  bool get _show => notifier.factor.value < listener.factor.value;

  void _toggle() {
    if (!_reset) return;

    notifier.streamFactor(show: _show);
  }
}

class ScrollBottomNotifier with ScrollsValueNotifier {
  /// Primary bottom navigation toggle
  final ValueNotifier<int> id = ValueNotifier(0);

  /// Check bottom navigation bar is lock or to be locked
  bool get lock => toggle.value == 0.0;

  /// Check toggle need to reset
  /// 0.0 < toggle && toggle < 1.0
  bool get resetToggle => 0.0 < toggle.value && toggle.value < 1.0;

  void refresh() {
    id.value++;
  }
}

// ScrollBottomController
// ScrollBottomListener
class ScrollBottomListener extends ScrollsController with ScrollsValueNotifier {
  ScrollBottomListener(super.scroll);

  late double height;
  late double pointer;
  // double get limit => kBottomNavigationBarHeight;
  // double get limit => 20;

  double _delta = 0.0, _offset = 0.0;

  final lock = ValueNotifier<bool>(false);
  double get _heightFactor => 1.0 - (_delta / pointer);

  @override
  void onUpdate() {
    if (lock.value) {
      return;
    }

    if (extentBefore == 0.0) {
      // NOTE: Over scrolling or bouncing, it is already reached top
      if (factor.value == 1.0) return;
      // NOTE: ensure that BottomNavigation is fully visible
      factor.value = 1.0;
      return;
    }

    if (_hasLimit) {
      // NOTE: Over scrolling or bouncing, it is already reached bottom
      if (factor.value == 1.0) {
        // NOTE: ensure that BottomNavigation is fully visible
        return;
      }
      _delta = (_delta - pixels + _offset).clamp(0.0, pointer);
    } else {
      _delta = (_delta + pixels - _offset).clamp(0.0, pointer);
    }

    // _delta = (_delta + pixels - _offset).clamp(0.0, limit);
    _offset = pixels;

    factor.value = _heightFactor;
  }

  @override
  void onEnd() {
    if (factor.value == 0.0 || factor.value == 1.0) return;
    bool show = factor.value > 0.3;
    streamFactor(show: show).onDone(() {
      _resetPosition(show);
    });
  }

  bool get _hasLimit {
    double kValue = height * factor.value;
    return (extentAfter - kValue) <= (pointer + kValue);
  }

  void _resetPosition(bool show) {
    if (show) {
      _delta = 0.0;
    } else {
      _offset = 0.0;
    }
  }
}
