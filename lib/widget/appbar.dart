part of 'main.dart';

class WidgetAppbarTitle extends StatelessWidget {
  const WidgetAppbarTitle({
    Key? key,
    required this.label,
    this.padding = const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    this.alignment,
    this.shrink = 0.0,
  }) : super(key: key);

  final String label;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry? alignment;
  final double shrink;

  @override
  Widget build(BuildContext context) {
    return WidgetLabel(
      key: key,
      padding: padding,
      alignment: alignment,
      label: label,
      maxLines: 1,
      overflow: TextOverflow.fade,
      labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
            height: 1.1,
            fontSize: fontSize,
          ),
    );
  }

  double get fontSize {
    return (30 * shrink).clamp(21, 30).toDouble();
  }
}
