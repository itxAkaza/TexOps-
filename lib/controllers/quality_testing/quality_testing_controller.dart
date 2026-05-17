import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:texops/data/fireStoreDB/quality/quality_testing_repository.dart';
import 'package:texops/data/models/quality_testing/quality_test_models.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/screens/QualityMeasures/Screens/score_screen/scoring_models.dart';
import 'package:texops/screens/QualityMeasures/Screens/score_screen/widgets/fabricScore/fabric_score_calculator.dart';
import 'package:texops/screens/QualityMeasures/Screens/score_screen/widgets/fibreScore/fibre_score_calculator.dart';
import 'package:texops/screens/QualityMeasures/Screens/score_screen/widgets/yarnScore/yarn_score_calculator.dart';

class QualityTestingController extends GetxController {
  QualityTestingController({QualityTestingRepository? repository})
      : _repository = repository ?? QualityTestingRepository();

    @override
  void onInit() {
    // // TODO: implement onInit
    // NotificationServices ns = NotificationServices();
    // ns.requestNotificationPermissions();
    // ns.initNotification();
    // ns.getAndSaveDeviceToken();
    // ns.isTokenRefresh();
    // ns.setupForegroundListener();
    // ns.setupInteractMessage();

    super.onInit();
  }

  final QualityTestingRepository _repository;

  final RxBool isSaving = false.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final Rxn<SectionScore> fibreScore = Rxn<SectionScore>();
  final Rxn<SectionScore> yarnScore = Rxn<SectionScore>();
  final Rxn<SectionScore> fabricScore = Rxn<SectionScore>();
  final RxnDouble overallBaleScore = RxnDouble();

  String _loadedBaleKey = '';

