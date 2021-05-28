// import 'dart:math';
// import 'dart:io';
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';

class ViewNavigationModel {
  ViewNavigationModel({
    this.key,
    required this.name,
    required this.icon,
    // required this.screenName,
    required this.description,
    this.action
  });

  final int? key;
  // final String screenName;
  final String description;
  final String name;
  final IconData icon;
  // final void Function(BuildContext context) action;
  void Function()? action;
}
