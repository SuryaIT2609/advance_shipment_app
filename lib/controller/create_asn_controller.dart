import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../model/asn_item_row.dart';

class CreateASNController extends GetxController {
  // ================= ASN HEADER =================
  final supplierInvoiceNo = TextEditingController();
  final supplierInvoiceDate = TextEditingController();
  final estimatedArrivalDate = TextEditingController();
  final llrNo = TextEditingController();
  final transporter = TextEditingController();

  // ================= ASN ITEMS =================
  List<ASNItemRow> items = [];

  @override
  void onInit() {
    super.onInit();

    // ✅ RECEIVE DATA FROM PO LIST PAGE
    final args = Get.arguments;

    if (args != null && args is List) {
      addItemsFromPO(args);
    }
  }

  // ================= ADD ITEMS AUTOMATICALLY =================
  void addItemsFromPO(List selectedItems) {
    items.clear();

    for (var row in selectedItems) {
      final item = ASNItemRow();

      item.itemCode.text = row['item_code'] ?? '';
      item.poNumber.text = row['po_number'] ?? '';
      item.poQty.text = row['pending_qty'].toString();
      item.asnQty.text = row['pending_qty'].toString(); // default ASN qty

      items.add(item);
    }

    update();
  }

  // ================= REMOVE ITEM =================
  void removeItem(int index) {
    items.removeAt(index);
    update();
  }
}
