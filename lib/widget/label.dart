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
  }

  Widget get avatar {
    return Icon(
      icon,
      size: iconSize,
      color: iconColor,
    );
  }
}
