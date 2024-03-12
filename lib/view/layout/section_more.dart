part of 'main.dart';

// Footer of Section
class ViewSectionMore extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final bool show;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final VisualDensity? visualDensity;

  const ViewSectionMore({
    super.key,
    this.leading,
    this.title,
    this.trailing,
    this.show = true,
    this.onPressed,
    this.padding,
    this.visualDensity = VisualDensity.compact,
  });

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox();
    // return DefaultTextStyle(
    //   style: TextStyle(
    //     color: Colors.red,
    //   ),
    //   child: ListTile(
    //     contentPadding: padding,
    //     horizontalTitleGap: 0,
    //     // minVerticalPadding: 0,
    //     visualDensity: visualDensity,
    //     leading: leading,
    //     title: title,
    //     trailing: trailing,
    //     onTap: onPressed,
    //   ),
    // );
    return ListTile(
      style: ListTileStyle.drawer,
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
