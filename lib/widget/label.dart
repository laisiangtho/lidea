part of lidea.widget;

class WidgetLabel extends StatelessWidget {
  final String? label;

  final IconData? icon;
  // final bool iconLeft;
  final double? iconSize;
  final Color? iconColor;
  final bool softWrap;
  final bool enable;
  final bool show;
  final TextOverflow overflow;
  final EdgeInsetsGeometry labelPadding;

  /// BoxDecoration()
  final BoxDecoration? decoration;
  final BoxConstraints constraints;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry? alignment;
  final MaterialTapTargetSize? materialTapTargetSize;

  const WidgetLabel({
    Key? key,
    this.icon,
    this.label,
    this.overflow = TextOverflow.fade,
    // this.iconLeft = true,
    this.iconSize, //26.0
    this.iconColor,
    this.softWrap = false,
    this.enable = true,
    this.show = true,
    this.labelPadding = EdgeInsets.zero,
    this.decoration,
    this.constraints = const BoxConstraints(),
    this.maxLines = 1,
    this.textAlign,
    this.labelStyle,
    this.padding = EdgeInsets.zero,
    this.alignment,
    this.materialTapTargetSize = MaterialTapTargetSize.shrinkWrap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (show == false) return const SizedBox();

    return Container(
      alignment: alignment,
      decoration: decoration,
      constraints: constraints,
      child: Chip(
        padding: padding,
        avatar: (icon != null)
            ? (label == null)
                ? null
                : avatar
            : null,
        labelPadding: labelPadding,

        label: (label != null)
            ? Text(
                label ?? '',
                maxLines: maxLines,
                overflow: overflow,
                softWrap: softWrap,
                textAlign: textAlign,
              )
            : avatar,

        labelStyle: Theme.of(context).textTheme.labelMedium!.merge(labelStyle),

        // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        // materialTapTargetSize: MaterialTapTargetSize.padded,
        materialTapTargetSize: materialTapTargetSize,
        visualDensity: VisualDensity.compact,
        // elevation: 10,
        // shadowColor: Colors.red,
        // backgroundColor: Colors.blue,
        // side: BorderSide.none,
        // shape: CircleBorder(side: BorderSide.none),
        // clipBehavior: Clip.none,
      ),
    );

    // return Container(
    //   alignment: alignment,
    //   decoration: decoration,
    //   constraints: constraints,
    //   child: Padding(
    //     padding: padding,
    //     child: SizedBox(
    //       child: Row(
    //         mainAxisSize: MainAxisSize.min,
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           if (icon != null) avatar,
    //           if (label != null)
    //             Padding(
    //               padding: labelPadding,
    //               child: Text(
    //                 label ?? '',
    //                 maxLines: maxLines,
    //                 overflow: overflow,
    //                 softWrap: softWrap,
    //                 textAlign: textAlign,
    //               ),
    //             ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget get avatar {
    return Icon(
      icon,
      size: iconSize,
      color: iconColor,
    );
  }
}
/*
class WidgetMarkWorking extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final BoxConstraints? constraints;
  final BoxDecoration? decoration;
  final WrapAlignment alignment;
  final double spacing;

  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  final String? label;
  final IconData? icon;
  final bool iconLeft;
  final double? iconSize;
  final Color? iconColor;
  final bool softWrap;
  final bool enable;
  final TextOverflow overflow;
  final EdgeInsetsGeometry labelPadding;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextStyle? labelStyle;
  final MaterialTapTargetSize? materialTapTargetSize;

  const WidgetMarkWorking({
    Key? key,
    this.constraints,
    this.decoration,
    // this.padding = const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
    this.padding = EdgeInsets.zero,
    this.alignment = WrapAlignment.start,
    this.spacing: 0.0,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.icon,
    this.iconLeft = true,
    this.iconSize,
    this.iconColor,
    this.label,
    this.overflow = TextOverflow.fade,
    this.labelPadding = EdgeInsets.zero,
    this.softWrap = false,
    this.maxLines = 1,
    this.textAlign,
    this.labelStyle,
    this.enable = true,
    this.materialTapTargetSize = MaterialTapTargetSize.shrinkWrap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: constraints ?? const BoxConstraints(minHeight: 29),
      child: DecoratedBox(
        decoration: decoration ?? const BoxDecoration(),
        child: Padding(
          padding: padding,
          child: Row(
            // alignment: alignment,
            // spacing: spacing,
            // crossAxisAlignment: WrapCrossAlignment.center,
            // runSpacing: 0.0,
            // runAlignment: WrapAlignment.center,
            // verticalDirection: VerticalDirection.up,
            // direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: crossAxisAlignment,
            mainAxisAlignment: mainAxisAlignment,
            children: [
              if (iconLeft == true && icon != null) _iconWidget,
              if (label != null)
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: labelPadding,
                    child: Text(
                      label!,
                      maxLines: maxLines,
                      overflow: overflow,
                      softWrap: softWrap,
                      textAlign: textAlign,
                      style: labelStyle ?? Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ),
              if (iconLeft == false && icon != null) _iconWidget,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _iconWidget {
    return Icon(
      icon,
      size: iconSize,
      color: iconColor,
    );
  }
}
*/

