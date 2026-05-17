import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/screens/drawerScreens/scan/scan_InBound_screen.dart';
import 'package:texops/screens/drawerScreens/scan/scan_OutBound_screen.dart';


class TexOpsBarcodeScanner extends StatefulWidget {
  const TexOpsBarcodeScanner({super.key});

  @override
  State<TexOpsBarcodeScanner> createState() => _TexOpsBarcodeScannerState();
}

class _TexOpsBarcodeScannerState extends State<TexOpsBarcodeScanner> {
  bool isScanning = true;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    final Rect scanWindowRectangle = Rect.fromCenter(
      center: screenSize.center(Offset.zero),
      width: 250,
      height: 250,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // LAYER 1: The Live Camera Feed
          MobileScanner(
            scanWindow: scanWindowRectangle,
            overlayBuilder: (context, constraints) => const SizedBox(),
            onDetect: (capture) {
              if (!isScanning) return;

              final List<Barcode> barcodes = capture.barcodes;

              if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                setState(() => isScanning = false);

                final String rawData = barcodes.first.rawValue!;

                try {
                  // 1. Decode the JSON map we generated earlier
                  Map<String, dynamic> parsedData = jsonDecode(rawData);

                  // 2. Intelligent Routing based on the "in" status
                  bool isInbound = parsedData['in'] ?? true;

                  if (isInbound) {
                    // Route to Basic Inbound Screen
                    Get.to(() => ScannedInboundScreen(baleData: parsedData))?.then((_) {
                      setState(() => isScanning = true);
                    });
                  } else {
                    // Route to Detailed Outbound Screen
                    Get.to(() => ScannedOutboundScreen(manifestData: parsedData))?.then((_) {
                      setState(() => isScanning = true);
                    });
                  }

                } catch (e) {
                  Get.snackbar(
                    'Invalid QR',
                    'This does not appear to be a valid TexOps label.',
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(20),
                  );
                  setState(() => isScanning = true);
                }
              }
            },
          ),

          // LAYER 2: The Dark Overlay
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.7),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                Center(
                  child: Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // LAYER 3: The Branded Frame
          Center(
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryDarkTeal, width: 4),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          // LAYER 4: The Instructions
          const Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Text(
              "Align QR code within the frame",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),

          // LAYER 5: Back Button & Header
          Positioned(
            top: 50,
            left: 10,
            right: 20,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
                const Text(
                  "Scan Bale",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}