import 'package:flutter/material.dart';
import 'package:get/get.dart';

class bailDetailController extends GetxController
{

  final RxMap<String, dynamic> bailData = <String, dynamic>{}.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    bailData.assignAll(Get.arguments[0]);
  }
  


}