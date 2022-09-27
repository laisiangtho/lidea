part of view.action;

class ViewMark extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final BoxConstraints? constraints;
  final BoxDecoration? decoration;
  // final Alignment? alignment;

  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  final String? badge;

  final Widget? child;

  final String? label;
  final IconData? icon;
  final bool iconLeft;
  final double? iconSize;
  final Color? iconColor;
  final bool softWrap;
  final bool enable;
  final bool show;
  final TextOverflow overflow;
  final EdgeInsetsGeometry labelPadding;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextStyle? labelStyle;
  final MaterialTapTargetSize? materialTapTargetSize;

  const ViewMark({
    Key? key,
    this.constraints,
    this.decoration,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.badge,
    this.child,
    this.icon,
    this.iconLeft = true,
    this.iconSize,
    this.iconColor,
    this.label,
    this.overflow = TextOverflow.clip,
    this.labelPadding = EdgeInsets.zero,
    this.softWrap = false,
    this.maxLines = 1,
    this.textAlign,
    this.labelStyle,
    this.enable = true,
    this.show = true,
    this.materialTapTargetSize = MaterialTapTargetSize.shrinkWrap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (show == false) return const SizedBox();

    final ThemeData theme = Theme.of(context);
    final VisualDensity effectiveVisualDensity = theme.visualDensity;
    final BoxConstraints unadjusted = constraints ??
        const BoxConstraints(
          minWidth: 32,
          minHeight: 32,
          // minWidth: kMinInteractiveDimension,
          // minHeight: kMinInteractiveDimension,
        );
    final BoxConstraints adjusted = effectiveVisualDensity.effectiveConstraints(unadjusted);

    final double effectiveIconSize = iconSize ?? IconTheme.of(context).size ?? 26.0;

    final rowChild = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        if (label != null)
          Flexible(
            fit: FlexFit.loose,
            child: Padding(
              padding: labelPadding,
              // child: Text(
              //   label!,
              //   maxLines: maxLines,
              //   overflow: overflow,
              //   softWrap: softWrap,
              //   textAlign: textAlign,
              //   // style: theme.textTheme.labelMedium!.merge(labelStyle),
              //   style: DefaultTextStyle.of(context).,
              // ),
              child: DefaultTextStyle.merge(
                child: Text(
                  label!,
                  maxLines: maxLines,
                  overflow: overflow,
                  softWrap: softWrap,
                  textAlign: textAlign,
                  // style: TextStyle(inherit: true).merge(labelStyle),
                  // style: theme.textTheme.labelMedium!.merge(labelStyle),
                  // style: theme.textTheme.labelMedium!.copyWith(inherit: true).merge(labelStyle),

                  // style: DefaultTextStyle.of(context).,
                ),
                // style: TextStyle(inherit: true).merge(labelStyle),
                style: labelStyle,
              ),
            ),
          ),
        if (child != null) child!,
      ],
    );
    // if (iconLeft == true && icon != null) _iconWidget(effectiveIconSize),
    // if (iconLeft == false && icon != null) _iconWidget(effectiveIconSize),

    if (icon != null) {
      rowChild.children
          .insert(iconLeft ? 0 : rowChild.children.length, _iconWidget(effectiveIconSize));
    }
    return Padding(
      padding: margin,
      child: ConstrainedBox(
        constraints: adjusted,
        child: Padding(
          padding: padding,
          child: Stack(
            fit: StackFit.passthrough,
            clipBehavior: Clip.none,
            // alignment: AlignmentDirectional.center,
            children: [
              DecoratedBox(
                decoration: decoration ?? const BoxDecoration(),
                child: SizedBox(
                  height: effectiveIconSize,
                  // width: effectiveIconSize,
                  child: rowChild,
                ),
              ),
              ViewBadage(
                badge: badge,
                top: 0,
                right: 5,
                show: badge != null && badge!.isNotEmpty,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconWidget(double effectiveIconSize) {
    return Align(
      child: IconTheme.merge(
        data: IconThemeData(
          size: effectiveIconSize,
          color: iconColor,
        ),
        child: Icon(icon),
      ),
      // child: IconTheme(
      //   data: IconThemeData(
      //     size: effectiveIconSize,
      //     // color: iconColor,
      //   ),
      //   child: Icon(icon),
      // ),
    );
  }
}
