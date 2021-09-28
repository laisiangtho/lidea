import 'dart:convert';
import 'package:crypto/crypto.dart';

export 'package:crypto/crypto.dart';

String getMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}
