part of lidea.widget;

class WidgetAppbarTitle extends StatelessWidget {
  const WidgetAppbarTitle({
    Key? key,
    required this.label,
    this.padding = const EdgeInsets.all(0),
    this.alignment,
    this.shrink = 0.0,
  }) : super(key: key);

  final String label;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry? alignment;
  final double shrink;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.center,
      child: Padding(
        padding: padding,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.fade,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: fontSize,
              ),
        ),
      ),
    );
  }

  double get fontSize {
    return (30 * shrink).clamp(21, 30).toDouble();
  }
}
