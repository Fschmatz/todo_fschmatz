import 'package:flutter/material.dart';

Widget dialogAlertErrors(String error, BuildContext context) {
  return AlertDialog(
    title: const Text(
      "Error",
    ),
    content: Text(
      error,
    ),
    actions: [
      TextButton(
        child: const Text(
          "Ok",
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )
    ],
  );
}