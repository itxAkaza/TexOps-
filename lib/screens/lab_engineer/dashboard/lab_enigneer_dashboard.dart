import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../record_gatePass/bail_entry_screen.dart';


class LabEnigneerDashboard extends StatelessWidget {
  const LabEnigneerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        children: [
          Center(child: Text("Testing ")),
          ElevatedButton(onPressed: (){
            Get.to(BaleEntryScreen());

          }, child: Text("go"))

        ],
      ),

    );
  }
}
