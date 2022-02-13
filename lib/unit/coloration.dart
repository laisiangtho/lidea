import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// Default color configuration is light, and translated into
// how human mind can interpreted the material color
class ColorationScheme {
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

  final Color primaryScheme;
  final MaterialColor primarySwatch;

  const ColorationScheme({
    this.brightness = Brightness.light,
    this.focus = Colors.black,
    this.primary = const Color(0xFFffffff),
    this.light = Colors.grey,
    this.dark = Colors.grey,
    this.scaffold = const Color(0xFFf7f7f7),
    this.highlight = Colors.orange,
    this.disable = Colors.black12,
    this.background = const Color(0xFFdbdbdb),
    this.error = Colors.red,
    this.shadow = const Color(0xFFbdbdbd),
    this.button = const Color(0xFFdedcdc),
    this.primaryScheme = Colors.black,
    this.primarySwatch = Colors.grey,
  });

  Color get canvas => Colors.transparent;
  Color get focusOpacity => focus.withOpacity(0.12);

  ColorScheme get scheme {
    return ColorScheme(
      brightness: brightness,
      primary: primaryScheme,
      // primaryVariant: light,
      secondary: primaryScheme,
      // secondaryVariant: light,
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

  static ColorationScheme darkColor({
    Brightness brightness = Brightness.dark,
    Color focus = Colors.white,
    Color primary = const Color(0xFF9c9c9c),
    Color light = Colors.grey,
    Color dark = Colors.blue,
    Color scaffold = const Color(0xFFa6a6a6),
    Color highlight = Colors.orange,
    Color disable = Colors.white30,
    Color background = const Color(0xFFbdbdbd),
    Color error = Colors.red,
    Color shadow = const Color(0xFF8f8f8f),
    Color button = const Color(0xFFd9d9d9),
    Color primaryScheme = Colors.white,
    MaterialColor primarySwatch = Colors.grey,
  }) {
    return ColorationScheme(
      brightness: brightness,
      focus: focus,
      primary: primary,
      light: light,
      dark: dark,
      scaffold: scaffold,
      highlight: highlight,
      disable: disable,
      background: background,
      error: error,
      shadow: shadow,
      button: button,
      primaryScheme: primaryScheme,
      primarySwatch: primarySwatch,
    );
  }
}

abstract class ColorationData {
  static ThemeData theme(TextTheme textTheme, ColorationScheme color) {
    // final TextTheme textTheme = Theme.of(context).textTheme.merge(_textTheme);

    return ThemeData(
      colorScheme: color.scheme,
      brightness: color.brightness,
      // primaryColorBrightness: Brightness.light,
      // primarySwatch: color.primarySwatch,

      // fontFamily: "Lato, Lato, Mm3Web",
      fontFamily: "Lato, 'Mm3Web', sans-serif",
      primaryColor: color.primary,
      primaryColorLight: color.light,
      primaryColorDark: color.dark,
      shadowColor: color.shadow,
      canvasColor: color.canvas,
      scaffoldBackgroundColor: color.scaffold,
      backgroundColor: color.background,
      highlightColor: color.highlight,
      disabledColor: color.disable,
      errorColor: color.error,

      textTheme: textTheme.apply(
        bodyColor: color.focus,
        displayColor: color.highlight,
        decorationColor: Colors.red,
      ),
      primaryTextTheme: textTheme,
      appBarTheme: AppBarTheme(
        // backgroundColor: Colors.blue,
        // foregroundColor: Colors.red,
        backgroundColor: color.primary,
        foregroundColor: color.focus,
      ),

      // iconTheme: IconThemeData(color: color.focus, size: 23),
      iconTheme: IconThemeData(color: color.focus, size: 26),
      cardTheme: CardTheme(
        color: color.primary,
        elevation: 0.5,
        shadowColor: color.shadow,
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.2, color: color.shadow),
          // BorderRadius.circular(5)
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
      ),
      dialogTheme: DialogTheme(
        // Color? backgroundColor,
        // double? elevation,
        // ShapeBorder? shape,
        // TextStyle? titleTextStyle,
        // TextStyle? contentTextStyle,
        // backgroundColor: Colors.red,
        titleTextStyle: TextStyle(fontSize: 19, height: 1.0, color: color.focus),
        contentTextStyle: TextStyle(fontSize: 14, height: 1.0, color: color.focus),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        elevation: 3,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.transparent,
        disabledColor: Colors.grey,
        selectedColor: Colors.amber,
        secondarySelectedColor: Colors.blueAccent,
        padding: EdgeInsets.zero,
        labelStyle: TextStyle(color: color.focus),
        secondaryLabelStyle: TextStyle(color: color.focus),
        brightness: color.brightness,
        // brightness: resolveBrightness,
      ),
      listTileTheme: ListTileThemeData(
          // bool? dense,
          // ShapeBorder? shape,
          // ListTileStyle? style,
          // Color? selectedColor,
          // Color? iconColor,
          // Color? textColor,
          // EdgeInsetsGeometry? contentPadding,
          // Color? tileColor,
          // Color? selectedTileColor,
          // double? horizontalTitleGap,
          // double? minVerticalPadding,
          // double? minLeadingWidth,
          // bool? enableFeedback,
          ),
      cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
        brightness: color.brightness,
        textTheme: const CupertinoTextThemeData(
          primaryColor: Colors.red,
          actionTextStyle: TextStyle(color: Colors.orange),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: color.shadow.withOpacity(0.7),
        // hoverColor: Colors.green,
        // focusColor: Colors.red,
        hintStyle: TextStyle(
          color: color.focus.withOpacity(0.7),
          height: 1.3,
          fontSize: 15,
        ),
        // labelStyle: const TextStyle(height: 1.7),
        // alignLabelWithHint: true,

        suffixStyle: const TextStyle(color: Colors.red),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color.shadow, width: 0.3),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color.shadow, width: 0.2),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color.shadow.withOpacity(0.8), width: 0.2),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: color.shadow, width: 0.2),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        clipBehavior: Clip.hardEdge,
        // clipBehavior: Clip.antiAlias,
        // clipBehavior: Clip.antiAliasWithSaveLayer,
        // modalBackgroundColor: color.background,
        modalBackgroundColor: color.primary,
        modalElevation: 2.0,
        // backgroundColor: color.primary,
        backgroundColor: color.background,
        // backgroundColor: Colors.red,
        elevation: 2.0,
      ),
      bottomAppBarTheme: const BottomAppBarTheme(color: Colors.cyan),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: Colors.red),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          textStyle: const TextStyle(fontSize: 19),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(color.focus),
          backgroundColor: MaterialStateProperty.all<Color>(color.primary),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(color.focus),
          backgroundColor: MaterialStateProperty.all<Color>(color.primary),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
      ),
    );
  }

  // static ColorScheme lightScheme = _lightColor.scheme;
  // static ColorScheme darkScheme = _darkColor.scheme;

  // static const _fontWeightSemiThin = FontWeight.w100;
  static const _fontWeightThin = FontWeight.w100;
  static const _fontWeighRegular = FontWeight.w300;
  static const _fontWeighMedium = FontWeight.w400;
  static const _fontWeighSemiBold = FontWeight.w500;
  // static const _fontWeighBold = FontWeight.w700;

  static const TextTheme textTheme = TextTheme(
    headline1: TextStyle(
      fontWeight: _fontWeighRegular,
      fontFamilyFallback: ["Mm3Web", "Lato"],
      height: 1.0,
      fontSize: 37,
    ),
    headline2: TextStyle(
      fontWeight: _fontWeightThin,
      fontFamilyFallback: ["Mm3Web", "Lato"],
      fontSize: 32,
      height: 1.0,
    ),
    headline3: TextStyle(
      fontWeight: _fontWeighRegular,
      fontFamilyFallback: ["Mm3Web", "Lato"],
      fontSize: 27,
      height: 1.0,
    ),
    headline4: TextStyle(
      fontWeight: _fontWeighRegular,
      fontFamilyFallback: ["Mm3Web", "Lato"],
      fontSize: 25,
      height: 1.0,
    ),
    headline5: TextStyle(
      fontWeight: _fontWeighRegular,
      fontFamilyFallback: ["Mm3Web", "Lato"],
      fontSize: 22,
      height: 1.2,
    ),
    headline6: TextStyle(
      fontWeight: _fontWeighRegular,
      fontFamilyFallback: ["Mm3Web", "Lato"],
      height: 1.2,
    ),

    /// default: ListTile.title
    subtitle1: TextStyle(
      fontWeight: _fontWeighRegular,
      fontFamilyFallback: ["Mm3Web", "Lato"],
      // height: 1.4,
      height: 1.0,
      fontSize: 20,
    ),
    subtitle2: TextStyle(
      fontWeight: _fontWeighMedium,
      fontFamilyFallback: ["Mm3Web", "Lato"],
      height: 1.0,
    ),
    bodyText1: TextStyle(
      fontWeight: _fontWeighRegular,
      fontFamilyFallback: [
        "sans-serif",
        "Mm3Web",
      ],
      fontSize: 20,
      height: 1.25,
    ),
    bodyText2: TextStyle(
      fontWeight: _fontWeighMedium,
      fontFamilyFallback: [
        "sans-serif",
        "Mm3Web",
      ],
      fontSize: 20,
      height: 1.25,
    ),
    caption: TextStyle(
      fontWeight: _fontWeighSemiBold,
      fontFamilyFallback: ["Mm3Web", "Lato"],
      height: 1.0,
    ),
    button: TextStyle(
      fontWeight: _fontWeightThin,
      fontFamilyFallback: ["Mm3Web", "Lato"],
      height: 1.0,
    ),
    overline: TextStyle(
      fontWeight: _fontWeighMedium,
      fontFamilyFallback: ["Mm3Web", "Lato"],
      height: 1.0,
    ),
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
