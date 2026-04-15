import 'package:get/get.dart';
import 'package:po_asn_app/Pages/splash.dart';

import 'pages/login_page.dart';
import 'pages/asn_list_page.dart';
import 'pages/po_cart_page.dart';
import 'pages/create_asn_page.dart';
import 'pages/po_list_page.dart'; // ✅ THIS MUST EXIST

// Get.toNamed('/purchase-orders');
final routes = [
  GetPage(name: '/splash', page: () => const SplashPage()),
  GetPage(name: '/auth/login', page: () => const LoginPage()),
  GetPage(name: '/create-asn', page: () => const CreateASNPage()),
  GetPage(name: '/po-cart', page: () => const POCartItemsPage()),
  GetPage(name: '/create-asn', page: () => const CreateASNPage()),
  GetPage(name: '/po-list', page: () => const PurchaseOrderListPage()),

  GetPage(
    name: '/purchase-orders',
    page: () => const PurchaseOrderListPage(), // ✅ NOT NULL
  ),
  GetPage(name: '/create-asn', page: () => const CreateASNPage()),
];
