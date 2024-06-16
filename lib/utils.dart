import 'package:flutter/cupertino.dart';

class Utils {
  static void showSheet(
    BuildContext context, {
    required Widget child,
    required VoidCallback onClicked,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            child,
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: onClicked,
            child: Text('Done'),
          ),
        );
      },
    );
  }
}
