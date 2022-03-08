part of 'main.dart';

// Grid
class WidgetGridBuilder extends StatelessWidget {
  final Widget Function(BuildContext, int) itemBuilder;
  final int itemCount;
  // final Widget? itemSnap;
  final Widget Function(BuildContext, int)? itemSnap;
  final Widget? itemVoid;
  final EdgeInsetsGeometry padding;
  final SliverGridDelegate gridDelegate;
  final Duration duration;

  ///const NeverScrollableScrollPhysics()
  final ScrollPhysics? physics;
  final ScrollController? scrollController;

  /// if primary is not provided sliver is use to render
  final bool? primary;
  final bool shrinkWrap;

  const WidgetGridBuilder({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    this.itemSnap,
    this.itemVoid,
    this.padding = EdgeInsets.zero,
    this.primary,
    this.shrinkWrap = false,
    this.duration = const Duration(milliseconds: 0),
    this.physics = const NeverScrollableScrollPhysics(),
    this.scrollController,
    required this.gridDelegate,
  }) : super(key: key);

  bool get voided => itemCount == 0;

  @override
  Widget build(BuildContext context) {
    if (primary == null) {
      return slivers(context);
    }

    return widgets(context);
  }

  Widget widgets(BuildContext context) {
    if (voided) return SizedBox(child: itemVoid);
    return Padding(
      padding: padding,
      child: GridView.builder(
        key: key,
        primary: primary,
        shrinkWrap: shrinkWrap,
        padding: EdgeInsets.zero,
        physics: physics,
        controller: scrollController,
        gridDelegate: gridDelegate,
        itemBuilder: builder,
        itemCount: itemCount,
        semanticChildCount: 300,
      ),
    );
  }

  Widget slivers(BuildContext context) {
    if (voided) return SliverToBoxAdapter(child: itemVoid);
    return SliverPadding(
      key: key,
      padding: padding,
      sliver: SliverGrid(
        gridDelegate: gridDelegate,
        delegate: SliverChildBuilderDelegate(
          builder,
          childCount: itemCount,
          // semanticIndexOffset: 300
        ),
      ),
    );
  }

  Widget builder(BuildContext context, int index) {
    return Material(
      key: ValueKey(key),
      child: FutureBuilder(
        // future: Future.microtask(() => true),
        future: Future.delayed(duration, () => true),
        builder: (_, snap) {
          if (snap.hasData == false && itemSnap != null) {
            return itemSnap!(context, index);
          }
          return itemBuilder(context, index);
        },
      ),
    );
  }
}

// List
class WidgetListBuilder extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final void Function(int, int)? itemReorderable;
  final Widget Function(BuildContext, int)? itemSnap;
  final Widget? itemVoid;
  final EdgeInsetsGeometry padding;
  final Duration duration;
  final Axis scrollDirection;
  final ScrollController? scrollController;

  ///const NeverScrollableScrollPhysics()
  final ScrollPhysics? physics;

  /// if primary is not provided sliver is use to render
  final bool? primary;
  final bool shrinkWrap;

  const WidgetListBuilder({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    this.itemReorderable,
    this.itemSnap,
    this.itemVoid,
    this.padding = EdgeInsets.zero,
    this.primary,
    this.shrinkWrap = false,
    this.duration = const Duration(milliseconds: 0),
    this.scrollDirection = Axis.vertical,
    this.scrollController,
    this.physics,
  }) : super(key: key);

  bool get voided => itemCount == 0;
  bool get reorderable => itemReorderable != null;

  @override
  Widget build(BuildContext context) {
    if (primary == null) {
      return slivers(context);
    }

    return widgets(context);
  }

  Widget widgets(BuildContext context) {
    if (voided) return SizedBox(child: itemVoid);

    if (reorderable) {
      return Padding(
        key: key,
        padding: padding,
        child: ReorderableListView.builder(
          primary: primary,
          shrinkWrap: shrinkWrap,
          padding: EdgeInsets.zero,
          scrollDirection: scrollDirection,
          scrollController: scrollController,
          physics: physics,
          itemBuilder: builder,
          itemCount: itemCount,
          onReorder: itemReorderable!,
        ),
      );
    }

    return Padding(
      padding: padding,
      child: ListView.builder(
        key: key,
        primary: primary,
        shrinkWrap: shrinkWrap,
        padding: EdgeInsets.zero,
        scrollDirection: scrollDirection,
        controller: scrollController,
        physics: physics,
        itemBuilder: builder,
        itemCount: itemCount,
      ),
    );
  }

  Widget slivers(BuildContext context) {
    if (voided) return SliverToBoxAdapter(child: itemVoid);

    if (reorderable) {
      return SliverPadding(
        key: key,
        padding: padding,
        sliver: SliverReorderableList(
          itemBuilder: builder,
          itemCount: itemCount,
          onReorder: itemReorderable!,
        ),
      );
    }

    return SliverPadding(
      padding: padding,
      sliver: SliverList(
        key: key,
        delegate: SliverChildBuilderDelegate(
          builder,
          childCount: itemCount,
        ),
      ),
    );
  }

  Widget builder(BuildContext context, int index) {
    return Material(
      key: ValueKey(key),
      child: FutureBuilder<bool>(
        // future: Future.delayed(duration, () => true),
        future: Future<bool>.microtask(() => true),
        builder: (_, snap) {
          if (snap.hasData == false && itemSnap != null) {
            return itemSnap!(context, index);
          }
          return itemBuilder(context, index);
        },
      ),
    );
  }
}

