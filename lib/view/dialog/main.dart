import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// Future<bool?> doConfirmWithWidget({
//   required BuildContext context,
//   required Widget child,
//   String? barrierLabel,
//   bool barrierDismissible = true,
//   bool useRootNavigator = true,
//   RouteSettings? routeSettings,
// }) {
//   if (kIsWeb || Platform.isAndroid) {
//     return showDialog<bool?>(
//       context: context,
//       barrierLabel: barrierLabel,
//       barrierDismissible: barrierDismissible,
//       useRootNavigator: useRootNavigator,
//       routeSettings: routeSettings,
//       useSafeArea: true,
//       barrierColor: Theme.of(context).shadowColor.withOpacity(0.5),
//       builder: (BuildContext context) => child,
//     );
//   }
//   return showCupertinoDialog<bool?>(
//     context: context,
//     barrierLabel: barrierLabel,
//     barrierDismissible: barrierDismissible,
//     useRootNavigator: useRootNavigator,
//     routeSettings: routeSettings,
//     builder: (BuildContext context) => child,
//   );
// }
Future<bool?> doConfirmWithWidget({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  String? barrierLabel,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) {
  if (kIsWeb || Platform.isAndroid) {
    return showDialog<bool?>(
      context: context,
      barrierLabel: barrierLabel,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      useSafeArea: true,
      barrierColor: Theme.of(context).shadowColor.withOpacity(0.5),
      builder: builder,
    );
  }
  return showCupertinoDialog<bool?>(
    context: context,
    barrierLabel: barrierLabel,
    barrierDismissible: barrierDismissible,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    builder: builder,
  );
}

Future<bool?> doConfirmWithSimple({
  required BuildContext context,
  required String message,
  String title = 'Confirm',
}) {
  if (kIsWeb || Platform.isAndroid) {
    return doConfirmWithWidget(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          // contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
          actionsPadding: EdgeInsets.zero,
          actionsAlignment: MainAxisAlignment.spaceAround,
        );
      },
    );
  }
  return doConfirmWithWidget(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        content: Text(
          message,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      );
    },
  );
}

Future<bool?> doConfirmWithDialog({
  required BuildContext context,
  required String message,
  String title = 'Confirm',
  String cancel = 'Cancel',
  String confirm = 'Confirm',
}) {
  // if (kIsWeb) {
  //   debugPrint('HelloWorld');
  //   return Future.value(false);
  // }
  if (kIsWeb || Platform.isAndroid) {
    return showDialog<bool?>(
      context: context,
      useSafeArea: true,
      barrierColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
      // barrierColor: Theme.of(context).shadowColor.withOpacity(0.8),
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
        actionsPadding: EdgeInsets.zero,
        // buttonPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: <Widget>[
          CupertinoButton(
            child: Text(
              cancel,
              style: DefaultTextStyle.of(context).style,
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CupertinoButton(
            child: Text(
              confirm,
              style: DefaultTextStyle.of(context).style.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
            // Navigator.of(context, rootNavigator: true).pop(false)
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  return showCupertinoDialog<bool?>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      content: Text(
        message,
        style: Theme.of(context).textTheme.labelLarge,
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          // isDefaultAction: true,
          // isDestructiveAction: true,
          child: Text(cancel),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        CupertinoDialogAction(
          // isDefaultAction: true,
          isDestructiveAction: true,
          child: Text(confirm),
          // Navigator.of(context, rootNavigator: true).pop(false)
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}
