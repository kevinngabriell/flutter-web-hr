// ignore_for_file: use_build_context_synchronously, avoid_print, avoid_web_libraries_in_flutter, non_constant_identifier_names

import 'dart:convert';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

import 'package:intl/intl.dart';

class ReportIndex extends StatefulWidget {
  const ReportIndex({super.key});

  @override
  State<ReportIndex> createState() => _ReportIndexState();
}

class _ReportIndexState extends State<ReportIndex> {
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  bool isLoading = false;

  double totalMenikah = 0;
  double totalGender = 0;
  double totalReligion = 0;
  double totalMasaKerja = 0;

  List<Map<String, dynamic>> reportTypes = [];
  String selectedReportType = '';
  List<Map<String, dynamic>> departmentList = [];
  String selectedDepartment = '';
  List<Map<String, dynamic>> monthList = [];
  String selectedMonth = '';
  List<Map<String, dynamic>> yearList = [];
  String selectedYear = '';

  List<Map<String, dynamic>> dataList = [];
  Map<String, dynamic> Piedata = {};
  

  String formatDateToIndonesian(String date) {
    DateFormat inputFormat = DateFormat('yyyy-MM-dd');
    DateTime dateTime = inputFormat.parse(date);

    DateFormat outputFormat = DateFormat('d MMMM yyyy');

    return outputFormat.format(dateTime);
  }

  
  @override
  void initState() {
    super.initState();
    fetchStatistics('DEPT-HR-000');
    fetchData();
    fetchSearchReport();
  }

