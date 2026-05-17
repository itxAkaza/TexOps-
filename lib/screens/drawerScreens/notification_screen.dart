import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:texops/resources/colors/app_colors.dart';

import '../../controllers/lab_engineer/notification/notification_controller.dart'; // Adjust your path


class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  // Helper to pick the right icon based on what Python sent
  IconData _getIconForTitle(String title) {
    title = title.toLowerCase();
    if (title.contains("quality")) return Icons.science_outlined;
    if (title.contains("gate pass") || title.contains("bale") || title.contains("record")) return Icons.edit_document;
    if (title.contains("yarn")) return Icons.precision_manufacturing_outlined;
    return Icons.campaign_outlined; // Default megaphone icon
  }

  // Helper to pick the right accent color
  Color _getColorForTitle(String title) {
    title = title.toLowerCase();
    if (title.contains("quality") || title.contains("record") || title.contains("bale")) return AppColors.primaryDarkTeal;
    if (title.contains("system") || title.contains("yarn")) return AppColors.accentOrange;
    return Colors.blueGrey;
  }

  @override
  Widget build(BuildContext context) {
    // Inject the controller when the screen opens
    final controller = Get.put(NotificationController());

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
          "Notifications",
          style: TextStyle(color: AppColors.primaryDarkTeal, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: () => controller.markAllAsRead(),
            child: const Text("Mark all as read", style: TextStyle(color: AppColors.primaryDarkTeal, fontSize: 12, fontWeight: FontWeight.bold)),
          )
        ],
      ),

      body: Obx(() {
        // 1. Loading State
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryDarkTeal));
        }

        // 2. Empty State
        if (controller.notificationsList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_off_outlined, size: 60, color: AppColors.textGrey.withOpacity(0.5)),
                const SizedBox(height: 15),
                const Text("You're all caught up!", style: TextStyle(color: AppColors.textGrey, fontSize: 16)),
              ],
            ),
          );
        }

        // 3. Data State
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: controller.notificationsList.length,
          itemBuilder: (context, index) {
            var data = controller.notificationsList[index];

            // Safely parse the timestamp from Firestore
            DateTime time = data['timestamp'] != null
                ? (data['timestamp'] as Timestamp).toDate()
                : DateTime.now();

            // Format the time (e.g., "May 17, 10:30 AM")
            String timeString = DateFormat('MMM d, h:mm a').format(time);

            String title = data['title'] ?? 'System Alert';
            String body = data['body'] ?? '';
            Color iconColor = _getColorForTitle(title);

            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
                // The neat side border from your UI design
                border: Border(left: BorderSide(color: iconColor, width: 4)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dynamic Icon Circle
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
                    child: Icon(_getIconForTitle(title), color: iconColor, size: 24),
                  ),
                  const SizedBox(width: 15),

                  // Text Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primaryDarkTeal)),
                        const SizedBox(height: 6),
                        Text(body, style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.4)),
                        const SizedBox(height: 12),
                        Text(timeString, style: const TextStyle(color: AppColors.textGrey, fontSize: 11)),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      }),
    );
  }
}