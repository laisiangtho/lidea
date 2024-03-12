// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

// class _MainState extends State<Main> {
// class _View extends _State with _Header {}
// abstract class _State extends StateAbstract {}
// mixin _Header on _State {}
// abstract class WidgetState<T extends StatefulWidget> extends State<T> {}

class ViewKeepAlive extends StatefulWidget {
  const ViewKeepAlive({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  State<ViewKeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<ViewKeepAlive> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
