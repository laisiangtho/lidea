part of 'main.dart';

// SheetsDraggable
abstract class SheetsDraggable extends StatefulWidget {
  const SheetsDraggable({super.key});

  @override
  State<SheetsDraggable> createState() => SheetsDraggableState();
}

// TickerProviderStateMixin  SingleTickerProviderStateMixin
class SheetsDraggableState<T extends StatefulWidget> extends ViewStateWidget<T>
    with SingleTickerProviderStateMixin {
  late final draggableController = DraggableScrollableController();
  ScrollController? scrollController;

  ViewData get viewData => ViewData();

  late final AnimationController switchController = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: this,
  );
  late final Animation<double> switchAnimation = Tween(
    begin: 0.0,
    end: 1.0,
  ).animate(switchController);

  // NOTE: update when scroll notify 0.16
  // double _initialSize = 0.16;
  double _initialSize = 0;

  /// NOTE: Overridable for Persistent showBottomSheet
  bool get persistent => false;

  /// NOTE: default height on persistent
  double get height => kBottomNavigationBarHeight;

  @override
  void initState() {
    super.initState();

    scrollController?.addListener(onUpdate);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController?.position.isScrollingNotifier.addListener(() {
        if (!persistent) return;
        if (scrollController!.position.isScrollingNotifier.value) {
          onStart();
        } else {
          // _setSnap();
          onEnd();
        }
      });
    });
  }

  double get viewPaddingTop => viewData.fromContext.viewPadding.top;
  double get viewPaddingBottom => viewData.fromContext.viewPadding.bottom;
  // double get viewPaddingTop => view.state.fromContext.viewPadding.top;
  // double get viewPaddingBottom => view.state.fromContext.viewPadding.bottom;
  // double get viewPaddingTop => state.fromContext.viewPadding.top;
  // double get viewPaddingBottom => state.fromContext.viewPadding.bottom;

  // double get kHeight => view.kBottomPadding + kBottomNavigationBarHeight;
  double get kHeight => viewPaddingBottom + height;
  double get kExtent => viewPaddingTop + kToolbarHeight;

  void onStart() {}

  void onUpdate() {}

  /// if factor is between 0.0 - 1.0, it will snap back
  void onEnd() {
    if (viewData.bottom.resetToggle) {
      scrollAnimateTo(size: actualInitialSize);
    } else {
      if (_initialSize == actualInitialSize) {
        draggableController.reset();
      }
    }
  }

  // DraggableScrollableNotification
  bool _draggableNotification(DraggableScrollableNotification notification) {
    if (!persistent) return true;

    _initialSize = notification.extent;
    _draggableEngine();
    return false;
  }

  void _draggableEngine() {
    final offset = ((_initialSize - actualInitialSize) * actualPointer).clamp(0.0, 1.0);
    viewData.bottom.toggle.value = (1.0 - offset).toDouble();
  }

  Future<void> scrollAnimateTo({double size = 0.0, int milliseconds = 200}) {
    return draggableController.animateTo(
      size,
      duration: const Duration(milliseconds: 200),
      curve: Curves.ease,
    );
  }

  /// Toggle scroll animation, if size is not provided "midSize" used
  Future<void> scrollAnimateToggle() {
    // size ??= actualMidSize;
    final hasShrink = _initialSize <= actualInitialSize;
    final adjustedSize = hasShrink ? actualMidSize : actualInitialSize;
    return scrollAnimateTo(size: adjustedSize);

    // size ??= actualMidSize;
    // final hasShrink = _initialSize == size;
    // final adjustedSize = hasShrink ? actualInitialSize : size;
    // return scrollAnimateTo(size: adjustedSize);
  }

  double get actualPointer => 7.0;
  double get actualInitialSize => kHeight / state.fromContext.size.height;
  double get actualMinSize => actualInitialSize;
  double get actualMidSize => 0.5;
  // 0.9375
  double get actualMaxSize {
    double apple = 1.0 - actualInitialSize;
    if (apple > actualInitialSize) {
      return apple;
    }
    return 1.0 - (kExtent / state.fromContext.size.height);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: viewData.bottom.factor,
      builder: (BuildContext _, double factor, Widget? child) {
        if (persistent) {
          return _builder(factor);
        }
        return _builder(1.0);
      },
    );
  }

  Widget _builder(double factor) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: _draggableNotification,
      child: DraggableScrollableSheet(
        expand: false,
        controller: draggableController,
        initialChildSize: actualInitialSize * factor,
        minChildSize: actualMinSize * factor,
        maxChildSize: actualMaxSize,
        builder: (BuildContext context, ScrollController controller) {
          scrollController = controller;

          return decoration(
            child: ViewScroll(
              child: CustomScrollView(
                controller: scrollController,
                // physics: const NeverScrollableScrollPhysics(),
                // scrollBehavior: const ViewScrollBehavior(),
                // physics: const ScrollPhysics(),
                // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                // physics: const BouncingScrollPhysics(),
                slivers: slivers(),
                restorationId: 'view-bottomsheet',
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> slivers() {
    return <Widget>[
      const SliverAppBar(
        // floating: true,
        pinned: true,
        // snap: true,
        title: Text('Sheet'),
      ),
      SliverToBoxAdapter(
        child: ElevatedButton(
          onPressed: scrollAnimateTo,
          child: const Text('.animateTo() reset'),
        ),
      ),
      SliverToBoxAdapter(
        child: ElevatedButton(
          onPressed: () {
            scrollAnimateTo(size: 0.5, milliseconds: 200);
          },
          child: const Text('draggableController.animateTo(0.5)'),
        ),
      ),
    ];
  }

  Widget decoration({Widget? child}) {
    if (persistent) {
      return Container(
        // margin: const EdgeInsets.symmetric(horizontal: 30),
        // margin: const EdgeInsets.only(top: kToolbarHeight),
        decoration: BoxDecoration(
          // color: persistent ? theme.scaffoldBackgroundColor.withOpacity(0.5) : theme.primaryColor,
          // color: theme.primaryColor,
          // color: Theme.of(context).primaryColor,
          color: Theme.of(context).bottomSheetTheme.modalBackgroundColor,
          // color: Colors.transparent,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(10),
            // top: Radius.elliptical(15, 15),
          ),

          // borderRadius: const BorderRadius.vertical(
          //   top: Radius.circular(10),
          //   // top: Radius.elliptical(15, 15),
          // ),
          // border: Border.all(color: Colors.blueAccent),
          // border: Border(
          //   top: BorderSide(width: 0.5, color: theme.shadowColor),
          // ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,

              // color: theme.shadowColor.withOpacity(0.9),
              // color: theme.backgroundColor.withOpacity(0.6),
              blurRadius: 0.5,
              spreadRadius: 0.0,
              offset: const Offset(0, 0),
            )
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: child,
      );
    }
    return child!;
  }
}
