import 'package:click_gift/components/custom_button.dart';
import 'package:click_gift/components/gradient_header_text.dart';
import 'package:click_gift/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/input_field.dart';
import 'login_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final LoginController controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradient = theme.brightness == Brightness.dark
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


    return Scaffold(
      appBar: null,
      body: Container(
        decoration: BoxDecoration(
          gradient: gradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedGradientText(),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.6), // Semi-transparent white background
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  inputField(controller: controller.email, hint: "Email"),
                  inputField(
                    controller: controller.password,
                    hint: "Password",
                    isPassword: true,
                  ),
                  customButton(
                    buttonText: "Login",
                    isLoading: controller.isLoading.value,
                    onPressed: () {
                      controller.login();
                    },
                  ),
                  customButton(
                    buttonText: "Register",
                    isLoading: false,
                    onPressed: () {
                      Get.toNamed(Routes.registration);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
