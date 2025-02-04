import 'package:click_gift/views/cart/cart_binding.dart';
import 'package:click_gift/views/cart/cart_view.dart';
import 'package:click_gift/views/categories/categories_binding.dart';
import 'package:click_gift/views/categories/categories_view.dart';
import 'package:click_gift/views/checkout/checkout_view.dart';
import 'package:click_gift/views/checkout/confirmation.dart';
import 'package:click_gift/views/dashboard/dashboard.dart';
import 'package:click_gift/views/dashboard/dashboard_binding.dart';
import 'package:click_gift/views/home/home_binding.dart';
import 'package:click_gift/views/home/home_view.dart';
import 'package:click_gift/views/inquiries/inquiries.dart';
import 'package:click_gift/views/product/product_binding.dart';
import 'package:click_gift/views/product/product_view.dart';
import 'package:click_gift/views/register/register_binding.dart';
import 'package:click_gift/views/register/register_view.dart';
import 'package:get/get.dart';

import '../views/login/login_binding.dart';
import '../views/login/login_view.dart';

class Routes {
  static const String login = "/login_page";
  static const String registration = "/registration_page";
  static const String dashboard = "/dashboard_page";
  static const String home = "/home_page";
  static const String categories = "/categories_page";
  static const String product = "/product_page";
  static const String cart = "/cart_page";
  static const String checkout = "/checkout_page";
  static const String confirmation = "/confirmation_page";
  static const String inquiries = "/inquiries_page";

  static final routes = [
    GetPage(
      name: Routes.login,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
        name: Routes.registration,
        page: () => RegistrationPage(),
        binding: RegisterBinding()),
    GetPage(
        name: Routes.dashboard,
        page: () => DashboardPage(),
        binding: DashboardBinding()),
    GetPage(name: Routes.home, page: () => HomePage(), binding: HomeBinding()),
    GetPage(
        name: Routes.categories,
        page: () => CategoriesView(),
        binding: CategoriesBinding()),
    GetPage(
        name: Routes.product,
        page: () => ProductPage(),
        binding: ProductBinding()),
    GetPage(name: Routes.cart, page: () => CartView(), binding: CartBinding()),
    GetPage(
      name: Routes.checkout,
      page: () => CheckoutPage(),
    ),
    GetPage(
      name: Routes.confirmation,
      page: () => OrderConfirmationScreen(),
    ),
    GetPage(
      name: Routes.inquiries,
      page: () => InquiriesPage(),
    ),
  ];
}
