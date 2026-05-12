import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:texops/resources/route/routes_names.dart';
import 'package:texops/screens/admin/bale_inventory/admin_bale_inventory_screen.dart';
import 'package:texops/screens/admin/dashboard/admin_dashboard.dart';
import 'package:texops/screens/admin/user_directory/admin_user_directory.dart';

class AppRoutes {
  static appRoutes() => [
    // GetPage(
    //     name: RoutesNames.introScreen,
    //     page: ()=>IntroScreen(),
    //     transition: Transition.leftToRightWithFade,
    //     transitionDuration: Duration(milliseconds: 250)
    //
    // ),
    GetPage(
      name: RoutesNames.adminDashboard,
      page: () => AdminDashboard(),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: RoutesNames.adminBaleInventory,
      page: () => AdminBaleInventoryScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: RoutesNames.adminUserDirectory,
      page: () => AdminUserDirectory(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
