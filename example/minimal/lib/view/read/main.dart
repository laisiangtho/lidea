import 'package:flutter/material.dart';

import 'package:lidea/icon.dart';
// import 'package:lidea/provider.dart';
// import 'package:lidea/view/user/main.dart';

import '../../app.dart';
// import '/widget/profile_icon.dart';
// import '/widget/button.dart';

part 'state.dart';
part 'header.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  static String route = 'read';
  static String label = 'Read';
  static IconData icon = LideaIcon.bookOpen;

  @override
  State<Main> createState() => _View();
}

class _View extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    debugPrint('read->build');

    return Scaffold(
      body: Views(
        scrollBottom: ScrollBottomNavigation(
          listener: _controller.bottom,
          notifier: App.viewData.bottom,
          height: 120,
          pointer: 20,
        ),
        // scrollBottomNavigation: ScrollBottomNavigation()
        child: CustomScrollView(
          controller: _controller,
          slivers: _slivers,
        ),
      ),
      resizeToAvoidBottomInset: true,
      // extendBody: true,
      // bottomNavigationBar: const SheetStack(),
      bottomNavigationBar: App.route.show('sheet-parallel').child,

      // bottomSheet: App.route.show('sheet-parallel').child,
      // extendBody: true,
    );
  }

  List<Widget> get _slivers {
    return [
      ViewHeaderSliver(
        pinned: true,
        floating: false,
        padding: state.fromContext.viewPadding,
        heights: const [kToolbarHeight - 20, 20],
        // overlapsBackgroundColor: state.theme.primaryColor,
        overlapsBorderColor: state.theme.dividerColor,
        builder: _header,
      ),
      ViewFlatBuilder(
        child: ValueListenableBuilder<String>(
          valueListenable: App.core.message,
          builder: (_, message, child) {
            if (message.isEmpty) return child!;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(message),
              ),
            );
          },
          child: const SizedBox(),
        ),
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
        headerTitle: const Text('home'),
        headerTrailing: ViewButton(
          onPressed: () {
            App.route.pushNamed('home');
          },
          child: const Icon(Icons.more_horiz),
        ),
        // footerTitle: const Text('View note'),
        child: ViewBlockCard(
          child: ViewListBuilder(
            primary: false,
            // padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (_, index) {
              final abc = App.core.data.randomBool();
              return ListTile(
                minVerticalPadding: 20,
                selected: abc,
                selectedColor: Colors.red,
                leading: Text('$index'),
                title: Text('tmp $abc'),
                onTap: () {},
              );
            },
            itemSeparator: (_, index) {
              return const ViewSectionDivider(
                primary: false,
              );
            },
            itemCount: 30,
          ),
        ),
      ),
    ];
  }
}

// class PullToRefresh extends PullToActivate {
//   const PullToRefresh({Key? key}) : super(key: key);

//   @override
//   State<PullToActivate> createState() => _PullToRefreshState();
// }

// class _PullToRefreshState extends PullOfState {
//   // late final Core core = context.read<Core>();
//   @override
//   Future<void> refreshUpdate() async {
//     await Future.delayed(const Duration(milliseconds: 50));
//     // await core.updateBookMeta();
//     // await Future.delayed(const Duration(milliseconds: 100));
//     // await core.collection.updateToken();
//     // await Future.delayed(const Duration(milliseconds: 400));
//   }
// }
