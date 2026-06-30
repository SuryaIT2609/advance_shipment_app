import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import '../model/asn_report_model.dart';
import '../secure storeage.dart';

class ASNController extends GetxController {
  bool loading = true;
  List<ASNModel> asnList = [];

  TextEditingController dateRangeController = TextEditingController();

  final TextEditingController invoiceSearchCtrl = TextEditingController();
  final TextEditingController itemSearchCtrl = TextEditingController();
  final TextEditingController itemDescSearchCtrl = TextEditingController();

  DateTimeRange? selectedRange;

  @override
  void onInit() {
    super.onInit();
    fetchASNList();
  }

  String fmt(DateTime d) {
    return "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
  }

  String displayFmt(DateTime d) {
    return "${d.day}-${d.month}-${d.year}";
  }

  Future<void> applyFilters({String? initFromDate, String? initToDate}) async {
    String? fromDate;
    String? toDate;
    if (selectedRange != null) {
      fromDate = fmt(selectedRange!.start);
      toDate = fmt(selectedRange!.end);
      dateRangeController.text =
          "${displayFmt(selectedRange!.start)} → ${displayFmt(selectedRange!.end)}";
    }
    await fetchASNList(
      itemCode: itemSearchCtrl.text,
      itemName: itemDescSearchCtrl.text,
      toDate: toDate,
      fromDate: fromDate,
      supplierInvoiceNo: invoiceSearchCtrl.text,
    );
    update();
  }

  Future<void> fetchASNList({
    String? itemCode,
    String? itemName,
    String? fromDate,
    String? toDate,
    String? supplierInvoiceNo,
  }) async {
    try {
      loading = true;
      update();

      final storage = SecureStorageService();
      String? apiKey = await storage.getApiKey();
      String? apiSecret = await storage.getApiSecret();

      final prefs = await SharedPreferences.getInstance();
      final sid = prefs.getString("sid");

      if (!kIsWeb) {
        if (sid == null) {
          print("❌ No session found. Please login first.");
          return;
        }
      }

      final Map<String, String> queryParams = {};

      if (itemCode != null && itemCode.trim().isNotEmpty) {
        queryParams["item"] = itemCode.trim();
      }

      if (supplierInvoiceNo != null && supplierInvoiceNo.trim().isNotEmpty) {
        queryParams["supplier_invoice_no"] = supplierInvoiceNo.trim();
      }

      if (itemName != null && itemName.trim().isNotEmpty) {
        queryParams["item_name"] = itemName.trim();
      }

      if (fromDate != null && fromDate.isNotEmpty) {
        queryParams["from_date"] = fromDate;
      }

      if (toDate != null && toDate.isNotEmpty) {
        queryParams["to_date"] = toDate;
      }

      final uri = Uri.parse(
        "$baseUrl/api/method/my_api_app.api_methods.smart_order_po.get_asn_list_nested",
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          if (kIsWeb) "Authorization": "token $apiKey:$apiSecret",
          if (!kIsWeb) "Cookie": "sid=$sid",
        },
      );

      final decoded = jsonDecode(response.body);
      final List data = decoded["message"] ?? [];

      asnList = data.map((e) => ASNModel.fromJson(e)).toList();
      print(asnList);
      print(response.body);
    } catch (e) {
      Get.snackbar("Error", "Failed to load ASN list");
    } finally {
      loading = false;
      update();
    }
  }
}
