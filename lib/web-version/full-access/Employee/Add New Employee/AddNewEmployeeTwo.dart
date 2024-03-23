// ignore_for_file: non_constant_identifier_names, file_names, avoid_print, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations

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
import 'package:hr_systems_web/web-version/full-access/Employee/Add%20New%20Employee/AddNewEmployeeEight.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Add%20New%20Employee/AddNewEmployeeFive.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Add%20New%20Employee/AddNewEmployeeFour.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Add%20New%20Employee/AddNewEmployeeSeven.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Add%20New%20Employee/AddNewEmployeeSix.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Add%20New%20Employee/AddNewEmployeeThree.dart';

import '../../../login.dart';
import '../../employee.dart';
import '../../index.dart';
import 'AddNewEmployeeFirst.dart';

class AddNewEmployeeTwo extends StatefulWidget {
  const AddNewEmployeeTwo({super.key});

  @override
  State<AddNewEmployeeTwo> createState() => _AddNewEmployeeTwoState();
}

class _AddNewEmployeeTwoState extends State<AddNewEmployeeTwo> {
  bool KTPDomisili = true;

  TextEditingController alamatKTP = TextEditingController();
  TextEditingController rtKTP = TextEditingController();
  TextEditingController rwKTP = TextEditingController();
  TextEditingController alamatDomisili = TextEditingController();
  TextEditingController rtDomisili = TextEditingController();
  TextEditingController rwDomisili = TextEditingController();
  TextEditingController nomorHandphone = TextEditingController();
  TextEditingController alamatEmail = TextEditingController();

  String nomorHandphoneText = '';
  String alamatEmailText = '';
  String id = '';

  String? selectedDomicileProvince;
  String? selectedIdentityProvince;
  List<Map<String, String>> provinceList = [];

  String? selectedDomicileCity;
  String? selectedIdentityCity;
  List<Map<String, String>> domicileCityList = [];
  List<Map<String, String>> identityCityList = [];

  String? selectedDomicileRegency;
  String? selectedIdentityRegency;
  List<Map<String, String>> domicileRegencyList = [];
  List<Map<String, String>> identityRegencyList = [];

  String? selectedDomicileDistrict;
  String? selectedIdentityDistrict;
  List<Map<String, String>> domicileDistrictList = [];
  List<Map<String, String>> identityDistrictList = [];

  String? selectedAddressStatus;
  List<Map<String, String>> addressStatuses = [];
  String? selectedAddressStatus2;
  List<Map<String, String>> addressStatuses2 = [];

  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
String trimmedCompanyAddress = '';
  List<dynamic> profileData = [];

