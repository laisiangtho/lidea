part of lidea.widget;

// Grid
class WidgetGridBuilder extends StatelessWidget {
  final Widget Function(BuildContext, int) itemBuilder;
  final int itemCount;
  // final Widget? itemSnap;
  final Widget Function(BuildContext, int)? itemSnap;
  final Widget? itemVoid;
  final EdgeInsetsGeometry? padding;
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
    this.padding,
    this.primary,
    this.shrinkWrap = true,
    this.duration = Duration.zero,
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
      padding: padding ?? const EdgeInsets.fromLTRB(7, 3, 7, 5),
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
      padding: padding ?? const EdgeInsets.fromLTRB(7, 3, 7, 5),
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
  final Widget Function(BuildContext, int) itemBuilder;

  /// itemSeparator work only with NONE sliver
  /// ```dart
  /// return const Padding(
  ///   padding: EdgeInsets.symmetric(horizontal: 15),
  ///   child: Divider(height: 0, thickness: 1,),
  /// );
  /// ```
  final Widget Function(BuildContext, int)? itemSeparator;
  final int itemCount;
  final void Function(int, int)? itemReorderable;
  final Widget Function(BuildContext, int)? itemSnap;

  /// show when itemCount is zero
  final Widget? itemVoid;
  final EdgeInsetsGeometry padding;
  final Duration duration;
  final Axis scrollDirection;
  final ScrollController? scrollController;

  /// to disabled scroll
  /// ```dart
  /// const NeverScrollableScrollPhysics()
  /// ```
  final ScrollPhysics? physics;

  /// if primary is not provided sliver is use to render
  final bool? primary;
  final bool shrinkWrap;

  const WidgetListBuilder({
    Key? key,
    required this.itemBuilder,
    this.itemSeparator,
    required this.itemCount,
    this.itemReorderable,
    this.itemSnap,
    this.itemVoid,
    this.padding = EdgeInsets.zero,
    this.primary,
    this.shrinkWrap = true,
    this.duration = Duration.zero,
    this.scrollDirection = Axis.vertical,
    this.scrollController,
    this.physics,
  }) : super(key: key);

  bool get voided => itemCount == 0;
  bool get reorderable => itemReorderable != null;

  ScrollPhysics? get adjustedPhysics {
    return (physics == null && primary != null) ? const NeverScrollableScrollPhysics() : physics;
  }

  @override
  Widget build(BuildContext context) {
    if (primary == null) {
      return slivers(context);
    }

    return widgets(context);
  }

  Widget widgets(BuildContext context) {
    // if (voided && itemVoid != null) return SizedBox(child: itemVoid);
    if (voided && itemVoid != null) return itemVoid!;

    if (reorderable) {
      return Padding(
        padding: padding,
        child: ReorderableListView.builder(
          primary: primary,
          shrinkWrap: shrinkWrap,
          padding: EdgeInsets.zero,
          scrollDirection: scrollDirection,
          scrollController: scrollController,
          physics: adjustedPhysics,
          itemBuilder: builder,
          itemCount: itemCount,
          onReorder: itemReorderable!,
        ),
      );
    }
    if (itemSeparator != null) {
      return Padding(
        padding: padding,
        child: ListView.separated(
          primary: primary,
          shrinkWrap: shrinkWrap,
          padding: EdgeInsets.zero,
          scrollDirection: scrollDirection,
          controller: scrollController,
          physics: adjustedPhysics,
          itemBuilder: builder,
          separatorBuilder: itemSeparator!,
          itemCount: itemCount,
        ),
      );
    }

    return Padding(
      padding: padding,
      child: ListView.builder(
        primary: primary,
        shrinkWrap: shrinkWrap,
        padding: EdgeInsets.zero,
        scrollDirection: scrollDirection,
        controller: scrollController,
        physics: adjustedPhysics,
        itemBuilder: builder,
        itemCount: itemCount,
      ),
    );
  }

  Widget slivers(BuildContext context) {
    // if (voided) return SliverToBoxAdapter(child: itemVoid);
    if (voided && itemVoid != null) return itemVoid!;

    if (reorderable) {
      return SliverPadding(
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
        delegate: SliverChildBuilderDelegate(
          builder,
          childCount: itemCount,
        ),
      ),
    );
  }

  Widget builder(BuildContext context, int index) {
    return Material(
      type: MaterialType.card,
      color: Colors.transparent,
      key: ValueKey(index),
      child: FutureBuilder<bool>(
        future: Future.delayed(duration, () => true),
        // future: Future<bool>.microtask(() => true),
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

  /// placeHolder rendered when placeHolder NOT empty and show is FALSE
  final Widget? placeHolder;

  /// if primary is not provided sliver is use to render
  final bool? primary;

  /// if show is false not widget is render, therefore no space is taken
  final bool show;

  /// how long should the ui wait to be rendered
  final Duration duration;

  const WidgetChildBuilder({
    Key? key,
    this.padding = EdgeInsets.zero,
    this.child,
    this.placeHolder,
    this.primary,
    this.show = true,
    this.duration = Duration.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Future.delayed(duration, () => true),
      builder: (_, snap) {
        if (snap.hasData == false && placeHolder != null) {
          return placeHolder!;
        }
        if (primary == null) {
          return slivers();
        }
        return widgets();
      },
    );
  }

  Widget widgets() {
    return Padding(
      // key: key,
      padding: show ? padding : EdgeInsets.zero,
      child: showPlaceHolder ?? showChild,
    );
  }

  Widget slivers() {
    return SliverPadding(
      // key: key,
      padding: show ? padding : EdgeInsets.zero,
      sliver: showPlaceHolder ?? SliverToBoxAdapter(child: showChild),
    );
  }

  Widget? get showPlaceHolder {
    if (show == false && placeHolder != null) {
      return placeHolder;
    }
    return null;
  }

  Widget? get showChild {
    if (show == false) return null;
    return child;
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

