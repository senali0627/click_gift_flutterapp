import 'package:click_gift/routes/routes.dart';
import 'package:click_gift/views/categories/categories_view.dart';
import 'package:click_gift/views/home/home_view.dart';
import 'package:click_gift/views/inquiries/inquiries.dart';
import 'package:click_gift/views/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home/home_controller.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final HomeController controller = Get.find<HomeController>();
  final RxBool isDarkTheme = false.obs;
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    CategoriesView(),
    InquiriesPage(),
    ProfileView(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradientColors = theme.brightness == Brightness.dark
        ? [Colors.grey.shade500, Colors.grey.shade600]
        : [Colors.blue.shade200, Colors.pink.shade100];

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: const Text("Click Gift"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Get.toNamed(Routes.cart);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: const AssetImage("assets/logo.png"),
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    return Text(
                      controller.userName.value,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  })
                ],
              ),
            ),
            Obx(() {
              return ListTile(
                leading: const Icon(Icons.brightness_6),
                title: const Text("Dark Mode"),
                trailing: Switch(
                  value: isDarkTheme.value,
                  onChanged: (value) {
                    isDarkTheme.value = value;
                    Get.changeTheme(
                      isDarkTheme.value ? ThemeData.dark() : ThemeData.light(),
                    );
                  },
                ),
              );
            }),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Get.defaultDialog(
                  title: "Logout",
                  content: const Text("Are you sure you want to logout?"),
                  confirm: ElevatedButton(
                    onPressed: () {
                      controller.logout();
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
              },
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black54,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: "Categories",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.question_answer),
                label: "Inquiries",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
