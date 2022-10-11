part of 'main.dart';

abstract class _State extends StateAbstract<Main> with SingleTickerProviderStateMixin {
  late final ScrollController _controller = ScrollController();

  late final boxOfBooks = App.core.data.boxOfBooks;

  late final AnimationController _dragController = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: this,
  );
  late final Animation<double> _dragAnimation = Tween(
    begin: 0.0,
    end: 1.0,
  ).animate(_dragController);
  late final Animation<Color?> _colorAnimation = ColorTween(
    begin: null,
    end: Theme.of(context).errorColor,
  ).animate(_dragController);

  @override
  void initState() {
    super.initState();
  }

  void onSort() {
    // boxOfBooks.box.add(
    //   BooksType(
    //     identify: App.core.data.randomString(5),
    //     name: App.core.data.randomString(15),
    //     shortname: App.core.data.randomString(3),
    //     year: 2000,
    //     langCode: 'EN',
    //     langName: 'English',
    //   ),
    // );
    if (_dragController.isCompleted) {
      _dragController.reverse();
    } else {
      _dragController.forward();
    }
  }

  void showBibleContent(BooksType bible, int index) async {
    // state.hasArguments;
    if (state.hasArguments) {
      debugPrint('from:${App.core.data.parallelId} to:${bible.identify}');

      if (App.core.data.parallelId != bible.identify) {
        App.core.data.parallelId = bible.identify;
      }
      // if (!App.core.scriptureParallel.isReady) {
      //   App.core.message.value = App.preference.text.aMoment;
      // }

      // Navigator.of(context).pop();
      state.navigator.maybePop();

      Future.microtask(() {
        // App.core.scriptureParallel.init().then((value) {
        //   if (App.core.message.value.isNotEmpty) {
        //     App.core.message.value = '';
        //   } else {
        //     App.core.notify();
        //   }
        // });
      });
    } else {
      bible.selected = !bible.selected;
      boxOfBooks.box.putAt(index, bible);
    }
  }

  Future showBibleInfo(BooksType book) {
    // return showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   useRootNavigator: true,
    //   // builder: (BuildContext context) => _ModalSheet(book: book, core: core),
    //   builder: (BuildContext context) => WidgetDraggableInfoModal(book: book),
    //   // barrierColor: Theme.of(context).backgroundColor.withOpacity(0.7),
    //   // barrierColor: Theme.of(context).shadowColor.withOpacity(0.7),
    //   // barrierColor: Theme.of(context).backgroundColor.withOpacity(0.7),
    //   // barrierColor: Theme.of(context).scaffoldBackgroundColor,
    // );
    return App.route.showSheetModal(context: context, name: 'sheet-bible', arguments: book);
  }
}
