part of view.layout;

class ViewBlockCard extends StatelessWidget {
  /// rounded and clip, card style
  final Widget? child;
  final EdgeInsetsGeometry margin;
  final BorderRadiusGeometry borderRadius;
  final Clip clipBehavior;

  /// Child as Card, having margin set around
  /// with BorderRadius.all(Radius.circular(12))
  const ViewBlockCard({
    Key? key,
    this.margin = const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    this.clipBehavior = Clip.hardEdge,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.child,
  }) : super(key: key);

  /// Child as Card, having margin set only top and bottom
  /// with BorderRadius.zero
  const ViewBlockCard.fill({
    Key? key,
    this.margin = const EdgeInsets.symmetric(vertical: 10),
    this.clipBehavior = Clip.none,
    this.borderRadius = BorderRadius.zero,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final cardTheme = CardTheme.of(context).color;
    return Padding(
      padding: margin,
      child: Material(
        type: MaterialType.card,
        // elevation: 0.8,
        elevation: CardTheme.of(context).elevation!,
        // color: CardTheme.of(context).color,
        color: CardTheme.of(context).color,
        shadowColor: CardTheme.of(context).shadowColor,
        // color: Theme.of(context).primaryColor,
        // shadowColor: Theme.of(context).shadowColor,
        clipBehavior: clipBehavior,
        // shape: RoundedRectangleBorder(
        //   borderRadius: borderRadius,
        //   // side: BorderSide(
        //   //   color: Theme.of(context).shadowColor,
        //   //   width: 0.5,
        //   // ),
        // ),
        shape: RoundedRectangleBorder(
          // side: BorderSide(width: 0.1, color: Theme.of(context).dividerColor),
          borderRadius: borderRadius,
        ),
        // child: DecoratedBox(
        //   decoration: BoxDecoration(
        //     // color: Theme.of(context).primaryColor,
        //     borderRadius: borderRadius,
        //     boxShadow: <BoxShadow>[
        //       BoxShadow(
        //         color: Theme.of(context).shadowColor,
        //         blurRadius: 0.2,
        //         spreadRadius: 0.2,
        //         offset: const Offset(0, 0),
        //       ),
        //     ],
        //   ),
        //   child: child,
        // ),
        child: child,
      ),
    );

    // return Container(
    //   margin: margin,
    //   clipBehavior: clipBehavior,
    //   decoration: BoxDecoration(
    //     color: Theme.of(context).primaryColor,
    //     borderRadius: borderRadius,
    //     boxShadow: <BoxShadow>[
    //       BoxShadow(
    //         color: Theme.of(context).dividerColor,
    //         blurRadius: 0.2,
    //         spreadRadius: 0.2,
    //         offset: const Offset(0, 0),
    //       ),
    //     ],
    //   ),
    //   child: child,
    // );
  }
}
