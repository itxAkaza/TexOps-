import 'dart:convert';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:texops/Utiles/utiles.dart';
import '../../../data/fireStoreDB/labEnginner/gatePassTransfer_data.dart';
import '../../../screens/lab_engineer/gatePassTransfer_screen/gatePassTransferDetail_Screen.dart';
import '../../../services/qrPdfService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GatePassTransferController extends GetxController {
  final RxList<Map<String, dynamic>> readyForTransferBales = <Map<String, dynamic>>[].obs;
  final RxMap<String, dynamic> selectedBale = <String, dynamic>{}.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      List<Map<String, dynamic>> allBales = List<Map<String, dynamic>>.from(Get.arguments);

      readyForTransferBales.assignAll(
          allBales.where((bale) => bale['qualityStatus'] == true).toList()
      );
    }
  }


  double getGatePassTotal(Map<String, dynamic> bale) {
    return double.tryParse(bale['price']?.toString() ?? '0') ?? 0.0;
  }

  void openTransferDetails(Map<String, dynamic> bale) {

    selectedBale.assignAll(bale);
    Get.to(() => const GatePassTransferDetailScreen());
  }

  Future<void> shareQRAsPDF() async {
    try {
      String gatePassRef = selectedBale['gatePassRef'] ?? 'Unknown';


      String qrString = getSlimQrData();

      await GatePassPdfService.generateAndShare(
        gatePassId: gatePassRef,
        qrData: qrString,
      );
    } catch (e) {
      Utils.toastMesseges(e.toString());
    }
  }

  Future<void> executeTransfer() async {
    String? userId = selectedBale['engineerUID'] ?? FirebaseAuth.instance.currentUser?.uid;
    String baleId = selectedBale['baleId'] ?? '';

    if (userId == null || baleId.isEmpty) return;

    isLoading.value = true;


    double amountToSubtract = getGatePassTotal(selectedBale);
    int count = int.tryParse(selectedBale['baleCount']?.toString() ?? '0') ?? 0;

    try {
      await TransferFirebaseService.transferOutboundBale(
        userId: userId,
        baleId: baleId,
        amountToSubtract: amountToSubtract,
        baleCountToSubtract: count,
      );


      readyForTransferBales.removeWhere((b) => b['baleId'] == baleId);

      Get.back();
      Utils.toastMessegessuccess('GatePass Outbound Transfer Complete!');

    } catch (e) {
      Utils.toastMesseges('Transfer failed: $e');
    } finally {
      isLoading.value = false;
    }
  }


  String getSlimQrData() {
    if (selectedBale.isEmpty) return "{}";


    var fibre = selectedBale['qualitytests.fibre'] ?? {};
    String fGrade = fibre['calculatedGrade'] ?? 'N/A';
    String fScore = fibre['calculatedScore']?.toString() ?? 'N/A';
    String fDenier = fibre['metrics']?['fibreDenier']?.toString() ?? 'N/A';
    String fLength = fibre['metrics']?['fibreLengthMm']?.toString() ?? 'N/A';


    var yarn = selectedBale['qualitytests.yarn'] ?? {};
    String yGrade = yarn['calculatedGrade'] ?? 'N/A';
    String yScore = yarn['calculatedScore']?.toString() ?? 'N/A';
    String yCount = yarn['metrics']?['actualCount']?.toString() ?? 'N/A';
    String yClsp = yarn['metrics']?['clsp']?.toString() ?? 'N/A';

    var fabric = selectedBale['qualitytests.fabric'] ?? {};
    String fabGrade = fabric['calculatedGrade'] ?? 'N/A';
    String fabScore = fabric['calculatedScore']?.toString() ?? 'N/A';
    String fabGsm = fabric['metrics']?['gsm']?.toString() ?? 'N/A';

    Map<String, dynamic> slimData = {
      'baleId': selectedBale['baleId'] ?? 'Unknown',
      'gatePassRef': selectedBale['gatePassRef'] ?? 'Unknown',
      'baleType': selectedBale['baleType'] ?? 'Unknown',
      'supplier': selectedBale['supplier'] ?? 'Unknown',
      'weight': selectedBale['weight'] ?? '0',
      'price': selectedBale['price'] ?? '0',
      'o_score': selectedBale['overAllBaleScore']?.toString() ?? 'N/A',
      'in': false,
      'f_grd': fGrade, 'f_scr': fScore, 'f_den': fDenier, 'f_len': fLength,
      'y_grd': yGrade, 'y_scr': yScore, 'y_cnt': yCount, 'y_clsp': yClsp,
      'fab_grd': fabGrade, 'fab_scr': fabScore, 'fab_gsm': fabGsm,
    };

    return jsonEncode(slimData);
  }


}