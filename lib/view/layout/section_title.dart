part of view.layout;

// Header of Section
class ViewSectionTitle extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final bool show;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final VisualDensity? visualDensity;

  const ViewSectionTitle({
    Key? key,
    this.leading,
    this.title,
    this.trailing,
    this.show = true,
    this.onPressed,
    // this.padding = const EdgeInsets.fromLTRB(25, 0, 25, 0),
    // this.padding = const EdgeInsets.fromLTRB(25, 0, 10, 0),

    this.padding = const EdgeInsets.only(left: 12),
    this.visualDensity = VisualDensity.compact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox();
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
