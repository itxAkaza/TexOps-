class YarnCalculations {
  /// Actual Count: Length / (840 * Weight)
  static String calculateActualCount(String lengthStr, String weightStr) {
    final length = double.tryParse(lengthStr);
    final weight = double.tryParse(weightStr);

    if (length != null && weight != null && weight > 0) {
      final result = length / (840 * weight);
      return result.toStringAsFixed(2); // e.g., "30.00"
    }
    return "-";
  }

  /// Tenacity: Breaking Force (cN) / Tex
  static String calculateTenacity(String forceStr, String texStr) {
    final force = double.tryParse(forceStr);
    final tex = double.tryParse(texStr);

    if (force != null && tex != null && tex > 0) {
      final result = force / tex;
      return result.toStringAsFixed(2);
    }
    return "-";
  }

  /// Elongation (%): ((Final Length - Original Length) / Original Length) * 100
  static String calculateElongation(String finalLStr, String originalLStr) {
    final finalL = double.tryParse(finalLStr);
    final originalL = double.tryParse(originalLStr);

    if (finalL != null && originalL != null && originalL > 0) {
      final result = ((finalL - originalL) / originalL) * 100;
      return result.toStringAsFixed(2);
    }
    return "-";
  }

  /// CLSP: Count * Strength
  static String calculateCLSP(String countStr, String strengthStr) {
    final count = double.tryParse(countStr);
    final strength = double.tryParse(strengthStr);

    if (count != null && strength != null) {
      final result = count * strength;
      return result.toStringAsFixed(0); // Usually a whole number
    }
    return "-";
  }

  /// Actual TPM: Twists / Length(m)
  static String calculateTPM(String twistsStr, String lengthStr) {
    final twists = double.tryParse(twistsStr);
    final length = double.tryParse(lengthStr);

    if (twists != null && length != null && length > 0) {
      final result = twists / length;
      return result.toStringAsFixed(2);
    }
    return "-";
  }
}
