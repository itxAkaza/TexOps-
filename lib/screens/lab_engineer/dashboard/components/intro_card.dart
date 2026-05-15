import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:texops/resources/route/routes_names.dart';

import '../../../../controllers/lab_engineer/lab_engineer_Dashboard/labEngineer_dashboard_controller.dart';
import '../../../../resources/colors/app_colors.dart';
// Ensure your color file is imported

class DashboardTopCard extends StatelessWidget {
  final LabEngineerController controller;
  final GlobalKey<ScaffoldState> drawerKey;

   DashboardTopCard({Key? key, required this.controller,required this.drawerKey}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    String todayDate = DateFormat('EEEE, MMMM dd, yyyy').format(DateTime.now());
    final height =MediaQuery.of(context).size.height;
    final width =MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryDarkTeal,
        borderRadius: BorderRadius.circular(30),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //profile
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: ()=> drawerKey.currentState?.openDrawer(),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColors.accentOrange,
                      backgroundImage: controller.userProfilePic.value.isNotEmpty
                          ? NetworkImage(controller.userProfilePic.value)
                          : null,

                    ),
                  ),
                  const SizedBox(width: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.userName.value,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        controller.userRole.value,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {},
              )
            ],
          ),
          const SizedBox(height: 25),

          //date
          Text(
            todayDate,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 5),

          //value
          const Text(
            "Total Value",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),


          Obx(() => Text(
            NumberFormat.currency(symbol: 'Rs', decimalDigits: 2).format(controller.totalSystemValue.value),
            style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          )),

          const SizedBox(height: 25),

          //buttons
          Row(
            mainAxisAlignment: .center,
            children: [
              GestureDetector(
                onTap: ()=>Get.toNamed(RoutesNames.bailEntryView),
                child: Container(
                  height: height*0.1,
                  width: width*0.4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),

                  ),
                  padding: EdgeInsets.all(20),

                  child: Row(
                    mainAxisAlignment: .center,
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 4,),
                      Text("Record New \n Lab Report",style: TextStyle(color: AppColors.primaryDarkTeal),),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 6,),
              GestureDetector(
                onTap: (){},
                child: Container(
                  height: height*0.1,
                  width: width*0.4,
                  decoration: BoxDecoration(
                    color: AppColors.accentOrange,
                    borderRadius: BorderRadius.circular(14),

                  ),
                  padding: EdgeInsets.all(20),

                  child: Row(
                    mainAxisAlignment: .center,
                    children: [
                      Icon(Icons.outbond_outlined,color: Colors.white,),
                      SizedBox(width: 4,),
                      Text("GatePass\n Transfer",style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),

          // Quarter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.getCurrentQuarter(),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

