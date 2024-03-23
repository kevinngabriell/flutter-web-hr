// ignore_for_file: non_constant_identifier_names, avoid_print, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/logout.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Applicant/applicantdashboard.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/EmployeeList.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/RequestNewEmployee.dart';
import 'package:hr_systems_web/web-version/full-access/Event/event.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/InventoryDashboard.dart';
import 'package:hr_systems_web/web-version/full-access/Performance/performance.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/PerjalananDinasIndex.dart';
import 'package:hr_systems_web/web-version/full-access/PinjamanKaryawan/PinjamanKaryawanIndex.dart';
import 'package:hr_systems_web/web-version/full-access/Report/report.dart';
import 'package:hr_systems_web/web-version/full-access/Salary/salary.dart';
import 'package:hr_systems_web/web-version/full-access/Settings/setting.dart';
import 'package:hr_systems_web/web-version/full-access/Structure/structure.dart';
import 'package:hr_systems_web/web-version/full-access/Training/traning.dart';
import 'package:hr_systems_web/web-version/full-access/index.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key, required employee_id});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  List<dynamic> profileData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  final storage = GetStorage();

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

        // Ensure that the fields are of the correct type
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

  @override
  Widget build(BuildContext context) {

    // Access the GetStorage instance
    final storage = GetStorage();

    // Retrieve the stored employee_id
    var employeeId = storage.read('employee_id');
    var positionId = storage.read('position_id');

    return MaterialApp(
      title: "Menu Karyawan",
      home: SafeArea(
        child: Scaffold(
          body: isLoading ? const Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //side menu
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
                              foregroundColor: const Color(0xDDDDDDDD),
                              backgroundColor: const Color(0xFFFFFFFF),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Image.asset('images/home-inactive.png')
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
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: const Color(0xff4ec3fc),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Image.asset('images/employee-active.png')
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
                                  Get.to(const PerformanceIndex());
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
                                            onPressed: () {
                                              logoutServicesWeb();
                                            },
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
                //content menu
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: EdgeInsets.only(left: 7.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 100.h,),
                        //4 card diatas
                        Row(
                          children: [
                            //card pertama
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 310.sp) / 4,
                              height: MediaQuery.of(context).size.height / 3,
                              child: GestureDetector(
                                onTap: () {
                                  // Get.snackbar('Under Construction', 'This feature is under construction stay tune');
                                  if(positionId == 'POS-HR-001' || positionId == 'POS-HR-002' || positionId == 'POS-HR-004' || positionId == 'POS-HR-005' || positionId == 'POS-HR-008' || positionId == 'POS-HR-024'){
                                    Get.to(const RequestNewEmployee());
                                  } else {
                                    showDialog(
                                      context: context, 
                                      builder: (_) {
                                        return AlertDialog(
                                          title: const Text("Error"),
                                          content: const Text("Maaf anda tidak memiliki akses ke menu ini"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Get.back();
                                              }, 
                                              child: const Text("Oke")
                                            ),
                                          ],
                                        );
                                      }
                                    );
                                  }
                                },
                                child: Card(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12))
                                  ),
                                  color: Colors.white,
                                  shadowColor: Colors.black,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 7.sp, top: 10.sp, bottom: 10.sp, right: 7.sp),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset('images/NewEmployeeRequest.png'),
                                        SizedBox(height: 15.sp,),
                                        Text('Pengajuan',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                          )
                                        ),
                                        SizedBox(height: 7.sp,),
                                        Text('Ajukan karyawan baru dan lengkapi semua informasi yang diperlukan untuk proses perekrutan dan penerimaan',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color.fromRGBO(116, 116, 116, 1),
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w400,
                                          )
                                        )
                                      ],
                                    ),
                                  )
                                ),
                              ),
                            ),
                            //card kedua
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 310.sp) / 4,
                              height: MediaQuery.of(context).size.height / 3,
                              child: GestureDetector(
                                onTap: () {
                                  if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008'){
                                    Get.to(const ApplicantIndex());
                                  } else {
                                    showDialog(
                                      context: context, 
                                      builder: (_) {
                                        return AlertDialog(
                                          title: const Text("Error"),
                                          content: const Text("Maaf anda tidak memiliki akses ke menu ini"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Get.back();
                                              }, 
                                              child: const Text("Oke")
                                            ),
                                          ],
                                        );
                                      }
                                    );
                                  }
                                },
                                child: Card(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12))
                                  ),
                                  color: Colors.white,
                                  shadowColor: Colors.black,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 7.sp, top: 10.sp, bottom: 10.sp, right: 7.sp),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset('images/Applicant.png'),
                                        SizedBox(height: 15.sp,),
                                        Text('Pelamar',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                          )
                                        ),
                                        SizedBox(height: 7.sp,),
                                        Text('Lihat semua pelamar kerja yang masuk, kelola data mereka, dan pantau status lamaran mereka',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color.fromRGBO(116, 116, 116, 1),
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w400,
                                          )
                                        )
                                      ],
                                    ),
                                  )
                                ),
                              ),
                            ),
                            //card ketiga
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 310.sp) / 4,
                              height: MediaQuery.of(context).size.height / 3,
                              child: GestureDetector(
                                onTap: () {
                                  if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008'){
                                    Get.to(const EmployeeListPage());
                                  } else {
                                    showDialog(
                                      context: context, 
                                      builder: (_) {
                                        return AlertDialog(
                                          title: const Text("Error"),
                                          content: const Text("Maaf anda tidak memiliki akses ke menu ini"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Get.back();
                                              }, 
                                              child: const Text("Oke")
                                            ),
                                          ],
                                        );
                                      }
                                    );
                                  }
                                },
                                child: Card(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12))
                                  ),
                                  color: Colors.white,
                                  shadowColor: Colors.black,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 7.sp, top: 10.sp, bottom: 10.sp, right: 7.sp),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset('images/Employee.png'),
                                        SizedBox(height: 15.sp,),
                                        Text('Karyawan',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                          )
                                        ),
                                        SizedBox(height: 7.sp,),
                                        Text('Lihat daftar lengkap karyawan yang bekerja di perusahaan, termasuk data dan detail personal mereka',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color.fromRGBO(116, 116, 116, 1),
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w400,
                                          )
                                        )
                                      ],
                                    ),
                                  )
                                ),
                              ),
                            ),
                            //card keempat
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 310.sp) / 4,
                              height: MediaQuery.of(context).size.height / 3,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(const InventoryIndex());
                                },
                                child: Card(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12))
                                  ),
                                  color: Colors.white,
                                  shadowColor: Colors.black,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 7.sp, top: 10.sp, bottom: 10.sp, right: 7.sp),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset('images/NewEmployeeRequest.png'),
                                        SizedBox(height: 15.sp,),
                                        Text('Inventaris',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                          )
                                        ),
                                        SizedBox(height: 7.sp,),
                                        Text('Lakukan pendataan dan ajukan permintaan inventaris baru melalui menu ini',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color.fromRGBO(116, 116, 116, 1),
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w400,
                                          )
                                        )
                                      ],
                                    ),
                                  )
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.sp,),
                        //4 card dibawah
                        Row(
                          children: [
                            //card pertama
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 310.sp) / 4,
                              height: MediaQuery.of(context).size.height / 3,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(PerjalananDinasIndex());
                                },
                                child: Card(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12))
                                  ),
                                  color: Colors.white,
                                  shadowColor: Colors.black,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 7.sp, top: 10.sp, bottom: 10.sp, right: 7.sp),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset('images/NewEmployeeRequest.png'),
                                        SizedBox(height: 15.sp,),
                                        Text('Perjalanan Dinas',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                          )
                                        ),
                                        SizedBox(height: 7.sp,),
                                        Text('Fitur segera hadir! Tetap tunggu kabar lebih lanjut tentang fitur menarik yang akan segera kami luncurkan',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color.fromRGBO(116, 116, 116, 1),
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w400,
                                          )
                                        )
                                      ],
                                    ),
                                  )
                                ),
                              ),
                            ),
                            //card kedua
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 310.sp) / 4,
                              height: MediaQuery.of(context).size.height / 3,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(PinjamanKaryawanIndex());
                                },
                                child: Card(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12))
                                  ),
                                  color: Colors.white,
                                  shadowColor: Colors.black,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 7.sp, top: 10.sp, bottom: 10.sp, right: 7.sp),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset('images/NewEmployeeRequest.png'),
                                        SizedBox(height: 15.sp,),
                                        Text('Pinjaman Karyawan',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                          )
                                        ),
                                        SizedBox(height: 7.sp,),
                                        Text('Fitur segera hadir! Tetap tunggu kabar lebih lanjut tentang fitur menarik yang akan segera kami luncurkan',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color.fromRGBO(116, 116, 116, 1),
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w400,
                                          )
                                        )
                                      ],
                                    ),
                                  )
                                ),
                              ),
                            ),
                            //card ketiga
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 310.sp) / 4,
                              height: MediaQuery.of(context).size.height / 3,
                              child: GestureDetector(
                                onTap: () {
                                 
                                },
                                child: Card(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12))
                                  ),
                                  color: Colors.white,
                                  shadowColor: Colors.black,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 7.sp, top: 10.sp, bottom: 10.sp, right: 7.sp),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset('images/NewEmployeeRequest.png'),
                                        SizedBox(height: 15.sp,),
                                        Text('Soon',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                          )
                                        ),
                                        SizedBox(height: 7.sp,),
                                        Text('Fitur segera hadir! Tetap tunggu kabar lebih lanjut tentang fitur menarik yang akan segera kami luncurkan',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color.fromRGBO(116, 116, 116, 1),
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w400,
                                          )
                                        )
                                      ],
                                    ),
                                  )
                                ),
                              ),
                            ),
                            //card keempat
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 310.sp) / 4,
                              height: MediaQuery.of(context).size.height / 3,
                              child: GestureDetector(
                                onTap: () {
                                  
                                },
                                child: Card(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12))
                                  ),
                                  color: Colors.white,
                                  shadowColor: Colors.black,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 7.sp, top: 10.sp, bottom: 10.sp, right: 7.sp),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset('images/NewEmployeeRequest.png'),
                                        SizedBox(height: 15.sp,),
                                        Text('Soon',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                          )
                                        ),
                                        SizedBox(height: 7.sp,),
                                        Text('Fitur segera hadir! Tetap tunggu kabar lebih lanjut tentang fitur menarik yang akan segera kami luncurkan',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color.fromRGBO(116, 116, 116, 1),
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w400,
                                          )
                                        )
                                      ],
                                    ),
                                  )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}
