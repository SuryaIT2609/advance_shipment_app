import 'package:get/get.dart';

import 'pages/login_page.dart';
import 'pages/asn_list_page.dart';
import 'pages/po_cart_page.dart';
import 'pages/create_asn_page.dart';
import 'pages/po_list_page.dart'; // ✅ THIS MUST EXIST

final routes = [
  GetPage(
    name: '/auth/login',
    page: () => const LoginPage(),
  ),
  GetPage(name: '/create-asn', page: () => const CreateASNPage()),
  GetPage(
    name: '/po-cart',
    page: () => const POCartItemsPage(),
  ),
  GetPage(
    name: '/create-asn',
    page: () => const CreateASNPage(),
  ),
  GetPage(name: '/po-list', page: () => const PurchaseOrderListPage()),

  GetPage(
    name: '/purchase-orders',
    page: () => const PurchaseOrderListPage(), // ✅ NOT NULL
  ),
  GetPage(
    name: '/create-asn',
    page: () => const CreateASNPage(),
  ),

];
