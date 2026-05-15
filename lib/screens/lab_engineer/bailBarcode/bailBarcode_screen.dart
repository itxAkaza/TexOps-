import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/resources/route/routes_names.dart';
import 'package:texops/screens/lab_engineer/bailBarcode/widget/qrButton.dart';
import 'package:texops/screens/lab_engineer/record_gatePass/widgets/text.dart';
import 'package:texops/screens/onBoarding/widgets/my_button.dart';

import '../../../controllers/lab_engineer/record_gatePass/gatePass_controller.dart';

class BailBarcodeScreen extends StatelessWidget {
  const BailBarcodeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final baleController = Get.find<BaleEntryController>();
    final height =MediaQuery.of(context).size.height;
    final width =MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundLightPeach,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppColors.primaryDarkTeal),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: ()=>Get.offAllNamed(RoutesNames.labEngineerDashboard),
              icon: Icon(Icons.close_rounded)
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: .center,
            children: [
              MYText(text: "Bale Receiving Tag",size: 22,color: AppColors.primaryDarkTeal,fontweight: FontWeight.bold,),
              SizedBox(height: height*0.02,),
              Card(
                color: Colors.white,
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: QrImageView(
                    data: baleController.qrData.value,
                    errorCorrectionLevel: QrErrorCorrectLevel.H,
                    backgroundColor: Colors.white,
                    version: QrVersions.auto,
                    size: 205,
          
                    // embeddedImage: AssetImage("assets/images/qrlogo.png"),
                    // embeddedImageStyle: QrEmbeddedImageStyle(
                    //   size: Size(50, 50),
                    // ),
          
                    eyeStyle: QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color:Colors.black,
                    ),
          
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.circle,
                      color: Colors.black,
                    ),
          
          
          
          
          
          
          
          
                  ),
                ),
              ),
          
              SizedBox(height: height*0.03,),
          
              MYText(text: "Scan or Verify Details Below",size: 18,color: AppColors.primaryDarkTeal,fontweight: FontWeight.w400,),
          
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: MYText(
                        text: "Ensure details match physical bale arrival.",
                        color: Colors.grey.shade600,
                        size: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
          
                    // Grid Details
                    Row(
                      children: [
                        _buildDetailColumn("Bale ID", baleController.generatedBaleId.value),
                        _buildDetailColumn("Supplier", baleController.selectedSupplier.value ?? "N/A"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildDetailColumn("Material", baleController.baleTypeController.text.isNotEmpty ? baleController.baleTypeController.text : "N/A"),
                        _buildDetailColumn("Weight", "${baleController.weightController.text} kg"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildDetailColumn("Cost", "Rs${baleController.priceController.text}", valueSize: 14),
                        _buildDetailColumn("GatePassID", "#${baleController.gatePassRefController.text}"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildDetailColumn("Date Received", baleController.arrivalTime),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildDetailColumn("EngineerID", baleController.engineerId.value),
                        _buildDetailColumn("Vehicle Number", baleController.vehicleNumberController.text),
                      ],
                    ),
          
                    const SizedBox(height: 30),


                    QrButton(
                        text: "Share QR as PDF",
                        height: height*0.07,
                        width: width,
                        onTap: baleController.shareQRAsPDF,
                        color: AppColors.primaryDarkTeal,
                      icon: Icons.share_outlined,

                    ),

                    const SizedBox(height: 10),

                    Obx(
                        (){
                          return QrButton(
                            text: "Save Tag & Register",
                            height: height*0.07,
                            width: width,
                            onTap: baleController.saveTagAndRegister,
                            color: AppColors.accentOrange,
                            isLoading: baleController.isLoading.value,
                            icon: Icons.bookmark_border_outlined,

                          );
                        }
                    ),




          
                    const SizedBox(height: 20),


                  ],
                ),
              ),
            
          
          
          ]
          
          ),
        ),
      )
    );
  }
}


Widget _buildDetailColumn(String title, String value, {double valueSize = 16}) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MYText(
          text: title,
          color: Colors.grey.shade600,
          size: 14,
        ),
        const SizedBox(height: 4),
        MYText(
          text: value,
          color: AppColors.primaryDarkTeal,
          size: valueSize,
          fontweight: FontWeight.bold,
        ),
      ],
    ),
  );
}
