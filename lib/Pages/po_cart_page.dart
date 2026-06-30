import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../controller/smartPoController.dart';
import 'po_list_page.dart';
import 'report_view.dart';
import 'autoPoMaster.dart';
import '../controller/login_controller.dart';

class POCartItemsPage extends StatefulWidget {
  const POCartItemsPage({super.key});

  @override
  State<POCartItemsPage> createState() => _POCartItemsPageState();
}

class _POCartItemsPageState extends State<POCartItemsPage> {
  SmartPoController smartPoController = Get.put(SmartPoController());
  late NewOrderDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await smartPoController.loadUserId();
    await smartPoController.fetchCartItems();
    smartPoController.supplierNewOrderCartList.clear();
    smartPoController.update();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SmartPoController>(
      builder: (controller) {
        _dataSource = NewOrderDataSource(
          items: controller.filteredCartItemsList,
          controller: controller,
        );

        return Scaffold(
          drawer: _buildDrawer(context),
          backgroundColor: const Color(0xFFF2F4F8),
          appBar: AppBar(
            backgroundColor: const Color(0xFF3B6EBF),
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Row(
              children: [
                Text("New Orders", style: TextStyle(color: Colors.white)),
                SizedBox(width: 8),
                Expanded(child: _buildSearchField(controller)),
              ],
            ),
            actions: [
              // Accept Button Moved to Top
              // if (controller.supplierNewOrderCartList.isNotEmpty)
              !controller.loading
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await _confirmAccept(context, controller);
                        },
                        icon: const Icon(Icons.check_circle, size: 18),
                        label: Text(
                          "Accept (${controller.supplierNewOrderCartList.length})",
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    )
                  : Container(),
              !controller.loading
                  ? IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _load,
                    )
                  : Container(),
              const SizedBox(width: 8),
            ],
          ),
          body: controller.loading
              ? const Center(child: CircularProgressIndicator())
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
                      source: _dataSource,
                      columnWidthMode: ColumnWidthMode.fill,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      gridLinesVisibility: GridLinesVisibility.horizontal,
                      selectionMode: SelectionMode.none,
                      // Custom tap handling
                      navigationMode: GridNavigationMode.cell,
                      onCellTap: (details) {
                        if (details.rowColumnIndex.rowIndex > 0) {
                          final row =
                              controller.filteredCartItemsList[details
                                      .rowColumnIndex
                                      .rowIndex -
                                  1];
                          controller.onAddCart(context, row);
                        }
                      },
                      columns: [
                        GridColumn(
                          columnName: 'select',
                          width: 70,
                          label: Container(
                            alignment: Alignment.center,
                            child: const Text("Select"),
                          ),
                        ),
                        _gridCol('itemCode', 'Item Code', width: 150),
                        _gridCol('itemName', 'Item Name', width: 250),
                        _gridCol('rate', 'Rate (₹)', width: 100),
                        _gridCol('binQty', 'Bin Qty', width: 100),
                        _gridCol('reqQty', 'Req Qty', width: 120),
                        _gridCol('date', 'Req Date', width: 120),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildSearchField(SmartPoController controller) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        onChanged: (val) {
          // Assuming your controller has a search method
          controller.searchNewOrders(val);
        },
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: "Search Code or Name...",
          hintStyle: TextStyle(color: Colors.white70),
          prefixIcon: Icon(Icons.search, color: Colors.white70),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  GridColumn _gridCol(String name, String label, {required double width}) {
    return GridColumn(
      columnName: name,
      width: width,
      label: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.centerLeft,
        color: const Color(0xFFF8FAFC),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Future<void> _confirmAccept(
    BuildContext context,
    SmartPoController controller,
  ) async {
    bool? value = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm PO Creation"),
        content: Text(
          "Accept ${controller.supplierNewOrderCartList.length} items?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
    if (value == true) {
      await controller.createPo(list: controller.supplierNewOrderCartList);
    }
  }

  // --- DRAWER CODE (Slightly Cleaned) ---
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF3B6EBF)),
            child: Text(
              "Smart PO",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _drawerItem(
            Icons.shopping_cart,
            "New Orders",
            () => Navigator.pop(context),
          ),
          _drawerItem(
            Icons.pending_actions,
            "Pending PO",
            () => Get.to(() => const PurchaseOrderListPage()),
          ),
          _drawerItem(
            Icons.analytics,
            "Invoice Report",
            () => Get.to(() => const InvoiceReportScreen()),
          ),
          _drawerItem(
            Icons.settings,
            "Item Master",
            () => Get.to(() => const AutoPoMasterScreen()),
          ),
          const Divider(),
          _drawerItem(Icons.logout, "Logout", () async {
            bool? logout = await showDialog(
              context: context,
              builder: (c) => AlertDialog(
                title: const Text("Logout?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(c, false),
                    child: const Text("No"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(c, true),
                    child: const Text("Yes"),
                  ),
                ],
              ),
            );
            if (logout == true) await LoginController().logout();
          }),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }
}

class NewOrderDataSource extends DataGridSource {
  final List<dynamic> items;
  final SmartPoController controller;

  NewOrderDataSource({required this.items, required this.controller}) {
    _buildRows();
  }

  List<DataGridRow> _dataGridRows = [];

  void _buildRows() {
    _dataGridRows = items.map<DataGridRow>((item) {
      return DataGridRow(
        cells: [
          DataGridCell<dynamic>(columnName: 'object', value: item),

          DataGridCell<bool>(
            columnName: 'select',
            value: controller.supplierNewOrderCartList.contains(item),
          ),

          DataGridCell<String>(columnName: 'itemCode', value: item.itemCode),
          DataGridCell<String>(columnName: 'itemName', value: item.itemName),
          DataGridCell<double>(
            columnName: 'rate',
            value: item.rate?.toDouble(),
          ),
          DataGridCell<int>(columnName: 'binQty', value: item.binQty),
          DataGridCell<String>(
            columnName: 'reqQty',
            value: "${item.requestedQty} ${item.uom}",
          ),
          DataGridCell<String>(
            columnName: 'date',
            value: item.remarksDate?.toIso8601String().split('T')[0] ?? "--",
          ),
        ],
      );
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final dynamic item = row.getCells()[0].value;

    return DataGridRowAdapter(
      cells: row.getCells().skip(1).map<Widget>((cell) {
        // ✅ CHECKBOX COLUMN
        if (cell.columnName == 'select') {
          return Center(
            child: Checkbox(
              value: controller.supplierNewOrderCartList.contains(item),
              onChanged: (value) {
                if (value == true) {
                  controller.supplierNewOrderCartList.add(item);
                } else {
                  controller.supplierNewOrderCartList.remove(item);
                }
                controller.update(); // refresh UI
              },
            ),
          );
        }

        // ✅ NORMAL CELLS
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            cell.value?.toString() ?? "--",
            style: TextStyle(
              fontWeight: cell.columnName == 'itemCode'
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }
}
