import 'package:flutter/material.dart';

showDefaultDialog({
  @required BuildContext context,
  @required String title,
  @required String content,
}) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 17,
            ),
          ),
          content: SingleChildScrollView(
              child: Text(
            content,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 13,
            ),
          )),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      });
}

showErrorDialog({
  @required BuildContext context,
  String title = "Erro!",
  @required String content,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(color: Colors.red),
        ),
        content: Text(
          content,
          textAlign: TextAlign.justify,
        ),
        actions: <Widget>[
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}

showSuccessDialog({
  @required BuildContext context,
  String title = "Sucesso!",
  @required String content,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(color: Colors.green),
        ),
        content: Text(
          content,
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 16),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}
