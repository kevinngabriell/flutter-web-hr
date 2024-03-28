// ignore_for_file: file_names, avoid_print, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Add%20New%20Employee/AddNewEmployeeEight.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Add%20New%20Employee/AddNewEmployeeFive.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Add%20New%20Employee/AddNewEmployeeFour.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Add%20New%20Employee/AddNewEmployeeSeven.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Add%20New%20Employee/AddNewEmployeeSix.dart';
import 'package:hr_systems_web/web-version/full-access/Event/event.dart';
import 'package:hr_systems_web/web-version/full-access/Performance/performance.dart';
import 'package:hr_systems_web/web-version/full-access/Report/report.dart';
import 'package:hr_systems_web/web-version/full-access/Salary/salary.dart';
import 'package:hr_systems_web/web-version/full-access/Settings/setting.dart';
import 'package:hr_systems_web/web-version/full-access/Structure/structure.dart';
import 'package:hr_systems_web/web-version/full-access/Training/traning.dart';
import 'package:intl/intl.dart'; 
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../login.dart';
import '../../employee.dart';
import '../../index.dart';
import 'AddNewEmployeeFirst.dart';
import 'AddNewEmployeeTwo.dart';

class AddNewEmployeeThree extends StatefulWidget {
  const AddNewEmployeeThree({super.key});

  @override
  State<AddNewEmployeeThree> createState() => _AddNewEmployeeThreeState();
}

class _AddNewEmployeeThreeState extends State<AddNewEmployeeThree> {
  DateTime? dateTimeDari1;
  DateTime? dateTimeDari2;
  DateTime? dateTimeDari3;
  DateTime? dateTimeSampai1;
  DateTime? dateTimeSampai2;
  DateTime? dateTimeSampai3;

  TextEditingController txtNamaPerusahaan1 = TextEditingController();
  TextEditingController txtJenisUsaha1 = TextEditingController();
  TextEditingController txtPosisi1 = TextEditingController();
  TextEditingController txtAlamat1 = TextEditingController();
  TextEditingController txtAtasan1 = TextEditingController();
  TextEditingController txtGaji1 = TextEditingController();
  TextEditingController txtDeskripsi1 = TextEditingController();
  TextEditingController txtAlasan1 = TextEditingController();
  TextEditingController txtNamaPerusahaan2 = TextEditingController();
  TextEditingController txtJenisUsaha2 = TextEditingController();
  TextEditingController txtPosisi2 = TextEditingController();
  TextEditingController txtAlamat2 = TextEditingController();
  TextEditingController txtAtasan2 = TextEditingController();
  TextEditingController txtGaji2 = TextEditingController();
  TextEditingController txtDeskripsi2 = TextEditingController();
  TextEditingController txtAlasan2 = TextEditingController();
  TextEditingController txtNamaPerusahaan3 = TextEditingController();
  TextEditingController txtJenisUsaha3 = TextEditingController();
  TextEditingController txtPosisi3 = TextEditingController();
  TextEditingController txtAlamat3 = TextEditingController();
  TextEditingController txtAtasan3 = TextEditingController();
  TextEditingController txtGaji3 = TextEditingController();
  TextEditingController txtDeskripsi3 = TextEditingController();
  TextEditingController txtAlasan3 = TextEditingController();
  String id = '';

  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
String trimmedCompanyAddress = '';
  List<dynamic> profileData = [];
  @override
  void initState() {
    super.initState();
    fetchLastID();
    fetchData();
  }

  final storage = GetStorage();

  Future<void> fetchData() async {
    String employeeId = storage.read('employee_id').toString();

    try {
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/account/getprofileforallpage.php';

      //String employeeId = storage.read('employee_id'); // replace with your logic to get employee ID

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
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    }
  }

