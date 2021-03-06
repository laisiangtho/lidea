part of lidea.view;

abstract class ViewDraggableSheetWidget extends StatefulWidget {
  // initialSize: 0.6,
  //     minSize: 0.3,
  //     maxSize: 0.9,
  const ViewDraggableSheetWidget({Key? key}) : super(key: key);

  @override
  State<ViewDraggableSheetWidget> createState() => ViewDraggableSheetState();
}

// class ViewDraggableSheetState<ViewDraggableSheetWidget extends StatefulWidget>
//     extends State<ViewDraggableSheetWidget> with TickerProviderStateMixin
// State<_SheetWidget> createState() => _SheetWidgetState();
// class _SheetWidgetState extends ViewDraggableSheetState<_SheetWidget>

class ViewDraggableSheetState<T extends StatefulWidget> extends State<T>
    with SingleTickerProviderStateMixin {
  late final draggableController = DraggableScrollableController();
  late ScrollController scrollController;

  late final ViewScrollNotify scrollNotify = Provider.of<ViewScrollNotify>(context, listen: false);

  late final AnimationController switchController = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: this,
  );
  late final Animation<double> switchAnimation = Tween(
    begin: 0.0,
    end: 1.0,
  ).animate(switchController);

  ThemeData get theme => Theme.of(context);

  // NOTE: device height and width
  // late double _dHeight;
  // late double _bPadding;
  double get _dHeight => MediaQuery.of(context).size.height;
  double get _bPadding => MediaQuery.of(context).padding.bottom;

  @override
  void dispose() {
    // scrollNotify.dispose();
    // scrollController.dispose();
    // switchController.dispose();
    super.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   _dHeight = MediaQuery.of(context).size.height;
  //   _bPadding = MediaQuery.of(context).padding.bottom;
  //   super.didChangeDependencies();
  // }

  BorderRadius get borderRadius => const BorderRadius.vertical(
        top: Radius.circular(10),
        // top: Radius.elliptical(15, 15),
      );

  // late final kHeight = scrollNotify.kHeight;
  double get kHeight => scrollNotify.kHeight;
  Color get backgroundColor => theme.primaryColor;

  // NOTE: update when scroll notify
  double _initialSize = 0.0;

  // NOTE: Overridable for modal sheet
  bool get persistent => true;
  double get initialSize => _initialSize;
  double get minSize {
    final size = (kHeight + _bPadding) / _dHeight;
    // _dHeight and _bPadding returned 0.0 value when save changed
    if (size == double.infinity) {
      return 0.0;
    }
    return size;
  }

  double get midSize => 0.5;

  /// default size is fullscreen - statusbar
  // double get maxSize => (_dHeight - scrollNotify.kHeightStatusBar) / _dHeight;
  double get maxSize {
    final size = (_dHeight - scrollNotify.kHeightStatusBar) / _dHeight;

    if (size <= 1.0) {
      return size;
    }
    // _dHeight and _bPadding returned 0.0 value when save changed
    return midSize;
  }

  bool get isSizeDefault => initialSize <= minSize;
  bool get isSizeShrink => initialSize < midSize;

  // late final _actualInitialSize = minSize * scrollNotify.factor;
  late final _actualInitialSize = persistent ? (minSize * scrollNotify.factor) : initialSize;
  late final _actualMinSize = minSize;
  late final _actualMaxSize = maxSize;

  bool _draggableNotification(DraggableScrollableNotification notification) {
    if (!persistent) return false;
    _draggableEngine(notification.extent);
    _initialSize = notification.extent;
    _switchControllerWatch();
    return true;
  }

  bool _scrollNotification(dynamic scroll) {
    if (!persistent) return false;
    if (scroll is ScrollStartNotification) {
      if (scrollNotify.lock) {
        scrollNotify.lock = false;
      }
    }
    if (scroll is ScrollUpdateNotification) {}
    if (scroll is UserScrollNotification) {
      if (scrollNotify.lock) {
        scrollNotify.lock = false;
      }
    }
    if (scroll is ScrollEndNotification) {
      if (scrollNotify.factor == 0.0) {
        scrollNotify.lock = true;
      }
      _setSnap();
    }
    return true;
  }

  void _draggableEngine(double size) {
    double _offset = (size - minSize) * 7.0;
    double _delta = _offset.clamp(0.0, 1.0);

    double factor = (1.0 - _delta).toDouble();
    double _old = scrollNotify.factor;

    if (size > initialSize) {
      // NOTE: scroll up
      factor = min(factor, _old);
    } else {
      // NOTE: scroll down
      factor = max(factor, _old);
    }
    scrollNotify.factor = factor;
  }

  Future<void> scrollAnimateTo({double size = 0.0, int time = 100, bool? lock}) {
    return draggableController.animateTo(
      size,
      duration: Duration(milliseconds: time),
      curve: Curves.ease,
    )..whenComplete(() {
        if (lock != null) {
          scrollNotify.lock = lock;
        }
        scrollController.jumpTo(0.0);
      });
  }

  /// Toggle scroll animation, if size is not provided "midSize" used
  Future<void> scrollAnimateToggle({double? size}) {
    size ??= midSize;
    final hasShrink = initialSize < size;
    final adjustedSize = hasShrink ? size : minSize;
    return scrollAnimateTo(size: adjustedSize, lock: hasShrink);
  }

  /// if factor is between 0.0 - 1.0, it will snap back
  void _setSnap() {
    double _factor = scrollNotify.factor;
    bool hasFactor = 0.0 < _factor && _factor < 1.0;
    if (hasFactor) {
      if (hasFactor) {
        Future.microtask(() {
          scrollAnimateTo(size: _actualInitialSize);
        });
        // scrollAnimateTo(size: _actualInitialSize).whenComplete(() {
        //   scrollController.jumpTo(0);
        // });
      }
    }
  }

  void _switchControllerWatch() {
    if (isSizeDefault) {
      switchController.reverse();
    } else if (switchController.isDismissed) {
      switchController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableActuator(
      child: NotificationListener<DraggableScrollableNotification>(
        onNotification: _draggableNotification,
        child: DraggableScrollableSheet(
          key: const ValueKey<String>('draggableController'),
          expand: false,
          controller: draggableController,
          initialChildSize: _actualInitialSize,
          minChildSize: _actualMinSize,
          maxChildSize: _actualMaxSize,
          builder: (BuildContext context, ScrollController controller) {
            scrollController = controller;
            // maxChildSize <= 1.0
            // minChildSize <= initialChildSize
            return sheetDecoration(
              child: ViewPage(
                controller: controller,
                // depth: 1,
                onNotification: _scrollNotification,
                child: body(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget body() {
    return CustomScrollView(
      key: const ValueKey<String>('csvbs'),
      controller: scrollController,
      scrollBehavior: const ViewScrollBehavior(),
      slivers: sliverWidgets(),
    );
  }

  List<Widget> sliverWidgets() {
    return <Widget>[
      ViewHeaderSliverSnap(
        pinned: true,
        floating: false,
        heights: [kHeight],
        // overlapsForce: true,
        // backgroundColor: theme.primaryColor,
        backgroundColor: persistent ? Colors.red : theme.primaryColor,
        overlapsBorderColor: theme.shadowColor,
        builder: (BuildContext _, ViewHeaderData org) {
          return Row(
            key: const ValueKey<String>('btn-action'),
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // AnimatedBuilder(
              //   animation: switchAnimation,
              //   builder: (context, child) {
              //     return Text('${switchAnimation.value}');
              //   },
              // ),
              TextButton(
                child: const Text('Min'),
                onPressed: () {
                  scrollAnimateTo(size: 0.5, lock: true);
                },
              ),
              TextButton(
                child: const Text('Max'),
                onPressed: () {
                  scrollAnimateTo(size: _actualMaxSize, lock: true);
                },
              ),
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  scrollAnimateTo(size: _actualInitialSize, lock: false);
                },
              ),
            ],
          );
        },
      ),
      SliverToBoxAdapter(
        child: Center(
          child: Text('hello'),
        ),
      ),
    ];
  }

  Widget sheetDecoration({Widget? child}) {
    // Material
    return Container(
      decoration: BoxDecoration(
        // color: persistent ? theme.scaffoldBackgroundColor.withOpacity(0.5) : theme.primaryColor,
        // color: theme.primaryColor,
        color: backgroundColor,
        // color: Colors.red,
        // color: Colors.transparent,
        borderRadius: borderRadius,

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
            color: theme.shadowColor,

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
}
