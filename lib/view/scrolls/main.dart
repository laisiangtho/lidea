library view.scrolls;
// import 'dart:ui';

// import 'package:flutter/gestures.dart';

import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

// NOTE: Notify
// import '/unit/notify.dart' show Notify;

part 'bottom.dart';
part 'behavior.dart';
part 'extension.dart';
part 'controller.dart';

/// Primary page that control Snap and scrollNotification
/// Useful to control glitch PrimaryViewPage ViewScrollSnap

class ViewScroll<T> extends StatefulWidget {
  /// to disable scrollNotification from page remove one of [notify]
  final ScrollBehavior? behavior;

  /// to disable scrollNotification from page remove one of [notify, controller]
  final ScrollBottomNavigation? scrollBottom;

  /// depth is useful on NestedScrollView
  final int depth;
  final bool Function(ScrollNotification)? onNotification;

  final Future<T>? snap;
  final Widget? snapAwait;
  final Widget? snapError;

  /// MaterialApp.createMaterialHeroController()
  final HeroController? heroController;

  final Widget child;
  const ViewScroll({
    super.key,
    this.behavior,
    this.scrollBottom,
    // this.notifier,
    this.depth = 0,
    this.onNotification,
    this.snap,
    this.snapAwait,
    this.snapError,
    this.heroController,
    required this.child,
  });

  @override
  State<ViewScroll> createState() => _ScrollsState();
}

class _ScrollsState<T> extends State<ViewScroll<T>> {
  @override
  void initState() {
    super.initState();
    // if (widget.scrollBottom != null) {
    //   widget.scrollBottom?.listener();
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.snap != null) {
      return FutureBuilder<T>(
        future: widget.snap,
        builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return widget.snapAwait ??
                  const Center(
                    child: Text('...'),
                  );
            default:
              if (snapshot.hasError) {
                return widget.snapError ??
                    const Center(
                      child: Text('...'),
                    );
              } else {
                return _childHero();
              }
          }
        },
      );
    }
    return _childHero();
  }

  Widget _childHero() {
    return HeroControllerScope(
      controller: widget.heroController ?? MaterialApp.createMaterialHeroController(),
      child: _childScroll(),
    );
  }

  Widget _childScroll() {
    return ScrollConfiguration(
      behavior: widget.behavior ?? const ScrollsBehavior(),
      // behavior: ScrollConfiguration.of(context).copyWith(
      //   dragDevices: {
      //     PointerDeviceKind.touch,
      //     PointerDeviceKind.mouse,
      //   },
      // ),
      // behavior: const MaterialScrollBehavior().copyWith(
      //   dragDevices: {
      //     PointerDeviceKind.mouse,
      //     PointerDeviceKind.touch,
      //     PointerDeviceKind.stylus,
      //     PointerDeviceKind.trackpad,
      //     PointerDeviceKind.unknown
      //   },
      // ),
      child: widget.child,
    );
  }
}
