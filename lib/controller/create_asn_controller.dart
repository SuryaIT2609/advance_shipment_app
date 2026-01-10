import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ASNItemRow {
  TextEditingController itemCode = TextEditingController();
  TextEditingController poQty = TextEditingController();
  TextEditingController poNumber = TextEditingController();
  TextEditingController asnQty = TextEditingController();
}

class CreateASNController extends GetxController {
  final supplierInvoiceNo = TextEditingController();
  final supplierInvoiceDate = TextEditingController();
  final estimatedArrivalDate = TextEditingController();
  final llrNo = TextEditingController();
  final transporter = TextEditingController();

  List<ASNItemRow> items = [];

  void addItemFromPO(Map<String, dynamic> row) {
    final item = ASNItemRow();

    item.itemCode.text = row['item_code'] ?? '';
    item.poNumber.text = row['po_no'] ?? '';
    item.poQty.text = row['po_qty'].toString();
    item.asnQty.text = row['po_qty'].toString();

    items.add(item);
    update();
  }

  void removeItem(int index) {
    items.removeAt(index);
    update();
  }
}
