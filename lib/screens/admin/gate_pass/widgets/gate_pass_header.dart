import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/controllers/admin/gate_pass_controller.dart';
import 'package:texops/resources/colors/app_colors.dart';

class GatePassHeader extends StatelessWidget {
  final GatePassController controller;
  const GatePassHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Viewing 342 records across all categories",
            style: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 13),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: (v) => controller.searchQuery.value = v,
            decoration: InputDecoration(
              hintText: 'Search by Pass #, Supplier, or Vehicle...',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildDropdown(controller.selectedStatus, [
                "All",
                "Pending",
                "Completed",
              ], "Status"),
              const SizedBox(width: 12),
              _buildDropdown(controller.selectedType, [
                "All",
                "Cotton",
                "Polyester",
              ], "Type"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(RxString value, List<String> items, String label) {
    return Expanded(
      child: Obx(
        () => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value.value,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
              onChanged: (v) => value.value = v!,
              items: items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
