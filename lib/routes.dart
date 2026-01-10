import 'package:get/get.dart';
import 'Pages/asn_list_page.dart';
import 'pages/login_page.dart';
import 'pages/create_asn_page.dart';

final routes = [
  GetPage(name: '/auth/login', page: () => const LoginPage()),
  GetPage(name: '/asn', page: () => const ASNPage()),
  GetPage(name: '/create-asn', page: () => const CreateASNPage()),
];
