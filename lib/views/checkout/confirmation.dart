import 'package:click_gift/components/custom_button.dart';
import 'package:click_gift/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderDetails = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Confirmation"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your order has been placed successfully!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text("Recipient Name: ${orderDetails['recipientName']}"),
            const SizedBox(height: 8),
            Text("Address: ${orderDetails['address']}"),
            const SizedBox(height: 8),
            Text("Payment Method: ${orderDetails['paymentMethod']}"),
            const SizedBox(height: 32),
            Center(
              child: customButton(
                buttonText: "Back to Home",
                onPressed: () {
                  Get.offAllNamed(Routes.dashboard);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
