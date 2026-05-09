import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/screens/lab_engineer/record_gatePass/widgets/text.dart';

import '../../../controllers/lab_engineer/record_gatePass/gatePass_controller.dart';

class BailbarcodeScreen extends StatelessWidget {
  const BailbarcodeScreen({super.key});

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
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
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
                        _buildDetailColumn("Bale ID", "#${baleController.generatedBaleId.value}"),
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
                        _buildDetailColumn("Cost", "\$${baleController.priceController.text} | Local Database Req.", valueSize: 14),
                        _buildDetailColumn("GatePassID", "#${baleController.gatePassRefController.text}"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildDetailColumn("Date Received", baleController.arrivalTime),
                        const Expanded(child: SizedBox()), // Empty space for alignment
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildDetailColumn("EngineerID", baleController.EnginnerID),
                        _buildDetailColumn("Vehicle Number", baleController.vehicleNumberController.text),
                      ],
                    ),
          
                    const SizedBox(height: 30),
          
                    // Action Buttons
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDarkTeal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.share_outlined, color: Colors.white),
                        label: MYText(
                          text: "Share QR as PDF",
                          color: Colors.white,
                          size: 16,
                          fontweight: FontWeight.bold,
                        ),
                        onPressed: () {
                          // Implement Share logic
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFA756), // Orange matching the design
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: MYText(
                          text: "Save Tag & Register",
                          color: Colors.white,
                          size: 16,
                          fontweight: FontWeight.bold,
                        ),
                        onPressed: () {
                          // Implement Save logic
                        },
                      ),
                    ),
          
                    const SizedBox(height: 20),
                    Center(
                      child: MYText(
                        text: "... 2 minutes ago",
                        color: Colors.grey.shade500,
                        size: 14,
                      ),
                    ),
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
