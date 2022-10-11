import 'package:flutter_test/flutter_test.dart';

import 'package:lidea/extension.dart';

const List<String?> lists = ['a', 'b', 'c', '+'];

void main() {
  test('String Extension', () {
    expect('ab', '[ba]'.bracketsHack());
    expect('http://github.com', 'git+http://github.com'.gitHack());
    expect('https://github.com/ab/cd', 'git+/ab/cd'.gitHack());
    expect('https://github.com/ab/cd', 'git+/[dc/ba]'.gitHack().bracketsHack());

    final result = lists.firstWhere((e) => e == 'apple', orElse: () => null);
    // print(result);
    expect(null, result);
  });
}
