import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texops/controllers/admin/quality_controller.dart';

class QualityScreenHeader extends StatelessWidget {
  QualityScreenHeader({super.key});
  final QualityController controller = Get.find<QualityController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (v) => controller.searchQuery.value = v,
            decoration: InputDecoration(
              hintText: 'Search vendor or material...',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              suffixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black45, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black45, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black45, width: 1),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 16,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildDropdown(controller.selectedMaterial, [
                "All",
                "Cotton",
                "Polyester",
              ], "Material"),
              const SizedBox(width: 12),
              _buildDropdown(controller.selectedRating, [
                "All",
                "Excellent",
                "Good",
                "Fair",
              ], "Rating"),
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
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
              value: value.value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              onChanged: (v) => value.value = v!,
              selectedItemBuilder: (_) => items
                  .map(
                    (e) => Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '$label: $e',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  )
                  .toList(),
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
