import 'package:click_gift/components/custom_button.dart';
import 'package:click_gift/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';
import '../../routes/routes.dart';

class ProfileView extends StatelessWidget {
  final Rx<User?> user = Rx<User?>(null);
  final RxBool emailNotifications = true.obs;
  final RxBool smsNotifications = false.obs;

  ProfileView({Key? key}) : super(key: key);

  Future<void> loadUser() async {
    user.value = await AuthService.getUser();
  }

  @override
  Widget build(BuildContext context) {
    // Load user when the page is created
    loadUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Obx(() {
        final currentUser = user.value;

        if (currentUser == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              Text(
                "Name:",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                currentUser.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16.0),

              // Email
              Text(
                "Email:",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                currentUser.email,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16.0),

              // Address
              Text(
                "Address:",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                currentUser.address,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16.0),

              // Password
              Text(
                "Password:",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                currentUser.password,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16.0),

              // Divider
              const Divider(),

              // Notification Preferences Section
              const Text(
                "Notification Preferences",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8.0),
              Obx(() => SwitchListTile(
                    title: const Text("Email Notifications"),
                    value: emailNotifications.value,
                    onChanged: (value) {
                      emailNotifications.value = value;
                    },
                  )),
              Obx(() => SwitchListTile(
                    title: const Text("SMS Notifications"),
                    value: smsNotifications.value,
                    onChanged: (value) {
                      smsNotifications.value = value;
                    },
                  )),
              const SizedBox(height: 16.0),

              // Divider
              const Divider(),

              // Order History Section
              const Text(
                "Order History",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8.0),
              ListTile(
                leading: const Icon(Icons.shopping_bag),
                title: const Text("Order #12345"),
                subtitle: const Text("Placed on 2025-01-26"),
                onTap: () {
                  // Navigate to order details page
                  Get.toNamed(
                      '/order-details'); // Replace with your order details route
                },
              ),
              const SizedBox(height: 16.0),
              const Divider(),

              // Logout Button
              Center(
                  child: customButton(
                      buttonText: "Logout",
                      onPressed: () {
                        Get.defaultDialog(
                          title: "Logout",
                          content:
                              const Text("Are you sure you want to logout?"),
                          confirm: ElevatedButton(
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.clear();
                              Get.offAllNamed(Routes.login);
                            },
                            child: const Text("Yes"),
                          ),
                          cancel: TextButton(
                            onPressed: () {
                              Get.back(); // Close the dialog
                            },
                            child: const Text("Cancel"),
                          ),
                        );
                      })),
            ],
          ),
        );
      }),
    );
  }
}
