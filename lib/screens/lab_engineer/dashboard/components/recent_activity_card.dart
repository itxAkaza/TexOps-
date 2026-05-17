import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../controllers/lab_engineer/lab_engineer_Dashboard/labEngineer_dashboard_controller.dart';
import '../../../../resources/colors/app_colors.dart';

class RecentActivityTile extends StatelessWidget
{
  final Map<String, dynamic> bale;
  final LabEngineerController controller;
  final VoidCallback? onTap;

  const RecentActivityTile({super.key, required this.bale, required this.controller, required this.onTap});

  @override
  Widget build(BuildContext context) {
    double totalValue = controller.calculateGatePassTotal(bale);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.primaryDarkTeal,
              radius: 25,
              child: Icon(Icons.local_shipping, color: Colors.white),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bale['supplier'] ?? 'Unknown Supplier',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryDarkTeal),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "GatePass: #${bale['gatePassRef'] ?? 'N/A'}",
                    style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  NumberFormat.currency(symbol: 'Rs', decimalDigits: 2).format(totalValue),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryDarkTeal),
                ),
                const SizedBox(height: 4),
                Text(
                  bale['arrivalTime'] ?? '',
                  style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


class RecentActivityShimmerTile extends StatelessWidget {
  const RecentActivityShimmerTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),

      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          children: [
            const CircleAvatar(radius: 25, backgroundColor: Colors.white),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: double.infinity, height: 16, color: Colors.white, margin: const EdgeInsets.only(right: 20)),
                  const SizedBox(height: 8),
                  Container(width: 80, height: 12, color: Colors.white),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(width: 70, height: 16, color: Colors.white),
                const SizedBox(height: 8),
                Container(width: 50, height: 12, color: Colors.white),
              ],

            )
          ],
        ),
      ),
    );
  }
}