import 'package:flutter/material.dart';
import '../../../app.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);
  static String route = 'pop-chapters';
  static String label = 'Chapters';
  static IconData icon = Icons.opacity_outlined;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends StateAbstract<Main> with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    duration: const Duration(milliseconds: 350),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void setFontSize(bool increase) {
    setState(() {
      fontSize.call(increase);
    });
  }

  void Function(bool) get fontSize => args!['setFontSize'];

  late final RenderBox render = args!['render'];
  late final Size sizeOfRender = render.size;
  late final Offset positionOfRender = render.localToGlobal(Offset.zero);
  late final Size sizeOfContext = MediaQuery.of(context).size;

  double get hzSpace => 20;
  // double get maxWidth => 414;
  // double get maxWidth => 250;
  double get maxWidth {
    switch (itemCount) {
      case 1:
        return 250;
      case 2:
        return 300;
      case 3:
        return 300;

      default:
        return 414;
    }
  }

  double get hzSize => (sizeOfContext.width - maxWidth) / 2;
  bool get _hasMax => sizeOfContext.width > maxWidth;
  double get left => _hasMax ? hzSize : hzSpace;
  double get right => _hasMax ? hzSize : hzSpace;
  double get top => positionOfRender.dy + sizeOfRender.height + 20;

  double get arrowWidth => 10;
  double get arrowHeight => 12;

  // Scripture get scripture => core.scripturePrimary;
  // int get itemCount => scripture.itemCount;
  late final itemCount = App.core.data.randomNumber(150);
  // late final itemCount = 150;
  // int get itemCount => 1;

  bool get itemLimit => itemCount > 4;
  int get perItem => itemLimit ? 4 : itemCount;

  // double get defaultHeight => (itemCount / perItem).ceilToDouble() * (itemLimit ? 75 : 110);
  // double get maxHeight => defaultHeight * 0.4;

  double get defaultHeight => (itemCount / perItem).ceilToDouble() * 75;
  double get maxHeight => sizeOfContext.height * 0.75;
  // NOTE:
  // double get defaultHeight => (itemCount / perItem).ceilToDouble() * 75;
  // double get maxHeight => sizeOfContext.height * 0.75;

  double get height {
    switch (itemCount) {
      case 1:
        return 190;
      case 2:
        return 115;
      case 3:
        return 80;

      default:
        return defaultHeight > maxHeight ? maxHeight : defaultHeight;
    }
  }

  double? get buttonFontSize {
    // Theme.of(context).textTheme.labelLarge!.fontSize
    // return 0;
    final textSize = state.textTheme.labelLarge!.fontSize!;
    switch (itemCount) {
      case 1:
        return textSize + 16;
      case 2:
        return textSize + 8;
      case 3:
        return textSize + 3;

      default:
        return textSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewPopupShapedArrow(
      left: left,
      right: right,
      top: top,
      height: height,
      arrow: positionOfRender.dx - left + (sizeOfRender.width * 0.18),
      arrowWidth: arrowWidth,
      arrowHeight: arrowHeight,
      backgroundColor: Theme.of(context).backgroundColor,
      // child: SizedBox(
      //   height: height,
      //   child: view(),
      // ),
      child: SizeTransition(
        sizeFactor: _animation,
        axis: Axis.vertical,
        axisAlignment: -1,
        child: SizedBox(
          height: height,
          child: view(),
        ),
      ),
    );
  }

  Widget view() {
    return GridTile(
      header: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).backgroundColor,
              blurRadius: 9,
              spreadRadius: 15,
              offset: const Offset(0, 0),
            ),
          ],
        ),
      ),
      footer: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).backgroundColor,
              blurRadius: 9,
              spreadRadius: 15,
              offset: const Offset(0, 0),
            ),
          ],
        ),
      ),
      child: GridView.count(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
        // mainAxisSpacing: 0,
        // crossAxisSpacing: 0,
        // childAspectRatio: childAspectRatio,
        mainAxisSpacing: 7,
        crossAxisSpacing: 7,
        childAspectRatio: 1.36,
        crossAxisCount: perItem,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: List<Widget>.generate(
          itemCount,
          (index) => chapterButton(index + 1),
        ),
      ),
    );
  }

  Widget chapterButton(int index) {
    // bool isCurrentChapter = false;
    bool isCurrentChapter = App.core.data.chapterId == index;
    // bool isCurrentChapter = chapter.id == index;

    return ViewButton(
      enable: !isCurrentChapter,
      style: TextStyle(fontSize: buttonFontSize),
      child: ViewMark(
        // label: scripture.digit(index),
        label: index.toString(),
        // labelStyle: TextStyle(
        //   color: isCurrentChapter ? Theme.of(context).highlightColor : null,
        // ),
      ),
      onPressed: () {
        Navigator.pop<int>(context, index);
      },
    );
    // return Padding(
    //   padding: const EdgeInsets.all(3.0),
    //   child: WidgetButton(
    //     // minSize: 55,
    //     // borderRadius: BorderRadius.all(Radius.circular(2.0)),
    //     padding: EdgeInsets.zero,
    //     // color: Theme.of(context).scaffoldBackgroundColor,
    //     child: Text(
    //       scripture.digit(index),
    //       style: TextStyle(
    //         color: isCurrentChapter ? Theme.of(context).highlightColor : null,
    //       ),
    //     ),
    //     onPressed: () => Navigator.pop<int>(context, index),
    //   ),
    // );
  }
}
