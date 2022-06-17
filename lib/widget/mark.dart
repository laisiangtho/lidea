part of lidea.widget;

class WidgetMark extends StatelessWidget {
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

  const WidgetMark({
    Key? key,
    this.constraints,
    this.decoration,
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
    this.overflow = TextOverflow.fade,
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
          minWidth: kMinInteractiveDimension,
          minHeight: kMinInteractiveDimension,
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
              child: Text(
                label!,
                maxLines: maxLines,
                overflow: overflow,
                softWrap: softWrap,
                textAlign: textAlign,
                style: theme.textTheme.labelMedium!.merge(labelStyle),
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
    return ConstrainedBox(
      constraints: adjusted,
      child: Padding(
        padding: padding,
        child: Stack(
          fit: StackFit.passthrough,
          clipBehavior: Clip.none,
          alignment: AlignmentDirectional.center,
          children: [
            DecoratedBox(
              decoration: decoration ?? const BoxDecoration(),
              child: SizedBox(
                height: effectiveIconSize,
                // width: effectiveIconSize,
                child: rowChild,
              ),
            ),
            WidgetBadage(
              badge: badge,
              top: 0,
              right: 5,
              show: badge != null && badge!.isNotEmpty,
            ),
          ],
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
    );
  }
}
