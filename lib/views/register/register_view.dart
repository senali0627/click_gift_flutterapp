import 'package:click_gift/components/gradient_header_text.dart';
import 'package:click_gift/views/register/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/custom_button.dart';
import '../../components/input_field.dart';

class RegistrationPage extends StatelessWidget {
  RegistrationPage({super.key});
  final RegisterController controller = Get.find<RegisterController>();

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
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  inputField(controller: controller.name, hint: "Name"),
                  inputField(controller: controller.email, hint: "Email"),
                  inputField(controller: controller.address, hint: "Address"),
                  inputField(
                    controller: controller.password,
                    hint: "Password",
                    isPassword: true,
                  ),
                  inputField(
                    controller: controller.repeatPw,
                    hint: "Repeat Password",
                    isPassword: true,
                  ),
                  customButton(
                    buttonText: "Register",
                    isLoading: false,
                    onPressed: () {
                      controller.register();
                      controller.complete ? Get.back() : null;
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
