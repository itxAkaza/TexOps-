import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:texops/data/models/quality_testing/quality_test_models.dart';
import 'package:flutter/foundation.dart';

class QualityTestingRepository {
  QualityTestingRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _rootCollection = 'BailRecord';
  static const String _baleDataCollection = 'bail_data';
  static const String _qualityTestsField = 'qualitytests';

  final FirebaseFirestore _firestore;

  Future<void> saveQualityTest({
    required String baleRecordId,
    required String baleId,
    required QualityTestRecord record,
    required QualitySummaryUpdate summary,
  }) async {
    final DocumentReference<Map<String, dynamic>> parentRef =
        _baleDocRef(baleRecordId: baleRecordId, baleId: baleId);
    final DocumentReference<Map<String, dynamic>> statsRef =
        _firestore.collection('records').doc('dashboard_stats');

    final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await parentRef.get();
    final Map<String, dynamic> data = snapshot.data() ?? {};

    final Map<String, dynamic> summaryUpdate =
      _buildSummaryUpdate(data, summary);
    final double? overallScore =
      _calculateOverallScore(data, summary.category, record.toMap());
    final bool overallCounted = data['overAllBaleScoreCounted'] == true;
    final double? previousOverall = _parseNumber(data['overAllBaleScore']);

    final Map<String, dynamic> recordMap = record.toMap();
    _assertSerializable(recordMap, path: 'recordMap');
    _assertSerializable(summaryUpdate, path: 'summaryUpdate');

    debugPrint('quality_save_record: $recordMap');
    debugPrint('quality_save_summary: $summaryUpdate');

    final Map<String, dynamic> updateData = {
      _qualityTestFieldPathFor(summary.category): recordMap,
      ...summaryUpdate,
    };
    if (overallScore != null) {
      updateData['overAllBaleScore'] = overallScore;
    }
    if (overallScore != null) {
      updateData['overAllBaleScoreCounted'] = true;
    }

    final WriteBatch batch = _firestore.batch();
    batch.set(parentRef, updateData, SetOptions(merge: true));
    await batch.commit();

    if (overallScore != null) {
      await _updateDashboardStats(
        statsRef: statsRef,
        previousOverall: previousOverall,
        newOverall: overallScore,
        wasCounted: overallCounted,
      );
    }
  }

  Future<Map<QualityTestCategory, QualityTestRecord>> fetchQualityTests(
    String baleRecordId,
    String baleId,
  ) async {
    final DocumentReference<Map<String, dynamic>> docRef = _firestore
        .collection(_rootCollection)
        .doc(baleRecordId)
        .collection(_baleDataCollection)
        .doc(baleId);
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await docRef.get();

    final Map<String, dynamic> data = snapshot.data() ?? {};
    final Map<String, dynamic> tests = _extractQualityTests(data);

    debugPrint(
      'quality_fetch_tests: path=${docRef.path} exists=${snapshot.exists} keys=${data.keys.toList()}',
    );
    debugPrint('quality_fetch_tests: tests_keys=${tests.keys.toList()}');

    final Map<QualityTestCategory, QualityTestRecord> results = {};
    for (final MapEntry<String, dynamic> entry in tests.entries) {
      if (entry.value is! Map) continue;
      final QualityTestCategory? category =
          _qualityTestCategoryFromKey(entry.key);
      if (category == null) continue;

      final QualityTestRecord record = QualityTestRecord.fromMap(
        Map<String, dynamic>.from(entry.value as Map),
      );
      results[category] = record;
    }

    return results;
  }

