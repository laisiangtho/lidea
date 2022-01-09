part of 'main.dart';

Future<bool?> doConfirmWithDialog({
  required BuildContext context,
  required String message,
  String title = 'Confirm',
  String cancel = 'Cancel',
  String confirm = 'Confirm',
}) {
  if (Platform.isAndroid) {
    return showDialog<bool?>(
      context: context,
      useSafeArea: true,
      barrierColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
      builder: (BuildContext context) => AlertDialog(
        content: Text(message),
        title: Text(title),
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
                    color: Theme.of(context).errorColor,
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
        style: Theme.of(context).textTheme.bodyText1!.copyWith(),
      ),
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontSize: 15,
            ),
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
