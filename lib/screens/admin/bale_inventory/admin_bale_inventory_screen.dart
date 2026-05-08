import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/screens/admin/bale_inventory/widgets/bale_card.dart';
import 'package:texops/screens/admin/bale_inventory/widgets/inventory_search_bar.dart';
import 'package:texops/screens/admin/bale_inventory/widgets/status_filter_chip.dart';

class AdminBaleInventoryScreen extends StatelessWidget {
  const AdminBaleInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLightPeach,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.primaryDarkTeal,
              size: 22,
            ),
          ),
        ),
        title: Text(
          "Bale Inventory",
          style: GoogleFonts.poppins(
            color: AppColors.primaryDarkTeal,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: -0.1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            InventorySearchBar(),
            SizedBox(height: 10),
            StatusFilterChip(),
            SizedBox(height: 10),
            BaleCard(),
          ],
        ),
      ),
    );
  }
}
