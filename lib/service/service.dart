import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../AuthService.dart';
import '../constant.dart';
import '../model/autoPoModel.dart';
import '../model/poPendingItemModel.dart';
import '../secure storeage.dart';

class AutoPoService {
  Future<Map<String, String>?> getUserCompany({String? user}) async {
    if (AuthService.sessionId == null) {
      print("❌ No session found. Please login first.");
      return null;
    }

    final url = Uri.parse(
      "$baseUrl/api/method/my_api_app.api_methods.smart_order_po.get_company_by_userid",
    );

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Cookie": 'sid=${AuthService.sessionId!}',
      },
      body: jsonEncode({"userid": user}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch user company");
    }

    final decoded = jsonDecode(response.body);

    String v = decoded["message"][0]["company"];
    String v2 = decoded["message"][0]["supplier"];

    if (decoded["message"] == null) return null;

    return {"company": v, "supplier": v2};
  }

  Future<Map<String, String>?> getUserCompanyWeb({String? user}) async {
    final storage = SecureStorageService();
    String? apiKey = await storage.getApiKey();
    String? apiSecret = await storage.getApiSecret();

    if (apiKey == null || apiSecret == null) return null;

    final url = Uri.parse(
      "$baseUrl/api/method/my_api_app.api_methods.smart_order_po.get_company_by_userid",
    ).replace(queryParameters: {"userid": user ?? ""});

    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "token $apiKey:$apiSecret",
      },
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to fetch user company");
    }

    final decoded = jsonDecode(response.body);

    if (decoded["message"] == null || decoded["message"].isEmpty) {
      return null;
    }

    String company = decoded["message"][0]["company"];
    String supplier = decoded["message"][0]["supplier"];

    return {"company": company, "supplier": supplier};
  }

  //
  // Future<void> getItemsList() async {
  //   String? key = await storage.getApiKey();
  //   String? secret = await storage.getApiSecret();
  //
  //   // String? key = 'f8ea7974de37950';
  //   // String? secret = '14e0d546d7726e9';
  //
  //   if (key != null && secret != null) {
  //     print("key: $key");
  //     print("sec: $secret");
  //     try {
  //       String url =
  //           "$baseUrl/api/method/my_api_app.api_methods.asn_web_call.get_items";
  //       final uri = Uri.parse(url);
  //       final response = await http.get(
  //         uri,
  //         headers: {
  //           "Accept": "application/json",
  //           "Authorization": "token $key:$secret",
  //         },
  //       );
  //
  //       print("GET ORDERS RESPONSE: ${response.body}");
  //
  //       if (response.statusCode == 200) {
  //         final json = jsonDecode(response.body);
  //
  //         if (json["message"]["status"] == "success") {
  //           List data = json["message"]["data"] ?? [];
  //           print(data);
  //         }
  //       }
  //       return;
  //     } catch (e) {
  //       print("Orders fetch failed: $e");
  //       return;
  //     }
  //   } else {}
  // }

  Future<List<AutoPoItem>> getAutoPoItems({
    String? company,
    String? supplier,
    String? itemCode,
    int cartItems = 0,
  }) async {
    final storage = SecureStorageService();
    String? apiKey = await storage.getApiKey();
    String? apiSecret = await storage.getApiSecret();

    if (!kIsWeb) {
      if (AuthService.sessionId == null) {
        print("❌ No session found. Please login first.");
        return [];
      }
    }

    final url = Uri.parse(
      "$baseUrl/api/method/my_api_app.api_methods.smart_order_po.get_auto_po_items",
    );

    final Map<String, dynamic> body = {};

    if (company != null) body["company"] = company;
    if (supplier != null) body["supplier"] = supplier;
    if (itemCode != null) body["item_code"] = itemCode;
    body["added_to_cart"] = cartItems;

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        if (kIsWeb) "Authorization": "token $apiKey:$apiSecret",
        if (!kIsWeb) "Cookie": 'sid=${AuthService.sessionId!}',
      },
      body: jsonEncode(body),
    );
    response.body;
    print(response.body);

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch Auto PO items");
    }

    final decoded = jsonDecode(response.body);

    if (decoded["message"] == null) return [];

    return List<AutoPoItem>.from(
      decoded["message"].map((e) => AutoPoItem.fromJson(e)),
    );
  }

  Future<bool> updateAddedToCart({
    required String childName,
    required bool addedToCart,
    String? lastPoId,
    double? requestedQty,
  }) async {
    final storage = SecureStorageService();
    String? apiKey = await storage.getApiKey();
    String? apiSecret = await storage.getApiSecret();

    if (!kIsWeb) {
      if (AuthService.sessionId == null) {
        print("❌ No session found. Please login first.");
        return false;
      }
    }

    if (kIsWeb) {
      if (apiKey == null || apiSecret == null) {
        print("❌ No Secret and Key.");
        return false;
      }
    }

    final url = Uri.parse(
      "$baseUrl/api/method/my_api_app.api_methods.smart_order_po.update_added_to_cart",
    );

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        if (kIsWeb) "Authorization": "token $apiKey:$apiSecret",
        if (!kIsWeb) "Cookie": 'sid=${AuthService.sessionId!}',
      },
      body: jsonEncode({
        "child_name": childName,
        "added_to_cart": addedToCart ? 1 : 0,
        "last_purchase_order": lastPoId,
        "requested_qty": requestedQty,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update cart status");
    }
    print(response.body);

    final decoded = jsonDecode(response.body);
    print("mesage${decoded["message"]}");

    return decoded["message"] != null;
  }

  Future<String?> createPurchaseOrder({
    required List<AutoPoItem> orderItems,
  }) async {
    final storage = SecureStorageService();
    String? apiKey = await storage.getApiKey();
    String? apiSecret = await storage.getApiSecret();

    String formattedDate =
        "${orderItems[0].remarksDate!.year}-"
        "${orderItems[0].remarksDate!.month.toString().padLeft(2, '0')}-"
        "${orderItems[0].remarksDate!.day.toString().padLeft(2, '0')}";

    print(formattedDate);

    if (!kIsWeb) {
      if (AuthService.sessionId == null || orderItems.isEmpty) return null;
    }

    final response = await http.post(
      Uri.parse(
        "$baseUrl/api/method/my_api_app.api_methods.smart_order_po.create_purchase_order",
      ),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        if (kIsWeb) "Authorization": "token $apiKey:$apiSecret",
        if (!kIsWeb) "Cookie": 'sid=${AuthService.sessionId!}',
      },
      body: jsonEncode({
        "supplier": orderItems[0].supplier,
        "company": orderItems[0].company,
        "auto_po_id": orderItems[0].autoPoId,
        "buying_price_list": orderItems[0].priceList,
        "currency": orderItems[0].currency,
        "set_warehouse": orderItems[0].setWarehouse,
        "schedule_date": DateTime.now().toIso8601String().split('T')[0],
        "cart_items": orderItems
            .map(
              (e) => {
                "item_code": e.itemCode,
                "qty": e.requestedQty,

                // "custom_remark_date": "testing",
                // "create_purchase_order": "testing",
                // e.remarksDate != null
                //     ? "${e.remarksDate!.year}-"
                //           "${e.remarksDate!.month.toString().padLeft(2, '0')}-"
                //           "${e.remarksDate!.day.toString().padLeft(2, '0')}"
                //     : null,
                "uom": e.uom,
                "rate": e.rate,
                "custom_unit_rate": e.rate,
                "child_name": e.rowId,
                "custom_date": e.remarksDate != null
                    ? e.remarksDate!.toIso8601String().split('T')[0]
                    : "",
                // ✅ for added_to_cart update
              },
            )
            .toList(),
      }),
    );
    response.body;
    print("purch: ${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["message"]?["purchase_order"];
    }

    return null;
  }

  Future<bool> updatePoItemCustomDate({
    required List<Map<String, dynamic>> items,
  }) async {
    final storage = SecureStorageService();

    String? apiKey = await storage.getApiKey();
    String? apiSecret = await storage.getApiSecret();

    if (!kIsWeb && AuthService.sessionId == null) {
      return false;
    }

    final response = await http.post(
      Uri.parse(
        "$baseUrl/api/method/my_api_app.api_methods.smart_order_po.update_po_item_custom_date",
      ),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',

        if (kIsWeb) "Authorization": "token $apiKey:$apiSecret",

        if (!kIsWeb) "Cookie": "sid=${AuthService.sessionId!}",
      },

      body: jsonEncode({"items": items}),
    );

    print("bulk update response: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["message"]?["status"] == "success") {
        return true;
      }
    }

    return false;
  }

  Future<String?> createASN({
    String? llr,
    String? transporter,
    String? taxCategory,
    required String company,
    required String supplier,
    required String buyingPriceList,
    required String currency,
    required String supplierInvoiceNo,
    required String supplierInvoiceDate,
    required String estimatedArrivalDate,
    required List<PurchaseOrderItemModel> items,
  }) async {
    final storage = SecureStorageService();
    String? apiKey = await storage.getApiKey();
    String? apiSecret = await storage.getApiSecret();

    if (!kIsWeb) {
      if (AuthService.sessionId == null || items.isEmpty) {
        print("❌ No session found. Please login first.");
        return null;
      }
    }

    final response = await http.post(
      Uri.parse(
        "$baseUrl/api/method/my_api_app.api_methods.smart_order_po.create_advance_shipment_notice",
      ),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        if (kIsWeb) "Authorization": "token $apiKey:$apiSecret",
        if (!kIsWeb) "Cookie": 'sid=${AuthService.sessionId!}',
      },
      body: jsonEncode({
        "company": company,
        "supplier": supplier,
        "buying_price_list": buyingPriceList,
        "currency": currency,
        "supplier_invoice_no": supplierInvoiceNo,
        "supplier_invoice_date": supplierInvoiceDate,
        "estimated_arrival_date": estimatedArrivalDate,
        "llr": llr,
        "transporter": transporter,
        "tax_category": taxCategory,
        "items": items
            .map(
              (e) => {
                // 🔴 MANDATORY – MUST MATCH BACKEND
                "item_code": e.itemCode, // maps to child.item
                "qty": e.enteredQty,
                "rate": e.rate,
                "stock_uom": e.uom, // maps to child.uom
                "po_no": e.poNumber, // mandatory
                "poi_name": e.poiName,
                "stock_uom_qty": (e.conversionFactor ?? 1) * e.enteredQty,
                "convertion_factor": e.conversionFactor ?? 1,
              },
            )
            .toList(),
      }),
    );

    response.body;
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["message"]?["asn"];
    }

    return null;
  }
}
