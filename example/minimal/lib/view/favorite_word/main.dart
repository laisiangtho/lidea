import 'package:flutter/material.dart';

// import 'package:lidea/icon.dart';
// import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';

import '../../app.dart';
import '/widget/button.dart';

part 'state.dart';
part 'header.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'favorite-word';
  static String label = 'Favorite';
  static IconData icon = Icons.loyalty;

  @override
  State<Main> createState() => _View();
}

class _View extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    debugPrint('favorite-word->build');

    return Scaffold(
      body: Views(
        scrollBottom: ScrollBottomNavigation(
          listener: _controller.bottom,
          notifier: App.viewData.bottom,
        ),
        child: ValueListenableBuilder(
          valueListenable: boxOfFavoriteWord.listen(),
          builder: (BuildContext _, Box<FavoriteWordType> __, Widget? ___) {
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
        heights: const [kToolbarHeight, kToolbarHeight],
        overlapsBackgroundColor: state.theme.primaryColor,
        overlapsBorderColor: state.theme.shadowColor,
        builder: _header,
      ),
      // listContainer(),
      ViewSection(
        show: boxOfFavoriteWord.isNotEmpty,
        onAwait: const ViewFeedback.await(),
        onEmpty: ViewFeedback.message(
          label: App.preference.text.recentSearchCount(0),
        ),
        child: ViewBlockCard.fill(
          child: listContainer(),
        ),
        // child: ViewBlockCard(
        //   clipBehavior: Clip.hardEdge,
        //   child: _recentBlock(items),
        // ),
      ),
    ];
  }

  Widget listContainer() {
    final items = boxOfFavoriteWord.entries.toList();
    items.sort((a, b) => b.value.date!.compareTo(a.value.date!));

    // final items = boxOfFavoriteWord.values.toList();
    // items.sort((a, b) => b.date!.compareTo(a.date!));

    return ViewListBuilder(
      primary: false,
      itemBuilder: (BuildContext context, int index) {
        return itemContainer(index, items.elementAt(index));
      },
      itemSnap: (BuildContext context, int index) {
        return const ListTile(
          leading: Icon(Icons.north_east_rounded),
        );
      },
      itemSeparator: (BuildContext context, int index) {
        return const ViewSectionDivider(
          primary: false,
        );
      },
      itemCount: items.length,
      duration: kThemeChangeDuration,
    );
  }

  Widget itemContainer(int index, MapEntry<dynamic, FavoriteWordType> item) {
    // final abc = App.core.scripturePrimary.bookById(bookmark.bookId);
    return Dismissible(
      // key: Key(index.toString()),
      key: Key(item.value.date.toString()),
      direction: DismissDirection.endToStart,
      background: dismissiblesFromRight(),

      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await onDelete(item.key);
        }
        return false;
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        title: Text(
          // history.value.word,
          item.value.word,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,

          style: Theme.of(context).textTheme.bodyMedium,
        ),
        minLeadingWidth: 10,
        leading: const Icon(Icons.bookmark_added),
        // trailing: Text(
        //   // App.core.scripturePrimary.digit(bookmark.chapterId),
        //   item.hit.toString(),
        //   style: const TextStyle(fontSize: 18),
        // ),
        onTap: () {
          onSearch(item.value.word);
        },
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
