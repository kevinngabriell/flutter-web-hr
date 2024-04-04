// ignore_for_file: unused_import, prefer_const_constructors_in_immutables, avoid_print, unnecessary_string_interpolations, non_constant_identifier_names, use_build_context_synchronously, avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data' show Uint8List;
import 'dart:html' as html;
import 'package:camera/camera.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/logout.dart';
import 'package:hr_systems_web/web-version/full-access/Absen/Absence.dart';
import 'package:hr_systems_web/web-version/full-access/Absen/ListEmployeeAbsence.dart';
import 'package:hr_systems_web/web-version/full-access/Absen/VerifyABsence.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/AddRequestNewEmployee.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/RequestNewEmployee.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/ResignForm.dart';
import 'package:hr_systems_web/web-version/full-access/Event/event.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:hr_systems_web/web-version/full-access/Performance/performance.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/AddNewPerjalananDinas.dart';
import 'package:hr_systems_web/web-version/full-access/PinjamanKaryawan/AddPinjamanKaryawan.dart';
import 'package:hr_systems_web/web-version/full-access/Report/report.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/newInventoryRequest.dart';
import 'package:hr_systems_web/web-version/full-access/Salary/salary.dart';
import 'package:hr_systems_web/web-version/full-access/Settings/setting.dart';
import 'package:hr_systems_web/web-version/full-access/Structure/structure.dart';
import 'package:hr_systems_web/web-version/full-access/Training/traning.dart';
import 'package:hr_systems_web/web-version/full-access/employee.dart';
import 'package:hr_systems_web/web-version/full-access/leave/Cuti.dart';
import 'package:hr_systems_web/web-version/full-access/leave/DatangTelat.dart';
import 'package:hr_systems_web/web-version/full-access/leave/Lembur.dart';
import 'package:hr_systems_web/web-version/full-access/leave/PulangAwal.dart';
import 'package:hr_systems_web/web-version/full-access/leave/ShowAllMyPermission.dart';
import 'package:hr_systems_web/web-version/full-access/leave/ShowAllPermission.dart';
import 'package:hr_systems_web/web-version/full-access/leave/Sick.dart';
import 'package:hr_systems_web/web-version/full-access/leave/ViewOnly.dart';
import 'package:hr_systems_web/web-version/full-access/profile.dart';
import 'package:hr_systems_web/web-version/login.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class FullIndexWeb extends StatefulWidget {
  FullIndexWeb(employee_id, {super.key});

  @override
  State<FullIndexWeb> createState() => _FullIndexWebState();
}

class _FullIndexWebState extends State<FullIndexWeb> {
  late SingleValueDropDownController _cnt;
  String? leaveoptions;
  String? requestoptions;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  int? sisaCuti;
  int? angkaHadir;
  int? angkaTelat;
  int? angkaAbsen;
  int? angkaLembur;

  String profilePictureBased64 = '';
  String notificationID = '';

  List<dynamic> profileData = [];
  bool isLoading = false;

  List<Map<String, dynamic>> permissionDataLimit = [];
  List<Map<String, dynamic>> permissionDataLimitApproval = [];
  List<Map<String, dynamic>> permissionDataLimitApprovalHRD = [];
  List<Map<String, dynamic>> noticationList = [];

  late CameraController controller;
  late Future<void> initializeControllerFuture;

  @override
  void initState() {
    _cnt = SingleValueDropDownController();
    super.initState();
    fetchData();
    fetchAngkaCuti();
    fetchAbsenceStatistics();
    fetchBirthday();
    fetchAbsenValidasi();
    fetchPermission();
  }

