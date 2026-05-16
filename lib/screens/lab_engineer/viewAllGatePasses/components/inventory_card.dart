import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/screens/lab_engineer/record_gatePass/widgets/text.dart';

import '../../../../resources/route/routes_names.dart';
import '../../detailScreen/detail_Screen.dart';


class BaleInventoryCard extends StatelessWidget {
  final Map<String, dynamic> bale;

  const BaleInventoryCard({super.key, required this.bale});

  @override
  Widget build(BuildContext context) {
    bool readyForYarn = bale['readyForYarn'] ?? false;
    bool qualityStatus = bale['qualityStatus'] ?? false;

    double price = double.tryParse(bale['price']?.toString() ?? '0') ?? 0.0;
    String formattedPrice = NumberFormat.currency(symbol: '₹', decimalDigits: 0).format(price);

    return GestureDetector(
      onTap: ()
      {
        Get.toNamed(RoutesNames.detailView,arguments: [bale]);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Bale #${bale['baleId'] ?? 'N/A'}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryDarkTeal),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: readyForYarn ? AppColors.primaryDarkTeal : AppColors.accentOrange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    readyForYarn ? "Sent for Yarn" : "In Storage",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: readyForYarn ? Colors.white : AppColors.accentOrange,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(child: _buildInfoItem("Material Type", bale['baleType'] ?? 'N/A')),
                Expanded(child: _buildInfoItem("Weight", "${bale['weight'] ?? '0'} kg")),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildInfoItem("Vendor & Vehicle", "${bale['supplier']} | ${bale['vehicleNumber']}")),
                Expanded(child: _buildInfoItem("Purchase Price", formattedPrice)),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: AppColors.pageIndicator),
            ),

            Row(
              children: [
                Icon(Icons.science_outlined, size: 16, color: qualityStatus ? Colors.green : AppColors.accentOrange),
                const SizedBox(width: 8),
                Text("Lab Testing: ", style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                Text(
                  qualityStatus ? "Completed" : "Pending",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: qualityStatus ? Colors.green : AppColors.accentOrange,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDarkTeal, fontSize: 14)),
      ],
    );
  }
}

