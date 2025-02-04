import 'package:battery_plus/battery_plus.dart';
import 'package:click_gift/components/custom_button.dart';
import 'package:click_gift/components/custom_snackbar.dart';
import 'package:click_gift/views/checkout/confirmation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class CheckoutPage extends StatefulWidget {
  CheckoutPage({super.key});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController recipientNameController = TextEditingController();
  final RxString selectedPaymentMethod = "Credit/Debit Card".obs;

  final Battery _battery = Battery();
  late int _batteryLevel;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _checkBatteryLevel();
  }

  Future<void> _checkBatteryLevel() async {
    _batteryLevel = await _battery.batteryLevel;

    if (_batteryLevel < 20) {
      showCustomSnackbar(
        title: "Low Battery",
        message:
            "Your battery is below 20%. Please plug in your charger to avoid interruptions during checkout.",
        backgroundColor: Colors.orangeAccent,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: recipientNameController,
              decoration: const InputDecoration(
                labelText: "Recipient Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: "Address",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Obx(() {
              return DropdownButtonFormField<String>(
                value: selectedPaymentMethod.value,
                onChanged: (value) {
                  selectedPaymentMethod.value = value!;
                },
                decoration: const InputDecoration(
                  labelText: "Payment Method",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Credit/Debit Card",
                    child: Text("Credit/Debit Card"),
                  ),
                  DropdownMenuItem(
                    value: "Cash on Delivery",
                    child: Text("Cash on Delivery"),
                  ),
                ],
              );
            }),
            const SizedBox(height: 32),
            Center(
              child: customButton(
                buttonText: "Place Order",
                onPressed: () {
                  Get.to(() => OrderConfirmationScreen(), arguments: {
                    "recipientName": recipientNameController.text,
                    "address": addressController.text,
                    "paymentMethod": selectedPaymentMethod.value,
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      showCustomSnackbar(
          title: "Permission Denied",
          message: "Please enable location permission from settings",
          backgroundColor: Colors.redAccent);
      return;
    }
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showCustomSnackbar(
          title: "Location Disabled",
          message: "Please enable location services",
          backgroundColor: Colors.redAccent);
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.best));

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      String address =
          "${placemark.name}, ${placemark.locality}, ${placemark.country}";

      addressController.text = address;
    }
  }
}
