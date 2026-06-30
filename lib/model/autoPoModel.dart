
class AutoPoItem {
  final String? rowId;
  final String autoPoId;
  final String itemCode;
  final String itemName;
  final String uom;
  final double rate;
  final double amount;
  final double binQty;
  final String storeName;
  final String supplier;
  final String supplierName;
  final String company;
  final String priceList;
  final String currency;
  final String setWarehouse;
  double? requestedQty;
  DateTime? remarksDate;

  AutoPoItem({
    required this.itemCode,
    required this.itemName,
    required this.uom,
    required this.rate,
    required this.amount,
    required this.binQty,
    required this.storeName,
    required this.supplier,
    required this.supplierName,
    required this.company,
    this.rowId,
    this.requestedQty,
    required this.priceList,
    required this.currency,
    required this.setWarehouse,
    required this.autoPoId,
    this.remarksDate,
  });

  factory AutoPoItem.fromJson(Map<String, dynamic> json) {
    return AutoPoItem(
      rowId: json['child_name'],
      autoPoId: json['auto_po_id'],
      itemCode: json['item_code'],
      itemName: json['item_name'],
      uom: json['uom'],
      rate: (json['rate'] ?? 0).toDouble(),
      amount: (json['amount'] ?? 0).toDouble(),
      binQty: (json['bin_qty'] ?? 0).toDouble(),
      requestedQty: (json['requested_qty'] ?? 0).toDouble(),
      storeName: json['store_name'],
      supplier: json['supplier'],
      supplierName: json['supplier_name'],
      company: json['company'],
      priceList: json['price_list'],
      currency: json['currency'],
      setWarehouse: json['set_warehouse'],
    );
  }
}
