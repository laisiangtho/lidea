// ignore_for_file: use_super_parameters

part of 'main.dart';

class ViewHeaderDecoration extends StatelessWidget {
  const ViewHeaderDecoration({
    Key? key,
    required this.child,
    this.overlaps = false,
    this.backgroundColor,
    this.overlapsBackgroundColor,
    this.overlapsBorderColor = Colors.transparent,
    this.borderWidth = 0.7,
    this.borderRadius = Radius.zero,
    this.padding = EdgeInsets.zero,
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
              offset: const Offset(0, 0),
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