  Future<double?> fetchOverallScore(
    String baleRecordId,
    String baleId,
  ) async {
    final DocumentReference<Map<String, dynamic>> docRef = _baleDocRef(
      baleRecordId: baleRecordId,
      baleId: baleId,
    );
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await docRef.get();
    final Map<String, dynamic> data = snapshot.data() ?? {};
    final dynamic value = data['overAllBaleScore'];
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  String _qualityTestKeyFor(QualityTestCategory category) {
    switch (category) {
      case QualityTestCategory.fibre:
        return 'fibre';
      case QualityTestCategory.yarn:
        return 'yarn';
      case QualityTestCategory.fabric:
        return 'fabric';
    }
  }

  String _qualityTestFieldPathFor(QualityTestCategory category) {
    return '$_qualityTestsField.${_qualityTestKeyFor(category)}';
  }

  QualityTestCategory? _qualityTestCategoryFromKey(String key) {
    switch (key) {
      case 'fibre':
        return QualityTestCategory.fibre;
      case 'yarn':
        return QualityTestCategory.yarn;
      case 'fabric':
        return QualityTestCategory.fabric;
      default:
        return null;
    }
  }

  DocumentReference<Map<String, dynamic>> _baleDocRef({
    required String baleRecordId,
    required String baleId,
  }) {
    return _firestore
        .collection(_rootCollection)
        .doc(baleRecordId)
        .collection(_baleDataCollection)
        .doc(baleId);
  }

  Map<String, dynamic> _buildSummaryUpdate(
    Map<String, dynamic> data,
    QualitySummaryUpdate summary,
  ) {
    final Map<String, dynamic> existingSummaries =
        Map<String, dynamic>.from(data['qualitySummaries'] as Map? ?? {});

    existingSummaries[summary.statusKey] = summary.status;
    existingSummaries[summary.scoreKey] = summary.scoreLabel;

    final String labStatus = _calculateLabStatus(existingSummaries);

    return {
      'labTestingStatus': labStatus,
      'qualitySummaries': existingSummaries,
    };
  }

  Map<String, dynamic> _extractQualityTests(Map<String, dynamic> data) {
    Map<String, dynamic> tests = Map<String, dynamic>.from(
      data[_qualityTestsField] as Map? ??
          data['qualityTests'] as Map? ??
          {},
    );

    if (tests.isEmpty) {
      const String prefix = '$_qualityTestsField.';
      final Map<String, dynamic> rebuilt = {};
      for (final MapEntry<String, dynamic> entry in data.entries) {
        final String key = entry.key;
        if (!key.startsWith(prefix)) continue;
        final String categoryKey = key.substring(prefix.length);
        if (entry.value is Map) {
          rebuilt[categoryKey] = Map<String, dynamic>.from(entry.value as Map);
        }
      }
      tests = rebuilt;
    }

    return tests;
  }

  double? _calculateOverallScore(
    Map<String, dynamic> data,
    QualityTestCategory category,
    Map<String, dynamic> recordMap,
  ) {
    final Map<String, dynamic> tests = _extractQualityTests(data);
    tests[_qualityTestKeyFor(category)] = recordMap;

    final List<double> scores = [];
    for (final dynamic value in tests.values) {
      if (value is! Map) continue;
      final dynamic scoreValue = value['calculatedScore'];
      final double? score = scoreValue is num
          ? scoreValue.toDouble()
          : double.tryParse(scoreValue?.toString() ?? '');
      if (score != null) {
        scores.add(score);
      }
    }

    if (scores.isEmpty) return null;
    final double total = scores.fold(0, (sum, val) => sum + val);
    return total / scores.length;
  }

  double? _parseNumber(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  Future<void> _updateDashboardStats({
    required DocumentReference<Map<String, dynamic>> statsRef,
    required double? previousOverall,
    required double newOverall,
    required bool wasCounted,
  }) async {
    final double delta = wasCounted && previousOverall != null
        ? (newOverall - previousOverall)
        : newOverall;

    await _firestore.runTransaction((transaction) async {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await transaction.get(statsRef);
      final Map<String, dynamic> data = snapshot.data() ?? {};

      final double totalScore =
          _parseNumber(data['total_quality_score']) ?? 0;
      final double testedCount =
          _parseNumber(data['total_bales_tested']) ?? 0;

      final Map<String, dynamic> updates = {
        'total_quality_score': totalScore + delta,
      };

      if (!wasCounted) {
        updates['total_bales_tested'] = testedCount + 1;
      }

      transaction.set(statsRef, updates, SetOptions(merge: true));
    });
  }

  String _calculateLabStatus(Map<String, dynamic> summaries) {
    final List<String> statuses = [
      summaries['fibreStatus'] as String? ?? 'Pending',
      summaries['yarnStatus'] as String? ?? 'Pending',
      summaries['fabricStatus'] as String? ?? 'Pending',
    ];

    final bool anyCompleted = statuses.any((status) => status != 'Pending');
    final bool allCompleted = statuses.every((status) => status != 'Pending');

    if (!anyCompleted) return 'Pending';
    if (allCompleted) return 'Completed';
    return 'Partial';
  }

  void _assertSerializable(
    Object? value, {
    String path = 'root',
  }) {
    if (value == null ||
        value is String ||
        value is num ||
        value is bool ||
        value is Timestamp) {
      return;
    }

    if (value is Map) {
      value.forEach((key, val) {
        if (key is! String) {
          throw StateError('Non-string key at $path: $key');
        }
        _assertSerializable(val, path: '$path.$key');
      });
      return;
    }

    if (value is List) {
      for (int i = 0; i < value.length; i++) {
        _assertSerializable(value[i], path: '$path[$i]');
      }
      return;
    }

    throw StateError('Unsupported type at $path: ${value.runtimeType}');
  }
}
