import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackbar({
  required String title,
  required String message,
  Color backgroundColor = Colors.red,
  Color textColor = Colors.white,
}) {
  final theme = Theme.of(Get.context!);
  final snackBarBackgroundColor = theme.brightness == Brightness.dark
      ? backgroundColor
      : backgroundColor.withOpacity(0.8);

  Get.snackbar(
    title,
    message,
    backgroundColor: snackBarBackgroundColor,
    colorText: textColor,
    snackPosition: SnackPosition.TOP,
    margin: EdgeInsets.all(10),
    borderRadius: 10,
    duration: Duration(seconds: 3),
    icon: Icon(
      Icons.error,
      color: textColor,
    ),
  );
}
