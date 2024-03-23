// ignore_for_file: non_constant_identifier_names, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, avoid_web_libraries_in_flutter, file_names, avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_systems_web/web-version/full-access/Event/event.dart';
import 'package:hr_systems_web/web-version/full-access/Performance/performance.dart';
import 'package:hr_systems_web/web-version/full-access/Report/report.dart';
import 'package:hr_systems_web/web-version/full-access/Salary/salary.dart';
import 'package:hr_systems_web/web-version/full-access/Settings/setting.dart';
import 'package:hr_systems_web/web-version/full-access/Structure/structure.dart';
import 'package:hr_systems_web/web-version/full-access/Training/traning.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import '../../login.dart';
import '../employee.dart';
import '../index.dart';

class ViewOnlyPermission extends StatefulWidget {
  final String permission_id;
  const ViewOnlyPermission({super.key, required this.permission_id});

  @override
  State<ViewOnlyPermission> createState() => _ViewOnlyPermissionState();
}

class _ViewOnlyPermissionState extends State<ViewOnlyPermission> {
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String employeeId = '';
  String departmentName = '';
  String positionName = '';
  String permissionTypeName = '';
  String suratDokter = '';
  String NamaYangMengajukanIzin = '';
  String NIKYangMengajukanIzin = '';
  String DeptYangMengajukanIzin = '';
  String JabatanYangMengajukanIzin = '';
  String tanggalIzin = '';

  String startCuti = '';
  String endCuti = '';
  String cutiPhone = '';
  String karyawanPengganti = '';
  String alasanIzin = '';
  String jamIzin = '';
  String createdBy = '';
  String createdDt = '';
  String updatedBy = '';
  String updatedDt = '';
  String imageUrl = '';
  String trimmedCompanyAddress = '';
  late Future<Map<String, dynamic>> permissionData;
  late Future<List<Map<String, dynamic>>> logPermissionData;
  late http.Response fileResponse;

