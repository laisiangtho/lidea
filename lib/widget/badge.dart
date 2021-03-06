part of lidea.widget;

class WidgetBadage extends StatelessWidget {
  final String? badge;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final bool show;

  const WidgetBadage({
    Key? key,
    this.badge,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.show = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!show) return SizedBox();

    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: SizedBox(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).errorColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).backgroundColor.withOpacity(0.5),
                offset: const Offset(0, .2),
                blurRadius: 1,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
            child: Text(
              badge!,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    fontSize: 13,
                    letterSpacing: 0.1,
                    color: Colors.white,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