// Child
class WidgetChildBuilder extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Widget? child;

  /// if primary is not provided sliver is use to render
  final bool? primary;

  final bool show;

  // final bool shrinkWrap;

  const WidgetChildBuilder({
    Key? key,
    this.child,
    this.padding = EdgeInsets.zero,
    this.primary,
    // this.shrinkWrap = false,
    this.show = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (primary == null) {
      return slivers();
    }

    return widgets();
  }

  Widget widgets() {
    return Padding(
      key: key,
      padding: padding,
      child: show ? child : null,
    );
  }

  Widget slivers() {
    return SliverPadding(
      key: key,
      padding: padding,
      sliver: SliverToBoxAdapter(
        child: show ? child : null,
      ),
    );
  }
}

// class SliverTesting extends SingleChildRenderObjectWidget {
//   const SliverTesting({
//     Key? key,
//     required this.padding,
//     Widget? sliver,
//   }) : super(key: key, child: sliver);

//   /// The amount of space by which to inset the child sliver.
//   final EdgeInsetsGeometry padding;

//   @override
//   RenderSliverPadding createRenderObject(BuildContext context) {
//     return RenderSliverPadding(
//       padding: padding,
//       textDirection: Directionality.of(context),
//     );
//   }
// }

// class SliverTesting extends SingleChildRenderObjectWidget {
//   const SliverTesting({
//     Key? key,
//     required this.padding,
//     Widget? sliver,
//   }) : super(key: key, child: sliver);

//   /// The amount of space by which to inset the child sliver.
//   final EdgeInsetsGeometry padding;

//   // RenderBox RenderSliver
//   @override
//   RenderSliverPadding createRenderObject(BuildContext context) {
//     return RenderSliverPadding(
//       padding: padding,
//       textDirection: Directionality.of(context),
//     );
//   }


//   // RenderPadding createRenderObject(BuildContext context) {
//   //   return RenderPadding(
//   //     padding: padding,
//   //     textDirection: Directionality.maybeOf(context),
//   //   );
//   // }

// }

// class SliverBlock extends SliverMultiBoxAdaptorWidget {
//   /// Creates a sliver that places box children in a linear array.
//   const SliverBlock({
//     Key? key,
//     required SliverChildDelegate delegate,
//   }) : super(key: key, delegate: delegate);

//   @override
//   SliverMultiBoxAdaptorElement createElement() =>
//       SliverMultiBoxAdaptorElement(this, replaceMovedChildren: true);

//   @override
//   RenderSliverList createRenderObject(BuildContext context) {
//     final SliverMultiBoxAdaptorElement element = context as SliverMultiBoxAdaptorElement;
//     return RenderSliverList(childManager: element);
//   }
// }

