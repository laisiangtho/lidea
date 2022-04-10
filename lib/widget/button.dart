part of lidea.widget;

class WidgetButton extends StatefulWidget {
  final String? message;

  final Widget? child;
  final bool enable;
  final bool show;
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
  final BoxConstraints constraints;

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
    this.message,
    this.child,
    this.enable = true,
    this.show = true,
    this.onPressed,
    this.onLongPress,
    // this.duration = const Duration(milliseconds: 100),
    this.duration = kThemeChangeDuration,
    this.opacity = 0.3,
    this.margin = const EdgeInsets.all(0.0),
    this.padding = const EdgeInsets.all(0.0),
    this.constraints = const BoxConstraints(),
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

  bool get enabled => widget.enable ? widget.onPressed != null : false;

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
    if (!widget.show) return const SizedBox();

    return Padding(
      padding: widget.margin,
      child: GestureDetector(
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
          if (enabled) {
            setOptical(true).whenComplete(() {
              widget.onPressed?.call();
            });
          }
        },
        onLongPress: widget.onLongPress,
        child: rowChild(),
      ),
    );
  }

  Widget rowChild() {
    final content = AnimatedOpacity(
      duration: widget.duration,
      opacity: opticityDisabled,
      child: ConstrainedBox(
        constraints: widget.constraints,
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
    );
    if (widget.message != null && widget.message!.isNotEmpty) {
      return Tooltip(
        message: widget.message,
        triggerMode: TooltipTriggerMode.longPress,
        child: content,
      );
    }
    return content;
  }
}