  Future<void> fetchLastID() async {
  const apiUrl =
      'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getlastidforinput.php';

  try {
    // Making GET request
    final response = await http.get(Uri.parse(apiUrl));

    // Checking if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parsing the response body
      final Map<String, dynamic> responseBody = json.decode(response.body);

      // Extracting the 'Data' array from the response
      final List<dynamic> data = responseBody['Data'];

      // Accessing the first object in the 'Data' array
      final Map<String, dynamic> firstDataObject = data.isNotEmpty ? data[0] : {};

      // Extracting the 'id' value from the first object
      id = firstDataObject['id'];

      // Now you can use the 'id' variable as needed
      print('Last ID: $id');
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
  
  Future<void> insertEmployee() async {
    try{
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/insertemployee/insertthree.php';

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "id": id,
          "company_name_1" : txtNamaPerusahaan1.text,
          "company_position_1" : txtPosisi1.text,
          "company_address_1" : txtAlamat1.text,
          "company_type_1" : txtJenisUsaha1.text,
          "company_start_1" : dateTimeDari1.toString(),
          "company_end_1" : dateTimeSampai1.toString(),
          "company_leader_1" : txtAtasan1.text,
          "company_salary_1" : txtGaji1.text,
          "company_jobdesc_1" : txtDeskripsi1.text,
          "company_leave_1" : txtAlasan1.text,

          "company_name_2" : txtNamaPerusahaan2.text,
          "company_position_2" : txtPosisi2.text,
          "company_address_2" : txtAlamat2.text,
          "company_type_2" : txtJenisUsaha2.text,
          "company_start_2" : dateTimeDari2.toString(),
          "company_end_2" : dateTimeSampai2.toString(),
          "company_leader_2" : txtAtasan2.text,
          "company_salary_2" : txtGaji2.text,
          "company_jobdesc_2" : txtDeskripsi2.text,
          "company_leave_2" : txtAlasan2.text,

          "company_name_3" : txtNamaPerusahaan3.text,
          "company_position_3" : txtPosisi3.text,
          "company_address_3" : txtAlamat3.text,
          "company_type_3" : txtJenisUsaha3.text,
          "company_start_3" : dateTimeDari3.toString(),
          "company_end_3" : dateTimeSampai3.toString(),
          "company_leader_3" : txtAtasan3.text,
          "company_salary_3" : txtGaji3.text,
          "company_jobdesc_3" : txtDeskripsi3.text,
          "company_leave_3" : txtAlasan3.text,
        }
      );

      if (response.statusCode == 200) {
        Get.to(const AddNewEmployeeFour());
        // Add any additional logic or UI updates after successful insertion
      } else {
        Get.snackbar('Gagal', '${response.body}');
        // Handle the error or show an error message to the user
      }

    } catch (e) {
      Get.snackbar('Gagal', '$e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Access the GetStorage instance
    final storage = GetStorage();

    // Retrieve the stored employee_id
    var employeeId = storage.read('employee_id');
    var photo = storage.read('photo');

    return MaterialApp(
      title: "Tambah Karyawan - Informasi Pribadi",
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
              //content menu
              Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.only(left: 7.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 100.sp,),
                      //statistik card
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 170.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nama Perusahaan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtNamaPerusahaan1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama perusahaan'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 170.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Jenis Usaha",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtJenisUsaha1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan jenis usaha perusahaan sebelumnya'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 170.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Posisi",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtPosisi1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan posisi anda'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.sp,),
                      //alamat
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 160.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Alamat",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtAlamat1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alamat perusahaan anda sebelumnya'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.sp,),
                      //dari, sampai, atasan, gaji
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 170.w) / 8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Dari",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DateTimePicker(
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    initialDate: DateTime.now(),
                                    dateMask: 'd MMM yyyy',
                                    onChanged: (value) {
                                      setState(() {
                                        dateTimeDari1 = DateFormat('yyyy-MM-dd').parse(value);
                                        //txtTanggal = value;
                                        //selectedDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(txtTanggal);
                                      });
                                    },
                                  )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 170.w) / 8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Sampai",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DateTimePicker(
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    initialDate: DateTime.now(),
                                    dateMask: 'd MMM yyyy',
                                    onChanged: (value) {
                                      setState(() {
                                        dateTimeSampai1 = DateFormat('yyyy-MM-dd').parse(value);
                                        //txtTanggal = value;
                                        //selectedDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(txtTanggal);
                                      });
                                    },
                                  )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 245.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Atasan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtAtasan1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama atasan anda'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 210.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Gaji",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtGaji1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan gaji anda'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.sp,),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 165.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Dekripsi Pekerjaan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtDeskripsi1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan deskripsi pekerjaan anda sebelumnya'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 165.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Alasan Keluar",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtAlasan1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alasan keluar anda sebelumnya'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.sp,),
                      const Divider(),
                      SizedBox(height: 30.sp,),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 170.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nama Perusahaan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtNamaPerusahaan2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama perusahaan'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 170.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Jenis Usaha",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtJenisUsaha2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan jenis usaha perusahaan sebelumnya'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 170.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Posisi",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtPosisi2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan posisi anda'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.sp,),
                      //alamat
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 160.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Alamat",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtAlamat2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alamat perusahaan anda sebelumnya'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.sp,),
                      //dari, sampai, atasan, gaji
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 170.w) / 8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Dari",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DateTimePicker(
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    initialDate: DateTime.now(),
                                    dateMask: 'd MMM yyyy',
                                    onChanged: (value) {
                                      setState(() {
                                        dateTimeDari2 = DateFormat('yyyy-MM-dd').parse(value);
                                      });
                                    },
                                  )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 170.w) / 8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Sampai",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DateTimePicker(
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    initialDate: DateTime.now(),
                                    dateMask: 'd MMM yyyy',
                                    onChanged: (value) {
                                      setState(() {
                                        dateTimeSampai2 = DateFormat('yyyy-MM-dd').parse(value);
                                      });
                                    },
                                  )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 245.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Atasan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtAtasan2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama atasan anda'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 210.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Gaji",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtGaji2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan gaji anda'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.sp,),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 165.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Dekripsi Pekerjaan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtDeskripsi2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan deskripsi pekerjaan anda sebelumnya'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 165.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Alasan Keluar",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtAlasan2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alasan anda keluar'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.sp,),
                      const Divider(),
                      SizedBox(height: 30.sp,),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 170.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nama Perusahaan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtNamaPerusahaan3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama perusahaan'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 170.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Jenis Usaha",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtJenisUsaha3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan jenis usaha perusahaan sebelumnya'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 170.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Posisi",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtPosisi3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan posisi anda'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.sp,),
                      //alamat
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 160.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Alamat",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtAlamat3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alamat perusahaan anda sebelumnya'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.sp,),
                      //dari, sampai, atasan, gaji
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 170.w) / 8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Dari",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DateTimePicker(
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    initialDate: DateTime.now(),
                                    dateMask: 'd MMM yyyy',
                                    onChanged: (value) {
                                      setState(() {
                                        dateTimeDari3 = DateFormat('yyyy-MM-dd').parse(value);
                                        //txtTanggal = value;
                                        //selectedDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(txtTanggal);
                                      });
                                    },
                                  )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 170.w) / 8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Sampai",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DateTimePicker(
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    initialDate: DateTime.now(),
                                    dateMask: 'd MMM yyyy',
                                    onChanged: (value) {
                                      setState(() {
                                        dateTimeSampai3 = DateFormat('yyyy-MM-dd').parse(value);
                                        //txtTanggal = value;
                                        //selectedDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(txtTanggal);
                                      });
                                    },
                                  )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 245.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Atasan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtAtasan3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama atasan anda'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 210.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Gaji",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtGaji3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan gaji anda sebelumnya'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.sp,),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 165.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Dekripsi Pekerjaan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtDeskripsi3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan deskripsi pekerjaan anda sebelumnya'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 165.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Alasan Keluar",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtAlasan3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alasan anda keluar'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                        onPressed: () {
                          insertEmployee();

                          // print('Nama perusahaan 1 : ' + txtNamaPerusahaan1.text + '\n');
                          // print('Jenis usaha 1 : ' + txtJenisUsaha1.text + '\n');
                          // print('Posisi 1 : ' + txtPosisi1.text + '\n');
                          // print('Alamat perusahaan 1 : ' + txtAlamat1.text + '\n');
                          // print('Dari 1 : ' + dateTimeDari1.toString() + '\n');
                          // print('Sampai 1 : ' + dateTimeSampai1.toString() + '\n');
                          // print('Atasan 1 : ' + txtAtasan1.text + '\n');
                          // print('Gaji 1 : ' + txtGaji1.text + '\n');
                          // print('Deskripsi 1 : ' + txtDeskripsi1.text + '\n');
                          // print('Alasan 1 : ' + txtAlasan1.text + '\n');

                          // print('Nama perusahaan 2 : ' + txtNamaPerusahaan2.text + '\n');
                          // print('Jenis usaha 2 : ' + txtJenisUsaha2.text + '\n');
                          // print('Posisi 2 : ' + txtPosisi2.text + '\n');
                          // print('Alamat perusahaan 2 : ' + txtAlamat2.text + '\n');
                          // print('Dari 2 : ' + dateTimeDari2.toString() + '\n');
                          // print('Sampai 2 : ' + dateTimeSampai2.toString() + '\n');
                          // print('Atasan 2 : ' + txtAtasan2.text + '\n');
                          // print('Gaji 2 : ' + txtGaji2.text + '\n');
                          // print('Deskripsi 2 : ' + txtDeskripsi2.text + '\n');
                          // print('Alasan 2 : ' + txtAlasan2.text + '\n');

                          // print('Nama perusahaan 3 : ' + txtNamaPerusahaan3.text + '\n');
                          // print('Jenis usaha 3 : ' + txtJenisUsaha3.text + '\n');
                          // print('Posisi 3 : ' + txtPosisi3.text + '\n');
                          // print('Alamat perusahaan 3 : ' + txtAlamat3.text + '\n');
                          // print('Dari 3 : ' + dateTimeDari3.toString() + '\n');
                          // print('Sampai 3 : ' + dateTimeSampai3.toString() + '\n');
                          // print('Atasan 3 : ' + txtAtasan3.text + '\n');
                          // print('Gaji 3 : ' + txtGaji3.text + '\n');
                          // print('Deskripsi 3 : ' + txtDeskripsi3.text + '\n');
                          // print('Alasan 3 : ' + txtAlasan3.text + '\n');

                          // Get.to(const AddNewEmployeeFour());
                        }, 
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(0.sp, 45.sp),
                          foregroundColor: const Color(0xFFFFFFFF),
                          backgroundColor: const Color(0xff4ec3fc),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Berikutnya')
                      ),
                        ],
                      ),
                      SizedBox(height: 40.sp,),
                    ],
                  ),
                )
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
                      SizedBox(height: 30.sp,),
                      SizedBox(
                        child: Card(
                          shape: const RoundedRectangleBorder( 
                            borderRadius: BorderRadius.all(Radius.circular(12))
                          ),
                          color: Colors.white,
                          shadowColor: Colors.black,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.495 / 2,
                            child: Padding(
                              padding: EdgeInsets.only(left: 17.sp, top: 5.sp, bottom: 15.sp,right: 7.sp),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.only(top: 15.sp, bottom: 15.sp),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(const AddNewEmployeeOne());
                                      },
                                      child: Text("Informasi pribadi", 
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          //color: const Color.fromRGBO(78, 195, 252, 1)
                                        ),
                                      )
                                    ),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(top: 15.sp, bottom: 15.sp),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(const AddNewEmployeeTwo());
                                      },
                                      child: Text("Data alamat", 
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          //color: const Color.fromRGBO(78, 195, 252, 1)
                                        ),
                                      )
                                    ),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(top: 15.sp, bottom: 15.sp),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(const AddNewEmployeeThree());
                                      },
                                      child: Text("Riwayat kerja", 
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: const Color.fromRGBO(78, 195, 252, 1)
                                        ),
                                      )
                                    ),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(top: 15.sp, bottom: 15.sp),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(const AddNewEmployeeFour());
                                      },
                                      child: Text("Pendidikan", 
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          //color: const Color.fromRGBO(78, 195, 252, 1)
                                        ),
                                      )
                                    ),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(top: 15.sp, bottom: 15.sp),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(const AddNewEmployeeFive());
                                      },
                                      child: Text("Kemampuan bahasa", 
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          //color: const Color.fromRGBO(78, 195, 252, 1)
                                        ),
                                      )
                                    ),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(top: 15.sp, bottom: 15.sp),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(const AddNewEmployeeSix());
                                      },
                                      child: Text("Data keluarga", 
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          //color: const Color.fromRGBO(78, 195, 252, 1)
                                        ),
                                      )
                                    ),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(top: 15.sp, bottom: 15.sp),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(const AddNewEmployeeSeven());
                                      },
                                      child: Text("Pertanyaan", 
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          //color: const Color.fromRGBO(78, 195, 252, 1)
                                        ),
                                      )
                                    ),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(top: 15.sp, bottom: 15.sp),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(const AddNewEmployeeEight());
                                      },
                                      child: Text("Pernyataan", 
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          //color: const Color.fromRGBO(78, 195, 252, 1)
                                        ),
                                      )
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
              ),
            ],
          )
        ),
      ),
    );
  }
}