import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return const CupertinoAlertDialog(
        content: Row(
          children: [
            Text("Loading..."),
            Spacer(),
            CircularProgressIndicator(),
          ],
        ),
      );
    },
  );
}

void hideLoading(BuildContext context) {
  try {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  } catch (e) {
    debugPrint('hideLoading error: $e');
  }
}

void showMassege(
    String massege,
    BuildContext context, {
      String? title,
      String? negativeButtonTitle,
      String? postiveButtonTitle,
      Function? postiveButtonClick,
      Function? negativeButtonClick,
    }) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: title != null ? Text(title) : null,
        content: Text(massege),
        actions: [
          if (postiveButtonTitle != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (postiveButtonClick != null) postiveButtonClick();
              },
              child: Text(postiveButtonTitle),
            ),
          if (negativeButtonTitle != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (negativeButtonClick != null) negativeButtonClick();
              },
              child: Text(negativeButtonTitle),
            ),
        ],
      );
    },
  );
}