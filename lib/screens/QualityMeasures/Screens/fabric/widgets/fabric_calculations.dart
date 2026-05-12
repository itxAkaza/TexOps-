class FabricCalculations {
  static String _formatNumber(double value) {
    if (value.isNaN || value.isInfinite) {
      return '-';
    }

    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2);
  }

  static String calculateStiffness(String weightStr, String bendingStr) {
    final double? weight = double.tryParse(weightStr);
    final double? bending = double.tryParse(bendingStr);

    if (weight == null || bending == null) {
      return '-';
    }

    return _formatNumber(weight * bending);
  }

  static String calculateSingleValue(String valueStr) {
    final double? value = double.tryParse(valueStr);

    if (value == null) {
      return '-';
    }

    return _formatNumber(value);
  }

  static String calculateGsm(String weightStr, String areaStr) {
    final double? weight = double.tryParse(weightStr);
    final double? area = double.tryParse(areaStr);

    if (weight == null || area == null || area <= 0) {
      return '-';
    }

    return _formatNumber(weight / area);
  }

  static String calculateCreaseRecovery(String theta1Str, String theta2Str) {
    final double? theta1 = double.tryParse(theta1Str);
    final double? theta2 = double.tryParse(theta2Str);

    if (theta1 == null || theta2 == null) {
      return '-';
    }

    return _formatNumber(theta1 + theta2);
  }
}
