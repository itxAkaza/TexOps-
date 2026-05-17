import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texops/resources/route/routes_names.dart';
import 'package:texops/screens/lab_engineer/dashboard/components/drawer/drawer.dart';
import '../../../controllers/lab_engineer/lab_engineer_Dashboard/labEngineer_dashboard_controller.dart';
import '../../../resources/colors/app_colors.dart';
import 'components/intro_card.dart';
import 'components/recent_activity_card.dart';

class LabEnigneerDashboard extends StatelessWidget
{
  LabEnigneerDashboard({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LabEngineerController());

    return Scaffold(
      backgroundColor: AppColors.backgroundLightPeach,
      key: scaffoldKey,
      drawer: Obx(() => MYDrawer(
          userName: controller.userName.value,
          userEmail: controller.userEmail.value,
          userRole: controller.userRole.value,
          userImageUrl: controller.userProfilePic.value)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.fetchDashboardData(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                // 1. The Top Card (Handles its own shimmer internally)
                DashboardTopCard(
                  controller: controller,
                  drawerKey: scaffoldKey,
                ),

                const SizedBox(height: 25),

                // 2. Recent Activity Header (Always visible)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Recent Activity Log",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDarkTeal),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(RoutesNames.viewAllGatePassesView,
                            arguments: controller.recentBales.value);
                      },
                      child: const Text(
                        "View All GatePasses",
                        style: TextStyle(color: AppColors.accentOrange),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 10),

                // 3. List Logic: Shimmer OR Real Data OR Empty State
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      // Show 5 dummy shimmer tiles while loading
                      return ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) => const RecentActivityShimmerTile(),
                      );
                    }

                    if (controller.recentBales.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text("No recent activity found.",
                              style: TextStyle(color: AppColors.textGrey)),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: controller.recentBales.length,
                      itemBuilder: (context, index) {
                        var bale = controller.recentBales[index];
                        return RecentActivityTile(
                          bale: bale,
                          controller: controller,
                          onTap: () {
                            Get.toNamed(RoutesNames.detailView, arguments: [bale]);
                          },
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}