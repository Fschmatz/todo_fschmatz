import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget dialogAlertErrors(String error, BuildContext context) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
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