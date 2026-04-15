// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/get_instance.dart';
// import 'package:get/get_state_manager/src/simple/get_state.dart';
//
// import '../controller/asn_controller.dart';
// import '../controller/login_controller.dart';
// import '../controller/smartPoController.dart';
//
// class InvoiceReportScreen extends StatefulWidget {
//   const InvoiceReportScreen({super.key});
//
//   @override
//   State<InvoiceReportScreen> createState() => _InvoiceReportScreenState();
// }
//
// class _InvoiceReportScreenState extends State<InvoiceReportScreen>
//     with SingleTickerProviderStateMixin {
//   ASNController controller = Get.put(ASNController());
//   LoginController loginController = Get.put(LoginController());
//
//   @override
//   void initState() {
//     super.initState();
//     _onLoad();
//   }
//
//   Future<void> _onLoad() async {
//     final DateTime now = DateTime.now();
//
//     final DateTime from = DateTime(now.year, now.month, 1);
//     final DateTime to = DateTime(now.year, now.month, now.day);
//
//     controller.selectedRange = DateTimeRange(start: from, end: to);
//
//     controller.dateRangeController.text =
//         "${controller.displayFmt(from)} → ${controller.displayFmt(to)}";
//
//     await controller.fetchASNList(fromDate: _apiFmt(from), toDate: _apiFmt(to));
//     controller.update();
//   }
//
//   String _apiFmt(DateTime d) {
//     return "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: GetBuilder(
//           init: controller,
//           builder: (controller) {
//             return Row(
//               children: [
//                 Text("Report"),
//                 SizedBox(width: 3),
//                 Text(
//                   " / ${controller.dateRangeController.text}",
//                   style: TextStyle(fontSize: 14),
//                 ),
//               ],
//             );
//           },
//         ),
//         backgroundColor: Colors.blue,
//         actions: [
//           InkWell(
//             onTap: () async {
//               // await _onLoad();
//             },
//             child: Padding(
//               padding: EdgeInsets.only(right: 12),
//               child: Icon(Icons.refresh, color: Colors.white),
//             ),
//           ),
//           GetBuilder(
//             init: controller,
//             builder: (controller) {
//               return InkWell(
//                 onTap: () => _openFilterSheet(context, controller),
//                 child: Padding(
//                   padding: EdgeInsets.only(right: 12),
//                   child: Icon(Icons.filter_alt_sharp, color: Colors.white),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: GetBuilder(
//         init: controller,
//         builder: (controller) {
//           return Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFFE8F4F8), Color(0xFFB5DDF0)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: SafeArea(
//               top: false,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: controller.asnList.isEmpty
//                         ? Center(
//                             child: Text(
//                               "No Data",
//                               style: TextStyle(fontSize: 24),
//                             ),
//                           )
//                         : ListView.builder(
//                             padding: const EdgeInsets.all(12),
//                             itemCount: controller.asnList.length,
//                             itemBuilder: (context, index) {
//                               final item = controller.asnList[index];
//                               String previous = "";
//                               String current = "";
//
//                               if (index != 0) {
//                                 previous =
//                                     controller
//                                         .asnList[index - 1]
//                                         .supplierInvoiceNo ??
//                                     "";
//                                 current = item.supplierInvoiceNo ?? "";
//                               }
//
//                               String status = item.completed == 1
//                                   ? "Completed"
//                                   : "Pending";
//
//                               return Column(
//                                 children: [
//                                   if (index == 0 || current != previous)
//                                     Text(
//                                       "${item.supplierInvoiceNo} - ${item.supplierInvoiceDate} - $status",
//                                       style: TextStyle(fontSize: 18),
//                                     ),
//                                   // asnInfoCard(
//                                   //   invoiceNo: item.supplierInvoiceNo ?? "--",
//                                   //   invoiceDate:
//                                   //       item.supplierInvoiceDate ?? "--",
//                                   //   llr: item.llr ?? "--",
//                                   //   transporter: item.transporter ?? "--",
//                                   //   estimatedArrivalDate:
//                                   //       item.estimatedArrivalDate ?? "--",
//                                   //   status: item.completed == 1
//                                   //       ? "GRN Done"
//                                   //       : "Pending",
//                                   // ),
//                                   Container(
//                                     margin: EdgeInsets.only(bottom: 12),
//                                     padding: EdgeInsets.all(16),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(16),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.black12,
//                                           blurRadius: 8,
//                                           offset: Offset(0, 4),
//                                         ),
//                                       ],
//                                     ),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             SizedBox(
//                                               width: 220,
//                                               child: Text(
//                                                 item.item ?? "--",
//                                                 style: TextStyle(
//                                                   fontSize: 13,
//                                                   // fontWeight: FontWeight.bold,
//                                                 ),
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                             ),
//                                             Text(
//                                               "${item.poNo}",
//                                               style: TextStyle(fontSize: 13),
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                           ],
//                                         ),
//                                         SizedBox(height: 8),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             SizedBox(
//                                               width: 220,
//                                               child: Text(
//                                                 "${item.itemName}",
//                                                 style: TextStyle(fontSize: 13),
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                             ),
//                                             Text(
//                                               "${item.qty} ${item.uom}",
//                                               style: TextStyle(fontSize: 13),
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                           ],
//                                         ),
//                                         SizedBox(height: 8),
//                                         Row(
//                                           children: [
//                                             Text(
//                                               "Rate: ${(item.rate ?? 0)}",
//                                               style: TextStyle(fontSize: 13),
//                                             ),
//                                             Spacer(),
//                                             Text(
//                                               "Amount: ${(item.amount ?? 0)}",
//                                               style: TextStyle(fontSize: 13),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             },
//                           ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget asnInfoCard({
//     required String invoiceNo,
//     required String invoiceDate,
//     required String llr,
//     required String transporter,
//     required String estimatedArrivalDate,
//     required String status,
//   }) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _infoRow("Invoice No", invoiceNo),
//             _infoRow("Invoice Date", invoiceDate),
//             _infoRow("LLR", llr),
//             _infoRow("Transporter", transporter),
//             _infoRow("Estimated Arrival Date", estimatedArrivalDate),
//             _infoRow("Status", status),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _infoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 150,
//             child: Text(
//               "$label :",
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value.isNotEmpty ? value : "--",
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _openFilterSheet(BuildContext context, ASNController controller) {
//     showModalBottomSheet(
//       useSafeArea: true,
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) {
//         return SafeArea(
//           child: Padding(
//             padding: EdgeInsets.only(
//               left: 16,
//               right: 16,
//               top: 16,
//               bottom: MediaQuery.of(context).viewInsets.bottom + 16,
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// 🔹 Title
//                   const Center(
//                     child: Text(
//                       "Filter Dispatched Items",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   _dateRangeField(context, controller),
//                   _textField("Invoice No", controller.invoiceSearchCtrl),
//                   const SizedBox(height: 12),
//                   _textField("Item Code", controller.itemSearchCtrl),
//                   _textField("Item Name", controller.itemDescSearchCtrl),
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton(
//                           onPressed: () async {
//                             controller.dateRangeController.clear();
//                             controller.selectedRange = null;
//                             controller.invoiceSearchCtrl.clear();
//                             controller.itemSearchCtrl.clear();
//                             controller.itemDescSearchCtrl.clear();
//                             await _onLoad();
//                             Navigator.pop(context);
//                           },
//                           child: const Text("Clear"),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             await controller.applyFilters();
//                             Navigator.pop(context);
//                           },
//                           child: const Text("Apply"),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _textField(String label, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//       ),
//     );
//   }
//
//   Widget _dateRangeField(BuildContext context, ASNController controller) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: TextField(
//         controller: controller.dateRangeController,
//         readOnly: true,
//         onTap: () async {
//           DateTimeRange? picked = await showDateRangePicker(
//             context: context,
//             firstDate: DateTime(2020),
//             lastDate: DateTime(2100),
//             initialDateRange: controller.selectedRange,
//             helpText: "Select Date Range",
//           );
//
//           if (picked != null) {
//             controller.selectedRange = picked;
//             controller.dateRangeController.text =
//                 "${controller.fmt(picked.start)}  →  ${controller.fmt(picked.end)}";
//           }
//         },
//         decoration: const InputDecoration(
//           labelText: "From Date - To Date",
//           border: OutlineInputBorder(),
//           suffixIcon: Icon(Icons.date_range),
//         ),
//       ),
//     );
//   }
//
//   BoxDecoration boxStyle() {
//     return BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(12),
//       border: Border.all(color: Colors.grey.shade300),
//     );
//   }
// }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/asn_controller.dart';
// import '../controller/login_controller.dart';
//
// class InvoiceReportScreen extends StatefulWidget {
//   const InvoiceReportScreen({super.key});
//
//   @override
//   State<InvoiceReportScreen> createState() => _InvoiceReportScreenState();
// }
//
// class _InvoiceReportScreenState extends State<InvoiceReportScreen> {
//   ASNController controller = Get.put(ASNController());
//   LoginController loginController = Get.put(LoginController());
//
//   @override
//   void initState() {
//     super.initState();
//     _onLoad();
//   }
//
//   Future<void> _onLoad() async {
//     final DateTime now = DateTime.now();
//     final DateTime from = DateTime(now.year, now.month, 1);
//     final DateTime to = DateTime(now.year, now.month, now.day);
//
//     controller.selectedRange = DateTimeRange(start: from, end: to);
//     controller.dateRangeController.text =
//         "${controller.displayFmt(from)} → ${controller.displayFmt(to)}";
//
//     await controller.fetchASNList(fromDate: _apiFmt(from), toDate: _apiFmt(to));
//     controller.update();
//   }
//
//   String _apiFmt(DateTime d) {
//     return "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: GetBuilder<ASNController>(
//           builder: (controller) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Invoice Report",
//                   style: TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//                 Text(
//                   controller.dateRangeController.text,
//                   style: const TextStyle(fontSize: 11, color: Colors.white70),
//                 ),
//               ],
//             );
//           },
//         ),
//         backgroundColor: const Color(0xFF3B6EBF),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: _onLoad,
//           ),
//           IconButton(
//             icon: const Icon(Icons.filter_alt_sharp, color: Colors.white),
//             onPressed: () => _openFilterSheet(context, controller),
//           ),
//         ],
//       ),
//       body: GetBuilder<ASNController>(
//         builder: (controller) {
//           return Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFFF2F4F8), Color(0xFFE8F4F8)],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//             child: controller.asnList.isEmpty
//                 ? const Center(
//                     child: Text(
//                       "No Data Found",
//                       style: TextStyle(fontSize: 18, color: Colors.grey),
//                     ),
//                   )
//                 : LayoutBuilder(
//                     builder: (context, constraints) {
//                       if (constraints.maxWidth > 700) {
//                         return _buildGridView(controller, constraints.maxWidth);
//                       }
//                       return _buildListView(controller);
//                     },
//                   ),
//           );
//         },
//       ),
//     );
//   }
//
//   // --- MOBILE LIST VIEW (With Grouped Headers) ---
//   Widget _buildListView(ASNController controller) {
//     return ListView.builder(
//       padding: const EdgeInsets.all(12),
//       itemCount: controller.asnList.length,
//       itemBuilder: (context, index) {
//         final item = controller.asnList[index];
//         bool showHeader = false;
//
//         if (index == 0) {
//           showHeader = true;
//         } else {
//           final prevItem = controller.asnList[index - 1];
//           if (prevItem.supplierInvoiceNo != item.supplierInvoiceNo) {
//             showHeader = true;
//           }
//         }
//
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (showHeader) _buildGroupHeader(item),
//             _buildReportCard(item),
//           ],
//         );
//       },
//     );
//   }
//
//   // --- DESKTOP GRID VIEW ---
//   Widget _buildGridView(ASNController controller, double width) {
//     return GridView.builder(
//       padding: const EdgeInsets.all(16),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: width > 1200 ? 4 : (width > 900 ? 3 : 2),
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//         mainAxisExtent: 185, // Fixed height to prevent layout errors
//       ),
//       itemCount: controller.asnList.length,
//       itemBuilder: (context, index) {
//         final item = controller.asnList[index];
//         return _buildReportCard(item, showInvoiceInline: true);
//       },
//     );
//   }
//
//   // --- UI COMPONENTS ---
//
//   Widget _buildGroupHeader(dynamic item) {
//     String status = item.completed == 1 ? "Completed" : "Pending";
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//       child: Row(
//         children: [
//           const Icon(Icons.receipt_long, size: 16, color: Color(0xFF3B6EBF)),
//           const SizedBox(width: 8),
//           Text(
//             "Inv: ${item.supplierInvoiceNo}",
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 14,
//               color: Color(0xFF3B6EBF),
//             ),
//           ),
//           const Spacer(),
//           Text(
//             status,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//               color: item.completed == 1 ? Colors.green : Colors.orange,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildReportCard(dynamic item, {bool showInvoiceInline = false}) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (showInvoiceInline) ...[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     "Inv: ${item.supplierInvoiceNo}",
//                     style: const TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF3B6EBF),
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Text(
//                   item.completed == 1 ? "Completed" : "Pending",
//                   style: TextStyle(
//                     fontSize: 10,
//                     color: item.completed == 1 ? Colors.green : Colors.orange,
//                   ),
//                 ),
//               ],
//             ),
//             const Divider(height: 12),
//           ],
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Text(
//                   item.item ?? "--",
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 13,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               Text(
//                 "PO: ${item.poNo}",
//                 style: const TextStyle(fontSize: 12, color: Colors.grey),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           Text(
//             "${item.itemName}",
//             style: const TextStyle(fontSize: 12, color: Colors.black54),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           const Spacer(),
//           const Divider(),
//           Row(
//             children: [
//               _statTile("Qty", "${item.qty} ${item.uom}"),
//               const Spacer(),
//               _statTile("Rate", "${item.rate}"),
//               const Spacer(),
//               _statTile("Total", "${item.amount}", isBold: true),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _statTile(String label, String value, {bool isBold = false}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 11,
//             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//             color: isBold ? const Color(0xFF3B6EBF) : Colors.black87,
//           ),
//         ),
//       ],
//     );
//   }
//
//   // --- FILTERS & PICKERS ---
//
//   void _openFilterSheet(BuildContext context, ASNController controller) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) => Padding(
//         padding: EdgeInsets.only(
//           left: 20,
//           right: 20,
//           top: 20,
//           bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 "Filter Reports",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 20),
//               _dateRangeField(context, controller),
//               _textField("Invoice No", controller.invoiceSearchCtrl),
//               _textField("Item Code", controller.itemSearchCtrl),
//               _textField("Item Name", controller.itemDescSearchCtrl),
//               const SizedBox(height: 20),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () {
//                         controller.invoiceSearchCtrl.clear();
//                         controller.itemSearchCtrl.clear();
//                         controller.itemDescSearchCtrl.clear();
//                         _onLoad();
//                         Navigator.pop(context);
//                       },
//                       child: const Text("Reset"),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF3B6EBF),
//                       ),
//                       onPressed: () async {
//                         await controller.applyFilters();
//                         Navigator.pop(context);
//                       },
//                       child: const Text(
//                         "Apply Filters",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _textField(String label, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           isDense: true,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       ),
//     );
//   }
//
//   Widget _dateRangeField(BuildContext context, ASNController controller) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: TextField(
//         controller: controller.dateRangeController,
//         readOnly: true,
//         onTap: () async {
//           DateTimeRange? picked = await showDateRangePicker(
//             context: context,
//             firstDate: DateTime(2020),
//             lastDate: DateTime(2100),
//             initialDateRange: controller.selectedRange,
//           );
//           if (picked != null) {
//             controller.selectedRange = picked;
//             controller.dateRangeController.text =
//                 "${controller.fmt(picked.start)}  →  ${controller.fmt(picked.end)}";
//           }
//         },
//         decoration: InputDecoration(
//           labelText: "Date Range",
//           prefixIcon: const Icon(Icons.date_range),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       ),
//     );
//   }
// }

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
