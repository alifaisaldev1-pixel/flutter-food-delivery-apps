import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage {
  static const double _fontSize = 16.0;
  static const Toast _toastLength = Toast.LENGTH_SHORT;
  static const ToastGravity _gravity = ToastGravity.BOTTOM;
  static const int _timeInSecForIosWeb = 1;

  static void showSuccessToast(String message) {
    _showToast(message, backgroundColor: Colors.green);
  }

  static void showErrorToast(String message) {
    _showToast(message, backgroundColor: Colors.red);
  }

  static void showInfoToast(String message) {
    _showToast(message, backgroundColor: Colors.blue);
  }

  static void showWarningToast(String message) {
    _showToast(message, backgroundColor: Colors.orange);
  }

  static void showCustomToast(
    String message, {
    Color backgroundColor = Colors.grey,
    Color textColor = Colors.white,
    Toast toastLength = _toastLength,
    ToastGravity gravity = _gravity,
  }) {
    _showToast(
      message,
      backgroundColor: backgroundColor,
      textColor: textColor,
      toastLength: toastLength,
      gravity: gravity,
    );
  }

  static void _showToast(
    String message, {
    required Color backgroundColor,
    Color textColor = Colors.white,
    Toast toastLength = _toastLength,
    ToastGravity gravity = _gravity,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: _timeInSecForIosWeb,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: _fontSize,
    );
  }
}