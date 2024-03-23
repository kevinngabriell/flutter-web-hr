// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/RequestNewEmployee.dart';
import 'package:hr_systems_web/web-version/full-access/Event/event.dart';
import 'package:hr_systems_web/web-version/full-access/Performance/performance.dart';
import 'package:hr_systems_web/web-version/full-access/Report/report.dart';
import 'package:hr_systems_web/web-version/full-access/Salary/salary.dart';
import 'package:hr_systems_web/web-version/full-access/Settings/setting.dart';
import 'package:hr_systems_web/web-version/full-access/Structure/structure.dart';
import 'package:hr_systems_web/web-version/full-access/Training/traning.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import '../../login.dart';
import '../employee.dart';
import '../index.dart';

class ViewApproveNewEmployeeRequest extends StatefulWidget {
  final String requestID;

  ViewApproveNewEmployeeRequest(this.requestID);

  @override
  State<ViewApproveNewEmployeeRequest> createState() => _ViewApproveNewEmployeeRequestState();
}

class _ViewApproveNewEmployeeRequestState extends State<ViewApproveNewEmployeeRequest> {
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();

  String RequestNumber = '';
  String RequestorEmployeeName = '';
  String RequestorEmployeePosition = '';
  String RequestorEmployeeDepartement = '';
  String RequestPosition = '';
  String RequestCount = '';
  String RequestReason = '';
  String RequestGender = '';
  String RequestHubunganKerja = '';
  String RequestStatus = '';
  String RequestMinUsia = '';
  String RequestMaxUsia = '';
  String RequestTinggiBadan = '';
  String RequestBeratBadan = '';
  String RequestFakultas = '';
  String RequestJurusan = '';
  String RequestIPK = '';
  String RequestLamaPengalaman = '';
  String RequestPeran = '';
  String RequestKeahlianLain = '';
  String RequestKualifikasiName = '';
  String RequestKualifikasiDept = '';
  String RequestKualifikasiPost = '';
  String RequestPIC = '';
  String RequestRincianTugas = '';
  String RequestTanggalMulai = '';
  String RequestCatatanLainnya = '';
  String RequestLastStatus = '';

