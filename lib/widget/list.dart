part of lidea.widget;

class WidgetListDivider extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  const WidgetListDivider({Key? key, this.padding = EdgeInsets.zero}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: const Divider(
        height: 0,
        thickness: 0.3,
      ),
    );
  }
}
