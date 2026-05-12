import 'package:get/get.dart';

class FibreTestingController extends GetxController {
  // --- UI STATE (Is it expanded?) ---
  var isFibreLengthExpanded = false.obs;
  var isFibreDenierExpanded = false.obs;

  void toggleFibreLength() {
    isFibreLengthExpanded.value = !isFibreLengthExpanded.value;
  }

  void toggleFibreDenier() {
    isFibreDenierExpanded.value = !isFibreDenierExpanded.value;
  }

  // --- DATA STATE (The text field inputs) ---
  var weightInput = 0.0.obs;
  var lengthInput = 0.0.obs;
  var calculatedDenierResult = "-".obs;

  // Called whenever the user types in the Weight or Length text fields
  void calculateDenier(String weightStr, String lengthStr) {
    double? weight = double.tryParse(weightStr);
    double? length = double.tryParse(lengthStr);

    if (weight != null && length != null && length > 0) {
      double result = (weight / length) * 9000;
      calculatedDenierResult.value = result.toStringAsFixed(1);
    } else {
      calculatedDenierResult.value = "-";
    }
  }
}