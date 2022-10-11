library view.popup;

import 'package:flutter/material.dart';

part 'shaped.dart';

/*
showDialog(
  context: context,
  builder: (_) => ViewPopupShapedArrow(),
);
Navigator.of(context).push(PageRouteBuilder(
  opaque: false,
  barrierDismissible: true,
  pageBuilder: (BuildContext context, _, __) => ViewPopupShapedArrow()
));
*/
/// Used in Lai Siangtho Book list, Chapter list, and Options
///
class ViewPopupShapedArrow extends StatelessWidget {
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
  final AlignmentGeometry alignment;

  const ViewPopupShapedArrow({
    Key? key,
    required this.child,
    this.top,
    this.right,
    this.left,
    this.bottom,
    this.elevation = 0.5,
    this.backgroundColor,
    this.alignment = AlignmentDirectional.center,
    this.radius = const Radius.circular(7),
    this.height,
    this.width,
    this.arrow = 65,
    this.arrowWidth = 10,
    this.arrowHeight = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double maxHeight = MediaQuery.of(context).size.height * 0.75;
    // double? fixedHeight = height != null && height! > maxHeight ? maxHeight : height;

    return Stack(
      alignment: alignment,
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
            clipBehavior: Clip.hardEdge,
            elevation: elevation,
            color: backgroundColor,
            // child: SizedBox(
            //   width: width,
            //   height: fixedHeight,
            //   child: child,
            // ),
            child: child,
          ),
        ),
      ],
    );
  }
}
