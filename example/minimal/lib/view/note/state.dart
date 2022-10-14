part of 'main.dart';

abstract class _State extends StateAbstract<Main> {
  late final ScrollController _controller = ScrollController();

  late final boxOfBookmarks = App.core.data.boxOfBookmarks;

  @override
  void initState() {
    super.initState();
  }

  void onDeleteAllConfirmWithDialog() {
    doConfirmWithDialog(
      context: context,
      message: App.preference.text.confirmToDelete('all'),
      title: App.preference.text.confirmation,
      cancel: App.preference.text.cancel,
      confirm: App.preference.text.confirm,
    ).then((bool? confirmation) {
      // if (confirmation != null && confirmation) onClearAll();
      if (confirmation != null && confirmation) {
        Future.microtask(() {
          // collection.boxOfBookmark.clear().whenComplete(core.notify);
          // App.core.clearBookmarkWithNotify();
          boxOfBookmarks.clearAll();
        });
      }
    });
  }

  Future<bool?> onDelete(dynamic key) {
    return boxOfBookmarks.deleteAtKey(key);
  }
}
