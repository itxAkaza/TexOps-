import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class GatePassPdfService {


  static Future<void> generateAndShare({
    required String gatePassId,
    required String qrData,
  }) async {
    try {
      final pdf = pw.Document();


      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'TexOps',
                    style: pw.TextStyle(
                      fontSize: 48,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.teal900,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Gate Pass ID: #$gatePassId',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                  pw.SizedBox(height: 50),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(20),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.black, width: 2),
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
                    ),
                    child: pw.BarcodeWidget(
                      barcode: pw.Barcode.qrCode(),
                      data: qrData,
                      width: 250,
                      height: 250,
                    ),
                  ),
                  pw.SizedBox(height: 30),
                  pw.Text(
                    'Scan this QR code to verify bale details.',
                    style: const pw.TextStyle(fontSize: 16, color: PdfColors.grey700),
                  ),
                ],
              ),
            );
          },
        ),
      );

      // Save the PDF temporarily
      final output = await getTemporaryDirectory();
      final filePath = '${output.path}/TexOps_GatePass_$gatePassId.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      // Share the file
      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'TexOps Gate Pass QR Code: #$gatePassId',
      );

    } catch (e) {

      throw Exception('Failed to generate PDF: $e');
    }
  }
}