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
      width: double.infinity,
      height: 260,
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 12),
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
        children: [
          _buildHeader(),
          const SizedBox(height: 18),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                width: 800,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, right: 20),
                  child: LineChart(_chartData()),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Using Flexible to prevent the title from pushing buttons off-screen
          const Flexible(
            child: Text(
              "Fiber Market Trends",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: AppColors.primaryDarkTeal,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _toggleButton("Cotton", 0, AppColors.accentOrange),
              const SizedBox(width: 8),
              _toggleButton("Poly", 1, AppColors.primaryDarkTeal),
            ],
          ),
        ],
      ),
    );
  }

  Widget _toggleButton(String label, int index, Color activeColor) {
    bool isSelected = selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => selectedIndex = index),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textGrey,
            fontSize: 11,
            fontWeight: FontWeight.bold,
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
        getDrawingHorizontalLine: (value) =>
            FlLine(color: Colors.grey.withOpacity(0.1), strokeWidth: 1),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(left: BorderSide(color: Colors.grey.withOpacity(0.2))),
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
            getTitlesWidget: (val, meta) => SideTitleWidget(
              meta: meta,
              child: Text(
                val.toInt().toString(),
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 30,
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
              int index = val.toInt();
              if (index < 0 || index >= months.length) return const Text('');
              return SideTitleWidget(
                meta: meta,
                space: 10,
                child: Text(
                  months[index],
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      lineBarsData: [
        selectedIndex == 0
            ? _lineStyle(cottonSpots, AppColors.accentOrange)
            : _lineStyle(polySpots, AppColors.primaryDarkTeal),
      ],
    );
  }

  LineChartBarData _lineStyle(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 4,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 4,
          color: Colors.white,
          strokeWidth: 3,
          strokeColor: color,
        ),
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), color.withOpacity(0.0)],
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
    FlSpot(11, 570), // Fixed: Removed the duplicate index 11 spot
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
