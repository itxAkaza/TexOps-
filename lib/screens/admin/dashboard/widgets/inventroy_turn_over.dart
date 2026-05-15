import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/controllers/admin/dashboard_controller.dart';
import 'package:texops/resources/colors/app_colors.dart';

class InventoryTurnoverChart extends StatelessWidget {
  const InventoryTurnoverChart({super.key});

  static const _storageColor = AppColors.primaryDarkTeal;
  static const _consumedColor = AppColors.accentOrange;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.autoRecorded, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Inventory Turn Over",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDarkTeal,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 10),

          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _legendDot(_storageColor, "In Storage"),
              _legendDot(_consumedColor, "Consumed"),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 220,
            child: Obx(() {
              if (controller.isLoadingBales.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryDarkTeal,
                    strokeWidth: 2,
                  ),
                );
              }

              // ✅ WEEKLY DATA (NEW LOGIC)
              final weeklyData = controller.getTurnoverDataByWeek();
              final inStorageWeeks = weeklyData['inStorage']!;
              final consumedWeeks = weeklyData['consumed']!;

              // ✅ SAFE MAX CALC
              final maxValue = [
                ...inStorageWeeks,
                ...consumedWeeks,
              ].reduce((a, b) => a > b ? a : b);

              final double maxY = maxValue > 0
                  ? ((maxValue / 100).ceil() + 1) * 100
                  : 500;

              final double interval = maxY / 5.0;

              return BarChart(
                BarChartData(
                  maxY: maxY,
                  groupsSpace: 12,
                  borderData: FlBorderData(show: false),

                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: interval,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: AppColors.autoRecorded.withOpacity(0.5),
                      strokeWidth: 1,
                    ),
                  ),

                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (val, _) {
                          const titles = [
                            "Week 1",
                            "Week 2",
                            "Week 3",
                            "Week 4",
                          ];

                          if (val >= 0 && val < titles.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                titles[val.toInt()],
                                style: GoogleFonts.poppins(
                                  color: AppColors.textGrey,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),

                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: interval,
                        reservedSize: 40,
                        getTitlesWidget: (val, _) => Text(
                          val.toInt().toString(),
                          style: GoogleFonts.poppins(
                            color: AppColors.textGrey,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  barGroups: List.generate(4, (index) {
                    final sY = inStorageWeeks[index];
                    final cY = consumedWeeks[index];

                    return BarChartGroupData(
                      x: index,
                      barsSpace: 8,
                      barRods: [
                        BarChartRodData(
                          toY: sY,
                          color: _storageColor,
                          width: 28,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: sY > 0,
                            toY: sY,
                            color: AppColors.backgroundLightPeach.withOpacity(
                              0.4,
                            ),
                          ),
                        ),
                        BarChartRodData(
                          toY: cY,
                          color: _consumedColor,
                          width: 28,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: cY > 0,
                            toY: cY,
                            color: AppColors.backgroundLightPeach.withOpacity(
                              0.4,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 11,
          height: 11,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: AppColors.textGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
