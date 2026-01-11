import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = "http://208.115.124.12:8000";

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;
  bool showPassword = false;

  void togglePassword() {
    showPassword = !showPassword;
    update();
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    loading = true;
    update();

    try {
      final res = await http.post(
        Uri.parse("$baseUrl/api/method/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "usr": emailController.text.trim(),
          "pwd": passwordController.text.trim(),
        }),
      );

      if (res.statusCode == 200 && res.headers['set-cookie'] != null) {
        final sid = res.headers['set-cookie']!
            .split(',')
            .firstWhere((c) => c.trim().startsWith('sid='))
            .split('sid=')[1]
            .split(';')[0];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("sid", sid);

        loading = false;
        update();

        Get.offAllNamed('/po-cart');

        return;
      }

      Get.snackbar("Login Failed", "Invalid username or password");
    } catch (_) {
      Get.snackbar("Error", "Unable to connect to ERPNext");
    }

    loading = false;
    update();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final sid = prefs.getString("sid");

    if (sid != null) {
      await http.get(
        Uri.parse("$baseUrl/api/method/logout"),
        headers: {"Cookie": "sid=$sid"},
      );
    }

    await prefs.clear();
    Get.offAllNamed('/auth/login');
  }
}
