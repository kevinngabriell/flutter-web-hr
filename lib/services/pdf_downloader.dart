// ignore_for_file: non_constant_identifier_names, avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;

pw.Widget buildHeader({
  required String company_name,
  required String company_address,
  required pw.MemoryImage logoImage,
}) {
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.center,
    mainAxisAlignment: pw.MainAxisAlignment.center,
    children: [
      pw.Image(logoImage), 
      pw.SizedBox(width: 30),
      pw.Column(
        children: [
          pw.Text(
            company_name,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 18,
              color: PdfColor.fromHex('#333333')
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            company_address,
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColor.fromHex('#555555')
            ),
          ),
          pw.SizedBox(height: 8),
        ],
      ),
    ],
  );
}

//PDF Perjalanan Dinas
Future<Uint8List> generatePDFPerjalananDinas(company_name, company_address, nama_karyawan, departemen, kota_tujuan, lama_perjalanan, keperluan, tim, member_satu, member_dua, member_tiga, member_empat, biaya, transportasi, tanggal_pengajuan, namaMengetahui, namaMenyetujui, tanggalMengetahui, tanggalMenyetujui) async{
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
                      buildHeader(company_name: company_name, company_address: company_address, logoImage: pw.MemoryImage(
                        base64Decode('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'),
                      ))
                    ]
                  )
                ]
              ),
              pw.Divider(thickness: 1.0, color: PdfColor.fromHex('#333333')),
              pw.SizedBox(height: 20),
              pw.Expanded(
                child: pw.Padding(
                  padding: const pw.EdgeInsets.only(),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Center(
                        child: pw.Text(
                          'PENGAJUAN PERJALANAN DINAS LUAR KOTA',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 18.0,
                            color: PdfColor.fromHex('#333333'), // Replace with your desired color
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.SizedBox(height: 40),
                      pw.Container(
                        margin: const pw.EdgeInsets.only(left: 20.0),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Dengan ini saya mengajukan permohonan perjalanan Dinas Luar Kota : ',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                color: PdfColor.fromHex('#333333'), // Replace with your desired color
                              ),
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.SizedBox(height: 22),
                            pw.Text(
                              '       Nama                                  : $nama_karyawan',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                color: PdfColor.fromHex('#555555'), // Replace with your desired color
                              ),
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.SizedBox(height: 12.h),
                            pw.Text(
                              '       Departemen                        : $departemen',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                color: PdfColor.fromHex('#555555'), // Replace with your desired color
                              ),
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.SizedBox(height: 12.h),
                            pw.Text(
                              '       Kota Tujuan                         : $kota_tujuan',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                color: PdfColor.fromHex('#555555'), // Replace with your desired color
                              ),
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.SizedBox(height: 12.h),
                            pw.Text(
                              '       Lama Perjalanan                 : $lama_perjalanan',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                color: PdfColor.fromHex('#555555'), // Replace with your desired color
                              ),
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.SizedBox(height: 12.h),
                            pw.Text(
                              '       Keperluan                            : $keperluan',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                color: PdfColor.fromHex('#555555'), // Replace with your desired color
                              ),
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.SizedBox(height: 12.h),
                            pw.Text(
                              '       Tim Analis / Teknisi             : $tim\n                                                     $member_satu\n                                                     $member_dua\n                                                     $member_tiga\n                                                     $member_empat',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                color: PdfColor.fromHex('#555555'), // Replace with your desired color
                              ),
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.SizedBox(height: 12.h),
                            pw.Text(
                              '       Biaya                                   : $biaya',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                color: PdfColor.fromHex('#555555'), // Replace with your desired color
                              ),
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.SizedBox(height: 12.h),
                            pw.Text(
                              '       Transportasi                        : $transportasi',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                color: PdfColor.fromHex('#555555'), // Replace with your desired color
                              ),
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.SizedBox(height: 22),
                            pw.Text(
                              'Setelah selesai melakukan perjalanan dinas akan membuat laporan dinas mengenai hasil perjalanan serta laporan pertanggungjawaban biaya yang disetujui oleh atasan untuk diberikan kepada GA.',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                color: PdfColor.fromHex('#333333'), // Replace with your desired color
                              ),
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.SizedBox(height: 32),
                            pw.Container(
                              margin: const pw.EdgeInsets.only(right: 20.0),
                              child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                children: [
                                  pw.Text(
                                    'Tangerang, $tanggal_pengajuan',
                                    style: pw.TextStyle(
                                      fontSize: 12.0,
                                      color: PdfColor.fromHex('#555555'), // Replace with your desired color
                                    ),
                                  ),
                                ]
                              ),
                            ),
                          ]
                        )
                      )
                    ]
                  )
                )
              ),
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 20.0),
                child: pw.Text('Dibuat oleh      : $nama_karyawan ($tanggal_pengajuan)', style: pw.TextStyle(fontSize: 12.0,color: PdfColor.fromHex('#555555'),)),
              ),
              pw.SizedBox(height: 12.h),
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 20.0),
                child: pw.Text('Mengetahui     : $namaMengetahui ($tanggalMengetahui)', style: pw.TextStyle(fontSize: 12.0,color: PdfColor.fromHex('#555555'),)),
              ),
              pw.SizedBox(height: 12.h),
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 20.0),
                child:  pw.Text('Disetujui oleh   : $namaMenyetujui ($tanggalMenyetujui)', style: pw.TextStyle(fontSize: 12.0,color: PdfColor.fromHex('#555555'),)),
              ),
              pw.SizedBox(height: 20.h),
              pw.Divider(thickness: 1.0, color: PdfColor.fromHex('#333333')),
              pw.Footer(
                title: pw.Text('Dokumen ini dibuat secara otomatis oleh sistem dan tidak membutuhkan tanda tangan', style: pw.TextStyle(fontSize: 8.0,color: PdfColor.fromHex('#555555'),)),
              )
            ]
        );
      }
    )
  );

  return pdf.save();
}

