part of 'main.dart';

// abstract class _State extends State<Main> {
abstract class _State extends StateAbstract<Main> {
  late final ScrollController _controller = ScrollController();
  // late final Future<void> _viewSnap = Future.delayed(const Duration(milliseconds: 1000));
  // late AppScrollBottomBarController _bottomBarController;

  final _kBookmarks = GlobalKey();
  final _kBooks = GlobalKey();
  final _kChapters = GlobalKey();
  final _kOptions = GlobalKey();

  // RouteNotifier get routes => App.route;

  // @override
  // void initState() {
  //   super.initState();
  //   // _controller = ScrollController();
  //   // _bottomBarController = AppScrollBottomBarController();
  //   // _viewSnap = Future.delayed(const Duration(milliseconds: 1000));
  //   // Future.microtask(() {
  //   //   final a = App.scroll.bottomFactor.value;
  //   //   final b = App.scroll.bottomToggle.value;

  //   //   final x = _controller.position.minScrollExtent;
  //   //   final y = _controller.offset;
  //   //   debugPrint('a $a b $b $x == $y');
  //   //   // debugPrint('read.initState Future.microtask');
  //   //   // _controller.animateTo(
  //   //   //   _controller.position.maxScrollExtent,
  //   //   //   duration: const Duration(milliseconds: 300),
  //   //   //   curve: Curves.fastOutSlowIn,
  //   //   // );
  //   // });
  // }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void setChapterPrevious() {}
  void setChapterNext() {}
  void setFontSize(bool increase) {
    debugPrint('setFontSize; $increase');
    App.core.data.boxOfSettings.fontSizeModify(increase);
  }

  void showBookmarks() {
    Navigator.of(context).push(
      PageRouteBuilder<int>(
        settings: RouteSettings(
          arguments: {
            'render': _kBookmarks.currentContext!.findRenderObject() as RenderBox,
            'setFontSize': setFontSize,
            'test': 'hello world',
          },
        ),
        opaque: false,
        barrierDismissible: true,
        transitionsBuilder: (BuildContext _, Animation<double> x, __, Widget child) {
          return FadeTransition(
            opacity: x,
            child: child,
          );
        },
        pageBuilder: (_, __, ___) {
          return App.route.show('pop-bookmarks').child;
        },
      ),
    );
  }

  void showBooks() {
    Navigator.of(context)
        .push(
      PageRouteBuilder<Map<String, int>?>(
        settings: RouteSettings(
          arguments: {
            'render': _kBooks.currentContext!.findRenderObject() as RenderBox,
            'setFontSize': setFontSize,
            'test': 'hello world',
          },
        ),
        opaque: false,
        barrierDismissible: true,
        transitionsBuilder: (BuildContext _, Animation<double> x, __, Widget child) {
          return FadeTransition(
            opacity: x,
            child: child,
          );
        },
        // transitionsBuilder: (context, animation, secondaryAnimation, child) {
        //   const begin = Offset(0.0, 1.0);
        //   const end = Offset.zero;
        //   final tween = Tween(begin: begin, end: end);
        //   final offsetAnimation = animation.drive(tween);

        //   return SlideTransition(
        //     position: offsetAnimation,
        //     child: child,
        //   );
        // },
        pageBuilder: (_, __, ___) {
          return App.route.show('pop-books').child;
        },
      ),
    )
        .then(
      (e) {
        if (e != null) {
          debugPrint('showBooks $e');
          // App.core.chapterChange(bookId: e['book'], chapterId: e['chapter']);
          // setBook(e);
        }
      },
    );
  }

  void showChapters() {
    Navigator.of(context)
        .push(
      PageRouteBuilder<int>(
        settings: RouteSettings(
          arguments: {
            'render': _kChapters.currentContext!.findRenderObject() as RenderBox,
            'setFontSize': setFontSize,
            'test': 'hello world',
          },
        ),
        opaque: false,
        barrierDismissible: true,
        transitionsBuilder: (BuildContext _, Animation<double> x, __, Widget child) {
          return FadeTransition(
            opacity: x,
            child: child,
          );
        },
        pageBuilder: (_, __, ___) {
          return App.route.show('pop-chapters').child;
        },
      ),
    )
        .then(
      (e) {
        if (e != null) {
          debugPrint('setChapter $e');
          setState(() {});
          // setChapter(e);
        }
      },
    );
  }

  void showOptions() {
    Navigator.of(context).push(
      PageRouteBuilder<int>(
        settings: RouteSettings(
          arguments: {
            'render': _kOptions.currentContext!.findRenderObject() as RenderBox,
            'setFontSize': setFontSize,
            'test': 'hello world',
          },
        ),
        opaque: false,
        barrierDismissible: true,
        transitionsBuilder: (BuildContext _, Animation<double> x, __, Widget child) {
          return FadeTransition(
            opacity: x,
            child: child,
          );
        },
        pageBuilder: (_, __, ___) {
          return App.route.show('pop-options').child;
        },
      ),
    );
  }
}
