/*
version: 0.2
developer: Khen Solomon Lethil
*/
part of 'root.dart';

abstract class ScrollPageController {

  ScrollPageController(this.controller) {
    // controller.lateNotify = ValueNotifier<ScrollNotification>(null);

    // controller.addListener((){
    //   print('controller.addListener');
    // });
    // this.controller.notifyListeners();
    
    // ignore: unnecessary_null_comparison
    
    // if (controller.lateNotify == null) {
    //   print('ScrollPageController');
    //   // controller.scrollNotification(listener);
    // }
    
    // controller.scrollNotification(listener);
    this.controller.addListener((){


      print('controller $controller');
      // if (controller is UserScrollNotification) {
      // }
      // this.listener(controller);
    });
  }

  ScrollController controller;

  /// Height of the bar
  double get height;

  double _delta = 0.0, _offsetOld = 0.0; //_minOffset=0.0, _maxOffset=1.0;
  final heightNotify = ValueNotifier<double>(1.0);
  final direction = ValueNotifier<int>(0);
  final enableNotify = ValueNotifier<bool>(true);
  void enable (bool s) => enableNotify.value = s;

  double get percentage => (_delta / height).toDouble();
  double get percentageShrink => (1.0 - percentage).toDouble();
  // double get percentageStretch => ??;

  void listener(dynamic notification) {
    

    if (notification == null) return;
    if (notification is UserScrollNotification) {
      // NOTE: down
      // if (notification.direction == ScrollDirection.forward) direction.value = 2;
      // NOTE: up
      // if (notification.direction == ScrollDirection.reverse) direction.value = 1;
      // if (notification.direction == ScrollDirection.idle) direction.value = 0;
      // direction.value = notification.direction.index;
      direction.value = notification.direction.index;
      if (notification.direction == ScrollDirection.idle) {

        // _scrollEnd(notification.metrics);
        // if ([0.0, 1.0].contains(percentageShrink)) {
        //   return;
        // }

        // final offset = percentageShrink.round() == 1? -_delta: height - _delta;

        // controller.animateTo(
        //   controller.offset + offset,
        //   duration: Duration(milliseconds: 200),
        //   curve: Curves.linear,
        // );
      }
    }
    // if (notification is ScrollStartNotification) {}
    if (notification is ScrollUpdateNotification) {
      // if (notification.depth > 0)
      // print(notification.depth);
      if (enableNotify.value) _scrollUpdate(notification.metrics);
    }
    if (notification is ScrollEndNotification) _scrollEnd(notification.metrics);
  }

  void _scrollUpdate(ScrollMetrics scroll) {
    final pixels = scroll.pixels;
    if (pixels < 0.0) return;
    // if ([0.0, 1.0].contains(heightNotify.value)) return;
    if ((_delta == 0.0 && heightNotify.value == 0.0) || (_delta == height && heightNotify.value == 1.0)) return;
    double maxExtent = scroll.maxScrollExtent, limit = maxExtent - height;
    if (pixels >= limit ){
      if (_delta > 0.0 ) {
        _offsetOld = pixels;
        final _deltaBottom = scroll.extentAfter.clamp(0.0, height);
        _delta = min(_delta,_deltaBottom);
      }
    } else {
      _delta = (_delta + pixels - _offsetOld).clamp(0.0, height);
      _offsetOld = pixels;
    }
    // if ((_delta == 0.0 && heightNotify.value == 0.0) || (_delta == height && heightNotify.value == 1.0)) return;
    heightNotify.value = percentageShrink;
  }

  void _scrollEnd(ScrollMetrics scroll) {
    /// NOTE: do skip for its reached
    if (_delta == 0.0 || _delta == height) return;

    if ([0.0, 1.0].contains(percentageShrink)) return;

    _delta = percentageShrink.round() == 1? 0.0:height;
    heightNotify.value = percentageShrink;
  }

  void dispose() {
    controller.dispose();
    direction.dispose();
    heightNotify.dispose();
  }
}

extension ScrollControllerExtension on ScrollController {

  
  static final _master = ScrollController();
  // static final _bar = <int, _ScrollBarControllerExtends>{};
  static final _bottom = <int, _ScrollBottomControllerExtends>{};

  // abstract class ScrollNotification extends LayoutChangedNotification with ViewportNotificationMi
  // static late ScrollNotification abc;

  // ignore: null_check_always_fails
  // static final ValueNotifier<ScrollNotification> notify = ValueNotifier<ScrollNotification>();
  // static late ValueNotifier<int> apple;
  // ValueNotifier<int> get lateNotify => apple;
  // set lateNotify (ValueNotifier<int> abc) => apple = abc;

  static late ValueNotifier<ScrollNotification> abc;
  // ValueNotifier<ScrollNotification> get lateNotify => apple;
  // set lateNotify (ValueNotifier<ScrollNotification> abc) => apple = abc;

  // static late ValueNotifier<ScrollNotification> notify;
  // ValueNotifier<ScrollNotification> get notification => notify;
  // set notification (ValueNotifier<ScrollNotification> abc) => notify = abc;

  // void scrollNotification(Function(ScrollNotification) listener) {
  //   // ignore: unnecessary_null_comparison
  //   if (abc != null) {
  //     abc.addListener(() => listener(abc.value));
  //   }
  // }
  // void setValueNotify(ValueNotifier<ScrollNotification> asdfasdf) {
  //   abc = asdfasdf;
  // }

  ScrollController get master => _master;
  // ScrollController get master => ScrollController();

  // _ScrollBarControllerExtends get bar {
  //   if (_bar.containsKey(this.hashCode)) {
  //     return _bar[this.hashCode];
  //   }
  //   return _bar[this.hashCode] = _ScrollBarControllerExtends(this);
  // }

  _ScrollBottomControllerExtends? get bottom {
    if (_bottom.containsKey(this.hashCode)) {
      return _bottom[this.hashCode];
    }
    return _bottom[this.hashCode] = _ScrollBottomControllerExtends(this);
  }
}

class _ScrollBottomControllerExtends extends ScrollPageController {
  _ScrollBottomControllerExtends(ScrollController scrollController)
      : super(scrollController);

  @override
  double height = kBottomNavigationBarHeight;

  /// Notifier of the active page index

  final pageNotify = ValueNotifier<int>(0);

  final toggleNotify = ValueNotifier<bool>(false);

  /// true is hide
  void toggle(bool status) => toggleNotify.value = status;

  /// Register a closure to be called when the tab changes
  void pageListener(Function(int) listener) {
    pageNotify.addListener(() => listener(pageNotify.value));
  }

  /// Set current page index
  void pageChange(int? index) {
    // print(scrollController.);
    if (index != null) pageNotify.value = index;
  }

  @override
  void dispose() {
    pageNotify.dispose();
    toggleNotify.dispose();
    super.dispose();
  }
}
