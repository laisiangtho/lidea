import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'stage';
  static String label = 'Stage';
  static IconData icon = Icons.shield_outlined;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final _controller = ScrollController();
  final Future<void> _viewSnap = Future.delayed(const Duration(milliseconds: 1000));

  final ValueNotifier<int> _valueNotifier = ValueNotifier<int>(0);
  final _changeNotifier = CounterChangeNotifier();

  late final counterInheritedWidget = CounterInheritedWidget.of(context);

  int counterInheritedWidgetNumber = 0;

  CounterChangeNotifier sliderInfo = CounterChangeNotifier();

  void numberChanged(int counterInheritedWidgetNumber) {
    setState(() {
      counterInheritedWidgetNumber++;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('stage->build');
    return Views(
      snap: _viewSnap,
      child: viewChild(),
    );
  }

  Widget viewChild() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stage'),
      ),
      body: ListView(
        controller: _controller,
        children: [
          ListTile(
            title: const Text('ValueNotifier'),
            subtitle: const Text('ValueListenableBuilder'),
            trailing: TextButton(
              onPressed: () {
                _valueNotifier.value += 1;
              },
              child: ValueListenableBuilder<int>(
                builder: (BuildContext context, int value, Widget? child) {
                  return Text('$value');
                },
                valueListenable: _valueNotifier,
                child: const Text('0'),
              ),
            ),
          ),
          ListTile(
            title: const Text('ChangeNotifier'),
            subtitle: const Text('AnimatedBuilder'),
            trailing: TextButton(
              onPressed: () {
                _changeNotifier.increment();
              },
              child: AnimatedBuilder(
                animation: _changeNotifier,
                builder: (context, child) {
                  return Text('${_changeNotifier.number}');
                },
                child: const Text('0'),
              ),
            ),
          ),
          ListTile(
            title: CounterInheritedWidget(
              number: counterInheritedWidgetNumber,
              numberChanged: numberChanged,
              // child: const Text('InheritedWidget'),
              child: const InheritedWidgetChild(),
            ),
            trailing: TextButton(
              onPressed: () {},
              child: Text(counterInheritedWidgetNumber.toString()),
            ),
          ),
          ListTile(
            title: CounterInheritedNotifier(
              notifier: sliderInfo,
              child: Builder(builder: (BuildContext context) {
                return Column(
                  children: <Widget>[
                    Slider(
                      min: 0.0,
                      max: 1.0,
                      value: CounterInheritedNotifier.of(context),
                      onChanged: (double value) {
                        sliderInfo.number = value;
                      },
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Spinner(),
                        Spinner(),
                        Spinner(),
                      ],
                    ),
                  ],
                );
              }),
            ),
            subtitle: const Text('CounterInheritedNotifier'),
          )
        ],
      ),
      persistentFooterButtons: const [
        Text('persistent'),
        Text('Footer'),
        Text('Buttons'),
      ],
      extendBody: true,
      extendBodyBehindAppBar: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.plus_one),
        onPressed: () => _changeNotifier.increment(),
      ),
    );
  }
}

class CounterChangeNotifier extends ChangeNotifier {
  double _number = 0;

  double get number => _number;
  set number(double value) {
    if (value != _number) {
      _number = value;
      notifyListeners();
    }
  }

  void increment() {
    _number++;
    notifyListeners();
  }
}

class CounterInheritedNotifier extends InheritedNotifier<CounterChangeNotifier> {
  const CounterInheritedNotifier({
    super.key,
    required CounterChangeNotifier super.notifier,
    required super.child,
  });

  // static CounterInheritedNotifier of(BuildContext context) {
  //   return context.dependOnInheritedWidgetOfExactType<CounterInheritedNotifier>()!;
  // }

  static CounterInheritedNotifier counterInheritedNotifier(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterInheritedNotifier>()!;
  }

  static CounterChangeNotifier counterChangeNotifier(BuildContext context) {
    return counterInheritedNotifier(context).notifier!;
  }

  static double of(BuildContext context) {
    return counterChangeNotifier(context).number;
  }
}

class CounterInheritedWidget extends InheritedWidget {
  final int number;
  final ValueChanged<int> numberChanged;
  const CounterInheritedWidget({
    super.key,
    required this.number,
    required this.numberChanged,
    required super.child,
  });

  static CounterInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterInheritedWidget>();
  }

  @override
  bool updateShouldNotify(covariant CounterInheritedWidget oldWidget) {
    return number != oldWidget.number || numberChanged != oldWidget.numberChanged;
  }
}

// class TmpInheritedWidget extends InheritedNotifier<CounterChangeNotifier> {
//   TmpInheritedWidget({
//     Key? key,
//     CounterChangeNotifier? notifier,
//     Widget? child,
//   }) : super(key: key, notifier: notifier, child: child!);

//   // static int of(BuildContext context) {
//   //   return context.dependOnInheritedWidgetOfExactType<CounterInheritedWidget>()!.number;
//   // }
// }

class InheritedWidgetChild extends StatelessWidget {
  const InheritedWidgetChild({super.key});

  @override
  Widget build(BuildContext context) {
    final number = CounterInheritedWidget.of(context)!.number;
    return Text('InheritedWidget: $number');
  }
}

// class SliderInfo extends ChangeNotifier {
//   SliderInfo();

//   int get value => _value;
//   int _value = 0;
//   set value(int value) {
//     if (value != _value) {
//       _value = value;
//       notifyListeners();
//     }
//   }
// }

// class SliderNotifier extends InheritedNotifier<SliderInfo> {
//   const SliderNotifier({
//     Key? key,
//     required SliderInfo notifier,
//     required Widget child,
//   }) : super(key: key, notifier: notifier, child: child);

//   static int of(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<SliderNotifier>()!.notifier!.value;
//   }
// }

class Spinner extends StatelessWidget {
  const Spinner({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: CounterInheritedNotifier.of(context) * 2.0 * math.pi,
      child: Container(
        width: 20,
        height: 20,
        color: Colors.green,
      ),
    );
  }
}
