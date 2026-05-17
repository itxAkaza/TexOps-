import 'package:get/get.dart';
import 'package:texops/resources/route/routes_names.dart';
import 'package:texops/screens/admin/bale_inventory/admin_bale_inventory_screen.dart';
// --- Admin Screens ---
import 'package:texops/screens/admin/dashboard/admin_dashboard.dart';
import 'package:texops/screens/admin/gate_pass/admin_gate_pass.dart';
import 'package:texops/screens/admin/quality/vendors_quality.dart';
import 'package:texops/screens/admin/user_directory/admin_user_directory.dart';
// --- Onboarding & Auth ---
import 'package:texops/screens/auth/login_screen.dart';
import 'package:texops/screens/lab_engineer/bailBarcode/bailBarcode_screen.dart';
// --- Lab Engineer Screens ---
import 'package:texops/screens/lab_engineer/dashboard/lab_enigneer_dashboard.dart';
import 'package:texops/screens/lab_engineer/detailScreen/detail_Screen.dart';
import 'package:texops/screens/lab_engineer/viewAllGatePasses/viewAllGatePasses_screen.dart';
import 'package:texops/screens/lab_engineer/viewShareQr/viewShare_Qr_Screen.dart';

import '../../screens/lab_engineer/gatePassTransfer_screen/gatePassTransferList_screen.dart';
import '../../screens/lab_engineer/record_gatePass/bail_entry_screen.dart';
import '../../screens/onBoarding/intro_screen.dart';

class AppRoutes {
  static List<GetPage> appRoutes() => [
    // --- Onboarding & Auth ---
    GetPage(
      name: RoutesNames.introScreen,
      page: () => IntroScreen(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesNames.loginScreen,
      page: () => LoginScreen(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 250),
    ),

    // --- Lab Engineer ---
    GetPage(
      name: RoutesNames.labEngineerDashboard,
      page: () => LabEnigneerDashboard(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesNames.bailEntryView,
      page: () => BaleEntryScreen(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesNames.bailBarcodeView,
      page: () => BailBarcodeScreen(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesNames.detailView, // Added back from imports
      page: () => DetailScreen(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesNames.gatePassTransferListView, // Added back from imports
      page: () => GatePassTransferListScreen(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesNames.viewAllGatePassesView, // Added back from imports
      page: () => ViewAllBalesScreen(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesNames.qrShareView, // Added back from imports
      page: () => ViewQrScreen(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 250),
    ),

    // --- Admin ---
    GetPage(name: RoutesNames.adminDashboard, page: () => AdminDashboard()),
    GetPage(
      name: RoutesNames.adminBaleInventory,
      page: () => AdminBaleInventoryScreen(),
    ),
    GetPage(
      name: RoutesNames.adminUserDirectory,
      page: () => AdminUserDirectory(),
    ),
    GetPage(name: RoutesNames.adminGatePass, page: () => AdminGatePass()),
    GetPage(
      name: RoutesNames.adminQuality, // Added back from imports
      page: () => VendorQualityScreen(),
    ),
  ];
}
