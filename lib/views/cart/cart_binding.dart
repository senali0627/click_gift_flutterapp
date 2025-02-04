import 'package:click_gift/views/cart/cart_controller.dart';
import 'package:get/get.dart';


class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=>CartController());
  }
}