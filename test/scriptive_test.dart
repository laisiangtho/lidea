import 'package:flutter_test/flutter_test.dart';

import 'package:lidea/mock.dart';
import 'package:lidea/intl.dart' as intl;

void main() {
  test('adds one to input values', () {
    final calculator = Calculator();
    expect(calculator.addOne(2), 3);
    expect(calculator.addOne(-7), -6);
    expect(calculator.addOne(0), 1);
  });
  test('adds one to input values', () {
    final _formattedNumber = intl.NumberFormat.compact().format(1500);
    expect(_formattedNumber, '1.5K');
  });
}
