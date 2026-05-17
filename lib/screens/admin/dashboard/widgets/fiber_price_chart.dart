import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/controllers/admin/dashboard_controller.dart';
import 'package:texops/resources/colors/app_colors.dart';

class FiberPriceChart extends StatelessWidget {
  const FiberPriceChart({super.key});

  static const _tabs = ['Cotton', 'Poly'];

  Color _lineColor(int index) =>
      index == 0 ? AppColors.primaryDarkTeal : AppColors.accentOrange;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.autoRecorded, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── HEADER ──────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Purchase Trends",
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDarkTeal,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Obx(
                () => FittedBox(
                  fit: BoxFit.scaleDown,
                  child: _TabSelector(
                    tabs: _tabs,
                    selected: controller.selectedFiberIndex.value,
                    onTap: (i) => controller.selectedFiberIndex.value = i,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── CHART ───────────────────────────────────────────────
          SizedBox(
            height: 200,
            child: Obx(() {
              final tabIdx = controller.selectedFiberIndex.value;

              final spots = controller.getWeeklyBaleSpots();
              final maxY = controller.getLineChartMaxY();
              final interval = controller.getLineChartInterval();
              final color = _lineColor(tabIdx);

              final days = controller.getCurrentWeekLabels();

              final hasData = spots.any((s) => s.y > 0);

              return Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: LineChart(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                        LineChartData(
                          minX: 0,
                          maxX: 6.1,
                          minY: 0,
                          maxY: maxY,
                          clipData: const FlClipData.all(),

                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: interval,
                            getDrawingHorizontalLine: (_) => FlLine(
                              color: AppColors.autoRecorded,
                              strokeWidth: 1,
                            ),
                          ),

                          borderData: FlBorderData(
                            show: true,
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors.autoRecorded,
                                width: 1,
                              ),
                              left: BorderSide(
                                color: AppColors.autoRecorded,
                                width: 1,
                              ),
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
                                reservedSize: 26,
                                interval: 1,
                                getTitlesWidget: (val, _) {
                                  // Skip fractional ticks injected at maxX boundary
                                  if (val % 1 != 0) {
                                    return const SizedBox.shrink();
                                  }

                                  final idx = val.toInt();

                                  if (idx < 0 || idx >= days.length) {
                                    return const SizedBox.shrink();
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      days[idx],
                                      style: GoogleFonts.poppins(
                                        color: AppColors.textGrey,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: interval,
                                reservedSize: 40,
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

                          lineTouchData: LineTouchData(
                            handleBuiltInTouches: true,
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipColor: (_) => AppColors.primaryDarkTeal,
                              tooltipBorderRadius: BorderRadius.circular(10),
                              tooltipPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 7,
                              ),
                              getTooltipItems: (touchedSpots) =>
                                  touchedSpots.map((s) {
                                    return LineTooltipItem(
                                      '${days[s.x.toInt()]}\n${s.y.toInt()} bales',
                                      GoogleFonts.poppins(
                                        color: AppColors.cardWhite,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        height: 1.5,
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),

                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              curveSmoothness: 0.35,
                              color: color,
                              barWidth: 2,
                              isStrokeCapRound: true,
                              belowBarData: BarAreaData(show: false),
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, _, __, ___) =>
                                    FlDotCirclePainter(
                                      radius: spot.y > 0 ? 4 : 2.5,
                                      color: AppColors.cardWhite,
                                      strokeWidth: 2,
                                      strokeColor: color,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  if (!hasData)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.cardWhite.withOpacity(0.88),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.show_chart_rounded,
                              size: 36,
                              color: AppColors.autoRecorded,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "No bales recorded this week",
                              style: GoogleFonts.poppins(
                                color: AppColors.textFormText,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ── TAB SELECTOR ───────────────────────────────────────────────
class _TabSelector extends StatelessWidget {
  final List<String> tabs;
  final int selected;
  final void Function(int) onTap;

  const _TabSelector({
    required this.tabs,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.backgroundLightPeach,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(tabs.length, (i) {
          final active = selected == i;

          return GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: active ? AppColors.primaryDarkTeal : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                tabs[i],
                style: GoogleFonts.poppins(
                  color: active ? AppColors.cardWhite : AppColors.textGrey,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── LABEL FORMATTER ─────────────────────────────────────────────
String _fmtLabel(double val) {
  if (val >= 1000000) {
    return '${(val / 1000000).toStringAsFixed(1)}M';
  }
  if (val >= 1000) {
    final k = val / 1000;
    return '${k % 1 == 0 ? k.toInt() : k.toStringAsFixed(1)}k';
  }
  return val.toInt().toString();
}
