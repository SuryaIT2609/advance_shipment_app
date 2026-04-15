import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:po_asn_app/controller/po_list_controller.dart';
import 'package:po_asn_app/model/poPendingItemModel.dart';
import '../controller/create_asn_controller.dart';
import '../controller/po_cart_controller.dart';

class CreateASNPage extends StatelessWidget {
  const CreateASNPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return GetBuilder<POListController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFF2F4F8),
          appBar: AppBar(
            backgroundColor: const Color(0xFF3B6EBF),
            title: const Text(
              "Advance Shipment Notice",
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: Get.back,
            ),
          ),
          bottomNavigationBar: SafeArea(
            bottom: true,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    onPressed: Get.back,
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B6EBF),
                    ),
                    onPressed: () async {
                      controller.loading = true;
                      controller.update();
                      if (_formKey.currentState!.validate()) {
                        bool value = await controller.createASN(
                          controller.selectedItems,
                        );
                        if (value) {
                          Navigator.pop(context);
                        }
                      }
                      controller.loading = false;
                      controller.update();
                    },
                    child: const Text(
                      "Submit ASN",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title("ASN Details"),
                  _field(
                    "Supplier Invoice No",
                    controller.supplierInvoiceNumber,
                  ),
                  _field(
                    "Supplier Invoice Date",
                    controller.supplierInvoiceDate,
                    isDate: true,
                  ),
                  _field(
                    "Estimated Arrival Date",
                    controller.estDate,
                    isDate: true,
                  ),
                  _field("LLR No", controller.llrNO),
                  _field("Transport Name", controller.transportName),
                  const SizedBox(height: 20),
                  _title("Items"),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 24,
                        columns: const [
                          DataColumn(label: Text("PO No")),
                          DataColumn(label: Text("Item Code")),
                          DataColumn(label: Text("Item Name")),
                          DataColumn(label: Text("UOM")),
                          DataColumn(label: Text("Pending Qty")),
                          DataColumn(label: Text("PO Qty")),
                          DataColumn(label: Text("ASN Done")),
                          DataColumn(label: Text("Remove")),
                        ],
                        rows: _rowsList(controller),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<DataRow> _rowsList(POListController controller) {
    List<DataRow> list = [];

    for (PurchaseOrderItemModel item in controller.selectedItems) {
      list.add(
        DataRow(
          cells: [
            DataCell(Text(item.poNumber ?? "--")),
            DataCell(Text(item.itemCode ?? "--")),
            DataCell(Text(item.itemName ?? "--")),
            DataCell(Text(item.uom ?? "--")),
            DataCell(
              SizedBox(
                width: 90,
                child: TextField(
                  controller: item.editableQtyController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    final entered = double.tryParse(value) ?? 0;
                    final maxQty = item.pendingQty ?? 0;
                    if (entered > maxQty) {
                      item.editableQtyController.text = maxQty.toString();
                      item.editableQtyController.selection =
                          TextSelection.fromPosition(
                            TextPosition(
                              offset: item.editableQtyController.text.length,
                            ),
                          );

                      // Optional user feedback
                      Get.snackbar(
                        "Invalid Quantity",
                        "ASN Qty cannot exceed Pending Qty ($maxQty)",
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 1),
                      );
                    }
                  },
                ),
              ),
            ),
            DataCell(Text((item.poQty ?? 0).toString())),
            DataCell(Text((item.transitQty ?? 0).toString())),
            DataCell(
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  controller.removeSelection(item);
                },
              ),
            ),
          ],
        ),
      );
    }

    return list;
  }

  // ================= UI HELPERS =================

  Widget _title(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      t,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );

  Widget _field(String label, TextEditingController c, {bool isDate = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        readOnly: isDate,
        // 🔒 prevent typing
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: isDate ? const Icon(Icons.calendar_today) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "$label is required";
          }
          return null;
        },
        onTap: isDate
            ? () async {
                FocusScope.of(Get.context!).unfocus();

                final DateTime? picked = await showDatePicker(
                  context: Get.context!,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );

                if (picked != null) {
                  c.text = picked.toIso8601String().split('T')[0];
                }
              }
            : null,
      ),
    );
  }

  // Widget _field(String label, TextEditingController c) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 12),
  //     child: TextFormField(
  //       controller: c,
  //       decoration: InputDecoration(
  //         labelText: label,
  //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  //       ),
  //       validator: (value) {
  //         if (value == null || value.trim().isEmpty) {
  //           return "$label is required";
  //         }
  //         return null;
  //       },
  //     ),
  //   );
  // }

  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.grey.shade200,
      child: const Row(
        children: [
          Expanded(
            child: Text(
              "Item Code",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              "PO Qty",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text("PO No", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text(
              "ASN Qty",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _itemRow(POListController c, row, int index) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(child: TextField(controller: row.itemCode, readOnly: true)),
          Expanded(child: TextField(controller: row.poQty, readOnly: true)),
          Expanded(child: TextField(controller: row.poNumber, readOnly: true)),
          Expanded(child: TextField(controller: row.asnQty)),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {},
            // => c.removeItem(index),
          ),
        ],
      ),
    );
  }
}
