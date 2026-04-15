import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

    print("valu: $value");

    if (value != null) {
      for (AutoPoItem itm in list) {
        if (itm.rowId != null) {
          bool? msg = await AutoPoService().updateAddedToCart(
            childName: itm.rowId!,
            addedToCart: false,
            lastPoId: value,
            requestedQty: 0,
          );
          print(msg);
        }
      }
      supplierNewOrderCartList.clear();
      await fetchCartItems();
      update();
    }
    loading = false;
    await fetchCartItems();
    update();
  }
}
