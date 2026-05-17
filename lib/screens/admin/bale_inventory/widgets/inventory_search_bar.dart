import 'package:flutter/material.dart';
import 'package:texops/resources/colors/app_colors.dart';

class InventorySearchBar extends StatelessWidget {
  const InventorySearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText:
                  'Search Bale ID, Vendor, or Vehicle...',
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              filled: true,
              fillColor: Colors.white,

              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  EdgeInsets.symmetric(
                    vertical: 12,
                  ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: AppColors.primaryDarkTeal,
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.tune,
              color: AppColors.cardOffWhite,
            ),
          ),
        ),
      ],
    );
  }
}
