part of lidea.view;

class ViewHeaderLayoutStack extends StatelessWidget {
  final List<Widget> leftAction;
  final Widget? primary;
  final List<Widget> rightAction;
  final EdgeInsetsGeometry padding;
  final Widget? secondary;
  const ViewHeaderLayoutStack({
    Key? key,
    this.leftAction = const [],
    this.primary,
    this.rightAction = const [],
    this.padding = const EdgeInsets.symmetric(vertical: 4, horizontal: 7),
    this.secondary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        if (primary != null) primary!,
        Positioned(
          left: 0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: leftAction,
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: Padding(
            // padding: padding,
            padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
            child: Row(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: rightAction,
            ),
          ),
        ),
        if (secondary != null) secondary!,
      ],
    );
  }
}
