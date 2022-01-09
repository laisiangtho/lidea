import 'dart:math';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}

class Mock {
  static String chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static List<String> listOfRandomString({int length = 50}) {
    return List<String>.generate(length, (int index) => randomString(length: 10));
  }

  static int randomNumber(int max) {
    return Random().nextInt(max);
  }

  static String randomString({int length = 10}) {
    return List.generate(length, (index) => chars[randomNumber(chars.length)]).join();
  }
  // Future<String> getCollection = Future<String>.delayed(
  //   Duration(seconds: 2),
  //   () => 'Data Loaded',
  // );

  // Future.delayed(const Duration(milliseconds: 500), () {});

  // Future<void> delay() async {
  //   await Future.delayed(Duration(milliseconds: 300), (){});
  // }

  // Future<bool> initCollectionMock() async {
  //   return Future<bool>.delayed(
  //     Duration(milliseconds: 500),
  //     () => true,
  //   );
  // }
}
