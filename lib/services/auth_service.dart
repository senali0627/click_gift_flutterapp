import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userKey = 'user';

  static Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> login(User? user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user!.toJson());
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userKey, userJson);
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;
    final Map<String, dynamic> userMap = jsonDecode(userJson);
    return User.fromJson(userMap);
  }

  static Future<bool> validateUser(String email, String password) async {
    final user = await getUser();
    if (user == null) return false;
    return user.email == email && user.password == password;
  }
}
