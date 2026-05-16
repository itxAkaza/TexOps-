import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/lab_engineer/detail/bail_detail_controller.dart';
import '../../../resources/colors/app_colors.dart';
import 'components/bail_id.dart';
import 'components/invenory.dart';
import 'components/lab_testing.dart';
import 'components/send_to_yarn.dart';


class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BailDetailController());

    return Scaffold(
      backgroundColor: AppColors.backgroundLightPeach,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryDarkTeal, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Bale Details",
          style: TextStyle(color: AppColors.primaryDarkTeal, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primaryDarkTeal),
            onPressed: () {
              // TODO: Get.to(() => EditBaleScreen());
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.primaryDarkTeal),
            onPressed: () {
              // Show confirmation dialog before deleting
              Get.defaultDialog(
                title: "Delete Bale",
                middleText: "Are you sure you want to delete this record?",
                textConfirm: "Delete",
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                textCancel: "Cancel",
                onConfirm: () {
                  Get.back(); // close dialog
                  controller.deleteCurrentBale();
                },
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryDarkTeal));
        }

        if (controller.bailData.isEmpty) {
          return const Center(child: Text("No data found"));
        }

        bool hasQualityStatus = controller.bailData['qualityStatus'] ?? false;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Bale ID & QR Button
              BaleIdAndQrSection(controller: controller),
              const SizedBox(height: 30),

              // 2. Receiving Data Card
              InventoryDataCard(data: controller.bailData),
              const SizedBox(height: 20),

              // 3. Yarn Toggle Card
              YarnToggleCard(controller: controller),
              const SizedBox(height: 20),

              // 4. Lab Testing Results Card
              LabTestingCard(hasQualityData: hasQualityStatus),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }
}