  String tanggalLembur = '';
  String jamMulaiLembur = '';
  String jamAkhirLembur = '';
  String keteranganLembur = '';

  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    fetchData();
    permissionData = fetchDetailPermission();
    logPermissionData = fetchLogPermissionData();
    getSuratDokter();
  }

  Future<void> getSuratDokter() async {
    try {
      var id = '${widget.permission_id}';
      String imageUrl =
          'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/getsuratdokter.php?permission_id=$id';
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        List<dynamic> dataList = json.decode(response.body);
        Map<String, dynamic> data = dataList[0];

        // Extract the "attachment" value
        setState(() {
          suratDokter = data['attachment'];
        });
      } else {
        // Handle error
        print('Failed to load image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error fetching image: $e');
    }
  }

  Future<void> fetchData() async {
    try {
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/account/getprofileforallpage.php';

      String employeeId = storage.read('employee_id').toString(); // replace with your logic to get employee ID

      // Create a Map for the request body
      Map<String, dynamic> requestBody = {'employee_id': employeeId};

      // Convert the Map to a JSON string
      String requestBodyJson = json.encode(requestBody);

      // Make the API call with a POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'employee_id': employeeId,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        // Ensure that the fields are of the correct type
        setState(() {
          companyName = data['company_name'] as String;
          companyAddress = data['company_address'] as String;
          employeeName = data['employee_name'] as String;
          employeeEmail = data['employee_email'] as String;       
          trimmedCompanyAddress = companyAddress.substring(0, 15);
          // imageUrl = data['company_logo'] as String;
          // print(imageUrl);
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    }
  }

  Future<Map<String, dynamic>> fetchDetailPermission() async {
    var id = '${widget.permission_id}';


    final response = await http.get(
      Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/getdetailpermission.php?permission_id=$id'),
    );

    if (response.statusCode == 200) {
      print(response.statusCode);
      setState(() {});
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Map<String, dynamic>>> fetchLogPermissionData() async {
    var id = '${widget.permission_id}';

    final response = await http.get(
      Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/getlogpermissiontable.php?permission_id=$id'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        return List<Map<String, dynamic>>.from(data['Data']);
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Uint8List> generatePDF() async{
    final pdf = pw.Document();
    final completer = Completer<Uint8List>();
    var id = '${widget.permission_id}';
    String jenisIzin = '';
    String bodyIzin = '';

    if (permissionTypeName == 'Izin pulang awal') {
      jenisIzin = 'Tidak Melakukan Rekam Kepulangan';
      bodyIzin = 'Saya tidak melakukan rekam kepulangan sesuai jam kantor (17.30 WIB) dikarenakan ';
    } else if (permissionTypeName == 'Izin datang telat') {
      jenisIzin = 'Tidak Melakukan Rekam Kedatangan';
      bodyIzin = 'Saya tidak melakukan rekam kehadiran sesuai jam kantor (08.30 WIB) dikarenakan ';
    }

  pdf.addPage(
    pw.Page(
      margin: const pw.EdgeInsets.all(10),
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        if (permissionTypeName == 'Izin pulang awal' || permissionTypeName == 'Izin datang telat'){
          final image = pw.MemoryImage(
            base64Decode('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'),
          );
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
                      // Image.asset(
                      //       'images/kinglab.png',
                      pw.Image(image),
                      pw.SizedBox(width: 30.sp),
                      pw.Column(
                        children: [
                          pw.Text(companyName, style: 
                            pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 18.0,
                              color: PdfColor.fromHex('#333333'), // Replace with your desired color
                            ),
                          ),
                          pw.SizedBox(height: 5.sp),
                          pw.Text(companyAddress, style: pw.TextStyle(fontSize: 12.0,color: PdfColor.fromHex('#555555'),),),
                          pw.SizedBox(height: 8.sp),
                        ]
                      )
                    ]

                  )
                ]
              ),
              pw.Divider(thickness: 1.0, color: PdfColor.fromHex('#333333')),
              pw.SizedBox(height: 8.sp),
              pw.Expanded(
                child: pw.Padding(
                padding: const pw.EdgeInsets.only(),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Center(
                      child: pw.Text(
                        'SURAT PERMOHONAN IZIN / PEMBERITAHUAN',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 18.0,
                          color: PdfColor.fromHex('#333333'), // Replace with your desired color
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.SizedBox(height: 10.sp),
                    pw.Center(
                      child: pw.Text(
                        '($jenisIzin)',
                        style: pw.TextStyle(
                          fontSize: 16.0,
                          color: PdfColor.fromHex('#555555'), // Replace with your desired color
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.SizedBox(height: 50.h), // Adjust the height as needed
                    pw.Container(
                      margin: const pw.EdgeInsets.only(left: 20.0),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Yang bertanda tangan di bawah ini : ',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 14.0,
                              color: PdfColor.fromHex('#333333'), // Replace with your desired color
                            ),
                            textAlign: pw.TextAlign.left,
                          ),
                          pw.SizedBox(height: 12.h),
                          pw.Text(
                            '       Nama              : $NamaYangMengajukanIzin',
                            style: pw.TextStyle(
                              fontSize: 12.0,
                              color: PdfColor.fromHex('#555555'), // Replace with your desired color
                            ),
                            textAlign: pw.TextAlign.left,
                          ),
                          pw.SizedBox(height: 8.h),
                          pw.Text(
                            '       NIK                  : $NIKYangMengajukanIzin',
                            style: pw.TextStyle(
                              fontSize: 12.0,
                              color: PdfColor.fromHex('#555555'), // Replace with your desired color
                            ),
                            textAlign: pw.TextAlign.left,
                          ),
                          pw.SizedBox(height: 8.h),
                          pw.Text(
                            '       Departemen    : $DeptYangMengajukanIzin',
                            style: pw.TextStyle(
                              fontSize: 12.0,
                              color: PdfColor.fromHex('#555555'), // Replace with your desired color
                            ),
                            textAlign: pw.TextAlign.left,
                          ),
                          pw.SizedBox(height: 8.h),
                          pw.Text(
                            '       Jabatan           : $JabatanYangMengajukanIzin',
                            style: pw.TextStyle(
                              fontSize: 12.0,
                              color: PdfColor.fromHex('#555555'), // Replace with your desired color
                            ),
                            textAlign: pw.TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 30.h),
                    pw.Container(
                      margin: const pw.EdgeInsets.only(left: 20.0),
                      child: pw.Text('Dengan ini menerangkan bahwa pada hari $tanggalIzin', style: pw.TextStyle(fontSize: 12.0,color: PdfColor.fromHex('#555555'),),),
                    ),
                    pw.SizedBox(height: 12.h),
                    pw.Container(
                      margin: const pw.EdgeInsets.only(left: 20.0),
                      child: pw.Text('$bodyIzin ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold ,fontSize: 12.0,color: PdfColor.fromHex('#555555'),),),
                    ),
                    pw.SizedBox(height: 12.h),
                    pw.Container(
                      margin: const pw.EdgeInsets.only(left: 20.0),
                      child: pw.Text('1. Datang Terlambat karena keperluan $alasanIzin', style: pw.TextStyle(fontSize: 12.0,color: PdfColor.fromHex('#555555'),)),
                    ),
                    pw.SizedBox(height: 12.h),
                    pw.Container(
                      margin: const pw.EdgeInsets.only(left: 20.0),
                      child: pw.Text('2. Absen masuk pada Jam $jamIzin WIB', style: pw.TextStyle(fontSize: 12.0,color: PdfColor.fromHex('#555555'),)),
                    ),
                    pw.SizedBox(height: 25.h),
                  ],
                ),
              ),
              ),
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 20.0),
                child: pw.Text('Dibuat oleh     : $createdBy ($createdDt)', style: pw.TextStyle(fontSize: 12.0,color: PdfColor.fromHex('#555555'),)),
              ),
              pw.SizedBox(height: 12.h),
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 20.0),
                child:  pw.Text('Disetujui oleh : $updatedBy ($updatedDt)', style: pw.TextStyle(fontSize: 12.0,color: PdfColor.fromHex('#555555'),)),
              ),
              pw.SizedBox(height: 20.h),
              pw.Divider(thickness: 1.0, color: PdfColor.fromHex('#333333')),
              pw.Footer(
                title: pw.Text('Dokumen ini dibuat secara otomatis oleh sistem dan tidak membutuhkan tanda tangan', style: pw.TextStyle(fontSize: 8.0,color: PdfColor.fromHex('#555555'),)),
              )
            ],
          );
        } else  if (permissionTypeName == 'Cuti tahunan'){
          final image = pw.MemoryImage(
            base64Decode('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'),
          );
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
                      // Image.asset(
                      //       'images/kinglab.png',
                      pw.Image(image),
                      pw.SizedBox(width: 30.sp),
                      pw.Column(
                        children: [
                          pw.Text(companyName, style: 
                            pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 18.0,
                              color: PdfColor.fromHex('#333333'), // Replace with your desired color
                            ),
                          ),
                          pw.SizedBox(height: 5.sp),
                          pw.Text(companyAddress, style: pw.TextStyle(fontSize: 12.0,color: PdfColor.fromHex('#555555'),),),
                          pw.SizedBox(height: 8.sp),
                        ]
                      )
                    ]

                  )
                ]
              ),
              pw.Divider(thickness: 1.0, color: PdfColor.fromHex('#333333')),
              pw.SizedBox(height: 8.sp),
              pw.Expanded(
                child: pw.Padding(
                padding: const pw.EdgeInsets.only(),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Center(
                      child: pw.Text(
                        'FORMULIR PERMOHONAN CUTI KARYAWAN',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 18.0,
                          color: PdfColor.fromHex('#333333'), // Replace with your desired color
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.SizedBox(height: 30.sp),
                    pw.Container(
                      margin: const pw.EdgeInsets.only(left: 20.0),
                      child: pw.Text('DATA KARYAWAN')
                    ),
                    pw.SizedBox(height: 12.h), 
                    pw.Text(
                      '       Nama Lengkap             : $NamaYangMengajukanIzin',
                      style: pw.TextStyle(
                        fontSize: 12.0,
                        color: PdfColor.fromHex('#555555'), // Replace with your desired color
                      ),
                      textAlign: pw.TextAlign.left,
                    ),
                    pw.SizedBox(height: 12.h),
                    pw.Text(
                      '       Divisi / Jabatan             : $DeptYangMengajukanIzin / $JabatanYangMengajukanIzin',
                      style: pw.TextStyle(
                        fontSize: 12.0,
                        color: PdfColor.fromHex('#555555'), // Replace with your desired color
                      ),
                      textAlign: pw.TextAlign.left,
                    ),
                    pw.SizedBox(height: 30.h),
                    pw.Container(
                      margin: const pw.EdgeInsets.only(left: 20.0),
                      child: pw.Text('KETERANGAN CUTI')
                    ),
                    pw.SizedBox(height: 12.h),
                    pw.Text(
                      '       Lama cuti                      : $startCuti s/d $endCuti',
                      style: pw.TextStyle(
                        fontSize: 12.0,
                        color: PdfColor.fromHex('#555555'), // Replace with your desired color
                      ),
                      textAlign: pw.TextAlign.left,
                    ),
                    pw.SizedBox(height: 12.h),
                    pw.Text(
                      '       No telepon                    : $cutiPhone',
                      style: pw.TextStyle(
                        fontSize: 12.0,
                        color: PdfColor.fromHex('#555555'), // Replace with your desired color
                      ),
                      textAlign: pw.TextAlign.left,
                    ),
                    pw.SizedBox(height: 12.h),
                    pw.Text(
                      '       Keterangan/Alasan      : $alasanIzin',
                      style: pw.TextStyle(
                        fontSize: 12.0,
                        color: PdfColor.fromHex('#555555'), // Replace with your desired color
                      ),
                      textAlign: pw.TextAlign.left,
                    ),
                    pw.SizedBox(height: 30.h),
                    pw.Container(
                      margin: const pw.EdgeInsets.only(left: 20.0),
                      child: pw.Text('SELAMA CUTI DIGANTIKAN OLEH')
                    ),
                    pw.SizedBox(height: 12.h),
                    pw.Text(
                      '       Nama Lengkap           : $karyawanPengganti',
                      style: pw.TextStyle(
                        fontSize: 12.0,
                        color: PdfColor.fromHex('#555555'), // Replace with your desired color
                      ),
                      textAlign: pw.TextAlign.left,
                    ),
                  ],
                ),
              ),
              ),
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 20.0),
                child: pw.Text('Dibuat oleh     : $createdBy ($createdDt)', style: pw.TextStyle(fontSize: 12.0,color: PdfColor.fromHex('#555555'),)),
              ),
              pw.SizedBox(height: 12.h),
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 20.0),
                child:  pw.Text('Disetujui oleh : $updatedBy ($updatedDt)', style: pw.TextStyle(fontSize: 12.0,color: PdfColor.fromHex('#555555'),)),
              ),
              pw.SizedBox(height: 20.h),
              pw.Divider(thickness: 1.0, color: PdfColor.fromHex('#333333')),
              pw.Footer(
                title: pw.Text('Dokumen ini dibuat secara otomatis oleh sistem dan tidak membutuhkan tanda tangan', style: pw.TextStyle(fontSize: 8.0,color: PdfColor.fromHex('#555555'),)),
              )
            ]
          );
        } else if (permissionTypeName == 'Lembur'){
          final image = pw.MemoryImage(
            base64Decode('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'),
          );
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
                      // Image.asset(
                      //       'images/kinglab.png',
                      pw.Image(image),
                      pw.SizedBox(width: 30.sp),
                      pw.Column(
                        children: [
                          pw.Text(companyName, style: 
                            pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 18.0,
                              color: PdfColor.fromHex('#333333'), // Replace with your desired color
                            ),
                          ),
                          pw.SizedBox(height: 5.sp),
                          pw.Text(companyAddress, style: pw.TextStyle(fontSize: 12.0,color: PdfColor.fromHex('#555555'),),),
                          pw.SizedBox(height: 8.sp),
                        ]
                      )
                    ]

                  )
                ]
              ),
              pw.Divider(thickness: 1.0, color: PdfColor.fromHex('#333333')),
              pw.SizedBox(height: 8.sp),
              pw.Expanded(
                child: pw.Padding(
                padding: const pw.EdgeInsets.only(),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Center(
                      child: pw.Text(
                        'FORMULIR LEMBUR KERJA',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 18.0,
                          color: PdfColor.fromHex('#333333'), // Replace with your desired color
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.SizedBox(height: 30.sp),
                    pw.Container(
                      margin: const pw.EdgeInsets.only(left: 20.0),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Yang bertanda tangan di bawah ini : ',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 14.0,
                              color: PdfColor.fromHex('#333333'), // Replace with your desired color
                            ),
                            textAlign: pw.TextAlign.left,
                          ),
                          pw.SizedBox(height: 12.h),
                          pw.Text(
                            '       Nama              : $NamaYangMengajukanIzin',
                            style: pw.TextStyle(
                              fontSize: 12.0,
                              color: PdfColor.fromHex('#555555'), // Replace with your desired color
                            ),
                            textAlign: pw.TextAlign.left,
                          ),
                          pw.SizedBox(height: 8.h),
                          pw.Text(
                            '       NIK                  : $NIKYangMengajukanIzin',
                            style: pw.TextStyle(
                              fontSize: 12.0,
                              color: PdfColor.fromHex('#555555'), // Replace with your desired color
                            ),
                            textAlign: pw.TextAlign.left,
                          ),
                          pw.SizedBox(height: 8.h),
                          pw.Text(
                            '       Departemen    : $DeptYangMengajukanIzin',
                            style: pw.TextStyle(
                              fontSize: 12.0,
                              color: PdfColor.fromHex('#555555'), // Replace with your desired color
                            ),
                            textAlign: pw.TextAlign.left,
                          ),
                          pw.SizedBox(height: 8.h),
                          pw.Text(
                            '       Jabatan           : $JabatanYangMengajukanIzin',
                            style: pw.TextStyle(
                              fontSize: 12.0,
                              color: PdfColor.fromHex('#555555'), // Replace with your desired color
                            ),
                            textAlign: pw.TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 10.h),
                    pw.Container(
                      margin: const pw.EdgeInsets.only(left: 20.0),
                      child: pw.Text('Dengan ini menerangkan bahwa pada hari $tanggalLembur dilaksanakan pekerjaan diluar jam kantor (Lembur) dari Pukul $jamMulaiLembur sampai pukul $jamAkhirLembur dengan keperluan $keteranganLembur', style: pw.TextStyle(fontSize: 12.0,color: PdfColor.fromHex('#555555'),),),
                    ),
                  ],
                ),
              ),
              ),
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 20.0),
                child: pw.Text('Dibuat oleh     : $createdBy ($createdDt)', style: pw.TextStyle(fontSize: 12.0,color: PdfColor.fromHex('#555555'),)),
              ),
              pw.SizedBox(height: 12.h),
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 20.0),
                child:  pw.Text('Disetujui oleh : $updatedBy ($updatedDt)', style: pw.TextStyle(fontSize: 12.0,color: PdfColor.fromHex('#555555'),)),
              ),
              pw.SizedBox(height: 20.h),
              pw.Divider(thickness: 1.0, color: PdfColor.fromHex('#333333')),
              pw.Footer(
                title: pw.Text('Dokumen ini dibuat secara otomatis oleh sistem dan tidak membutuhkan tanda tangan', style: pw.TextStyle(fontSize: 8.0,color: PdfColor.fromHex('#555555'),)),
              )
            ]
          );
        } else {
          return pw.Column(
            children: [

            ]
          );
        }
      },
    ),
  );
    

  return pdf.save();
  }

  Future<void> generateAndDisplayPDF() async {
    var id = '${widget.permission_id}';
    // Generate PDF
    final Uint8List pdfBytes = await generatePDF();

    // Convert Uint8List to Blob
    final html.Blob blob = html.Blob([pdfBytes]);

    // Create a data URL
    final String url = html.Url.createObjectUrlFromBlob(blob);

    // Create a download link
    final html.AnchorElement anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = '$id-$permissionTypeName-$NamaYangMengajukanIzin.pdf'
      ..click();

    // Clean up
    html.Url.revokeObjectUrl(url);
  }

  Future<void> ApproveManager() async {
    try{
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/updatepermissionapprovemanager.php';
      String id_permission = '${widget.permission_id}';

      String employeeId = storage.read('employee_id').toString();

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'id_permission': id_permission,
          'employee_id': employeeId
        }
      );

      if(response.statusCode == 200){
        Get.to(FullIndexWeb(employeeId));
      } else {
        Get.snackbar('Error : ', '${response.body}');
        print('Response body: ${response.body}');
      }

    } catch (e) {
      print('Exception: $e');
      Get.snackbar('Error', 'An error occurred. Please try again later.');
    }

  }

  Future<void> RejectManager() async {
    var apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/updatepermissionrejectmanager.php';
    var id_permission = '${widget.permission_id}';

    try{
      String employeeId = storage.read('employee_id').toString();

      var response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'id_permission': id_permission,
          'employee_id': employeeId
        }
      );

      if(response.statusCode == 200){
        Get.to(FullIndexWeb(employeeId));
      } else {
        Get.snackbar('Error : ', '${response.body}');
      }

    } catch (e) {
      print('Exception: $e');
      Get.snackbar('Error', '$e');
    }

  }

  Future<void> RejectHRD() async {
    var apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/updatepermissionrejectHRD.php';
    var id_permission = '${widget.permission_id}';

    try{
      String employeeId = storage.read('employee_id').toString();

      var response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'id_permission': id_permission,
          'employee_id': employeeId
        }
      );

      if(response.statusCode == 200){
        Get.to(FullIndexWeb(employeeId));
      } else {
        Get.snackbar('Error : ', '${response.body}');
      }

    } catch (e) {
      print('Exception: $e');
      Get.snackbar('Error', '$e');
    }

  }

  Future<void> ApproveHRD() async {
    try{
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/updatepermissionapproveHRD.php';
      String id_permission = '${widget.permission_id}';

      String employeeId = storage.read('employee_id').toString();

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'id_permission': id_permission,
          'employee_id': employeeId
        }
      );

      if(response.statusCode == 200){
        Get.to(FullIndexWeb(employeeId));
      } else {
        Get.snackbar('Error : ', '${response.body}');
        print('Response body: ${response.body}');
      }

    } catch (e) {
      print('Exception: $e');
      Get.snackbar('Error', 'An error occurred. Please try again later.');
    }

  }

  Future<void> _downloadFile() async {
  var id = '${widget.permission_id}';

  String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/getattachment.php?permission_id=$id';
  try {
    // Make a GET request to your API to download the file
    http.Response fileResponse = await http.get(Uri.parse(apiUrl));

    if (fileResponse.statusCode == 200) {
      // Convert the response body to a Uint8List
      final Uint8List bytes = fileResponse.bodyBytes;

      // Create a Blob from the Uint8List
      final html.Blob blob = html.Blob([bytes]);

      // Create a download link
      final html.AnchorElement anchor = html.AnchorElement(href: html.Url.createObjectUrlFromBlob(blob))
        ..target = 'blank'
        ..download = 'file.pdf';

      // Trigger a click on the link to start the download
      anchor.click();
    } else {
      // Handle API error
      print('Error downloading file: ${fileResponse.statusCode}');
    }
  } catch (e) {
    // Handle general error
    print('Error: $e');
  }
}



  @override
  Widget build(BuildContext context) {
    // Access the GetStorage instance
    final storage = GetStorage();

    // Retrieve the stored employee_id
    var employeeId = storage.read('employee_id');
    var positionId = storage.read('position_id');
    var photo = storage.read('photo');

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Side Menu
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15.sp,),
                      //company logo and name
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 0, right: 0),
                        dense: true,
                        horizontalTitleGap: 0.0, // Adjust this value as needed
                        leading: Container(
                          margin: const EdgeInsets.only(right: 2.0), // Add margin to the right of the image
                          child: Image.asset(
                            'images/kinglab.png',
                            width: MediaQuery.of(context).size.width * 0.08,
                          ),
                        ),
                        title: Text(
                          "$companyName",
                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w300),
                        ),
                        subtitle: Text(
                          '$trimmedCompanyAddress',
                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w300),
                        ),
                      ),
                      SizedBox(height: 30.sp,),
                      //halaman utama title
                      Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: Text("Halaman utama", 
                            style: TextStyle( fontSize: 20.sp, fontWeight: FontWeight.w600,)
                          ),
                      ),
                      SizedBox(height: 10.sp,),
                      //beranda button
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: ElevatedButton(
                          onPressed: () {Get.to(FullIndexWeb(employeeId));},
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            alignment: Alignment.centerLeft,
                            minimumSize: Size(60.w, 55.h),
                            foregroundColor: const Color(0xFFFFFFFF),
                            backgroundColor: const Color(0xff4ec3fc),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Image.asset('images/home-active.png')
                              ),
                              SizedBox(width: 2.w),
                              Text('Beranda',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,)
                              )
                            ],
                          )
                        ),
                      ),
                      SizedBox(height: 10.sp,),
                      //karyawan button
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: ElevatedButton(
                          onPressed: () {Get.to(EmployeePage(employee_id: employeeId,));},
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            alignment: Alignment.centerLeft,
                            minimumSize: Size(60.w, 55.h),
                            foregroundColor: const Color(0xDDDDDDDD),
                            backgroundColor: const Color(0xFFFFFFFF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Image.asset('images/employee-inactive.png')
                              ),
                              SizedBox(width: 2.w),
                              Text('Karyawan',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,)
                              )
                            ],
                          )
                        ),
                      ),
                      SizedBox(height: 10.sp,),
                      //gaji button
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(const SalaryIndex());
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            alignment: Alignment.centerLeft,
                            minimumSize: Size(60.w, 55.h),
                            foregroundColor: const Color(0xDDDDDDDD),
                            backgroundColor: const Color(0xFFFFFFFF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Image.asset('images/gaji-inactive.png')
                              ),
                              SizedBox(width: 2.w),
                              Text('Gaji',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,)
                              )
                            ],
                          )
                        ),
                      ),
                      SizedBox(height: 10.sp,),
                      //performa button
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(PerformanceIndex);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            alignment: Alignment.centerLeft,
                            minimumSize: Size(60.w, 55.h),
                            foregroundColor: const Color(0xDDDDDDDD),
                            backgroundColor: const Color(0xFFFFFFFF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Image.asset('images/performa-inactive.png')
                              ),
                              SizedBox(width: 2.w),
                              Text('Performa',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,)
                              )
                            ],
                          )
                        ),
                      ),
                      SizedBox(height: 10.sp,),
                      //pelatihan button
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(const TrainingIndex());
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            alignment: Alignment.centerLeft,
                            minimumSize: Size(60.w, 55.h),
                            foregroundColor: const Color(0xDDDDDDDD),
                            backgroundColor: const Color(0xFFFFFFFF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Image.asset('images/pelatihan-inactive.png')
                              ),
                              SizedBox(width: 2.w),
                              Text('Pelatihan',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,)
                              )
                            ],
                          )
                        ),
                      ),
                      SizedBox(height: 10.sp,),
                      //acara button
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(const EventIndex());
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            alignment: Alignment.centerLeft,
                            minimumSize: Size(60.w, 55.h),
                            foregroundColor: const Color(0xDDDDDDDD),
                            backgroundColor: const Color(0xFFFFFFFF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Image.asset('images/acara-inactive.png')
                              ),
                              SizedBox(width: 2.w),
                              Text('Acara',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,)
                              )
                            ],
                          )
                        ),
                      ),
                      SizedBox(height: 10.sp,),
                      //laporan button
                      Padding(
                              padding: EdgeInsets.only(left: 5.w, right: 5.w),
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(const ReportIndex());
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  alignment: Alignment.centerLeft,
                                  minimumSize: Size(60.w, 55.h),
                                  foregroundColor: const Color(0xDDDDDDDD),
                                  backgroundColor: const Color(0xFFFFFFFF),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Image.asset('images/laporan-inactive.png')
                                    ),
                                    SizedBox(width: 2.w),
                                    Text('Laporan',
                                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,)
                                    )
                                  ],
                                )
                              ),
                            ),
                      SizedBox(height: 30.sp,),
                      //pengaturan title
                      Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: Text("Pengaturan", 
                            style: TextStyle( fontSize: 20.sp, fontWeight: FontWeight.w600,)
                          ),
                      ),
                      SizedBox(height: 10.sp,),
                      //pengaturan button
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(const SettingIndex());
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            alignment: Alignment.centerLeft,
                            minimumSize: Size(60.w, 55.h),
                            foregroundColor: const Color(0xDDDDDDDD),
                            backgroundColor: const Color(0xFFFFFFFF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Image.asset('images/pengaturan-inactive.png')
                              ),
                              SizedBox(width: 2.w),
                              Text('Pengaturan',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,)
                              )
                            ],
                          )
                        ),
                      ),
                      SizedBox(height: 10.sp,),
                      //struktur button
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(const StructureIndex());
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            alignment: Alignment.centerLeft,
                            minimumSize: Size(60.w, 55.h),
                            foregroundColor: const Color(0xDDDDDDDD),
                            backgroundColor: const Color(0xFFFFFFFF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Image.asset('images/struktur-inactive.png')
                              ),
                              SizedBox(width: 2.w),
                              Text('Struktur',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,)
                              )
                            ],
                          )
                        ),
                      ),
                      SizedBox(height: 10.sp,),
                      //keluar button
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: ElevatedButton(
                          onPressed: () async {
                            //show dialog sure to exit ?
                            showDialog(
                              context: context, 
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text("Keluar"),
                                  content: const Text('Apakah anda yakin akan keluar ?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {Get.back();},
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {Get.off(const LoginPageDesktop());},
                                      child: const Text('OK',),
                                    ),
                                  ],
                                );
                              }
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            alignment: Alignment.centerLeft,
                            minimumSize: Size(60.w, 55.h),
                            foregroundColor: const Color(0xDDDDDDDD),
                            backgroundColor: const Color(0xFFFFFFFF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Image.asset('images/logout.png')
                              ),
                              SizedBox(width: 2.w),
                              Text('Keluar',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.red)
                              )
                            ],
                          )
                        ),
                      ),
                      SizedBox(height: 30.sp,),
                    ],
                  ),
                ),
              ),
              //content
              Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.only(left: 7.w),
                  child: FutureBuilder(
                    future: permissionData,
                    builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Terjadi kesahalan pada saat pengambilan data');
                      }  else if (snapshot.data == null || (snapshot.data as Map<String, dynamic>)['Data'] == null) {
                        return const Text('Data is null');
                      } else {
                        var data = (snapshot.data as Map<String, dynamic>)['Data'];
                        if (data.isEmpty) {
                          return const Text('Data is empty');
                        }

                          var firstData = data[0];
                          var permission_status = firstData['id_permission_status'] ?? 'N/A';
                          var employee_spv = firstData['employee_spv'] ?? 'N/A';
                          permissionTypeName = firstData['permission_type_name'] ?? 'N/A';

                          NamaYangMengajukanIzin = firstData['employee_name'] ?? 'N/A';
                          NIKYangMengajukanIzin = firstData['employee_id'] ?? 'N/A';
                          DeptYangMengajukanIzin = firstData['department_name'] ?? 'N/A';
                          JabatanYangMengajukanIzin = firstData['position_name'] ?? 'N/A';
                          tanggalIzin = DateFormat('EEEE, dd MMM yyyy').format(DateTime.parse(firstData['permission_date'] ?? '1999-01-01'),);
                          startCuti = DateFormat('EEEE, dd MMM yyyy').format(DateTime.parse(firstData['start_date'] ?? '1999-01-01'),);
                          endCuti = DateFormat('EEEE, dd MMM yyyy').format(DateTime.parse(firstData['end_date'] ?? '1999-01-01'),);
                          cutiPhone = firstData['cuti_phone'] ?? 'N/A';
                          karyawanPengganti = firstData['pengganti_cuti'] ?? 'N/A';
                          alasanIzin = firstData['permission_reason'] ?? 'N/A';
                          jamIzin = firstData['permission_time'] ?? 'N/A';
                          createdBy = firstData['created_by'] ?? 'N/A';
                          createdDt = firstData['created_dt'] ?? 'N/A';
                          updatedBy = firstData['update_by'] ?? 'N/A';
                          updatedDt = firstData['update_dt'] ?? 'N/A';

                          tanggalLembur = DateFormat('EEEE, dd MMM yyyy').format(DateTime.parse(firstData['lembur_date'] ?? '1999-01-01'),);
                          jamMulaiLembur = firstData['start_time'] ?? 'N/A';
                          jamAkhirLembur = firstData['end_time'] ?? 'N/A';
                          keteranganLembur = firstData['keperluan'] ?? 'N/A';


                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 100.sp,),
                            Row(
                              children: [
                                SizedBox(
                                  width: (MediaQuery.of(context).size.width - 160.w) / 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Nama Lengkap",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromRGBO(116, 116, 116, 1)
                                        ),
                                      ),
                                      SizedBox(height: 7.h,),
                                      TextFormField(
                                        initialValue: firstData != null ? firstData['employee_name'] ?? '' : '',
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          fillColor: Color.fromRGBO(235, 235, 235, 1),
                                          hintText: 'Masukkan nama anda'
                                        ),
                                        readOnly: true,
                                      )
                                    ],
                                  )
                                ),
                                SizedBox(width: 20.sp,),
                                SizedBox(
                                  width: (MediaQuery.of(context).size.width - 160.w) / 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "NIK",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromRGBO(116, 116, 116, 1)
                                        ),
                                      ),
                                      SizedBox(height: 7.h,),
                                      TextFormField(
                                        initialValue: firstData != null ? firstData['employee_id'] ?? '' : '',
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          fillColor: Color.fromRGBO(235, 235, 235, 1),
                                          hintText: 'Masukkan NIK anda'
                                        ),
                                        readOnly: true,
                                      )
                                    ],
                                  )
                                ),
                              ],
                            ),
                            SizedBox(height: 20.sp,),
                            Row(
                              children: [
                                SizedBox(
                                  width: (MediaQuery.of(context).size.width - 160.w) / 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Departemen",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromRGBO(116, 116, 116, 1)
                                        ),
                                      ),
                                      SizedBox(height: 7.h,),
                                      TextFormField(
                                        initialValue: firstData != null ? firstData['department_name'] ?? '' : '',
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          fillColor: Color.fromRGBO(235, 235, 235, 1),
                                          hintText: 'Masukkan departemen anda'
                                        ),
                                        readOnly: true,
                                      )
                                    ],
                                  )
                                ),
                                SizedBox(width: 20.sp,),
                                SizedBox(
                                  width: (MediaQuery.of(context).size.width - 160.w) / 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Jabatan",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromRGBO(116, 116, 116, 1)
                                        ),
                                      ),
                                      SizedBox(height: 7.h,),
                                      TextFormField(
                                        initialValue: firstData != null ? firstData['position_name'] ?? '' : '',
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          fillColor: Color.fromRGBO(235, 235, 235, 1),
                                          hintText: 'Masukkan jabatan anda'
                                        ),
                                        readOnly: true,
                                      )
                                    ],
                                  )
                                ),
                              ],
                            ),
                            SizedBox(height: 20.sp,),
                            if(permissionTypeName == 'Sakit')
                              Row(
                                children: [
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width - 160.w) / 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Tanggal mulai izin",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color.fromRGBO(116, 116, 116, 1)
                                          ),
                                        ),
                                        SizedBox(height: 7.h,),
                                        //DateTime
                                        TextFormField(
                                              initialValue: firstData != null ? DateFormat('dd MMM yyyy').format(DateTime.parse(firstData['start_date'] ?? ''),): '',
                                              //controller: txtAlasan,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                fillColor: Color.fromRGBO(235, 235, 235, 1),
                                                hintText: 'Masukkan tanggal lembur'
                                              ),
                                              readOnly: true,
                                            )
                                      ],
                                    )
                                  ),
                                  SizedBox(width: 20.sp,),
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width - 160.w) / 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Tanggal akhir izin",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color.fromRGBO(116, 116, 116, 1)
                                          ),
                                        ),
                                        SizedBox(height: 7.h,),
                                         TextFormField(
                                              initialValue: firstData != null ? DateFormat('dd MMM yyyy').format(DateTime.parse(firstData['end_date'] ?? ''),): '',
                                              //controller: txtAlasan,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                fillColor: Color.fromRGBO(235, 235, 235, 1),
                                                hintText: 'Masukkan tanggal lembur'
                                              ),
                                              readOnly: true,
                                            )
                                      ],
                                    )
                                  ),
                                ],
                              ),
                            if(permissionTypeName == 'Sakit')
                              SizedBox(height: 20.sp,),
                            if(permissionTypeName == 'Sakit')
                              suratDokter.isNotEmpty
                                ? Image.memory(
                                    base64.decode(suratDokter),
                                    fit: BoxFit.cover, // Choose the appropriate BoxFit for your needs
                                  )
                                : const CircularProgressIndicator(),
                            if(permissionTypeName == 'Lembur')
                              Row(
                                children: [
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width - 160.w) / 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Tanggal lembur",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color.fromRGBO(116, 116, 116, 1)
                                          ),
                                        ),
                                        SizedBox(height: 7.h,),
                                        //DateTime
                                        TextFormField(
                                              initialValue: firstData != null ? DateFormat('dd MMM yyyy').format(DateTime.parse(firstData['permission_date'] ?? ''),): '',
                                              //controller: txtAlasan,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                fillColor: Color.fromRGBO(235, 235, 235, 1),
                                                hintText: 'Masukkan tanggal lembur'
                                              ),
                                              readOnly: true,
                                            )
                                      ],
                                    )
                                  ),
                                  SizedBox(width: 20.sp,),
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width - 160.w) / 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Jam mulai lembur",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color.fromRGBO(116, 116, 116, 1)
                                          ),
                                        ),
                                        SizedBox(height: 7.h,),
                                        TextFormField(
                                              initialValue: firstData != null ? firstData['start_time'] ?? '' : '',
                                              //controller: txtAlasan,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                fillColor: Color.fromRGBO(235, 235, 235, 1),
                                                hintText: 'Masukkan alasan anda'
                                              ),
                                              readOnly: true,
                                            )
                                      ],
                                    )
                                  ),
                                ],
                              ),
                            if(permissionTypeName == 'Lembur')
                              SizedBox(height: 20.sp,),
                            if(permissionTypeName == 'Lembur')
                              Row(
                                children: [
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width - 160.w) / 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Jam akhir lembur",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color.fromRGBO(116, 116, 116, 1)
                                          ),
                                        ),
                                        SizedBox(height: 7.h,),
                                        //DateTime
                                        TextFormField(
                                              initialValue: firstData != null ? firstData['end_time'] ?? '' : '',
                                              //controller: txtAlasan,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                fillColor: Color.fromRGBO(235, 235, 235, 1),
                                                hintText: 'Masukkan tanggal lembur'
                                              ),
                                              readOnly: true,
                                            )
                                      ],
                                    )
                                  ),
                                  SizedBox(width: 20.sp,),
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width - 160.w) / 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Keperluan",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color.fromRGBO(116, 116, 116, 1)
                                          ),
                                        ),
                                        SizedBox(height: 7.h,),
                                        TextFormField(
                                              initialValue: firstData != null ? firstData['keperluan'] ?? '' : '',
                                              //controller: txtAlasan,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                fillColor: Color.fromRGBO(235, 235, 235, 1),
                                                hintText: 'Masukkan alasan anda'
                                              ),
                                              readOnly: true,
                                            )
                                      ],
                                    )
                                  ),
                                ],
                              ),
                            if(permissionTypeName == 'Cuti tahunan')
                              Row(
                                children: [
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width - 160.w) / 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Tanggal mulai cuti",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color.fromRGBO(116, 116, 116, 1)
                                          ),
                                        ),
                                        SizedBox(height: 7.h,),
                                        //DateTime
                                        TextFormField(
                                              initialValue: firstData != null ? DateFormat('dd MMM yyyy').format(DateTime.parse(firstData['start_date'] ?? ''),): '',
                                              //controller: txtAlasan,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                fillColor: Color.fromRGBO(235, 235, 235, 1),
                                                hintText: 'Masukkan alasan anda'
                                              ),
                                              readOnly: true,
                                            )
                                      ],
                                    )
                                  ),
                                  SizedBox(width: 20.sp,),
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width - 160.w) / 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Tanggal akhir cuti",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color.fromRGBO(116, 116, 116, 1)
                                          ),
                                        ),
                                        SizedBox(height: 7.h,),
                                        TextFormField(
                                              initialValue: firstData != null ? DateFormat('dd MMM yyyy').format(DateTime.parse(firstData['end_date'] ?? ''),): '',
                                              //controller: txtAlasan,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                fillColor: Color.fromRGBO(235, 235, 235, 1),
                                                hintText: 'Masukkan alasan anda'
                                              ),
                                              readOnly: true,
                                            )
                                      ],
                                    )
                                  ),
                                ],
                              ),
                            if(permissionTypeName == 'Cuti tahunan')
                              SizedBox(height: 20.sp,),
                            if(permissionTypeName == 'Cuti tahunan')
                              Row(
                                children: [
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width - 160.w) / 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Tanggal mulai cuti",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color.fromRGBO(116, 116, 116, 1)
                                          ),
                                        ),
                                        SizedBox(height: 7.h,),
                                        //DateTime
                                        TextFormField(
                                              initialValue: firstData != null ? DateFormat('dd MMM yyyy').format(DateTime.parse(firstData['start_date'] ?? ''),): '',
                                              //controller: txtAlasan,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                fillColor: Color.fromRGBO(235, 235, 235, 1),
                                                hintText: 'Masukkan alasan anda'
                                              ),
                                              readOnly: true,
                                            )
                                      ],
                                    )
                                  ),
                                  SizedBox(width: 20.sp,),
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width - 160.w) / 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Tanggal akhir cuti",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color.fromRGBO(116, 116, 116, 1)
                                          ),
                                        ),
                                        SizedBox(height: 7.h,),
                                        TextFormField(
                                              initialValue: firstData != null ? DateFormat('dd MMM yyyy').format(DateTime.parse(firstData['end_date'] ?? ''),): '',
                                              //controller: txtAlasan,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                fillColor: Color.fromRGBO(235, 235, 235, 1),
                                                hintText: 'Masukkan alasan anda'
                                              ),
                                              readOnly: true,
                                            )
                                      ],
                                    )
                                  ),
                                ],
                              ),
                            if(permissionTypeName == 'Cuti tahunan')
                              SizedBox(height: 20.sp,),
                            if(permissionTypeName == 'Cuti tahunan')
                              Row(
                                children: [
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width - 160.w) / 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Nomor yang bisa dihubungi",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color.fromRGBO(116, 116, 116, 1)
                                          ),
                                        ),
                                        SizedBox(height: 7.h,),
                                        TextFormField(
                                          //initialValue: sisaCuti.toString(),
                                          initialValue: firstData != null ? firstData['cuti_phone'] ?? '' : '',
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            fillColor: Color.fromRGBO(235, 235, 235, 1),
                                            hintText: 'Masukkan sisa cuti berjalan'
                                          ),
                                          readOnly: true,
                                        )
                                      ],
                                    )
                                  ),
                                  SizedBox(width: 20.sp,),
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width - 160.w) / 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Karyawan pengganti",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color.fromRGBO(116, 116, 116, 1)
                                          ),
                                        ),
                                        SizedBox(height: 7.h,),
                                        TextFormField(
                                          initialValue: firstData != null ? firstData['pengganti_cuti'] ?? '' : '',
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            fillColor: Color.fromRGBO(235, 235, 235, 1),
                                            hintText: 'Masukkan nomor yang bisa dihubungi'
                                          ),
                                          readOnly: true,
                                        )
                                      ],
                                    )
                                  ),
                                ],
                              ),
                            if(permissionTypeName == 'Cuti tahunan')
                              SizedBox(height: 20.sp,),
                            if(permissionTypeName == 'Cuti tahunan')
                              Row(
                                children: [
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width - 158.w),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Keterangan atau alasan",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color.fromRGBO(116, 116, 116, 1)
                                          ),
                                        ),
                                        SizedBox(height: 7.h,),
                                        TextFormField(
                                          initialValue: firstData != null ? firstData['permission_reason'] ?? '' : '',
                                          maxLines: 3,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            fillColor: Color.fromRGBO(235, 235, 235, 1),
                                            hintText: 'Masukkan keterangan atau alasan anda'
                                          ),
                                          readOnly: true,
                                        )
                                      ],
                                    )
                                  ),
                                  SizedBox(width: 20.sp,),
                                  
                                ],
                              ),
                            if(permissionTypeName == "Izin pulang awal" || permissionTypeName == "Izin datang telat")
                              Row(
                                children: [
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width - 160.w) / 2,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Hari dan tanggal",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: const Color.fromRGBO(116, 116, 116, 1)
                                            ),
                                          ),
                                          SizedBox(height: 7.h,),
                                          //DateTime
                                          TextFormField(
                                            initialValue: firstData != null ? DateFormat('dd MMM yyyy').format(DateTime.parse(firstData['permission_date'] ?? ''),): '',
                                            //controller: txtAlasan,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              fillColor: Color.fromRGBO(235, 235, 235, 1),
                                              hintText: 'Masukkan alasan anda'
                                            ),
                                            readOnly: true,
                                          )
                                        ],
                                      )
                                    ),
                                  SizedBox(width: 20.sp,),
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width - 160.w) / 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Alasan",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color.fromRGBO(116, 116, 116, 1)
                                          ),
                                        ),
                                        SizedBox(height: 7.h,),
                                        TextFormField(
                                          initialValue: firstData != null ? firstData['permission_reason'] ?? '' : '',
                                          //controller: txtAlasan,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            fillColor: Color.fromRGBO(235, 235, 235, 1),
                                            hintText: 'Masukkan alasan anda'
                                          ),
                                          readOnly: true,
                                        )
                                      ],
                                    )
                                  ),
                                ],
                              ),
                            SizedBox(height: 20.sp,),
                            if(permissionTypeName == 'Izin pulang awal' || permissionTypeName == 'Izin datang telat')
                              Row(
                                children: [
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width - 160.w) / 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Jam absen",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color.fromRGBO(116, 116, 116, 1)
                                          ),
                                        ),
                                        SizedBox(height: 7.h,),
                                        TextFormField(
                                          initialValue: firstData != null ? firstData['permission_time'] ?? '' : '',
                                          //controller: txtAlasan,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            fillColor: Color.fromRGBO(235, 235, 235, 1),
                                            hintText: 'Masukkan alasan anda'
                                          ),
                                          readOnly: true,
                                        )
                                      ],
                                    )
                                  ),
                                  SizedBox(width: 20.sp,),
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width - 160.w) / 2,
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                      ],
                                    )
                                  ),
                                ],
                              ),
                            SizedBox(height: 50.sp,),
                            if(employeeId.toString().padLeft(10, '0') == employee_spv && permission_status == 'PER-STATUS-001')
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: (){
                                      showDialog(
                                        context: context, 
                                        builder: (_) {
                                          return AlertDialog(
                                            title: const Text("Persetujuan"),
                                            content: const Text('Apakah anda menyetujui izin tersebut ?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {Get.back();},
                                                child: const Text('Batal'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  ApproveManager();
                                                },
                                                child: const Text('Setuju',),
                                              ),
                                            ],
                                          );
                                        }
                                      );
                                    }, 
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(0.sp, 45.sp),
                                      foregroundColor: const Color(0xFFFFFFFF),
                                      backgroundColor: const Color(0xFF26C749),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Terima')
                                  ),
                                  SizedBox(width: 20.sp,),
                                  ElevatedButton(
                                    onPressed: (){
                                      showDialog(
                                        context: context, 
                                        builder: (_) {
                                          return AlertDialog(
                                            title: const Text("Penolakan"),
                                            content: const Text('Apakah anda yakin untuk menolak izin tersebut?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {Get.back();},
                                                child: const Text('Batal'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  RejectManager();
                                                },
                                                child: const Text('Tolak',),
                                              ),
                                            ],
                                          );
                                        }
                                      );
                                    }, 
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(0.sp, 45.sp),
                                      foregroundColor: const Color(0xFFFFFFFF),
                                      backgroundColor: const Color(0xffBB1717),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Tolak')
                                  )
                                ],
                              ),
                            SizedBox(height: 50.sp,),
                            if(positionId == 'POS-HR-002' && permission_status == 'PER-STATUS-002')
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: (){
                                      showDialog(
                                        context: context, 
                                        builder: (_) {
                                          return AlertDialog(
                                            title: const Text("Persetujuan"),
                                            content: const Text('Apakah anda menyetujui izin tersebut ?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {Get.back();},
                                                child: const Text('Batal'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  ApproveHRD();
                                                },
                                                child: const Text('Setuju',),
                                              ),
                                            ],
                                          );
                                        }
                                      );
                                    }, 
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(0.sp, 45.sp),
                                      foregroundColor: const Color(0xFFFFFFFF),
                                      backgroundColor: const Color(0xFF26C749),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Terima')
                                  ),
                                  SizedBox(width: 20.sp,),
                                  ElevatedButton(
                                    onPressed: (){
                                      showDialog(
                                        context: context, 
                                        builder: (_) {
                                          return AlertDialog(
                                            title: const Text("Penolakan"),
                                            content: const Text('Apakah anda yakin untuk menolak izin tersebut?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {Get.back();},
                                                child: const Text('Batal'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  RejectHRD();
                                                },
                                                child: const Text('Tolak',),
                                              ),
                                            ],
                                          );
                                        }
                                      );
                                    }, 
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(0.sp, 45.sp),
                                      foregroundColor: const Color(0xFFFFFFFF),
                                      backgroundColor: const Color(0xffBB1717),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Tolak')
                                  )
                                ],
                              ),
                            if(permission_status == 'PER-STATUS-003')
                              ElevatedButton(
                                onPressed: () {
                                  generateAndDisplayPDF();
                                }, 
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(0.sp, 45.sp),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: const Color(0xff4ec3fc),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Generate PDF')
                              ),
                            FutureBuilder(
                              future: logPermissionData,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        //Image.asset('assets/no_data.png'), // Ganti dengan path gambar yang sesuai
                                        Text('Anda belum pernah mengajukan izin apapun'),
                                      ],
                                    );
                                  } else if (snapshot.data!.isEmpty) {
                                    return const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        //Image.asset('assets/no_data.png'), // Ganti dengan path gambar yang sesuai
                                        Text('Anda belum pernah mengajukan izin apapun'),
                                      ],
                                    );
                                  } else {
                                    return DataTable(
                                      dataRowHeight: 100.h,
                                      showCheckboxColumn: false,
                                      columns: <DataColumn>[
                                        const DataColumn(label: Text('Nama')),
                                        const DataColumn(label: Text('Aksi')),
                                      ],
                                      rows: snapshot.data!.map((data) {
                                        return DataRow(
                                          cells: <DataCell>[
                                            DataCell(
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(data['employee_name']),
                                                  SizedBox(height: 8.h,),
                                                  Text(DateFormat('EEEE, d MMM y HH:mm:ss').format(DateTime.parse(data['action_dt']),))
                                                ],
                                              )
                                            ),
                                            DataCell(
                                              Text(data['action'])
                                            ),
                                          ],
                                          onSelectChanged: (bool? selected) {
                                            if (selected!) {
                                              
                                            }
                                          },
                                        );
                                      }).toList(),
                                    );
                                  }
                              }
                            ),
                            SizedBox(height: 100.sp,),

                                ],
                              );
                            }
                          }
                  ),
            

                ),
              ),
              //right profile
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15.sp,),
                    //photo profile and name
                    ListTile(
                      contentPadding: const EdgeInsets.only(left: 0, right: 0),
                                dense: true,
                                horizontalTitleGap: 20.0,
                      leading: Container(
                              margin: const EdgeInsets.only(right: 2.0),
                              child: Image.memory(
                                base64Decode(photo),
                              ),
                            ),
                      title: Text("$employeeName",
                        style: TextStyle( fontSize: 15.sp, fontWeight: FontWeight.w300,),
                      ),
                      subtitle: Text('$employeeEmail',
                        style: TextStyle( fontSize: 15.sp, fontWeight: FontWeight.w300,),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}