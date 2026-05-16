

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../controllers/lab_engineer/viewAllGatePasses/viewAllGatePass_controller.dart';
import '../../../../resources/colors/app_colors.dart';
import '../../record_gatePass/widgets/text.dart';

class FilterBottomSheet extends StatelessWidget {
  final ViewAllBalesController controller;

  const FilterBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.cardOffWhite,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
          ),
          const SizedBox(height: 20),


          MYText(text: "Select Vendor", size: 14, fontweight: FontWeight.bold, color: AppColors.primaryDarkTeal),
          const SizedBox(height: 10),
          Obx(() => DropdownButtonFormField<String>(
            initialValue: controller.selectedVendor.value,
            dropdownColor: AppColors.cardOffWhite,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.grey[500]!,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primaryDarkTeal,
                  width: 1.5,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryDarkTeal),
            items: controller.availableVendors.map((String vendor) {
              return DropdownMenuItem<String>(
                value: vendor,
                child: Text(vendor),
              );
            }).toList(),
            onChanged: (String? val) {
              if (val != null) controller.selectedVendor.value = val;
            },
            style: GoogleFonts.poppins(textStyle: const TextStyle(color: AppColors.textGrey)),
          )),

          const SizedBox(height: 24),


          MYText(text: "Max Price Range (PKR)", size: 14, fontweight: FontWeight.bold, color: AppColors.primaryDarkTeal),
          Obx(() => Column(
            children: [
              Slider(
                activeColor: AppColors.primaryDarkTeal,
                inactiveColor: Colors.grey.shade300,
                min: 0,
                max: controller.maxPriceRange.value,
                value: controller.currentPriceLimit.value,
                onChanged: (val) => controller.currentPriceLimit.value = val,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Rs0", style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                  Text("Rs${NumberFormat('#,##0').format(controller.currentPriceLimit.value)}",
                      style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                ],
              )
            ],
          )),

          const SizedBox(height: 24),


          MYText(text: "Material Category", size: 14, fontweight: FontWeight.bold, color: AppColors.primaryDarkTeal),
          const SizedBox(height: 10),
          Obx(() => Wrap(
            spacing: 10,
            children: ['All', 'Cotton', 'Polyester'].map((material) {
              bool isSelected = controller.selectedMaterial.value == material;
              return ChoiceChip(
                label: Text(material,textAlign: TextAlign.center,),
                selected: isSelected,
                selectedColor: AppColors.primaryDarkTeal,
                backgroundColor: Colors.white,
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.primaryDarkTeal),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: isSelected ? AppColors.primaryDarkTeal : Colors.grey.shade300),
                ),
                onSelected: (val) => controller.setMaterialFilter(material),
              );
            }).toList(),
          )),

          const SizedBox(height: 30),


          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    controller.resetBottomSheetFilters();
                    Get.back();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppColors.primaryDarkTeal),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Reset", style: TextStyle(color: AppColors.primaryDarkTeal, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    controller.applyFilters();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDarkTeal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Apply Filter", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}