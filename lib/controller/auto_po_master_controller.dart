import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/asn_report_model.dart';
import '../model/auto_po_model.dart';
import '../secure storeage.dart';

const String baseUrl = "http://208.115.124.12:8000";

class AutoPoItemMasterController extends GetxController {
  bool loading = true;
  List<AutoPoItemReportModel> autoPoItemList = [];

  TextEditingController dateRangeController = TextEditingController();

  final TextEditingController invoiceSearchCtrl = TextEditingController();
  final TextEditingController itemSearchCtrl = TextEditingController();
  final TextEditingController itemDescSearchCtrl = TextEditingController();

  DateTimeRange? selectedRange;

  Future<void> fetchAutoPoItems() async {
    try {
      final storage = SecureStorageService();
      String? apiKey = await storage.getApiKey();
      String? apiSecret = await storage.getApiSecret();

      loading = true;
      update();

      final prefs = await SharedPreferences.getInstance();
      final sid = prefs.getString("sid");

      if (!kIsWeb) {
        if (sid == null) {
          return;
        }
      }

      final response = await http.get(
        Uri.parse(
          "$baseUrl/api/method/my_api_app.api_methods.smart_order_po.get_auto_po_items_master_data",
        ),
        headers: {
          if (kIsWeb) "Authorization": "token $apiKey:$apiSecret",
          if (!kIsWeb) "Cookie": "sid=$sid",
        },
      );
      final decoded = jsonDecode(response.body);
      final List data = decoded["message"] ?? [];
      autoPoItemList = data
          .map((e) => AutoPoItemReportModel.fromJson(e))
          .toList();
    } catch (e) {
      Get.snackbar("Error", "Failed to load Auto PO items");
    } finally {
      loading = false;
      update();
    }
  }
}
