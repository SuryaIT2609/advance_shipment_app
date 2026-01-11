import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/po_list_controller.dart';

class PurchaseOrderListPage extends StatelessWidget {
  const PurchaseOrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<POListController>(
      init: POListController(),
      builder: (c) {
        return Scaffold(
          backgroundColor: const Color(0xFFF2F4F8),

          appBar: AppBar(
            backgroundColor: const Color(0xFF3B6EBF),
            title: const Text("Purchase Order List", style: TextStyle(color: Colors.white)),
          ),

          body: Column(
            children: [

              // 🔍 SEARCH
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: c.search,
                  decoration: InputDecoration(
                    hintText: "Search PO / Item Code / Item Name",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // 📋 LIST
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: c.filteredItems.length,
                  itemBuilder: (context, index) {
                    final row = c.filteredItems[index];
                    final selected = c.isSelected(row);

                    return GestureDetector(
                      onTap: () => c.toggleSelection(row),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: selected ? Colors.blue.shade50 : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: selected,
                              onChanged: (_) => c.toggleSelection(row),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(row['po_number'], style: const TextStyle(fontWeight: FontWeight.w600)),
                                  Text(row['item_code']),
                                  Text(row['item_name'], style: const TextStyle(color: Colors.black54)),
                                  Text("Pending Qty: ${row['pending_qty']}"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 🚚 CREATE ASN BUTTON
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.local_shipping),
                      label: const Text("Create ASN"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B6EBF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: c.selectedItems.isEmpty
                          ? null
                          : () {
                        Get.toNamed(
                          '/create-asn',
                          arguments: c.selectedItems, // MUST BE LIST
                        );
                      },

                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