  Future<void> saveTest(QualityTestPayload payload) async {
    isSaving.value = true;
    errorMessage.value = '';

    try {
      if (_hasInvalidMetricValue(payload.metrics)) {
        Get.snackbar(
          'Invalid Values',
          'Please check inputs for zero or invalid calculations.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 14,
          backgroundColor: AppColors.primaryDarkTeal,
          colorText: AppColors.cardWhite,
          icon: const Icon(Icons.error_outline, color: Colors.white),
          duration: const Duration(seconds: 2),
        );
        return;
      }

      final QualityTestRecord record = _buildRecord(payload);
      final QualitySummaryUpdate summary = _buildSummary(payload, record);

      await _repository.saveQualityTest(
        baleRecordId: payload.baleRecordId,
        baleId: payload.baleId,
        record: record,
        summary: summary,
      );

      Get.snackbar(
        'Saved',
        '${record.testCategory} test saved successfully',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
        backgroundColor: AppColors.primaryDarkTeal,
        colorText: AppColors.cardWhite,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        duration: const Duration(seconds: 2),
      );

      // ---> THE STACK FIX <---
      // Wait 1 second so they can read the "Saved" popup, then automatically
      // destroy this input screen and drop them safely back on the main Category hub!
      Future.delayed(const Duration(seconds: 1), () {
        Get.close(2);
      });

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to save test results.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
        backgroundColor: AppColors.primaryDarkTeal,
        colorText: AppColors.cardWhite,
        icon: const Icon(Icons.error_outline, color: Colors.white),
        duration: const Duration(seconds: 2),
      );
    } finally {
      isSaving.value = false;
    }
  }

  bool _hasInvalidMetricValue(Map<String, dynamic> metrics) {
    for (final dynamic value in metrics.values) {
      if (value is num) {
        if (value.isNaN || value.isInfinite) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> loadBaleScores(String baleRecordId, String baleId) async {
    final String cacheKey = '$baleRecordId::$baleId';
    if (_loadedBaleKey == cacheKey && !isLoading.value) return;

    _loadedBaleKey = cacheKey;
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final Map<QualityTestCategory, QualityTestRecord> records =
          await _repository.fetchQualityTests(baleRecordId, baleId);

        overallBaleScore.value =
          await _repository.fetchOverallScore(baleRecordId, baleId);

      fibreScore.value = _scoreForCategory(records, QualityTestCategory.fibre);
      yarnScore.value = _scoreForCategory(records, QualityTestCategory.yarn);
      fabricScore.value =
          _scoreForCategory(records, QualityTestCategory.fabric);
    } catch (e) {
      errorMessage.value = e.toString();
      overallBaleScore.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  QualityTestRecord _buildRecord(QualityTestPayload payload) {
    final String testedBy =
        FirebaseAuth.instance.currentUser?.uid ?? 'Unknown';

    switch (payload.category) {
      case QualityTestCategory.fibre:
        final FibreMetrics metrics = FibreMetrics.fromMap(payload.metrics);
        final SectionScore score = FibreScoreCalculator().calculate(
          FibreScoreInput(
            fibreLengthMm: metrics.fibreLengthMm,
            fibreDenier: metrics.fibreDenier,
          ),
        );
        return _recordFromScore(
          payload: payload,
          testedBy: testedBy,
          score: score,
          metrics: metrics.toMap(),
        );
      case QualityTestCategory.yarn:
        final YarnMetrics metrics = YarnMetrics.fromMap(payload.metrics);
        final SectionScore score = YarnScoreCalculator().calculate(
          YarnScoreInput(
            actualCountNe: metrics.actualCount,
            tenacityCnTex: metrics.tenacity,
            elongationPct: metrics.elongationPercentage,
            clsp: metrics.clsp,
            tpm: metrics.tpm,
          ),
        );
        return _recordFromScore(
          payload: payload,
          testedBy: testedBy,
          score: score,
          metrics: metrics.toMap(),
        );
      case QualityTestCategory.fabric:
        final FabricMetrics metrics = FabricMetrics.fromMap(payload.metrics);
        final SectionScore score = FabricScoreCalculator().calculate(
          FabricScoreInput(
            stiffnessMgCm: metrics.stiffness,
            warpCountEpi: metrics.warpCount,
            weftCountPpi: metrics.weftCount,
            gsm: metrics.gsm,
            tensileWarpN: metrics.tensileStrength,
            tensileWeftN: metrics.tensileStrength,
            tearingStrengthN: metrics.tearingStrength,
            burstingStrengthKpa: metrics.burstingStrength,
            creaseRecoveryDeg: metrics.creaseRecovery,
          ),
        );
        return _recordFromScore(
          payload: payload,
          testedBy: testedBy,
          score: score,
          metrics: metrics.toMap(),
        );
    }
  }

  QualityTestRecord _recordFromScore({
    required QualityTestPayload payload,
    required String testedBy,
    required SectionScore score,
    required Map<String, dynamic> metrics,
  }) {
    return QualityTestRecord(
      testCategory: qualityTestCategoryLabel(payload.category),
      testedBy: testedBy,
      testedAt: DateTime.now(),
      metrics: metrics,
      calculatedScore: score.finalScore,
      calculatedGrade: _gradeLabel(score.grade),
      isPassed: !score.failedCritical,
    );
  }

  QualitySummaryUpdate _buildSummary(
    QualityTestPayload payload,
    QualityTestRecord record,
  ) {
    return QualitySummaryUpdate(
      category: payload.category,
      status: record.isPassed ? 'Passed' : 'Failed',
      scoreLabel: record.calculatedGrade,
    );
  }

  SectionScore? _scoreForCategory(
    Map<QualityTestCategory, QualityTestRecord> records,
    QualityTestCategory category,
  ) {
    final QualityTestRecord? record = records[category];
    if (record == null) return null;

    switch (category) {
      case QualityTestCategory.fibre:
        final FibreMetrics metrics = FibreMetrics.fromMap(record.metrics);
        return FibreScoreCalculator().calculate(
          FibreScoreInput(
            fibreLengthMm: metrics.fibreLengthMm,
            fibreDenier: metrics.fibreDenier,
          ),
        );
      case QualityTestCategory.yarn:
        final YarnMetrics metrics = YarnMetrics.fromMap(record.metrics);
        return YarnScoreCalculator().calculate(
          YarnScoreInput(
            actualCountNe: metrics.actualCount,
            tenacityCnTex: metrics.tenacity,
            elongationPct: metrics.elongationPercentage,
            clsp: metrics.clsp,
            tpm: metrics.tpm,
          ),
        );
      case QualityTestCategory.fabric:
        final FabricMetrics metrics = FabricMetrics.fromMap(record.metrics);
        return FabricScoreCalculator().calculate(
          FabricScoreInput(
            stiffnessMgCm: metrics.stiffness,
            warpCountEpi: metrics.warpCount,
            weftCountPpi: metrics.weftCount,
            gsm: metrics.gsm,
            tensileWarpN: metrics.tensileStrength,
            tensileWeftN: metrics.tensileStrength,
            tearingStrengthN: metrics.tearingStrength,
            burstingStrengthKpa: metrics.burstingStrength,
            creaseRecoveryDeg: metrics.creaseRecovery,
          ),
        );
    }
  }

  String _gradeLabel(String grade) {
    return '$grade-Grade';
  }
}
