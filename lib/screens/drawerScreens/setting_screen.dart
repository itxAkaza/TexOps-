import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texops/resources/colors/app_colors.dart';

import '../../controllers/lab_engineer/setting/setting_controller.dart'; // Adjust path
// import 'settings_controller.dart'; // Adjust path

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Scaffold(
      backgroundColor: AppColors.backgroundLightPeach,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryDarkTeal),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(color: AppColors.primaryDarkTeal, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text(
            //   "ACCOUNT",
            //   style: TextStyle(color: AppColors.primaryDarkTeal, fontSize: 12, fontWeight: FontWeight.bold),
            // ),
            const SizedBox(height: 10),

            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(15),
            //     boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
            //   ),
            //   child: ListTile(
            //     leading: const Icon(Icons.lock_outline, color: AppColors.primaryDarkTeal, size: 22),
            //     title: const Text("Change Password", style: TextStyle(color: AppColors.primaryDarkTeal, fontWeight: FontWeight.w600, fontSize: 15)),
            //     trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textGrey),
            //     onTap: () {
            //     },
            //   ),
            // ),
            //
            // const SizedBox(height: 30),

            const Text(
              "NOTIFICATIONS",
              style: TextStyle(color: AppColors.primaryDarkTeal, fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: ListTile(
                leading: const Icon(Icons.notifications_none_outlined, color: AppColors.primaryDarkTeal, size: 22),
                title: const Text("Push Notifications", style: TextStyle(color: AppColors.primaryDarkTeal, fontWeight: FontWeight.w600, fontSize: 15)),
                trailing: Obx(() => CupertinoSwitch(
                  activeColor: AppColors.accentOrange,
                  value: controller.isPushEnabled.value,
                  onChanged: (value) {
                    controller.togglePushNotifications(value);
                  },
                )),
              ),
            ),

            const Spacer(),

            // --- FOOTER ---
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Text(
                  "TexOps ERP v1.0.0",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}