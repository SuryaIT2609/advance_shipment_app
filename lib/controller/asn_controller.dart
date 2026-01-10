import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = "http://208.115.124.12:8000";

class ASNController extends GetxController {
  bool loading = true;
  List<String> asnList = [];

  @override
  void onInit() {
    super.onInit();
    fetchASNList();
  }

  Future<void> fetchASNList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sid = prefs.getString("sid");

      if (sid == null) {
        Get.offAllNamed('/auth/login');
        return;
      }

      final response = await http.get(
        Uri.parse("$baseUrl/api/method/get_asn_list"),
        headers: {
          "Content-Type": "application/json",
          "Cookie": "sid=$sid",
        },
      );

      final data = jsonDecode(response.body);

      asnList = data["message"] == null
          ? []
          : List<String>.from(
        data["message"].map((e) => e["asn_no"]),
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to load ASN list");
    }

    loading = false;
    update();
  }
}
