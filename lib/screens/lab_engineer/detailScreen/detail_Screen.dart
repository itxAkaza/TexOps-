import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:texops/controllers/lab_engineer/detail/bail_detail_controller.dart';


class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bailDatController=Get.put(bailDetailController());
    return Scaffold(
      body: Column(
        mainAxisAlignment: .center,
        children: [
          Text(bailDatController.bailData["price"].toString())


        ],
      ),
    );
  }
}
