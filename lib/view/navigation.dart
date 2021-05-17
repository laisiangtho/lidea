import 'package:flutter/material.dart';
import 'model.dart';
import 'notify.dart';

class ViewNavigation extends StatefulWidget {
  ViewNavigation({
    Key? key,
    required this.items,
    // required this.controller,
    // this.duration: const Duration(milliseconds: 400),
    required this.itemDecoration,
    required this.itemBuilder,
  }) : super(key: key);

  // final ScrollController controller;
  final List<ViewNavigationModel> items;
  // final Duration duration;
  final Widget Function({Widget child}) itemDecoration;
  final Widget Function({int? index, required ViewNavigationModel item, required bool current, required bool route}) itemBuilder;

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<ViewNavigation> with TickerProviderStateMixin {
  // ValueNotifier<int> get notify => ViewNotify.navigation;

  @override
  void initState() {
    super.initState();
    // notify.addListener(() {});
  }

  @override
  void dispose() {
    // notify.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return widget.itemDecoration(
      child: ValueListenableBuilder<int>(
        key: widget.key,
        valueListenable: ViewNotify.navigation,
        builder: _item
      )
    );
  }

  Widget _item(BuildContext context, int value,Widget? child){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: widget.items.asMap().map(
        (index, item) => MapEntry(
          index, 
          widget.itemBuilder(
            index: item.key,
            // index: index,
            item: item,
            route: item.action == null,
            current: item.action == null && item.key == value
          )
        )
      ).values.toList()
    );
  }
}
