import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:po_asn_app/Pages/po_list_page.dart';
import 'package:po_asn_app/Pages/report_view.dart';
import 'package:po_asn_app/controller/login_controller.dart';
import '../controller/smartPoController.dart';
import 'autoPoMaster.dart';

class POCartItemsPage extends StatefulWidget {
  const POCartItemsPage({super.key});

  @override
  State<POCartItemsPage> createState() => _POCartItemsPageState();
}

class _POCartItemsPageState extends State<POCartItemsPage> {
  SmartPoController smartPoController = Get.put(SmartPoController());

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await smartPoController.loadUserId();
    await smartPoController.fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SmartPoController>(
      init: smartPoController,
      builder: (controller) {
        return Scaffold(
          drawer: _buildDrawer(context),
          backgroundColor: const Color(0xFFF2F4F8),
          appBar: AppBar(
            backgroundColor: const Color(0xFF3B6EBF),
            elevation: 0,
            title: InkWell(
              onTap: () async {
                bool value = await showDialogueForLogout(context);
                if (value) {
                  await LoginController().logout();
                }
              },
              child: const Text(
                "New Orders",
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () async => await _load(),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 14,
                    child: Text(
                      controller.supplierNewOrderCartList.length.toString(),
                      style: const TextStyle(
                        color: Color(0xFF3B6EBF),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: controller.loading
                    ? const Center(child: CircularProgressIndicator())
                    : controller.filteredCartItemsList.isEmpty
                    ? const Center(child: Text("No Cart Items Found"))
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          // If width is greater than 600, use GridView (Desktop/Tablet)
                          if (constraints.maxWidth > 600) {
                            return _buildGridView(
                              controller,
                              constraints.maxWidth,
                            );
                          }
                          // Otherwise use ListView (Mobile)
                          return _buildListView(controller);
                        },
                      ),
              ),
              _buildBottomAction(controller),
            ],
          ),
        );
      },
    );
  }

  // --- RESPONSIVE VIEWS ---

  Widget _buildListView(SmartPoController controller) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.filteredCartItemsList.length,
      itemBuilder: (context, index) {
        final row = controller.filteredCartItemsList[index];
        return _buildItemCard(controller, row);
      },
    );
  }

  Widget _buildGridView(SmartPoController controller, double width) {
    // Determine column count based on width
    int crossAxisCount = width > 1200 ? 4 : (width > 900 ? 3 : 2);

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.8, // Adjust this to fit content height in grid
      ),
      itemCount: controller.filteredCartItemsList.length,
      itemBuilder: (context, index) {
        final row = controller.filteredCartItemsList[index];
        return _buildItemCard(controller, row);
      },
    );
  }

  // --- SHARED UI COMPONENTS ---

  Widget _buildItemCard(SmartPoController controller, dynamic row) {
    bool isSelected = controller.supplierNewOrderCartList.contains(row);

    return InkWell(
      onTap: () => controller.onAddCart(context, row),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4), // Margin for ListView
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: isSelected
              ? Border.all(color: const Color(0xFF3B6EBF), width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: isSelected,
              activeColor: const Color(0xFF3B6EBF),
              onChanged: (v) => controller.onAddCart(context, row),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          row.itemCode,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        "₹ ${row.rate}",
                        style: const TextStyle(
                          color: Color(0xFF3B6EBF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    row.itemName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "BIN: ${row.binQty}",
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            "${row.requestedQty} ${row.uom}",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Text(
                        row.remarksDate != null
                            ? row.remarksDate!.toIso8601String().split('T')[0]
                            : "---",
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAction(SmartPoController controller) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (controller.loading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Accept ${controller.supplierNewOrderCartList.length} Items",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B6EBF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: controller.supplierNewOrderCartList.isEmpty
                        ? null
                        : () async {
                            bool? value = await showUpdateConfirmationDialog(
                              context,
                              controller.supplierNewOrderCartList.length,
                            );
                            if (value == true) {
                              await smartPoController.createPo(
                                list: controller.supplierNewOrderCartList,
                              );
                            }
                          },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF3B6EBF)),
            accountName: Text(
              "Smart PO System",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text("Inventory Management"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.business, color: Color(0xFF3B6EBF), size: 40),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text("New Orders"),
            selected: true,
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.pending_actions),
            title: const Text("Pending PO"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PurchaseOrderListPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text("Invoice Report"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InvoiceReportScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text("Item Master"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AutoPoMasterScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- DIALOGS ---

  Future<bool> showUpdateConfirmationDialog(
    BuildContext context,
    int totalLength,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text("Confirm Selection"),
            content: Text(
              "Are you sure you want to accept $totalLength items into a Purchase Order?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text(
                  "Confirm",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> showDialogueForLogout(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Logout"),
            content: const Text("Are you sure you want to logout?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}

//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:po_asn_app/Pages/po_list_page.dart';
// import 'package:po_asn_app/Pages/report_view.dart';
// import 'package:po_asn_app/controller/login_controller.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../controller/asn_controller.dart';
// import '../controller/po_cart_controller.dart';
// import '../controller/po_pending_controller.dart';
// import '../controller/smartPoController.dart';
// import '../service/service.dart';
// import 'autoPoMaster.dart';
//
// class POCartItemsPage extends StatefulWidget {
//   const POCartItemsPage({super.key});
//
//   @override
//   State<POCartItemsPage> createState() => _POCartItemsPageState();
// }
//
// class _POCartItemsPageState extends State<POCartItemsPage> {
//   SmartPoController smartPoController = Get.put(SmartPoController());
//
//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }
//
//   Future<void> _load() async {
//     await smartPoController.loadUserId();
//     await smartPoController.fetchCartItems();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder(
//       init: smartPoController,
//       builder: (controller) {
//         return Scaffold(
//           drawer: Drawer(
//             backgroundColor: Colors.white,
//             child: SafeArea(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   DrawerHeader(
//                     decoration: BoxDecoration(color: Color(0xFF3B6EBF)),
//                     child: Align(
//                       alignment: Alignment.bottomLeft,
//                       child: Text(
//                         "Smart PO",
//                         style: TextStyle(
//                           fontSize: 22,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   ListTile(
//                     leading: const Icon(Icons.shopping_cart),
//                     title: const Text("New Orders"),
//                     onTap: () {},
//                   ),
//                   ListTile(
//                     leading: const Icon(Icons.local_shipping),
//                     title: const Text("Pending PO"),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute<void>(
//                           builder: (context) => const PurchaseOrderListPage(),
//                         ),
//                       );
//                     },
//                   ),
//                   ListTile(
//                     leading: const Icon(Icons.local_shipping),
//                     title: const Text("Invoice Report"),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute<void>(
//                           builder: (context) => const InvoiceReportScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                   ListTile(
//                     leading: const Icon(Icons.local_shipping),
//                     title: const Text("Item Master"),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute<void>(
//                           builder: (context) => const AutoPoMasterScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           backgroundColor: const Color(0xFFF2F4F8),
//           appBar: AppBar(
//             backgroundColor: const Color(0xFF3B6EBF),
//             elevation: 0,
//             title: InkWell(
//               onTap: () async {
//                 bool value = await showDialogueForLogout(context);
//                 if (value) {
//                   await LoginController().logout();
//                 }
//               },
//               child: const Text(
//                 "New Orders",
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.refresh, color: Colors.white),
//                 onPressed: () async {
//                   await _load();
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 15),
//                 child: Text(
//                   controller.supplierNewOrderCartList.length.toString(),
//                   style: TextStyle(color: Colors.white, fontSize: 20),
//                 ),
//               ),
//             ],
//           ),
//
//           // ================= BODY =================
//           body: Column(
//             children: [
//               Expanded(
//                 child: controller.loading
//                     ? const Center(child: CircularProgressIndicator())
//                     : controller.filteredCartItemsList.isEmpty
//                     ? const Center(child: Text("No Cart Items Found"))
//                     : ListView.builder(
//                         padding: const EdgeInsets.all(16),
//                         itemCount: controller.filteredCartItemsList.length,
//                         itemBuilder: (context, index) {
//                           final row = controller.filteredCartItemsList[index];
//                           bool value = controller.supplierNewOrderCartList
//                               .contains(row);
//                           return InkWell(
//                             onTap: () {
//                               controller.onAddCart(context, row);
//                             },
//                             child: Container(
//                               margin: const EdgeInsets.only(bottom: 12),
//                               padding: const EdgeInsets.all(16),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(14),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.05),
//                                     blurRadius: 10,
//                                     offset: const Offset(0, 4),
//                                   ),
//                                 ],
//                               ),
//                               child: Row(
//                                 children: [
//                                   Checkbox(value: value, onChanged: (v) {}),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Text(
//                                               row.itemCode,
//                                               style: const TextStyle(
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.w600,
//                                               ),
//                                             ),
//                                             Spacer(),
//                                             Text("Rate : ${row.rate}"),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           row.itemName,
//                                           style: const TextStyle(
//                                             color: Colors.black54,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 6),
//                                         Text(
//                                           "BIN Qty: ${row.binQty}",
//                                           style: const TextStyle(
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 6),
//                                         Text(
//                                           "Ordered Qty: ${row.requestedQty} ${row.uom}",
//                                           style: const TextStyle(
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   // ================= RIGHT =================
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     children: [
//                                       Text(
//                                         row.remarksDate != null
//                                             ? row.remarksDate!
//                                                   .toIso8601String()
//                                                   .split('T')[0]
//                                             : "---",
//                                         style: const TextStyle(
//                                           color: Colors.green,
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 8),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//               ),
//
//               // ================= BOTTOM BUTTON =================
//               SafeArea(
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 8,
//                         offset: Offset(0, -2),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       controller.loading
//                           ? Align(
//                               alignment: Alignment.center,
//                               child: SizedBox(
//                                 width: 40,
//                                 height: 48,
//                                 child: CircularProgressIndicator(),
//                               ),
//                             )
//                           : Expanded(
//                               child: SizedBox(
//                                 width: double.infinity,
//                                 height: 48,
//                                 child: ElevatedButton.icon(
//                                   icon: const Icon(
//                                     Icons.local_shipping,
//                                     color: Colors.white,
//                                   ),
//
//                                   label: const Text(
//                                     "Accept Items",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: const Color(0xFF3B6EBF),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                   onPressed: () async {
//                                     if (controller
//                                         .supplierNewOrderCartList
//                                         .isNotEmpty) {
//                                       bool? value =
//                                           await showUpdateConfirmationDialog(
//                                             context,
//                                             controller
//                                                 .supplierNewOrderCartList
//                                                 .length,
//                                           );
//                                       if (value) {
//                                         await smartPoController.createPo(
//                                           list: controller
//                                               .supplierNewOrderCartList,
//                                         );
//                                       }
//                                     }
//                                   },
//                                 ),
//                               ),
//                             ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<bool> showUpdateConfirmationDialog(
//     BuildContext context,
//     int totalLength,
//   ) async {
//     return await showDialog<bool>(
//           context: context,
//           barrierDismissible: false,
//           builder: (context) {
//             return AlertDialog(
//               title: const Text("Confirm Update"),
//               content: Text("Are you ready to make Accept $totalLength Items?"),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(false),
//                   child: const Text("Cancel"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => Navigator.of(context).pop(true),
//                   child: const Text("Yes, Update"),
//                 ),
//               ],
//             );
//           },
//         ) ??
//         false;
//   }
//
//   Future<bool> showDialogueForLogout(BuildContext context) async {
//     return await showDialog<bool>(
//           context: context,
//           barrierDismissible: false,
//           builder: (context) {
//             return AlertDialog(
//               title: const Text("Sure You Want To Logout"),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(false),
//                   child: const Text("Cancel"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => Navigator.of(context).pop(true),
//                   child: const Text("Logout"),
//                 ),
//               ],
//             );
//           },
//         ) ??
//         false;
//   }
// }
