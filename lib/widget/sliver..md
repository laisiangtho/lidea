# ?

```dart
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverSingle extends SingleChildRenderObjectWidget {
  const SliverSingle({Key? key, Widget? child}) : super(key: key, child: child);
  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSliverSingle();
  }
}

class RenderSliverSingle extends RenderSliverSingleBoxAdapter {
  RenderSliverSingle({RenderBox? child}) : super(child: child);

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    final SliverConstraints constraints = this.constraints;
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    final double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
        break;
      case Axis.vertical:
        childExtent = child!.size.height;
        break;
    }
    // assert(childExtent != null);
    final double paintedChildSize = calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent = calculateCacheOffset(constraints, from: 0.0, to: childExtent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);
    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow:
          childExtent > constraints.remainingPaintExtent || constraints.scrollOffset > 0.0,
    );
    setChildParentData(child!, constraints, geometry!);
  }
}

// MultiChildRenderObjectWidget
// SingleChildRenderObjectWidget
class SliverMulti extends MultiChildRenderObjectWidget {
  // SliverMulti({Key? key, required List<Widget> children}) : super(key: key, children: children);
  // SliverMulti({Key? key, required List<Widget> children}) : super(key: key, children: children);
  SliverMulti({Key? key, List<Widget>? children}) : super(key: key, children: children!);
  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSliverMulti();
  }
}

class RenderSliverMulti extends RenderSliverMultiBoxAdaptor {
  // RenderSliverMulti({RenderSliverBoxChildManager? children}) : super(childManager: children!);
  RenderSliverMulti({required RenderSliverBoxChildManager children})
      : super(childManager: children);

  @override
  void performLayout() {
    if (firstChild == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    final SliverConstraints constraints = this.constraints;
    firstChild!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    // final double childExtent;
    // switch (constraints.axis) {
    //   case Axis.horizontal:
    //     childExtent = firstChild!.size.width;
    //     break;
    //   case Axis.vertical:
    //     childExtent = firstChild!.size.height;
    //     break;
    // }
    // assert(childExtent != null);
    // final double paintedChildSize = calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    // final double cacheExtent = calculateCacheOffset(constraints, from: 0.0, to: childExtent);

    // final correction = _layoutChildSequence(
    //   child: firstChild,
    //   scrollOffset: constraints.scrollOffset,
    //   overlap: constraints.overlap,
    //   remainingPaintExtent: constraints.remainingPaintExtent,
    //   mainAxisExtent: constraints.viewportMainAxisExtent,
    //   crossAxisExtent: constraints.crossAxisExtent,
    //   growthDirection: GrowthDirection.forward,
    //   advance: childAfter,
    //   remainingCacheExtent: constraints.remainingCacheExtent,
    //   cacheOrigin: constraints.cacheOrigin,
    // );

    // geometry = SliverGeometry(
    //   scrollExtent: childExtent,
    //   paintExtent: paintedChildSize,
    //   cacheExtent: cacheExtent,
    //   maxPaintExtent: childExtent,
    //   hitTestExtent: paintedChildSize,
    //   hasVisualOverflow:
    //       childExtent > constraints.remainingPaintExtent || constraints.scrollOffset > 0.0,
    // );
    // if (correction != null) {
    //   geometry = SliverGeometry(scrollOffsetCorrection: correction);
    //   return;
    // }
    geometry = const SliverGeometry();
  }
}

class SliverTesting extends RenderSliverMultiBoxAdaptor {
  SliverTesting({required RenderSliverBoxChildManager childManager})
      : super(childManager: childManager);

  @override
  void performLayout() {
    // TODO: implement performLayout
  }
}

class RenderMultiSliver extends RenderSliver {
  RenderMultiSliver({
    required bool containing,
  });

  @override
  void performLayout() {
    // TODO: implement performLayout
    if (firstChild == null) {
      geometry = SliverGeometry.zero;
      return;
    }
  }
}
