import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/controllers/admin/quality_controller.dart';
import 'package:texops/data/models/vendor_quality_model.dart';
import 'package:texops/resources/colors/app_colors.dart';

class VendorQualityCard extends StatelessWidget {
  final VendorQualityModel vendor;
  const VendorQualityCard({super.key, required this.vendor});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<QualityController>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primaryDarkTeal,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.business_rounded, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vendor.vendorName,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  vendor.materialType.toUpperCase(),
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                vendor.hasData
                    ? "${vendor.totalScore.toStringAsFixed(1)}%"
                    : "--",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: AppColors.primaryDarkTeal,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: vendor.hasData
                      ? c.getRatingColor(vendor.totalScore)
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  vendor.hasData
                      ? c.getRatingTag(vendor.totalScore)
                      : "PENDING",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
