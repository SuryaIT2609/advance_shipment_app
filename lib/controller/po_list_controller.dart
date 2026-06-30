import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import '../model/autoPoModel.dart';
import '../model/poPendingItemModel.dart';
import '../secure storeage.dart';
import '../service/service.dart';

class POListController extends GetxController {
  bool loading = false;

  List<PurchaseOrderItemModel> items = [];
  List<PurchaseOrderItemModel> filteredItems = [];
  List<PurchaseOrderItemModel> selectedItems = [];

  TextEditingController supplierInvoiceNumber = TextEditingController();
  TextEditingController supplierInvoiceDate = TextEditingController();
  TextEditingController estDate = TextEditingController();
  TextEditingController llrNO = TextEditingController();
  TextEditingController transportName = TextEditingController();
  List<Map<String, dynamic>> pendingDateUpdates = [];

  // initLoad() {
  //   supplierInvoiceNumber.text = "1233309";
  //   supplierInvoiceDate.text = "12.10.2026";
  //   estDate.text = "12.10.2026";
  //   llrNO.text = "12ldslw";
  //   transportName.text = "woieoejn";
  // }

  Future<void> fetchPOItems() async {
    final storage = SecureStorageService();
    String? apiKey = await storage.getApiKey();
    String? apiSecret = await storage.getApiSecret();

    try {
      loading = true;
      update();

      final prefs = await SharedPreferences.getInstance();
      final sid = prefs.getString("sid");

      final res = await http.get(
        Uri.parse("$baseUrl/api/method/get_purchase_order_items"),
        headers: {
          if (kIsWeb) "Authorization": "token $apiKey:$apiSecret",
          if (!kIsWeb) "Cookie": 'sid=$sid',
        },
      );

      final decoded = jsonDecode(res.body);

      print(res.body);
      items = (decoded["message"] as List)
          .map((e) => PurchaseOrderItemModel.fromJson(e))
          .toList();

      filteredItems = List.from(items);
    } finally {
      loading = false;
      update();
    }
  }

  // ---------------- SEARCH ----------------
  void search(String value) {
    filteredItems = items.where((row) {
      return row.poNumber.toString().toLowerCase().contains(
            value.toLowerCase(),
          ) ||
          row.itemCode.toString().toLowerCase().contains(value.toLowerCase()) ||
          row.itemName.toString().toLowerCase().contains(value.toLowerCase());
    }).toList();
    update();
  }

  // ---------------- SELECT / UNSELECT ----------------
  void toggleSelection(PurchaseOrderItemModel row) {
    if (selectedItems.contains(row)) {
      selectedItems.remove(row);
    } else {
      selectedItems.add(row);
    }
    update();
  }

  void removeSelection(PurchaseOrderItemModel row) {
    if (selectedItems.contains(row)) {
      selectedItems.remove(row);
      update();
    }
  }

  void clearSelection() {
    selectedItems.clear();
    update();
  }

  bool isSelected(PurchaseOrderItemModel row) {
    return selectedItems.contains(row);
  }

  Future<bool> createASN(List<PurchaseOrderItemModel> asnList) async {
    String? value = await AutoPoService().createASN(
      company: asnList[0].company ?? "",
      supplier: asnList[0].supplier ?? "",
      buyingPriceList: asnList[0].buyingPriceList ?? "",
      currency: asnList[0].currency ?? "",
      supplierInvoiceNo: supplierInvoiceNumber.text,
      supplierInvoiceDate: supplierInvoiceDate.text,
      estimatedArrivalDate: estDate.text,
      items: asnList,
      llr: llrNO.text,
      transporter: transportName.text,
    );
    clearSelection();

    print(value);
    if (value != null) {
      return true;
    }
    return false;
  }

  Future<void> updateDispatchDate({
    required List<Map<String, dynamic>> items,
  }) async {
    loading = true;
    update();

    bool value = await AutoPoService().updatePoItemCustomDate(items: items);

    loading = false;
    update();

    if (value) {
      clearSelection();
      await fetchPOItems();
      Get.snackbar(
        "Success",
        "Dispatch Date Updated Successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } else {
      clearSelection();
      Get.snackbar(
        "Error",
        "Failed to Update Dispatch Date",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }
}
