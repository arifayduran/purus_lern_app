import 'package:flutter/cupertino.dart';

void myCupertinoDialog(
  BuildContext context,
  String? title,
  String? description,
  Widget? widget1,
  Widget? widget2,
  String cancel,
  String confirm,
  Function fCancel,
  Function fConfirm,
  Color? color1,
  Color? color2,
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
                description != null
                    ? Text(
                        description,
                      )
                    : SizedBox(),
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
                  style: TextStyle(
                      color: color1 ?? CupertinoColors.destructiveRed),
                ),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context1);
                  fConfirm();
                },
                child: Text(
                  confirm,
                  style: TextStyle(color: color2 ?? CupertinoColors.activeBlue),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
