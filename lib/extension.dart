library lidea;

import 'package:flutter/material.dart';

// .split('').reverse().join('');
// .replaceAll('0','~');
// .replaceAll('0','~').split('').reverse().join('');
extension LideaStringExtension on String {
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
        .replaceFirst('git+', '[moc.tnetnocresubuhtig.war//:sptth]')
        .bracketsHack();
    // moc.tnetnocresubuhtig.war//:sptth
    // moc.buhtig//:sptth
  }

  String token(String key) {
    return this.replaceAll('~', key);
  }
}

extension LideaLocale on Locale {
  String get nativeName {
    switch (this.languageCode) {
      case 'en':
        return 'English';
      case 'my':
        return 'မြန်မာ';
      case 'no':
        return 'Norsk';
    }
    return 'Other';
  }
}
