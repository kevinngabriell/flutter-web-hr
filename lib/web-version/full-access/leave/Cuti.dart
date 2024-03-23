// ignore_for_file: prefer_const_constructors_in_immutables, file_names, unnecessary_string_interpolations, non_constant_identifier_names, avoid_print, use_build_context_synchronously

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Event/event.dart';
import 'package:hr_systems_web/web-version/full-access/Performance/performance.dart';
import 'package:hr_systems_web/web-version/full-access/Report/report.dart';
import 'package:hr_systems_web/web-version/full-access/Salary/salary.dart';
import 'package:hr_systems_web/web-version/full-access/Settings/setting.dart';
import 'package:hr_systems_web/web-version/full-access/Structure/structure.dart';
import 'package:hr_systems_web/web-version/full-access/Training/traning.dart';
import 'package:hr_systems_web/web-version/full-access/leave/ShowAllMyPermission.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../login.dart';
import '../employee.dart';
import '../index.dart';

class CutiPage extends StatefulWidget {
  const CutiPage({super.key});

  @override
  State<CutiPage> createState() => _CutiPageState();
}

class _CutiPageState extends State<CutiPage> {

  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String employeeId = '';
  String departmentName = '';
  String positionName = '';
  String trimmedCompanyAddress = '';
  TextEditingController txtNamaLengkap = TextEditingController();
  TextEditingController txtNIK = TextEditingController();
  TextEditingController txtDepartemen = TextEditingController();
  TextEditingController txtJabatan = TextEditingController();
  List<Map<String, String>> employees = [];
  String? selectedEmployeeId;
  DateTime? TanggalMulaiCuti;
  DateTime? TanggalAkhirCuti;
  TextEditingController cutiPhone = TextEditingController();
  TextEditingController txtAlasan = TextEditingController();
  int? sisaCuti;
  TextEditingController txtSisaCuti = TextEditingController();
  bool isLoading = false;
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDataforFilled();
    fetchEmployeeList();
    fetchAngkaCuti();
  }

  Future<void> fetchAngkaCuti() async {
    String employeeId = storage.read('employee_id').toString();

    try {
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/getangkacutibyid.php?employee_id=$employeeId';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('Data') && responseData['Data'] is List && (responseData['Data'] as List).isNotEmpty) {

          Map<String, dynamic> data = (responseData['Data'] as List).first;
          if (data.containsKey('leave_count') && data['leave_count'] != null) {

            setState(() {
              sisaCuti = int.parse(data['leave_count'].toString());
            });
            
          } else {
            print('leave_count is null or not found in the response data.');
          }
        } else {
          print('Data is null or not found in the response data.');
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchData() async {
    try {
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/account/getprofileforallpage.php';
      String employeeId = storage.read('employee_id').toString(); // replace with your logic to get employee ID

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
          txtNamaLengkap.text = employeeName;
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

  Future<void> fetchDataforFilled() async {
    try {
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/getdataforrequestor.php';

      // Replace 'employee_id' with the actual employee ID from storage
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

        setState(() {
          employeeName = data['Data']['employee_name'] as String;
          employeeId = data['Data']['employee_id'] as String;
          departmentName = data['Data']['department_name'] as String;
          positionName = data['Data']['position_name'] as String;

          txtNIK.text = employeeId;
          txtDepartemen.text = departmentName;
          txtJabatan.text = positionName;
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    } finally {
      isLoading = false;
    }
  }

Future<void> fetchEmployeeList() async {
  String employeeId = storage.read('employee_id').toString();

  try {
    isLoading = true;
    final response = await http.get(Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/getemployeeexceptme.php?employee_id=$employeeId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Check if the response contains the expected key 'Data'
      if (responseData.containsKey('Data')) {
        final List<dynamic> employeeData = responseData['Data'] ?? [];

        setState(() {
          employees = employeeData
              .map<Map<String, String>>((dynamic employee) =>
                  Map<String, String>.from(employee))
              .toList();
        });
      } else {
        print('Expected key "Data" not found in the response data.');
      }
    } else {
      print('Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    isLoading = false;
  }
}

  Future<void> insertCuti() async {
    try{
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/insertpermission.php';

      String employeeId = storage.read('employee_id').toString(); // replace with your logic to get employee ID
      DateTime dateNow = DateTime.now();

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "action" : "3",
          "date_now": dateNow.toString(),
          "employee_id": employeeId,
          "cuti_phone": cutiPhone.text,
          "start_cuti": TanggalMulaiCuti.toString(),
          "end_cuti": TanggalAkhirCuti.toString(),
          "pengganti_cuti": selectedEmployeeId,
          "created_by": employeeId,
          "created_dt": dateNow.toString(),
          "permission_reason": txtAlasan.text
        }
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Sukses"),
              content: const Text("Permohonan cuti tahunan anda telah berhasil diajukan"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.to(FullIndexWeb(employeeId));
                  }, 
                  child: const Text("Kembali ke halaman utama")
                ),
                TextButton(
                  onPressed: () {
                    Get.to(const ShowAllMyPermission());
                  }, 
                  child: const Text("Lihat detail izin")
                )
              ],
            );
          }
        );
        // Add any additional logic or UI updates after successful insertion
      } else if (response.statusCode == 206){
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Gagal"),
              content: const Text("Jatah cuti anda saat ini tidak mencukupi. Silahkan periksa kembali jatah cuti anda !!"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.to(FullIndexWeb(employeeId));
                  }, 
                  child: const Text("Kembali ke halaman utama")
                ),
              ],
            );
          }
        );
      } else {
        Get.snackbar('Gagal', '${response.statusCode}, ${response.body}');
        // Handle the error or show an error message to the user
      }



    } catch (e){
      Get.snackbar('Gagal', '$e');
      // Handle exceptions or show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    var employeeId = storage.read('employee_id');
    var photo = storage.read('photo');
    TextEditingController sisaCutiController = TextEditingController(text: sisaCuti?.toString() ?? '');

    print(sisaCuti);

    return SafeArea(
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 100.sp,),
                      Center(
                        child: Text(
                          "Formulir Pengajuan Cuti Karyawan",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color.fromRGBO(116, 116, 116, 1)
                          ),
                        ),
                      ),
                      SizedBox(height: 30.sp,),
                      Text(
                        "Data Karyawan",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(0, 0, 0, 1)
                        ),
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
                                  "Nama Lengkap",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(116, 116, 116, 1)
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                                if(isLoading)
                                  const CircularProgressIndicator()
                                else
                                  TextFormField(
                                    controller: txtNamaLengkap,
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
                                if(isLoading)
                                  const CircularProgressIndicator()
                                else
                                  TextFormField(
                                    controller: txtNIK,
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
                                  controller: txtDepartemen,
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
                                  controller: txtJabatan,
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
                      SizedBox(height: 30.sp,),
                      Text(
                        "Keterangan Cuti",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(0, 0, 0, 1)
                        ),
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
                                  "Tanggal mulai cuti",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(116, 116, 116, 1)
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                                //DateTime
                                DateTimePicker(
                                  firstDate: DateTime(2023),
                                  lastDate: DateTime(2100),
                                  initialDate: DateTime.now(),
                                  dateMask: 'd MMM yyyy',
                                  onChanged: (value) {
                                    setState(() {
                                      TanggalMulaiCuti = DateFormat('yyyy-MM-dd').parse(value);
                                      //selectedDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(txtTanggal);
                                    });
                                  },
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
                                DateTimePicker(
                                  firstDate: DateTime(2023),
                                  lastDate: DateTime(2100),
                                  initialDate: DateTime.now(),
                                  dateMask: 'd MMM yyyy',
                                  onChanged: (value) {
                                    setState(() {
                                      TanggalAkhirCuti = DateFormat('yyyy-MM-dd').parse(value);
                                      //selectedDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(txtTanggal);
                                    });
                                  },
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
                                  "Sisa cuti berjalan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(116, 116, 116, 1)
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                                
                                TextFormField(
                                  // initialValue: sisaCuti?.toString() ?? '',
                                  controller: sisaCutiController,
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
                                  "Nomor yang bisa dihubungi",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(116, 116, 116, 1)
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: cutiPhone,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nomor yang bisa dihubungi'
                                  ),
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
                                  controller: txtAlasan,
                                  maxLines: 3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan keterangan atau alasan anda'
                                  ),
                                )
                              ],
                            )
                          ),
                          SizedBox(width: 20.sp,),
                          
                        ],
                      ),
                      SizedBox(height: 30.sp,),
                      Text(
                        "Selama Cuti Tugas Digantikan Oleh",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(0, 0, 0, 1)
                        ),
                      ),
                      SizedBox(height: 10.sp,),
                      DropdownButtonFormField<String>(
                        value: selectedEmployeeId,
                        hint: const Text('Pilih karyawan pengganti'),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedEmployeeId = newValue;
                          });
                        },
                        items: employees.map((Map<String, String> employee) {
                          final String? id = employee['id'];
                          final String? employeeName = employee['employee_name'];

                          return DropdownMenuItem<String>(
                            value: id,
                            child: Text(employeeName ?? 'Unknown'),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 40.sp,),
                      ElevatedButton(
                        onPressed: () {
                          insertCuti();
                          // print(employeeId.toString());
                          // print(TanggalMulaiCuti.toString());
                          // print(TanggalAkhirCuti.toString());
                          // print(cutiPhone.toString());
                          // print(txtAlasan);
                          // print(selectedEmployeeId);
                          // insertPermission();
                        }, 
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(0.sp, 45.sp),
                          foregroundColor: const Color(0xFFFFFFFF),
                          backgroundColor: const Color(0xff4ec3fc),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Kumpulkan')
                      ),
                      SizedBox(height: 40.sp,),
                    ],
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
        ),
      ),
    );
  }
}