Future<void> generateAndDisplayPDFPerjalananDinas(buisnessTripId, company_name, company_address, nama_karyawan, departemen, kota_tujuan, lama_perjalanan, keperluan, tim, member_satu, member_dua, member_tiga, member_empat, biaya, transportasi, tanggal_pengajuan, namaMengetahui, namaMenyetujui, tanggalMengetahui, tanggalMenyetujui) async {
 
    // Generate PDF
    final Uint8List pdfBytes = await generatePDFPerjalananDinas(company_name, company_address, nama_karyawan, departemen, kota_tujuan, lama_perjalanan, keperluan, tim, member_satu, member_dua, member_tiga, member_empat, biaya, transportasi, tanggal_pengajuan, namaMengetahui, namaMenyetujui, tanggalMengetahui, tanggalMenyetujui);

    // Convert Uint8List to Blob
    final html.Blob blob = html.Blob([pdfBytes]);

    // Create a data URL
    final String url = html.Url.createObjectUrlFromBlob(blob);

    // Create a download link
    final html.AnchorElement anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'PerjalananDinas-$buisnessTripId.pdf'
      ..click();

    // Clean up
    html.Url.revokeObjectUrl(url);
  }

  Future<Uint8List> generatePDFLPD(companyName, companyAddress, namaKaryawan, departemen, spvName, memberOne, memberTwo, 
  memberThree, memberFour, lpdID, projectName, strtDate, endedDate, countDayTiket, priceTiket,
  countDayPenginapan, countDayTransport, countDayEntertain, countDayLain, pricePenginapan, priceTransport, 
  priceEntertain, priceLain, totalTiket, totalPenginapan, totalTransport, totalEntertain, totalLain, JumlahTiket, JumlahHotel, 
  JumlahTransport, JumlahEntertain, JumlahLain, GrandTotal, uraianLPD, advancedCash, Kekurangan, insertDt, kosongSatu, kosongDua, kosongTiga, 
  kosongEmpat, kosongLima, kosongEnam, kosongTujuh, kosongDelapan) async{
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
                      buildHeader(company_name: companyName, company_address: companyAddress, logoImage: pw.MemoryImage(
                        base64Decode('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'),
                      ))
                    ]
                  )
                ]
              ),
              pw.Divider(thickness: 1.0, color: PdfColor.fromHex('#333333')),
              pw.SizedBox(height: 20),
              pw.Expanded(
                child: pw.Padding(
                  padding: const pw.EdgeInsets.only(),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Center(
                        child: pw.Text(
                          'LAPORAN PERJALANAN DINAS',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 18.0,
                            color: PdfColor.fromHex('#333333'), // Replace with your desired color
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.SizedBox(height: 40),
                      pw.Container(
                        margin: const pw.EdgeInsets.only(left: 20.0, right: 20.0),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.SizedBox(
                                  width: 320,
                                  child: pw.Text('Nama                                       : $namaKaryawan')
                                ),
                                pw.SizedBox(
                                  width: 320,
                                  child: pw.Text('Bagian         : $departemen')
                                )
                              ]
                            ),
                            pw.SizedBox(height: 8),
                            pw.Row(
                              children: [
                                pw.SizedBox(
                                  width: 320,
                                  child: pw.Text('Perjalanan Disetujui Oleh        : $spvName')
                                ),
                                pw.SizedBox(
                                  width: 320,
                                  child: pw.Text('SPPD No     : $lpdID')
                                )
                              ]
                            ),
                            pw.SizedBox(height: 8),
                            pw.Text(
                              'Nama-nama yang ikut serta    : $memberOne, $memberTwo, $memberThree, $memberFour',
                            ),
                            pw.SizedBox(height: 8),
                            pw.Text(
                              'Tanggal Dinas                         : $strtDate - $endedDate',
                            ),
                            pw.SizedBox(height: 8),
                            pw.Text(
                              'Proyek                                     : $projectName',
                            ),
                            pw.SizedBox(height: 40),
                            pw.Row(
                              children: [
                                pw.SizedBox(
                                  width: 150,
                                  child: pw.Text('Uraian Pembiayaan', textAlign: pw.TextAlign.center,)
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('Jumlah Hari', textAlign: pw.TextAlign.center,)
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('Satuan', textAlign: pw.TextAlign.center,)
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('Jumlah Biaya', textAlign: pw.TextAlign.center,)
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('JUMLAH (IDR)', textAlign: pw.TextAlign.center,)
                                ),
                              ]
                            ),
                            pw.SizedBox(height: 15),
                            pw.Row(
                              children: [
                                pw.SizedBox(
                                  width: 150,
                                  child: pw.Text('Tiket Pesawat')
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('$countDayTiket hari', textAlign: pw.TextAlign.center,)
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('$priceTiket', textAlign: pw.TextAlign.right,)
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('$totalPenginapan', textAlign: pw.TextAlign.right,)
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('$JumlahTiket', textAlign: pw.TextAlign.right,)
                                ),
                              ]
                            ),
                            pw.SizedBox(height: 15),
                            pw.Row(
                              children: [
                                pw.SizedBox(
                                  width: 150,
                                  child: pw.Text('Hotel / Penginapan')
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('$countDayPenginapan Hari', textAlign: pw.TextAlign.center,)
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('$pricePenginapan', textAlign: pw.TextAlign.right,)
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('$totalPenginapan', textAlign: pw.TextAlign.right,)
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('$JumlahHotel', textAlign: pw.TextAlign.right,)
                                ),
                              ]
                            ),
                            pw.SizedBox(height: 15),
                            pw.Row(
                              children: [
                                pw.SizedBox(
                                  width: 150,
                                  child: pw.Text('Uang Saku $namaKaryawan')
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('$countDayPenginapan Hari', textAlign: pw.TextAlign.center,)
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('$pricePenginapan', textAlign: pw.TextAlign.right,)
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('$totalPenginapan', textAlign: pw.TextAlign.right,)
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('$JumlahHotel', textAlign: pw.TextAlign.right,)
                                ),
                              ]
                            ),
                            pw.SizedBox(height: 15),
                            if(!kosongSatu)
                              pw.Row(
                                children: [
                                  pw.SizedBox(
                                    width: 150,
                                    child: pw.Text('Uang Saku $memberOne')
                                  ),
                                  pw.SizedBox(
                                    width: 100,
                                    child: pw.Text('$countDayPenginapan Hari', textAlign: pw.TextAlign.center,)
                                  ),
                                  pw.SizedBox(
                                    width: 100,
                                    child: pw.Text('$pricePenginapan', textAlign: pw.TextAlign.right,)
                                  ),
                                  pw.SizedBox(
                                    width: 100,
                                    child: pw.Text('$totalPenginapan', textAlign: pw.TextAlign.right,)
                                  ),
                                  pw.SizedBox(
                                    width: 100,
                                    child: pw.Text('$JumlahHotel', textAlign: pw.TextAlign.right,)
                                  ),
                                ]
                              ),
                            if(!kosongSatu)
                              pw.SizedBox(height: 15),
                            if(!kosongDua)
                              pw.Row(
                                children: [
                                  pw.SizedBox(
                                    width: 150,
                                    child: pw.Text('Uang Saku $memberTwo')
                                  ),
                                  pw.SizedBox(
                                    width: 100,
                                    child: pw.Text('$countDayPenginapan Hari', textAlign: pw.TextAlign.center,)
                                  ),
                                  pw.SizedBox(
                                    width: 100,
                                    child: pw.Text('$pricePenginapan', textAlign: pw.TextAlign.right,)
                                  ),
                                  pw.SizedBox(
                                    width: 100,
                                    child: pw.Text('$totalPenginapan', textAlign: pw.TextAlign.right,)
                                  ),
                                  pw.SizedBox(
                                    width: 100,
                                    child: pw.Text('$JumlahHotel', textAlign: pw.TextAlign.right,)
                                  ),
                                ]
                              ),
                            if(!kosongDua)
                              pw.SizedBox(height: 15),
                            if(!kosongTiga)
                              pw.Row(
                                children: [
                                  pw.SizedBox(
                                    width: 150,
                                    child: pw.Text('Uang Saku $memberThree')
                                  ),
                                  pw.SizedBox(
                                    width: 100,
                                    child: pw.Text('$countDayPenginapan Hari', textAlign: pw.TextAlign.center,)
                                  ),
                                  pw.SizedBox(
                                    width: 100,
                                    child: pw.Text('$pricePenginapan', textAlign: pw.TextAlign.right,)
                                  ),
                                  pw.SizedBox(
                                    width: 100,
                                    child: pw.Text('$totalPenginapan', textAlign: pw.TextAlign.right,)
                                  ),
                                  pw.SizedBox(
                                    width: 100,
                                    child: pw.Text('$JumlahHotel', textAlign: pw.TextAlign.right,)
                                  ),
                                ]
                              ),
                            if(!kosongTiga)
                              pw.SizedBox(height: 15),
                            if(!kosongEmpat)
                              pw.Row(
                                children: [
                                  pw.SizedBox(
                                    width: 150,
                                    child: pw.Text('Uang Saku $memberFour')
                                  ),
                                  pw.SizedBox(
                                    width: 100,
                                    child: pw.Text('$countDayPenginapan Hari', textAlign: pw.TextAlign.center,)
                                  ),
                                  pw.SizedBox(
                                    width: 100,
                                    child: pw.Text('$pricePenginapan', textAlign: pw.TextAlign.right,)
                                  ),
                                  pw.SizedBox(
                                    width: 100,
                                    child: pw.Text('$totalPenginapan', textAlign: pw.TextAlign.right,)
                                  ),
                                  pw.SizedBox(
                                    width: 100,
                                    child: pw.Text('$JumlahHotel', textAlign: pw.TextAlign.right,)
                                  ),
                                ]
                              ),
                            if(!kosongEmpat)
                              pw.SizedBox(height: 15),
                            pw.Row(
                              children: [
                                pw.SizedBox(
                                  width: 150,
                                  child: pw.Text('Transport (Taxi) Lokal/sewa mobil harian')
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('$countDayTransport Hari', textAlign: pw.TextAlign.center,)
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('$priceTransport', textAlign: pw.TextAlign.right,)
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('$totalTransport', textAlign: pw.TextAlign.right,)
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('$JumlahTransport', textAlign: pw.TextAlign.right,)
                                ),
                              ]
                            ),
                            pw.SizedBox(height: 15),
                            pw.Row(
                              children: [
                                pw.SizedBox(
                                  width: 150,
                                  child: pw.Text('By entertain')
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('$countDayEntertain Hari', textAlign: pw.TextAlign.center,)
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('$priceEntertain', textAlign: pw.TextAlign.right,)
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('$totalEntertain', textAlign: pw.TextAlign.right,)
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('$JumlahEntertain', textAlign: pw.TextAlign.right,)
                                ),
                              ]
                            ),
                            pw.SizedBox(height: 15),
                            pw.Row(
                              children: [
                                pw.SizedBox(
                                  width: 150,
                                  child: pw.Text('Lain-lain')
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('$countDayLain Hari', textAlign: pw.TextAlign.center,)
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('$priceLain', textAlign: pw.TextAlign.right,)
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('$totalLain', textAlign: pw.TextAlign.right,)
                                ),
                                pw.SizedBox(
                                  width: 100,
                                  child: pw.Text('$JumlahLain', textAlign: pw.TextAlign.right,)
                                ),
                              ]
                            ),
                            // pw.SizedBox(height: 15),
                            // pw.Row(
                            //   children: [
                            //     pw.SizedBox(
                            //       width: 450,
                            //       child: pw.Text('GRAND TOTAL', textAlign: pw.TextAlign.right,)
                            //     ),
                            //     pw.SizedBox(
                            //       width: 100,
                            //       child: pw.Text('$GrandTotal', textAlign: pw.TextAlign.right,)
                            //     ),
                            //   ]
                            // ),
                            // pw.SizedBox(height: 15),
                            // pw.Row(
                            //   children: [
                            //     pw.SizedBox(
                            //       width: 450,
                            //       child: pw.Text('UANG MUKA (Advance)', textAlign: pw.TextAlign.right,)
                            //     ),
                            //     pw.SizedBox(
                            //       width: 100,
                            //       child: pw.Text('$advancedCash', textAlign: pw.TextAlign.right,)
                            //     ),
                            //   ]
                            // ),
                            // pw.SizedBox(height: 25),
                            // pw.Row(
                            //   children: [
                            //     pw.SizedBox(
                            //       width: 450,
                            //       child: pw.Text('Kekurangan/Kelebihan', textAlign: pw.TextAlign.right,)
                            //     ),
                            //     pw.SizedBox(
                            //       width: 100,
                            //       child: pw.Text('$Kekurangan', textAlign: pw.TextAlign.right,)
                            //     ),
                            //   ]
                            // ),
                            // pw.SizedBox(height: 50),
                            // pw.Text(
                            //   '$uraianLPD',
                            // ),
                          ]
                        )
                      )
                    ]
                  )
                )
              ),
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 20.0),
                child: pw.Text('Dibuat oleh      : $namaKaryawan ($insertDt)', style: pw.TextStyle(fontSize: 12.0,color: PdfColor.fromHex('#555555'),)),
              ),
              pw.SizedBox(height: 12.h),
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 20.0),
                child: pw.Text('Mengetahui     : ', style: pw.TextStyle(fontSize: 12.0,color: PdfColor.fromHex('#555555'),)),
              ),
              pw.SizedBox(height: 12.h),
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 20.0),
                child:  pw.Text('Disetujui oleh   : ', style: pw.TextStyle(fontSize: 12.0,color: PdfColor.fromHex('#555555'),)),
              ),
              pw.SizedBox(height: 20.h),
              pw.Divider(thickness: 1.0, color: PdfColor.fromHex('#333333')),
              pw.Footer(
                title: pw.Text('Dokumen ini dibuat secara otomatis oleh sistem dan tidak membutuhkan tanda tangan', style: pw.TextStyle(fontSize: 8.0,color: PdfColor.fromHex('#555555'),)),
              )
            ]
        );
      }
    )
  );

  return pdf.save();
  }

  Future<void> generateAndDisplayPDFLPD(companyName, companyAddress, namaKaryawan, departemen, spvName, memberOne, memberTwo, 
  memberThree, memberFour, lpdID, projectName, strtDate, endedDate, countDayTiket, priceTiket,
  countDayPenginapan, countDayTransport, countDayEntertain, countDayLain, pricePenginapan, priceTransport, 
  priceEntertain, priceLain, totalTiket, totalPenginapan, totalTransport, totalEntertain, totalLain, JumlahTiket, JumlahHotel, 
  JumlahTransport, JumlahEntertain, JumlahLain,
  GrandTotal, uraianLPD, advancedCash, Kekurangan, insertDt) async {

    bool kosongSatu = true;
    if(memberOne != '-'){
      kosongSatu = false;
    } else if (memberOne == '-'){
      kosongSatu = true;
    }
    
    bool kosongDua = true;
    if(memberTwo != '-'){
      kosongDua = false;
    } else if (memberTwo == '-'){
      kosongDua = true;
    }

    bool kosongTiga = true;
    if(memberThree != '-'){
      kosongTiga = false;
    } else if (memberThree == '-'){
      kosongTiga = true;
    }

    bool kosongEmpat = true;
    if(memberFour != '-'){
      kosongEmpat = false;
    } else if (memberThree == '-'){
      memberFour = true;
    }

    bool kosongLima = true;
    bool kosongEnam = true;
    bool kosongTujuh = true;
    bool kosongDelapan = true;
    // Generate PDF
    final Uint8List pdfBytes = await generatePDFLPD(companyName, companyAddress, namaKaryawan, departemen, spvName, memberOne, memberTwo, 
  memberThree, memberFour, lpdID, projectName, strtDate, endedDate, countDayTiket, priceTiket,
  countDayPenginapan, countDayTransport, countDayEntertain, countDayLain, pricePenginapan, priceTransport, 
  priceEntertain, priceLain, totalTiket, totalPenginapan, totalTransport, totalEntertain, totalLain, JumlahTiket, JumlahHotel, 
  JumlahTransport, JumlahEntertain, JumlahLain, GrandTotal, uraianLPD, advancedCash, Kekurangan, insertDt, kosongSatu, kosongDua, kosongTiga, 
  kosongEmpat, kosongLima, kosongEnam, kosongTujuh, kosongDelapan);

    // Convert Uint8List to Blob
    final html.Blob blob = html.Blob([pdfBytes]);

    // Create a data URL
    final String url = html.Url.createObjectUrlFromBlob(blob);

    // Create a download link
    final html.AnchorElement anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'LaporanPerjalanDinas-$lpdID.pdf'
      ..click();

    // Clean up
    html.Url.revokeObjectUrl(url);
  }

