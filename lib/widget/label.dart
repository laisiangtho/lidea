import 'package:flutter/material.dart';

class WidgetLabel extends StatelessWidget {
  const WidgetLabel({
    Key? key,
    this.icon,
    this.label,
    this.overflow = TextOverflow.fade,
    this.iconLeft = true,
    this.iconSize = 26.0,
    this.iconColor,
    this.message = '',
    this.softWrap = false,
    this.enable = true,
    this.labelPadding = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.materialTapTargetSize = MaterialTapTargetSize.shrinkWrap,
  }) : super(key: key);

  final String? label;
  final String message;
  final IconData? icon;
  final bool iconLeft;
  final double? iconSize;
  final Color? iconColor;
  final bool softWrap;
  final bool enable;
  final TextOverflow overflow;
  final EdgeInsetsGeometry? labelPadding;
  final EdgeInsetsGeometry? padding;
  final MaterialTapTargetSize? materialTapTargetSize;

  @override
  Widget build(BuildContext context) {
    final btn = Chip(
      padding: padding,
      avatar: (icon != null) ? avatar : null,
      labelPadding: labelPadding,
      // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      // materialTapTargetSize: MaterialTapTargetSize.padded,
      materialTapTargetSize: materialTapTargetSize,
      label: Text(
        label ?? '',
        maxLines: 1,
        overflow: TextOverflow.fade,
        softWrap: false,
        // style: Theme.of(context).textTheme.bodyText1,
      ),
      // labelStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
      //       color: enable ? null : Theme.of(context).disabledColor,
      //     ),
    );
    if (message.isNotEmpty) {
      return Tooltip(
        message: message,
        child: btn,
      );
    }
    return btn;
  }

  Icon get avatar {
    return Icon(
      icon,
      size: iconSize,
      color: iconColor,
    );
  }
}
