part of 'main.dart';

class ViewSectionDivider extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final bool? primary;
  const ViewSectionDivider({
    super.key,
    this.primary,
    this.padding,
  });

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
