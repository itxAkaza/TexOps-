import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/controllers/admin/user_directory_controller.dart';
import 'package:texops/resources/colors/app_colors.dart';

class CategoryTabs extends StatelessWidget {
  final UserDirectoryController controller;

  const CategoryTabs({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(controller.categories.length, (index) {
          final isSelected = controller.selectedTab.value == index;

          return GestureDetector(
            onTap: () => controller.changeTab(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.categories[index],
                  style: GoogleFonts.poppins(
                    color: isSelected ? AppColors.primaryDarkTeal : Colors.grey,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 2,
                  width: isSelected ? 25 : 0,
                  color: AppColors.primaryDarkTeal,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
