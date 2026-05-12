import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/screens/admin/bale_inventory/admin_bale_details_screen.dart';
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
            Expanded(
              child: ListView(
                children: [
                  BaleCard(
                    bale: BaleModel(
                      baleId: "B-8902",
                      materialType: "Polyester Blend",
                      vendor: "Nishat Textiles",
                      weight: "300 kg",
                      purchasePrice: 52000,
                      status: BaleStatus.sentForYarn,
                      labStatus: LabStatus.completed,
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminBaleDetailsScreen(),
                        ),
                      );
                      debugPrint("Hello");
                    },
                  ),

                  BaleCard(
                    bale: BaleModel(
                      baleId: "B-8915",
                      materialType: "Ring Spun Cotton",
                      vendor: "Sapphire Textile Mills",
                      weight: "420 kg",
                      purchasePrice: 68500,
                      status: BaleStatus.testing,
                      labStatus: LabStatus.pending,
                    ),

                    onTap: () {
                      debugPrint("Bale Opened");
                    },
                  ),

                  BaleCard(
                    bale: BaleModel(
                      baleId: "B-8921",
                      materialType: "Polyester Fiber",
                      vendor: "Interloop Textiles",
                      weight: "350 kg",
                      purchasePrice: 74200,
                      status: BaleStatus.completed,
                      labStatus: LabStatus.completed,
                    ),

                    onTap: () {
                      debugPrint("Completed Bale");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
