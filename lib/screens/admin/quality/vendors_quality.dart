import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/controllers/admin/quality_controller.dart';
import 'package:texops/resources/colors/app_colors.dart';

import 'widgets/quality_screen_header.dart';
import 'widgets/vendor_quality_card.dart';

class VendorQualityScreen extends StatelessWidget {
  VendorQualityScreen({super.key});

  final QualityController controller = Get.put(QualityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLightPeach,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Supplier Quality Rates",
          style: GoogleFonts.poppins(
            color: AppColors.primaryDarkTeal,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          QualityScreenHeader(),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF7F7F7),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: Obx(() {
                final list = controller.vendorSummaries;
                if (list.isEmpty) {
                  return const Center(child: Text("Waiting for Lab Data..."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 15, bottom: 20),
                  itemCount: list.length,
                  itemBuilder: (context, index) =>
                      VendorQualityCard(vendor: list[index]),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
