part of 'main.dart';

class WidgetButton extends StatefulWidget {
  final Widget? child;
  final void Function()? onPressed;
  final void Function()? onLongPress;
  final Duration duration;
  final double opacity;
  final EdgeInsetsGeometry margin;

  // Container
  final EdgeInsetsGeometry padding;
  // final double? height;
  // final double? width;
  final BoxDecoration decoration;

  // Material
  final double elevation;
  final Color? color;
  final Color? shadowColor;
  final Clip clipBehavior;
  final TextStyle? textStyle;

  /// Usage
  /// ```dart
  /// BorderRadius.all(Radius.circular(10))
  /// BorderRadius.circular(10)
  /// ```
  final BorderRadiusGeometry? borderRadius;

  const WidgetButton({
    Key? key,
    this.child,
    this.onPressed,
    this.onLongPress,
    this.duration = const Duration(milliseconds: 100),
    this.opacity = 0.3,
    this.margin = const EdgeInsets.all(0.0),
    this.padding = const EdgeInsets.all(0.0),
    // this.height,
    // this.width,
    this.decoration = const BoxDecoration(),
    this.elevation = 0.0,
    this.color,
    this.shadowColor,
    this.borderRadius,
    this.clipBehavior = Clip.none,
    this.textStyle,
  }) : super(key: key);

  @override
  _WidgetButtonState createState() => _WidgetButtonState();
}

class _WidgetButtonState extends State<WidgetButton> {
  bool down = false;

  Future<void> setOptical(bool isDown) {
    return Future.microtask(() {
      if (mounted && down != isDown) {
        setState(() {
          down = isDown;
        });
      }
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  bool get enabled => widget.onPressed != null;
  double get opticityDisabled {
    // (widget.opacity > 0.2) ? widget.opacity - 0.2 : 0.0;
    if (enabled) {
      return down ? widget.opacity : 1;
    } else if (widget.opacity > 0.2) {
      return widget.opacity - 0.1;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: widget.key,
      onTapDown: (_) => setOptical(true),
      onTapUp: (_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          setOptical(false);
        });
      },
      onTapCancel: () => setOptical(false),
      onTap: () {
        // if (enabled) {
        //   // widget.onPressed!.call();
        //   widget.onPressed!();
        // }
        // widget.onPressed?.call();
        setOptical(true).whenComplete(() {
          widget.onPressed?.call();
        });
      },
      onLongPress: widget.onLongPress,
      child: Padding(
        padding: widget.margin,
        child: AnimatedOpacity(
          duration: widget.duration,
          opacity: opticityDisabled,
          child: Material(
            // MaterialType type = MaterialType.canvas,
            // double elevation = 0.0,
            // Color? color,
            // Color? shadowColor,
            // TextStyle? textStyle,
            // BorderRadiusGeometry? borderRadius,
            // ShapeBorder? shape,
            // bool borderOnForeground = true,
            // Clip clipBehavior = Clip.none,
            // Duration animationDuration = kThemeChangeDuration,
            elevation: widget.elevation,
            color: widget.color,
            shadowColor: widget.shadowColor,
            borderRadius: widget.borderRadius,
            clipBehavior: widget.clipBehavior,
            textStyle: widget.textStyle,
            child: SizedBox(
              child: DecoratedBox(
                decoration: widget.decoration,
                child: Padding(
                  padding: widget.padding,
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
