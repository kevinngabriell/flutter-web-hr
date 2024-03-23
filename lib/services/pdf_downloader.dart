import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;

//PDF Perjalanan Dinas
Future<Uint8List> generatePDFPerjalananDinas() async{
  final pdf = pw.Document();
  final completer = Completer<Uint8List>();

  pdf.addPage(
    pw.Page(
      margin: const pw.EdgeInsets.all(10),
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                   pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text('Logo'),
                      pw.SizedBox(width: 30.sp),
                      pw.Column(
                        children: [
                          pw.Text('companyName', style: 
                            pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 18.0,
                              color: PdfColor.fromHex('#333333'), // Replace with your desired color
                            ),
                          ),
                          pw.SizedBox(height: 5.sp),
                          pw.Text('companyAddress', style: pw.TextStyle(fontSize: 12.0,color: PdfColor.fromHex('#555555'),),),
                          pw.SizedBox(height: 8.sp),
                        ]
                      )
                    ]
                  )
                ]
              )
            ]
        );
      }
    )
  );

  return pdf.save();
}

Future<void> generateAndDisplayPDF() async {

    // Generate PDF
    final Uint8List pdfBytes = await generatePDFPerjalananDinas();

    // Convert Uint8List to Blob
    final html.Blob blob = html.Blob([pdfBytes]);

    // Create a data URL
    final String url = html.Url.createObjectUrlFromBlob(blob);

    // Create a download link
    final html.AnchorElement anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'PerjalananDinas.pdf'
      ..click();

    // Clean up
    html.Url.revokeObjectUrl(url);
  }