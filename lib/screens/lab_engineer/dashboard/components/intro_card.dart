import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:texops/resources/route/routes_names.dart';
import 'package:texops/screens/drawerScreens/notification_screen.dart';

import '../../../../controllers/lab_engineer/lab_engineer_Dashboard/labEngineer_dashboard_controller.dart';
import '../../../../resources/colors/app_colors.dart';

class DashboardTopCard extends StatelessWidget {
  final LabEngineerController controller;
  final GlobalKey<ScaffoldState> drawerKey;

  const DashboardTopCard({super.key, required this.controller, required this.drawerKey});

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('EEEE, MMMM dd, yyyy').format(DateTime.now());
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryDarkTeal,
        borderRadius: BorderRadius.circular(30),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => controller.isLoading.value
                  ? Shimmer.fromColors(
                baseColor: Colors.white.withOpacity(0.2),
                highlightColor: Colors.white.withOpacity(0.5),
                child: Row(
                  children: [
                    const CircleAvatar(radius: 25, backgroundColor: Colors.white),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 100, height: 16, color: Colors.white, margin: const EdgeInsets.only(bottom: 4)),
                        Container(width: 70, height: 12, color: Colors.white),
                      ],
                    ),
                  ],
                ),
              )

                  : Row(
                children: [
                  GestureDetector(
                    onTap: () => drawerKey.currentState?.openDrawer(),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColors.accentOrange,
                      backgroundImage: controller.userProfilePic.value.isNotEmpty
                          ? NetworkImage(controller.userProfilePic.value)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.userName.value,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        controller.userRole.value,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              )),
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {
                  Get.to(() => const NotificationsScreen());
                },
              )
            ],
          ),
          const SizedBox(height: 25),

          // Date
          Text(todayDate, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 5),

          // Value
          const Text("Total Value", style: TextStyle(color: Colors.white70, fontSize: 14)),

          Obx(() => controller.isLoading.value
              ? Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.2),
            highlightColor: Colors.white.withOpacity(0.5),
            child: Container(width: 180, height: 35, color: Colors.white, margin: const EdgeInsets.only(top: 4)),
          )
              : Text(
            NumberFormat.currency(symbol: 'Rs', decimalDigits: 2).format(controller.totalSystemValue.value),
            style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          )),

          const SizedBox(height: 25),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Get.toNamed(RoutesNames.bailEntryView),
                child: Container(
                  height: height * 0.1,
                  width: width * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add, color: AppColors.primaryDarkTeal),
                      SizedBox(width: 4),
                      Text("Record New \n Lab Report", style: TextStyle(color: AppColors.primaryDarkTeal)),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  Get.toNamed(RoutesNames.gatePassTransferListView, arguments: controller.recentBales.value);
                },
                child: Container(
                  height: height * 0.1,
                  width: width * 0.4,
                  decoration: BoxDecoration(
                    color: AppColors.accentOrange,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.outbond_outlined, color: Colors.white),
                      SizedBox(width: 4),
                      Text("GatePass\n Transfer", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),

          // Quarter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(controller.getCurrentQuarter(), style: const TextStyle(color: Colors.white)),
              ],
            ),
          )
        ],
      ),
    );
  }
}