Future<Uint8List> generatePDFPinjamanKaryawan(companyName, companyAddress, employee_name, position, loan_amount, loan_reason, loan_topay, spv_name, spv_dt, hr_name, hr_dt, insert_dt) async {
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
                      buildHeader(company_name: companyName, company_address: companyAddress, logoImage: pw.MemoryImage(
                        base64Decode('iVBORw0KGgoAAAANSUhEUgAAAEYAAABGCAYAAABxLuKEAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAABJ4SURBVHgB3Vx5kBzVef+97p57dmb20r2rAQksIywJsEGUjVkOUUAIR8CJ4yJBcsUVOzYxSv4ITspRVHE5qVQqkFQupxwjh1AxJsjiSqBskEBgsBBoAd1IaHZXi7Q6dmdn5+yZ7pffez0rdrUraY+ZBeVTzc5MH6/7fe87ft/v65HADEoymVwBx1nhQiwXEElArhjeddqhKUikIURaQnYakO/ANDtTqVQnZkgE6ihURAKuu1pKcUdVCQlMT9K85S0C7lNU1BYqKoU6SV0UQ4V0SEeuozI6UFcRm6ikH6d6ejahxlJTxSTb2lZLiHUY6xr1lpSAXE8FbUCNpCaK8SzEfQQzr5DTpWYKmpZiqJAkXeaR+rvM5EQCGwzTWD+dGGRiipJsT35buu5P+HEJPmHC1V4BKVc3xmN96UxmSpls0hajMo3ruuuExAM4D4TW83B3T/daTFImpRjtOhX3ZzxrBc4nkegUlnHXZFxrworx4om7GR9/gJ2qpIRpXDdR5UxIMf8PlDIsE1aOca4DZkQpYuQ7/zCA1Un0XNScznXgORWjY0qdLYWgEFIIrRNpOEwoqKfoOKnLlbPIWRXT3t7+UP0DrTITCZ9pY9U1c+Giwi1Gfas4zsl13HVnO+SMilHwvp4pWeiLs24WrLXhYPmSOO65IwJDGqeOEKif6fD6DyTb2884v3EBno4rEsqFgqiX8M6CUReNERuxEPD5KyQWNPVi136BoM9GIGyiUBJAfd1qZWNT4+Npyuk7rPGOVmYmpk8RnF2kgE/Y+LUvDGHpohJM14V9XOIP7zGQLfnx5EsOTg6EMYEwOB1JeCUNrjt9xxiLUS7E5fwL1FmUK9lUwDsHTSQaQrjs4jwiEYGCDOOhxxI42ENjlT7U22QoSVrNyzSa1MiNY5ajShvUXdR0pVFmdDEQoy81Ns9BxdeEhQvCKBUdkndCx54ZuRePGRgloyymai2rMQOik47hwnQM/MaqIP7liQIeeyaIeCSAkBXAgcOSKhP1txdPEiw4u0YWnKOS4sK29kOYIXTrJWkXfr+JgFVGpmDxm2TQK6M1EcKxAad6zIxJqqun+4LhL6dcidZyJ2YQ8svq5W0bGMoLBMwKEqEywZ2BvoESMHPWMiwqGXcMfzE+ulHjPnxM0t7mw3MbP4fXNn8Of3x/El6ynGG1qCtqntoTrRivdpB3ouYiRvjqmaHsyisbsXihD1Fmpa98uYVpvIxzi6wDOJYdw6WCZzGO04EaC/tB8PtcMn1hWKYKpGe2gNfeGMTOAyVkcwH86NETqIgzE4uqpmpqEpjVymOImmsubPeoN60Y3vYdqLGYooK/+ssL8cwTl2DddxYxsJbHr5q57L0fVvCttbvwi639+OcfpGA4vnHHVMH60xcFsOnR5dj42Kdx1WejPL+2duP1wIYtRqADNRR1q6GQwIVzC+g/dhCfWcy0rIHLOJOQnlMsXGCiNTgIy7L4rXKGcU0sTIaY5fuAYh/a58s6hCKvO2rqtqkrp1ksjp2wXTGwd18OFmH/M/8zhL09clTEGXmuIRzc9HnggnknsfVNE9m8AnZjSwHlnod7CpjbOohfbLHw9Es5VEpnv48pSJBI+CkFHjowLVE3QwQi1MTp8zLA78QgrsA7uyUOHLLx5VvyEEZE+a9Ox6Nun+cZRgWzwwMY6svjogUtOHIiOMrrdAUuTY4hkZyXx+u/9OHn27I6ocuqAr1jhk9S7yambE7sr3NUN4npCNFrLOjg0wttWocBV1RhfHVmxaKLoFXE1ZcSsHByhhjtJkpJC1sl4mEbuZzEJckCb0mMWnxRPc/PbHXrtTZ6j5U8FxymKNSi8NXaaNN9i/rzdHzMlWKFIkSWYxqi9HD79Vn8we3HcfXlBZxmD3CED0Ms6m9f2Y+2ppyes+ZchAfhBOPOlUvT8BllvW3RvBxaYrQGqTIO3UzFJaEszcU912awoKGATC486hrKbkzY+Pqdg/jmb51EW7MzLa8yBJK8rpwGvcCpGQb2d5lInfCjxHSrMscocSXKVEQ8XMHX7s5gdrQE11DW42rzn92cxcrPlJnaGbB9AtGgJBWRg6ONgRZIN3M45i0r81i5ogjTkiiVTi8u1VV9OD4Uwt7uEE4OGdMKyjx1uZmIxR/ENLgXtVq9VMobu0L0fwG74CBnV5GrNnECuGVlXDC/hGjUwVVLDeSLnMTJCuY2u/jGPSXWRiX4qBgfT1Pv7fNAt7GQOlLGrEYLv70qhxtWDtElaRk+E1s7o7qMqJqdznhfvKyCl9828OrbUZQdC9MMxGnBwrFGCc+FxXjzldt8eLszi93dYZq/iVCghO9+fRDJ2YXheahDafgRAv8ijcIrFketcLV6LJObMaUN0/Dikiu81P7vG1ux+S1Lp++Qz8GXbpF4c6eLnR/4x441RbFQI1EENr0GL7ziYP1aA+/ttbH7fQufXVrBJRd85PPem0RY5jWsGa6gP0rlw4GT4U8Wqh0V7winev69t+URDEYQCJjouNzGtvcC2HOAIxiGdtGazKd2FjMsJlZdVcAfrRnQgVWlcKGyFW84k2lCIpapQvlhnCIZT/jdZZDOhElapXmOdUqBXvrhKCwTikVBC7Srewz9t7uvCfd/30XJ9leVXBuyovaEKtPUlm0m3j80hy2RBgZLMv9mCJYvhhMDIRTKceIWbjMCME2+jBD8CGnGbt+hANn3GGsrg/uCep+h34PYfbCFqJiuVX15nxN4dKNAqezXl5Yj/k5XlGJSqKmwM0Su9j+eK6Fc8cGo0GokY4RbwoJZJTz3sklrdz3vkMo5KhqPVKTFQrLIb4w7KiXJspeyVVarxLH/gxJC/iy/s++kfFaqmBLEqztV/Kl5XZCqWYw5JdLQyfOdPQKdbIUsu5BGVJb61v1GDt29ERw67MOCVm4QVAJdTzIU5+04uo/YXH1uqfjhmnmtUBcNePxFQbLcQLHkoSQF+FRj7olnqVQ3WPuWrhBpKkaQ55RJ1Fhs18ALr/nxqTlEoqysFdBTkH3ZxT78cKOL373dRCYdQ7Zoo1j28V3gg24Lm98II+CXtI4E3x2UTT+2bsvjlquJX1hDSRBEujF0HQ9j+z4PBI5bnE5HJNIW4XNXrXvF3qoa2LbTxvEbY+Rvg3jvfcaQHuDIcQd9gzZ27LNYkjA2MDDPm2shHrdgBA383WOGTstBP12xTJcyCowlfvzZPxlomxXHiovmsp4axPa9Ie4vo0aF4yiRUr4jqk9aPoIayXBjVejC0sD85gr6MzYSTSHWOMQct83HqhujOHQoh397pA9/vX4xbrxe4UuHFbnEs8/m8Cfrd+Ef/mYFliwhV9NbxjfX7kQ26/WYAqESAgR/wrSQzlaZ4RpbDPPAWks9cQ1n6rl/dHJUt+lotDtvjoErV85GkPD/wT+9iEDMh46bt+Laa6JYtaoJT/60gq/etwirbmIZQRPZ0VnEFSsacM/djE/vzUGYrdtFC6PsXNC1QuxOZpmqrRLe2Hor9u3txwsvHsO2Xw1g5+6CLi10HpHj39WkxTC2WOox9IXtC9O0nymVBQqruESvPsaUcMzGr9+cpGuUsebeNhQrDv7xX7sI7/NMJuRcrpnFDGOzbMjDdgpYuiTKz0C+UMH3vn8A//XjpTrdL17kR9kuEbeEUXHLVdAm0dwS4FjHsOwSxqpLEih8rQ1XX/cKll06i2MMYdeeMu3UwCm4ODXdpJVOLG9y6OQYHZiUeKui/lmkAy6+2MLffm8OPmDKzWRtpI91IV8Kopgni/fhca6qjZVXCPSdzOHk0QpygzmgpQEnjg7Czlmwy3ns2zkAVSxkTmbREAygv6/AusfUJYSywva2Bp7bp+OScJm5RAYtzQJtc12s/f1WvP52Hj96LIN9+10FKzEV4Vkvq3cvXQvxFC2mA5MRotVoSJJ5o7XQTSLMmsX+g3jldbZZaTFHezIolKLIEege7TmiFy8RstBfDuJoiii4X+JEpISY/yiKhWYM9Nv4vQd20/pcWgqw9qshHpehl8dpNR4JlYhm0dfVA4c4KVtgazdcxrymBPJD3N7Tg8WzgD//VoRlicB/PqkQklWNP5MxHWPTR4oxsIGh4aFJnE29cJV+J8fgmsGrb/nQ3ODD0d48C0j2oQM5HO/NoWAXUcwGcaw36/F8/BMPGzj+oUuOJoT+QAVR4hVFI9x1QxyXLu7X89ixM4Dc8QqPG4Lr5CArTXpqYaOfYw2xaxnBYKaCBbOp2KgPhZyDYx9yBQgSD/bYuOpi4qIbGvHTFwUmXQ6a2OKphEKfStMrt0zmfL0Q5SJXy9W1TyP5lvSAHz1HXMYNF3neZz7roGITy/Lz4KBEka8CtxWGiGaJSYrZst5XGqpgz0EeN8TMlCmjUiyTmiihkJF6fBVblVIjTOEFZqLDvcCJPo41BDQEsnDKrJXU9cjDPP9ykNclobI4zdav6zFpExRe4qnhBxeNETNdj0mIoanFir7h9tmKR7HRxUZ8icWg0F0kqbGMq2kZiYFBwVUOKg8ccSOiytMK7D7g8bdqXM3sqYR/Kkx4fHJT3ANz/QM2TjJLqXknIordkxr8qhIiEnYUk0Ec5KAh4t3DJGa14dSn4Q+pw6ktjDUpTFDU/BSxFOBrXlMFYdPF/JbqZMkckRFg4UjGxDI0+WSyaNzTYzDlCv3d4v6yIzVzp74nGsocywHrSmZLnmeofrY61kBLo8uqOo/ZLYLHSyy90MHSCyrw+QXmtBrw83oWxwiQm7mXxHvQ7/I4HotJRBfOPdWT2jRGMXrfZKyGSxQICoQDqoekgBcwZw7Z/pYC/Gob96nekqIig+ozX+99EIEvzAkzUFt+EzsPBjlhA9FYBfffW0KQeCUY4DmkN/18BcNSW8CDawbxndUmWqIVPc6sJhLozER+XrdtHpVNCjjI6wdCJksFi9cAtu9vIdVpQk5QNafPfZRiqLENE7cawQmbvHmuPAu5MINqmJP44uUmV8vQkwpQCYpCCPEzs68uHm2jmRgmQjRs4dV3LWz6VSsyQwEMMBj/8Jkm7DjQROuNo6cvhl7WQxmb1IQIYF5rgaCPBBcVsH1PA37+ejMVr1ypgsZYQG8Phv2steLc7sPln6JF+coTS9qetWwYuWlMyGY/aA0J8s04p1pY6FEZIbaLduy2cNkySwfCy5aUkB4MIBIlQ1fyYygbwC93GjjQHUORvv/dh33oz0WYBElJEBQ+/ZLDV0w/GaMIqjfe9cY3GHE3bm7UvJ3PqpD7DaBtjoMVSxy8/2EYRbuMaMSv7WH+XB+VxqKCVXeR8SYYsbAwksGi9lms0XBOfxrPU8Z0z9OZdKoxnujAuZ6V4Y1/6SYLMcaGfV2Nnis1F3mzMXQfDdFtEvjJM368uQcsJqN4v8fQbZO8IuCkXyvFI4HZSGOaVTFy5KOsrqg20hQtQXI7k2c2OmZh+y6S5OxqpvOSQDJK/BSHRdNZQE5ZxZVgoAEXtpd13HlrTxxdvTj7NIANqZ6uMYoZP8mbYg2j645zlQl+EeRqkkkz8nh3fwxHj0fx38+7OMQqumKUNW9Cz/e6jcNtZulRkrpzyQwjq9sNd2Q8qGYZYeiM4+rsNWLhOURmyMLPXgI2bS4hTJe58Qut+M1bbdx0RZGXUOMHqVxZLWjPpBWRpmmOG1fHfd5CPffaGG9U7b6bcQZR/ea7rzc06t1Cxv6J5y1s3V7RsUMz//JcOaE2FbHqFJQdgT0pif99pYRMMcEywUQ0HMbTmyWOnRRnOdf4Rqqb2XjcfWeR5IL2h7mo3x5/1ArW3OnHq9tc7DtCDbt1IBgnLMNkh2eJCirMZts31WdonDQeluHmv+8+3P3AmUc8i6ini6TLQCzlmN8TqBsweUGHPR/lEgqOA3V4kGeyotyH1mxI0+uKynGcQojOru6uy842zFlhoS4VDHHXeClc0w2qyHetaiz5BChFiYpNRN+64T8e6uVc9JzOIRP/IZdnOUmcz+IpZUI/5JrcT//OZ+VMQilKJlxhqQHVwMo/cb4J73kySlEyqd9dqzQ+ODj4g8ZYXEHSlTgPRGUfwzTWUCdHJ3PelMFEsi25mpnpoalyxXUXgjfhyPWp3u6HMQWZ8i/1WTp0NjY2Pk6c0Ah8sn6HrUg3YYpbCPWfxxSlJvCzaj3rPvbArAIsi2DNLU13KNRQPjYFKYWwQj6dOpjWkKiDUEF3MuzdJ+vy+4SPRPPUSiE1sJCxY9dR9I83HNWvkndI9fT5dAO1Cqjsgel2DzsbCpmjTlJXxZwu3lPoVJDrJjm55bx6QnrKSp52aAr65oiZpOxizdE50/951/8BTz7b6PFW7yAAAAAASUVORK5CYII='),
                      ))
                    ]
                  )
                ]
              ),
              pw.Divider(thickness: 1.0, color: PdfColor.fromHex('#333333')),
              pw.SizedBox(height: 20),
              pw.Expanded(
                child: pw.Padding(
                  padding: const pw.EdgeInsets.only(),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Center(
                        child: pw.Text(
                          'FORM PERMOHONAN PEMINJAMAN KARYAWAN',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 18.0,
                            color: PdfColor.fromHex('#333333'), // Replace with your desired color
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.SizedBox(height: 40),
                      pw.Container(
                        margin: const pw.EdgeInsets.only(left: 20.0, right: 20.0),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              '       Nama                                  : $employee_name',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                color: PdfColor.fromHex('#555555'), // Replace with your desired color
                              ),
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.SizedBox(height: 8),
                            pw.Text(
                              '       Jabatan                               : $position',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                color: PdfColor.fromHex('#555555'), // Replace with your desired color
                              ),
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.SizedBox(height: 8),
                            pw.Text(
                              '       Besar Pinjaman                  : $loan_amount',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                color: PdfColor.fromHex('#555555'), // Replace with your desired color
                              ),
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.SizedBox(height: 8),
                            pw.Text(
                              '       Keperluan Pinjaman           : $loan_reason',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                color: PdfColor.fromHex('#555555'), // Replace with your desired color
                              ),
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.SizedBox(height: 8),
                            pw.Text(
                              '       Cara Membayar                 : $loan_topay',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                color: PdfColor.fromHex('#555555'), // Replace with your desired color
                              ),
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text('Menyetujui,'),
                                    pw.SizedBox(height: 90),
                                    pw.Text('(______________________)')
                                  ]
                                )
                              ]
                            )
                          ]
                        )
                      )
                    ]
                  )
                )
              ),
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 20.0),
                child: pw.Text('Dibuat oleh      : $employee_name ($insert_dt)', style: pw.TextStyle(fontSize: 12.0,color: PdfColor.fromHex('#555555'),)),
              ),
              pw.SizedBox(height: 12),
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 20.0),
                child: pw.Text('Mengetahui     : $spv_name ($spv_dt)', style: pw.TextStyle(fontSize: 12.0,color: PdfColor.fromHex('#555555'),)),
              ),
              pw.SizedBox(height: 12),
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 20.0),
                child: pw.Text('Mengetahui     : $hr_name ($hr_dt)', style: pw.TextStyle(fontSize: 12.0,color: PdfColor.fromHex('#555555'),)),
              ),
              pw.SizedBox(height: 12),
              pw.Divider(thickness: 1.0, color: PdfColor.fromHex('#333333')),
              pw.Footer(
                title: pw.Text('Dokumen ini dibuat secara otomatis oleh sistem dan tidak membutuhkan tanda tangan', style: pw.TextStyle(fontSize: 8.0,color: PdfColor.fromHex('#555555'),)),
              )
            ]
        );
      }
    )
  );
        

  return pdf.save();
}

Future<void> generateAndDisplayPDFPinjamanKaryawan(companyName, companyAddress, loanId, employee_name, position, loan_amount, loan_reason, loan_topay, spv_name, spv_dt, hr_name, hr_dt, insert_dt) async {
 
    // Generate PDF
    final Uint8List pdfBytes = await generatePDFPinjamanKaryawan(companyName, companyAddress, employee_name, position, loan_amount, loan_reason, loan_topay, spv_name, spv_dt, hr_name, hr_dt, insert_dt);

    // Convert Uint8List to Blob
    final html.Blob blob = html.Blob([pdfBytes]);

    // Create a data URL
    final String url = html.Url.createObjectUrlFromBlob(blob);

    // Create a download link
    final html.AnchorElement anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'PinjamanKaryawan-$loanId.pdf'
      ..click();

    // Clean up
    html.Url.revokeObjectUrl(url);
  }