// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Absen/DetailAbsence.dart';
import 'package:hr_systems_web/web-version/full-access/Event/event.dart';
import 'package:hr_systems_web/web-version/full-access/Performance/performance.dart';
import 'package:hr_systems_web/web-version/full-access/Report/report.dart';
import 'package:hr_systems_web/web-version/full-access/Salary/salary.dart';
import 'package:hr_systems_web/web-version/full-access/Settings/setting.dart';
import 'package:hr_systems_web/web-version/full-access/Structure/structure.dart';
import 'package:hr_systems_web/web-version/full-access/Training/traning.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../login.dart';
import '../employee.dart';
import '../index.dart';

class ListEmployeeAbsence extends StatefulWidget {
  const ListEmployeeAbsence({super.key});

  @override
  State<ListEmployeeAbsence> createState() => _ListEmployeeAbsenceState();
}

class _ListEmployeeAbsenceState extends State<ListEmployeeAbsence> {
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  late Future<List<Map<String, dynamic>>> employeeList;

  Future<void> fetchData() async {
    String employeeId = storage.read('employee_id').toString();

    try {
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
    }
  }

  Future<List<Map<String, dynamic>>> fetchEmployeeList() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployeelist.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['Data'];
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load data');
    }
  }  

  @override
  void initState(){
    super.initState();
    fetchData();
    employeeList = fetchEmployeeList();
  }

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    var employeeId = storage.read('employee_id');
    var positionId = storage.read('position_id');
    var photo = storage.read('photo');
    return MaterialApp(
      title: "Absen",
      home: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15.sp,),
                        ListTile(
                        contentPadding: const EdgeInsets.only(left: 0, right: 0),
                        dense: true,
                        horizontalTitleGap: 0.0,
                        leading: Container(
                          margin: EdgeInsets.only(right: 2.0), // Add margin to the right of the image
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
                                onPressed: () {Get.to(EmployeePage(employee_id: employeeId));},
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
                                  Get.to(SalaryIndex());
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
                                  Get.to(PerformanceIndex());
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
                                  Get.to(TrainingIndex());
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
                                  Get.to(EventIndex());
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
                                  Get.to(ReportIndex());
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
                                  Get.to(SettingIndex());
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
                                  Get.to(StructureIndex());
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
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    SizedBox(
                      height: 100.h,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 380.sp,
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: employeeList,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.hasData) {
                              return DataTable(
                                showCheckboxColumn: false,
                                columns: const <DataColumn>[
                                  DataColumn(label: Text('Nama Karyawan')),
                                  DataColumn(label: Text('Departemen')),
                                  // DataColumn(label: Text('Periode Kerja')),
                                  // DataColumn(label: Text('Status')),
                                ],
                                rows: snapshot.data!.map<DataRow>((employee) {
                                  return DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(employee['employee_name'])),
                                      DataCell(Text(employee['department_name'])),
                                      // DataCell(Text(employee['employee_name'])),
                                      // DataCell(Text(employee['department_name'])),
                                    ],
                                    onSelectChanged: (selected) {
                                      if (selected!) {
                                        Get.to(DetailAbsenInsertUpdate(employee['id'], employee['employee_name']) );
                                      }
                                    },
                                  );
                                }).toList(),
                              );
                            } else {
                              return const Center(child: Text('No data available'));
                            }
                          },
                        ),
                      )
                  ],
                )
              ),
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
                          subtitle: Text("$employeeEmail",
                            style: TextStyle( fontSize: 15.sp, fontWeight: FontWeight.w300,),
                          ),
                        ),
                      ],
                    ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}