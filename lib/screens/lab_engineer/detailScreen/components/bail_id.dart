import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../controllers/lab_engineer/detail/bail_detail_controller.dart';
import '../../../../resources/colors/app_colors.dart';
 // Ensure correct import path

class BaleIdAndQrSection extends StatelessWidget {
  final BailDetailController controller;

  const BaleIdAndQrSection({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Bale #${controller.bailData['baleId'] ?? 'N/A'}",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDarkTeal,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),


        OutlinedButton.icon(
          onPressed: controller.openQrScreen,
          icon: const Icon(Icons.qr_code_scanner, color: AppColors.primaryDarkTeal),
          label: const Text(
            "Share / View QR Tag",
            style: TextStyle(color: AppColors.primaryDarkTeal, fontWeight: FontWeight.bold),
          ),

          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primaryDarkTeal, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            backgroundColor: AppColors.cardOffWhite
          ),

        ),

      ],
    );
  }
}




