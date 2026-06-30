import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
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

  // if (width < 600) {
  // // Mobile
  // } else if (width < 1024) {
  // // Tablet
  // } else {
  // // Desktop
  // }
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
    double width = MediaQuery.of(context).size.width;
    return GetBuilder<POListController>(
      init: poListController,
      builder: (c) {
        return Scaffold(
          backgroundColor: const Color(0xFFF2F4F8),
          appBar: AppBar(
            backgroundColor: const Color(0xFF3B6EBF),
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Row(
              children: [
                const Text(
                  "Purchase Order List",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (width > 1024)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        color: const Color(0xFF3B6EBF),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: TextField(
                          onChanged: c.search,
                          decoration: InputDecoration(
                            hintText: "Search PO / Code / Name",
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            actions: [
              if (width > 1024)
                ElevatedButton.icon(
                  onPressed: c.selectedItems.isEmpty
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateASNPage(),
                            ),
                          );
                        },
                  icon: const Icon(Icons.local_shipping, color: Colors.white),
                  label: Text(
                    "Create ASN (${c.selectedItems.length})",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B6EBF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                ),
              IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
              IconButton(
                onPressed: c.clearSelection,
                icon: const Icon(Icons.layers_clear),
              ),
              IconButton(
                onPressed: c.selectedItems.isEmpty
                    ? null
                    : () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );

                        if (selectedDate == null) return;

                        // ✅ LOCAL UPDATE
                        for (var item in c.selectedItems) {
                          item.dispatchDate = selectedDate
                              .toIso8601String()
                              .split('T')[0];
                        }

                        c.update();

                        Get.defaultDialog(
                          title: "Update Dispatch Date",
                          middleText:
                              "Update dispatch date for ${c.selectedItems.length} rows ?",
                          textConfirm: "Update",
                          textCancel: "Cancel",
                          confirmTextColor: Colors.white,

                          onConfirm: () async {
                            Get.back();
                            await c.updateDispatchDate(
                              items: c.selectedItems.map((e) {
                                return {
                                  "po_name": e.poNumber,
                                  "po_item_name": e.poiName,
                                  "custom_date": selectedDate
                                      .toIso8601String()
                                      .split('T')[0],
                                };
                              }).toList(),
                            );
                          },
                        );
                      },
                icon: const Icon(Icons.edit_calendar, color: Colors.white),
              ),
            ],
          ),
          body: Column(
            children: [
              // --- SEARCH BAR SECTION (Fixed Height to prevent layout errors) ---
              if (width < 1024)
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
                      return _buildTableView(c);
                    }
                  },
                ),
              ),

              // --- BOTTOM ACTION BUTTON ---
              if (width < 1024) _buildBottomButton(c),
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

  Widget _buildTableView(POListController c) {
    final PODataSource poDataSource = PODataSource(
      items: c.filteredItems,
      controller: c,
      packetQtyFn: _packetQty,
    );

    return poListController.loading
        ? Center(child: CircularProgressIndicator())
        : Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SfDataGrid(
                source: poDataSource,
                // Changed to .none to ensure horizontal scroll when columns are wide
                columnWidthMode: ColumnWidthMode.none,
                headerGridLinesVisibility: GridLinesVisibility.both,
                gridLinesVisibility: GridLinesVisibility.horizontal,

                // Disable built-in selection colors to prevent the "Red/Pink" highlight
                selectionMode: SelectionMode.none,
                navigationMode: GridNavigationMode.row,

                // Manual Cell Tap Handling for 1-click selection
                onCellTap: (DataGridCellTapDetails details) {
                  // index 0 is header, so we check > 0
                  if (details.rowColumnIndex.rowIndex > 0) {
                    // Get the item using the row index
                    final int index = details.rowColumnIndex.rowIndex - 1;
                    final item = c.filteredItems[index];

                    // Toggle selection in your controller
                    c.toggleSelection(item);
                  }
                },

                columns: [
                  GridColumn(
                    columnName: 'select',
                    width: 70,
                    label: Container(
                      alignment: Alignment.center,
                      child: const Text(""),
                    ),
                  ),
                  _gridCol('poNumber', 'PO Number', width: 150),
                  _gridCol('poDate', 'PO Date', width: 150),
                  _gridCol('itemCode', 'Item Code', width: 140),
                  _gridCol('itemName', 'Item Name', width: 300),
                  _gridCol('poQty', 'PO QTY', width: 100),
                  _gridCol('pending', 'Pending', width: 100),
                  _gridCol('uom', 'UOM', width: 100),
                  _gridCol('rate', 'RATE', width: 100),
                  _gridCol('remarksDate', 'Dispatch Date', width: 100),
                  // _gridCol('packet', 'Packet Qty', width: 120),
                ],
              ),
            ),
          );
  }

  GridColumn _gridCol(String name, String label, {required double width}) {
    return GridColumn(
      columnName: name,
      width: width,
      // Fixed width forces horizontal scroll if total > screen width
      label: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        color: const Color(0xFFF8FAFC),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
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
        Text(
          value,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildBottomButton(POListController c) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
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
                      MaterialPageRoute(
                        builder: (context) => const CreateASNPage(),
                      ),
                    );
                  },
            icon: const Icon(Icons.local_shipping, color: Colors.white),
            label: Text(
              "Create ASN (${c.selectedItems.length})",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B6EBF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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

class PODataSource extends DataGridSource {
  final List<PurchaseOrderItemModel> items;
  final POListController controller;
  final String Function(PurchaseOrderItemModel) packetQtyFn;

  PODataSource({
    required this.items,
    required this.controller,
    required this.packetQtyFn,
  }) {
    _buildDataGridRows();
  }

  List<DataGridRow> _dataGridRows = [];

  void _buildDataGridRows() {
    _dataGridRows = items.map<DataGridRow>((item) {
      return DataGridRow(
        cells: [
          DataGridCell<PurchaseOrderItemModel>(
            columnName: 'object',
            value: item,
          ),
          DataGridCell<bool>(
            columnName: 'select',
            value: controller.isSelected(item),
          ),
          DataGridCell<String>(columnName: 'poNumber', value: item.poNumber),
          DataGridCell<String>(columnName: 'poDate', value: item.poDate),
          DataGridCell<String>(columnName: 'itemCode', value: item.itemCode),
          DataGridCell<String>(columnName: 'itemName', value: item.itemName),
          DataGridCell<String>(
            columnName: 'poQty',
            value: item.poQty.toString(),
          ),
          DataGridCell<double>(
            columnName: 'pending',
            value: item.pendingQty?.toDouble(),
          ),
          DataGridCell<String>(columnName: 'uom', value: item.uom),
          DataGridCell<String>(columnName: 'rate', value: item.rate.toString()),
          DataGridCell<String>(
            columnName: 'dispatchDate',
            value: item.dispatchDate.toString(),
          ),
          // DataGridCell<String>(columnName: 'glQty', value: item.glQty),
          // DataGridCell<String>(columnName: 'packet', value: packetQtyFn(item)),
        ],
      );
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final PurchaseOrderItemModel item = row.getCells()[0].value;
    final bool isSelected = controller.isSelected(item);

    return DataGridRowAdapter(
      color: isSelected ? const Color(0xFFE3F2FD) : Colors.white,

      cells: row.getCells().skip(1).map<Widget>((cell) {
        // ✅ CHECKBOX
        if (cell.columnName == 'select') {
          return Center(
            child: Checkbox(
              value: isSelected,
              activeColor: const Color(0xFF3B6EBF),
              onChanged: (val) {
                controller.toggleSelection(item);
              },
            ),
          );
        }

        // ✅ DISPATCH DATE CLICK EVENT
        if (cell.columnName == 'dispatchDate') {
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  (cell.value == "null" ? "---" : cell.value)?.toString() ??
                      "--",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          );
        }

        // ✅ NORMAL CELLS
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            cell.value?.toString() ?? "--",
            style: const TextStyle(fontSize: 13),
          ),
        );
      }).toList(),
    );
  }
}
