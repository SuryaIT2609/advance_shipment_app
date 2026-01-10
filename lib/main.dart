import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes.dart';
import 'controller/login_controller.dart';
import 'controller/asn_controller.dart';

void main() {
  // 🔥 REGISTER ALL GLOBAL CONTROLLERS HERE
  Get.put<LoginController>(LoginController(), permanent: true);
  Get.put<ASNController>(ASNController(), permanent: true);

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
