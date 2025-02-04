import 'package:click_gift/components/custom_button.dart';
import 'package:click_gift/components/custom_snackbar.dart';
import 'package:click_gift/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InquiriesPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final inquiryController = TextEditingController();

  InquiriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email is required';
                } else if (!GetUtils.isEmail(value.trim())) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: inquiryController,
              decoration: const InputDecoration(
                labelText: 'Inquiry/Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Message is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Center(
              child: customButton(
                buttonText: 'Submit Inquiry',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _handleSubmitInquiry();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitInquiry() {
    String name = nameController.text.trim();
    Get.offAllNamed(Routes.dashboard);

    showCustomSnackbar(
      title: 'Inquiry Submitted',
      message: 'Thank you, $name! We have received your inquiry.',
      backgroundColor: Colors.greenAccent,
    );

    nameController.clear();
    emailController.clear();
    inquiryController.clear();
  }
}
