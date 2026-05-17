
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/lab_engineer/detail/bail_detail_controller.dart';
import '../../../../resources/colors/app_colors.dart';

class YarnToggleCard extends StatelessWidget {
  final BailDetailController controller;

  const YarnToggleCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const
            [
              Icon(Icons.radio_button_checked, color: AppColors.primaryDarkTeal),
              SizedBox(width: 10),
              Text(
                "Send to Yarn Manufacturing",
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDarkTeal),
              ),
            ],
          ),

          Obx(() => CupertinoSwitch(
            activeTrackColor: AppColors.accentOrange,
            value: controller.isReadyForYarn.value,
            onChanged: (val) => controller.toggleYarnStatus(val),
          )),

        ],
      ),
    );
  }
}