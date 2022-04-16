part of lidea.widget;

class WidgetBlockTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final VisualDensity? visualDensity;

  const WidgetBlockTile({
    Key? key,
    this.leading,
    this.title,
    this.trailing,
    this.onPressed,
    this.padding = const EdgeInsets.fromLTRB(25, 0, 25, 0),
    this.visualDensity = VisualDensity.compact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: padding,
      horizontalTitleGap: 0,
      // minVerticalPadding: 0,
      visualDensity: visualDensity,
      leading: leading,
      title: title,
      trailing: trailing,
      onTap: onPressed,
    );
  }
}

class WidgetBlockMore extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final VisualDensity? visualDensity;

  const WidgetBlockMore({
    Key? key,
    this.leading,
    this.title,
    this.trailing,
    this.onPressed,
    this.padding = const EdgeInsets.fromLTRB(25, 0, 25, 0),
    this.visualDensity = VisualDensity.compact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: padding,
      horizontalTitleGap: 0,
      // minVerticalPadding: 0,
      visualDensity: visualDensity,
      leading: leading,
      title: title,
      trailing: trailing,
      onTap: onPressed,
    );
  }
}

class WidgetBlockSection extends StatelessWidget {
  final Widget? child;
  final Widget? placeHolder;
  final bool? primary;
  final EdgeInsetsGeometry? padding;

  final bool show;
  final Duration duration;
  final Widget? headerLeading;
  final Widget? headerTitle;
  final Widget? headerTrailing;
  final void Function()? headerOnPressed;
  final Widget? footerLeading;
  final Widget? footerTitle;
  final Widget? footerTrailing;
  final void Function()? footerOnPressed;

  const WidgetBlockSection({
    Key? key,
    this.child,
    this.placeHolder,
    this.primary,
    this.padding,
    this.show = true,
    this.duration = Duration.zero,
    this.headerLeading,
    this.headerTitle,
    this.headerTrailing,
    this.headerOnPressed,
    this.footerLeading,
    this.footerTitle,
    this.footerTrailing,
    this.footerOnPressed,
  }) : super(key: key);

  bool get hasChild => child != null;
  bool get hasHeader => headerLeading != null || headerTitle != null || headerTrailing != null;
  bool get hasFooter => footerLeading != null || footerTitle != null || footerTrailing != null;
  @override
  Widget build(BuildContext context) {
    // ListBody()
    return FutureBuilder<bool>(
      future: Future.delayed(duration, () => true),
      builder: (_, snap) {
        if (snap.hasData == false && placeHolder != null) {
          return placeHolder!;
        }
        return WidgetChildBuilder(
          primary: primary,
          padding: padding ?? const EdgeInsets.fromLTRB(0, 3, 0, 5),
          show: show && (hasChild || hasHeader || hasFooter),
          child: ListBody(
            children: [
              if (hasHeader)
                WidgetBlockTile(
                  leading: headerLeading,
                  title: headerTitle,
                  trailing: headerTrailing,
                  onPressed: headerOnPressed,
                ),
              if (hasChild) child!,
              if (hasFooter)
                WidgetBlockMore(
                  leading: footerLeading,
                  title: footerTitle,
                  trailing: footerTrailing,
                  onPressed: footerOnPressed,
                ),
            ],
          ),
          placeHolder: placeHolder,
        );
      },
    );
  }
}

class WidgetBlockCard extends StatelessWidget {
  /// rounded and clip, card style
  final Widget? child;
  final EdgeInsetsGeometry? margin;

  const WidgetBlockCard({
    Key? key,
    this.child,
    this.margin = const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Material(
    //   color: Theme.of(context).primaryColor,
    //   borderOnForeground: false,
    //   shape: RoundedRectangleBorder(
    //     side: BorderSide(
    //       color: Theme.of(context).dividerColor,
    //       width: 0.6,
    //     ),
    //     borderRadius: const BorderRadius.all(Radius.circular(12)),
    //   ),
    //   clipBehavior: Clip.hardEdge,
    // );
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Theme.of(context).dividerColor,
            // color: Theme.of(context).backgroundColor,
            blurRadius: 0.2,
            spreadRadius: 0.2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: child,
    );
  }
}

class WidgetBlockFill extends StatelessWidget {
  /// rectangle block background color
  /// having top and bottom border
  final Widget? child;

  const WidgetBlockFill({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0.7),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Theme.of(context).dividerColor,
            blurRadius: 0.2,
            spreadRadius: 0.2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: child,
    );
  }
}
