import 'dart:convert';
import 'dart:io';

import 'package:click_gift/components/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductController extends GetxController {
  var cart = <String, dynamic>{}.obs;
  var quantity = 1.obs;

  void addToCart(
    String productId,
    Map<String, dynamic> productDetails,
    File? customImage,
    String wrappingStyle,
    String customMessage,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final existingCart = prefs.getString('cart');
    if (existingCart != null) {
      cart.value = jsonDecode(existingCart);
    }

    if (cart.containsKey(productId)) {
      cart[productId]['quantity'] += quantity.value;
    } else {
      cart[productId] = {
        'product': productDetails,
        'quantity': quantity.value,
        'customImage': customImage?.path,
        'wrappingStyle': wrappingStyle,
        'customMessage': customMessage,
      };
    }

    prefs.setString('cart', jsonEncode(cart.value));
    Get.back();
    showCustomSnackbar(
      title: "Success",
      message: "${productDetails['name']} added to the cart!",
      backgroundColor: Colors.greenAccent,
    );
  }

  void increaseQuantity() {
    quantity++;
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      quantity--;
    }
  }
}
