import 'dart:io';

import 'package:click_gift/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'product_controller.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  File? _image;
  final _picker = ImagePicker();
  String? _selectedWrappingStyle;
  TextEditingController _messageController = TextEditingController();

  Future<void> _openImagePicker(ImageSource source) async {
    final XFile? pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = Get.arguments as Map<String, dynamic>;
    final ProductController controller = Get.find<ProductController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product['image'],
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product['name'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Rs ${product['price']}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product['description'],
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Quantity",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        controller.decreaseQuantity();
                      },
                    ),
                    Obx(() => Text(
                          "${controller.quantity.value}",
                          style: const TextStyle(fontSize: 18),
                        )),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        controller.increaseQuantity();
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "You can upload or capture a custom image for gift wrapping or a personalized message card.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Center(
              child: customButton(
                buttonText: "Upload a Custom Image",
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Select Image Source'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text('Capture from Camera'),
                            onTap: () {
                              Navigator.pop(context);
                              _openImagePicker(ImageSource.camera);
                            },
                          ),
                          ListTile(
                            title: const Text('Select from Gallery'),
                            onTap: () {
                              Navigator.pop(context);
                              _openImagePicker(ImageSource.gallery);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            if (_image != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _image!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            DropdownButton<String>(
              value: _selectedWrappingStyle,
              hint: const Text("Wrapping Style"),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedWrappingStyle = newValue;
                });
              },
              items: <String>['Classic', 'Luxury', 'Minimalist']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              "Enter a Custom Message (Optional)",
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Your message here",
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Center(
              child: customButton(
                buttonText: "Add to Cart",
                onPressed: () {
                  controller.addToCart(
                    product['name'],
                    product,
                    _image,
                    _selectedWrappingStyle ?? "",
                    _messageController.text,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
