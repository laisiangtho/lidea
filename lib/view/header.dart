part of lidea.view;

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
  double get maxExpanded => heights.reduce((a, b) => a + b);
  double get minExpanded => heights.first;

  // MediaQuery.of(context).padding.top
  double get maxHeight => maxExpanded + padding.vertical;
  double get minHeight => minExpanded + padding.vertical;

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
    // final bool snapOverlaps = (snapExtent > 0.0)
    //     ? overlaps || offset >= snapExtent
    //     : (overlapsForce == false)
    //         ? offset > 0.0
    //         : overlapsForce;
    final bool snapOverlaps = overlapsForce
        ? overlapsForce
        : (snapExtent > 0.0)
            ? overlaps || offset >= snapExtent
            : offset > 0.0;

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
    this.borderWidth: 0.7,
    this.borderRadius: Radius.zero,
    this.padding: EdgeInsets.zero,
  }) : super(key: key);

  final Widget child;
  final bool overlaps;

  final Color? backgroundColor;
  final Color? overlapsBackgroundColor;
  final Color overlapsBorderColor;
  final double borderWidth;
  final Radius borderRadius;
  final EdgeInsetsGeometry padding;

  bool get hasRadius => borderRadius.x > 0.0 || borderRadius.y > 0.0;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        // color: (overlaps && backgroundColor != null)?Theme.of(context).primaryColor:Theme.of(context).scaffoldBackgroundColor,
        color: (overlaps && overlapsBackgroundColor != null)
            ? overlapsBackgroundColor
            : backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        // : backgroundColor ?? Colors.transparent,
        borderRadius: hasRadius
            ? BorderRadius.vertical(
                bottom: borderRadius,
              )
            : null,
        border: (hasRadius == false && overlaps)
            ? Border(
                bottom: BorderSide(width: borderWidth, color: overlapsBorderColor),
              )
            : null,
        boxShadow: [
          if (overlaps)
            BoxShadow(
              color: overlapsBorderColor,
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
