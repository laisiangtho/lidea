import 'package:flutter/foundation.dart';

abstract class Notify with ChangeNotifier {
  void notifyIf<T>(T element, T value) {
    if (value != element) {
      notify();
    }
  }

  void notify() => notifyListeners();
}
