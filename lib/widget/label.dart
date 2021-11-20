import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class WidgetLabel extends StatelessWidget {
  const WidgetLabel({
    Key? key,
    this.icon,
    this.label,
    this.overflow = TextOverflow.fade,
    this.iconLeft = true,
    this.iconSize,
    this.iconColor,
    this.message = '',
    this.softWrap = false,
    this.enable = true,
    this.labelPadding = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
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

  @override
  Widget build(BuildContext context) {
    // return RichText(
    //   key: key,
    //   // maxLines: 1,
    //   softWrap: softWrap,
    //   overflow: overflow,
    //   textAlign: TextAlign.center,
    //   // strutStyle: const StrutStyle(height: 1.5),
    //   text: TextSpan(
    //     style: Theme.of(context).textTheme.subtitle1, //!.copyWith(height: 1.25, fontSize: 19),
    //     // style: TextStyle(height: 1.0, fontSize: 19),
    //     children: <InlineSpan>[
    //       if (icon != null && iconLeft == true)
    //         WidgetSpan(
    //           child: Icon(
    //             icon,
    //             size: 25,
    //           ),
    //           alignment: PlaceholderAlignment.middle,
    //         ),
    //       if (label != null)
    //         TextSpan(
    //           text: label,
    //         ),
    //       if (icon != null && iconLeft == false)
    //         WidgetSpan(
    //           child: Icon(
    //             icon,
    //             size: 22,
    //           ),
    //         ),
    //     ],
    //   ),
    // );

    // final iconWidget = Icon(icon, size: 25);
    // return Row(
    //   mainAxisSize: MainAxisSize.min,
    //   // mainAxisAlignment: MainAxisAlignment.end,
    //   textBaseline: TextBaseline.ideographic,
    //   verticalDirection: VerticalDirection.up,
    //   children: [
    //     if (icon != null && iconLeft == true) Icon(icon, size: 25),
    //     if (label != null) Text(label!, style: Theme.of(context).textTheme.bodyText1),
    //     if (icon != null && iconLeft == false) Icon(icon, size: 25),
    //   ],
    // );
    final btn = Chip(
      backgroundColor: Colors.transparent,
      padding: padding,
      avatar: (icon != null)
          ? Icon(
              icon,
              size: iconSize,
              color: iconColor,
            )
          : null,
      labelPadding: labelPadding,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      label: Text(
        label ?? '',
        maxLines: 1,
        overflow: TextOverflow.fade,
        softWrap: false,
      ),
      labelStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
            color: enable ? null : Theme.of(context).disabledColor,
          ),
    );
    if (message.isNotEmpty) {
      return Tooltip(
        message: message,
        child: btn,
      );
    }
    return btn;
  }
}
