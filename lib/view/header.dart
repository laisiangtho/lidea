part of 'main.dart';

class ViewHeaderData {
  final double minHeight;
  final double maxHeight;

  final double offset;
  final bool overlaps;
  // final double shrink;
  // final double stretch;

  const ViewHeaderData({
    required this.minHeight,
    required this.maxHeight,
    required this.offset,
    required this.overlaps,
    // required this.shrink,
    // required this.stretch,
  });

  // double get stretch => (offset / maxHeight).clamp(0.0, 1.0).toDouble();
  // double get shrink => 1.0 - stretch;
  double get stretch => stretchOffsetDouble(maxHeight);
  double get shrink => shrinkOffsetDouble(maxHeight);

  double get snapExtent => maxHeight - minHeight;

  double get snapHeight => snapExtent - offset.clamp(0.0, snapExtent).toDouble();

  // double get snapStretch => (offset / snapExtent).clamp(0.0, 1.0).toDouble();
  // double get snapShrink => 1.0 - snapStretch;
  double get snapStretch => stretchOffsetDouble(snapExtent);
  double get snapShrink => shrinkOffsetDouble(snapExtent);

  /// 0.0 to 1.0
  double stretchOffsetDouble(double size) {
    return (offset / size).clamp(0.0, 1.0).toDouble();
  }

  /// 1.0 to 0.0
  double shrinkOffsetDouble(double size) {
    return 1.0 - stretchOffsetDouble(size);
  }
}

class ViewHeaderDelegate extends SliverPersistentHeaderDelegate {
  const ViewHeaderDelegate(
    this.builder, {
    this.minHeight: kToolbarHeight,
    this.maxHeight: kToolbarHeight,
    this.reservedTop: false,
  });
  final Function(BuildContext, double, bool) builder;
  final double minHeight;
  final double maxHeight;
  final bool reservedTop;

  @override
  bool shouldRebuild(ViewHeaderDelegate oldDelegate) => true;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => minHeight < maxHeight ? maxHeight : minHeight;

  // @override
  // FloatingHeaderSnapConfiguration? get snapConfiguration => null;

  // @override
  // OverScrollHeaderStretchConfiguration get stretchConfiguration => OverScrollHeaderStretchConfiguration();

  @override
  Widget build(BuildContext context, double offset, bool overlapsContent) {
    // double padding = MediaQuery.of(context).padding.top;

    return SizedBox.expand(
      child: builder(context, offset, overlapsContent),
    );
  }
}

class ViewHeaderSliverSnap extends StatelessWidget {
  const ViewHeaderSliverSnap({
    Key? key,
    this.pinned: true,
    this.floating: true,
    this.heroTag: 'appbar-primary',
    required this.builder,
    required this.heights,
    this.padding: EdgeInsets.zero,
    this.backgroundColor,
    this.overlapsBackgroundColor,
    this.overlapsBorderColor: Colors.transparent,
    this.overlapsForce = false,
    this.borderWidth: 0.5,
    this.borderRadius: Radius.zero,
  }) : super(key: key);

  final bool pinned;
  final bool floating;
  final String heroTag;

  final EdgeInsetsGeometry padding;

  final Function(BuildContext, ViewHeaderData) builder;
  final List<double> heights;

  final Color? backgroundColor;
  final Color? overlapsBackgroundColor;
  final Color overlapsBorderColor;
  final bool overlapsForce;

  final double borderWidth;
  final Radius borderRadius;

  // [65] [65, 100]
  double get max => heights.reduce((a, b) => a + b);
  double get min => heights.first;

  // MediaQuery.of(context).padding.top
  double get maxHeight => max + padding.vertical;
  double get minHeight => min + padding.vertical;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: pinned,
      floating: floating,
      delegate: ViewHeaderDelegate(
        (BuildContext context, double offset, bool overlaps) {
          Widget ui = _bar(context, offset, overlaps);
          if (heroTag.isNotEmpty) {
            return ui;
          }
          return Hero(
            tag: heroTag,
            child: ui,
          );
        },
        maxHeight: maxHeight,
        minHeight: minHeight,
      ),
    );
  }

  Widget _bar(BuildContext context, double offset, bool overlaps) {
    final double snapExtent = maxHeight - minHeight;

    // final bool snapOverlaps = (snapExtent > 0.0)
    //     ? overlaps || snapOffset == 0.0
    //     : (overlapsForce == false)
    //         ? offset > 0.0
    //         : overlapsForce;
    // offset >= snapExtent
    final bool snapOverlaps = (snapExtent > 0.0)
        ? overlaps || offset >= snapExtent
        : (overlapsForce == false)
            ? offset > 0.0
            : overlapsForce;

    return ViewHeaderDecoration(
      overlaps: snapOverlaps,
      padding: padding,
      backgroundColor: backgroundColor,
      overlapsBackgroundColor: overlapsBackgroundColor,
      overlapsBorderColor: overlapsBorderColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      child: builder(
        context,
        ViewHeaderData(
          maxHeight: maxHeight,
          minHeight: minHeight,
          offset: offset,
          overlaps: snapOverlaps,
          // shrink: shrink,
          // stretch: stretch,
        ),
      ),
    );
  }
}

class ViewHeaderDecoration extends StatelessWidget {
  const ViewHeaderDecoration({
    Key? key,
    required this.child,
    this.overlaps: false,
    this.backgroundColor,
    this.overlapsBackgroundColor,
    this.overlapsBorderColor: Colors.transparent,
    this.borderWidth: 0.5,
    // this.borderRadius:0.0,
    this.borderRadius: Radius.zero,
    this.padding: EdgeInsets.zero,
  }) : super(key: key);

  final Widget child;
  final bool overlaps;
  // final bool overlapsColor;

  final Color? backgroundColor;
  final Color? overlapsBackgroundColor;
  final Color overlapsBorderColor;
  final double borderWidth;
  final Radius borderRadius;
  // final Radius borderRadiusTmp;
  final EdgeInsetsGeometry padding;

  bool get hasRadius => borderRadius.x > 0.0 || borderRadius.y > 0.0;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: key,
      decoration: BoxDecoration(
        // color: (overlaps && backgroundColor != null)?Theme.of(context).primaryColor:Theme.of(context).scaffoldBackgroundColor,
        color: (overlaps && overlapsBackgroundColor != null)
            ? overlapsBackgroundColor
            : backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        borderRadius: hasRadius
            ? new BorderRadius.vertical(bottom: borderRadius
                // bottom: Radius.elliptical(3, 2)
                )
            : null,
        border: (hasRadius == false && overlaps)
            ? Border(
                // bottom: BorderSide(width: borderWidth, color: Theme.of(context).shadowColor),
                bottom: BorderSide(width: borderWidth, color: overlapsBorderColor),
              )
            : null,
        boxShadow: [
          if (overlaps)
            BoxShadow(
              color: overlapsBorderColor,
              // color: Theme.of(context).backgroundColor.withOpacity(overlaps?0.3:0.0),
              blurRadius: 0,
              spreadRadius: 0,
              offset: Offset(0, 0),
            )
        ],
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

// ViewHeaderSliverSnap
// ViewHeaderSliverDash
