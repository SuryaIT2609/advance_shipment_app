import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/asn_controller.dart';
import '../controller/login_controller.dart';

class ASNPage extends StatelessWidget {
  const ASNPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ASNController>(
      init: ASNController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFF2F4F8),

          // ================= APP BAR =================
          appBar: AppBar(
            backgroundColor: const Color(0xFF3B6EBF),
            title: const Text("ASN", style: TextStyle(color: Colors.white)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            actions: [
              TextButton.icon(
                onPressed: () {
                  Get.toNamed('/create-asn');
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Create ASN",
                  style: TextStyle(color: Colors.white),
                ),
              ),

              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () {
                  Get.defaultDialog(
                    title: "Logout",
                    middleText: "Are you sure?",
                    textCancel: "Cancel",
                    textConfirm: "Logout",
                    confirmTextColor: Colors.white,
                    onConfirm: () {
                      Get.back();
                      Get.find<LoginController>().logout();
                    },
                  );
                },
              ),
            ],
          ),

          // ================= BODY =================
          body: controller.loading
              ? const Center(child: CircularProgressIndicator())
              : controller.asnList.isEmpty
              ? const Center(child: Text("No ASN Found"))
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.asnList.length,
            itemBuilder: (context, index) {
              final asnNo = controller.asnList[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      asnNo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B6EBF),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Open",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
