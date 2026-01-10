import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = "http://208.115.124.12:8000";

class POPendingController extends GetxController {
  bool loading = false;

  // ✅ MUST be initialized (fixes your crash)
  List<Map<String, dynamic>> items = [];

  Future<void> loadPendingPO() async {
    try {
      loading = true;
      items = [];
      update();

      final prefs = await SharedPreferences.getInstance();
      final sid = prefs.getString("sid");

      if (sid == null) {
        Get.snackbar("Error", "Session expired");
        return;
      }

      final res = await http.get(
        Uri.parse("$baseUrl/api/method/get_po_pending_for_asn"),
        headers: {"Cookie": "sid=$sid"},
      );

      final data = jsonDecode(res.body);

      items = List<Map<String, dynamic>>.from(
        data["message"] ?? [],
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to load PO items");
    }

    loading = false;
    update();
  }
}
