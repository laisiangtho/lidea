part of 'main.dart';

// WidgetBlockHeader
class WidgetBlockTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;

  const WidgetBlockTile({
    Key? key,
    this.leading,
    this.title,
    this.trailing,
    this.onPressed,
    this.padding = const EdgeInsets.fromLTRB(25, 0, 25, 0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: padding,
      horizontalTitleGap: 0,
      // minVerticalPadding: 0,
      visualDensity: VisualDensity.compact,
      leading: leading,
      title: title,
      trailing: trailing,
      onTap: onPressed,
    );
  }
}

// class WidgetBlockHeader extends StatelessWidget {
//   final String label;
//   final Widget? more;
//   final void Function()? onPressed;
//   final EdgeInsetsGeometry? padding;

//   const WidgetBlockHeader({
//     Key? key,
//     required this.label,
//     this.more,
//     this.onPressed,
//     this.padding,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return WidgetBlockTile(
//       padding: padding,
//       title: WidgetLabel(
//         alignment: Alignment.centerLeft,
//         label: label,
//       ),
//       trailing: WidgetButton(
//         child: more,
//         decoration: BoxDecoration(
//           color: Colors.red,
//         ),
//         elevation: 2,
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         onPressed: onPressed,
//       ),
//     );
//   }
// }

// WidgetBlockFooter
// class WidgetBlockFooter extends StatelessWidget {
//   final String label;
//   final Widget? more;
//   final void Function()? onPressed;
//   final EdgeInsetsGeometry? padding;

//   const WidgetBlockFooter({
//     Key? key,
//     required this.label,
//     this.more,
//     this.onPressed,
//     this.padding,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // return Padding(
//     //   padding: padding,
//     //   child: Row(
//     //     mainAxisAlignment: mainAxisAlignment,
//     //     children: [
//     //       WidgetLabel(
//     //         alignment: Alignment.centerLeft,
//     //         label: label,
//     //       ),
//     //       if (more != null)
//     //         WidgetButton(
//     //           child: more!,
//     //           onPressed: onPressed,
//     //         )
//     //     ],
//     //   ),
//     // );
//     return WidgetBlockTile(
//       padding: padding,
//       title: WidgetLabel(
//         alignment: Alignment.centerLeft,
//         label: label,
//       ),
//       trailing: WidgetButton(
//         child: more,
//         decoration: BoxDecoration(
//           color: Colors.red,
//         ),
//         elevation: 2,
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         onPressed: onPressed,
//       ),
//     );
//   }
// }
