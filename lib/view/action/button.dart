part of 'main.dart';

// const EdgeInsets _kButtonPadding = EdgeInsets.all(16.0);
// const EdgeInsets _kBackgroundButtonPadding = EdgeInsets.symmetric(
//   vertical: 14.0,
//   horizontal: 64.0,
// );

class ViewButton extends StatefulWidget {
  /// Creates an iOS-style button.
  const ViewButton({
    super.key,
    required this.child,
    this.style,
    // this.padding = const EdgeInsets.symmetric(vertical: 13.5, horizontal: 7),
    this.padding = const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
    this.margin = EdgeInsets.zero,
    this.color,
    this.disabledColor = CupertinoColors.quaternarySystemFill,
    // this.minSize = 44.0,
    // this.minSize = 35.0,
    this.constraints = const BoxConstraints(
      minWidth: 50,
    ),
    this.pressedOpacity = 0.4,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    // this.alignment = Alignment.center,
    this.onPressed,
    this.show = true,
    this.showShadow = false,
    this.enable = true,
    this.badge,
    this.message,
  }) : _filled = false;

  /// Creates an iOS-style button with a filled background.
  const ViewButton.filled({
    super.key,
    required this.child,
    this.style,
    // this.padding = const EdgeInsets.all(16.0),
    // this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 7),
    this.padding = const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
    // this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.color,
    this.disabledColor = CupertinoColors.quaternarySystemFill,
    // this.minSize = 44.0,
    this.constraints = const BoxConstraints(
      minWidth: 50,
    ),
    this.pressedOpacity = 0.4,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    // this.alignment = Alignment.center,
    this.onPressed,
    this.show = true,
    this.showShadow = false,
    this.enable = true,
    this.badge,
    this.message,
  }) :
        //color = null,
        _filled = true;

  final Widget child;
  final TextStyle? style;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? color;
  final Color disabledColor;
  final VoidCallback? onPressed;
  // final double? minSize;
  final BoxConstraints constraints;
  final double? pressedOpacity;
  final BorderRadius? borderRadius;
  // final AlignmentGeometry alignment;
  final bool _filled;
  final bool show;
  final bool showShadow;
  final bool enable;
  final String? badge;
  final String? message;

  // bool get enabled => onPressed != null;
  bool get enabled => enable ? onPressed != null : false;

  @override
  State<ViewButton> createState() => _ViewButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('enabled', value: enabled, ifFalse: 'disabled'));
  }
}

