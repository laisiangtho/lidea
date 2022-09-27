import 'package:flutter/material.dart';
import '../../app.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  static String route = 'nested';
  static String label = 'Nested';
  static IconData icon = Icons.ac_unit;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final Future<void> _viewSnap = Future.delayed(const Duration(milliseconds: 1000));

  @override
  Widget build(BuildContext context) {
    debugPrint('nested->build');
    return Views(
      snap: _viewSnap,
      child: viewChild(),
    );
  }

  Widget viewChild() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nested'),
      ),
      body: const Center(
        child: Text('configuration'),
      ),
    );
  }
}
