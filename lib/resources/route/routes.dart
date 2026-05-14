import 'package:get/get.dart';
import 'package:texops/resources/route/routes_names.dart';
import 'package:texops/screens/admin/bale_inventory/admin_bale_inventory_screen.dart';
import 'package:texops/screens/admin/dashboard/admin_dashboard.dart';
import 'package:texops/screens/admin/gate_pass/admin_gate_pass.dart';
import 'package:texops/screens/admin/user_directory/admin_user_directory.dart';
import 'package:texops/screens/auth/login_screen.dart';
import 'package:texops/screens/lab_engineer/bailBarcode/bailBarcode_screen.dart';
import 'package:texops/screens/lab_engineer/dashboard/lab_enigneer_dashboard.dart';
import 'package:texops/screens/lab_engineer/record_gatePass/bail_entry_screen.dart';
import 'package:texops/screens/onBoarding/intro_screen.dart';

class AppRoutes {
  static appRoutes() => [
    // Intro
    GetPage(
      name: RoutesNames.introScreen,
      page: () => IntroScreen(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 250),
    ),

    // Login
    GetPage(
      name: RoutesNames.loginScreen,
      page: () => LoginScreen(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 250),
    ),

    // Lab Engineer
    GetPage(
      name: RoutesNames.bailEntryView,
      page: () => BaleEntryScreen(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 250),
    ),

    GetPage(
      name: RoutesNames.bailBarcodeView,
      page: () => BailbarcodeScreen(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 250),
    ),

    GetPage(
      name: RoutesNames.labEngineerDashboard,
      page: () => LabEnigneerDashboard(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 250),
    ),

    // Admin
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
  ];
}
