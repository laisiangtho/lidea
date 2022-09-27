part of 'main.dart';

abstract class _State extends StateAbstract<Main> {
  late final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  Future showFilter() {
    return App.route.showSheetModal(context: context, name: 'sheet-filter');
  }
}
