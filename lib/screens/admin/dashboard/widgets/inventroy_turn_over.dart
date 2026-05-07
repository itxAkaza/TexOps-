import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:texops/resources/colors/app_colors.dart';

class InventoryTurnoverChart extends StatelessWidget {
  const InventoryTurnoverChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Inventory Turn Over",
            style: TextStyle(
              color: AppColors.primaryDarkTeal,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          _buildLegend(),
          const SizedBox(height: 20),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 1200,
                barTouchData: BarTouchData(enabled: true),
                titlesData: _buildTitles(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: _buildBarGroups(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        _legendItem(AppColors.primaryDarkTeal, "Received"),
        const SizedBox(width: 16),
        _legendItem(AppColors.accentOrange, "Consumed"),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    // Data for Q1, Q2, Q3, Q4
    // Each group has two bars: [Received, Consumed]
    return [
      _makeGroupData(0, 800, 750),
      _makeGroupData(1, 1000, 950),
      _makeGroupData(2, 700, 680),
      _makeGroupData(3, 900, 850),
    ];
  }

  BarChartGroupData _makeGroupData(int x, double received, double consumed) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: received,
          color: AppColors.primaryDarkTeal,
          width: 12,
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
          toY: consumed,
          color: AppColors.accentOrange,
          width: 12,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  FlTitlesData _buildTitles() {
    return FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) => SideTitleWidget(
            meta: meta,
            child: Text(
              "${(value / 1000).toStringAsFixed(1)}k",
              style: const TextStyle(color: AppColors.textGrey, fontSize: 10),
            ),
          ),
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            const titles = ['Q1', 'Q2', 'Q3', 'Q4'];
            return SideTitleWidget(
              meta: meta,
              child: Text(
                titles[value.toInt()],
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
