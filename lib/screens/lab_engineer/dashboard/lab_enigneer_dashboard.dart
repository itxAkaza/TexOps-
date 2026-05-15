import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/lab_engineer/lab_engineer_Dashboard/labEngineer_dashboard_controller.dart';
import '../../../resources/colors/app_colors.dart';
import 'components/intro card.dart';
import 'components/recent_activity_card.dart';


class LabEnigneerDashboard extends StatelessWidget {
  const LabEnigneerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LabEngineerController());

    return Scaffold(
      backgroundColor: AppColors.backgroundLightPeach,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryDarkTeal),
            );
          }

          return RefreshIndicator(
            onRefresh: () => controller.fetchDashboardData(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. The Top Card
                  DashboardTopCard(controller: controller),

                  const SizedBox(height: 25),

                  // 2. Recent Activity Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Recent Activity Log",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDarkTeal
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Get.to(ViewAllGatePassesScreen(gatePasses: controller.recentBales));
                        },
                        child: const Text(
                          "View All GatePasses",
                          style: TextStyle(color: AppColors.accentOrange),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 10),

                  // 3. List of recent gate passes
                  controller.recentBales.isEmpty
                      ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text("No recent activity found.", style: TextStyle(color: AppColors.textGrey)),
                      ))
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.recentBales.length,
                    itemBuilder: (context, index) {
                      var bale = controller.recentBales[index];
                      return RecentActivityTile(
                        bale: bale,
                        controller: controller,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}