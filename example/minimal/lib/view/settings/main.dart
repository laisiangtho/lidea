import 'package:flutter/material.dart';
import '../../app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'settings';
  static String label = 'Settings';
  static IconData icon = Icons.settings;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final Future<void> _viewSnap = Future.delayed(const Duration(milliseconds: 1000));

  @override
  Widget build(BuildContext context) {
    debugPrint('settings->build');
    return Views(
      snap: _viewSnap,
      child: viewChild(),
    );
  }

  Widget viewChild() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const Center(
        child: Text('configuration'),
      ),
    );
  }
}
