part of view.popup;

class ShapedArrowWithRoundedRectangleBorder extends RoundedRectangleBorder {
  final double arrow;
  final Radius radius;
  final double width;
  final double height;

  const ShapedArrowWithRoundedRectangleBorder({
    required this.arrow,
    this.radius = Radius.zero,
    this.width = 10,
    this.height = 12,
    BorderSide side = BorderSide.none,
    BorderRadiusGeometry borderRadius = BorderRadius.zero,
  }) : super(
          side: side,
          borderRadius: borderRadius,
        );

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, radius))
      ..moveTo(arrow, rect.top)
      ..relativeLineTo(width, -height)
      ..relativeLineTo(width, height)
      ..close();

    // NOTE: arrow bottom
    // return Path()
    //   ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(7)))
    //   ..moveTo(arrow, rect.bottom)
    //   ..relativeLineTo(10, 12)
    //   ..relativeLineTo(10, -12)
    //   ..close();

    // NOTE: arrow top
    // return Path()
    //   ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(7)))
    //   ..moveTo(arrow, rect.top)
    //   ..relativeLineTo(10, -12)
    //   ..relativeLineTo(10, 12)
    //   ..close();
  }
}
