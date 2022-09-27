import 'package:flutter/material.dart';

import 'package:lidea/icon.dart';
// import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';

import '../../app.dart';
import '/widget/button.dart';

part 'state.dart';
part 'header.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  static String route = 'note';
  static String label = 'Note';
  static IconData icon = LideaIcon.listNested;

  @override
  State<Main> createState() => _View();
}

class _View extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    debugPrint('note->build');

    return Scaffold(
      body: Views(
        scrollBottom: ScrollBottomNavigation(
          listener: _controller.bottom,
          notifier: App.view.bottom,
        ),
        // child: CustomScrollView(
        //   controller: _controller,
        //   slivers: _slivers,
        // ),
        child: ValueListenableBuilder(
          valueListenable: boxOfBookmarks.listen(),
          builder: (BuildContext _, Box<BookmarksType> __, Widget? ___) {
            return CustomScrollView(
              controller: _controller,
              slivers: _slivers,
            );
          },
        ),
      ),
    );
  }

  List<Widget> get _slivers {
    return [
      ViewHeaderSliver(
        pinned: true,
        floating: false,
        padding: state.fromContext.viewPadding,
        heights: const [kToolbarHeight, 100],
        // overlapsBackgroundColor: state.theme.primaryColor,
        overlapsBorderColor: state.theme.dividerColor,
        builder: _header,
      ),
      listContainer(),
    ];
  }

  Widget listContainer() {
    final items = boxOfBookmarks.values.toList();
    // items.sort((a, b) => b.date!.compareTo(a.date!));
    return ViewListBuilder(
      itemBuilder: (BuildContext context, int index) {
        return itemContainer(index, items.elementAt(index));
      },
      itemCount: items.length,
      itemVoid: SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(App.preference.text.bookmarkCount(0)),
        ),
      ),
      itemReorderable: boxOfBookmarks.reorderable,
    );
  }

  Widget itemContainer(int index, BookmarksType item) {
    // final abc = App.core.scripturePrimary.bookById(bookmark.bookId);
    return Dismissible(
      // key: Key(index.toString()),
      key: Key(item.date.toString()),
      direction: DismissDirection.endToStart,
      background: dismissiblesFromRight(),

      confirmDismiss: (direction) async {
        // if (direction == DismissDirection.endToStart) {
        //   return await onDelete(index);
        // } else {
        //   // Navigate to edit page;
        // }
        return null;
      },
      child: ListTile(
        // contentPadding: EdgeInsets.zero,
        title: Text(
          // history.value.word,
          'abc.name',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,

          style: Theme.of(context).textTheme.bodyMedium,
        ),
        minLeadingWidth: 10,
        leading: const Icon(Icons.bookmark_added),

        trailing: const Text(
          // App.core.scripturePrimary.digit(bookmark.chapterId),
          'chapterId',
          style: TextStyle(fontSize: 18),
        ),
        // onTap: () => onNav(
        //   bookmark.bookId,
        //   bookmark.chapterId,
        // ),
      ),
    );
  }

  Widget dismissiblesFromRight() {
    return Container(
      color: Theme.of(context).disabledColor,
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Text(
          App.preference.text.delete,
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
