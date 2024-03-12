// ignore_for_file: use_super_parameters

part of 'main.dart';

class ViewLabel extends StatelessWidget {
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
  final EdgeInsetsGeometry margin;

  /// BoxDecoration()
  final BoxDecoration? decoration;
  final BoxConstraints? constraints;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry? alignment;
  final MaterialTapTargetSize? materialTapTargetSize;

  const ViewLabel({
    Key? key,
    this.icon,
    this.label,
    this.overflow = TextOverflow.fade,
    // this.overflow = TextOverflow.clip,
    // this.iconLeft = true,
    this.iconSize, //26.0
    this.iconColor,
    this.softWrap = true,
    this.enable = true,
    this.show = true,
    this.labelPadding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.decoration,
    // this.constraints = const BoxConstraints(),
    this.constraints,
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
      margin: margin,
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
        elevation: 0,
        side: BorderSide.none,

        label: (label != null)
            ? Text(
                label ?? '',
                maxLines: maxLines,
                overflow: overflow,
                softWrap: softWrap,
                textAlign: textAlign,
                // strutStyle: StrutStyle(forceStrutHeight: true),
                // textHeightBehavior: TextHeightBehavior(
                //   applyHeightToFirstAscent: false,
                //   applyHeightToLastDescent: false,
                // ),
              )
            : avatar,

        labelStyle: Theme.of(context).textTheme.labelMedium!.merge(labelStyle),

        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        // materialTapTargetSize: MaterialTapTargetSize.padded,
        // materialTapTargetSize: materialTapTargetSize,
        // visualDensity: VisualDensity.compact,
        // visualDensity: VisualDensity.adaptivePlatformDensity,
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
