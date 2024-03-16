import 'package:flutter/material.dart';

/// Text decoration
class TextDecoration extends StatelessWidget {
  final String text;
  final List<TextSpan>? decoration;

  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextScaler? textScaler;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  /// ```dart
  /// TextDecoration(
  ///   text: 'This is {{blue}} and {{red}}',
  ///   decoration: const [
  ///     TextSpan(
  ///       text: 'blue',
  ///       style: TextStyle(color: Colors.blue),
  ///     ),
  ///     TextSpan(
  ///       text: 'red',
  ///       style: TextStyle(color: Colors.red),
  ///     ),
  ///   ],
  /// );
  /// ```
  const TextDecoration({
    super.key,
    required this.text,
    this.decoration,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: _textDecoration(
          text: text,
          decoration: decoration,
        ),
      ),
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }

  /// ```dart
  /// _textDecoration(
  ///   text: 'This is {{blue}} and {{red}}',
  ///   decoration: const [
  ///     TextSpan(
  ///       text: 'blue',
  ///       style: TextStyle(color: Colors.blue),
  ///     ),
  ///     TextSpan(
  ///       text: 'red',
  ///       style: TextStyle(color: Colors.red),
  ///     ),
  ///   ],
  /// );
  /// ```
  List<InlineSpan> _textDecoration({required String text, List<TextSpan>? decoration = const []}) {
    List<TextSpan> children = [];
    text.split('{{').forEach((element) {
      if (element.contains('}}')) {
        final str = element.split('}}');
        final decorated = decoration?.firstWhere(
          (e) => e.semanticsLabel == str.first,
          orElse: () => TextSpan(
            text: str.first,
          ),
        );
        if (decorated != null) {
          children.add(decorated);
        } else {
          children.add(
            TextSpan(
              text: str.first,
            ),
          );
        }

        if (!element.endsWith('}}')) {
          children.add(TextSpan(text: str.last));
        }
      } else {
        children.add(TextSpan(text: element));
      }
    });

    return children;
  }
}
