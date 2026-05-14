import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/controllers/admin/dashboard_controller.dart';
import 'package:texops/resources/colors/app_colors.dart';

class InventoryTurnoverChart extends StatelessWidget {
  const InventoryTurnoverChart({super.key});

  // Teal = In Storage (not yet sent to yarn) — matches Figma "Received Bales"
  static const _storageColor = AppColors.primaryDarkTeal;
  // Orange = Consumed (sent to yarn / turned over) — matches Figma "Consumed Bales"
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
          // ── Header ──────────────────────────────────────────────
          Text(
            "Inventory Turn Over",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDarkTeal,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),

          // ── Legend (Figma style – square dot + label) ────────────
          Row(
            children: [
              _legendDot(_storageColor, "In Storage"),
              const SizedBox(width: 16),
              _legendDot(_consumedColor, "Consumed Bales"),
            ],
          ),

          const SizedBox(height: 16),

          // ── Chart ───────────────────────────────────────────────
          SizedBox(
            height: 220,
            child: Obx(() {
              final isLoading = controller.isLoadingBales.value;

              if (isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryDarkTeal,
                    strokeWidth: 2,
                  ),
                );
              }

              final data = controller.getTurnoverData();
              final inStorage = data['inStorage'] ?? 0.0;
              final consumed = data['consumed'] ?? 0.0;
              final maxY = controller.getBarChartMaxY();
              final interval = controller.getBarChartInterval();
              final hasData = inStorage > 0 || consumed > 0;

              if (!hasData) {
                return _EmptyState(
                  message: "No inventory data yet",
                  icon: Icons.inventory_2_outlined,
                );
              }

              return BarChart(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                BarChartData(
                  maxY: maxY,
                  groupsSpace: 20,

                  borderData: FlBorderData(show: false),

                  // Grid – horizontal dashes only
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: interval,
                    getDrawingHorizontalLine: (_) =>
                        FlLine(color: AppColors.autoRecorded, strokeWidth: 1),
                  ),

                  // Tooltip
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBorderRadius: BorderRadius.circular(10),
                      tooltipPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      getTooltipColor: (_) => AppColors.primaryDarkTeal,
                      getTooltipItem: (group, _, rod, rodIndex) {
                        final label = rodIndex == 0 ? "In Storage" : "Consumed";
                        return BarTooltipItem(
                          '',
                          const TextStyle(),
                          children: [
                            TextSpan(
                              text: '$label\n',
                              style: GoogleFonts.poppins(
                                color: rodIndex == 0
                                    ? AppColors.accentOrange
                                    : AppColors.backgroundLightPeach,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                              ),
                            ),
                            TextSpan(
                              text: '${rod.toY.toInt()} bales',
                              style: GoogleFonts.poppins(
                                color: AppColors.cardWhite,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // Axis titles
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
                        reservedSize: 28,
                        getTitlesWidget: (val, _) {
                          // Single group → label centered under the pair
                          if (val.toInt() == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                "Current",
                                style: GoogleFonts.poppins(
                                  color: AppColors.textGrey,
                                  fontSize: 10,
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
                        reservedSize: 44,
                        getTitlesWidget: (val, meta) {
                          if (val == meta.max) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            _fmtLabel(val),
                            style: GoogleFonts.poppins(
                              color: AppColors.textGrey,
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Bars — two rods in one group, side by side
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barsSpace: 8,
                      barRods: [
                        // Teal = In Storage
                        BarChartRodData(
                          toY: inStorage,
                          color: _storageColor,
                          width: 36,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: maxY,
                            color: AppColors.backgroundLightPeach.withOpacity(
                              0.4,
                            ),
                          ),
                        ),
                        // Orange = Consumed
                        BarChartRodData(
                          toY: consumed,
                          color: _consumedColor,
                          width: 36,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: maxY,
                            color: AppColors.backgroundLightPeach.withOpacity(
                              0.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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

// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const _EmptyState({required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: AppColors.autoRecorded),
          const SizedBox(height: 8),
          Text(
            message,
            style: GoogleFonts.poppins(
              color: AppColors.textFormText,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Axis label formatter ───────────────────────────────────────────────────────
String _fmtLabel(double val) {
  if (val >= 1000000) return '${(val / 1000000).toStringAsFixed(1)}M';
  if (val >= 1000) {
    final k = val / 1000;
    return '${k % 1 == 0 ? k.toInt() : k.toStringAsFixed(1)}k';
  }
  return val.toInt().toString();
}
