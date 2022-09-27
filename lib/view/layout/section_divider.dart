part of view.layout;

class ViewSectionDivider extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final bool? primary;
  const ViewSectionDivider({
    Key? key,
    this.primary,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewFlatBuilder(
      primary: primary,
      padding: padding,
      child: const Divider(
        height: 0,
        thickness: 0.3,
      ),
    );
  }
}
