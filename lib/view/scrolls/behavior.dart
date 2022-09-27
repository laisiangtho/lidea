part of view.scrolls;

class ScrollsBehavior extends ScrollBehavior {
  const ScrollsBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // switch (getPlatform(context)) {
    //   case TargetPlatform.iOS:
    //   case TargetPlatform.macOS:
    //   case TargetPlatform.android:
    //     // return const BouncingScrollPhysics();
    //     return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
    //   case TargetPlatform.fuchsia:
    //   case TargetPlatform.linux:
    //   case TargetPlatform.windows:
    //     return const ClampingScrollPhysics();
    // }
    return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  }

  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
