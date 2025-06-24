import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showLoading(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        content: Row(
          children: [
            Text("Loading"),
            Spacer(),
            CircularProgressIndicator(),
          ],
        ),
      );
    },
  );
}

hideLoading(BuildContext context) {
  Navigator.pop(context);
}

showMassege(String massege, BuildContext context,
    {String? title,
    String? negativeButtonTitle,
    String? postiveButtonTitle,
    Function? postiveButtonClick,
    Function? negativeButtonClick}) {
  showDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: title == null ? null : Text(title),
        content: Column(
          children: [
            Text("$massege"),
            SizedBox(
              width: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (postiveButtonTitle != null)
                  TextButton(
                    onPressed: () {
                      if (postiveButtonClick != null) postiveButtonClick!();
                      hideLoading(context);
                    },
                    child: postiveButtonTitle != null
                        ? Text('$postiveButtonTitle')
                        : Container(),
                  ),
                if (negativeButtonTitle != null)
                  TextButton(
                    onPressed: () {
                      if (negativeButtonClick != null) negativeButtonClick!();
                      hideLoading(context);
                    },
                    child: negativeButtonTitle != null
                        ? Text('$negativeButtonTitle')
                        : Container(),
                  ),
              ],
            )
          ],
        ),
      );
    },
  );
}
