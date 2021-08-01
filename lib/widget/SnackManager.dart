import 'package:flutter/material.dart';

class SnackBarManager {
  static void showSnackBar(BuildContext context, String message, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xFF53256E),
        action: SnackBarAction(
          label: action,
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}