  void initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.last;
    controller = CameraController(firstCamera, ResolutionPreset.medium);
    initializeControllerFuture = controller.initialize();
  }

  @override
  void dispose() {
    _cnt.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() {
        isLoading = true;
      });
      // Get the current position
      Position position = await Geolocator.getCurrentPosition();

      String employeeId = storage.read('employee_id').toString();
      double targetLatitude;
      double targetLongitude;
      String locationName = '';

      final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/absent/checkabsencelocation.php?employee_id=$employeeId'),
      );

      if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        // Access the 'Data' key which contains a list of items
        List<dynamic> dataList = data['Data'];
        if (dataList.isNotEmpty) {
          // Assuming you want the first item in the list
          Map<String, dynamic> firstItem = dataList[0];

          setState(() async {
            locationName = firstItem['absence_location'] as String;
            targetLongitude = double.parse(firstItem['longitude']?.toString() ?? '0.0');
            targetLatitude = double.parse(firstItem['latitude']?.toString() ?? '0.0');

            if(locationName == "Free"){
              initializeCamera();
              final cameras = await availableCameras();
              final firstCamera = cameras.last;
              if (controller.value.isInitialized) {
                controller.dispose();
              }
              Get.to(Absence(camera: firstCamera));
              setState(() {
                isLoading = false;
              });
            } else {
              LocationPermission permission = await Geolocator.checkPermission();
              if (permission == LocationPermission.denied) {
                permission = await Geolocator.requestPermission();
              }

              if (permission == LocationPermission.deniedForever) {
                // Handle denied forever case
                print("Location permission denied forever");
                return;
              }

              if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
                Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best,);

                double tolerance = 500;

                double distance = Geolocator.distanceBetween(
                  position.latitude,
                  position.longitude,
                  targetLatitude,
                  targetLongitude,
                );

                print("User's Latitude: ${position.latitude}");
                print("User's Longitude: ${position.longitude}");
                print("Target Latitude: $targetLatitude");
                print("Target Longitude: $targetLongitude");
                print("Distance: $distance");

                if (distance <= tolerance) {
                  initializeCamera();
                  final cameras = await availableCameras();
                  final firstCamera = cameras.last;
                  
                 if (controller.value.isInitialized) {
                    controller.dispose();
                  }

                  Get.to(Absence(camera: firstCamera));
                  setState(() {
                    isLoading = false;
                  });
                } else {
                  if (controller.value.isInitialized) {
                    controller.dispose();
                  }
                  setState(() {
                    isLoading = false;
                  });
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Error"),
                      content: Text("Anda berada diluar area kantor dan tidak dapat melakukan absen pada saat ini"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.to(FullIndexWeb(employeeId));
                          },
                          child: Text("OK"),
                        ),
                      ],
                    ),
                  );
                }
              }
            }
          });
        } else {
          throw Exception('No data available in the response.');
        }
      } else {
        throw Exception('Failed to load data. StatusCode: ${data['StatusCode']}');
      }
    } else {
      throw Exception('Failed to load data. Status code: ${response.statusCode}');
    }

      // print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');

    } catch (e) {
      print('Error occurred while getting location: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  final storage = GetStorage();

  List<Map<String, dynamic>> parseEmployeeData(String jsonData) {
    Map<String, dynamic> data = json.decode(jsonData);

    if (data['Status'] == 'Success') {
      List<dynamic> employeeList = data['Data'];

      return List<Map<String, dynamic>>.from(employeeList);
    } else {
      return [];
    }
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
      print('Server Error: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchAbsenValidasi() async {

    try {
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/absent/getvalidationabsence.php';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('Data') && responseData['Data'] is List && (responseData['Data'] as List).isNotEmpty) {

          Map<String, dynamic> data = (responseData['Data'] as List).first;
          if (data.containsKey('not_verified') && data['not_verified'] != null) {

            setState(() {
              angkaAbsen = int.parse(data['not_verified'].toString());
            });
            
          } else {
            print('not_verified is null or not found in the response data.');
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
      isLoading = false;
      showDialog(
        context: context, 
        builder: (_){
          return AlertDialog(
            title: const Text('Server Error'),
            content: const Text('Silahkan hubungi dept IT untuk pemeriksaan server'),
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
      isLoading = false;
    }
  }

  Future<void> fetchBirthday() async{
    try{  
      String employeeId = storage.read('employee_id').toString();
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/notification/getlimitnotif.php?employee_id=$employeeId';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          noticationList = List<Map<String, dynamic>>.from(data['Data']);
        });
      } else if (response.statusCode == 404){
        print('404, No Data Found');
      }

    } catch (e){
      print('Error: $e');
    }
  }

  Future<void> fetchAbsenceStatistics() async {
    String employeeId = storage.read('employee_id').toString();

    try {
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/absent/getabsencestatistic.php?employee_id=$employeeId';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        // Check if the response contains the expected keys
        if (responseData.containsKey('Tepat Waktu') &&
            responseData.containsKey('Tidak Hadir') &&
            responseData.containsKey('Terlambat') &&
            responseData.containsKey('Lembur') &&
            responseData.containsKey('Pulang Awal')) {
          setState(() {
            angkaHadir = int.parse(responseData['Tepat Waktu'].toString());
            angkaTelat = int.parse(responseData['Terlambat'].toString());
            angkaLembur = int.parse(responseData['Lembur'].toString());
          });
        } else {
          print('Expected keys not found in the response data.');
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  
  Future<void> fetchPermission() async { 
    try {
      isLoading = true;

      String employeeId = storage.read('employee_id').toString();
      String apiURL = "https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/getpermission.php?action=1&id=$employeeId";

      var response = await http.get(Uri.parse(apiURL));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          permissionDataLimit = List<Map<String, dynamic>>.from(data['Data']['myPermission']);
          permissionDataLimitApproval = List<Map<String, dynamic>>.from(data['Data']['managerApproval']);
          permissionDataLimitApprovalHRD = List<Map<String, dynamic>>.from(data['Data']['HRDApproval']);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }

    } finally {
      isLoading = false;
    }
  }

  Future<void> Notification(action_id) async {
    //delete only one notif
    if(action_id == '1'){
      try{
        isLoading = true;
        String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/notification/notification.php';

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "action" : "1",
            "notification_id": notificationID
          }
        );

        String employeeId = storage.read('employee_id').toString();

        if (response.statusCode == 200) {
          isLoading = false;
          Get.back();
        } else {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error ${response.body}'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(FullIndexWeb(employeeId));
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        }
      } catch(e){
        String employeeId = storage.read('employee_id').toString();
        showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error $e'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(FullIndexWeb(employeeId));
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
      } finally {
        isLoading = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    var employeeId = storage.read('employee_id');
    var positionId = storage.read('position_id');
    var photo = storage.read('photo');

    return MaterialApp(
      title: "HR Dashboard",
      home: Scaffold(
        body: isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
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
                        SizedBox(height: 5.sp,),
                        NamaPerusahaanMenu(companyName: companyName, companyAddress: trimmedCompanyAddress),
                        SizedBox(height: 10.sp,),
                        const HalamanUtamaMenu(),
                        SizedBox(height: 5.sp,),
                        BerandaActive(employeeId: employeeId.toString()),
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
                        LaporanNonActive(positionId: positionId.toString()),
                        SizedBox(height: 10.sp,),
                        const PengaturanMenu(),
                        SizedBox(height: 5.sp,),
                        const PengaturanNonActive(),
                        SizedBox(height: 5.sp,),
                        const StrukturNonActive(),
                        SizedBox(height: 5.sp,),
                        const Logout(),
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
                        SizedBox(height: 5.sp,),
                        NotificationnProfile(employeeName: employeeName, employeeAddress: employeeEmail, photo: photo),
                        SizedBox(height: 7.sp,),
                        //statistik card
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //kehadiran card
                            Card(
                              shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12))),
                              color: Colors.white,
                              shadowColor: Colors.black,
                              child: SizedBox(
                                width: (MediaQuery.of(context).size.width - 125.w) / 4,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 7.sp, top: 5.sp, bottom: 5.sp, right: 7.sp),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Kehadiran',
                                            style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w400,)
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(angkaHadir.toString(),style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(color: Color.fromRGBO(220, 251, 234, 100),borderRadius: BorderRadius.all(Radius.circular(10.0)),),
                                            width: MediaQuery.of(context).size.width * 0.05,
                                            child: Row(
                                              children: [
                                                SizedBox(width: 12.sp, ),
                                              ],
                                            ),
                                              ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ),
                            //keterlambatan card
                            Card(
                              shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12))),
                              color: Colors.white,
                              shadowColor: Colors.black,
                              child: SizedBox(
                                width: (MediaQuery.of(context).size.width - 125.w) / 4,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 7.sp, top: 5.sp, bottom: 5.sp, right: 7.sp),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Keterlambatan',
                                            style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w400,)
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(angkaTelat.toString(),
                                            style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(220, 251, 234, 100),
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            ),
                                            width: MediaQuery.of(context).size.width * 0.05,
                                            child: Row(
                                              children: [
                                                SizedBox(width: 12.sp, ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ),
                            //absen card
                            Card(
                              shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12))),
                              color: Colors.white,
                              shadowColor: Colors.black,
                              child: SizedBox(
                                width: (MediaQuery.of(context).size.width - 125.w) / 4,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 7.sp, top: 5.sp, bottom: 5.sp, right: 7.sp),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Verifikasi Absen',
                                            style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w400,)
                                          ),
                                        ],
                                      ),
                                      if(positionId == 'POS-HR-002')
                                        Row(
                                          children: [
                                            Text(angkaAbsen.toString(),
                                              style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)
                                            ),
                                          ],
                                        ),
                                      if(positionId != 'POS-HR-002')
                                      Row(
                                        children: [
                                            Text('0',
                                              style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)
                                            ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(220, 251, 234, 100),
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            ),
                                            width: MediaQuery.of(context).size.width * 0.05,
                                            child: Row(
                                              children: [
                                                SizedBox(width: 12.sp, ),
                                              ],
                                            ),
                                              ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ),
                            //lembur card
                            Card(
                              shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12))),
                              color: Colors.white,
                              shadowColor: Colors.black,
                              child: SizedBox(
                                width: (MediaQuery.of(context).size.width - 125.w) / 4,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 7.sp, top: 5.sp, bottom: 5.sp, right: 7.sp),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Sisa cuti',
                                            style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w400,)
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(sisaCuti.toString(),
                                            style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(220, 251, 234, 100),
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            ),
                                            width: MediaQuery.of(context).size.width * 0.05,
                                            child: Row(
                                              children: [
                                                SizedBox(width: 12.sp, ),
                                              ],
                                            ),
                                              ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ),
                          ],
                        ),
                        SizedBox(height: 7.sp,),
                        //absen, izin button
                        Card(
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                          color: Colors.white,
                          shadowColor: Colors.black,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 5.w,
                            child: Padding(
                              padding: EdgeInsets.only(left: 2.sp, top: 3.sp, bottom: 2.sp, right: 2.sp),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      
                                      _getCurrentLocation();
                                    },
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.49 / 5,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset( 'images/absen.png', width: MediaQuery.of(context).size.width *0.012.sp,),
                                          SizedBox(height: 2.sp),
                                              Text( 'Absen',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 5.sp,
                                                  fontWeight: FontWeight.w700
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      showDialog(
                                        context: context, 
                                        builder: (_) {
                                          return AlertDialog(
                                            title: const Text("Jenis Izin"),
                                            content: DropdownButtonFormField(
                                              value: '001',
                                              items: const [
                                                DropdownMenuItem(value: '001',child: Text('Izin pulang awal')),
                                                DropdownMenuItem(value: '002',child: Text('Izin datang telat')),
                                                DropdownMenuItem(value: '003',child: Text('Cuti tahunan')),
                                                DropdownMenuItem(value: '004',child: Text('Lembur')),
                                                DropdownMenuItem(value: '005',child: Text('Sakit'))
                                              ], 
                                              onChanged: (value) {
                                                leaveoptions = value.toString();
                                              }
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {Get.back();},
                                                child: const Text('Batal'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  if(leaveoptions == '001'){
                                                    Get.to(PulangAwalPage());
                                                  } else if (leaveoptions == '002') {
                                                    Get.to(DatangTelatPage());
                                                  } else if (leaveoptions == '003'){
                                                    Get.to(const CutiPage());
                                                  } else if (leaveoptions == '004'){
                                                    Get.to(const Lembur());
                                                  } else if (leaveoptions == '005'){
                                                    Get.to(const SickPermission());
                                                  }
                                                },
                                                child: const Text('Lanjut',),
                                              ),
                                            ],
                                          );
                                        }
                                      );
                                    },
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.49 / 5,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset( 'images/leave.png',width: MediaQuery.of(context).size.width *0.012.sp,),
                                          SizedBox(height: 2.sp),
                                          Text('Izin',style: TextStyle(color: Colors.black,fontSize: 5.sp,fontWeight: FontWeight.w700),),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context, 
                                        builder: (_) {
                                          return AlertDialog(
                                            title: const Text("Jenis Permintaan"),
                                            content: DropdownButtonFormField(
                                              value: '006',
                                              items: const [
                                                DropdownMenuItem(value: '006',child: Text('Pengajuan Inventaris')),
                                                DropdownMenuItem(value: '007',child: Text('Pengajuan Karyawan Baru')),
                                                DropdownMenuItem(value: '008',child: Text('Pengajuan Perjalanan Dinas')),
                                                DropdownMenuItem(value: '009',child: Text('Pengajuan Peminjaman Karyawan')),
                                                DropdownMenuItem(value: '010',child: Text('Pengajuan Pemunduran Diri')),
                                              ], 
                                              onChanged: (value) {
                                                requestoptions = value.toString();
                                              }
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {Get.back();},
                                                child: const Text('Batal'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  if(requestoptions == '006'){
                                                    Get.to(const NewInventoryRequest());
                                                  } else if (requestoptions == '007') {
                                                    if(positionId == 'POS-HR-001' || positionId == 'POS-HR-002' || positionId == 'POS-HR-004' || positionId == 'POS-HR-005' || positionId == 'POS-HR-008' || positionId == 'POS-HR-024'){
                                                      Get.to(const AddRequestNewEmployee());
                                                    } else {
                                                      showDialog(
                                                        context: context, 
                                                        builder: (_) {
                                                          return AlertDialog(
                                                            title: const Text("Error"),
                                                            content: const Text("Maaf anda tidak memiliki akses ke menu ini"),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () {Get.back();}, 
                                                                child: const Text("Oke")
                                                              ),
                                                            ],
                                                          );
                                                        }
                                                      );
                                                    }
                                                  } else if (requestoptions == '008'){
                                                    Get.to(const AddNewPerjalananDinas());
                                                  } else if (requestoptions == '009'){
                                                    Get.to(const AddNewPinjamanKaryawan());
                                                  } else if (requestoptions == '010'){
                                                    Get.to(const ResignForm());
                                                  }
                                                },
                                                child: const Text('Lanjut',),
                                              ),
                                            ],
                                          );
                                        }
                                      );
                                    },
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.49 / 5,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset( 'images/absen.png',width: MediaQuery.of(context).size.width *0.012.sp,),
                                          SizedBox(height: 2.sp),
                                          Text('Permintaan', style: TextStyle(color: Colors.black, fontSize: 5.sp, fontWeight: FontWeight.w700),),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if(positionId == 'POS-HR-002')
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(const VerifyAbsence());
                                      },
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.49 / 5,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset( 'images/absen.png',width: MediaQuery.of(context).size.width *0.012.sp,),
                                            SizedBox(height: 2.sp),
                                            Text('Verifikasi', style: TextStyle(color: Colors.black, fontSize: 5.sp, fontWeight: FontWeight.w700),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if(positionId == 'POS-HR-002')
                                    GestureDetector(
                                      onTap: () {
                                       
                                      },
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.49 / 5,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset( 'images/absen.png',width: MediaQuery.of(context).size.width *0.012.sp,),
                                            SizedBox(height: 2.sp),
                                            Text('Kasbon', style: TextStyle(color: Colors.black, fontSize: 5.sp, fontWeight: FontWeight.w700),),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 7.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                              shape: const RoundedRectangleBorder( 
                                borderRadius: BorderRadius.all(Radius.circular(12))
                              ),
                              color: Colors.white,
                              shadowColor: Colors.black,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 4.sp, top: 2.sp, bottom: 2.sp, right: 4.sp),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 5.sp,),
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Izin Saya',
                                                  style: TextStyle(
                                                    fontSize: 6.sp, fontWeight: FontWeight.w600,
                                                  )
                                                ),
                                                SizedBox(height: 1.sp,),
                                                Text( 'Kelola dan tijau izin yang telah diajukan',
                                                  style: TextStyle(
                                                    fontSize: 4.sp, fontWeight: FontWeight.w300,
                                                  )
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(const ShowAllMyPermission());
                                              },
                                              child: Text('Lihat semua',  style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w400, color: const Color(0xFF2A85FF)))
                                            )
                                          ],
                                        ),
                                      SizedBox( height: 7.sp,),
                                      for (int index = 0; index < 3; index++)
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(ViewOnlyPermission(permission_id : permissionDataLimit[index]['id_permission']));
                                              },
                                              child: Card(
                                                child: ListTile(
                                                  title: Text(
                                                    index < permissionDataLimit.length
                                                        ? '${permissionDataLimit[index]['employee_name']} | ${permissionDataLimit[index]['permission_type_name']}'
                                                        : '-',
                                                    style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),
                                                  ),
                                                  subtitle: Text(
                                                    index < permissionDataLimit.length
                                                        ? permissionDataLimit[index]['permission_status_name']
                                                        : '-',
                                                    style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5.sp,),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //kelola izin card
                            if(positionId == 'POS-HR-001' || positionId == 'POS-HR-004' || positionId == 'POS-HR-024')
                              Card(
                                shape: const RoundedRectangleBorder( 
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                                ),
                                color: Colors.white,
                                shadowColor: Colors.black,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.35,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 4.sp, top: 2.sp, bottom: 2.sp, right: 4.sp),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 5.sp,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Persetujuan izin',
                                                  style: TextStyle(
                                                    fontSize: 6.sp, fontWeight: FontWeight.w600,
                                                  )
                                                ),
                                                SizedBox(height: 1.sp,),
                                                Text( 'Terima atau tolak permintaan izin yang masuk',
                                                  style: TextStyle(
                                                    fontSize: 4.sp, fontWeight: FontWeight.w300,
                                                  )
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(const ShowAllPermissionPage());
                                              },
                                              child: Text('Lihat semua',  style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w400, color: const Color(0xFF2A85FF)))
                                            )
                                          ],
                                        ),
                                        SizedBox( height: 7.sp,),
                                        for (int indexA = 0; indexA < 3; indexA++)
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(ViewOnlyPermission(permission_id : permissionDataLimitApproval[indexA]['id_permission']));
                                                },
                                                child: Card(
                                                  child: ListTile(
                                                    title: Text(
                                                      indexA < permissionDataLimitApproval.length
                                                          ? '${permissionDataLimitApproval[indexA]['employee_name']} | ${permissionDataLimitApproval[indexA]['permission_type_name']}'
                                                          : '-',
                                                      style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    subtitle: Text(
                                                      indexA < permissionDataLimitApproval.length
                                                          ? permissionDataLimitApproval[indexA]['permission_status_name']
                                                          : '-',
                                                      style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 5.sp,),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008')
                              Card(
                                shape: const RoundedRectangleBorder( 
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                                ),
                                color: Colors.white,
                                shadowColor: Colors.black,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.35,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 4.sp, top: 2.sp, bottom: 2.sp, right: 4.sp),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 5.sp,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Persetujuan izin',
                                                  style: TextStyle(
                                                    fontSize: 6.sp, fontWeight: FontWeight.w600,
                                                  )
                                                ),
                                                SizedBox(height: 1.sp,),
                                                Text( 'Terima atau tolak permintaan izin yang masuk',
                                                  style: TextStyle(
                                                    fontSize: 4.sp, fontWeight: FontWeight.w300,
                                                  )
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(const ShowAllPermissionPage());
                                              },
                                              child: Text('Lihat semua',  style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w400, color: const Color(0xFF2A85FF)))
                                            )
                                          ],
                                        ),
                                        SizedBox( height: 7.sp,),
                                        for (int indexB = 0; indexB < 3; indexB++)
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(ViewOnlyPermission(permission_id : permissionDataLimitApprovalHRD[indexB]['id_permission']));
                                                },
                                                child: Card(
                                                  child: ListTile(
                                                    title: Text(
                                                      indexB < permissionDataLimitApprovalHRD.length
                                                          ? '${permissionDataLimitApprovalHRD[indexB]['employee_name']} | ${permissionDataLimitApprovalHRD[indexB]['permission_type_name']}'
                                                          : '-',
                                                      style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    subtitle: Text(
                                                      indexB < permissionDataLimitApprovalHRD.length
                                                          ? permissionDataLimitApprovalHRD[indexB]['permission_status_name']
                                                          : '-',
                                                      style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 5.sp,),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        )
                      ],
                    ),

                ),
          )],
          )
        ),
      ),
    );
  }

  
}
