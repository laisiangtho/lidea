part of 'main.dart';

abstract class ScrollsController {
  ScrollController scroll;
  ScrollsController(this.scroll) {
    scroll.addListener(onUpdate);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onInit();
      scroll.position.isScrollingNotifier.addListener(() {
        if (scroll.position.isScrollingNotifier.value) {
          onStart();
        } else {
          onEnd();
        }
      });
    });
  }
  void onInit() {}

  void onStart() {
    // debugPrint('scroll is started');
  }

  void onUpdate() {
    // debugPrint('scroll is updating');
  }

  void onEnd() {
    // debugPrint('scroll is ended');
  }

  ScrollPosition get position => scroll.position;

  /// The number of pixels to offset the children in the opposite of the axis direction.
  double get pixels => position.pixels;

  /// The quantity of content conceptually "above" the viewport in the scrollable.
  /// This is the content above the content described by [extentInside].
  double get extentBefore => position.extentBefore;

  /// The quantity of content conceptually "below" the viewport in the scrollable.
  /// This is the content below the content described by [extentInside].
  double get extentAfter => position.extentAfter;

  /// Down(forward): 1, Up(reverse): 2
  int get direction => position.userScrollDirection.index;
}

mixin ScrollsValueNotifier {
  /// Primary factor
  final ValueNotifier<double> factor = ValueNotifier(1.0);

  /// Primary toggle
  final ValueNotifier<double> toggle = ValueNotifier(1.0);

  StreamSubscription<double> streamFactor({bool show = true}) {
    return streamDouble(factor.value, show: show).listen((double value) {
      factor.value = value;
    });
  }

  // 55/56*100 height/kHeight*100 -> /100
  Stream<double> streamDouble(double value, {bool show = true}) async* {
    double calcd = 0.0;
    value = value * 100;
    while (show ? value <= 100 : value >= 0.0) {
      await Future.delayed(Duration.zero);
      // await Future.delayed(const Duration(microseconds: 100));
      // await Future.delayed(const Duration(microseconds: 1));
      // await Future.delayed(const Duration(microseconds: 0));
      calcd = (show ? value++ : value--).toDouble() / 100;
      yield calcd;
    }
    yield calcd.roundToDouble();
  }

  /// Discards resources
  void dispose() {
    factor.dispose();
    toggle.dispose();
  }
}
