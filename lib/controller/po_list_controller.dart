import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = "http://208.115.124.12:8000";

class POListController extends GetxController {
  bool loading = false;

  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> filteredItems = [];

  // ✅ Selected items
  List<Map<String, dynamic>> selectedItems = [];

  @override
  void onInit() {
    super.onInit();
    fetchPOItems();
  }

  Future<void> fetchPOItems() async {
    try {
      loading = true;
      update();

      final prefs = await SharedPreferences.getInstance();
      final sid = prefs.getString("sid");

      final res = await http.get(
        Uri.parse("$baseUrl/api/method/get_purchase_order_items"),
        headers: {"Cookie": "sid=$sid"},
      );

      final decoded = jsonDecode(res.body);
      items = List<Map<String, dynamic>>.from(decoded["message"] ?? []);
      filteredItems = List.from(items);
    } finally {
      loading = false;
      update();
    }
  }

  // ---------------- SEARCH ----------------
  void search(String value) {
    filteredItems = items.where((row) {
      return row['po_number'].toString().toLowerCase().contains(value.toLowerCase()) ||
          row['item_code'].toString().toLowerCase().contains(value.toLowerCase()) ||
          row['item_name'].toString().toLowerCase().contains(value.toLowerCase());
    }).toList();
    update();
  }

  // ---------------- SELECT / UNSELECT ----------------
  void toggleSelection(Map<String, dynamic> row) {
    if (selectedItems.contains(row)) {
      selectedItems.remove(row);
    } else {
      selectedItems.add(row);
    }
    update();
  }

  bool isSelected(Map<String, dynamic> row) {
    return selectedItems.contains(row);
  }
}

