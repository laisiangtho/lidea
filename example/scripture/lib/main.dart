// NOTE: Material
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const LaiSiangtho());
}

class LaiSiangtho extends StatelessWidget {
  const LaiSiangtho({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('abc');
  }

  Widget builder(BuildContext context, Widget? child) {
    return child!;
  }
}
