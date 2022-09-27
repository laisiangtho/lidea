part of view.header;

class ViewHeaderLayoutStack extends StatelessWidget {
  /// left Action
  final List<Widget> left;

  /// Title
  final Widget? primary;

  /// right Action
  final List<Widget> right;
  final Widget? secondary;
  final ViewHeaderData data;
  const ViewHeaderLayoutStack({
    Key? key,
    required this.data,
    this.left = const [],
    this.primary,
    this.right = const [],
    this.secondary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        if (primary != null) primary!,
        if (left.isNotEmpty)
          Positioned(
            left: 0,
            height: data.minHeight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: left,
            ),
          ),
        if (right.isNotEmpty)
          Positioned(
            right: 0,
            height: data.minHeight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: right,
            ),
          ),
        if (secondary != null) secondary!,
      ],
    );
  }
}
