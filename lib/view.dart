library lidea;

import 'dart:ui';

export 'view/model.dart';
export 'view/notify.dart';
export 'view/page.dart';
export 'view/header.dart';
export 'view/navigation.dart';

Color hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}