import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:texops/resources/colors/app_colors.dart';

class FiberPriceChart extends StatefulWidget {
  const FiberPriceChart({super.key});

  @override
  State<FiberPriceChart> createState() => _FiberPriceChartState();
}

class _FiberPriceChartState extends State<FiberPriceChart> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 12),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: LineChart(_chartData()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Text(
            "Fiber Market Trends",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.primaryDarkTeal,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Row(
          children: [
            _toggleButton("Cotton", 0, AppColors.accentOrange),
            const SizedBox(width: 8),
            _toggleButton("Poly", 1, AppColors.primaryDarkTeal),
          ],
        ),
      ],
    );
  }

  Widget _toggleButton(String label, int index, Color color) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? color : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppColors.textGrey,
          ),
        ),
      ),
    );
  }

  LineChartData _chartData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (v) =>
            FlLine(color: Colors.grey.withOpacity(0.08), strokeWidth: 1),
      ),

      borderData: FlBorderData(
        show: true,
        border: Border(left: BorderSide(color: Colors.grey.withOpacity(0.15))),
      ),

      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),

        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (val, meta) {
              return Text(
                val.toInt().toString(),
                style: const TextStyle(fontSize: 10, color: AppColors.textGrey),
              );
            },
          ),
        ),

        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (val, meta) {
              const months = [
                'Jan',
                'Feb',
                'Mar',
                'Apr',
                'May',
                'Jun',
                'Jul',
                'Aug',
                'Sep',
                'Oct',
                'Nov',
                'Dec',
              ];

              final i = val.toInt();
              if (i < 0 || i >= months.length) {
                return const SizedBox.shrink();
              }

              return Text(
                months[i],
                style: const TextStyle(fontSize: 10, color: AppColors.textGrey),
              );
            },
          ),
        ),
      ),

      lineBarsData: [
        _lineStyle(
          selectedIndex == 0 ? cottonSpots : polySpots,
          selectedIndex == 0
              ? AppColors.accentOrange
              : AppColors.primaryDarkTeal,
        ),
      ],
    );
  }

  LineChartBarData _lineStyle(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,

      dotData: FlDotData(show: false),

      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [color.withOpacity(0.12), color.withOpacity(0.0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  static const cottonSpots = [
    FlSpot(0, 420),
    FlSpot(1, 460),
    FlSpot(2, 440),
    FlSpot(3, 490),
    FlSpot(4, 470),
    FlSpot(5, 510),
    FlSpot(6, 500),
    FlSpot(7, 530),
    FlSpot(8, 520),
    FlSpot(9, 550),
    FlSpot(10, 540),
    FlSpot(11, 570),
  ];

  static const polySpots = [
    FlSpot(0, 310),
    FlSpot(1, 330),
    FlSpot(2, 320),
    FlSpot(3, 350),
    FlSpot(4, 340),
    FlSpot(5, 370),
    FlSpot(6, 365),
    FlSpot(7, 385),
    FlSpot(8, 375),
    FlSpot(9, 400),
    FlSpot(10, 395),
    FlSpot(11, 410),
  ];
}
