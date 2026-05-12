import 'package:get/get.dart';
import 'package:texops/resources/route/routes_names.dart';
import 'package:texops/screens/admin/bale_inventory/admin_bale_inventory_screen.dart';
import 'package:texops/screens/admin/dashboard/admin_dashboard.dart';
import 'package:texops/screens/QualityMeasures/Screens/Common/quality_review_screen.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/choose_category.dart';
import 'package:texops/screens/QualityMeasures/Screens/fabric/fabric_input.dart';
import 'package:texops/screens/QualityMeasures/Screens/fibre/fibre_input.dart';
import 'package:texops/screens/QualityMeasures/Screens/yarn/yarn_input.dart';
// import 'package:texops/screens/admin/user_directory/admin_user_directory.dart';

class AppRoutes {
  static appRoutes() => [
    // GetPage(
    //     name: RoutesNames.introScreen,
    //     page: ()=>IntroScreen(),
    //     transition: Transition.leftToRightWithFade,
    //     transitionDuration: Duration(milliseconds: 250)
    //
    // ),
    GetPage(name: RoutesNames.adminDashboard, page: () => AdminDashboard()),
    GetPage(
      name: RoutesNames.adminBaleInventory,
      page: () => AdminBaleInventoryScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    
    // GetPage(
    //   name: RoutesNames.adminUserDirectory,
    //   page: () => //AdminUserDirectory(),
    //   transition: Transition.rightToLeftWithFade,
    // ),
    GetPage(
      name: RoutesNames.qualityChooseCategory,
      page: () => const ChooseCategoryScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: RoutesNames.qualityFibreTesting,
      page: () => const FibreTestingScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: RoutesNames.qualityYarnTesting,
      page: () => const YarnTestingScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: RoutesNames.qualityFabricTesting,
      page: () => const FabricTestingScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: RoutesNames.qualityReview,
      page: () {
        final dynamic args = Get.arguments;
        final String testType = args is Map && args['testType'] is String
            ? args['testType'] as String
            : 'Quality Review';
        final List<QualityReviewCardData> cards =
            args is Map && args['cards'] is List<QualityReviewCardData>
            ? args['cards'] as List<QualityReviewCardData>
            : <QualityReviewCardData>[];

        return QualityReviewScreen(
          testType: testType,
          cards: cards,
        );
      },
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(name: RoutesNames.adminGatePass, page: () => AdminGatePass()),
  ];
}
