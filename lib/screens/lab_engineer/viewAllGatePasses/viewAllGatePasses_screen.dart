import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texops/resources/colors/app_colors.dart';

import '../../../controllers/lab_engineer/viewAllGatePasses/viewAllGatePass_controller.dart';
import 'components/filterBottomSheet.dart';
import 'components/inventory_card.dart';


class ViewAllBalesScreen extends StatelessWidget {
  const ViewAllBalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ViewAllBalesController());

    return Scaffold(
      backgroundColor: AppColors.backgroundLightPeach,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryDarkTeal, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Bale Inventory",
          style: TextStyle(color: AppColors.primaryDarkTeal, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          // Search & Filter Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      hintText: "Search Bale ID, Vendor, or Vehicle...",
                      hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryDarkTeal,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune, color: Colors.white),
                    onPressed: () {
                      Get.bottomSheet(
                        FilterBottomSheet(controller: controller),
                        isScrollControlled: true,
                      );
                    },
                  ),
                )
              ],
            ),
          ),

          // Quick Filter Chips Row
          // Quick Filter Chips Row
          SizedBox(
            height: 50,
            child: ListView.builder( // <-- Removed Obx from here
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: controller.quickFilters.length,
              itemBuilder: (context, index) {
                String filter = controller.quickFilters[index];

                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Obx(() { // <-- Placed Obx exactly where the changing variable is read
                    bool isSelected = controller.selectedQuickFilter.value == filter;

                    return ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      selectedColor: AppColors.primaryDarkTeal,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.primaryDarkTeal,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.shade300),
                      ),
                      onSelected: (bool selected) {
                        if (selected) controller.setQuickFilter(filter);
                      },
                    );
                  }),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // Expanded List View
          Expanded(
            child: Obx(() {
              if (controller.filteredBales.isEmpty) {
                return const Center(child: Text("No bales match your criteria.", style: TextStyle(color: AppColors.textGrey)));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: controller.filteredBales.length,
                itemBuilder: (context, index) {
                  return BaleInventoryCard(bale: controller.filteredBales[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}