import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:po_asn_app/AuthService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../constant.dart';
import '../secure storeage.dart';

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

  // void _setLoading(bool value) {
  //   loading = value;
  //   update();
  // }
  //
  // Future<void> login() async {
  //   if (!formKey.currentState!.validate()) return;
  //
  //   _setLoading(true);
  //
  //   try {
  //     final result = await _performLogin();
  //
  //     if (result == null) {
  //       throw Exception("Login failed");
  //     }
  //
  //     // Save common data
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setString("userId", emailController.text.trim());
  //
  //     Get.offAllNamed('/po-cart');
  //   } catch (e) {
  //     print(e);
  //     Get.snackbar("Login Failed", "Invalid username or password");
  //   }
  //
  //   _setLoading(false);
  // }
  //
  // Future<Map<String, dynamic>?> _performLogin() async {
  //   final email = emailController.text.trim();
  //   final password = passwordController.text.trim();
  //
  //   if (kIsWeb) {
  //     // 🔹 API KEY LOGIN
  //     final res = await http.post(
  //       Uri.parse(
  //         "$baseUrl/api/method/my_api_app.api_methods.asn_web_call.get_api_credentials",
  //       ),
  //       headers: {"Content-Type": "application/x-www-form-urlencoded"},
  //       body: {"email": email, "password": password},
  //     );
  //
  //     if (res.statusCode != 200) return null;
  //
  //     final data = jsonDecode(res.body);
  //
  //     final apiKey = data["message"]["api_key"];
  //     final apiSecret = data["message"]["api_secret"];
  //
  //     await SecureStorageService().saveCredentials(apiKey, apiSecret);
  //
  //     return {"type": "api", "apiKey": apiKey, "apiSecret": apiSecret};
  //   } else {
  //     // 🔹 SESSION LOGIN
  //     final res = await http.post(
  //       Uri.parse("$baseUrl/api/method/login"),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({"usr": email, "pwd": password}),
  //     );
  //
  //     if (res.statusCode != 200 || res.headers['set-cookie'] == null) {
  //       return null;
  //     }
  //
  //     final sid = res.headers['set-cookie']!
  //         .split(',')
  //         .firstWhere((c) => c.trim().startsWith('sid='))
  //         .split('sid=')[1]
  //         .split(';')[0];
  //
  //     await SharedPreferences.getInstance().then(
  //       (prefs) => prefs.setString("sid", sid),
  //     );
  //
  //     AuthService.sessionId = sid;
  //     return {"type": "session", "sid": sid};
  //   }
  // }

  Future<void> login() async {
    if (kIsWeb) {
      await webLogin();
    } else {
      await loginNormal();
    }
  }

  Future<void> loginNormal() async {
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
        // print("trim ; ${emailController.text.trim()}");
        print(emailController.text);
        await prefs.setString("userId", emailController.text.trim());
        AuthService.sessionId = sid;
        loading = false;
        update();
        Get.offAllNamed('/po-cart');
        return;
      }
      Get.snackbar("Login Failed", "Invalid username or password");
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Unable to connect to ERPNext");
    }
    loading = false;
    update();
  }

  Future<void> webLogin() async {
    if (!formKey.currentState!.validate()) return;
    loading = true;
    update();

    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    // print("email ${email}");
    // print("pass $password");
    final storage = SecureStorageService();

    final response = await http.post(
      Uri.parse(
        "$baseUrl/api/method/my_api_app.api_methods.asn_web_call.get_api_credentials",
      ),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {"email": email, "password": password},
    );

    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final apiKey = data["message"]["api_key"];
      final apiSecret = data["message"]["api_secret"];

      await storage.saveCredentials(apiKey, apiSecret);
      storage.getApiKey();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("userId", emailController.text.trim());
      loading = false;
      update();
      print("Saved API Key & Secret");
      Get.offAllNamed('/po-cart');
    } else {
      loading = false;
      update();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final storage = SecureStorageService();
    final sid = prefs.getString("sid");

    if (kIsWeb) {
      await storage.removeKey();
      await storage.removeSecret();
      Get.offAllNamed('/auth/login');
    } else {
      if (sid != null) {
        await http.get(
          Uri.parse("$baseUrl/api/method/logout"),
          headers: {"Cookie": "sid=$sid"},
        );
      }
      await prefs.clear();
      AuthService.sessionId = null;
      Get.offAllNamed('/auth/login');
    }
  }
}
