import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';

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
  final Color divider;
  final Color button;

  final Color primaryScheme;
  final MaterialColor primarySwatch;

  const ColorationScheme({
    this.brightness = Brightness.light,
    // this.focus = Colors.black12,
    // this.primary = const Color(0xFFffffff),
    this.focus = const Color(0xFFd5d5d5),
    this.primary = const Color(0xFFffffff),
    this.light = Colors.white,
    this.dark = Colors.black45,
    this.scaffold = const Color(0xFFf7f7f7),
    this.highlight = Colors.blue,
    this.disable = Colors.black12,
    this.background = const Color(0xFFdbdbdb),
    this.error = const Color.fromARGB(255, 187, 43, 43),
    this.shadow = const Color(0xFFbdbdbd),
    this.divider = const Color(0xFFbdbdbd),
    this.button = const Color(0xFFdedcdc),
    this.primaryScheme = Colors.black,
    this.primarySwatch = Colors.blue,
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
    // Color focus = Color.fromARGB(255, 185, 183, 183),
    Color focus = const Color(0xFF959595),
    Color primary = const Color(0xFF9c9c9c),
    Color light = Colors.white,
    Color dark = Colors.black45,
    Color scaffold = const Color(0xFFa6a6a6),
    Color highlight = Colors.black38,
    Color disable = Colors.white12,
    // const Color(0xFFdbdbdb),
    // Color background = const Color(0xFFbdbdbd),
    Color background = const Color(0xFF949494),
    // Color background = const Color(0xFF9c9c9c),
    // Color background = const Color.fromARGB(182, 181, 181, 0),
    Color error = const Color.fromARGB(255, 138, 52, 52),
    Color shadow = const Color(0xFF8f8f8f),
    Color divider = const Color(0xFF8f8f8f),
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
      divider: divider,
      button: button,
      primaryScheme: primaryScheme,
      primarySwatch: primarySwatch,
    );
  }
}

abstract class ColorationData {
  static ThemeData theme({
    required TextTheme text,
    required ColorationScheme color,

    /// Lato, 'Mm3Web', sans-serif
    String? fontFamily = "Lato",
    // List<String>? fontFallback = const ['Mm3Web'],
  }) {
    // final TextTheme textTheme = Theme.of(context).textTheme.merge(_textTheme);

    return ThemeData(
      colorScheme: color.scheme,
      brightness: color.brightness,
      // primaryColorBrightness: Brightness.light,
      // primarySwatch: color.primarySwatch,

      // fontFamily: "Lato, Lato, Mm3Web",
      fontFamily: fontFamily,

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
      dividerColor: color.divider,
      focusColor: color.focus,

      textTheme: text.apply(
        // fontFamily: "Lato, sans-serif",
        fontFamily: fontFamily,
        bodyColor: color.primaryScheme,
        displayColor: color.primaryScheme.withOpacity(0.6),
        decorationColor: Colors.red,
        decorationStyle: TextDecorationStyle.wavy,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: color.primary,
        foregroundColor: color.primaryScheme,
      ),

      iconTheme: IconThemeData(color: color.primaryScheme, size: 26),
      cardTheme: CardTheme(
        color: color.primary,
        elevation: 0.8,
        shadowColor: color.shadow,
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.2, color: color.divider),
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
        titleTextStyle: TextStyle(fontSize: 19, color: color.primaryScheme),
        contentTextStyle: TextStyle(fontSize: 14, color: color.primaryScheme),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        elevation: 3,
      ),
      snackBarTheme: SnackBarThemeData(
        // Color? backgroundColor,
        // Color? actionTextColor,
        // Color? disabledActionTextColor,
        // TextStyle? contentTextStyle,
        // double? elevation,
        // ShapeBorder? shape,
        // SnackBarBehavior? behavior,
        backgroundColor: color.dark,
        elevation: 1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.transparent,
        disabledColor: Colors.grey,
        selectedColor: Colors.amber,
        secondarySelectedColor: Colors.blueAccent,
        padding: EdgeInsets.zero,
        // labelStyle: TextStyle(color: Colors.red),
        labelStyle: text.labelMedium,
        // secondaryLabelStyle: TextStyle(color: color.primaryScheme),
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
      // cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
      //   brightness: color.brightness,
      //   textTheme: const CupertinoTextThemeData(
      //     primaryColor: Colors.red,
      //     actionTextStyle: TextStyle(color: Colors.orange),
      //   ),
      // ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: color.shadow.withOpacity(0.7),
        // hoverColor: Colors.green,
        // focusColor: Colors.red,
        // hintStyle: TextStyle(
        //   color: color.primaryScheme.withOpacity(0.7),
        //   fontSize: 15,
        // ),
        // labelStyle: const TextStyle(),
        alignLabelWithHint: true,

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
          // textStyle: const TextStyle(fontSize: 19),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(color.primaryScheme),
          backgroundColor: MaterialStateProperty.all<Color>(color.primary),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(color.primaryScheme),
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

  static TextTheme textTheme({
    List<String>? fontFallback = const ['Mm3Web', 'sans-serif'],
    FontWeight fontWeightMedium = FontWeight.normal,
    FontWeight fontWeightBold = FontWeight.w500,
  }) {
    return TextTheme(
      displayLarge: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightMedium,
        fontSize: 50,
      ),
      displayMedium: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightMedium,
        fontSize: 45,
      ),
      displaySmall: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightMedium,
        fontSize: 40,
      ),
      headlineLarge: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightMedium,
        fontSize: 35,
      ),
      headlineMedium: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightMedium,
        fontSize: 30,
      ),
      headlineSmall: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightMedium,
        fontSize: 25,
      ),
      // appbar-title
      titleLarge: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightMedium,
        fontSize: 21,
        // height: 1.3,
      ),
      titleMedium: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightMedium,
        fontSize: 19,
      ),
      titleSmall: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightMedium,
        fontSize: 17,
      ),
      bodyLarge: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightMedium,
        fontSize: 23,
      ),
      bodyMedium: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightMedium,
        fontSize: 19,
      ),
      bodySmall: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightMedium,
        fontSize: 15,
      ),

      labelLarge: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightMedium,
        // fontSize: 23,
        fontSize: 20,
      ),
      labelMedium: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightMedium,
        fontSize: 18,
      ),
      labelSmall: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightMedium,
        fontSize: 15,
      ),
    );
  }
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
