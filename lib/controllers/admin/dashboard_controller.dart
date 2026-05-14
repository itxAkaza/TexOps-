import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:texops/data/fireStoreDB/admin/dashboard_stats_service.dart';
import 'package:texops/data/models/dashboard_model.dart';
import 'package:texops/data/models/gate_pass_model.dart';

class DashboardController extends GetxController {
  final DashboardService _service = DashboardService();

  var stats = DashboardStatsModel(
    totalGatePasses: 0,
    totalBalesCount: 0,
    overallQualityRate: 0.0,
    totalUsers: 0,
  ).obs;

  // RxList does NOT support bindStream — use StreamSubscription instead
  RxList<GatePassModel> allBailData = <GatePassModel>[].obs;
  RxBool isLoadingBales = true.obs;

  /// 0 = Cotton, 1 = Poly
  RxInt selectedFiberIndex = 0.obs;

  static const List<String> fiberTypes = ['cotton', 'poly'];

  StreamSubscription<List<GatePassModel>>? _balesSub;

  @override
  void onInit() {
    super.onInit();

    // stats is Rx<DashboardStatsModel> — bindStream works fine
    stats.bindStream(_service.getDashboardStats());

    // allBailData is RxList — bindStream doesn't exist on RxList.
    // Use listen() and assign to .value to keep reactivity intact.
    _balesSub = _service.getAllBailData().listen(
      (data) {
        allBailData.value = data;
        isLoadingBales.value = false;
      },
      onError: (_) {
        isLoadingBales.value = false;
      },
    );
  }

  @override
  void onClose() {
    _balesSub?.cancel(); // prevent memory leaks
    super.onClose();
  }

  // ─────────────────────────────────────────────────────────────
  // LINE CHART — Weekly Bales Bought (Mon–Sun of current week)
  // ─────────────────────────────────────────────────────────────

  List<FlSpot> getWeeklyBaleSpots() {
    // Always initialise all 7 days to 0 so the chart never collapses
    final Map<int, double> dailyTotals = {for (int i = 0; i < 7; i++) i: 0.0};

    if (allBailData.isEmpty) return _spotsFromMap(dailyTotals);

    final now = DateTime.now();
    final weekStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1)); // Monday at midnight

    final String targetType = fiberTypes[selectedFiberIndex.value];

    for (final bale in allBailData) {
      if (bale.baleType.trim().toLowerCase() != targetType) continue;
      if (bale.createdAt.isBefore(weekStart)) continue;
      if (bale.createdAt.isAfter(weekStart.add(const Duration(days: 7)))) {
        continue;
      }
      final int dayIndex = bale.createdAt.weekday - 1; // 0=Mon … 6=Sun
      final double count = double.tryParse(bale.baleCount.trim()) ?? 0.0;
      dailyTotals[dayIndex] = (dailyTotals[dayIndex] ?? 0.0) + count;
    }

    return _spotsFromMap(dailyTotals);
  }

  List<FlSpot> _spotsFromMap(Map<int, double> map) {
    return map.entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList()
      ..sort((a, b) => a.x.compareTo(b.x));
  }

  double getLineChartMaxY() {
    final spots = getWeeklyBaleSpots();
    if (spots.isEmpty) return 100;
    final rawMax = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    if (rawMax == 0) return 100;
    return _roundUpNice(rawMax * 1.3);
  }

  double getLineChartInterval() => _niceInterval(getLineChartMaxY());

  // ─────────────────────────────────────────────────────────────
  // BAR CHART — Inventory Turnover (In-Storage vs Consumed)
  // ─────────────────────────────────────────────────────────────

  Map<String, double> getTurnoverData() {
    if (allBailData.isEmpty) return {'inStorage': 0, 'consumed': 0};

    double inStorage = 0;
    double consumed = 0;

    for (final bale in allBailData) {
      final count = double.tryParse(bale.baleCount.trim()) ?? 0.0;
      if (bale.readyForYarn == true) {
        consumed += count;
      } else {
        inStorage += count;
      }
    }

    return {'inStorage': inStorage, 'consumed': consumed};
  }

  double getBarChartMaxY() {
    final data = getTurnoverData();
    final rawMax = [
      data['inStorage']!,
      data['consumed']!,
    ].reduce((a, b) => a > b ? a : b);
    if (rawMax == 0) return 100;
    return _roundUpNice(rawMax * 1.3);
  }

  double getBarChartInterval() => _niceInterval(getBarChartMaxY());

  // ─────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────

  double _roundUpNice(double value) {
    if (value <= 0) return 100;
    final mag = _magnitude(value);
    return (value / mag).ceil() * mag;
  }

  double _niceInterval(double maxY) {
    if (maxY <= 0) return 20;
    final raw = maxY / 5;
    final mag = _magnitude(raw);
    return (raw / mag).ceil() * mag;
  }

  double _magnitude(double value) {
    if (value <= 0) return 1;
    final exp = (value.toStringAsFixed(0).length - 1).clamp(0, 10);
    return double.parse('1e$exp');
  }
}
