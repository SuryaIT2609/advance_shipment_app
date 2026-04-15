import 'package:flutter/cupertino.dart';

class PurchaseOrderItemModel {
  String? poiName;
  String? itemCode;
  String? itemName;

  double? poQty;
  double? grnQty;
  double? transitQty;
  double? pendingQty;

  String? uom;
  String? warehouse;
  String? poNumber;
  String? currency;
  String? company;
  String? supplier;
  String? buyingPriceList;
  double? boxQty;
  double? packetQtyNos;
  double? packetQtyKg;
  String? glQty;
  double? conversionFactor;
  double? rate;

  // ✅ Editable quantity controller
  late TextEditingController editableQtyController;

  PurchaseOrderItemModel({
    this.poiName,
    this.itemCode,
    this.itemName,
    this.poQty,
    this.grnQty,
    this.transitQty,
    this.pendingQty,
    this.uom,
    this.warehouse,
    this.poNumber,
    this.currency,
    this.company,
    this.supplier,
    this.buyingPriceList,
    this.conversionFactor,
    this.rate,
    this.boxQty,
    this.glQty,
    this.packetQtyKg,
    this.packetQtyNos,
  }) {
    // ✅ Initialize controller with default pending qty
    editableQtyController = TextEditingController(
      text: (pendingQty ?? 0).toString(),
    );
  }

  factory PurchaseOrderItemModel.fromJson(Map<String, dynamic> json) {
    final pending = (json['pending_qty'] ?? 0).toDouble();

    return PurchaseOrderItemModel(
      poiName: json['poi_name'],
      itemCode: json['item_code'],
      itemName: json['item_name'],
      poQty: (json['po_qty'] ?? 0).toDouble(),
      grnQty: (json['grn_qty'] ?? 0).toDouble(),
      transitQty: (json['transit_qty'] ?? 0).toDouble(),

      boxQty: (json['custom_box_qty'] ?? 0).toDouble(),
      packetQtyNos: (json['custom_1_packet_qty_nos'] ?? 0).toDouble(),
      packetQtyKg: (json['custom_1_packet_qty_kg'] ?? 0).toDouble(),
      glQty: json['custom_gl_qty'] ?? "0",
      pendingQty: pending,
      uom: json['uom'],
      warehouse: json['warehouse'],
      poNumber: json['po_number'],
      currency: json['currency'],
      company: json['company'],
      supplier: json['supplier'],
      buyingPriceList: json['buying_price_list'],
      conversionFactor: (json['conversion_factor'] ?? 1).toDouble(),
      rate: (json['rate'] ?? 0).toDouble(),
    );
  }

  // ✅ Safe getter for entered ASN qty
  double get enteredQty {
    final val = double.tryParse(editableQtyController.text);
    if (val == null) return 0;

    // Prevent over-entry
    if (pendingQty != null && val > pendingQty!) {
      return pendingQty!;
    }
    return val;
  }

  // ✅ Call this when item is removed
  void dispose() {
    editableQtyController.dispose();
  }
}
