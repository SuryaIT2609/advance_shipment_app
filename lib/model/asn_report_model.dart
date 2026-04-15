// class ASNItemReportModel {
//   final String asnNo;
//   final String? supplierInvoiceNo;
//   final String? supplierInvoiceDate;
//   final String? estimatedArrivalDate;
//   final String? llr;
//   final String? transporter;
//
//   final String? item;
//   final String? itemName;
//   final double qty;
//   final String? uom;
//   final double? unitRate;
//   final double rate;
//   final double amount;
//   final String? poNo;
//   final String? poiName;
//   final double conversionFactor;
//   final int completed;
//
//   ASNItemReportModel({
//     required this.asnNo,
//     this.supplierInvoiceNo,
//     this.supplierInvoiceDate,
//     this.estimatedArrivalDate,
//     this.llr,
//     this.transporter,
//     this.item,
//     this.itemName,
//     required this.qty,
//     this.uom,
//     this.unitRate,
//     required this.rate,
//     required this.amount,
//     this.poNo,
//     this.poiName,
//     required this.conversionFactor,
//     required this.completed,
//   });
//
//   factory ASNItemReportModel.fromJson(Map<String, dynamic> json) {
//     return ASNItemReportModel(
//       asnNo: json['asn_no'],
//       supplierInvoiceNo: json['supplier_invoice_no'],
//       supplierInvoiceDate: json['supplier_invoice_date'],
//       estimatedArrivalDate: json['estimated_arrival_date'],
//       llr: json['llr'],
//       transporter: json['transporter'],
//       item: json['item'],
//       itemName: json['item_name'],
//       qty: (json['qty'] ?? 0).toDouble(),
//       uom: json['uom'],
//       unitRate: json['unit_rate'] != null
//           ? (json['unit_rate']).toDouble()
//           : null,
//       rate: (json['rate'] ?? 0).toDouble(),
//       amount: (json['amount'] ?? 0).toDouble(),
//       poNo: json['po_no'],
//       poiName: json['poi_name'],
//       completed: (json['completed'] ?? 0).toInt(),
//       conversionFactor: (json['convertion_factor'] ?? 1)
//           .toDouble(), // backend typo
//     );
//   }
// }

class ASNModel {
  final String asnNo;
  final String? supplierInvoiceNo;
  final String? supplierInvoiceDate;
  final String? estimatedArrivalDate;
  final String? llr;
  final String? transporter;
  final int completed;
  final List<ASNItem> items;

  ASNModel({
    required this.asnNo,
    this.supplierInvoiceNo,
    this.supplierInvoiceDate,
    this.estimatedArrivalDate,
    this.llr,
    this.transporter,
    required this.completed,
    required this.items,
  });

  factory ASNModel.fromJson(Map<String, dynamic> json) {
    return ASNModel(
      asnNo: json['asn_no'],
      supplierInvoiceNo: json['supplier_invoice_no'],
      supplierInvoiceDate: json['supplier_invoice_date'],
      estimatedArrivalDate: json['estimated_arrival_date'],
      llr: json['llr'],
      transporter: json['transporter'],
      completed: json['completed'] ?? 0,
      items: (json['items'] as List).map((e) => ASNItem.fromJson(e)).toList(),
    );
  }
}

class ASNItem {
  final String? item;
  final String? itemName;
  final double qty;
  final String? uom;
  final double? unitRate;
  final double rate;
  final double amount;
  final String? poNo;
  final String? poiName;
  final double conversionFactor;

  ASNItem({
    this.item,
    this.itemName,
    required this.qty,
    this.uom,
    this.unitRate,
    required this.rate,
    required this.amount,
    this.poNo,
    this.poiName,
    required this.conversionFactor,
  });

  factory ASNItem.fromJson(Map<String, dynamic> json) {
    return ASNItem(
      item: json['item'],
      itemName: json['item_name'],
      qty: (json['qty'] ?? 0).toDouble(),
      uom: json['uom'],
      unitRate: json['unit_rate'] != null
          ? (json['unit_rate']).toDouble()
          : null,
      rate: (json['rate'] ?? 0).toDouble(),
      amount: (json['amount'] ?? 0).toDouble(),
      poNo: json['po_no'],
      poiName: json['poi_name'],
      conversionFactor: (json['convertion_factor'] ?? 1).toDouble(),
    );
  }
}
