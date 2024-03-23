part of '../main.dart';

// Default color configuration is light, and translated into
// how human mind can interpreted the material color
class ColorNest {
  final Brightness brightness;
  final Color scaffold;
  final Color focus;
  final Color splash;

  final Color primary;
  final Color dark;
  final Color light;
  final Color highlight;
  final Color disable;
  final Color background;
  final Color error;
  final Color shadow;
  final Color divider;
  final Color button;

  final Color primaryScheme;
  final MaterialColor primarySwatch;
  final Color secondaryScheme;

  const ColorNest.light({
    this.brightness = Brightness.light,
    this.scaffold = const Color(0xFFf7f7f7),
    // this.focus = Colors.black12,
    // this.primary = const Color(0xFFffffff),
    this.focus = const Color(0xFFd5d5d5),
    this.splash = const Color.fromARGB(94, 118, 119, 119),
    this.primary = Colors.white,
    this.light = Colors.white,
    this.dark = Colors.black45,
    // this.dark = Colors.black38,
    // this.highlight = Colors.black38,
    this.highlight = Colors.blue,
    // this.disable = const Color.fromARGB(31, 221, 220, 220),
    this.disable = const Color(0xFFefefef),
    this.background = const Color(0xFFdbdbdb),
    this.error = const Color.fromARGB(255, 187, 43, 43),
    this.shadow = const Color(0xFFbdbdbd),
    // this.divider = const Color(0xFFbdbdbd),
    this.divider = const Color(0xFFdadada),
    this.button = const Color(0xFFdedcdc),
    this.primaryScheme = Colors.black,
    this.primarySwatch = Colors.grey,
    this.secondaryScheme = Colors.white,
  });

  const ColorNest.dark({
    this.brightness = Brightness.dark,
    this.scaffold = const Color(0xFFa6a6a6),
    // this.focus = Color.fromARGB(255, 185, 183, 183),
    this.focus = const Color.fromARGB(255, 199, 199, 199),
    this.splash = const Color.fromARGB(94, 170, 170, 170),
    this.primary = const Color(0xFF9c9c9c),
    this.light = Colors.white,
    this.dark = Colors.white70,
    // this.highlight = Colors.black54,
    this.highlight = const Color.fromARGB(255, 110, 110, 110),
    this.disable = const Color.fromARGB(31, 235, 232, 232),
    // const Color(0xFFdbdbdb),
    // this.background = const Color(0xFFbdbdbd),
    this.background = const Color(0xFF949494),
    // this.background = const Color(0xFF9c9c9c),
    // this.background = const Color.fromARGB(182, 181, 181, 0),
    // this.error = const Color.fromARGB(255, 138, 52, 52),
    this.error = const Color(0xFF604542),
    this.shadow = const Color.fromARGB(255, 116, 114, 114),
    // this.divider = const Color(0xFF8f8f8f),
    // this.divider = const Color(0xFFababab),
    this.divider = const Color(0xFF9c9a9a),
    this.button = const Color(0xFFd9d9d9),
    this.primaryScheme = Colors.white,
    this.primarySwatch = Colors.grey,
    this.secondaryScheme = Colors.white,
  });

  Color get canvas => Colors.transparent;

  // NOTE: TextSelectionMenu BackgroundColor, used in colorScheme.onSurface
  Color get menuBackgroundColor => scaffold.lighten(amount: .7);

  // NOTE: TextSelectionMenu TextColor, , used in colorScheme.surface
  Color get menuTextColor => primary.darken(amount: .5);

  // Color get focusOpacity => focus.withOpacity(0.12);

  ColorScheme get scheme {
    return ColorScheme(
      brightness: brightness,
      primary: primaryScheme,
      // primaryVariant: light,
      secondary: secondaryScheme,
      // secondaryVariant: light,
      background: background,
      surface: background.darken(),
      error: error,
      onError: focus.withOpacity(0.42),
      onPrimary: focus.withOpacity(0.32),
      onSecondary: focus.withOpacity(0.22),
      onSurface: focus.withOpacity(0.12),
      onBackground: scaffold,
    );
  }
}

