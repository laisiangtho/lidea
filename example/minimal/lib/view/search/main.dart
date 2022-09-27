import 'package:flutter/material.dart';

import 'package:lidea/icon.dart';
import 'package:lidea/provider.dart';
// import 'package:lidea/view/user/main.dart';

import '../../app.dart';

part 'state.dart';
part 'header.dart';
part 'recent.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  static String route = 'search'; // ./result ./suggestion
  static String label = 'Search';
  static IconData icon = LideaIcon.search;

  @override
  State<Main> createState() => _View();
}

class _View extends _State with _Header, _Recent {
  @override
  Widget build(BuildContext context) {
    debugPrint('search->build');

    return Scaffold(
      body: Views(
        scrollBottom: ScrollBottomNavigation(
          listener: _controller.bottom,
          notifier: App.view.bottom,
        ),
        child: NestedScrollView(
          controller: _controller,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              ViewHeaderSliver(
                pinned: true,
                floating: false,
                padding: state.fromContext.viewPadding,
                heights: const [kToolbarHeight],
                // overlapsBackgroundColor: state.theme.primaryColor,
                overlapsBorderColor: state.theme.dividerColor,
                overlapsForce: innerBoxIsScrolled,
                builder: _header,
              ),
            ];
          },
          body: ValueListenableBuilder<bool>(
            valueListenable: _focusNotifier,
            builder: (context, toggle, child) {
              if (toggle) {
                return suggest();
              }
              return child!;
            },
            child: result(),
          ),
        ),
      ),
    );
  }

  Widget message(String msg) {
    return SliverFillRemaining(
      hasScrollBody: false,
      fillOverscroll: true,
      child: Center(
        child: Text(msg),
      ),
    );
  }

  Widget suggest() {
    return CustomScrollView(
      primary: true,
      slivers: [
        Selector<Core, SuggestionType>(
          selector: (_, e) => e.cacheSuggestion,
          builder: (BuildContext context, SuggestionType o, Widget? child) {
            if (o.emptyQuery) {
              return suggestRecent();
            } else if (o.emptyResult) {
              return child!;
            } else {
              return suggests(o);
            }

            // return suggests(o);
          },
          child: message(App.preference.text.searchNoMatch),
        ),
      ],
    );
  }

  Widget suggestRecent() {
    return Selector<Core, Iterable<MapEntry<dynamic, RecentSearchType>>>(
      selector: (_, e) => e.data.boxOfRecentSearch.entries,
      builder: (BuildContext _, Iterable<MapEntry<dynamic, RecentSearchType>> items, Widget? __) {
        return ViewSection(
          show: items.isNotEmpty,
          // duration: const Duration(milliseconds: 270),
          headerTitle: ViewLabel(
            alignment: Alignment.centerLeft,
            label: App.preference.text.recentSearch(items.length > 1),
          ),
          placeHolder: message(App.preference.text.aWordOrTwo),
          // child: Padding(
          //   padding: const EdgeInsets.fromLTRB(0, 3, 0, 5),
          //   child: Material(
          //     type: MaterialType.card,
          //     color: Theme.of(context).primaryColor,
          //     shape: RoundedRectangleBorder(
          //       side: BorderSide(
          //         color: Theme.of(context).shadowColor,
          //         width: 0.5,
          //       ),
          //     ),
          //     child: _recentBlock(items),
          //   ),
          // ),
          // child: Card(
          //   // clipBehavior: Clip.hardEdge,
          //   child: _recentBlock(items),
          // ),
          child: ViewBlockCard.fill(
            child: _recentBlock(items),
          ),
          // child: ViewBlockCard(
          //   clipBehavior: Clip.hardEdge,
          //   child: _recentBlock(items),
          // ),
        );
      },
    );
  }

  Widget suggests(SuggestionType o) {
    return ViewSection(
      headerTitle: const Text('Suggest ???'),
      headerTrailing: ViewButton(
        onPressed: () {},
        child: const Icon(Icons.more_horiz),
      ),
      footerTitle: Text('hasFocus ${_focusNode.hasFocus}'),
      child: ViewBlockCard(
        child: ListBody(
          children: [
            ViewButton(
              onPressed: () {},
              child: const Text('ViewButton'),
            ),
            ViewButton(
              child: Text(o.query),
            ),
          ],
        ),
      ),
    );
  }

  Widget result() {
    return CustomScrollView(
      primary: true,
      slivers: [
        Selector<Core, ConclusionType>(
          selector: (_, e) => e.cacheConclusion,
          builder: (BuildContext context, ConclusionType o, Widget? child) {
            if (o.emptyQuery) {
              return resultNoQuery();
            } else if (o.emptyResult) {
              return child!;
            } else {
              return results();
            }
          },
          child: message(App.preference.text.searchNoMatch),
        ),
      ],
    );
  }

  Widget resultNoQuery() {
    return ViewSection(
      headerTitle: const Text('Result no query'),
      headerTrailing: ViewButton(
        onPressed: () {},
        child: const Icon(Icons.more_horiz),
      ),
      footerTitle: Text('hasFocus ${_focusNode.hasFocus}'),
      child: ViewBlockCard(
        child: ListBody(
          children: [
            ViewButton(
              onPressed: () {},
              child: const Text('ViewButton'),
            ),
            ViewButton(
              child: Text(suggestQuery),
            ),
          ],
        ),
      ),
    );
  }

  Widget results() {
    return ViewSection(
      headerTitle: const Text('Result ???'),
      headerTrailing: ViewButton(
        onPressed: () {},
        child: const Icon(Icons.more_horiz),
      ),
      footerTitle: Text('hasFocus ${_focusNode.hasFocus}'),
      child: ViewBlockCard(
        child: ListBody(
          children: [
            ViewButton(
              onPressed: () {},
              child: const Text('ViewButton'),
            ),
            ViewButton(
              child: Text(suggestQuery),
            ),
          ],
        ),
      ),
    );
  }
}
