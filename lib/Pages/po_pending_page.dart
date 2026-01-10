import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/po_pending_controller.dart';

class POPendingDialog extends StatelessWidget {
  final Function(Map<String, dynamic>) onSelect;

  const POPendingDialog({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<POPendingController>(
      init: POPendingController()..loadPendingPO(),
      builder: (c) {
        return AlertDialog(
          title: const Text("Pending PO Items"),
          content: SizedBox(
            width: double.maxFinite,
            child: c.loading
                ? const Center(child: CircularProgressIndicator())
                : c.items.isEmpty
                ? const Text("No Pending Items")
                : ListView.builder(
              shrinkWrap: true,
              itemCount: c.items.length,
              itemBuilder: (context, index) {
                final row = c.items[index];

                return Card(
                  child: ListTile(
                    title: Text(
                      "${row['po_no']} - ${row['item_code']}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      "Item: ${row['item_name']}\nPO Qty: ${row['po_qty']}",
                    ),
                    trailing: const Icon(Icons.check_circle,
                        color: Colors.green),
                    onTap: () {
                      onSelect(row);
                      Get.back();
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
