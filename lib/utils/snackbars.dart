import 'package:flutter/material.dart';

void openSnackbar(context, snackMessage) {
  final snackbar = SnackBar(
    duration: const Duration(seconds: 1),
    content: Container(
      alignment: Alignment.centerLeft,
      height: 40,
      child: Text(
        snackMessage,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    ),
    action: SnackBarAction(
      label: 'Ok',
      textColor: Colors.white,
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