  Future<void> fetchStatistics(departmentID) async {
    try{
      isLoading = true;
      final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/report/reportstatistic.php?departmentId=$departmentID'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['StatusCode'] == 200) {
          setState(() {
            Piedata = json.decode(response.body)['Data'];
          });
        }
      } else {
         print('Failed to fetch data');
      }

    } catch (e){
       print('Failed to fetch data');
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchSearchReport() async{
    
    try{
      isLoading = true;
      final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/report/reportlist.php'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['StatusCode'] == 200) {
          setState(() {
            reportTypes = (data['Data']['Report Type'] as List)
              .map((company) => Map<String, String>.from(company))
              .toList();
            
            selectedReportType = reportTypes[0]['report_type_id'].toString();
            
            departmentList = (data['Data']['Department'] as List)
              .map((company) => Map<String, String>.from(company))
              .toList();
            
            selectedDepartment = departmentList[0]['department_id'].toString();
            
            monthList = (data['Data']['Month List'] as List)
              .map((company) => Map<String, String>.from(company))
              .toList();

            selectedMonth = monthList[0]['month_id'].toString();
            
            yearList = (data['Data']['Year List'] as List)
              .map((company) => Map<String, String>.from(company))
              .toList();
            
            selectedYear = yearList[0]['year'].toString();

          });
        }
      } else {
         print('Failed to fetch data');
      }

    } catch (e){
       print('Failed to fetch data');
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchData() async {
    String employeeId = storage.read('employee_id').toString();
    try {
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/account/getprofileforallpage.php';
      Map<String, dynamic> requestBody = {'employee_id': employeeId};
      String requestBodyJson = json.encode(requestBody);

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'employee_id': employeeId,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        setState(() {
          companyName = data['company_name'] as String;
          companyAddress = data['company_address'] as String;
          employeeName = data['employee_name'] as String;
          employeeEmail = data['employee_email'] as String;
          trimmedCompanyAddress = companyAddress.substring(0, 15);
        }); 
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> spReport(reportType, departmentID, selectedMonth, selectedYear) async {

    try {
      isLoading = true;
      String apiURL = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/report/getreport.php?reportType=$reportType&departmentId=$departmentID&month=$selectedMonth&year=$selectedYear';
      var response = await http.get(Uri.parse(apiURL));

      if (response.statusCode == 200) {
        if(reportType == '1'){
          var code = json.decode(response.statusCode.toString());
          var data = json.decode(response.body);

          print(code);
          if(code == '400'){
            Get.snackbar('Error', 'Data yang anda minta tidak tersedia !!');
          } else {
            List<String> employeeNames = [];
            List<String> departmentNames = [];
            List<String> positionNames = [];
            List<String> date = [];
            List<String> time = [];
            List<String> location = [];
            List<String> absenTypes = [];
            List<String> presenceTypes = [];
            List<String> isValid = [];

            setState(() {
              dataList = List<Map<String, dynamic>>.from(data['Data']);
              employeeNames = dataList.map((data) => data['employee_name'] as String).toList();
              departmentNames = dataList.map((data) => data['department_name'] as String).toList();
              positionNames = dataList.map((data) => data['position_name'] as String).toList();
              date = dataList.map((data) => data['date'] as String).toList();
              time = dataList.map((data) => data['time'] as String).toList();
              location = dataList.map((data) => data['location'] as String).toList();
              absenTypes = dataList.map((data) => data['absence_type_name'] as String).toList();
              presenceTypes = dataList.map((data) => data['presence_type_name'] as String).toList();
              isValid = dataList.map((data) => data['is_valid'] as String).toList();
            });

            // Create an Excel workbook
            var excel = Excel.createExcel();

            var sheet = excel['Sheet1'];
            sheet.merge(
              CellIndex.indexByString('A1'),
              CellIndex.indexByString('I1'),
              customValue: const TextCellValue('Laporan Absen'),
            );

            sheet.appendRow([const TextCellValue('Nama karyawan'), const TextCellValue('Departemen'), const TextCellValue('Posisi'), const TextCellValue('Tanggal'), const TextCellValue('Jam'), const TextCellValue('Lokasi'), const TextCellValue('Tipe Absen'), const TextCellValue('Kehadiran'), const TextCellValue('Valid')]);

            for (int i = 0; i < employeeNames.length; i++) {
              sheet.appendRow([
                TextCellValue(employeeNames[i]),
                TextCellValue(departmentNames[i]),
                TextCellValue(positionNames[i]),
                TextCellValue(date[i]),
                TextCellValue(time[i]),
                TextCellValue(location[i]),
                TextCellValue(absenTypes[i]),
                TextCellValue(presenceTypes[i]),
                TextCellValue(isValid[i])
              ]);
            }

            DateTime now = DateTime.now();

            // Save the workbook to a file
            List<int>? excelBytes = excel.encode();
            final blob = html.Blob([Uint8List.fromList(excelBytes!)], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            final url = html.Url.createObjectUrlFromBlob(blob);
            final anchor = html.AnchorElement(href: url)
              ..target = 'blank'
              ..download = 'LaporanAbsen-$now.xlsx';

            // Trigger a click on the anchor element to start the download
            html.document.body?.append(anchor);
            anchor.click();

            // Clean up
            html.Url.revokeObjectUrl(url);
            anchor.remove();
          }

        } else if (reportType == '2'){

          var data = json.decode(response.body);
          List<String> employeeNames = [];
          List<String> departmentNames = [];
          List<String> positionNames = [];
          List<String> leaveCount = [];
          List<String> expiredDate = [];

          setState(() {
            dataList = List<Map<String, dynamic>>.from(data['Data']);
            employeeNames = dataList.map((data) => data['employee_name'] as String).toList();
            departmentNames = dataList.map((data) => data['department_name'] as String).toList();
            positionNames = dataList.map((data) => data['position_name'] as String).toList();
            leaveCount = dataList.map((data) => data['leave_count'] as String).toList();
            expiredDate = dataList.map((data) => data['expired_date'] as String).toList();
          });

          // Create an Excel workbook
          var excel = Excel.createExcel();

          var sheet = excel['Sheet1'];
          sheet.merge(
            CellIndex.indexByString('A1'),
            CellIndex.indexByString('E1'),
            customValue: const TextCellValue('Laporan Sisa Cuti'),
          );

          sheet.appendRow([const TextCellValue('Nama karyawan'), const TextCellValue('Departemen'), const TextCellValue('Posisi'), const TextCellValue('Sisa cuti'), const TextCellValue('Masa berakhir')]);

          for (int i = 0; i < employeeNames.length; i++) {

          sheet.appendRow([
            TextCellValue(employeeNames[i]),
            TextCellValue(departmentNames[i]),
            TextCellValue(positionNames[i]),
            TextCellValue(leaveCount[i]),
            TextCellValue(expiredDate[i]),
          ]);
          }

          DateTime now = DateTime.now();

          // Save the workbook to a file
          List<int>? excelBytes = excel.encode();
          final blob = html.Blob([Uint8List.fromList(excelBytes!)], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url)
            ..target = 'blank'
            ..download = 'LaporanSisaCuti-$now.xlsx';

          // Trigger a click on the anchor element to start the download
          html.document.body?.append(anchor);
          anchor.click();

          // Clean up
          html.Url.revokeObjectUrl(url);
          anchor.remove();

        } else if (reportType == '3'){

        } else if (reportType == '4'){

          var data = json.decode(response.body);
          List<String> employeeId = [];
          List<String> employeeName = [];
          List<String> departmentName = [];
          List<String> positionName = [];
          List<String> employeePOB = [];
          List<String> employeeDOB = [];
          List<String> employeePhone = [];
          List<String> employeeIdentity = [];
          List<String> employeeAddress = [];

          setState(() {
            // Ensure dataList is initialized with an empty list if data['Data'] is null
            dataList = data['Data'] != null ? List<Map<String, dynamic>>.from(data['Data']) : [];
            
            employeeId = dataList.map((data) => data['employee_id']?.toString() ?? '').toList();
            employeeName = dataList.map((data) => data['employee_name']?.toString() ?? '').toList();
            departmentName = dataList.map((data) => data['department_name']?.toString() ?? '').toList();
            positionName = dataList.map((data) => data['position_name']?.toString() ?? '').toList();
            employeePOB = dataList.map((data) => data['employee_pob']?.toString() ?? '').toList();
            employeeDOB = dataList.map((data) {
              String originalDate = data['employee_dob'] as String; // Ensure this is a String.
              return formatDateToIndonesian(originalDate);
            }).toList();
            employeePhone = dataList.map((data) => data['employee_phone_number']?.toString() ?? '').toList();
            employeeIdentity = dataList.map((data) => data['employee_identity']?.toString() ?? '').toList();
            employeeAddress = dataList.map((data) => data['employee_address_ktp']?.toString() ?? '').toList();
          });


          // Create an Excel workbook
          var excel = Excel.createExcel();

          var sheet = excel['Sheet1'];
          sheet.merge(
            CellIndex.indexByString('A1'),
            CellIndex.indexByString('E1'),
            customValue: const TextCellValue('Data Karyawan'),
          );

          sheet.appendRow([const TextCellValue('NIK'), const TextCellValue('NAMA'), const TextCellValue('DEPARTEMEN'), const TextCellValue('JABATAN'), const TextCellValue('NOMOR HP'), const TextCellValue('NIK KTP'), const TextCellValue('TEMPAT, TANGGAL LAHIR'), const TextCellValue('ALAMAT'),]);

          for (int i = 0; i < employeeId.length; i++) {

          sheet.appendRow([
            TextCellValue(employeeId[i]),
            TextCellValue(employeeName[i]),
            TextCellValue(departmentName[i]),
            TextCellValue(positionName[i]),
            TextCellValue(employeePhone[i]),
            TextCellValue(employeeIdentity[i]),
            TextCellValue('${employeePOB[i]}, ${employeeDOB[i]}'),
            TextCellValue(employeeAddress[i]),
          ]);
          }

          DateTime now = DateTime.now();

          // Save the workbook to a file
          List<int>? excelBytes = excel.encode();
          final blob = html.Blob([Uint8List.fromList(excelBytes!)], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url)
            ..target = 'blank'
            ..download = 'DataKaryawan-$now.xlsx';

          // Trigger a click on the anchor element to start the download
          html.document.body?.append(anchor);
          anchor.click();

          // Clean up
          html.Url.revokeObjectUrl(url);
          anchor.remove();

        }
      } else {
        Get.snackbar('Error', 'Data yang anda minta tidak tersedia !!');
      }

    } catch (e) {
      String error = e.toString();
      showDialog(
        context: context, 
        builder: (_){
          return AlertDialog(
            title: const Text('Error'),
            content: Text(error),
            actions: [
              TextButton(
                onPressed: (){
                  Get.back();
                }, 
                child: const Text('Oke')
              )
            ],
          );
        }
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> createExcelAnnualLeave(departmentID) async{
    // Create an Excel workbook
    var excel = Excel.createExcel();

    if(departmentID == 'DEPT-HR-000'){

    } else {
      
    }

    DateTime now = DateTime.now();

    // Save the workbook to a file
    List<int>? excelBytes = excel.encode();
    final blob = html.Blob([Uint8List.fromList(excelBytes!)], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'LaporanSisaCuti-$now.xlsx';

    // Trigger a click on the anchor element to start the download
    html.document.body?.append(anchor);
    anchor.click();

    // Clean up
    html.Url.revokeObjectUrl(url);
    anchor.remove();
  }

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    var employeeId = storage.read('employee_id');
    var positionId = storage.read('position_id');
    var photo = storage.read('photo');

    totalMenikah = double.parse(Piedata['Status']['jumlahBelumMenikah'] ?? 0) + double.parse(Piedata['Status']['jumlahMenikah']);
    totalGender = double.parse(Piedata['Gender']['jumlahLaki']) + double.parse(Piedata['Gender']['jumlahPerempuan']);
    totalReligion = double.parse(Piedata['Religion']['jumlahIslam']) + double.parse(Piedata['Religion']['jumlahKristen']) + double.parse(Piedata['Religion']['jumlahKatolik']) + double.parse(Piedata['Religion']['jumlahBudha']) + double.parse(Piedata['Religion']['jumlahHindu']) + double.parse(Piedata['Religion']['jumlahKonghucu']);
    totalMasaKerja = double.parse(Piedata['Year']['oneTilFive']) + double.parse(Piedata['Year']['sixTilTenYears']) + double.parse(Piedata['Year']['moreThenTenYears']);

    return MaterialApp(
      title: "Laporan",
      home: Scaffold(
        body: isLoading ? const CircularProgressIndicator() : SingleChildScrollView(
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
                        NamaPerusahaanMenu(companyName: companyName, companyAddress: trimmedCompanyAddress),
                        SizedBox(height: 10.sp,),
                        const HalamanUtamaMenu(),
                        SizedBox(height: 5.sp,),
                        BerandaNonActive(employeeId: employeeId.toString()),
                        SizedBox(height: 5.sp,),
                        KaryawanNonActive(employeeId: employeeId.toString()),
                        SizedBox(height: 5.sp,),
                        const GajiNonActive(),
                        SizedBox(height: 5.sp,),
                        const PerformaNonActive(),
                        SizedBox(height: 5.sp,),
                        const PelatihanNonActive(),
                        SizedBox(height: 5.sp,),
                        const AcaraNonActive(),
                        SizedBox(height: 5.sp,),
                        const LaporanActive(),
                        SizedBox(height: 10.sp,),
                        const PengaturanMenu(),
                        SizedBox(height: 5.sp,),
                        const PengaturanNonActive(),
                        SizedBox(height: 5.sp,),
                        const StrukturNonActive(),
                        SizedBox(height: 5.sp,),
                        const Logout(),
                      ],
                    ),
                  ),
              ),
              //Content
              Expanded(
                flex: 8,
                child: Padding(
                  padding: EdgeInsets.only(left: 7.w, right: 7.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5.sp,),
                      NotificationnProfile(employeeName: employeeName, employeeAddress: employeeEmail, photo: photo),
                      SizedBox(height: 7.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: (){
                              showDialog(
                                context: context, 
                                builder: (_){
                                  return AlertDialog(
                                    title: const Center(child: Text('Laporan')),
                                    content: SizedBox(
                                      width: MediaQuery.of(context).size.width / 2,
                                      height: MediaQuery.of(context).size.height / 4,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width / 5,
                                                child: Column(
                                                  children: [
                                                    const Text('Jenis laporan'),
                                                    SizedBox(height: 5.h,),
                                                    DropdownButtonFormField<String>(
                                                      value: selectedReportType,
                                                      hint: const Text('Pilih jenis laporan'),
                                                      onChanged: (String? newValue) {
                                                        selectedReportType = newValue.toString();
                                                      },
                                                      items: reportTypes.map<DropdownMenuItem<String>>((Map<String, dynamic> report) {
                                                        return DropdownMenuItem<String>(
                                                          value: report['report_type_id']!,
                                                          child: Text(report['report_type_name']!),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width / 5,
                                                child: Column(
                                                  children: [
                                                    const Text('Departemen'),
                                                    SizedBox(height: 5.h,),
                                                    DropdownButtonFormField<String>(
                                                      value: selectedDepartment,
                                                      hint: const Text('Pilih departemen'),
                                                      onChanged: (String? newValue) {
                                                        selectedDepartment = newValue.toString();
                                                      },
                                                      items: departmentList.map<DropdownMenuItem<String>>((Map<String, dynamic> department) {
                                                        return DropdownMenuItem<String>(
                                                          value: department['department_id']!,
                                                          child: Text(department['department_name']!),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20.h,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width / 5,
                                                child: Column(
                                                  children: [
                                                    const Text('Bulan'),
                                                    SizedBox(height: 5.h,),
                                                    DropdownButtonFormField<String>(
                                                      value: selectedMonth,
                                                      hint: const Text('Pilih bulan'),
                                                      onChanged: (String? newValue) {
                                                        selectedMonth = newValue.toString();
                                                      },
                                                      items: monthList.map<DropdownMenuItem<String>>((Map<String, dynamic> month) {
                                                        return DropdownMenuItem<String>(
                                                          value: month['month_id']!,
                                                          child: Text(month['month_name']!),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width / 5,
                                                child: Column(
                                                  children: [
                                                    const Text('Tahun'),
                                                    SizedBox(height: 5.h,),
                                                    DropdownButtonFormField<String>(
                                                      value: selectedYear,
                                                      hint: const Text('Pilih tahun'),
                                                      onChanged: (String? newValue) {
                                                        selectedYear = newValue.toString();
                                                      },
                                                      items: yearList.map<DropdownMenuItem<String>>((Map<String, dynamic> year) {
                                                        return DropdownMenuItem<String>(
                                                          value: year['year']!,
                                                          child: Text(year['year']!),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: (){
                                          Get.back();
                                        }, 
                                        child: const Text('Batal')
                                      ),
                                      TextButton(
                                        onPressed: (){
                                          spReport(selectedReportType, selectedDepartment, selectedMonth, selectedYear);
                                        }, 
                                        child: const Text('Download laporan')
                                      )
                                    ],
                                  );
                                }
                              );
                            }, 
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(50.w, 55.h),
                              foregroundColor: const Color(0xFFFFFFFF),
                              backgroundColor: const Color(0xff4ec3fc),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Cari laporan')
                          )
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.only(top: 5.sp, bottom: 5.sp, left: 5.sp, right: 5.sp),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 5,
                                      child: DropdownButtonFormField<String>(
                                        value: selectedDepartment,
                                        hint: const Text('Pilih departemen'),
                                        onChanged: (String? newValue) {
                                          selectedDepartment = newValue.toString();
                                          fetchStatistics(selectedDepartment);
                                        },
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(width: 0.0),
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(width: 0.0),
                                            borderRadius: BorderRadius.circular(10.0),
                                          )
                                        ),
                                        items: departmentList.map<DropdownMenuItem<String>>((Map<String, dynamic> department) {
                                          return DropdownMenuItem<String>(
                                            value: department['department_id']!,
                                            child: Text(department['department_name']!),
                                          );
                                       }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 7.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 4,
                                      child: Card(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 10.sp, bottom: 10.sp),
                                          child: Column(
                                            children: [
                                              Center(
                                                child: Text('Demografi',style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w700,))
                                              ),
                                              SizedBox(height: 5.sp,),
                                              SizedBox(
                                                width: (MediaQuery.of(context).size.width - 150.w) / 4,
                                                height: (MediaQuery.of(context).size.height - 380.h),
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: PieChart(
                                                        PieChartData(
                                                          sections: [
                                                            PieChartSectionData(
                                                              showTitle: false,
                                                              color: Colors.blue,
                                                              value: double.parse(Piedata['Gender']['jumlahLaki']),
                                                              title: Piedata['Gender']['jumlahLaki'],
                                                              radius: 40,
                                                            ),
                                                            PieChartSectionData(
                                                              showTitle: false,
                                                              color: Colors.pink,
                                                              value: double.parse(Piedata['Gender']['jumlahPerempuan']),
                                                              title: Piedata['Gender']['jumlahPerempuan'],
                                                              radius: 40,
                                                            ),
                                                          ]
                                                        )
                                                      ),
                                                    ),
                                                    SizedBox(height: 20.h,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          width: 16,
                                                          height: 16, 
                                                          decoration: const BoxDecoration(
                                                            color: Colors.blue, 
                                                            shape: BoxShape.rectangle, 
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8), 
                                                        Text("Laki-laki ${Piedata['Gender']['jumlahLaki']} (${(double.parse(Piedata['Gender']['jumlahLaki']) / totalGender * 100).toStringAsFixed(1)}%)"),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.h,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          width: 16,
                                                          height: 16, 
                                                          decoration: const BoxDecoration(
                                                            color: Colors.pink, 
                                                            shape: BoxShape.rectangle, 
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8), 
                                                        Text("Perempuan ${Piedata['Gender']['jumlahPerempuan']} (${(double.parse(Piedata['Gender']['jumlahPerempuan']) / totalGender * 100).toStringAsFixed(1)}%)"),
                                                      ],
                                                    ),
                                                    SizedBox(height: 30.h,),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width - 190.w,
                                      child: Card(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 10.sp, bottom: 10.sp),
                                          child: Column(
                                            children: [
                                              Center(
                                                child: Text('Pendidikan Terakhir', style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w700,))
                                              ),
                                              SizedBox(height: 5.sp,),
                                              SizedBox(
                                                width: (MediaQuery.of(context).size.width - 150.w) / 4,
                                                height: (MediaQuery.of(context).size.height - 380.h),
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: BarChart(
                                                        BarChartData(

                                                        )
                                                      ),
                                                    )
                                                  ]
                                                )
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 15.sp,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width - 20.w) / 4,
                                      child: Card(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 10.sp, bottom: 10.sp),
                                          child: Column(
                                            children: [
                                              Text('Agama', style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w700,)),
                                              SizedBox(height: 5.sp,),
                                              SizedBox(
                                                width: (MediaQuery.of(context).size.width - 150.w) / 4,
                                                height: (MediaQuery.of(context).size.height - 250.h),
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: PieChart(
                                                        PieChartData(
                                                          sections: [
                                                            PieChartSectionData(
                                                              showTitle: false,
                                                              color: Colors.green,
                                                              value: double.parse(Piedata['Religion']['jumlahIslam']),
                                                              title: Piedata['Religion']['jumlahIslam'],
                                                              radius: 40,
                                                            ),
                                                            PieChartSectionData(
                                                              showTitle: false,
                                                              color: Colors.blue,
                                                              value: double.parse(Piedata['Religion']['jumlahKristen']),
                                                              title: Piedata['Religion']['jumlahKristen'],
                                                              radius: 40,
                                                            ),
                                                            PieChartSectionData(
                                                              showTitle: false,
                                                              color: Colors.red,
                                                              value: double.parse(Piedata['Religion']['jumlahKatolik']),
                                                              title: Piedata['Religion']['jumlahKatolik'],
                                                              radius: 40,
                                                            ),
                                                            PieChartSectionData(
                                                              showTitle: false,
                                                              color: Colors.yellow,
                                                              value: double.parse(Piedata['Religion']['jumlahBudha']),
                                                              title: Piedata['Religion']['jumlahBudha'],
                                                              radius: 40,
                                                            ),
                                                            PieChartSectionData(
                                                              showTitle: false,
                                                              color: Colors.orange,
                                                              value: double.parse(Piedata['Religion']['jumlahHindu']),
                                                              title: Piedata['Religion']['jumlahHindu'],
                                                              radius: 40,
                                                            ),
                                                            PieChartSectionData(
                                                              showTitle: false,
                                                              color: Colors.purple,
                                                              value: double.parse(Piedata['Religion']['jumlahKonghucu']),
                                                              title: Piedata['Religion']['jumlahKonghucu'],
                                                              radius: 40,
                                                            ),
                                                          ]
                                                        )
                                                      ),
                                                    ),
                                                    SizedBox(height: 20.h,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          width: 16,
                                                          height: 16, 
                                                          decoration: const BoxDecoration(
                                                            color: Colors.green, 
                                                            shape: BoxShape.rectangle, 
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8), 
                                                        Text("Islam ${Piedata['Religion']['jumlahIslam']} (${(double.parse(Piedata['Religion']['jumlahIslam']) / totalReligion * 100).toStringAsFixed(1)}%)"),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.h,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          width: 16,
                                                          height: 16, 
                                                          decoration: const BoxDecoration(
                                                            color: Colors.blue, 
                                                            shape: BoxShape.rectangle, 
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8), 
                                                        Text("Kristen ${Piedata['Religion']['jumlahKristen']} (${(double.parse(Piedata['Religion']['jumlahKristen']) / totalReligion * 100).toStringAsFixed(1)}%)"),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.h,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          width: 16,
                                                          height: 16, 
                                                          decoration: const BoxDecoration(
                                                            color: Colors.red, 
                                                            shape: BoxShape.rectangle, 
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8), 
                                                        Text("Katolik ${Piedata['Religion']['jumlahKatolik']} (${(double.parse(Piedata['Religion']['jumlahKatolik']) / totalReligion * 100).toStringAsFixed(1)}%)"),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.h,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          width: 16,
                                                          height: 16, 
                                                          decoration: const BoxDecoration(
                                                            color: Colors.yellow, 
                                                            shape: BoxShape.rectangle, 
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8), 
                                                        Text("Budha ${Piedata['Religion']['jumlahBudha']} (${(double.parse(Piedata['Religion']['jumlahBudha']) / totalReligion * 100).toStringAsFixed(1)}%)"),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.h,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          width: 16,
                                                          height: 16, 
                                                          decoration: const BoxDecoration(
                                                            color: Colors.orange, 
                                                            shape: BoxShape.rectangle, 
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8), 
                                                        Text("Hindu ${Piedata['Religion']['jumlahHindu']} (${(double.parse(Piedata['Religion']['jumlahHindu']) / totalReligion * 100).toStringAsFixed(1)}%)"),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.h,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          width: 16,
                                                          height: 16, 
                                                          decoration: const BoxDecoration(
                                                            color: Colors.purple, 
                                                            shape: BoxShape.rectangle, 
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8), 
                                                        Text("Konghucu ${Piedata['Religion']['jumlahKonghucu']} (${(double.parse(Piedata['Religion']['jumlahKonghucu']) / totalReligion * 100).toStringAsFixed(1)}%)"),
                                                      ],
                                                    ),
                                                    SizedBox(height: 30.h,),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width - 20.w) / 4,
                                      child: Card(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 10.sp, bottom: 10.sp),
                                          child: Column(
                                            children: [
                                              Text('Status Karyawan', style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w700,)),
                                              SizedBox(height: 5.sp,),
                                              SizedBox(
                                                width: (MediaQuery.of(context).size.width - 140.w) / 4,
                                                height: (MediaQuery.of(context).size.height - 255.h),
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: PieChart(
                                                        PieChartData(
                                                          sections: [
                                                            PieChartSectionData(
                                                              showTitle: false,
                                                              color: Colors.blue,
                                                              value: double.parse(Piedata['Status']['jumlahBelumMenikah']?? 0),
                                                              title: '${(double.parse(Piedata['Status']['jumlahBelumMenikah']?? 0) / totalMenikah * 100).toStringAsFixed(1)}%',
                                                              radius: 40,
                                                            ),
                                                            PieChartSectionData(
                                                              showTitle: false,
                                                              color: Colors.pink,
                                                              value: double.parse(Piedata['Status']['jumlahMenikah']),
                                                              title: Piedata['Status']['jumlahMenikah'],
                                                              radius: 40,
                                                            ),
                                                          ]
                                                        )
                                                      ),
                                                    ),
                                                    SizedBox(height: 20.h,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          width: 16,
                                                          height: 16, 
                                                          decoration: const BoxDecoration(
                                                            color: Colors.blue, 
                                                            shape: BoxShape.rectangle, 
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8), 
                                                        Text("Belum Menikah ${Piedata['Status']['jumlahBelumMenikah'] ?? 0} (${(double.parse(Piedata['Status']['jumlahBelumMenikah']) / totalMenikah * 100).toStringAsFixed(1)}%)"),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.h,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          width: 16,
                                                          height: 16, 
                                                          decoration: const BoxDecoration(
                                                            color: Colors.pink, 
                                                            shape: BoxShape.rectangle, 
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8), 
                                                        Text("Sudah Menikah ${Piedata['Status']['jumlahMenikah']} (${(double.parse(Piedata['Status']['jumlahMenikah']) / totalMenikah * 100).toStringAsFixed(1)}%)"),
                                                      ],
                                                    ),
                                                    SizedBox(height: 140.h,),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width - 20.w) / 4,
                                      child: Card(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 10.sp, bottom: 10.sp),
                                          child: Column(
                                            children: [
                                              Text('Masa Kerja', style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w700,)),
                                              SizedBox(height: 5.sp,),
                                              SizedBox(
                                                width: (MediaQuery.of(context).size.width - 130.w) / 4,
                                                height: (MediaQuery.of(context).size.height - 250.h),
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: PieChart(
                                                        PieChartData(
                                                          sections: [
                                                            PieChartSectionData(
                                                              showTitle: false,
                                                              color: Colors.green,
                                                              value: double.parse(Piedata['Year']['oneTilFive']),
                                                              title: Piedata['Year']['oneTilFive'],
                                                              radius: 40,
                                                            ),
                                                            PieChartSectionData(
                                                              showTitle: false,
                                                              color: Colors.blue,
                                                              value: double.parse(Piedata['Year']['sixTilTenYears']),
                                                              title: Piedata['Year']['sixTilTenYears'],
                                                              radius: 40,
                                                            ),
                                                            PieChartSectionData(
                                                              showTitle: false,
                                                              color: Colors.red,
                                                              value: double.parse(Piedata['Year']['moreThenTenYears']),
                                                              title: Piedata['Year']['moreThenTenYears'],
                                                              radius: 40,
                                                            ),
                                                          ]
                                                        )
                                                      ),
                                                    ),
                                                    SizedBox(height: 20.h,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          width: 16,
                                                          height: 16, 
                                                          decoration: const BoxDecoration(
                                                            color: Colors.green, 
                                                            shape: BoxShape.rectangle, 
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8), 
                                                        Text("1-5 Tahun ${Piedata['Year']['oneTilFive']} (${(double.parse(Piedata['Year']['oneTilFive']) / totalMasaKerja * 100).toStringAsFixed(1)}%)"),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.h,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          width: 16,
                                                          height: 16, 
                                                          decoration: const BoxDecoration(
                                                            color: Colors.blue, 
                                                            shape: BoxShape.rectangle, 
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8), 
                                                        Text("6-10 Tahun ${Piedata['Year']['sixTilTenYears']} (${(double.parse(Piedata['Year']['sixTilTenYears']) / totalMasaKerja * 100).toStringAsFixed(1)}%)"),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.h,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          width: 16,
                                                          height: 16, 
                                                          decoration: const BoxDecoration(
                                                            color: Colors.red, 
                                                            shape: BoxShape.rectangle, 
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8), 
                                                        Text("Lebih dari 10 Tahun ${Piedata['Year']['moreThenTenYears']} (${(double.parse(Piedata['Year']['moreThenTenYears']) / totalMasaKerja * 100).toStringAsFixed(1)}%)"),
                                                      ],
                                                    ),
                                                    SizedBox(height: 80.h,),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // SizedBox(
                                    //   width: MediaQuery.of(context).size.width / 4,
                                    //   child: Card(
                                    //     child: Text('data'),
                                    //   ),
                                    // )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                )
              )
            ],
          ),
        )
      )
    );
  }


}