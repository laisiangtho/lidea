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
  final Widget Function({required BuildContext context, Widget child}) itemDecoration;
  
  final Widget Function({required BuildContext context, required int index, required ViewNavigationModel item, required bool disabled, required bool route}) itemBuilder;

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<ViewNavigation> with TickerProviderStateMixin {
  // ValueNotifier<int> get notify => NotifyNavigationButton.navigation;

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
      context: context,
      child: ValueListenableBuilder<int>(
        key: widget.key,
        valueListenable: NotifyNavigationButton.navigation,
        builder: _item
      )
    );
  }

  Widget _item(BuildContext context, int value,Widget? child){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widget.items.asMap().map(
        (index, item) => MapEntry(
          index, 
          widget.itemBuilder(
            context: context,
            // index: item.key,
            index: index,
            item: item,
            route: item.action == null,
            disabled: item.action == null && item.key == value
          )
        )
      ).values.toList()
    );
  }
}
