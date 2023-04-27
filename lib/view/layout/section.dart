part of view.layout;

class ViewSection extends StatelessWidget {
  final Widget? child;

  /// widget to render
  final Widget? onAwait;
  final Widget? onEmpty;
  final bool? primary;
  final EdgeInsetsGeometry? padding;

  final bool show;
  final Duration duration;

  final bool header;
  final Widget? headerLeading;
  final Widget? headerTitle;
  final Widget? headerTrailing;
  final void Function()? headerOnPressed;

  final bool footer;
  final Widget? footerLeading;
  final Widget? footerTitle;
  final Widget? footerTrailing;
  final void Function()? footerOnPressed;

  const ViewSection({
    Key? key,
    this.child,
    this.onAwait,
    this.onEmpty,
    this.primary,
    this.padding,
    this.show = true,
    this.duration = Duration.zero,
    this.header = true,
    this.headerLeading,
    this.headerTitle,
    this.headerTrailing,
    this.headerOnPressed,
    this.footer = true,
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
    return FutureBuilder<bool>(
      future: Future.delayed(duration, () => true),
      builder: (_, snap) {
        if (snap.hasData == false && onAwait != null) {
          return onAwait!;
        }
        if (show == false && onEmpty != null) {
          return onEmpty!;
        }
        return ViewFlatBuilder(
          primary: primary,
          // padding: padding ?? const EdgeInsets.fromLTRB(0, 3, 0, 5),
          padding: padding,
          show: show && (hasChild || hasHeader || hasFooter),
          // onAwait: onAwait,
          child: ListBody(
            children: [
              if (header && hasHeader)
                ViewSectionTitle(
                  show: header,
                  leading: headerLeading,
                  title: headerTitle,
                  trailing: headerTrailing,
                  onPressed: headerOnPressed,
                ),
              if (hasChild) child!,
              if (footer && hasFooter)
                ViewSectionMore(
                  show: footer,
                  leading: footerLeading,
                  title: footerTitle,
                  trailing: footerTrailing,
                  onPressed: footerOnPressed,
                ),
            ],
          ),
        );
      },
    );
  }
}
