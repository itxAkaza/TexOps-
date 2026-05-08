import 'package:flutter/material.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/screens/admin/dashboard/widgets/admin_stat_card.dart';
import 'package:texops/screens/admin/dashboard/widgets/fiber_price_chart.dart';
import 'package:texops/screens/admin/dashboard/widgets/inventroy_turn_over.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final crossAxisCount = size.width > 650 ? 4 : 2;

    return Scaffold(
      backgroundColor: const Color(0xFFFFEEDB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.primaryDarkTeal,
              size: 22,
            ),
            onPressed: () {},
          ),
        ),
        title: Text(
          "TexOps Overview",
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.primaryDarkTeal,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    children: const [
                      AdminStatCard(
                        backgroundColor: AppColors.primaryDarkTeal,
                        headingText: "Total Gate Passes",
                        icon: Icons.description_outlined,
                        bodyText: "342",
                        subtitleText: "View GatePass list",
                      ),
                      AdminStatCard(
                        backgroundColor: AppColors.accentOrange,
                        headingText: "Inventory Count",
                        icon: Icons.inventory_2_outlined,
                        bodyText: "7,265",
                        subtitleText: "Number of Bales",
                      ),
                      AdminStatCard(
                        backgroundColor: AppColors.accentOrange,
                        headingText: "Overall Quality Rate",
                        icon: Icons.verified_outlined,
                        bodyText: "94.8%",
                        subtitleText: "All Quality Rates",
                      ),
                      AdminStatCard(
                        backgroundColor: AppColors.primaryDarkTeal,
                        headingText: "Total Users",
                        icon: Icons.supervised_user_circle_rounded,
                        bodyText: "12",
                        subtitleText: "Add New User",
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  FiberPriceChart(),
                  const SizedBox(height: 10),
                  InventoryTurnoverChart(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
