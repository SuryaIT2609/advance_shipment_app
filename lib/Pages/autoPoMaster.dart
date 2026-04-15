// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/get_instance.dart';
// import 'package:get/get_state_manager/src/simple/get_state.dart';
// import 'package:po_asn_app/controller/auto_po_master_controller.dart';
//
// import '../controller/asn_controller.dart';
// import '../controller/login_controller.dart';
// import '../controller/smartPoController.dart';
// import '../model/auto_po_model.dart';
//
//
// class AutoPoMasterScreen extends StatefulWidget {
//   const AutoPoMasterScreen({super.key});
//
//   @override
//   State<AutoPoMasterScreen> createState() => _AutoPoMasterScreenState();
// }
//
// class _AutoPoMasterScreenState extends State<AutoPoMasterScreen>
//     with SingleTickerProviderStateMixin {
//   AutoPoItemMasterController controller = Get.put(AutoPoItemMasterController());
//   LoginController loginController = Get.put(LoginController());
//
//   @override
//   void initState() {
//     super.initState();
//     _onLoad();
//   }
//
//   Future<void> _onLoad() async {
//     await controller.fetchAutoPoItems();
//     controller.update();
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
//                 Text("Item Master"),
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
//               await _onLoad();
//             },
//             child: Padding(
//               padding: EdgeInsets.only(right: 12),
//               child: Icon(Icons.refresh, color: Colors.white),
//             ),
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
//                     child: controller.autoPoItemList.isEmpty
//                         ? Center(
//                             child: Text(
//                               "No Data",
//                               style: TextStyle(fontSize: 24),
//                             ),
//                           )
//                         : ListView.builder(
//                             padding: const EdgeInsets.all(12),
//                             itemCount: controller.autoPoItemList.length,
//                             itemBuilder: (context, index) {
//                               AutoPoItemReportModel item =
//                                   controller.autoPoItemList[index];
//                               return Container(
//                                 margin: EdgeInsets.only(bottom: 12),
//                                 padding: EdgeInsets.all(16),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(16),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black12,
//                                       blurRadius: 8,
//                                       offset: Offset(0, 4),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         SizedBox(
//                                           width: 220,
//                                           child: Text(
//                                             item.itemCode ?? "--",
//                                             style: TextStyle(fontSize: 14),
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                         Text(
//                                           "BOX: ${item.boxQty}",
//                                           style: TextStyle(fontSize: 14),
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: 8),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         SizedBox(
//                                           width: 220,
//                                           child: Text(
//                                             "${item.itemName}",
//                                             style: TextStyle(fontSize: 14),
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                         Text(
//                                           "Packet: ${item.packetQtyNos}",
//                                           style: TextStyle(fontSize: 14),
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: 8),
//                                     Row(
//                                       children: [
//                                         Text(
//                                           "Rate: ${(item.rate ?? 0)}",
//                                           style: TextStyle(fontSize: 14),
//                                         ),
//                                         Spacer(),
//                                         Text(
//                                           "Amount: ${(item.amount ?? 0)}",
//                                           style: TextStyle(fontSize: 14),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
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
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:po_asn_app/controller/auto_po_master_controller.dart';
import '../controller/login_controller.dart';
import '../model/auto_po_model.dart';

class AutoPoMasterScreen extends StatefulWidget {
  const AutoPoMasterScreen({super.key});

  @override
  State<AutoPoMasterScreen> createState() => _AutoPoMasterScreenState();
}

class _AutoPoMasterScreenState extends State<AutoPoMasterScreen>
    with SingleTickerProviderStateMixin {
  AutoPoItemMasterController controller = Get.put(AutoPoItemMasterController());
  LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    _onLoad();
  }

  Future<void> _onLoad() async {
    await controller.fetchAutoPoItems();
    controller.update();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AutoPoItemMasterController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF3B6EBF),
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              "Item Master",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(icon: const Icon(Icons.refresh), onPressed: _onLoad),
            ],
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF2F4F8), Color(0xFFE8F4F8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // --- SEARCH BAR ---
                  Container(
                    color: const Color(0xFF3B6EBF),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: TextField(
                      onChanged: (value) {
                        // Assuming your controller has a search function
                        // controller.searchItems(value);
                      },
                      decoration: InputDecoration(
                        hintText: "Search by Code or Name",
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  // --- RESPONSIVE CONTENT ---
                  Expanded(
                    child: controller.autoPoItemList.isEmpty
                        ? const Center(
                            child: Text(
                              "No Data Found",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              if (constraints.maxWidth > 700) {
                                return _buildGridView(
                                  controller,
                                  constraints.maxWidth,
                                );
                              }
                              return _buildListView(controller);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- MOBILE LIST VIEW ---
  Widget _buildListView(AutoPoItemMasterController controller) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: controller.autoPoItemList.length,
      itemBuilder: (context, index) {
        return _buildItemCard(controller.autoPoItemList[index]);
      },
    );
  }

  // --- DESKTOP GRID VIEW ---
  Widget _buildGridView(AutoPoItemMasterController controller, double width) {
    int crossAxisCount = width > 1200 ? 4 : (width > 900 ? 3 : 2);
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 170, // Fixed height to prevent overflow
      ),
      itemCount: controller.autoPoItemList.length,
      itemBuilder: (context, index) {
        return _buildItemCard(controller.autoPoItemList[index]);
      },
    );
  }

  // --- REUSABLE ITEM CARD ---
  Widget _buildItemCard(AutoPoItemReportModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4), // Margin for ListView
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.itemCode ?? "--",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B6EBF),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _badgeIndicator("BOX: ${item.boxQty}"),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "${item.itemName}",
            style: const TextStyle(fontSize: 13, color: Colors.black87),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          const Divider(height: 20),
          Row(
            children: [
              Expanded(
                child: _statColumn("Rate", item.rate?.toString() ?? "0"),
              ),
              Expanded(
                child: _statColumn(
                  "Packet",
                  item.packetQtyNos?.toString() ?? "0",
                ),
              ),
              Expanded(
                child: _statColumn(
                  "Amount",
                  item.amount?.toString() ?? "0",
                  isTotal: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badgeIndicator(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade700,
        ),
      ),
    );
  }

  Widget _statColumn(String label, String value, {bool isTotal = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.green.shade700 : Colors.black87,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
