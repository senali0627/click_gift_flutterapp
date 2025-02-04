import 'package:click_gift/views/categories/categories_controller.dart';
import 'package:click_gift/views/home/home_controller.dart';
import 'package:get/get.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => CategoriesController());
    // Get.lazyPut(()=>HomeController());
    // Get.lazyPut(()=>HomeController());
  }
}
