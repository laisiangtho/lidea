part of 'main.dart';

class OpticityButton extends StatefulWidget {
  final Widget child;
  final void Function()? onPressed;
  final Duration duration;
  final double opacity;

  const OpticityButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.duration = const Duration(milliseconds: 0),
    this.opacity = 0.5,
  }) : super(key: key);

  @override
  _TouchableOpacityState createState() => _TouchableOpacityState();
}

class _TouchableOpacityState extends State<OpticityButton> {
  bool down = false;

  void setOptical(bool isDown) {
    setState(() {
      down = isDown;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  bool get enabled => widget.onPressed != null;
  double get opticityDisabled {
    // (widget.opacity > 0.2) ? widget.opacity - 0.2 : 0.0;
    if (enabled) {
      return down ? widget.opacity : 1;
    } else if (widget.opacity > 0.2) {
      return widget.opacity - 0.2;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setOptical(true),
      onTapUp: (_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          setOptical(false);
        });
      },
      onTapCancel: () => setOptical(false),
      onTap: () {
        setOptical(true);
        if (enabled) {
          widget.onPressed!.call();
        }
      },
      child: AnimatedOpacity(
        child: widget.child,
        duration: widget.duration,
        opacity: opticityDisabled,
      ),
    );
  }
}
