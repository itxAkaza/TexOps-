import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texops/screens/lab_engineer/detailScreen/components/bail_id.dart';
import 'package:texops/screens/lab_engineer/detailScreen/components/invenory.dart';
import 'package:texops/screens/lab_engineer/detailScreen/components/lab_testing.dart';

import '../../../controllers/lab_engineer/detail/bail_detail_controller.dart';
import '../../../resources/colors/app_colors.dart';

class AdminBaleDetailsScreen extends StatelessWidget {
  const AdminBaleDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BailDetailController());
    print(controller.bailData.values);

    return Scaffold(
      backgroundColor: AppColors.backgroundLightPeach,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryDarkTeal,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),

        title: const Text(
          "Bale Details",
          style: TextStyle(
            color: AppColors.primaryDarkTeal,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryDarkTeal),
          );
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
              BaleIdAndQrSection(controller: controller),
              const SizedBox(height: 30),

              InventoryDataCard(data: controller.bailData),
              const SizedBox(height: 20),

              LabTestingCard(hasQualityData: hasQualityStatus),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }
}
