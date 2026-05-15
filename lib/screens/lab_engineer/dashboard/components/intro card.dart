import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../controllers/lab_engineer/lab_engineer_Dashboard/labEngineer_dashboard_controller.dart';
import '../../../../resources/colors/app_colors.dart';
// Ensure your color file is imported

class DashboardTopCard extends StatelessWidget {
  final LabEngineerController controller;

  const DashboardTopCard({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('EEEE, MMMM dd, yyyy').format(DateTime.now());

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryDarkTeal,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.accentOrange,
                    backgroundImage: controller.userProfilePic.value.isNotEmpty
                        ? NetworkImage(controller.userProfilePic.value)
                        : null,
                    child: controller.userProfilePic.value.isEmpty
                        ? Text(
                      controller.userName.value.isNotEmpty
                          ? controller.userName.value[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    )
                        : null,
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
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {},
              )
            ],
          ),
          const SizedBox(height: 25),

          // System Value Section
          Text(
            todayDate,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 5),
          const Text(
            "System Value Logged",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          Obx(() => Text(
            NumberFormat.currency(symbol: '₹', decimalDigits: 2).format(controller.totalSystemValue.value),
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          )),

          const SizedBox(height: 25),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cardWhite,
                    foregroundColor: AppColors.primaryDarkTeal,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    // Get.to(BaleEntryScreen());
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Record New\nLab Report", textAlign: TextAlign.center),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    // Handle Outbound
                  },
                  icon: const Icon(Icons.swap_horiz),
                  label: const Text("Issue Outbound\nGatePass Transfer", textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Quarter Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.getCurrentQuarter(),
                  style: const TextStyle(color: Colors.white),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              ],
            ),
          )
        ],
      ),
    );
  }
}

