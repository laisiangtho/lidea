library view.header;

import 'package:flutter/material.dart';

part 'data.dart';
part 'decoration.dart';
part 'layout.dart';
part 'title.dart';

/// SliverPersistentHeaderDelegate
class ViewHeaderDelegate extends SliverPersistentHeaderDelegate {
  const ViewHeaderDelegate({
    this.minHeight = kToolbarHeight,
    this.maxHeight = kToolbarHeight,
    // this.reservedTop = false,
    this.verticalPadding = 0.0,
    this.overlapsForce = false,
    required this.builder,
  });
  final Widget Function(BuildContext, double, bool) builder;
  final double minHeight;
  final double maxHeight;
  final double verticalPadding;
  // final bool reservedTop;
  final bool overlapsForce;

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

  double get _snapExtent => maxHeight - minHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: builder(
        context,
        shrinkOffset,
        overlapsForce
            ? overlapsForce
            : (_snapExtent > 0.0)
                ? overlapsContent || shrinkOffset >= _snapExtent
                : shrinkOffset > 0.0,
      ),
    );
  }
}

class ViewHeaderSliver extends StatelessWidget {
  const ViewHeaderSliver({
    Key? key,
    this.pinned = true,
    this.floating = true,
    this.heroTag = 'appbar-primary',
    required this.builder,
    required this.heights,
    this.padding = EdgeInsets.zero,
    this.backgroundColor,
    this.overlapsBackgroundColor,
    this.overlapsBorderColor = Colors.transparent,
    this.overlapsForce = false,
    this.borderWidth = 0.5,
    this.borderRadius = Radius.zero,
  }) : super(key: key);

  final bool pinned;
  final bool floating;
  final String heroTag;

  final EdgeInsetsGeometry padding;

  final Widget Function(BuildContext, ViewHeaderData) builder;
  final List<double> heights;

  final Color? backgroundColor;
  final Color? overlapsBackgroundColor;
  final Color overlapsBorderColor;
  final bool overlapsForce;

  final double borderWidth;
  final Radius borderRadius;

  // [65] [65, 100]
  double get maxHeight => heights.reduce((a, b) => a + b);
  double get minHeight => heights.first;

  // MediaQuery.of(context).padding.top
  double get _maxExtent => maxHeight + padding.vertical;
  double get _minExtent => minHeight + padding.vertical;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: pinned,
      floating: floating,
      delegate: ViewHeaderDelegate(
        builder: _bar,
        maxHeight: _maxExtent,
        minHeight: _minExtent,
        overlapsForce: overlapsForce,
      ),
    );
  }

  Widget _bar(BuildContext context, double offset, bool overlaps) {
    return ViewHeaderDecoration(
      overlaps: overlaps,
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
          verticalPadding: padding.vertical,
          offset: offset,
          overlaps: overlaps,
          // shrink: shrink,
          // stretch: stretch,
        ),
      ),
    );
  }
}
