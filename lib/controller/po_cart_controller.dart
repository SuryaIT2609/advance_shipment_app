import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = "http://208.115.124.12:8000";

class POListController extends GetxController {
  bool loading = false;

  /// full data from API
  List<Map<String, dynamic>> items = [];

  /// filtered list for search
  List<Map<String, dynamic>> filteredItems = [];

  /// selected rows
  final List<Map<String, dynamic>> selectedItems = [];

  @override
  void onInit() {
    super.onInit();
    fetchPOItems();
  }

  // ================= FETCH PO ITEMS =================
  Future<void> fetchPOItems() async {
    try {
      loading = true;
      update();

      final prefs = await SharedPreferences.getInstance();
      final sid = prefs.getString("sid");

      if (sid == null) {
        Get.snackbar("Error", "Session expired");
        return;
      }

      final res = await http.get(
        Uri.parse("$baseUrl/api/method/get_purchase_order_items"),
        headers: {"Cookie": "sid=$sid"},
      );

      final decoded = jsonDecode(res.body);
      final List list = decoded['message'] ?? [];

      items = list.map<Map<String, dynamic>>((e) {
        return {
          "po_number": e["po_number"],
          "item_code": e["item_code"],
          "item_name": e["item_name"],
          "pending_qty": e["pending_qty"],
        };
      }).toList();

      filteredItems = List.from(items);
      selectedItems.clear();
    } catch (e) {
      Get.snackbar("Error", "Failed to load PO items");
    }

    loading = false;
    update();
  }

  // ================= SEARCH =================
  void search(String text) {
    if (text.isEmpty) {
      filteredItems = List.from(items);
    } else {
      final q = text.toLowerCase();
      filteredItems = items.where((row) {
        return row["po_number"].toLowerCase().contains(q) ||
            row["item_code"].toLowerCase().contains(q) ||
            row["item_name"].toLowerCase().contains(q);
      }).toList();
    }
    update();
  }

  // ================= SELECTION =================
  bool isSelected(Map<String, dynamic> row) {
    return selectedItems.any((e) =>
    e["po_number"] == row["po_number"] &&
        e["item_code"] == row["item_code"]);
  }

  void toggleSelection(Map<String, dynamic> row) {
    if (isSelected(row)) {
      selectedItems.removeWhere((e) =>
      e["po_number"] == row["po_number"] &&
          e["item_code"] == row["item_code"]);
    } else {
      selectedItems.add(row);
    }
    update();
  }
}
