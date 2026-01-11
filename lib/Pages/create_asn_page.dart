import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/create_asn_controller.dart';

class CreateASNPage extends StatelessWidget {
  const CreateASNPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateASNController>(
      builder: (c) {
        return Scaffold(
          backgroundColor: const Color(0xFFF2F4F8),

          appBar: AppBar(
            backgroundColor: const Color(0xFF3B6EBF),
            title: const Text("Advance Shipment Notice",
                style: TextStyle(color: Colors.white)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: Get.back,
            ),
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _title("ASN Details"),
                _field("Supplier Invoice No", c.supplierInvoiceNo),
                _field("Supplier Invoice Date", c.supplierInvoiceDate),
                _field("Estimated Arrival Date", c.estimatedArrivalDate),
                _field("LLR No", c.llrNo),
                _field("Transport Name", c.transporter),

                const SizedBox(height: 20),
                _title("Items"),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _tableHeader(),
                      ...List.generate(c.items.length, (i) {
                        final row = c.items[i];
                        return _itemRow(c, row, i);
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        onPressed: Get.back,
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B6EBF),
                        ),
                        onPressed: () {
                          // NEXT STEP: SUBMIT ASN API
                        },
                        child: const Text("Submit ASN"),
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

  // ================= UI HELPERS =================

  Widget _title(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(t,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold)),
  );

  Widget _field(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
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
          Expanded(child: TextField(controller: row.itemCode, readOnly: true)),
          Expanded(child: TextField(controller: row.poQty, readOnly: true)),
          Expanded(child: TextField(controller: row.poNumber, readOnly: true)),
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
