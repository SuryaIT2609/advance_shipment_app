
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/asn_controller.dart';
import '../model/asn_report_model.dart'; // Ensure correct path

class InvoiceReportScreen extends StatefulWidget {
  const InvoiceReportScreen({super.key});

  @override
  State<InvoiceReportScreen> createState() => _InvoiceReportScreenState();
}

class _InvoiceReportScreenState extends State<InvoiceReportScreen> {
  ASNController controller = Get.put(ASNController());
  ASNModel? selectedASN; // To track selection for Desktop view

  @override
  void initState() {
    super.initState();
    _onLoad();
  }

  Future<void> _onLoad() async {
    final DateTime now = DateTime.now();
    final DateTime from = DateTime(now.year, now.month, 1);
    final DateTime to = DateTime(now.year, now.month, now.day);
    await controller.fetchASNList(
      fromDate: "${from.year}-${from.month}-${from.day}",
      toDate: "${to.year}-${to.month}-${to.day}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Invoice Report",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF3B6EBF),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _onLoad,
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_sharp, color: Colors.white),
            onPressed: () => _openFilterSheet(context, controller),
          ),
        ],
      ),
      body: GetBuilder<ASNController>(
        builder: (controller) {
          return LayoutBuilder(
            builder: (context, constraints) {
              bool isDesktop = constraints.maxWidth > 900;

              if (isDesktop) {
                return Row(
                  children: [
                    // Left Side: Invoice List
                    SizedBox(
                      width: 400,
                      child: _buildInvoiceList(controller, isDesktop),
                    ),
                    const VerticalDivider(width: 1),
                    // Right Side: Items List
                    Expanded(
                      child: selectedASN == null
                          ? const Center(
                              child: Text("Select an invoice to view items"),
                            )
                          : _ItemDetailView(asn: selectedASN!),
                    ),
                  ],
                );
              }

              // Mobile View
              return _buildInvoiceList(controller, isDesktop);
            },
          );
        },
      ),
    );
  }

  Widget _textField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _dateRangeField(BuildContext context, ASNController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller.dateRangeController,
        readOnly: true,
        onTap: () async {
          DateTimeRange? picked = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
            initialDateRange: controller.selectedRange,
            helpText: "Select Date Range",
          );

          if (picked != null) {
            controller.selectedRange = picked;
            controller.dateRangeController.text =
                "${controller.fmt(picked.start)}  →  ${controller.fmt(picked.end)}";
          }
        },
        decoration: const InputDecoration(
          labelText: "From Date - To Date",
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.date_range),
        ),
      ),
    );
  }

  BoxDecoration boxStyle() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    );
  }

  Widget _buildInvoiceList(ASNController controller, bool isDesktop) {
    return Column(
      children: [
        // --- Parent Search (Invoice) ---
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            // onChanged: (v) => controller.filterInvoices(v), // Implement in controller
            decoration: InputDecoration(
              hintText: "Search Invoice / ASN No",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              isDense: true,
            ),
          ),
        ),
        Expanded(
          child: controller.asnList.isEmpty
              ? const Center(child: Text("No Invoices Found"))
              : ListView.builder(
                  itemCount: controller.asnList.length,
                  itemBuilder: (context, index) {
                    final asn = controller.asnList[index];
                    bool isSelected = selectedASN?.asnNo == asn.asnNo;

                    return Card(
                      color: isSelected && isDesktop
                          ? Colors.blue.shade50
                          : Colors.white,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: ListTile(
                        title: Text(
                          "INV: ${asn.supplierInvoiceNo ?? '--'}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("ASN: ${asn.asnNo}"),
                            Text(
                              "Date: ${asn.supplierInvoiceDate ?? '--'}",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: Icon(
                          asn.completed == 1
                              ? Icons.check_circle
                              : Icons.pending,
                          color: asn.completed == 1
                              ? Colors.green
                              : Colors.orange,
                        ),
                        onTap: () {
                          if (isDesktop) {
                            setState(() => selectedASN = asn);
                          } else {
                            // Navigate to Mobile Detail Screen
                            Get.to(() => _ItemDetailView(asn: asn));
                          }
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // Filter sheet remains similar but focuses on Parent/Header data
  void _openFilterSheet(BuildContext context, ASNController controller) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 Title
                  const Center(
                    child: Text(
                      "Filter Dispatched Items",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _dateRangeField(context, controller),
                  _textField("Invoice No", controller.invoiceSearchCtrl),
                  const SizedBox(height: 12),
                  _textField("Item Code", controller.itemSearchCtrl),
                  _textField("Item Name", controller.itemDescSearchCtrl),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            controller.dateRangeController.clear();
                            controller.selectedRange = null;
                            controller.invoiceSearchCtrl.clear();
                            controller.itemSearchCtrl.clear();
                            controller.itemDescSearchCtrl.clear();
                            await _onLoad();
                            Navigator.pop(context);
                          },
                          child: const Text("Clear"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller.applyFilters();
                            Navigator.pop(context);
                          },
                          child: const Text("Apply"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ItemDetailView extends StatefulWidget {
  final ASNModel asn;

  const _ItemDetailView({required this.asn});

  @override
  State<_ItemDetailView> createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<_ItemDetailView> {
  String itemQuery = "";

  @override
  Widget build(BuildContext context) {
    // Local filter for items
    final filteredItems = widget.asn.items.where((item) {
      final search = itemQuery.toLowerCase();
      return (item.itemName ?? "").toLowerCase().contains(search) ||
          (item.item ?? "").toLowerCase().contains(search);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Items for ${widget.asn.asnNo}"),
        automaticallyImplyLeading: Get.currentRoute != "/",
        // Only show back button on Mobile
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // --- Item Level Search ---
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (v) => setState(() => itemQuery = v),
              decoration: InputDecoration(
                hintText: "Search items in this invoice...",
                prefixIcon: const Icon(Icons.inventory_2_outlined),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return _buildItemCard(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(ASNItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.item ?? "--",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "PO: ${item.poNo ?? '--'}",
                style: const TextStyle(color: Colors.blue, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            item.itemName ?? "--",
            style: const TextStyle(color: Colors.black54),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoTile("Qty", "${item.qty} ${item.uom}"),
              _infoTile("Rate", "${item.rate}"),
              _infoTile("Amount", "${item.amount}", isBold: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value, {bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
