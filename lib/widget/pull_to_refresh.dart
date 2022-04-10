part of lidea.widget;

// PullForAction PullForTask PullToRefreshState Pull
class PullToAny extends StatefulWidget {
  /// refreshTriggerPullDistance  = 100
  final double? distance;

  /// refreshIndicatorExtent = 70
  final double? extent;

  final Future<void> Function()? onUpdate;

  const PullToAny({
    Key? key,
    this.distance,
    this.extent,
    this.onUpdate,
  }) : super(key: key);

  @override
  State<PullToAny> createState() => PullOfState();
}

class PullOfState<T extends StatefulWidget> extends State<PullToAny> {
  String _message = '';
  @override
  Widget build(BuildContext context) {
    return CupertinoSliverRefreshControl(
      refreshTriggerPullDistance: widget.distance ?? 100,
      refreshIndicatorExtent: widget.extent ?? 70,
      builder: (
        BuildContext _,
        RefreshIndicatorMode mode,
        pulledExtent,
        triggerPullDistance,
        indicatorExtent,
      ) {
        final double percentage = (pulledExtent / triggerPullDistance); //.clamp(0.0, 1.0);
        return Center(
          child: _refreshMode(mode, percentage),
        );
      },
      onRefresh: refreshTrigger,
    );
  }

  Future<void> refreshTrigger() async {
    await (widget.onUpdate ?? refreshUpdate).call().catchError((e) {
      _message = e;
    });
  }

  Future<void> refreshUpdate() async {
    return Future.delayed(Duration.zero, () {
      // throw Exception('Mocking update');
      // return Future.error('Mocking update');
    });
  }

  Widget? _refreshMode(RefreshIndicatorMode mode, double percentage) {
    switch (mode) {
      case RefreshIndicatorMode.drag:
        // While we're dragging, we draw individual ticks of the spinner while simultaneously
        // easing the opacity in. Note that the opacity curve values here were derived using
        // Xcode through inspecting a native app running on iOS 13.5.
        // const Curve opacityCurve = Interval(0.0, 0.35, curve: Curves.easeInOut);
        // return Opacity(
        //   // opacity: opacityCurve.transform(percentageComplete),
        //   opacity: percentageComplete.clamp(0.3, 1.0),
        //   // child: CupertinoActivityIndicator.partiallyRevealed(radius: radius, progress: percentageComplete),
        //   child: _refreshAnimation(percentageComplete,1.0)
        // );
        return _refreshIndicator(percentage, percentage);
      case RefreshIndicatorMode.armed:
      case RefreshIndicatorMode.refresh:
        // Once we're armed or performing the refresh, we just show the normal spinner.
        // return CupertinoActivityIndicator(radius: radius);
        return _refreshIndicator(percentage, null);
      case RefreshIndicatorMode.done:
        // When the user lets go, the standard transition is to shrink the spinner.
        // return CupertinoActivityIndicator(radius: radius * percentageComplete);
        return _refreshIndicator(percentage, null);
      case RefreshIndicatorMode.inactive:
        // Anything else doesn't show anything.
        _message = '';
        return null;
    }
  }

  Widget refreshPercentage(double? percentage) {
    // if (percentage == null) {
    //   return const CupertinoActivityIndicator();
    // }
    // return CupertinoActivityIndicator.partiallyRevealed(
    //   progress: percentage,
    // );
    return CircularProgressIndicator(
      value: percentage,
      strokeWidth: 2.0,
      semanticsLabel: 'Percentage',
      semanticsValue: percentage.toString(),
    );
  }

  Widget _refreshIndicator(double percentage, double? value) {
    if (_message.isNotEmpty) {
      return Text(
        _message,
        style: TextStyle(
          color: Theme.of(context).errorColor,
          fontWeight: FontWeight.w300,
          fontSize: DefaultTextStyle.of(context).style.fontSize! * percentage,
        ),
      );
    }
    final size = (40 * percentage).clamp(10, 40).toDouble();
    return SizedBox(
      height: size,
      width: size,
      child: refreshPercentage(value),
    );
  }
}
