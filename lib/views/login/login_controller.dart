import 'package:click_gift/components/custom_snackbar.dart';
import 'package:click_gift/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/auth_service.dart';

class LoginController extends GetxController {
  final email = TextEditingController();
  final password = TextEditingController();
  var isLoading = false.obs;

  login() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      showCustomSnackbar(
          title: "Error",
          message: "Fields cannot be empty",
          backgroundColor: Colors.redAccent);
      return;
    }
    isLoading.value = true;
    bool isValidUser =
        await AuthService.validateUser(email.text, password.text);
    if (isValidUser) {
      await AuthService.login(await AuthService.getUser());
      Get.offAllNamed(Routes.dashboard);
    } else {
      showCustomSnackbar(
          title: "Error",
          message: "Invalid email or password",
          backgroundColor: Colors.redAccent);
    }
    isLoading.value = false;
  }
}
