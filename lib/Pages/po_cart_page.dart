import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/po_cart_controller.dart';
import '../controller/po_pending_controller.dart';

class POCartItemsPage extends StatelessWidget {
  const POCartItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<POPendingController>(
      init: POPendingController(),
      builder: (c) {
        return Scaffold(
          backgroundColor: const Color(0xFFF2F4F8),

          // ================= APP BAR =================
          appBar: AppBar(
            backgroundColor: const Color(0xFF3B6EBF),
            elevation: 0,
            title: const Text(
              "PO Cart Items",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: c.fetchCartItems,
              ),
            ],
          ),

          // ================= BODY =================
          body: Column(
            children: [
              // ================= LIST =================
              Expanded(
                child: c.loading
                    ? const Center(child: CircularProgressIndicator())
                    : c.items.isEmpty
                    ? const Center(child: Text("No Cart Items Found"))
                    : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: c.items.length,
                  itemBuilder: (context, index) {
                    final row = c.items[index];
                    final poCreated = row['po_created'] ?? 0;

                    return Container(
                      margin:
                      const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.05),
                            blurRadius: 10,
                            offset:
                            const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // ================= LEFT =================
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  row['item_code'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  row['item_name'] ?? '',
                                  style: const TextStyle(
                                    color:
                                    Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Qty: ${row['qty']}",
                                  style: const TextStyle(
                                    fontWeight:
                                    FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ================= RIGHT =================
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.end,
                            children: [
                              // STATUS
                              Container(
                                padding:
                                const EdgeInsets
                                    .symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: poCreated == 1
                                      ? Colors.grey
                                      .shade300
                                      : Colors.green
                                      .shade100,
                                  borderRadius:
                                  BorderRadius
                                      .circular(20),
                                ),
                                child: Text(
                                  poCreated == 1
                                      ? "ACCEPTED"
                                      : "OPEN",
                                  style: TextStyle(
                                    color: poCreated ==
                                        1
                                        ? Colors.grey
                                        .shade700
                                        : Colors.green,
                                    fontSize: 12,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              SizedBox(
                                height: 36,
                                child: ElevatedButton(
                                  style: ElevatedButton
                                      .styleFrom(
                                    backgroundColor:
                                    poCreated == 1
                                        ? Colors.grey
                                        : const Color(
                                        0xFF3B6EBF),
                                    shape:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius
                                          .circular(
                                          8),
                                    ),
                                  ),
                                  onPressed: poCreated ==
                                      1
                                      ? null
                                      : () => c.acceptItem(
                                      row['name']),
                                  child: Text(
                                    poCreated == 1
                                        ? "Accepted"
                                        : "Accept",
                                    style:
                                    const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // ================= BOTTOM BUTTON =================
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(16),
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
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.local_shipping,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Purchase Order List",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xFF3B6EBF),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        print("NAVIGATING TO PO LIST");
                        Get.toNamed('/purchase-orders');
                      },


                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
