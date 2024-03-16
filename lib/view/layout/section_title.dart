part of 'main.dart';

/// Header of Section
class ViewSectionTitle extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final bool show;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final VisualDensity? visualDensity;

  const ViewSectionTitle({
    super.key,
    this.leading,
    this.title,
    this.trailing,
    this.show = true,
    this.onPressed,
    // this.padding = const EdgeInsets.fromLTRB(25, 0, 25, 0),
    // this.padding = const EdgeInsets.fromLTRB(25, 0, 10, 0),

    this.padding = const EdgeInsets.only(left: 12, right: 12),
    // this.padding = const EdgeInsets.only(left: 12),
    this.visualDensity = VisualDensity.compact,
  });

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox();
    return ListTile(
      // contentPadding: (leading == null)
      //     ? const EdgeInsets.only(left: 30, right: 15, bottom: 10, top: 10)
      //     : padding,
      contentPadding: (leading != null || trailing != null)
          ? const EdgeInsets.only(left: 20, right: 5, bottom: 10, top: 10)
          : padding,
      // horizontalTitleGap: 0,
      // minVerticalPadding: 0,
      visualDensity: visualDensity,
      leading: leading,
      title: title,
      trailing: trailing,
      // titleTextStyle: Theme.of(context).textTheme.titleMedium,
      onTap: onPressed,
    );
  }
}