class _ViewButtonState extends State<ViewButton> with SingleTickerProviderStateMixin {
  // Eyeballed values. Feel free to tweak.
  static const Duration kFadeOutDuration = Duration(milliseconds: 120);
  static const Duration kFadeInDuration = Duration(milliseconds: 180);
  final Tween<double> _opacityTween = Tween<double>(begin: 1.0);

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: 0.0,
      vsync: this,
    );
    _opacityAnimation =
        _animationController.drive(CurveTween(curve: Curves.decelerate)).drive(_opacityTween);
    _setTween();
  }

  @override
  void didUpdateWidget(ViewButton old) {
    super.didUpdateWidget(old);
    _setTween();
  }

  void _setTween() {
    _opacityTween.end = widget.pressedOpacity ?? 1.0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool _buttonHeldDown = false;

  void _handleTapDown(TapDownDetails event) {
    if (!_buttonHeldDown) {
      _buttonHeldDown = true;
      _animate();
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _animate() {
    if (_animationController.isAnimating) {
      return;
    }
    final bool wasHeldDown = _buttonHeldDown;
    final TickerFuture ticker = _buttonHeldDown
        ? _animationController.animateTo(1.0,
            duration: kFadeOutDuration, curve: Curves.easeInOutCubicEmphasized)
        : _animationController.animateTo(0.0,
            duration: kFadeInDuration, curve: Curves.easeOutCubic);
    ticker.then<void>((void value) {
      if (mounted && wasHeldDown != _buttonHeldDown) {
        _animate();
      }
    });
  }

  bool get enabled => widget.enabled;

  // void Function()? get onPressed => widget.onPressed;
  void Function()? get onPressed => enabled ? widget.onPressed : null;

  @override
  Widget build(BuildContext context) {
    if (!widget.show) return const SizedBox();

    return Padding(
      padding: widget.margin,
      child: MouseRegion(
        cursor: enabled && kIsWeb ? SystemMouseCursors.click : MouseCursor.defer,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: enabled ? _handleTapDown : null,
          onTapUp: enabled ? _handleTapUp : null,
          onTapCancel: enabled ? _handleTapCancel : null,
          onTap: onPressed,
          child: ConstrainedBox(
            // constraints: widget.minSize == null
            //     ? const BoxConstraints()
            //     : BoxConstraints(
            //         minWidth: widget.minSize!,
            //         minHeight: widget.minSize!,
            //       ),
            constraints: widget.constraints,
            child: Stack(
              fit: StackFit.passthrough,
              clipBehavior: Clip.none,
              alignment: AlignmentDirectional.center,
              children: [
                rowChild(),
                ViewBadage(
                  badge: widget.badge,
                  top: 0,
                  right: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget rowChild() {
    // CupertinoTheme.of(context).
    // final theme = Theme.of(context);

    // theme.primaryColor
    // final abc = theme.;

    // final theme = CupertinoTheme.of(context);
    // final Color primaryColor = theme.primaryColor;
    // final Color? backgroundColor = widget.color == null
    //     ? (widget._filled ? primaryColor : null)
    //     : CupertinoDynamicColor.maybeResolve(widget.color, context);

    // final Color foregroundColor = backgroundColor != null
    //     ? theme.primaryContrastingColor
    //     : enabled
    //         ? primaryColor
    //         : CupertinoDynamicColor.resolve(CupertinoColors.placeholderText, context);

    // final TextStyle textStyle = theme.textTheme.textStyle.copyWith(color: foregroundColor);

    final theme = CupertinoTheme.of(context);
    final Color primaryColor = theme.primaryColor;
    final Color? backgroundColor = widget.color == null
        ? (widget._filled ? Theme.of(context).primaryColor : null)
        : CupertinoDynamicColor.maybeResolve(widget.color, context);

    final Color foregroundColor = backgroundColor != null
        // ? theme.primaryContrastingColor
        ? enabled
            ? primaryColor
            : primaryColor.withOpacity(0.4)
        : enabled
            ? primaryColor
            : CupertinoDynamicColor.resolve(CupertinoColors.placeholderText, context);

    // final hasBackground = backgroundColor != null;

    // final style = theme.textTheme.textStyle.merge(widget.style).copyWith(
    //       color: foregroundColor,
    //     );
    // final style = (widget.style ?? theme.textTheme.textStyle).copyWith(
    //   color: foregroundColor,
    // );

    // final showShadow = backgroundColor != null && widget.showShadow;

    final row = Semantics(
      button: true,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            // border: Border.all(width: 0.1, color: Theme.of(context).dividerColor),
            boxShadow: [
              if (backgroundColor != null && backgroundColor.opacity > 0.0 && widget.showShadow)
                BoxShadow(
                  // color: Theme.of(context).shadowColor.withOpacity(enabled ? 1 : 0.4),
                  color: Theme.of(context)
                      .shadowColor
                      .withOpacity(enabled ? backgroundColor.opacity : 0.4),
                  spreadRadius: 0.2,
                  blurRadius: 0.3,
                  offset: const Offset(0, 0.7),
                ),
            ],
            // color: backgroundColor != null && !enabled
            //     ? CupertinoDynamicColor.resolve(widget.disabledColor, context)
            //     : backgroundColor,
            color: backgroundColor != null && !enabled
                ? CupertinoDynamicColor.resolve(backgroundColor, context)
                : backgroundColor,
            // color: backgroundColor,
          ),
          // child: Padding(
          //   // padding: widget.padding ??
          //   //     (backgroundColor != null ? _kBackgroundButtonPadding : _kButtonPadding),
          //   padding: widget.padding,
          //   child: Align(
          //     alignment: widget.alignment,
          //     widthFactor: 1.0,
          //     // heightFactor: 1.0,
          //     child: DefaultTextStyle(
          //       style: theme.textTheme.textStyle.merge(widget.style).copyWith(
          //             color: foregroundColor,
          //           ),
          //       child: IconTheme(
          //         data: IconThemeData(color: foregroundColor),
          //         child: widget.child,
          //       ),
          //     ),
          //   ),
          // ),
          child: Padding(
            // padding: widget.padding ??
            //     (backgroundColor != null ? _kBackgroundButtonPadding : _kButtonPadding),
            padding: widget.padding,
            child: DefaultTextStyle(
              style: theme.textTheme.textStyle.merge(widget.style).copyWith(
                    color: foregroundColor,
                  ),
              child: IconTheme(
                data: IconThemeData(color: foregroundColor),
                child: widget.child,
              ),
            ),
          ),
          // child: Container(
          //   alignment: widget.alignment,
          //   padding: widget.padding,
          //   child: DefaultTextStyle(
          //     style: theme.textTheme.textStyle.merge(widget.style).copyWith(
          //           color: foregroundColor,
          //         ),
          //     child: IconTheme(
          //       data: IconThemeData(color: foregroundColor),
          //       child: widget.child,
          //     ),
          //   ),
          // ),
        ),
      ),
    );

    if (widget.message != null && widget.message!.isNotEmpty) {
      return Tooltip(
        message: widget.message,
        triggerMode: TooltipTriggerMode.longPress,
        child: row,
      );
    }
    return row;
  }
}
