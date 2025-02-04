import 'dart:convert';

import 'package:click_gift/components/custom_snackbar.dart';
import 'package:click_gift/routes/routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';

class RegisterController extends GetxController {
  final name = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();
  final password = TextEditingController();
  final repeatPw = TextEditingController();
  bool complete = false;

  register() async {
    if (password.text != repeatPw.text) {
      password.text = "";
      repeatPw.text = "";
      showCustomSnackbar(
          title: "Error",
          message: "Passwords don't match",
          backgroundColor: Colors.redAccent);
    } else if (password.text.length < 6) {
      password.text = "";
      repeatPw.text = "";
      showCustomSnackbar(
        title: "Error",
        message: "Password must be 6 or more characters",
        backgroundColor: Colors.redAccent,
      );
    } else if (email.text.isEmpty) {
      showCustomSnackbar(
        title: "Error",
        message: "Email cannot be empty",
        backgroundColor: Colors.redAccent,
      );
    } else if (name.text.isNotEmpty &&
        address.text.isNotEmpty &&
        password.text.isNotEmpty) {
      final user = User(
          name: name.text,
          email: email.text,
          address: address.text,
          password: password.text);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(user.toJson()));
      Get.back();
      showCustomSnackbar(
          title: 'Success',
          message: 'Registration successful',
          backgroundColor: Colors.greenAccent);

    } else {
      showCustomSnackbar(
          title: 'Error',
          message: 'All fields are required',
          backgroundColor: Colors.redAccent);
    }
  }

  @override
  void onClose() {
    email.dispose();
    name.dispose();
    address.dispose();
    password.dispose();
    super.onClose();
  }
}
