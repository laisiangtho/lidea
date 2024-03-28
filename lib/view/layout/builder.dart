part of 'main.dart';

class ViewGridBuilder extends StatelessWidget {
  final Widget Function(BuildContext, int) itemBuilder;
  final int itemCount;
  // final Widget? itemSnap;
  final Widget Function(BuildContext, int)? itemSnap;
  final Widget? onEmpty;
  final EdgeInsetsGeometry? padding;
  final SliverGridDelegate gridDelegate;
  final Duration duration;

  ///const NeverScrollableScrollPhysics()
  final ScrollPhysics? physics;
  final ScrollController? scrollController;

  /// if primary is not provided sliver is use to render
  final bool? primary;
  final bool shrinkWrap;

  const ViewGridBuilder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.itemSnap,
    this.onEmpty,
    this.padding,
    this.primary,
    this.shrinkWrap = true,
    this.duration = Duration.zero,
    this.physics = const NeverScrollableScrollPhysics(),
    this.scrollController,
    required this.gridDelegate,
  });

  bool get voided => itemCount == 0;

  @override
  Widget build(BuildContext context) {
    if (primary == null) {
      return slivers(context);
    }

    return widgets(context);
  }

  Widget widgets(BuildContext context) {
    if (voided) return SizedBox(child: onEmpty);
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
    if (voided) return SliverToBoxAdapter(child: onEmpty);
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
class ViewListBuilder extends StatelessWidget {
  final Widget Function(BuildContext, int) itemBuilder;

  /// itemSeparator for None Sliver
  /// ```dart
  /// return const ViewSectionDivider(primary: false);
  /// ```
  /// itemSeparator for Sliver
  /// ```dart
  /// return const ViewSectionDivider();
  /// ```
  /// itemSeparator custom
  /// ```dart
  /// return const Padding(
  ///   padding: EdgeInsets.symmetric(horizontal: 15),
  ///   child: Divider(height: 0, thickness: 1,),
  /// );
  /// ```
  final Widget Function(BuildContext, int)? itemSeparator;
  final int itemCount;

  /// if items are reorderable, should provide the sorting method
  final void Function(int, int)? itemReorderable;

  /// snapshot for each item
  final Widget Function(BuildContext, int)? itemSnap;

  /// show when itemCount is empty
  final Widget? onEmpty;
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

  const ViewListBuilder({
    super.key,
    required this.itemBuilder,
    this.itemSeparator,
    required this.itemCount,
    this.itemReorderable,
    this.itemSnap,
    this.onEmpty,
    this.padding = EdgeInsets.zero,
    this.primary,
    this.shrinkWrap = true,
    this.duration = Duration.zero,
    this.scrollDirection = Axis.vertical,
    this.scrollController,
    this.physics,
  });

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
    // if (voided && onEmpty != null) return SizedBox(child: onEmpty);
    if (voided && onEmpty != null) return onEmpty!;

    if (reorderable) {
      return Padding(
        padding: padding,
        child: ReorderableListView.builder(
          primary: primary,
          shrinkWrap: shrinkWrap,
          padding: EdgeInsets.zero,
          // scrollDirection: scrollDirection,
          scrollController: scrollController,
          // buildDefaultDragHandles: false,
          physics: adjustedPhysics,
          itemBuilder: builder,
          itemCount: itemCount,
          onReorder: itemReorderable!,
          proxyDecorator: (Widget child, int index, Animation<double> animation) {
            return AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return Material(
                  elevation: 2,
                  // color: Colors.transparent,
                  // shadowColor: Colors.transparent,
                  shadowColor: Theme.of(context).shadowColor.withOpacity(0.2),
                  child: child,
                );
              },
              child: child,
            );
          },
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
    // if (voided) return SliverToBoxAdapter(child: onEmpty);
    if (voided && onEmpty != null) return onEmpty!;

    if (reorderable) {
      return SliverPadding(
        padding: padding,
        sliver: SliverReorderableList(
          itemBuilder: builder,
          itemCount: itemCount,
          onReorder: itemReorderable!,
          proxyDecorator: (Widget child, int index, Animation<double> animation) {
            return AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return Material(
                  elevation: 0,
                  color: Colors.transparent,
                  child: child,
                );
              },
              child: child,
            );
          },
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
    // return Material(
    //   type: MaterialType.transparency,
    //   // color: Colors.transparent,
    //   shadowColor: Colors.transparent,
    //   key: ValueKey(index),
    //   child: FutureBuilder<bool>(
    //     future: Future.delayed(duration, () => true),
    //     // future: Future<bool>.microtask(() => true),
    //     builder: (_, snap) {
    //       if (snap.hasData == false && itemSnap != null) {
    //         return itemSnap!(context, index);
    //       }
    //       return itemBuilder(context, index);
    //     },
    //   ),
    // );
    return FutureBuilder<bool>(
      key: ValueKey(index),
      future: Future.delayed(duration, () => true),
      // future: Future<bool>.microtask(() => true),
      builder: (_, snap) {
        if (snap.hasData == false && itemSnap != null) {
          return itemSnap!(context, index);
        }
        return itemBuilder(context, index);
      },
    );
  }
}

// Child -> Flat use in almost everywhere
class ViewFlatBuilder extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final Widget? child;

  /// onAwait rendered when onAwait NOT empty and show is FALSE
  final Widget? onAwait;

  /// if primary is not provided sliver is use to render
  final bool? primary;

  /// if show is false not widget is render, therefore no space is taken
  final bool show;

  /// how long should the ui wait to be rendered
  final Duration duration;

  const ViewFlatBuilder({
    super.key,
    this.padding,
    this.child,
    this.onAwait,
    this.primary,
    this.show = true,
    this.duration = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Future.delayed(duration, () => true),
      builder: (_, snap) {
        if (snap.hasData == false && onAwait != null) {
          return onAwait!;
        }
        if (primary == null) {
          return _slivers();
        }
        return _widgets();
      },
    );
  }

  Widget _widgets() {
    return Padding(
      // key: key,
      padding: show && padding != null ? padding! : EdgeInsets.zero,
      child: _showPlaceHolder ?? _showChild,
    );
  }

  Widget _slivers() {
    return SliverPadding(
      // key: key,
      padding: show && padding != null ? padding! : EdgeInsets.zero,
      sliver: _showPlaceHolder ?? SliverToBoxAdapter(child: _showChild),
    );
  }

  Widget? get _showPlaceHolder {
    if (show == false && onAwait != null) {
      return onAwait;
    }
    return null;
  }

  Widget? get _showChild {
    if (show == false) return null;
    return child;
  }
}
