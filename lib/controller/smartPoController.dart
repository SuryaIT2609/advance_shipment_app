import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/autoPoModel.dart';
import '../service/service.dart';

class SmartPoController extends GetxController {
  bool loading = false;
  List<AutoPoItem> autoPoItems = [];
  List<AutoPoItem> filteredAutoPoItems = [];
  String? userId;
  List<AutoPoItem> cartItemsList = [];
  List<AutoPoItem> filteredCartItemsList = [];

  List<AutoPoItem> supplierNewOrderCartList = [];
  final TextEditingController searchController = TextEditingController();
  final TextEditingController cartSearchController = TextEditingController();

  Future<void> loadUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    userId = pref.getString("userId");
    update();
  }

  void filterByItemCode(String query) {
    if (query.isEmpty) {
      filteredAutoPoItems = List.from(autoPoItems);
    } else {
      filteredAutoPoItems = autoPoItems.where((item) {
        return item.itemCode.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    update();
  }

  void clearSearch() {
    searchController.text = "";
    filterByItemCode("");
  }

  Future<void> onAddCart(BuildContext context, AutoPoItem item) async {
    final exists = supplierNewOrderCartList.any(
      (cartItem) => cartItem.itemCode == item.itemCode,
    );

    // If already selected → remove
    if (exists) {
      supplierNewOrderCartList.removeWhere(
        (cartItem) => cartItem.itemCode == item.itemCode,
      );
      item.remarksDate = null;
      update();
      return;
    }

    // Ask date first
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              const Text(
                "When Going to Dispatch",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Expanded(child: child!),
            ],
          ),
        );
      },
    );

    if (picked != null) {
      item.remarksDate = picked; // ✅ store in model
      supplierNewOrderCartList.add(item);
      update();
    }
  }

  Future<void> updateToCart({required AutoPoItem item}) async {
    if (item.rowId != null) {
      bool? value = await AutoPoService().updateAddedToCart(
        childName: item.rowId!,
        addedToCart: true,
      );
      if (value) {
        await fetchCartItems();
        update();
      }
    }
  }

  //////////////////// Cart area //////////////

  Future<void> fetchCartItems() async {
    Map<String, String>? userData;
    loading = true;
    update();
    cartItemsList = [];
    filteredCartItemsList = [];

    if (userId != null) {
      if (kIsWeb) {
        userData = await AutoPoService().getUserCompanyWeb(user: userId);
      } else {
        userData = await AutoPoService().getUserCompany(user: userId);
      }

      // print("usr d$userData");
      if (userData == null) {
        loading = false;
        update();
        return;
      }

      final String company = userData["company"] ?? "";
      final String supplier = userData["supplier"] ?? "";

      if (company.isNotEmpty && supplier.isNotEmpty) {
        cartItemsList = await AutoPoService().getAutoPoItems(
          company: company,
          supplier: supplier,
          cartItems: 1,
        );
      }
      print(cartItemsList);
      filteredCartItemsList = List.from(cartItemsList);
    }
    loading = false;
    update();
  }

  void filterByItemCodeCartItems(String query) {
    if (query.isEmpty) {
      filteredCartItemsList = List.from(cartItemsList);
    } else {
      filteredCartItemsList = cartItemsList.where((item) {
        return item.itemCode.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    update();
  }

  void clearSearchCartItems() {
    cartSearchController.text = "";
    filterByItemCodeCartItems("");
  }

  Future<void> createPo({required List<AutoPoItem> list}) async {
    loading = true;
    update();
    String? value = await AutoPoService().createPurchaseOrder(orderItems: list);

    // print("valu: $value");

    if (value != null) {
      for (AutoPoItem itm in list) {
        if (itm.rowId != null) {
          bool? msg = await AutoPoService().updateAddedToCart(
            childName: itm.rowId!,
            addedToCart: false,
            lastPoId: value,
            requestedQty: 0,
          );
        }
      }

      Get.snackbar(
        "Success",
        "Accepted Successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
      loading = false;
      supplierNewOrderCartList.clear();
      await fetchCartItems();
      update();
    } else {
      loading = false;
      supplierNewOrderCartList.clear();
      Get.snackbar(
        "Failed",
        "Failed to Accept Items",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
      update();
    }
  }

  // --- Search for New Orders ---
  void searchNewOrders(String query) {
    final lowercaseQuery = query.toLowerCase();

    if (query.isEmpty) {
      filteredCartItemsList = List.from(cartItemsList);
    } else {
      filteredCartItemsList = cartItemsList.where((item) {
        // Search in both Item Code and Item Name
        final codeMatch = (item.itemCode ?? "").toLowerCase().contains(
          lowercaseQuery,
        );
        final nameMatch = (item.itemName ?? "").toLowerCase().contains(
          lowercaseQuery,
        );

        return codeMatch || nameMatch;
      }).toList();
    }
    update();
  }

  // --- Search for Item Master (If you use autoPoItems) ---
  void searchItemMaster(String query) {
    final lowercaseQuery = query.toLowerCase();

    if (query.isEmpty) {
      filteredAutoPoItems = List.from(autoPoItems);
    } else {
      filteredAutoPoItems = autoPoItems.where((item) {
        final codeMatch = (item.itemCode ?? "").toLowerCase().contains(
          lowercaseQuery,
        );
        final nameMatch = (item.itemName ?? "").toLowerCase().contains(
          lowercaseQuery,
        );

        return codeMatch || nameMatch;
      }).toList();
    }
    update();
  }
}
