

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../resources/colors/app_colors.dart';

class LabTestingCard extends StatelessWidget {
  final bool hasQualityData;

  const LabTestingCard({Key? key, required this.hasQualityData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Lab Testing Results",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryDarkTeal),
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.readOnlyBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              "Data managed by Quality Control Dept.",
              style: TextStyle(color: AppColors.textGrey, fontSize: 13),
            ),
          ),
          const SizedBox(height: 20),
          if (hasQualityData)
            Row(
              children: [
                const Icon(Icons.check, color: Colors.green),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Quality Data: Added", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDarkTeal)),
                    Text("(View detailed report)", style: TextStyle(color: Colors.green, fontSize: 12)),
                  ],
                )
              ],
            )
          else
            Row(
              children: const [
                Icon(Icons.radio_button_unchecked, color: AppColors.textGrey),
                SizedBox(width: 10),
                Text("Quality data hasn't been added yet.", style: TextStyle(color: AppColors.textGrey)),
              ],
            ),
        ],
      ),
    );
  }
}