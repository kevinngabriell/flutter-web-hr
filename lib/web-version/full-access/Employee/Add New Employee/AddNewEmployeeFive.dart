// ignore_for_file: avoid_print, file_names, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations

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
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../login.dart';
import '../../employee.dart';
import '../../index.dart';
import 'AddNewEmployeeEight.dart';
import 'AddNewEmployeeFirst.dart';
import 'AddNewEmployeeFour.dart';
import 'AddNewEmployeeSeven.dart';
import 'AddNewEmployeeSix.dart';
import 'AddNewEmployeeThree.dart';
import 'AddNewEmployeeTwo.dart';

class AddNewEmployeeFive extends StatefulWidget {
  const AddNewEmployeeFive({super.key});

  @override
  State<AddNewEmployeeFive> createState() => _AddNewEmployeeFiveState();
}

class _AddNewEmployeeFiveState extends State<AddNewEmployeeFive> {
  String? selectedAbility;
  String? selectedAbility2;
  String? selectedAbility3;
  String? selectedAbility4;
  String? selectedAbility5;
  String? selectedAbility6;
  String? selectedAbility7;
  String? selectedAbility8;
  String? selectedAbility9;
  String? selectedAbility10;
  String? selectedAbility11;
  String? selectedAbility12;
  String? selectedAbility13;
  String? selectedAbility14;
  String? selectedAbility15;
  String? selectedAbility16;
  List<Map<String, String>> abilityList = [];

  TextEditingController txtBahasa1 = TextEditingController();
  TextEditingController txtBahasa2 = TextEditingController();
  TextEditingController txtBahasa3 = TextEditingController();
  TextEditingController txtBahasa4 = TextEditingController();

  String id = '';
String trimmedCompanyAddress = '';
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';

  List<dynamic> profileData = [];

  @override
  void initState() {
    super.initState();
    fetchAbilityList();
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

  Future<void> fetchAbilityList() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getability.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        final abilities = (data['Data'] as List)
            .map((ability) => Map<String, String>.from({
                  'ability_id': ability['ability_id'],
                  'ability_name': ability['ability_name'],
                }))
            .toList();

        setState(() {
          abilityList = abilities;
          if (abilityList.isNotEmpty) {
            selectedAbility = abilityList[0]['ability_id'];
            selectedAbility2 = abilityList[0]['ability_id'];
            selectedAbility3 = abilityList[0]['ability_id'];
            selectedAbility4 = abilityList[0]['ability_id'];
            selectedAbility5 = abilityList[0]['ability_id'];
            selectedAbility6 = abilityList[0]['ability_id'];
            selectedAbility7 = abilityList[0]['ability_id'];
            selectedAbility8 = abilityList[0]['ability_id'];
            selectedAbility9 = abilityList[0]['ability_id'];
            selectedAbility10 = abilityList[0]['ability_id'];
            selectedAbility11 = abilityList[0]['ability_id'];
            selectedAbility12 = abilityList[0]['ability_id'];
            selectedAbility13 = abilityList[0]['ability_id'];
            selectedAbility14 = abilityList[0]['ability_id'];
            selectedAbility15 = abilityList[0]['ability_id'];
            selectedAbility16 = abilityList[0]['ability_id'];

          }
        });
      } else {
        // Handle API error
        print('Failed to fetch ability list');
      }
    } else {
      // Handle HTTP error
      print('Failed to fetch data');
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

  Future<void> insertemployee() async {
    try{
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/insertemployee/insertfive.php';

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "id": id,
          "language_1" : "Bahasa Indonesia",
          "language_2" : "Bahasa Inggris",
          "language_3" : txtBahasa3.text,
          "language_4" : txtBahasa4.text,
          "ability_1" : selectedAbility,
          "ability_2" : selectedAbility2,
          "ability_3" : selectedAbility3,
          "ability_4" : selectedAbility4,
          "ability_5" : selectedAbility5,
          "ability_6" : selectedAbility6,
          "ability_7" : selectedAbility7,
          "ability_8" : selectedAbility8,
          "ability_9" : selectedAbility9,
          "ability_10" : selectedAbility10,
          "ability_11" : selectedAbility11,
          "ability_12" : selectedAbility12,
          "ability_13" : selectedAbility13,
          "ability_14" : selectedAbility14,
          "ability_15" : selectedAbility15,
          "ability_16" : selectedAbility16,
        }
      );

      if (response.statusCode == 200) {
        print('Employee inserted successfully');
        Get.to(const AddNewEmployeeSix());
        // Add any additional logic or UI updates after successful insertion
      } else {
        Get.snackbar('Gagal', '${response.body}');
      }

    } catch (e) {
      Get.snackbar('Gagal', '$e');
      print('Exception during API call: $e');
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
                      //Bahasa Indonesia
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 110.w) / 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Bahasa",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  //initialValue: 'Bahasa Indonesia',
                                  controller: txtBahasa1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan bahasa indonesia'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 240.w) / 4,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Mendengar",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 240.w) / 4,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Berbicara",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility2,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility2 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 240.w) / 4,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Membaca",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility3,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility3 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 240.w) / 4,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Menulis",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility4,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility4 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                          )
                        ],
                      ),
                      SizedBox(height: 30.sp,),
                      //Bahasa Inggris
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 110.w) / 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Bahasa",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtBahasa2,
                                  //initialValue: 'Bahasa Inggris',
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan bahasa inggris'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 240.w) / 4,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Mendengar",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility5,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility5 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 240.w) / 4,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Berbicara",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility6,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility6 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 240.w) / 4,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Membaca",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility7,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility7 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 240.w) / 4,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Menulis",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility8,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility8 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                          )
                        ],
                      ),
                      SizedBox(height: 30.sp,),
                      //Bahasa 3
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 110.w) / 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Bahasa",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtBahasa3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan bahasa yang anda kuasai'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 240.w) / 4,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Mendengar",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility9,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility9 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 240.w) / 4,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Berbicara",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility10,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility10 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 240.w) / 4,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Membaca",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility11,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility11 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 240.w) / 4,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Menulis",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility12,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility12 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                          )
                        ],
                      ),
                      SizedBox(height: 30.sp,),
                      //Bahasa 4
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 110.w) / 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Bahasa",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtBahasa4,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan bahasa yang anda kuasai'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 240.w) / 4,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Mendengar",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility13,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility13 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 240.w) / 4,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Berbicara",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility14,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility14 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 240.w) / 4,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Membaca",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility15,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility15 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 240.w) / 4,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Menulis",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility16,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility16 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                          )
                        ],
                      ),
                      SizedBox(height: 40.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                        onPressed: () {
                          insertemployee();
                          
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
                      )
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
                                          //color: const Color.fromRGBO(78, 195, 252, 1)
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
                                          color: const Color.fromRGBO(78, 195, 252, 1)
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