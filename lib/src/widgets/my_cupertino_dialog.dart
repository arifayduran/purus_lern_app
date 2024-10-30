import 'package:flutter/cupertino.dart';

void myCupertinoDialog(
  BuildContext context,
  String? title,
  String description,
  Widget? widget1,
  Widget? widget2,
  String cancel,
  String confirm,
  Function fCancel,
  Function fConfirm,
) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context1) {
      return StatefulBuilder(
        builder: (context2, setDialogState) {
          return CupertinoAlertDialog(
            title: title != null ? Text(title) : null,
            content: Column(
              children: [
                Text(
                  description,
                ),
                widget1 ?? SizedBox(),
                widget2 ?? SizedBox(),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context1);
                  fCancel();
                },
                child: Text(
                  cancel,
                  style: TextStyle(color: CupertinoColors.destructiveRed),
                ),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context1);
                  fConfirm();
                },
                child: Text(
                  confirm,
                  style: TextStyle(color: CupertinoColors.activeBlue),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
