import 'dart:io';

import 'package:click_gift/components/custom_button.dart';
import 'package:click_gift/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'cart_controller.dart';

class CartView extends StatelessWidget {
  final CartController controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.cart.isEmpty) {
          return const Center(
            child: Text(
              "Your cart is empty",
              style: TextStyle(fontSize: 18),
            ),
          );
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.cart.length,
                itemBuilder: (context, index) {
                  final productId = controller.cart.keys.toList()[index];
                  final cartItem = controller.cart[productId];
                  final product = cartItem['product'];
                  final customImage = cartItem['customImage'];
                  final wrappingStyle = cartItem['wrappingStyle'];
                  final customMessage = cartItem['customMessage'];

                  // Use RxBool to track expanded state per item
                  RxBool isExpanded = false.obs;

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              product['image'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(product['name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Rs ${product['price']}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Quantity: ${cartItem['quantity']}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  controller.decreaseQuantity(productId);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  controller.increaseQuantity(productId);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  controller.removeItem(productId);
                                },
                              ),
                            ],
                          ),
                        ),
                        Obx(() {
                          List<Widget> expandedWidgets = [];
                          if (isExpanded.value) {
                            expandedWidgets.add(const SizedBox(height: 8));
                            if (customImage != null) {
                              expandedWidgets.add(
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(customImage),
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            }
                            expandedWidgets.add(const SizedBox(height: 8));
                            expandedWidgets.add(
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "Wrapping Style: $wrappingStyle",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            );
                            expandedWidgets.add(
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "Custom Message: $customMessage",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            );
                          }
                          // Add the "Show More" or "Show Less" button
                          expandedWidgets.add(
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: TextButton(
                                onPressed: () {
                                  isExpanded.value = !isExpanded.value;
                                },
                                child: Text(isExpanded.value
                                    ? "Show Less"
                                    : "Show More"),
                              ),
                            ),
                          );
                          return Column(
                            children: expandedWidgets,
                          );
                        }),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Obx(
                    () => Text(
                      "Rs ${controller.totalPrice.value.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
              child: SizedBox(
                width: double.infinity,
                child: customButton(
                  buttonText: "Proceed to Checkout",
                  onPressed: () {
                    Get.toNamed(Routes.checkout);
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
