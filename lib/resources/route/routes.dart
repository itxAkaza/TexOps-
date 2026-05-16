import 'package:get/get.dart';
import 'package:texops/resources/route/routes_names.dart';
import 'package:texops/screens/lab_engineer/detailScreen/detail_Screen.dart';

// --- Onboarding & Auth ---
import '../../screens/lab_engineer/gatePassTransfer_screen/gatePassTransferList_screen.dart';
import '../../screens/lab_engineer/viewAllGatePasses/viewAllGatePasses_screen.dart';
import '../../screens/lab_engineer/viewShareQr/viewShare_Qr_Screen.dart';
import '../../screens/onBoarding/intro_screen.dart';
import 'package:texops/screens/auth/login_screen.dart';

// --- Admin Screens ---
import 'package:texops/screens/admin/bale_inventory/admin_bale_inventory_screen.dart';
import 'package:texops/screens/admin/dashboard/admin_dashboard.dart';
import 'package:texops/screens/admin/gate_pass/admin_gate_pass.dart';
import 'package:texops/screens/admin/user_directory/admin_user_directory.dart';

// --- Lab Engineer Screens ---
import 'package:texops/screens/lab_engineer/dashboard/lab_enigneer_dashboard.dart';
import '../../screens/lab_engineer/bailBarcode/bailBarcode_screen.dart';
import '../../screens/lab_engineer/record_gatePass/bail_entry_screen.dart';

class AppRoutes {
  static appRoutes() => [
    // ==============================
    // Onboarding & Auth Routes
    // ==============================
    GetPage(
      name: RoutesNames.introScreen,
      page: () => IntroScreen(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesNames.loginScreen,
      page: () => LoginScreen(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesNames.qrShareView,
      page: () => ViewQrScreen(),
      transition: Transition.fade,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesNames.viewAllGatePassesView,
      page: () => ViewAllBalesScreen(),
      transition: Transition.fade,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesNames.gatePassTransferListView,
      page: () => GatePassTransferListScreen(),
      transition: Transition.fade,
      transitionDuration: Duration(milliseconds: 250),
    ),

    // ==============================
    // Lab Engineer Routes
    // ==============================
    GetPage(
      name: RoutesNames.bailEntryView,
      page: () => BaleEntryScreen(),
      transition: Transition.fade,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesNames.bailBarcodeView,
      page: () => BailBarcodeScreen(),
      transition: Transition.fade,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesNames.labEngineerDashboard,
      page: () => LabEnigneerDashboard(),
      transition: Transition.fade,
      transitionDuration: Duration(milliseconds: 250),
    ),

    GetPage(
      name: RoutesNames.detailView,
      page: () => DetailScreen(),
      transition: Transition.fade,
      transitionDuration: Duration(milliseconds: 250),
    ),

    // ==============================
    // Admin Routes
    // ==============================
    GetPage(
      name: RoutesNames.adminDashboard,
      page: () => AdminDashboard(),
    ),
    GetPage(
      name: RoutesNames.adminBaleInventory,
      page: () => AdminBaleInventoryScreen(),
    ),
    GetPage(
      name: RoutesNames.adminUserDirectory,
      page: () => AdminUserDirectory(),
    ),
    GetPage(
      name: RoutesNames.adminGatePass,
      page: () => AdminGatePass(),
    ),
  ];
}