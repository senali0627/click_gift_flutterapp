import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:click_gift/routes/routes.dart';
import 'package:click_gift/services/auth_service.dart'; // Import AuthService
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/custom_snackbar.dart';
import 'components/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isLoggedIn = await AuthService.checkLoginStatus();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  MyApp({super.key, required this.isLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Connectivity _connectivity = Connectivity();
  final Battery _battery = Battery();
  var isConnected = true.obs;
  var batteryLevel = 100.obs;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    monitorBattery();
    monitorNetwork();
  }

  void monitorNetwork() {
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      bool isOnline = results.any((result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet ||
          result == ConnectivityResult.vpn);

      isConnected.value = isOnline;

      if (!isOnline) {
        showCustomSnackbar(
          title: "Offline",
          message: "You are offline. Some features may not work.",
          backgroundColor: Colors.orange,
        );
      }
    });
  }

  void monitorBattery() {
    _battery.batteryLevel.then((level) {
      batteryLevel.value = level;
    });

    _battery.onBatteryStateChanged.listen((BatteryState state) async {
      int level = await _battery.batteryLevel;
      batteryLevel.value = level;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Click Gift',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: widget.isLoggedIn ? Routes.dashboard : Routes.login,
      getPages: Routes.routes,
      builder: (context, child) {
        return Stack(
          children: [
            child!,

            Obx(() {
              if (!isConnected.value) {
                return Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    width: MediaQuery.sizeOf(context).width,
                    color: Colors.orange,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.wifi_off, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          "You are offline",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            // Low Battery Banner
            Obx(() {
              if (batteryLevel.value < 20) {
                return Positioned(
                  top: isConnected.value ? 0 : 50,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.battery_alert, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          "Low Battery: Please charge your device",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        );
      },
    );
  }
}