abstract class ThemeNest {
  static ThemeData theme({
    required TextTheme text,
    required ColorNest color,

    /// Lato, 'Mm3Web', sans-serif
    String? fontFamily = 'Lato',
    // List<String>? fontFallback = const ['Mm3Web'],
  }) {
    // final TextTheme textTheme = Theme.of(context).textTheme.merge(_textTheme);

    return ThemeData(
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
      splashColor: color.splash,
      hoverColor: color.focus.withOpacity(0.5),
      focusColor: color.focus,

      highlightColor: color.highlight,
      disabledColor: color.disable,
      dividerColor: color.divider,

      // hoverColor: color.focus,
      // hoverColor: Colors.red,
      // indicatorColor: Colors.amber,
      // hintColor: Colors.yellow,
      // toggleableActiveColor: Colors.cyan,
      // selectedRowColor: Colors.red,
      // unselectedWidgetColor: Colors.red,

//  brightness: brightness,
//       primary: primaryScheme,
//       // primaryVariant: light,
//       secondary: primaryScheme,
//       // secondaryVariant: light,
//       background: background,
//       surface: background.darken(),
//       error: error,
//       onError: focus.withOpacity(0.42),
//       onPrimary: focus.withOpacity(0.32),
//       onSecondary: focus.withOpacity(0.22),
//       onSurface: focus.withOpacity(0.12),
//       onBackground: scaffold,
      colorScheme: color.scheme.copyWith(
        background: color.background,
        error: color.error,
        // primary: color.primary,
        // onBackground: Colors.red,
        // NOTE: TextSelectionMenu TextColor
        onSurface: color.menuBackgroundColor,
        // NOTE: TextSelectionMenu BackgroundColor
        surface: color.menuTextColor,
        // surfaceTint: Colors.red,
        // inverseSurface: Colors.red,
        // onPrimary: Colors.red,
        // onInverseSurface: Colors.red,
        // onPrimaryContainer: Colors.red,
        // onSecondary: Colors.red,
        // onSecondaryContainer: Colors.red,
        // onSurfaceVariant: Colors.red,
        // onTertiary: Colors.red,
        // onTertiaryContainer: Colors.red,
        // onBackground: Colors.red,
      ),

      cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
        brightness: color.brightness,
        // primaryContrastingColor: color.dark,
      ),
      popupMenuTheme: const PopupMenuThemeData(
          // color: Colors.red,
          ),

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
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: color.divider,
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
        // backgroundColor: Colors.transparent,
        // disabledColor: Colors.grey,
        // selectedColor: Colors.amber,
        // secondarySelectedColor: Colors.blueAccent,
        // secondarySelectedColor: Colors.red,

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
        // iconColor: color.primaryScheme.withOpacity(0.5),
        iconColor: color.dark,
        enableFeedback: true,
        selectedColor: color.highlight,
        // selectedTileColor: color.focus,
        textColor: color.primaryScheme,
      ),
      expansionTileTheme: ExpansionTileThemeData(
        collapsedIconColor: color.divider,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: color.shadow.withOpacity(0.7),
        // fillColor: Colors.red,
        hoverColor: color.shadow.withOpacity(0.5),
        focusColor: color.shadow.withOpacity(0.5),
        // hintStyle: TextStyle(
        //   color: color.primaryScheme.withOpacity(0.7),
        //   fontSize: 15,
        // ),
        // labelStyle: const TextStyle(),
        alignLabelWithHint: true,

        // suffixStyle: const TextStyle(color: Colors.red),
        // contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        contentPadding: EdgeInsets.zero,
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
        constraints: const BoxConstraints(
          maxWidth: 600,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        clipBehavior: Clip.hardEdge,
        // modalBackgroundColor: color.background,
        // modalBackgroundColor: color.light,

        modalBackgroundColor: color.primary,
        // modalBackgroundColor: Colors.red,
        modalElevation: 0.0,
        // backgroundColor: color.primary,
        // backgroundColor: color.background,
        // backgroundColor: Colors.red,
        elevation: 2.0,
      ),

      bottomAppBarTheme: const BottomAppBarTheme(
          // color: Colors.red,
          ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: color.primary,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
      ),

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
    FontWeight fontWeightNormal = FontWeight.normal,
    FontWeight fontWeightBold = FontWeight.w500,
  }) {
    return TextTheme(
      displayLarge: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightNormal,
        fontSize: 50,
      ),
      displayMedium: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightNormal,
        fontSize: 45,
      ),
      displaySmall: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightNormal,
        fontSize: 40,
      ),
      headlineLarge: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightNormal,
        fontSize: 35,
      ),
      headlineMedium: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightNormal,
        fontSize: 30,
      ),
      headlineSmall: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightNormal,
        fontSize: 25,
      ),
      // appbar-title
      titleLarge: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightBold,
        fontSize: 21,
        // height: 1.3,
      ),
      titleMedium: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightBold,
        fontSize: 19,
      ),
      titleSmall: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightBold,
        fontSize: 17,
      ),
      bodyLarge: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightNormal,
        fontSize: 23,
      ),
      bodyMedium: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightNormal,
        fontSize: 19,
      ),
      bodySmall: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightNormal,
        fontSize: 15,
      ),

      labelLarge: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightNormal,
        // fontSize: 23,
        fontSize: 20,
      ),
      labelMedium: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightNormal,
        fontSize: 18,
      ),
      labelSmall: TextStyle(
        fontFamilyFallback: fontFallback,
        fontWeight: fontWeightNormal,
        fontSize: 14,
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
