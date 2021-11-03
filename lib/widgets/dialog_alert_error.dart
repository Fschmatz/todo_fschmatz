import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget dialogAlertErrors(String error, BuildContext context) {
  return AlertDialog(
    title: const Text(
      "Error",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    content: Text(
      error,
      style: const TextStyle(
        fontSize: 18,
      ),
    ),
    actions: [
      TextButton(
        child: const Text(
          "Ok",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )
    ],
  );
}