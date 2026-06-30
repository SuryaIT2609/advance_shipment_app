import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:po_asn_app/controller/po_list_controller.dart';
import 'package:po_asn_app/model/poPendingItemModel.dart';

class CreateASNPage extends StatefulWidget {
  const CreateASNPage({super.key});

  @override
  State<CreateASNPage> createState() => _CreateASNPageState();
}

class _CreateASNPageState extends State<CreateASNPage> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return GetBuilder<POListController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFF2F4F8),
          appBar: AppBar(
            backgroundColor: const Color(0xFF3B6EBF),
            elevation: 0,
            title: const Text(
              "Create Advance Shipment Notice",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: Get.back,
            ),
            // Desktop-style submit button in AppBar for convenience
            actions: [
              if (MediaQuery.of(context).size.width > 900)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: controller.loading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF3B6EBF),
                          ),

                          onPressed: () =>
                              _handleSubmit(controller, formKey, context),
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text("Submit ASN"),
                        ),
                ),
            ],
          ),
          bottomNavigationBar: MediaQuery.of(context).size.width <= 900
              ? _buildMobileBottomBar(controller, formKey, context)
              : null,
          body: Center(
            child: controller.loading
                ? CircularProgressIndicator()
                : ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    // Limits width on ultra-wide screens
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeaderCard(controller, context),
                            const SizedBox(height: 24),
                            _title("Item Details"),
                            _buildItemTable(controller),
                            const SizedBox(height: 100), // Space for bottom bar
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  // --- Form Header Section (2 Columns on Desktop) ---
  Widget _buildHeaderCard(POListController controller, BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title("ASN Information"),
            const Divider(),
            const SizedBox(height: 16),
            Wrap(
              spacing: 20,
              runSpacing: 10,
              children: [
                _responsiveField(
                  context,
                  "Supplier Invoice No",
                  controller.supplierInvoiceNumber,
                ),
                _responsiveField(
                  context,
                  "Supplier Invoice Date",
                  controller.supplierInvoiceDate,
                  isDate: true,
                ),
                _responsiveField(
                  context,
                  "Estimated Arrival Date",
                  controller.estDate,
                  isDate: true,
                ),
                _responsiveField(context, "LLR No", controller.llrNO),
                _responsiveField(
                  context,
                  "Transport Name",
                  controller.transportName,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Responsive Field Sizing ---
  Widget _responsiveField(
    BuildContext context,
    String label,
    TextEditingController c, {
    bool isDate = false,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    // On large screens, take 48% width (2-column). On mobile, take 100%.
    double width = screenWidth > 800
        ? (screenWidth > 1200 ? 540 : screenWidth * 0.42)
        : screenWidth;

    return SizedBox(
      width: width,
      child: _field(label, c, isDate: isDate),
    );
  }

  // --- Modern Item Table ---
  Widget _buildItemTable(POListController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
          columnSpacing: 30,
          columns: const [
            DataColumn(
              label: Text(
                "PO No",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                "Item Code",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                "Item Name",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text("UOM", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text(
                "ASN Qty (Edit)",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                "Pending Qty",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                "Rate",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                "Amount",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                "Remove",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: controller.selectedItems.map((item) {
            return DataRow(
              cells: [
                DataCell(Text(item.poNumber ?? "--")),
                DataCell(Text(item.itemCode ?? "--")),
                DataCell(
                  SizedBox(
                    width: 150,
                    child: Text(
                      item.itemName ?? "--",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(Text(item.uom ?? "--")),
                DataCell(
                  SizedBox(
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextField(
                        controller: item.editableQtyController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.all(8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onChanged: (value) {
                          _validateQty(value, item);
                          controller.update();
                        },
                      ),
                    ),
                  ),
                ),
                DataCell(Text(item.pendingQty.toString())),
                DataCell(Text(item.rate.toString())),
                DataCell(
                  Text(
                    calculateAmount(
                      item,
                      double.tryParse(item.editableQtyController.text),
                    ).toStringAsFixed(2),
                  ),
                ),
                DataCell(
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                    onPressed: () => controller.removeSelection(item),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  double calculateAmount(PurchaseOrderItemModel item, double? enteredAmount) {
    double amount = (enteredAmount ?? 0) * (item.rate ?? 0);
    return amount;
  }

  // --- Submission Logic ---
  void _handleSubmit(
    POListController controller,
    GlobalKey<FormState> formKey,
    BuildContext context,
  ) async {
    if (formKey.currentState!.validate()) {
      controller.loading = true;
      controller.update();

      bool success = await controller.createASN(controller.selectedItems);
      await controller.fetchPOItems();

      if (success) {
        Get.snackbar(
          "Success",
          "ASN Created Successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );

        await Future.delayed(Duration(seconds: 2), () {
          controller.loading = false;
          controller.update();
          Get.back();
        });
      } else {
        Get.snackbar(
          "Failed",
          "Error In Submitting ASN",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      }
      controller.loading = false;
      controller.update();
    }
  }

  void _validateQty(String value, PurchaseOrderItemModel item) {
    final entered = double.tryParse(value) ?? 0;
    final maxQty = item.pendingQty ?? 0;

    if (entered > maxQty) {
      item.editableQtyController.text = maxQty.toString();
      item.editableQtyController.selection = TextSelection.fromPosition(
        TextPosition(offset: item.editableQtyController.text.length),
      );

      Get.snackbar(
        "Limit Exceeded",
        "Cannot exceed pending quantity",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // --- UI Helpers ---
  Widget _buildMobileBottomBar(
    POListController controller,
    GlobalKey<FormState> formKey,
    BuildContext context,
  ) {
    return controller.loading
        ? Center(child: CircularProgressIndicator())
        : Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
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
                    onPressed: () =>
                        _handleSubmit(controller, formKey, context),
                    child: const Text(
                      "Submit ASN",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget _title(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      t,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF3B6EBF),
      ),
    ),
  );

  Widget _field(String label, TextEditingController c, {bool isDate = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        readOnly: isDate,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 14),
          filled: true,
          fillColor: Colors.grey.shade50,
          suffixIcon: isDate
              ? const Icon(Icons.calendar_month, size: 20)
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
        onTap: isDate ? () => _selectDate(c) : null,
      ),
    );
  }

  Future<void> _selectDate(TextEditingController c) async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) c.text = picked.toIso8601String().split('T')[0];
  }
}
