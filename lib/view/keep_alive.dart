part of lidea.view;

class ViewKeepAlive extends StatefulWidget {
  const ViewKeepAlive({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  _KeepAliveState createState() => _KeepAliveState();
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
