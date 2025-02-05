import 'dart:convert';
import 'package:click_gift/components/custom_button.dart';
import 'package:click_gift/components/custom_snackbar.dart';
import 'package:click_gift/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:connectivity_plus/connectivity_plus.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  ReviewPageState createState() => ReviewPageState();
}

class ReviewPageState extends State<ReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();

  List<Map<String, String>> reviews = [];

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedReviews = prefs.getString('reviews');

    if (storedReviews != null) {
      setState(() {
        reviews = List<Map<String, String>>.from(json.decode(storedReviews));
      });
    } else {
      // Check connectivity
      var connectivityResults = await Connectivity().checkConnectivity();
      if (connectivityResults.contains(ConnectivityResult.none)) {
        _loadFromLocalJson();
      }
    }
  }

  Future<void> _loadFromLocalJson() async {
    try {
      String jsonString = await rootBundle.loadString('assets/reviews.json');
      List<dynamic> jsonData = json.decode(jsonString);

      setState(() {
        reviews = jsonData.map((e) => Map<String, String>.from(e)).toList();
      });
    } catch (e) {
      debugPrint("Error loading JSON: $e");
    }
  }

  Future<void> _saveReview() async {
    if (_formKey.currentState!.validate()) {
      String name = nameController.text.trim();
      String review = reviewController.text.trim();

      Map<String, String> newReview = {
        "name": name,
        "review": review,
      };

      setState(() {
        reviews.add(newReview);
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('reviews', json.encode(reviews));

      showCustomSnackbar(
        title: 'Review Submitted',
        message: 'Thank you, $name! We appreciate your feedback.',
        backgroundColor: Colors.greenAccent,
      );

      // Clear input fields
      nameController.clear();
      reviewController.clear();

      // Delay before navigating
      await Future.delayed(const Duration(seconds: 2));

      Get.offAllNamed(Routes.dashboard);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit a Review')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: reviewController,
                    decoration: const InputDecoration(
                      labelText: 'Review/Feedback',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Review is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: customButton(
                      buttonText: 'Submit Review',
                      onPressed: _saveReview,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Previous Reviews:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(reviews[index]['name'] ?? ''),
                      subtitle: Text(reviews[index]['review'] ?? ''),
                    ),
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