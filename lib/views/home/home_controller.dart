import 'dart:convert';

import 'package:click_gift/routes/routes.dart';
import 'package:click_gift/services/auth_service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../models/user.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  var categories = [].obs;
  var selectedCategory = 0.obs;
  var filteredProducts = [].obs;
  var userName = "".obs;
  var discountedProducts = <Map<String, dynamic>>[].obs;



  @override
  void onInit() {
    super.onInit();
    loadProductsFromJson();
    loadDiscountedProducts();
  }

  void loadProductsFromJson() async {
    User? user = await AuthService.getUser();
    userName.value = user!.name;
    try {
      final String jsonString =
      await rootBundle.loadString('assets/products.json');
      final Map<String, dynamic> data = json.decode(jsonString);

      categories.value = data['categories'];
      filterProducts();
    } catch (e) {
      print("Error loading JSON: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void changeCategory(int index) {
    selectedCategory.value = index;
    filterProducts();
  }

  void filterProducts() {
    filteredProducts.value =
        categories[selectedCategory.value]['products'] ?? [];
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed(Routes.login);
  }

  void loadDiscountedProducts() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.jsonbin.io/v3/b/67a319e3acd3cb34a8d89715'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Response Data: $data");  // Add this line to log the entire response

        // Check if the expected structure exists
        final products = data['record']?['discounted_products'];
        if (products != null && products is List) {
          discountedProducts.value = List<Map<String, dynamic>>.from(products);
        } else {
          print("Discounted products are empty or null.");
          discountedProducts.value = [];
        }
      } else {
        print("Failed to load discounted products, Status code: ${response.statusCode}");
        discountedProducts.value = []; // Reset if API fails
      }
    } catch (e) {
      print("Error fetching discounted products: $e");
      discountedProducts.value = []; // Reset in case of an error
    }
  }


}
