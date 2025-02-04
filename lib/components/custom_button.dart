import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget customButton({
  required String buttonText,
  required Function onPressed,
  bool isLoading = false,
  double width = 180,
  double height = 60,
}) {
  final theme = Theme.of(Get.context!);
  final buttonGradient = theme.brightness == Brightness.dark
      ? LinearGradient(
    colors: [Colors.black, Colors.grey.shade800],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  )
      : LinearGradient(
    colors: [Colors.blue.shade200, Colors.pink.shade100],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  return Container(
    padding: EdgeInsets.all(10),
    width: width,
    height: height,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        minimumSize: Size(width, height),
        shape: StadiumBorder(),
        padding: EdgeInsets.zero,
        side: BorderSide(color: Colors.transparent),
      ).copyWith(
        shadowColor: MaterialStateProperty.all(Colors.transparent),
      ),
      onPressed: isLoading ? null : () => onPressed(),
      child: Container(
        decoration: BoxDecoration(
          gradient: buttonGradient,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
          buttonText,
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}
