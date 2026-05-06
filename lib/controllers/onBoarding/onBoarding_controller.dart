
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class onBoradingController extends GetxController
{

  RxBool isLast=false.obs;
  final controller=PageController();

  void makeLast(bool last)
  {
    isLast.value=last;

  }

}