class AutoPoItemReportModel {
  final String? itemCode;
  final String? itemName;
  final double binQty;
  final String? uom;
  final double rate;
  final double amount;
  final String? poNo;
  final String? poiName;
  final double packetQtyKg;
  final double packetQtyNos;
  final double boxQty;
  final double numberOfBins;
  final double conversionFactor;

  AutoPoItemReportModel({
    this.itemCode,
    this.itemName,
    required this.binQty,
    this.uom,
    required this.rate,
    required this.amount,
    this.poNo,
    this.poiName,
    required this.packetQtyKg,
    required this.packetQtyNos,
    required this.boxQty,
    required this.numberOfBins,
    required this.conversionFactor,
  });

  factory AutoPoItemReportModel.fromJson(Map<String, dynamic> json) {
    return AutoPoItemReportModel(
      itemCode: json['item_code'],
      itemName: json['item_name'],
      binQty: (json['bin_qty'] ?? 0).toDouble(),
      uom: json['uom'],
      rate: (json['rate'] ?? 0).toDouble(),
      amount: (json['amount'] ?? 0).toDouble(),
      poNo: json['po_no'],
      poiName: json['poi_name'],
      packetQtyKg: (json['packet_qtykg'] ?? 0).toDouble(),
      packetQtyNos: (json['packet_qtynos'] ?? 0).toDouble(),
      boxQty: (json['box_qty'] ?? 0).toDouble(),
      numberOfBins: (json['number_of_bins'] ?? 0).toDouble(),
      conversionFactor:
      (json['convertion_factor'] ?? 1).toDouble(), // backend typo
    );
  }
}
