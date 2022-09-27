import 'package:flutter/material.dart';

// ViewGesture
// ViewItemSwipe
// ViewItemSwipe
// ViewSwipeWidget
class ViewSwipeWidget extends StatefulWidget {
  const ViewSwipeWidget({
    Key? key,
    required this.child,
    required this.menu,
    this.dx = 0.2,
  }) : super(key: key);

  final Widget child;
  final List<Widget> menu;
  final double dx;

  @override
  ViewSwipeState createState() => ViewSwipeState();
}

class ViewSwipeState extends State<ViewSwipeWidget> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final offset = Tween(
    begin: const Offset(0.0, 0.0),
    end: Offset(-(widget.dx * widget.menu.length), 0.0),
  ).animate(
    CurveTween(curve: Curves.linear).animate(controller),
  );

  late final double = Tween(
    begin: 0.7,
    end: 1.0,
  ).animate(CurveTween(curve: Curves.easeIn).animate(controller));

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (data) {
        controller.value -= (data.primaryDelta! / context.size!.width / 0.3);
      },
      onHorizontalDragEnd: (data) {
        if (data.primaryVelocity! > 2500) {
          controller.animateTo(.0, duration: const Duration(milliseconds: 100));
        } else if (controller.value >= .3 || data.primaryVelocity! < -2500) {
          controller.animateTo(1.0, duration: const Duration(milliseconds: 100));
        } else {
          controller.animateTo(.0, duration: const Duration(milliseconds: 100));
        }
        // if (data.primaryVelocity! > 2500) {
        //   controller.animateTo(.0, duration: const Duration(milliseconds: 50));
        // } else if (controller.value >= .3 || data.primaryVelocity! < -2500) {
        //   controller.animateTo(1.0, duration: const Duration(milliseconds: 50));
        // } else {
        //   controller.animateTo(.0, duration: const Duration(milliseconds: 50));
        // }
      },
      onLongPress: () {
        if (controller.isCompleted) {
          controller.reverse();
        } else if (controller.isDismissed) {
          controller.forward();
        }
      },
      child: Stack(
        children: <Widget>[
          SlideTransition(position: offset, child: widget.child),
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraint) {
                return AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return Stack(
                      alignment: const Alignment(0, 0),
                      children: <Widget>[
                        Positioned(
                          right: .0,
                          top: .0,
                          bottom: .0,
                          width: constraint.maxWidth * offset.value.dx * -1,
                          child: SizedBox(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: widget.menu.map(
                                (item) {
                                  return Expanded(
                                    child: FadeTransition(
                                      opacity: double,
                                      child: item,
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
