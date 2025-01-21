import 'package:flutter/material.dart';

void showSnackBarMessage(
  BuildContext context,
  String message,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.green,
      content: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
  );
}
