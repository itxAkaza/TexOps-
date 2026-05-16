
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/screens/lab_engineer/bailBarcode/widget/qrButton.dart';
import 'package:texops/screens/lab_engineer/record_gatePass/widgets/text.dart';

import '../../../controllers/lab_engineer/share_qr/view_share_qr.dart';



class ViewQrScreen extends StatelessWidget {
  const ViewQrScreen({super.key});

  @override
  Widget build(BuildContext context)
  {
    final controller = Get.put(ViewQrController());
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundLightPeach,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.primaryDarkTeal),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Tag Viewer",
          style: TextStyle(
              color: AppColors.primaryDarkTeal,
              fontWeight: FontWeight.bold,
              fontSize: 20
          ),
        ),

      ),
      body: Obx(()
      {
        if (controller.qrData.value.isEmpty)
        {
          return const Center(child: Text("No QR Data Available"));
        }

        return Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [


                  MYText(
                    text: "Bale #${controller.baleId.value}",
                    size: 24,
                    color: AppColors.primaryDarkTeal,
                    fontweight: FontWeight.bold,
                  ),

                  SizedBox(height: height * 0.05),

                  Card(
                    color: Colors.white,
                    elevation: 12,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: QrImageView(
                        data: controller.qrData.value,
                        errorCorrectionLevel: QrErrorCorrectLevel.H,
                        backgroundColor: Colors.white,
                        version: QrVersions.auto,
                        size: width * 0.65,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Colors.black,
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.circle,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.07),


                  QrButton(
                    text: "Share QR as PDF",
                    height: height * 0.07,
                    width: width * 0.9,
                    onTap: controller.shareQRAsPDF,
                    color: AppColors.primaryDarkTeal,
                    icon: Icons.share_outlined,
                  ),
                  SizedBox(height: height * 0.04),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}