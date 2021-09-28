import 'package:flutter/material.dart';

class WidgetKeepAlive extends StatefulWidget {
  const WidgetKeepAlive({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  _KeepAliveState createState() => _KeepAliveState();
}

class _KeepAliveState extends State<WidgetKeepAlive> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
