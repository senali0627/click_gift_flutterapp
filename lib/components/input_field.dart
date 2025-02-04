import "package:flutter/material.dart";

Widget inputField({required TextEditingController controller, required String hint, bool isPassword = false}) {
  return Container(
    padding: EdgeInsets.all(10),
    child: TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: hint,
      ),
    ),
  );
}
