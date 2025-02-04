import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends GetxController {
  var cart = <String, dynamic>{}.obs;
  var totalPrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final existingCart = prefs.getString('cart');
    if (existingCart != null) {
      cart.value = jsonDecode(existingCart);
      calculateTotalPrice();
    }
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cart', jsonEncode(cart.value));
  }

  void increaseQuantity(String productId) {
    if (cart.containsKey(productId)) {
      cart[productId]['quantity']++;

      cart.refresh();
      calculateTotalPrice();
      saveCart();
    }
  }

  void decreaseQuantity(String productId) {
    if (cart.containsKey(productId) && cart[productId]['quantity'] > 1) {
      cart[productId]['quantity']--;
      cart.refresh();
      calculateTotalPrice();
      saveCart();
    }
  }

  void removeItem(String productId) {
    if (cart.containsKey(productId)) {
      cart.remove(productId);
      cart.refresh();
      calculateTotalPrice();
      saveCart();
    }
  }

  void calculateTotalPrice() {
    totalPrice.value = 0.0;
    cart.forEach((key, value) {
      totalPrice.value += value['product']['price'] * value['quantity'];
    });
  }
}
