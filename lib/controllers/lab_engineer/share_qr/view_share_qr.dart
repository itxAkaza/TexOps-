import 'dart:convert';
import 'package:get/get.dart';
import 'package:texops/Utiles/utiles.dart';
import '../../../services/qrPdfService.dart';

class ViewQrController extends GetxController {
  final RxString qrData = ''.obs;
  final RxString baleId = ''.obs;


  String _gatePassRef = '';

  @override
  void onInit()
  {
    super.onInit();

    if (Get.arguments != null)
    {
      baleId.value = Get.arguments['baleId'] ?? 'Unknown';
      qrData.value = Get.arguments['qrData'] ?? '';


      try {
        if (qrData.value.isNotEmpty)
        {
          final Map<String, dynamic> parsedData = jsonDecode(qrData.value);
          _gatePassRef = parsedData['gatePassRef'] ?? baleId.value;
        }
      } catch (e)
      {
        _gatePassRef = baleId.value; // Fallback
      }
    }
  }

  Future<void> shareQRAsPDF() async
  {
    try {
      await GatePassPdfService.generateAndShare(
        gatePassId: _gatePassRef,
        qrData: qrData.value,
      );
    } catch (e)
    {
      Utils.toastMesseges(e.toString());
    }

  }
}