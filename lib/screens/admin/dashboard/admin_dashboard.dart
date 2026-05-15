import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/controllers/admin/dashboard_controller.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/resources/route/routes_names.dart';
import 'package:texops/screens/admin/dashboard/widgets/admin_stat_card.dart';
import 'package:texops/screens/admin/dashboard/widgets/fiber_price_chart.dart';
import 'package:texops/screens/admin/dashboard/widgets/inventroy_turn_over.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    final size = MediaQuery.of(context).size;
    final crossAxisCount = size.width > 650 ? 4 : 2;

    return Scaffold(
      backgroundColor: const Color(0xFFFFEEDB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          "TexOps Overview",
          style: GoogleFonts.poppins(
            color: AppColors.primaryDarkTeal,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Stat Cards ──────────────────────────────────────
              Obx(() {
                final s = controller.stats.value;
                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.2,
                  children: [
                    AdminStatCard(
                      backgroundColor: AppColors.primaryDarkTeal,
                      headingText: "Total Gate Passes",
                      icon: Icons.description_outlined,
                      bodyText: s.totalGatePasses.toString(),
                      subtitleText: "View GatePass list",
                      onTap: () => Get.toNamed(RoutesNames.adminGatePass),
                    ),
                    AdminStatCard(
                      backgroundColor: AppColors.accentOrange,
                      headingText: "Inventory Count",
                      icon: Icons.inventory_2_outlined,
                      bodyText: _formatCount(s.totalBalesCount),
                      subtitleText: "Number of Bales",
                      onTap: () => Get.toNamed(RoutesNames.adminBaleInventory),
                    ),
                    AdminStatCard(
                      backgroundColor: AppColors.accentOrange,
                      headingText: "Overall Quality Rate",
                      icon: Icons.verified_outlined,
                      bodyText: "${s.overallQualityRate.toStringAsFixed(1)}%",
                      subtitleText: "All Quality Rates",
                      onTap: () {},
                    ),
                    AdminStatCard(
                      backgroundColor: AppColors.primaryDarkTeal,
                      headingText: "Total Users",
                      icon: Icons.supervised_user_circle_rounded,
                      bodyText: s.totalUsers.toString(),
                      subtitleText: "Add New User",
                      onTap: () => Get.toNamed(RoutesNames.adminUserDirectory),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 14),

              // ── Line Chart ──────────────────────────────────────
              const FiberPriceChart(),

              const SizedBox(height: 14),

              // ── Bar Chart ───────────────────────────────────────
              const InventoryTurnoverChart(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Compact number formatter for stat cards (e.g. 7265 → "7.3k")
  String _formatCount(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return value.toString();
  }
}
