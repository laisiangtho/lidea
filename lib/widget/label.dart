part of 'main.dart';

class WidgetLabel extends StatelessWidget {
  const WidgetLabel({
    Key? key,
    this.icon,
    this.label,
    this.overflow = TextOverflow.fade,
    // this.iconLeft = true,
    this.iconSize, //26.0
    this.iconColor,
    this.message = '',
    this.softWrap = false,
    this.enable = true,
    this.labelPadding = EdgeInsets.zero,
    this.maxLines = 1,
    this.textAlign,
    this.labelStyle,
    this.padding = EdgeInsets.zero,
    this.alignment,
    this.materialTapTargetSize = MaterialTapTargetSize.shrinkWrap,
  }) : super(key: key);

  final String? label;
  final String message;
  final IconData? icon;
  // final bool iconLeft;
  final double? iconSize;
  final Color? iconColor;
  final bool softWrap;
  final bool enable;
  final TextOverflow overflow;
  final EdgeInsetsGeometry? labelPadding;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final MaterialTapTargetSize? materialTapTargetSize;

  @override
  Widget build(BuildContext context) {
    if (message.isNotEmpty) {
      return Tooltip(
        message: message,
        child: chip(context),
      );
    }
    return chip(context);
  }

  Widget chip(BuildContext context) {
    // Material(
    //   child: MediaQuery(
    //     data: MediaQuery.of(context),
    return Container(
      alignment: alignment,
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

        labelStyle: labelStyle ?? Theme.of(context).textTheme.labelMedium,

        // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        // materialTapTargetSize: MaterialTapTargetSize.padded,
        materialTapTargetSize: materialTapTargetSize,
        // elevation: 10,
        // shadowColor: Colors.red,
        // backgroundColor: Colors.blue,
        // side: BorderSide.none,
        // shape: CircleBorder(side: BorderSide.none),
        // clipBehavior: Clip.none,
      ),
    );
  }

  Icon get avatar {
    return Icon(
      icon,
      size: iconSize,
      color: iconColor,
    );
  }
}
