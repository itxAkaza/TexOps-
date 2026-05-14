import 'package:cloud_firestore/cloud_firestore.dart';

enum QualityTestCategory { fibre, yarn, fabric }

String qualityTestCategoryLabel(QualityTestCategory category) {
  switch (category) {
    case QualityTestCategory.fibre:
      return 'Fibre';
    case QualityTestCategory.yarn:
      return 'Yarn';
    case QualityTestCategory.fabric:
      return 'Fabric';
  }
}

QualityTestCategory? qualityTestCategoryFromLabel(String? label) {
  switch (label) {
    case 'Fibre':
      return QualityTestCategory.fibre;
    case 'Yarn':
      return QualityTestCategory.yarn;
    case 'Fabric':
      return QualityTestCategory.fabric;
    default:
      return null;
  }
}

class QualityTestRecord {
  QualityTestRecord({
    required this.testCategory,
    required this.testedBy,
    required this.testedAt,
    required this.metrics,
    required this.calculatedScore,
    required this.calculatedGrade,
    required this.isPassed,
  });

  final String testCategory;
  final String testedBy;
  final DateTime testedAt;
  final Map<String, dynamic> metrics;
  final double calculatedScore;
  final String calculatedGrade;
  final bool isPassed;

  Map<String, dynamic> toMap() {
    return {
      'testCategory': testCategory,
      'testedBy': testedBy,
      'testedAt': Timestamp.fromDate(testedAt),
      'metrics': metrics,
      'calculatedScore': calculatedScore,
      'calculatedGrade': calculatedGrade,
      'isPassed': isPassed,
    };
  }

  factory QualityTestRecord.fromMap(Map<String, dynamic> map) {
    final Timestamp? timestamp = map['testedAt'] as Timestamp?;
    final dynamic scoreValue = map['calculatedScore'];
    final double parsedScore = scoreValue is num
        ? scoreValue.toDouble()
        : double.tryParse(scoreValue?.toString() ?? '') ?? 0;
    return QualityTestRecord(
      testCategory: map['testCategory'] as String? ?? '',
      testedBy: map['testedBy'] as String? ?? '',
      testedAt: timestamp?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0),
      metrics: Map<String, dynamic>.from(map['metrics'] as Map? ?? {}),
      calculatedScore: parsedScore,
      calculatedGrade: map['calculatedGrade'] as String? ?? '',
      isPassed: map['isPassed'] as bool? ?? false,
    );
  }
}

class QualitySummaryUpdate {
  QualitySummaryUpdate({
    required this.category,
    required this.status,
    required this.scoreLabel,
  });

  final QualityTestCategory category;
  final String status;
  final String scoreLabel;

  String get statusKey {
    switch (category) {
      case QualityTestCategory.fibre:
        return 'fibreStatus';
      case QualityTestCategory.yarn:
        return 'yarnStatus';
      case QualityTestCategory.fabric:
        return 'fabricStatus';
    }
  }

  String get scoreKey {
    switch (category) {
      case QualityTestCategory.fibre:
        return 'fibreScore';
      case QualityTestCategory.yarn:
        return 'yarnScore';
      case QualityTestCategory.fabric:
        return 'fabricScore';
    }
  }
}

class QualityTestPayload {
  QualityTestPayload({
    required this.baleRecordId,
    required this.baleId,
    required this.category,
    required this.metrics,
  });

  final String baleRecordId;
  final String baleId;
  final QualityTestCategory category;
  final Map<String, dynamic> metrics;
}

class FibreMetrics {
  FibreMetrics({
    required this.fibreLengthMm,
    required this.fibreDenier,
  });

  final double fibreLengthMm;
  final double fibreDenier;

  Map<String, dynamic> toMap() {
    return {
      'fibreLengthMm': fibreLengthMm,
      'fibreDenier': fibreDenier,
    };
  }

  factory FibreMetrics.fromMap(Map<String, dynamic> map) {
    return FibreMetrics(
      fibreLengthMm: (map['fibreLengthMm'] as num).toDouble(),
      fibreDenier: (map['fibreDenier'] as num).toDouble(),
    );
  }
}

class YarnMetrics {
  YarnMetrics({
    required this.actualCount,
    required this.tenacity,
    required this.elongationPercentage,
    required this.clsp,
    required this.tpm,
    this.nominalCount,
  });

  final double actualCount;
  final double tenacity;
  final double elongationPercentage;
  final double clsp;
  final double tpm;
  final double? nominalCount;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'actualCount': actualCount,
      'tenacity': tenacity,
      'elongationPercentage': elongationPercentage,
      'clsp': clsp,
      'tpm': tpm,
    };
    if (nominalCount != null) {
      map['nominalCount'] = nominalCount;
    }
    return map;
  }

  factory YarnMetrics.fromMap(Map<String, dynamic> map) {
    return YarnMetrics(
      actualCount: (map['actualCount'] as num).toDouble(),
      tenacity: (map['tenacity'] as num).toDouble(),
      elongationPercentage: (map['elongationPercentage'] as num).toDouble(),
      clsp: (map['clsp'] as num).toDouble(),
      tpm: (map['tpm'] as num).toDouble(),
      nominalCount: map['nominalCount'] != null
          ? (map['nominalCount'] as num).toDouble()
          : null,
    );
  }
}

class FabricMetrics {
  FabricMetrics({
    required this.stiffness,
    required this.warpCount,
    required this.weftCount,
    required this.gsm,
    required this.tensileStrength,
    required this.tearingStrength,
    required this.burstingStrength,
    required this.creaseRecovery,
    required this.knitType,
    required this.weaveType,
  });

  final double stiffness;
  final double warpCount;
  final double weftCount;
  final double gsm;
  final double tensileStrength;
  final double tearingStrength;
  final double burstingStrength;
  final double creaseRecovery;
  final String knitType;
  final String weaveType;

  Map<String, dynamic> toMap() {
    return {
      'stiffness': stiffness,
      'warpCount': warpCount,
      'weftCount': weftCount,
      'gsm': gsm,
      'tensileStrength': tensileStrength,
      'tearingStrength': tearingStrength,
      'burstingStrength': burstingStrength,
      'creaseRecovery': creaseRecovery,
      'knitType': knitType,
      'weaveType': weaveType,
    };
  }

  factory FabricMetrics.fromMap(Map<String, dynamic> map) {
    return FabricMetrics(
      stiffness: (map['stiffness'] as num).toDouble(),
      warpCount: (map['warpCount'] as num).toDouble(),
      weftCount: (map['weftCount'] as num).toDouble(),
      gsm: (map['gsm'] as num).toDouble(),
      tensileStrength: (map['tensileStrength'] as num).toDouble(),
      tearingStrength: (map['tearingStrength'] as num).toDouble(),
      burstingStrength: (map['burstingStrength'] as num).toDouble(),
      creaseRecovery: (map['creaseRecovery'] as num).toDouble(),
      knitType: map['knitType'] as String? ?? '',
      weaveType: map['weaveType'] as String? ?? '',
    );
  }
}
