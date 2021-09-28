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
  }) : super(key: key);

  final String? label;
  final String message;
  final IconData? icon;
  final bool iconLeft;
  final double? iconSize;
  final Color? iconColor;
  final bool softWrap;
  final TextOverflow overflow;

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
      avatar: (icon != null)
          ? Icon(
              icon,
              size: iconSize,
              color: iconColor,
            )
          : null,
      labelPadding: EdgeInsets.zero,
      label: Text(
        label ?? '',
        maxLines: 1,
        overflow: TextOverflow.fade,
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
