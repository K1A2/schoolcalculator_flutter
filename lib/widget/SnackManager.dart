import 'package:flutter/material.dart';

class SnackBarManager {
  static void showSnackBar(BuildContext context, String message, String action, Duration duration, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        action: SnackBarAction(
          label: action,
          textColor: Colors.white,
          onPressed: () {},
        ),
        duration: duration,
      ),
    );
  }
}