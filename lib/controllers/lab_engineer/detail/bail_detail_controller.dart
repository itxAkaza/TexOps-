import 'dart:convert';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:texops/Utiles/utiles.dart';

import '../../../data/fireStoreDB/labEnginner/bail_detail_data.dart';



class BailDetailController extends GetxController
{
  final RxMap<String, dynamic> bailData = <String, dynamic>{}.obs;

  final RxBool isReadyForYarn = false.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit()
  {
    super.onInit();
    if (Get.arguments != null && Get.arguments.isNotEmpty)
    {
      bailData.assignAll(Get.arguments[0]);
      isReadyForYarn.value = bailData['readyForYarn'] ?? false;
    }
  }


  Future<void> toggleYarnStatus(bool value) async
  {
    String? userId = bailData['engineerUID'] ?? FirebaseAuth.instance.currentUser?.uid;
    String baleId = bailData['baleId'] ?? '';

    if (userId == null || baleId.isEmpty) return;


    isReadyForYarn.value = value;
    bailData['readyForYarn'] = value;

    try
    {
      await BaleDetailFirebaseService.updateYarnStatus(userId, baleId, value);
      Utils.toastMessegessuccess("Status Updated");
    } catch (e)
    {

      isReadyForYarn.value = !value;
      bailData['readyForYarn'] = !value;
      Utils.toastMesseges(e.toString());
    }

  }


  Future<void> deleteCurrentBale() async
  {
    String? userId = bailData['engineerUID'] ?? FirebaseAuth.instance.currentUser?.uid;
    String baleId = bailData['baleId'] ?? '';


    double amountToSubtract = double.tryParse(bailData['price']?.toString() ?? '0') ?? 0.0;

    if (userId == null || baleId.isEmpty) return;

    isLoading.value = true;
    try {

      await BaleDetailFirebaseService.deleteBale(
        userId: userId,
        baleId: baleId,
        amountToSubtract: amountToSubtract,
      );

      Utils.toastMessegessuccess("Deleted");
      Get.back();

    } catch (e)
    {
     Utils.toastMesseges(e.toString());
    } finally
    {
      isLoading.value = false;
    }


  }


  void openQrScreen() {
    var qrData = bailData['qrCodeData'];

    String qrString = qrData is String ? qrData : jsonEncode(qrData);


  }
}