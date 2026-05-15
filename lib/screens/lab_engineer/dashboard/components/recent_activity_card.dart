
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../controllers/lab_engineer/lab_engineer_Dashboard/labEngineer_dashboard_controller.dart';
import '../../../../resources/colors/app_colors.dart';


class RecentActivityTile extends StatelessWidget {
  final Map<String, dynamic> bale;
  final LabEngineerController controller;
  final VoidCallback ? onTap;

  const RecentActivityTile({super.key, required this.bale, required this.controller,required this.onTap});

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
        ),
        child: Row(
          children: [
            // Vehicle Icon
            CircleAvatar(
              backgroundColor: AppColors.primaryDarkTeal,
              radius: 25,
              child: const Icon(Icons.local_shipping, color: Colors.white),
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