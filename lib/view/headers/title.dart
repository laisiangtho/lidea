// ignore_for_file: use_super_parameters

part of 'main.dart';

class ViewHeaderTitle extends StatelessWidget {
  const ViewHeaderTitle({
    Key? key,
    required this.label,
    this.padding = const EdgeInsets.symmetric(
      vertical: 0.0,
      horizontal: 50.0,
    ),
    this.alignment,
    this.shrinkMin = 21,
    this.shrinkMax = 30,
    this.data,
  }) : super(key: key);

  final String label;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry? alignment;
  // final double shrink;
  final ViewHeaderData? data;
  final int shrinkMin;
  final int shrinkMax;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.center,
      child: Padding(
        padding: padding,
        child: Text(
          label,
          maxLines: 1,
          // textScaleFactor: 1.0,
          // overflow: TextOverflow.fade,
          // style: Theme.of(context).textTheme.titleLarge,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: fontSize,
                // fontWeight: FontWeight.lerp(FontWeight.bold, FontWeight.normal, data!.snapShrink),
              ),
        ),
      ),
    );
  }

  // Custom 30px to labelMedium: 18px
  double? get fontSize {
    if (data != null) {
      return (30 * data!.snapShrink).clamp(shrinkMin, shrinkMax).toDouble();
    }
    return null;
    // return (30 * shrink).clamp(21, 30).toDouble();
    // return (30 * shrink).clamp(18, 30).toDouble();
  }
}
