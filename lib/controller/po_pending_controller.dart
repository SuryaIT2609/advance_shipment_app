import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = "http://208.115.124.12:8000";

class POPendingController extends GetxController {
  bool loading = false;
  List<Map<String, dynamic>> items = [];

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  // ================= FETCH CART =================
  Future<void> fetchCartItems() async {
    try {
      loading = true;
      update();

      final prefs = await SharedPreferences.getInstance();
      final sid = prefs.getString("sid");

      if (sid == null) return;

      final res = await http.get(
        Uri.parse("$baseUrl/api/method/get_po_cart_items"),
        headers: {"Cookie": "sid=$sid"},
      );

      final data = jsonDecode(res.body);
      items = List<Map<String, dynamic>>.from(data['message'] ?? []);
    } catch (_) {
      Get.snackbar("Error", "Failed to load cart");
    }

    loading = false;
    update();
  }

  // ================= ACCEPT ITEM =================
  Future<void> acceptItem(String cartItemId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sid = prefs.getString("sid");

      final res = await http.post(
        Uri.parse("$baseUrl/api/method/update_po_cart_item_status"),
        headers: {
          "Content-Type": "application/json",
          "Cookie": "sid=$sid",
        },
        body: jsonEncode({"cart_item_id": cartItemId}),
      );

      final data = jsonDecode(res.body);
      if (data["message"]?["status"] == "success") {
        await fetchCartItems();
        Get.snackbar("Success", "Item Accepted");
      }
    } catch (_) {
      Get.snackbar("Error", "Server error");
    }
  }
}
