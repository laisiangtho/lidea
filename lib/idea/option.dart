part of 'root.dart';

enum CustomTextDirection {
  localeBased,
  ltr,
  rtl,
}

// See http://en.wikipedia.org/wiki/Right-to-left
const List<String> rtlLanguages = <String>[
  'ar', // Arabic
  'fa', // Farsi
  'he', // Hebrew
  'ps', // Pashto
  'ur', // Urdu
];

// Fake locale to represent the system Locale option.
const systemLocaleOption = Locale('system');

late Locale _deviceLocale;
Locale get deviceLocale => _deviceLocale;
set deviceLocale(Locale locale) {
  _deviceLocale = locale;
}

class IdeaTheme{

  const IdeaTheme({
    required this.themeMode,
    required this.textFactor,
    required this.customTextDirection,
    this.locale,
    required this.timeDilation,
    required this.platform,
    required this.isTesting
  });

  final ThemeMode themeMode;
  final double textFactor;
  final CustomTextDirection customTextDirection;
  final Locale? locale;
  final double timeDilation;
  final TargetPlatform platform;
  final bool isTesting; // True for integration tests.

  // We use a sentinel value to indicate the system text scale option. By
  // default, return the actual text scale factor, otherwise return the
  // sentinel value.
  double textScaleFactor(BuildContext context, {bool useSentinel = false}) {
    if (textFactor == systemTextScaleFactorOption) {
      return useSentinel
          ? systemTextScaleFactorOption
          : MediaQuery.of(context).textScaleFactor;
    } else {
      return textFactor;
    }
  }

  /// Returns a text direction based on the [CustomTextDirection] setting.
  /// If it is based on locale and the locale cannot be determined, returns
  /// null.
  TextDirection? resolvedTextDirection() {
    return TextDirection.ltr;
    // switch (customTextDirection) {
    //   case CustomTextDirection.localeBased:
    //     final language = locale.countryCode!.toLowerCase();
    //     if (language.isEmpty) return null;
    //     return rtlLanguages.contains(language)
    //         ? TextDirection.rtl
    //         : TextDirection.ltr;
    //   case CustomTextDirection.rtl:
    //     return TextDirection.rtl;
    //   default:
    //     return TextDirection.ltr;
    // }
  }

  /// Returns the active [Brightness].
  Brightness get systemBrightness {
    Brightness brightness;
    switch (themeMode) {
      case ThemeMode.light:
        brightness = Brightness.light;
        break;
      case ThemeMode.dark:
        brightness = Brightness.dark;
        break;
      default:
        brightness = WidgetsBinding.instance!.window.platformBrightness;
    }
    return brightness;
  }

  /// Returns opposite of active [Brightness].
  Brightness get resolvedSystemBrightness {
    return this.systemBrightness == Brightness.dark ? Brightness.light : Brightness.dark;
  }

  /// Returns a [SystemUiOverlayStyle] based on the [ThemeMode] setting.
  /// In other words, if the theme is dark, returns light; if the theme is
  /// light, returns dark.
  // SystemUiOverlayStyle resolvedSystemUiOverlayStyle() {
  //   return this.systemBrightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
  // }

  IdeaTheme copyWith({
    ThemeMode? themeMode,
    double? textFactor,
    CustomTextDirection? customTextDirection,
    Locale? locale,
    double? timeDilation,
    TargetPlatform? platform,
    bool? isTesting,
  }) {
    return IdeaTheme(
      themeMode: themeMode ?? this.themeMode,
      textFactor: textFactor ?? this.textFactor,
      customTextDirection: customTextDirection ?? this.customTextDirection,
      locale: locale ?? this.locale,
      timeDilation: timeDilation ?? this.timeDilation,
      platform: platform ?? this.platform,
      isTesting: isTesting ?? this.isTesting,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is IdeaTheme &&
      themeMode == other.themeMode &&
      textFactor == other.textFactor &&
      customTextDirection == other.customTextDirection &&
      locale == other.locale &&
      timeDilation == other.timeDilation &&
      platform == other.platform &&
      isTesting == other.isTesting;

  @override
  int get hashCode => hashValues(
    themeMode,
    textFactor,
    customTextDirection,
    locale,
    timeDilation,
    platform,
    isTesting,
  );

  static IdeaTheme of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ModelBindingScope>();
    return scope!.modelBindingState.currentModel;
  }

  static void update(BuildContext context, IdeaTheme newModel) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ModelBindingScope>();
    scope!.modelBindingState.updateModel(newModel);
  }

  // amount range from 0.0 to 1.0

  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

}

// Applies text IdeaTheme to a widget
class ApplyTextOptions extends StatelessWidget {
  const ApplyTextOptions({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final options = IdeaTheme.of(context);
    final textDirection = options.resolvedTextDirection();
    final textScaleFactor = options.textScaleFactor(context);

    Widget widget = MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: textScaleFactor
      ),
      child: child,
    );

    return textDirection == null? widget : Directionality(textDirection: textDirection, child: widget);
  }
}
