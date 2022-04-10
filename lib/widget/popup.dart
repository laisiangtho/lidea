part of lidea.widget;

/*
showDialog(
  context: context,
  builder: (_) => WidgetPopupShapedArrow(),
);
Navigator.of(context).push(PageRouteBuilder(
  opaque: false,
  barrierDismissible: true,
  pageBuilder: (BuildContext context, _, __) => WidgetPopupShapedArrow()
));
*/
/// Used in Lai Siangtho Book list, Chapter list, and Options
class WidgetPopupShapedArrow extends StatelessWidget {
  final Widget child;

  final double? top;
  final double? right;
  final double? left;
  final double? bottom;
  final double elevation;

  final double arrow;
  final double arrowWidth;
  final double arrowHeight;
  final Radius radius;

  final double? width;
  final double? height;
  final Color? backgroundColor;

  const WidgetPopupShapedArrow({
    Key? key,
    required this.child,
    this.top,
    this.right,
    this.left,
    this.bottom,
    this.elevation = 0.5,
    this.backgroundColor,
    this.radius = const Radius.circular(7),
    this.height,
    this.width,
    this.arrow = 65,
    this.arrowWidth = 10,
    this.arrowHeight = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height * 0.75;
    double? fixedHeight = height != null && height! > maxHeight ? maxHeight : height;

    return Stack(
      children: <Widget>[
        Positioned(
          top: top,
          right: right,
          bottom: bottom,
          left: left,
          child: Material(
            shape: ShapedArrowWithRoundedRectangleBorder(
              arrow: arrow,
              radius: radius,
              width: arrowWidth,
              height: arrowHeight,
            ),
            clipBehavior: Clip.antiAlias,
            elevation: elevation,
            color: backgroundColor,
            child: SizedBox(
              width: width,
              height: fixedHeight,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

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
