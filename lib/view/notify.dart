import 'package:flutter/foundation.dart';

class ViewNotify extends ChangeNotifier {

  static ValueNotifier<int> navigation = ValueNotifier<int>(0);

  // static void navigationListener(Function(int) listener) {
  //   navigation.addListener(() => listener(navigation.value));
  // }
  // int _current = 0;

  // int? get current => _current;
  // set current(int? index) {
  //   _current = index!;
  //   notifyListeners();
  // }
  
}

