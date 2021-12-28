import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget dialogAlertErrors(String error, BuildContext context) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    title: const Text(
      "Error",
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
    content: Text(
      error,
      style: const TextStyle(
        fontSize: 16,
      ),
    ),
    actions: [
      TextButton(
        child: const Text(
          "Ok",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )
    ],
  );
}