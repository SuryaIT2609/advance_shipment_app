import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes.dart';
import 'controller/login_controller.dart';
import 'controller/asn_controller.dart';
import 'controller/po_pending_controller.dart';
import 'controller/create_asn_controller.dart';
import 'controller/po_list_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ GLOBAL CONTROLLERS (ONLY REGISTRATION)
  Get.put<LoginController>(LoginController(), permanent: true);
  Get.put<ASNController>(ASNController(), permanent: true);
  Get.put<POPendingController>(POPendingController(), permanent: true);
  // Get.put<CreateASNController>(CreateASNController(), permanent: true);
  Get.put<POListController>(POListController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/auth/login',
      getPages: routes,
    );
  }
}
