// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/po_list_controller.dart';
// import '../controller/smartPoController.dart';
// import '../model/poPendingItemModel.dart';
// import 'asn_list_page.dart';
// import 'create_asn_page.dart';
//
// class PurchaseOrderListPage extends StatefulWidget {
//   const PurchaseOrderListPage({super.key});
//
//   @override
//   State<PurchaseOrderListPage> createState() => _PurchaseOrderListPageState();
// }
//
// class _PurchaseOrderListPageState extends State<PurchaseOrderListPage> {
//   POListController poListController = Get.put(POListController());
//
//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }
//
//   Future<void> _load() async {
//     await poListController.fetchPOItems();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<POListController>(
//       init: poListController,
//       builder: (c) {
//         return Scaffold(
//           backgroundColor: const Color(0xFFF2F4F8),
//           appBar: AppBar(
//             backgroundColor: const Color(0xFF3B6EBF),
//             title: const Text(
//               "Purchase Order List",
//               style: TextStyle(color: Colors.white),
//             ),
//             actions: [
//               IconButton(
//                 onPressed: () async {
//                   await _load();
//                 },
//                 icon: Icon(Icons.refresh, color: Colors.white),
//               ),
//               IconButton(
//                 onPressed: () {
//                   c.clearSelection();
//                 },
//                 icon: Icon(Icons.clear, color: Colors.white),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   poListController.selectedItems.length.toString(),
//                   style: TextStyle(color: Colors.white, fontSize: 26),
//                 ),
//               ),
//             ],
//           ),
//           body: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: TextField(
//                   onChanged: c.search,
//                   decoration: InputDecoration(
//                     hintText: "Search PO / Item Code / Item Name",
//                     prefixIcon: const Icon(Icons.search),
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//               ),
//
//               // 📋 LIST
//               Expanded(
//                 child: ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: c.filteredItems.length,
//                   itemBuilder: (context, index) {
//                     PurchaseOrderItemModel row = c.filteredItems[index];
//                     bool selected = c.isSelected(row);
//
//                     return GestureDetector(
//                       onTap: () => c.toggleSelection(row),
//                       child: Container(
//                         margin: const EdgeInsets.only(bottom: 12),
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: selected ? Colors.blue.shade50 : Colors.white,
//                           borderRadius: BorderRadius.circular(14),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.05),
//                               blurRadius: 8,
//                               offset: const Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           children: [
//                             Checkbox(
//                               value: selected,
//                               onChanged: (_) => c.toggleSelection(row),
//                             ),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     row.poNumber ?? "--",
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                   Text(row.itemCode ?? "--"),
//                                   Text(
//                                     row.itemName ?? "--",
//                                     style: const TextStyle(
//                                       color: Colors.black54,
//                                     ),
//                                   ),
//                                   Text("Pending Qty: ${row.pendingQty}"),
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               child: Column(
//                                 children: [
//                                   Text("Monthly : ${row.glQty}"),
//                                   Text("BOX : ${row.boxQty}"),
//                                   Text("Packet : ${_packetQty(row)}"),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//
//               // 🚚 CREATE ASN BUTTON
//               SafeArea(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: SizedBox(
//                     width: double.infinity,
//                     height: 48,
//                     child: ElevatedButton.icon(
//                       icon: const Icon(
//                         Icons.local_shipping,
//                         color: Colors.white,
//                       ),
//                       label: const Text(
//                         "Create ASN",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF3B6EBF),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       onPressed: c.selectedItems.isEmpty
//                           ? null
//                           : () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute<void>(
//                                   builder: (context) => CreateASNPage(),
//                                 ),
//                               );
//                             },
//                     ),
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
//   String _packetQty(PurchaseOrderItemModel row) {
//     String value = "";
//     if (row.uom == "Nos") {
//       value = (row.packetQtyNos ?? 0).toString();
//     } else if (row.uom == "Kg") {
//       value = (row.packetQtyKg ?? 0).toString();
//     }
//     return value;
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/po_list_controller.dart';
import '../model/poPendingItemModel.dart';
import 'create_asn_page.dart';

class PurchaseOrderListPage extends StatefulWidget {
  const PurchaseOrderListPage({super.key});

  @override
  State<PurchaseOrderListPage> createState() => _PurchaseOrderListPageState();
}

class _PurchaseOrderListPageState extends State<PurchaseOrderListPage> {
  POListController poListController = Get.put(POListController());

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await poListController.fetchPOItems();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<POListController>(
      init: poListController,
      builder: (c) {
        return Scaffold(
          backgroundColor: const Color(0xFFF2F4F8),
          appBar: AppBar(
            backgroundColor: const Color(0xFF3B6EBF),
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              "Purchase Order List",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                onPressed: _load,
                icon: const Icon(Icons.refresh),
              ),
              IconButton(
                onPressed: c.clearSelection,
                icon: const Icon(Icons.layers_clear),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Text(
                    c.selectedItems.length.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // --- SEARCH BAR SECTION (Fixed Height to prevent layout errors) ---
              Container(
                width: double.infinity,
                color: const Color(0xFF3B6EBF),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: TextField(
                  onChanged: c.search,
                  decoration: InputDecoration(
                    hintText: "Search PO / Code / Name",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // --- RESPONSIVE LIST/GRID ---
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Mobile View
                    if (constraints.maxWidth < 650) {
                      return _buildListView(c);
                    }
                    // Desktop/Tablet View
                    else {
                      return _buildGridView(c, constraints.maxWidth);
                    }
                  },
                ),
              ),

              // --- BOTTOM ACTION BUTTON ---
              _buildBottomButton(c),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListView(POListController c) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: c.filteredItems.length,
      itemBuilder: (context, index) {
        return _buildItemCard(c, c.filteredItems[index]);
      },
    );
  }

  Widget _buildGridView(POListController c, double screenWidth) {
    int crossAxisCount = screenWidth > 1100 ? 4 : (screenWidth > 800 ? 3 : 2);
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 180, // Fixes height in grid to prevent overflow
      ),
      itemCount: c.filteredItems.length,
      itemBuilder: (context, index) {
        return _buildItemCard(c, c.filteredItems[index]);
      },
    );
  }

  Widget _buildItemCard(POListController c, PurchaseOrderItemModel row) {
    bool selected = c.isSelected(row);

    return GestureDetector(
      onTap: () => c.toggleSelection(row),
      child: Container(
        height: 200,
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: selected
              ? Border.all(color: const Color(0xFF3B6EBF), width: 2)
              : Border.all(color: Colors.transparent, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: selected,
                    onChanged: (_) => c.toggleSelection(row),
                    activeColor: const Color(0xFF3B6EBF),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    row.poNumber ?? "--",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            Text(
              "Item: ${row.itemCode}",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Text(
              row.itemName ?? "--",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statCol("Pending", row.pendingQty.toString()),
                  _statCol("GL Qty", row.glQty.toString()),
                  _statCol("Packet", _packetQty(row)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCol(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBottomButton(POListController c) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: c.selectedItems.isEmpty
                ? null
                : () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateASNPage()),
              );
            },
            icon: const Icon(Icons.local_shipping, color: Colors.white),
            label: Text(
              "Create ASN (${c.selectedItems.length})",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B6EBF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }

  String _packetQty(PurchaseOrderItemModel row) {
    if (row.uom == "Nos") return (row.packetQtyNos ?? 0).toString();
    if (row.uom == "Kg") return (row.packetQtyKg ?? 0).toString();
    return "0";
  }
}