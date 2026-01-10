import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:po_asn_app/Pages/po_pending_page.dart';
import '../controller/create_asn_controller.dart';

class CreateASNPage extends StatelessWidget {
  const CreateASNPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateASNController>(
      init: CreateASNController(),
      builder: (c) {
        return Scaffold(
          backgroundColor: const Color(0xFFF2F4F8),

          // ---------------- APP BAR ----------------
          appBar: AppBar(
            backgroundColor: const Color(0xFF3B6EBF),
            title: const Text("Advance Shipment Notice",
                style: TextStyle(color: Colors.white)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
          ),

          // ---------------- BODY ----------------
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ===== HEADER SECTION =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _sectionTitle("Items"),
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.dialog(
                          POPendingDialog(
                            onSelect: (row) {
                              Get.find<CreateASNController>().addItemFromPO(row);
                            },
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text("Get Items from PO"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B6EBF),
                      ),
                    ),



                  ],
                ),




                _sectionTitle("ASN Details"),

                _textField("Supplier Invoice No", c.supplierInvoiceNo),
                _textField("Supplier Invoice Date", c.supplierInvoiceDate),
                _textField("Estimated Arrival Date", c.estimatedArrivalDate),
                _textField("LLR No", c.llrNo),
                _textField("Transport Name", c.transporter),

                const SizedBox(height: 24),

                // ===== ITEM TABLE =====
                _sectionTitle("Items"),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _tableHeader(),
                      ...List.generate(c.items.length, (index) {
                        final row = c.items[index];
                        return _itemRow(c, row, index);
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // ADD ITEM
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: TextButton.icon(
                //     onPressed: c.addItem,
                //     icon: const Icon(Icons.add),
                //     label: const Text("Add Item"),
                //   ),
                // ),

                const SizedBox(height: 30),

                // ===== ACTION BUTTONS =====
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        onPressed: () {},
                        child: const Text("Save Draft"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B6EBF),
                        ),
                        onPressed: () {},
                        child: const Text("Submit"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------- UI HELPERS ----------------

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _textField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.grey.shade200,
      child: const Row(
        children: [
          Expanded(child: Text("Item Code", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text("PO Qty", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text("PO No", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text("ASN Qty", style: TextStyle(fontWeight: FontWeight.bold))),
          SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _itemRow(CreateASNController c, row, int index) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(child: TextField(controller: row.itemCode)),
          Expanded(child: TextField(controller: row.poQty)),
          Expanded(child: TextField(controller: row.poNumber)),
          Expanded(child: TextField(controller: row.asnQty)),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => c.removeItem(index),
          ),
        ],
      ),
    );
  }
}