  @override
  void initState() {
    super.initState();
    fetchProvinceList();
    fetchAddressStatuses();
    fetchAddressStatuses2();
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

  Future<void> fetchProvinceList() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getprovince.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        final provinces = (data['Data'] as List)
            .map((province) => Map<String, String>.from({
                  'id': province['id'],
                  'name': province['name'],
                }))
            .toList();

        setState(() {
          provinceList = provinces;
          if (provinceList.isNotEmpty) {
            selectedDomicileProvince = provinceList[0]['id'];
            selectedIdentityProvince = provinceList[0]['id'];
          }
        });
      } else {
        // Handle API error
        print('Failed to fetch province list');
      }
    } else {
      // Handle HTTP error
      print('Failed to fetch data');
    }
  }

  Future<void> fetchCityList(String? provinceId, bool isDomicile) async {
    if (provinceId != null) {
      final response = await http.get(
          Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getkotakab.php?provinsi=$provinceId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['StatusCode'] == 200) {
          final cities = (data['Data'] as List)
              .map((city) => Map<String, String>.from({
                    'id': city['id'],
                    'name': city['name'],
                  }))
              .toList();

          setState(() {
            if (isDomicile) {
              domicileCityList = cities;
              selectedDomicileCity = domicileCityList.isNotEmpty ? domicileCityList[0]['id'] : null;
            } else {
              identityCityList = cities;
              selectedIdentityCity = identityCityList.isNotEmpty ? identityCityList[0]['id'] : null;
            }
          });
        } else {
          print('Failed to fetch city list');
        }
      } else {
        print('Failed to fetch data');
      }
    }
  }
  
  Future<void> fetchRegencyList(String? cityId, bool isDomicile) async {
    if (cityId != null) {
      final response = await http.get(
          Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getkecamatan.php?kotakab=$cityId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['StatusCode'] == 200) {
          final regencies = (data['Data'] as List)
              .map((regency) => Map<String, String>.from({
                    'id': regency['id'],
                    'name': regency['name'],
                  }))
              .toList();

          setState(() {
            if (isDomicile) {
              domicileRegencyList = regencies;
              selectedDomicileRegency = domicileRegencyList.isNotEmpty ? domicileRegencyList[0]['id'] : null;
            } else {
              identityRegencyList = regencies;
              selectedIdentityRegency = identityRegencyList.isNotEmpty ? identityRegencyList[0]['id'] : null;
            }
          });
        } else {
          print('Failed to fetch regency list');
        }
      } else {
        print('Failed to fetch data');
      }
    }
  }
  
  Future<void> fetchDistrictList(String? regencyId, bool isDomicile) async {
    if (regencyId != null) {
      final response = await http.get(
          Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getkelurahan.php?kecamatan=$regencyId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['StatusCode'] == 200) {
          final districts = (data['Data'] as List)
              .map((district) => Map<String, String>.from({
                    'id': district['id'],
                    'name': district['name'],
                  }))
              .toList();

          setState(() {
            if (isDomicile) {
              domicileDistrictList = districts;
              selectedDomicileDistrict = domicileDistrictList.isNotEmpty ? domicileDistrictList[0]['id'] : null;
            } else {
              identityDistrictList = districts;
              selectedIdentityDistrict = identityDistrictList.isNotEmpty ? identityDistrictList[0]['id'] : null;
            }
          });
        } else {
          print('Failed to fetch district list');
        }
      } else {
        print('Failed to fetch data');
      }
    }
  }

  Future<void> fetchAddressStatuses() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getaddressstatus.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        final addressStatusList = (data['Data'] as List)
            .map((addressStatus) => Map<String, String>.from({
                  'address_status_id': addressStatus['address_status_id'],
                  'address_status_name': addressStatus['address_status_name'],
                }))
            .toList();

        setState(() {
          addressStatuses = addressStatusList;
          if (addressStatuses.isNotEmpty) {
            selectedAddressStatus = addressStatuses[0]['address_status_id'];
          }
        });
      } else {
        // Handle API error
        print('Failed to fetch address statuses');
      }
    } else {
      // Handle HTTP error
      print('Failed to fetch data');
    }
  }

  Future<void> fetchAddressStatuses2() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getaddressstatus.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        final addressStatusList2 = (data['Data'] as List)
            .map((addressStatus2) => Map<String, String>.from({
                  'address_status_id': addressStatus2['address_status_id'],
                  'address_status_name': addressStatus2['address_status_name'],
                }))
            .toList();

        setState(() {
          addressStatuses2 = addressStatusList2;
          if (addressStatuses2.isNotEmpty) {
            selectedAddressStatus2 = addressStatuses2[0]['address_status_id'];
          }
        });
      } else {
        // Handle API error
        print('Failed to fetch address statuses');
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


  Future<void> insertEmployee() async {
    try{
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/insertemployee/inserttwo.php';

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "employee_address_ktp": alamatKTP.text,
          "employee_address_status_ktp": selectedAddressStatus,
          "employee_rt_ktp": rtKTP.text,
          "employee_rw_ktp": rwKTP.text,
          "employee_provinsi_ktp": selectedIdentityProvince,
          "employee_kota_kab_ktp": selectedIdentityCity,
          "employee_kec_ktp": selectedIdentityRegency,
          "employee_kel_ktp": selectedIdentityDistrict,
          "employee_address_now": alamatDomisili.text,
          "employee_address_status_now": selectedAddressStatus2,
          "employee_rt_now": rtDomisili.text,
          "employee_rw_now": rwDomisili.text,
          "employee_provinsi_now": selectedDomicileProvince,
          "employee_kot_kab_now": selectedDomicileCity,
          "employee_kec_now": selectedDomicileRegency,
          "employee_kel_now": selectedDomicileDistrict,
          "employee_email": alamatEmailText,
          "employee_phone_number": nomorHandphoneText,
          "id": id,
        }
      );

      if (response.statusCode == 200) {
        print('Employee inserted successfully');
        Get.to(const AddNewEmployeeThree());
        // Add any additional logic or UI updates after successful insertion
      } else {
        Get.snackbar('Gagal', '${response.body}');
        print('Failed to insert employee. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Handle the error or show an error message to the user
      }

    } catch (e){
      Get.snackbar('Gagal', '$e');
      print('Exception during API call: $e');
      // Handle exceptions or show an error message to the user
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
      title: "Tambah Karyawan - Data Alamat",
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
                  padding: EdgeInsets.only(left: 7.w, right: 7.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 100.sp,),
                      //statistik card
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 165.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Alamat sesuai KTP",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: alamatKTP,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alamat sesuai KTP'
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
                            width: (MediaQuery.of(context).size.width- 170.w) / 8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("RT",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: rtKTP,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: '000'
                                  ),
                                  readOnly: false,
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
                                Text("RW",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: rwKTP,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: '000'
                                  ),
                                  readOnly: false,
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
                                Text("Status",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DropdownButtonFormField<String>(
                                  value: selectedAddressStatus,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedAddressStatus = newValue;
                                    });
                                  },
                                  items: addressStatuses.map<DropdownMenuItem<String>>(
                                    (Map<String, String> status) {
                                      return DropdownMenuItem<String>(
                                        value: status['address_status_id']!,
                                        child: Text(status['address_status_name']!),
                                      );
                                    },
                                  ).toList(),
                                ),
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
                                Text("Provinsi",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DropdownButtonFormField<String>(
                                  hint: const Text("Pilih provinsi"),
                                  value: selectedIdentityProvince,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedIdentityProvince = newValue;
                                      fetchCityList(selectedIdentityProvince, false);
                                    });
                                  },
                                  items: provinceList.map<DropdownMenuItem<String>>(
                                    (Map<String, String> province) {
                                      return DropdownMenuItem<String>(
                                        value: province['id']!,
                                        child: Text(province['name']!),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.sp,),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 170.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Kota/Kab",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DropdownButtonFormField<String>(
                                  hint: const Text("Pilih kota/kabupaten KTP"),
                                  value: selectedIdentityCity,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedIdentityCity = newValue;
                                      fetchRegencyList(selectedIdentityCity, false);
                                    });
                                  },
                                  items: identityCityList.map<DropdownMenuItem<String>>(
                                    (Map<String, String> city) {
                                      return DropdownMenuItem<String>(
                                        value: city['id']!,
                                        child: Text(city['name']!),
                                      );
                                    },
                                  ).toList(),
                                ),
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
                                Text("Kecamatan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DropdownButtonFormField<String>(
                                  hint: const Text("Pilih kecamatan"),
                                  value: selectedIdentityRegency,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedIdentityRegency = newValue;
                                      fetchDistrictList(selectedIdentityRegency, false);
                                    });
                                  },
                                  items: identityRegencyList.map<DropdownMenuItem<String>>(
                                    (Map<String, String> regency) {
                                      return DropdownMenuItem<String>(
                                        value: regency['id']!,
                                        child: Text(regency['name']!),
                                      );
                                    },
                                  ).toList(),
                                ),
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
                                Text("Kelurahan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DropdownButtonFormField<String>(
                                  hint: const Text('Pilih kelurahan'),
                                  value: selectedIdentityDistrict,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedIdentityDistrict = newValue;
                                    });
                                  },
                                  items: identityDistrictList.map<DropdownMenuItem<String>>(
                                    (Map<String, String> district) {
                                      return DropdownMenuItem<String>(
                                        value: district['id']!,
                                        child: Text(district['name']!),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.sp,),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 165.w),
                            child: CheckboxListTile(
                              title: const Text('Alamat domisili sama dengan alamat KTP'),
                              value: KTPDomisili,
                              onChanged:(value) { 
                                setState(() {
                                  KTPDomisili = !KTPDomisili;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 30.sp,),
                      if(KTPDomisili == false)
                        Row(
                          children: [
                            SizedBox(
                            width: (MediaQuery.of(context).size.width- 165.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Alamat domisili",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: alamatDomisili,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alamat domisili anda saat ini'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          ],
                        ),
                        SizedBox(height: 30.sp,),
                      if (KTPDomisili == false) 
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width- 170.w) / 8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("RT",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  TextFormField(
                                    controller: rtDomisili,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: '000'
                                    ),
                                    readOnly: false,
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
                                  Text("RW",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  TextFormField(
                                    controller: rwDomisili,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: '000'
                                    ),
                                    readOnly: false,
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
                                  Text("Status",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    hint: const Text('Pilih status domisili'),
                                    value: selectedAddressStatus2,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAddressStatus2 = newValue;
                                      });
                                    },
                                    items: addressStatuses2.map<DropdownMenuItem<String>>(
                                      (Map<String, String> status2) {
                                        return DropdownMenuItem<String>(
                                          value: status2['address_status_id']!,
                                          child: Text(status2['address_status_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
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
                                  Text("Provinsi",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    hint: const Text('Pilih provinsi'),
                                    value: selectedDomicileProvince,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedDomicileProvince = newValue;
                                        fetchCityList(selectedDomicileProvince, true);
                                      });
                                    },
                                    items: provinceList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> province) {
                                        return DropdownMenuItem<String>(
                                          value: province['id']!,
                                          child: Text(province['name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.sp,),
                      if (KTPDomisili == false) 
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width- 170.w) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Kota/Kab",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    hint: const Text('Pilih kota/kab domisili'),
                                    value: selectedDomicileCity,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedDomicileCity = newValue;
                                        fetchRegencyList(selectedDomicileCity, true);
                                      });
                                    },
                                    items: domicileCityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> city) {
                                        return DropdownMenuItem<String>(
                                          value: city['id']!,
                                          child: Text(city['name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
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
                                  Text("Kecamatan",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    hint: const Text('Pilih kecamatan domisili'),
                                    value: selectedDomicileRegency,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedDomicileRegency = newValue;
                                        fetchDistrictList(selectedDomicileRegency, true);
                                      });
                                    },
                                    items: domicileRegencyList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> regency) {
                                        return DropdownMenuItem<String>(
                                          value: regency['id']!,
                                          child: Text(regency['name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
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
                                  Text("Kelurahan",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    hint: const Text('Pilih keluarahan domisili'),
                                    value: selectedDomicileDistrict,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedDomicileDistrict = newValue;
                                      });
                                    },
                                    items: domicileDistrictList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> district) {
                                        return DropdownMenuItem<String>(
                                          value: district['id']!,
                                          child: Text(district['name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      if(KTPDomisili == false)                       
                        SizedBox(height: 30.sp,),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 170.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Alamat Email",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: alamatEmail,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alamat email karyawan'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 170.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nomor Handphone",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: nomorHandphone,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nomor handphone karyawan'
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
                          if (KTPDomisili == true) {
                            alamatDomisili.text = alamatKTP.text;
                            rtDomisili.text = rtKTP.text;
                            rwDomisili.text = rwKTP.text;
                            selectedDomicileProvince = selectedIdentityProvince;
                            selectedDomicileCity = selectedIdentityCity;
                            selectedDomicileRegency = selectedIdentityRegency;
                            selectedDomicileDistrict = selectedIdentityDistrict;
                          }

                          nomorHandphoneText = nomorHandphone.text;
                          alamatEmailText = alamatEmail.text;
                        
                          insertEmployee();
                          
                          //Get.to(const AddNewEmployeeThree());
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
                                          color: const Color.fromRGBO(78, 195, 252, 1)
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