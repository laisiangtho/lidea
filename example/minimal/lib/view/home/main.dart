// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

import 'package:lidea/icon.dart';
// import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';

import '../../app.dart';
import '/widget/profile_icon.dart';
import '/widget/button.dart';

part 'state.dart';
part 'header.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  static String route = 'home';
  static String label = 'Home';
  static IconData icon = LideaIcon.flag;

  @override
  State<Main> createState() => _View();
}

class _View extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    debugPrint('home->build');

    return Scaffold(
      body: Views(
        scrollBottom: ScrollBottomNavigation(
          listener: _controller.bottom,
          notifier: App.viewData.bottom,
        ),

        // snap: _viewSnap,
        child: CustomScrollView(
          controller: _controller,
          slivers: _slivers,
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
      const PullToRefresh(),

      /// Favorite book
      ValueListenableBuilder(
        valueListenable: App.core.data.boxOfBooks.listen(),
        builder: bookList,
      ),

      /// Recent search
      ValueListenableBuilder(
        valueListenable: App.core.data.boxOfRecentSearch.listen(),
        builder: recentSearch,
      ),

      ViewSection(
        headerTitle: const Text('View section'),
        headerTrailing: ViewButton(
          onPressed: () {},
          child: const Icon(Icons.more_horiz),
        ),
        // footerTitle: const Text('View note'),
        child: ViewBlockCard(
          child: ListBody(
            children: [
              ViewButton(
                onPressed: () {},
                child: const Text('ViewButton'),
              ),
              const ViewButton(
                child: Text('ViewButton disable'),
              ),
            ],
          ),
        ),
      ),
      ViewSection(
        headerTitle: const Text('View section with fill'),
        child: ViewBlockCard.fill(
          child: ListBody(
            children: [
              ViewButton(
                onPressed: () {
                  doConfirmWithDialog(context: context, message: 'Confirm');
                },
                child: const Text('ViewButton'),
              ),
              const ViewButton(
                child: Text('ViewButton disable'),
              ),
            ],
          ),
        ),
      ),
      ViewSection(
        headerTitle: const Text('Search: home/search'),
        child: ViewBlockCard(
          child: ListBody(
            children: [
              ListTile(
                title: const Text('go to search (default)'),
                subtitle: const Text('same as bottom navigation'),
                onTap: () {
                  App.route.pushNamed('home/search');
                },
              ),
              ListTile(
                title: const Text('go to search and focus'),
                subtitle: const Text('ready to type'),
                onTap: () {
                  App.route.pushNamed('home/search', arguments: {'focus': true, 'keyword': 'love'});
                },
              ),
              ListTile(
                title: const Text('go to search (instantly)'),
                subtitle: const Text('get result (working)'),
                onTap: () {
                  App.route.pushNamed('home/search');
                },
              ),
            ],
          ),
        ),
      ),
      ViewSection(
        headerTitle: const Text('Swipe: home/bible'),
        child: ViewBlockCard(
          child: ListBody(
            children: [
              ListTile(
                title: const Text('go to bible (default)'),
                subtitle: const Text('same as more from home'),
                onTap: () {
                  App.route.pushNamed('home/bible');
                },
              ),
              ListTile(
                title: const Text('go to bible as coming from parallel'),
                subtitle: const Text('ready to select for parallel'),
                onTap: () {
                  App.route.pushNamed('home/bible', arguments: {'parallel': true});
                },
              ),
            ],
          ),
        ),
      ),
      ViewSection(
        headerTitle: const Text('???'),
        child: ViewBlockCard.fill(
          child: ListBody(
            children: [
              ViewButton(
                onPressed: () {
                  App.route.pushNamed('reader/user-profile-test-child');
                },
                child: const Text('reader/user-profile-test-child'),
              ),
              ViewButton(
                onPressed: () {
                  App.route.pushNamed('/user-profile-test-child');
                },
                child: const Text('/user-profile-test-child'),
              ),
              ViewButton(
                onPressed: () {
                  App.route.pushNamed('/reader');
                },
                child: const Text('/reader'),
              ),
              ViewButton(
                onPressed: () {
                  App.route.pushNamed('read/2');
                },
                child: const Text('read/2'),
              ),
              ViewButton(
                onPressed: () {
                  App.route.pushNamed('/read');
                },
                child: const Text('/read'),
              ),
              ViewButton(
                onPressed: () {
                  App.route.pushNamed('home/swipe');
                },
                child: const Text('home/swipe'),
              ),
            ],
          ),
        ),
      ),
      ViewSection(
        headerTitle: const Text('Sign in buttons'),
        child: Card(
          child: ListBody(
            children: [
              SignInButton(
                icon: Icons.abc,
                label: 'Sign in with Google',
                onPressed: () {},
              ),
              SignInButton(
                icon: Icons.abc,
                label: 'Sign in with Apple',
                onPressed: () {},
              ),
              SignInButton(
                icon: Icons.abc,
                label: 'Sign in with Facebook',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      ViewSection(
        headerTitle: const Text('ViewButton'),
        child: Card(
          child: ListBody(
            children: [
              ViewButton(
                color: Colors.red,
                onPressed: () {},
                child: const Text('ViewButton'),
              ),
              const ViewButton.filled(
                child: Text('ViewButton disable filled'),
              ),
              const ViewButton(
                child: Text('ViewButton disable'),
              ),
            ],
          ),
        ),
      ),
      ViewSection(
        headerTitle: const Text('route.showSheetModal'),
        child: Card(
          child: ListBody(
            children: [
              ListTile(
                title: const Text('route.showSheetModal sheet-modal'),
                onTap: () {
                  App.route.showSheetModal(context: context, name: 'sheet-modal');
                },
              ),
              ListTile(
                title: const Text('route.showSheetStack sheet-stack'),
                onTap: () {
                  App.route.showSheetStack(context: context, name: 'sheet-stack');
                },
              ),
            ],
          ),
        ),
      ),
      const ViewSectionDivider(),
      ViewSection(
        headerTitle: const Text('Go to'),
        child: Card(
          child: ListBody(
            children: [
              ListTile(
                title: const Text('Store'),
                subtitle: const Text('App.route.pushNamed(home/store)'),
                onTap: () {
                  App.route.pushNamed('home/store');
                },
              ),
              ListTile(
                title: const Text('Gallery'),
                subtitle: const Text('App.route.pushNamed(home/gallery)'),
                onTap: () {
                  App.route.pushNamed('home/gallery');
                },
              ),
              ListTile(
                title: const Text('Stage'),
                subtitle: const Text('App.route.pushNamed(stage)'),
                onTap: () {
                  App.route.pushNamed('stage');
                },
              ),
              ListTile(
                title: const Text('Read: 2'),
                subtitle: const Text('routes.pushNamed(/read/2)'),
                onTap: () {
                  App.route.pushNamed('/read/2');
                },
              ),
              ListTile(
                title: const Text('Read: 1'),
                subtitle: const Text('routes.pushNamed(read/1)'),
                onTap: () {
                  App.route.pushNamed('read/1');
                },
              ),
              ListTile(
                title: const Text('Other'),
                subtitle: const Text('routes.pushNamed(/other)'),
                onTap: () {
                  App.route.pushNamed('/other');
                },
              ),
              ListTile(
                title: const Text('a page thats not on current navigator'),
                subtitle: const Text('routes.pushNamed(name: /none)'),
                onTap: () {
                  App.route.pushNamed('/none');
                },
              ),
            ],
          ),
        ),
      ),
      ViewSection(
        headerTitle: const Text('Navigator.of(context)'),
        child: Card(
          child: ListBody(
            children: [
              ListTile(
                title: const Text('Go to a page thats not on current navigator, Non existent'),
                subtitle: const Text('Navigator.of(context).pushNamed(/none)'),
                onTap: () {
                  Navigator.of(context).pushNamed('/none');
                },
              ),
              ListTile(
                title: const Text('Go to Stage'),
                subtitle: const Text('Navigator.of(context).pushNamed(/stage)'),
                onTap: () {
                  Navigator.of(context).pushNamed('/stage');
                },
              ),
              ListTile(
                title: const Text('Go to Read: 2'),
                subtitle: const Text('Navigator.of(context).pushNamed(/read/2)'),
                onTap: () {
                  Navigator.of(context).pushNamed('/read/2');
                },
              ),
              ListTile(
                title: const Text('Go to Other'),
                subtitle: const Text('Navigator.of(context).pushNamed(/other)'),
                onTap: () {
                  Navigator.of(context).pushNamed('/other');
                },
              ),
              ListTile(
                title: const Text('Go to a page thats not on current navigator, Non existent'),
                subtitle: const Text('Navigator.of(context, rootNavigator: true).pushNamed(/none)'),
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pushNamed('/none');
                },
              ),
              ListTile(
                title: const Text('Go out of ButtomNavigation'),
                subtitle:
                    const Text('Navigator.of(context, rootNavigator: true).pushNamed(/other)'),
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pushNamed('/other');
                },
              ),
            ],
          ),
        ),
      ),
      ViewSection(
        headerTitle: const Text('Routes mapping check'),
        child: Card(
          child: ListBody(
            children: [
              ListTile(
                title: const Text('Call: empty'),
                subtitle: const Text('....'),
                onTap: () {
                  App.route.routeTest('');
                },
              ),
              ListTile(
                title: const Text('Just slash'),
                subtitle: const Text('/'),
                onTap: () {
                  App.route.routeTest('/');
                },
              ),
              ListTile(
                title: const Text('plan call home'),
                subtitle: const Text('/home'),
                onTap: () {
                  App.route.routeTest('/home');
                },
              ),
              ListTile(
                title: const Text('plan call reader'),
                subtitle: const Text('/reader'),
                onTap: () {
                  App.route.routeTest('/reader');
                },
              ),
              ListTile(
                title: const Text(':int call read'),
                subtitle: const Text('/read/2'),
                onTap: () {
                  App.route.routeTest('/read/2');
                },
              ),
              ListTile(
                title: const Text(':string call read'),
                subtitle: const Text('/read/other'),
                onTap: () {
                  App.route.routeTest('/read/other');
                },
              ),
            ],
          ),
        ),
      ),
      ViewSection(
        headerTitle: const Text('Routes mapping test'),
        child: Card(
          child: ListBody(
            children: [
              ListTile(
                title: const Text('Call: empty'),
                subtitle: const Text('....'),
                onTap: () {
                  // routeTest
                  App.route.routeTest('');
                },
              ),
              ListTile(
                title: const Text('Just slash'),
                subtitle: const Text('/'),
                onTap: () {
                  // routeTest
                  App.route.routeTest('/');
                },
              ),
              ListTile(
                title: const Text('plan call book'),
                subtitle: const Text('/book'),
                onTap: () {
                  // routeTest
                  App.route.routeTest('/book');
                },
              ),
              ListTile(
                title: const Text('Trailing with slash'),
                subtitle: const Text('/book/'),
                onTap: () {
                  App.route.routeTest('/book/');
                },
              ),
              ListTile(
                title: const Text(':int - Nonnumeric'),
                subtitle: const Text('/book/bookId'),
                onTap: () {
                  App.route.routeTest('/book/bookId');
                },
              ),
              ListTile(
                title: const Text('/book/sub: has sub page'),
                subtitle: const Text('/book/sub'),
                onTap: () {
                  App.route.routeTest('/book/sub');
                },
              ),
              ListTile(
                title: const Text(':int - Numeric'),
                subtitle: const Text('/book/3'),
                onTap: () {
                  App.route.routeTest('/book/3');
                },
              ),
              ListTile(
                title: const Text('Non existent'),
                subtitle: const Text('/book/none'),
                onTap: () {
                  App.route.routeTest('/book/none');
                },
              ),
              ListTile(
                title: const Text('plan call settings'),
                subtitle: const Text('/settings'),
                onTap: () {
                  App.route.routeTest('/settings');
                },
              ),
              ListTile(
                title: const Text('/settings/color: has sub'),
                subtitle: const Text('/settings/color'),
                onTap: () {
                  App.route.routeTest('/settings/color');
                },
              ),
              ListTile(
                title: const Text('Non existent'),
                subtitle: const Text('/settings/none'),
                onTap: () {
                  App.route.routeTest('/settings/none');
                },
              ),
              ListTile(
                title: const Text('plan call name'),
                subtitle: const Text('/name'),
                onTap: () {
                  App.route.routeTest('/name');
                },
              ),
              ListTile(
                title: const Text(':string - Non alphabetic'),
                subtitle: const Text('/name/454'),
                onTap: () {
                  App.route.routeTest('/name/454');
                },
              ),
              ListTile(
                title: const Text(':string - Alphabetic'),
                subtitle: const Text('/name/khen'),
                onTap: () {
                  App.route.routeTest('/name/khen');
                },
              ),
              ListTile(
                title: const Text('plan call blog'),
                subtitle: const Text('/blog'),
                onTap: () {
                  App.route.routeTest('/blog');
                },
              ),
              ListTile(
                title: const Text(':any - Anything using number'),
                subtitle: const Text('/blog/2'),
                onTap: () {
                  // routeTest
                  App.route.routeTest('/blog/2');
                },
              ),
              ListTile(
                title: const Text(':any - Anything using string'),
                subtitle: const Text('/blog/str'),
                onTap: () {
                  // routeTest
                  App.route.routeTest('/blog/str');
                },
              ),
            ],
          ),
        ),
      ),
    ];
  }

  Widget bookList(BuildContext context, Box<BooksType> box, Widget? child) {
    // final items = box.toMap().entries.toList();
    final items = box.values.where((e) => e.selected).toList();
    // items.sort((a, b) => a.value.order.compareTo(b.value.order));

    return ViewSection(
      headerLeading: const Icon(Icons.ac_unit),
      headerTitle: Text(App.preference.text.favorite('true')),
      // headerTitle: ViewMark(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   label: App.preference.text.favorite(true),
      // ),
      headerTrailing: ViewButton(
        show: items.isNotEmpty,
        message: App.preference.text.addTo(App.preference.text.favorite('true')),
        onPressed: () {
          App.route.pushNamed('home/bible');
        },
        child: const ViewMark(
          icon: Icons.more_horiz,
        ),
      ),
      footer: items.isNotEmpty,
      footerTitle: ViewButton(
        // padding: EdgeInsets.zero,
        // style: const TextStyle(
        //   color: Colors.red,
        //   fontSize: 12,
        // ),
        // color: Colors.red,
        onPressed: () {
          App.route.pushNamed('home/bible');
        },
        // child: ViewMark(
        //   label: App.preference.text.addMore(App.preference.text.favorite(true)),
        // ),
        child: Text(
          App.preference.text.addMore(App.preference.text.favorite('true')),
          textAlign: TextAlign.center,
        ),
      ),
      // footerTitle: Text(
      //   App.preference.text.addMore(App.preference.text.favorite(true)),
      //   textAlign: TextAlign.center,
      // ),
      // footerOnPressed: () {
      //   App.route.pushNamed('home/bible');
      // },

      child: ViewBlockCard(
        child: ViewListBuilder(
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return bookItem(
              index,
              items.elementAt(index),
            );
          },
          itemSeparator: (BuildContext context, int index) {
            return const ViewSectionDivider(
              primary: false,
            );
          },
          onEmpty: ViewButton(
            padding: const EdgeInsets.symmetric(vertical: 30),
            // child: ViewMark(
            //   label: App.preference.text.addTo(App.preference.text.favorite(true)),
            // ),
            child: Text(
              App.preference.text.addTo(App.preference.text.favorite('true')),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              App.route.pushNamed('home/bible');
            },
          ),
          itemCount: items.length,
        ),
      ),
    );
  }

  Widget bookItem(int index, BooksType book) {
    bool isAvailable = book.available > 0;
    bool isPrimary = book.identify == App.core.data.primaryId;
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          book.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          semanticsLabel: book.name,
          style: DefaultTextStyle.of(context).style.copyWith(
                fontSize: 20,
                fontWeight: isAvailable ? FontWeight.w400 : FontWeight.w300,
                // color: isAvailable?Colors.black:Colors.grey,
              ),
        ),
      ),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Container(
            constraints: const BoxConstraints(
              minWidth: 30.0,
            ),
            padding: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              color: isAvailable
                  ? isPrimary
                      ? Theme.of(context).highlightColor
                      : Theme.of(context).primaryColorDark
                  : Theme.of(context).disabledColor,
            ),
            child: Text(
              book.langCode.toUpperCase(),
              textAlign: TextAlign.center,
              style: DefaultTextStyle.of(context).style.copyWith(
                    fontSize: 12,
                    color: isAvailable ? Theme.of(context).primaryColor : null,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              book.shortname,
              style: DefaultTextStyle.of(context).style.copyWith(fontSize: 14),
            ),
          )
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            book.year.toString(),
            style: DefaultTextStyle.of(context).style.copyWith(
                  fontSize: 16,
                  color: isAvailable ? null : Theme.of(context).hintColor,
                ),
          ),
        ],
      ),
      // onTap: () => isAvailable ? showBible(book) : showMore(book),
      onTap: () {
        if (isAvailable) {
          showBibleContent(book);
        } else {
          showBibleInfo(book);
        }
      },
      onLongPress: () {
        showBibleInfo(book);
      },
    );
  }

  Widget recentSearch(BuildContext context, Box<RecentSearchType> box, Widget? child) {
    // return const SliverToBoxAdapter(
    //   child: Text('abc'),
    // );
    // items.sort((a, b) => b.value.date!.compareTo(a.value.date!));

    final items = box.values.toList();

    items.sort((a, b) => b.date!.compareTo(a.date!));

    return ViewSection(
      show: items.isNotEmpty,
      headerTitle: Text(
        App.preference.text.recentSearch('true'),
      ),
      headerTrailing: ViewButton(
        message: App.preference.text.addTo(App.preference.text.recentSearch('true')),
        onPressed: () {
          App.route.pushNamed('home/recent-search');
        },
        child: const ViewMark(
          icon: Icons.more_horiz,
        ),
      ),
      child: ViewBlockCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            textDirection: TextDirection.ltr,
            children: items.take(3).map(
              (e) {
                return ViewButton(
                  style: state.theme.textTheme.bodyLarge,
                  child: ViewMark(
                    // padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    label: e.word,
                  ),
                  // onPressed: () => onSearch(e.value.word),
                  onPressed: () {
                    App.route.pushNamed(
                      'home/search',
                      arguments: {'keyword': e.word},
                    );
                  },
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}

class PullToRefresh extends PullToActivate {
  const PullToRefresh({super.key});

  @override
  State<PullToActivate> createState() => _PullToRefreshState();
}

class _PullToRefreshState extends PullOfState {
  // late final Core core = context.read<Core>();
  @override
  Future<void> refreshUpdate() async {
    await Future.delayed(const Duration(milliseconds: 50));
    // await App.core.updateBookMeta();
    // await Future.delayed(const Duration(milliseconds: 100));
    // await App.core.data.updateToken();
    // await Future.delayed(const Duration(milliseconds: 400));
  }
}
