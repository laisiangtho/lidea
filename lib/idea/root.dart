import 'package:flutter/material.dart';

// Default color configuration is light, and translated into how human mind can interpreted the material color
class IdeaColor {
  final Brightness brightness;
  final Color focus;

  final Color primary;
  final Color dark;
  final Color light;
  final Color scaffold;
  final Color highlight;
  final Color disable;
  final Color background;
  final Color error;
  final Color shadow;
  final Color button;

  // schemePrimary primaryScheme
  final Color primaryScheme;

  const IdeaColor({
    this.brightness = Brightness.light,
    this.focus = Colors.black,
    this.primary = Colors.white,
    this.light = Colors.grey,
    this.dark = Colors.blue,
    this.scaffold = Colors.white,
    this.highlight = Colors.blue,
    this.disable = Colors.grey,
    this.background = Colors.grey,
    this.error = Colors.red,
    this.shadow = Colors.grey,
    this.button = Colors.blue,
    this.primaryScheme = Colors.white,
  });

  // Color get shadow => scaffold.darken(amount: 0.2);
  Color get canvas => Colors.transparent;

  Color get focusOpacity => focus.withOpacity(0.12);
  Color get text => focus;

  ColorScheme get scheme => ColorScheme(
        brightness: brightness,
        primary: primaryScheme,
        primaryVariant: light,
        secondary: primaryScheme,
        secondaryVariant: light,
        background: background,
        surface: background.darken(),
        error: error,
        onError: focusOpacity,
        onPrimary: focusOpacity,
        onSecondary: focusOpacity,
        onSurface: focusOpacity,
        onBackground: scaffold,
      );
}

extension ColorDimExtension on Color {
  Color darken({double amount = .1}) {
    assert(amount >= 0 && amount <= 1);
    HSLColor color = HSLColor.fromColor(this);
    return color.withLightness((color.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  Color lighten({double amount = .1}) {
    assert(amount >= 0 && amount <= 1);
    HSLColor color = HSLColor.fromColor(this);
    return color.withLightness((color.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  // Color darken(Color color, [double amount = .1]) {
  //   assert(amount >= 0 && amount <= 1);
  //   final hsl = HSLColor.fromColor(color);
  //   final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  //   return hslDark.toColor();
  // }

  // Color lighten(Color color, [double amount = .1]) {
  //   assert(amount >= 0 && amount <= 1);
  //   final hsl = HSLColor.fromColor(color);
  //   final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
  //   return hslLight.toColor();
  // }
}
