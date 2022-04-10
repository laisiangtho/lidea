part of lidea.view;

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
