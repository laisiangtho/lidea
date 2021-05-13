part of 'root.dart';

class ModelPage {
  ModelPage({
    this.key,
    this.name,
    this.icon,
    this.screenName,
    this.description,
    this.action
  });

  final int key;
  final String screenName;
  final String description;
  final String name;
  final IconData icon;
  final void Function(BuildContext context) action;
}

class ScrollPageBottom extends StatefulWidget {
  ScrollPageBottom({
    this.controller,
    this.items,
    // this.duration: const Duration(milliseconds: 400),
    this.builderDecoration,
    this.builderButton,
  });

  final ScrollController controller;
  final List<ModelPage> items;
  // final Duration duration;
  final Widget Function({Widget child}) builderDecoration;
  final Widget Function({int index, ModelPage item, bool current, bool route}) builderButton;

  @override
  _BottomBarAnimatedState createState() => _BottomBarAnimatedState();
}

class _BottomBarAnimatedState extends State<ScrollPageBottom> with TickerProviderStateMixin {
  ScrollController get controller => widget.controller;
  // Duration get animationDuration => widget.duration;
  double get height => controller.bottom.height;
  double heightCurrent(heightFactor) => (height*heightFactor).toDouble();
  // double heightCurrent(heightFactor) => (height*heightFactor).toDouble().clamp(5.0, height);
  int milliseconds(double heightFactor) => [0.0, 1.0].contains(heightFactor)?200:0;
  List<ModelPage> get items => widget.items;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.master.bottom.toggleNotify,
      builder: (BuildContext context, bool hide,Widget child) => hide?Container(height: 0):_height()
    );
  }

  Widget _height() {
    return ValueListenableBuilder<double>(
      valueListenable: controller.master.bottom.heightNotify,
      builder: container,
      child: _page(),
    );
  }

  ValueListenableBuilder<int> _page(){
    return ValueListenableBuilder<int>(
      valueListenable: controller.master.bottom.pageNotify,
      builder: _item,
    );
  }

  Widget _item(BuildContext context, int value,Widget child){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items.asMap().map(
        (index, item) => MapEntry(
          index, 
          widget.builderButton(
            index: item?.key,
            item: item,
            route: item.action == null,
            current: item.action == null && item?.key == value
          )
        )
      ).values.toList()
    );
  }

  Widget container(BuildContext context, double heightFactor,Widget children) {
    return AnimatedContainer(
      duration: Duration(milliseconds:milliseconds(heightFactor)),
      height: heightCurrent(heightFactor),
      child: widget.builderDecoration(
        child: children
      )
    );
  }
}