  TextEditingController txtPosisiJobAds = TextEditingController();
  TextEditingController txtJobDescAds = TextEditingController();
  TextEditingController txtCriteriaJobAds = TextEditingController();
  String locationJobAds = '';

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchEmployeeRequestDetail();
    fetchEmployeeRequestDetailKualifikasi();
    fetchEmployeeRequestDetailPIC();
  }

  Future<void> fetchEmployeeRequestDetail() async {
    try {
      String request_id = widget.requestID;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/requestemployee/getdetailemployeerequest.php?request_id=$request_id';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('Data') && responseData['Data'] is List && (responseData['Data'] as List).isNotEmpty) {

          Map<String, dynamic> data = (responseData['Data'] as List).first;
           setState(() {
              RequestNumber = data['id_new_employee_request'];
              RequestorEmployeeName = data['employee_name'];
              RequestorEmployeePosition = data['position_name'];
              RequestorEmployeeDepartement = data['department_name'];
              RequestPosition = data['posisi_diajukan'];
              RequestCount = data['jumlah_karyawan_diajukan'];
              RequestReason = data['request_reason'];
              RequestGender = data['gender_name'];
              RequestHubunganKerja = data['hubungan_kerja_name'];
              RequestStatus = data['status_name'];
              RequestMinUsia = data['minimal_usia'];
              RequestMaxUsia = data['maksimal_usia'];
              RequestTinggiBadan = data['tinggi_badan'];
              RequestBeratBadan = data['berat_badan'];
              RequestFakultas = data['fakultas'];
              RequestJurusan = data['jurusan'];
              RequestIPK = data['ipk'];
              RequestLamaPengalaman = data['lama_pengalaman'];
              RequestPeran = data['peran'];
              RequestKeahlianLain = data['keahlian_lain'];
              RequestRincianTugas = data['rincian_tugas'];
              RequestTanggalMulai = data['mulai_kerja'];
              RequestCatatanLainnya = data['catatan_lain'];
              RequestLastStatus = data['last_status'];
            });
        } else {
          print('Data is null or not found in the response data.');
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchEmployeeRequestDetailKualifikasi() async {
    try {
      String request_id = widget.requestID;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/requestemployee/getdetailemployeerequestkualifikasi.php?request_id=$request_id';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('Data') && responseData['Data'] is List && (responseData['Data'] as List).isNotEmpty) {

          Map<String, dynamic> data = (responseData['Data'] as List).first;
           setState(() {
              RequestKualifikasiName = data['employee_name'];
              RequestKualifikasiDept = data['department_name'];
              RequestKualifikasiPost = data['position_name'];
              
            });
        } else {
          print('Data is null or not found in the response data.');
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchEmployeeRequestDetailPIC() async {
    try {
      String request_id = widget.requestID;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/requestemployee/getdetailemployeerequestpic.php?request_id=$request_id';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('Data') && responseData['Data'] is List && (responseData['Data'] as List).isNotEmpty) {

          Map<String, dynamic> data = (responseData['Data'] as List).first;
           setState(() {
              RequestPIC = data['employee_name'];
              print(RequestPIC);
            });
        } else {
          print('Data is null or not found in the response data.');
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

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
  
  Future<void> approvebyHR() async {
    try{
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/requestemployee/updatenewemployeerequestapprovebyhr.php';
      String request_id = widget.requestID;

      String employeeId = storage.read('employee_id').toString();

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'request_id': request_id,
          'employee_id': employeeId
        }
      );

      if(response.statusCode == 200){
        Get.to(FullIndexWeb(employeeId));
      } else {
        Get.snackbar('Error : ', response.body);
        print('Response body: ${response.body}');
      }

    } catch (e) {
      print('Exception: $e');
      Get.snackbar('Error', 'An error occurred. Please try again later.');
    }

  }

  Future<void> rejectbyHR() async {
    try{
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/requestemployee/updatenewemployeerequestrejectbyhr.php';
      String request_id = widget.requestID;

      String employeeId = storage.read('employee_id').toString();

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'request_id': request_id,
          'employee_id': employeeId
        }
      );

      if(response.statusCode == 200){
        Get.to(FullIndexWeb(employeeId));
      } else {
        Get.snackbar('Error : ', response.body);
        print('Response body: ${response.body}');
      }

    } catch (e) {
      print('Exception: $e');
      Get.snackbar('Error', 'An error occurred. Please try again later.');
    }

  }

  Future<void> approvebyDirector() async {
    try{
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/requestemployee/updatenewemployeerequestapprovebydirector.php';
      String request_id = widget.requestID;

      String employeeId = storage.read('employee_id').toString();

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'request_id': request_id,
          'employee_id': employeeId
        }
      );

      if(response.statusCode == 200){
        Get.to(FullIndexWeb(employeeId));
      } else {
        Get.snackbar('Error : ', response.body);
        print('Response body: ${response.body}');
      }

    } catch (e) {
      print('Exception: $e');
      Get.snackbar('Error', 'An error occurred. Please try again later.');
    }

  }

  Future<void> rejectbyDirector() async {
    try{
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/requestemployee/updatenewemployeerequestrejectbydirector.php';
      String request_id = widget.requestID;

      String employeeId = storage.read('employee_id').toString();

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'request_id': request_id,
          'employee_id': employeeId
        }
      );

      if(response.statusCode == 200){
        Get.to(FullIndexWeb(employeeId));
      } else {
        Get.snackbar('Error : ', response.body);
        print('Response body: ${response.body}');
      }

    } catch (e) {
      print('Exception: $e');
      Get.snackbar('Error', 'An error occurred. Please try again later.');
    }

  }

  Future<void> insertJobAds() async {
    try{
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/requestemployee/createnewjobads.php';

      String employeeId = storage.read('employee_id').toString(); // replace with your logic to get employee ID
      DateTime dateNow = DateTime.now();

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "employeeId": '0000000015',
          "request_id": widget.requestID,
          "job_title": txtPosisiJobAds.text,
          "job_desc": txtJobDescAds.text,
          "criteria": txtCriteriaJobAds.text,
          "location": locationJobAds
        }
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Sukses"),
              content: const Text("Iklan lowongan pekerjaan baru telah berhasil dibuat"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.to(FullIndexWeb(employeeId));
                  }, 
                  child: const Text("Kembali ke halaman utama")
                ),
                TextButton(
                  onPressed: () {
                    Get.to(const RequestNewEmployee());
                  }, 
                  child: const Text("Oke")
                )
              ],
            );
          }
        );
        // Add any additional logic or UI updates after successful insertion
      } else {
        Get.snackbar('Gagal', response.body);
        // Handle the error or show an error message to the user
      }

    } catch (e){
      Get.snackbar('Gagal', '$e');
      // Handle exceptions or show an error message to the user
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

    return MaterialApp(
      title: "$RequestPosition - New Request Employee",
      home: Scaffold(
        body: SingleChildScrollView(
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
                          companyName,
                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w300),
                        ),
                        subtitle: Text(
                          trimmedCompanyAddress,
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
                              onPressed: () {Get.to(EmployeePage(employee_id: employeeId,));},
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
              //content menu
              Expanded(
                flex: 8,
                child: Padding(
                  padding: EdgeInsets.only(left: 7.w, right: 7.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15.sp,),
                      //Profile Name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 5,
                            child: ListTile(
                              contentPadding: const EdgeInsets.only(left: 0, right: 0),
                                dense: true,
                                horizontalTitleGap: 20.0,
                              leading: Container(
                                margin: const EdgeInsets.only(right: 2.0),
                                child: Image.memory(
                                  base64Decode(photo),
                                ),
                              ),
                              title: Text(employeeName,
                                style: TextStyle( fontSize: 15.sp, fontWeight: FontWeight.w300,),
                              ),
                              subtitle: Text(employeeEmail,
                                style: TextStyle( fontSize: 15.sp, fontWeight: FontWeight.w300,),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.sp,),
                      Text("DATA KARYAWAN", 
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 20.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nomor",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestNumber)
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nama",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestorEmployeeName)
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Jabatan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestorEmployeePosition)
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Departemen",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestorEmployeeDepartement)
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Posisi yang diusulkan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestPosition)
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Jumlah yang diusulkan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestCount)
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 50.sp,),
                      Text("ALASAN KARYAWAN", 
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 20.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Alasan Pengadaan Karyawan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestReason)
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Jenis kelamin",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestGender)
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Status karyawan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestHubunganKerja)
                              ],
                            ),
                          ),
                          
                        ],
                      ),
                      SizedBox(height: 50.sp,),
                      Text("SYARAT UMUM", 
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 20.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Status",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestStatus)
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Minimal usia",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestMinUsia)
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Maksimal usia",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestMaxUsia)
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Tinggi badan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestTinggiBadan)
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Berat badan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestBeratBadan)
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                        ],
                      ),
                      SizedBox(height: 50.sp,),
                      Text("SYARAT KHUSUS", 
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 20.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Fakultas",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestFakultas)
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Jurusan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestJurusan)
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("IPK",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestIPK)
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Lama pengalaman",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestLamaPengalaman)
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Peran",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestPeran)
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Keahilan lain",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestKeahlianLain)
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50.sp,),
                      Text("KUALIFIKASI", 
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 20.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 120.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nama",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestKualifikasiName)
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Jabatan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestKualifikasiPost)
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Departemen",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestKualifikasiDept)
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50.sp,),
                      Text("LAINNYA", 
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 20.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 120.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("PIC karyawan baru",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestPIC)
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Rincian tugas",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestRincianTugas)
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Tanggal mulai kerja",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestTanggalMulai)
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 150.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Catatan lainnya",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                Text(RequestCatatanLainnya)
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50.sp,),
                      if(RequestLastStatus == 'Menunggu persetujuan HRD')
                        if(positionId == 'POS-HR-002')
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  approvebyHR();
                                
                                }, 
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(0.sp, 45.sp),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: const Color(0xFF26C749),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Menyetujui')
                              ),
                              SizedBox(width: 10.w,),
                              ElevatedButton(
                                onPressed: () {
                                  rejectbyHR();
                                }, 
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(0.sp, 45.sp),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: const Color(0xffBB1717),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Menolak')
                              ),
                            ],
                          ),
                          SizedBox(height: 30.h,)
                      , if(RequestLastStatus == 'Menunggu Persetujuan Direktur')
                        if(positionId == 'POS-HR-008')
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  approvebyDirector();
                                }, 
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(0.sp, 45.sp),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: const Color(0xFF26C749),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Menyetujui')
                              ),
                              SizedBox(width: 10.w,),
                              ElevatedButton(
                                onPressed: () {
                                  rejectbyDirector();
                                }, 
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(0.sp, 45.sp),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: const Color(0xffBB1717),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Menolak')
                              ),
                            ],
                          ),
                          SizedBox(height: 30.h,)
                      , if(RequestLastStatus == 'Permintaan karyawan telah disetujui')
                        if(positionId == 'POS-HR-002')
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context, 
                                    builder: (_) {
                                      return AlertDialog(
                                        title: const Text('Atur Lowongan Pekerjaan'),
                                        content: SizedBox(
                                          width: MediaQuery.of(context).size.width / 2,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('Posisi', textAlign: TextAlign.start,),
                                              SizedBox(height: 7.h,),
                                              TextFormField(
                                                controller: txtPosisiJobAds,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                ),
                                              ),
                                              SizedBox(height: 20.h,),
                                              const Text('Deskripsi pekerjaan'),
                                              SizedBox(height: 7.h,),
                                              TextFormField(
                                                controller: txtJobDescAds,
                                                maxLines: 3,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                ),
                                              ),
                                              SizedBox(height: 20.h,),
                                              const Text('Kualifikasi'),
                                              SizedBox(height: 7.h,),
                                              TextFormField(
                                                controller: txtCriteriaJobAds,
                                                maxLines: 3,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                ),
                                              ),
                                              SizedBox(height: 20.h,),
                                              const Text('Lokasi'),
                                              SizedBox(height: 7.h,),
                                              DropdownButtonFormField(
                                                  value: 'Tangerang, Indonesia',
                                                  items: const [
                                                    DropdownMenuItem(
                                                      value: 'Tangerang, Indonesia',
                                                      child: Text('Tangerang, Indonesia')
                                                    ),
                                                  ], 
                                                  onChanged: (value) {
                                                    locationJobAds = value.toString();
                                                  }
                                                ),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: (){
                                              if(txtPosisiJobAds.text.isEmpty){
                                                showDialog(
                                                  context: context, 
                                                  builder: (_) {
                                                    return AlertDialog(
                                                      title: const Text("Error"),
                                                      content: const Text('Posisi tidak dapat kosong'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {Get.back();},
                                                          child: const Text('Oke'),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                );
                                              } else if (txtJobDescAds.text.isEmpty){
                                                showDialog(
                                                  context: context, 
                                                  builder: (_) {
                                                    return AlertDialog(
                                                      title: const Text("Error"),
                                                      content: const Text('Deskripsi pekerjaan tidak dapat kosong'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {Get.back();},
                                                          child: const Text('Oke'),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                );
                                              } else if (txtCriteriaJobAds.text.isEmpty){
                                                showDialog(
                                                  context: context, 
                                                  builder: (_) {
                                                    return AlertDialog(
                                                      title: const Text("Error"),
                                                      content: const Text('Kualifikasi tidak dapat kosong'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {Get.back();},
                                                          child: const Text('Oke'),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                );
                                              } else {
                                                insertJobAds();
                                              }
                                            }, 
                                            child: const Text('Simpan')
                                          ),
                                          TextButton(
                                            onPressed: (){
                                              Get.back();
                                            }, 
                                            child: const Text('Batal')
                                          )
                                        ]
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
                                child: const Text('Buka lowongan')
                              ),
                            ],
                          ),
                          SizedBox(height: 30.h,)
                      , if(RequestLastStatus == 'Penerimaan Calon Karyawan Baru Dibuka')
                      if(positionId == 'POS-HR-002')
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  
                                
                                }, 
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(0.sp, 45.sp),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: const Color(0xFF26C749),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Tutup Lowongan')
                              ),
                              SizedBox(width: 10.w,),
                              
                            ],
                          ),
                          SizedBox(height: 30.h,),
                      SizedBox(height: 50.sp,),
                    ],
                  ),
                )
              ),
            ],
          )
        ),
      ),
    );
  }
  String formatDate(String inputDate) {
    // Parse the input string to a DateTime object
    DateTime dateTime = DateTime.parse(inputDate);

    // Format the DateTime object as a string in the "dd MM yyyy" format
    String formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);

    return formattedDate;
  }
}