part of view.header;

class ViewHeaderData {
  final double minHeight;
  final double maxHeight;

  final double verticalPadding;

  final double offset;
  final bool overlaps;
  // final double shrink;
  // final double stretch;

  const ViewHeaderData({
    required this.maxHeight,
    required this.minHeight,
    this.verticalPadding = 0.0,
    required this.offset,
    required this.overlaps,
    // required this.shrink,
    // required this.stretch,
  });

  // maxExpanded
  // minHeight
  // maxExtent

  // double get maxHeight => maxExpanded + verticalPadding;
  // double get minHeight => minExpanded + verticalPadding;

  double get maxExtent => maxHeight + verticalPadding;
  double get minExtent => minHeight + verticalPadding;

  // double get stretch => (offset / maxExtent).clamp(0.0, 1.0).toDouble();
  // double get shrink => 1.0 - stretch;
  double get stretch => stretchOffsetDouble(maxExtent);
  double get shrink => shrinkOffsetDouble(maxExtent);

  double get snapExtent => maxExtent - minExtent;

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

  /// `size * snapShrink`
  double shrinkWith(double size) {
    return size * snapShrink;
  }

  ///`size * snapStretch`
  double stretchWith(double size) {
    return size * snapStretch;
  }
}
