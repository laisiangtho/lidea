import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool?> doConfirmWithDialog({
  required BuildContext context,
  required String message,
  String? cancel = 'Cancel',
  String? confirm = 'Confirm',
}) async {
  if (!Platform.isIOS) {
    return await showDialog<bool?>(
      context: context,
      useSafeArea: false,
      barrierColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
      builder: (BuildContext context) => AlertDialog(
        content: Text(message),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        actions: <Widget>[
          CupertinoButton(
            // color: Theme.of(context).scaffoldBackgroundColor,
            // padding: const EdgeInsets.symmetric(horizontal:12, vertical:7),
            // minSize: 10,
            child: Text(cancel!),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CupertinoButton(
            // color: Theme.of(context).splashColor,
            // padding: const EdgeInsets.symmetric(horizontal:12, vertical:7),
            // minSize: 10,
            child: Text(confirm!),
            // Navigator.of(context, rootNavigator: true).pop(false)
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }
  return await showCupertinoDialog<bool?>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      content: Text(message),
      actions: <Widget>[
        CupertinoDialogAction(
          // isDefaultAction: true,
          child: Text(cancel!),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text(confirm!),
          // Navigator.of(context, rootNavigator: true).pop(false)
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}
