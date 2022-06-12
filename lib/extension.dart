library lidea;

// import 'dart:ui';
// import 'package:flutter/material.dart';

// .split('').reverse().join('');
// .replaceAll('0','~');
// .replaceAll('0','~').split('').reverse().join('');
extension LideaStringHackExtension on String {
  String bracketsHack({String? key}) {
    String id = this.replaceAllMapped(
      RegExp(r'\<(.*?)\>'),
      (Match i) => i.group(1).toString().split('').reversed.join(),
    );
    return (key != null && key.isNotEmpty) ? id.token(key) : id;
  }

  String gitHack({String? url}) {
    return this
        .replaceFirst('git+http', 'http')
        .replaceFirst('com+', url ?? "")
        .replaceFirst('git+', '<moc.tnetnocresubuhtig.war//:sptth>')
        .bracketsHack();
    // moc.tnetnocresubuhtig.war//:sptth
    // moc.buhtig//:sptth
  }

  String token(String key) {
    return this.replaceAll('~', key);
  }
}

extension LideaStringCasingExtension on String {
  String removeNonAlphanumeric({String joiner = ' '}) {
    return this.replaceAll(
      RegExp(r'[^\w]+'),
      joiner,
    );
  }

  String toCapitalized() {
    return length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  }

  String toTitleCase({String joiner = ' '}) {
    return replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(joiner);
  }
}

// extension LideaLocale on Locale {
//   String get nativeName {
//     switch (this.languageCode) {
//       case 'en':
//         return 'English';
//       case 'my':
//         return 'မြန်မာ';
//       case 'no':
//         return 'Norsk';
//     }
//     return 'Other';
//   }
// }

// extension LideaContext on BuildContext {
//   /// Status bar height
//   double get statusBarHeight => MediaQueryData.fromWindow(window).padding.top;

//   /// Full screen width
//   // double get screenWidget => MediaQuery.of(this).size.width;

//   /// Full screen height
//   // double get screenHeight => MediaQuery.of(this).size.height;

// //   EdgeInsets get padding => MediaQuery.of(this).viewPadding;

// // // Height (without SafeArea)
// //   double get screenHeightNoneSafeArea => screenHeight - padding.top - padding.bottom;

// // // Height (without status bar)
// //   double get screenHeightNoneStatusBar => screenHeight - padding.top;

// // // Height (without status and toolbar)
// //   double get screenHeightNoneToolbar => screenHeight - padding.top - kToolbarHeight;
// }
