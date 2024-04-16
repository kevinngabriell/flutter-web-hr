// ignore_for_file: unused_field, camel_case_types, non_constant_identifier_names, avoid_print, use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/mobile-version/absen.dart';
import 'package:hr_systems_web/mobile-version/document.dart';
import 'package:hr_systems_web/mobile-version/others.dart';
import 'package:hr_systems_web/mobile-version/permission/cutiTahunanMobile.dart';
import 'package:hr_systems_web/mobile-version/permission/izinDatangTelatMobile.dart';
import 'package:hr_systems_web/mobile-version/permission/izinLemburMobile.dart';
import 'package:hr_systems_web/mobile-version/permission/izinPulangAwalMobile.dart';
import 'package:hr_systems_web/mobile-version/permission/izinSakitMobile.dart';
import 'package:hr_systems_web/mobile-version/permission/viewAllMyPermission.dart';
import 'package:hr_systems_web/mobile-version/profileMobile.dart';
import 'package:hr_systems_web/mobile-version/request/newBusinessTripRequestMobile.dart';
import 'package:hr_systems_web/mobile-version/request/newEmployeeLoanRequest.dart';
import 'package:hr_systems_web/mobile-version/request/newInventoryRequestMobile.dart';
import 'package:hr_systems_web/mobile-version/request/newResignRequest.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class indexMobile extends StatefulWidget {
  final String EmployeeID;

  const indexMobile({super.key, required this.EmployeeID});

  @override
  State<indexMobile> createState() => _indexMobileState();
}

class _indexMobileState extends State<indexMobile> {
  final storage = GetStorage();
  bool isLoading = false;
  String? leaveoptions;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String positionName = '';
  String employeeEmail = '';
  String sisaCuti = '';
  String timeIn = "- : -";
  String timeOut = "- : -";

  final int _currentIndex = 0;
  String _currentMenu = 'Home';

  @override
  void initState() {
    super.initState();
    fetchDataTimeIn();
    fetchDataTimeOut();
    fetchData();
  }

  Future<void> fetchData() async {
    String employeeId = GetStorage().read('employee_id').toString();

    try {
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-systems-data-v.1/GetAllPageProfile.php';
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
          positionName = data['position_name'] as String;
        });

        storage.write('employee_name', data['employee_name'] as String);
        storage.write('position_name', data['position_name'] as String);

        await Future.delayed(const Duration(seconds: 1)); 

      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    } finally{
      isLoading = false;
    }
  }

  Future<void> checkLocation() async {

  try {
    isLoading = true;
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
              final cameras = await availableCameras();
              final firstCamera = cameras[1];
              for (CameraDescription camera in cameras) {
                print('Camera name: ${camera.name}');
                print('Camera lens direction: ${camera.lensDirection}');
                print('Camera sensor orientation: ${camera.sensorOrientation}');
                print('-----------------------------');
              }
              setState(() {
                isLoading = false;
              });
              Get.to(TakePictureScreen(camera: firstCamera));
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
                  final cameras = await availableCameras();
                  final firstCamera = cameras.last;
                  setState(() {
                    isLoading = false;
                  });
                  Get.to(TakePictureScreen(camera: firstCamera));
                } else {
                  setState(() {
                    isLoading = false;
                  });
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Error"),
                      content: const Text("Anda berada diluar area kantor dan tidak dapat melakukan absen pada saat ini"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("OK"),
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
  } catch (e) {
    print('Error: $e');
    // Handle the error as needed, e.g., show a user-friendly message
  } finally {
    isLoading = false;
  }
}

  Future<void> fetchDataTimeIn() async {
    try {
      isLoading = true;
      // Read the 'employee_id' from GetStorage
      String employeeId = GetStorage().read('employee_id').toString();

      // Construct the API URL with the employeeId
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-systems-data-v.1/AbsenceProcess/GetWaktuAbsenDatangMobileHome.php?employee_id=$employeeId';

      // Make the API call with a GET request
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        timeIn = data['time'];
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchDataTimeOut() async {
    try {
      isLoading = true;
      // Read the 'employee_id' from GetStorage
      String employeeId = GetStorage().read('employee_id').toString();

      // Construct the API URL with the employeeId
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-systems-data-v.1/AbsenceProcess/GetWaktuAbsenPulangMobileHome.php?employee_id=$employeeId';

      // Make the API call with a GET request
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        timeOut = data['time'];
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    } finally {
      isLoading = false;
    }
  }

  void _changeSelectedNavBar(int index) {
    setState(() {
      if (index == 0) {
        Get.to(indexMobile(EmployeeID: widget.EmployeeID,));
      }else if(index == 1){
        _currentMenu = 'Order';
      }else if(index == 2){
        FutureBuilder<void>(
          future: checkLocation(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            switch (snapshot.connectionState) {
                case ConnectionState.none:
              return const Text('Press button to start.');
                case ConnectionState.active:
                case ConnectionState.waiting:
              return const CircularProgressIndicator();
                case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return const Text('Location checked successfully!');
            }
          },
        );
      }else if(index == 3){
        Get.to(const viewAllMyPermissionMobile());
      } else if (index == 4){
        Get.to(MyProfileMobile(employeeId: widget.EmployeeID,));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var photo = storage.read('photo');

    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading ? const Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 10,
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h,),
                    Padding(
                      padding: EdgeInsets.only(top: 10.sp, left: 15.sp),
                      child: Row(
                        children: [
                          Image.memory(base64Decode(photo), width: MediaQuery.of(context).size.width * 0.13,),
                          SizedBox(width: 10.w,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(employeeName,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              Text(positionName,
                                style: TextStyle(
                                  color: const Color.fromRGBO(116, 116, 116, 1),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox( 
                          width: MediaQuery.of(context).size.width / 2,
                          child: Card(
                            margin: EdgeInsets.only(left: 15.sp, right: 15.sp),
                            color: timeIn != '- : -'
                            ? const Color.fromRGBO(78, 195, 252, 1)
                            : const Color.fromRGBO(255, 184, 0, 1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.sp, left: 10.sp),
                                      child: Text(extractTime(timeIn),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w800
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.sp, right: 10.sp),
                                      child: Image.asset('images/absenMasuk.png'),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 1.sp, left: 10.sp, bottom: 10.sp),
                                  child: Text('Absen masuk', 
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox( 
                          width: MediaQuery.of(context).size.width / 2,
                          child: Card(
                            margin: const EdgeInsets.only(left: 15, right: 15),
                            color: timeOut != '- : -'
                            ? const Color.fromRGBO(78, 195, 252, 1)
                            : const Color.fromRGBO(255, 184, 0, 1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.sp, left: 10.sp),
                                      child: Text(extractTime(timeOut),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w800
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.sp, right: 10.sp),
                                      child: Image.asset('images/absenKeluar.png'),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 1.sp, left: 10.sp, bottom: 10.sp),
                                  child: Text('Absen keluar', 
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                    SizedBox(height: 10.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox( 
                          width: MediaQuery.of(context).size.width / 2,
                          child: Card(
                            margin: const EdgeInsets.only(left: 15, right: 15),
                            color: const Color.fromRGBO(78, 195, 252, 1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.sp, left: 10.sp),
                                      child: Text('0%',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w800
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.sp, right: 10.sp),
                                      child: Image.asset('images/onTime.png'),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 1.sp, left: 10.sp, bottom: 10.sp),
                                  child: Text('Ketepatan waktu', 
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox( 
                          width: MediaQuery.of(context).size.width / 2,
                          child: Card(
                            margin: const EdgeInsets.only(left: 15, right: 15),
                            color: const Color.fromRGBO(78, 195, 252, 1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.sp, left: 10.sp),
                                      child: Text('0',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w800
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.sp, right: 10.sp),
                                      child: Image.asset('images/onTime.png'),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 1.sp, left: 10.sp, bottom: 10.sp),
                                  child: Text('Total kehadiran', 
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25.h,),
                    Padding(
                      padding: EdgeInsets.only(left: 15.sp),
                      child: Text('Fitur',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 7,
                      padding: EdgeInsets.only(top: 12.sp, bottom: 0.sp),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              izinDialog();
                            },
                            child: Column(
                              children: [
                                Image.asset('images/DocumentIcon.png'),
                                SizedBox(height: 5.sp,),
                                const Text('Izin'),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              permohonanDialog();
                            },
                            child: Column(
                              children: [
                                Image.asset('images/PermohonanIcon.png'),
                                SizedBox(height: 5.sp,),
                                const Text('Permohonan'),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(documentMobile());
                            },
                            child: Column(
                              children: [
                                Image.asset('images/BonIcon.png'),
                                SizedBox(height: 5.sp,),
                                const Text('Dokumen'),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(const othersMobile());
                            },
                            child: Column(
                              children: [
                                Image.asset('images/AssetIcon.png'),
                                SizedBox(height: 5.sp,),
                                const Text('Lainnya'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5.h,),
                    Padding(
                      padding: EdgeInsets.only(left: 15.sp),
                      child: Text('Acara',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800
                        ),
                      ),
                    ),
                  ],
                ),
              )
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _changeSelectedNavBar,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        unselectedItemColor: const Color.fromRGBO(221, 221, 221, 1),
        unselectedIconTheme: const IconThemeData(
          color: Color.fromRGBO(221, 221, 221, 1)
        ),
        unselectedLabelStyle: const TextStyle(
          color: Colors.black
        ),
        selectedItemColor: const Color.fromRGBO(78, 195, 252, 1),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schema),
            label: 'Training',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Absen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Izin',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  String extractTime(String fullTime) {
    // Add error checking as needed
    List<String> parts = fullTime.split(':');
    return '${parts[0]}:${parts[1]}';
  }

  Future izinDialog() {
    return showDialog(
      context: context, 
      builder: (_){
        return AlertDialog(
          title: const Text('Pengajuan Izin'),
          content: DropdownButtonFormField(
            value: 'IZIN-001',
            items: const [
              DropdownMenuItem(value: 'IZIN-001',child: Text('Izin pulang awal'),),
              DropdownMenuItem(value: 'IZIN-002',child: Text('Izin datang telat'),),
              DropdownMenuItem(value: 'IZIN-003',child: Text('Cuti tahunan'),),
              DropdownMenuItem(value: 'IZIN-004',child: Text('Lembur'),),
              DropdownMenuItem(value: 'IZIN-005',child: Text('Sakit'),),
            ],
            onChanged: (value){
              leaveoptions = value.toString();
            },
          ),
          actions: [
            TextButton(
              onPressed: (){
                Get.back();
              }, 
              child: const Text('Kembali')
            ),
            TextButton(
              onPressed: (){
                if(leaveoptions == 'IZIN-001'){
                  Get.to(const IzinPulangAwal());
                } else if (leaveoptions == 'IZIN-002'){
                  Get.to(const izinDatangTelatMobile());
                } else if (leaveoptions == 'IZIN-003'){
                  Get.to(const cutiTahunanMobile());
                } else if (leaveoptions == 'IZIN-004'){
                  Get.to(const izinLemburMobile());
                } else if (leaveoptions == 'IZIN-005'){
                  Get.to(const izinSakitMobile());
                }
              }, 
              child: const Text('Kumpul')
            ),
          ],
        );
      }
    );
  }

  Future permohonanDialog() {
    return showDialog(
      context: context, 
      builder: (_){
        return AlertDialog(
          title: const Text('Pengajuan Permohonan'),
          content: DropdownButtonFormField(
            value: 'PER-001',
            items: const [
              DropdownMenuItem(value: 'PER-001',child: Text('Pengajuan inventaris'),),
              DropdownMenuItem(value: 'PER-002',child: Text('Pengajuan karyawan baru'),),
              DropdownMenuItem(value: 'PER-003',child: Text('Pengajuan perjalanan dinas'),),
              DropdownMenuItem(value: 'PER-004',child: Text('Pengajuan pinjaman karyawan'),),
              DropdownMenuItem(value: 'PER-005',child: Text('Pengajuan pemunduran diri'),),
            ],
            onChanged: (value){
              leaveoptions = value.toString();
            },
          ),
          actions: [
            TextButton(
              onPressed: (){
                Get.back();
              }, 
              child: const Text('Kembali')
            ),
            TextButton(
              onPressed: (){
                if(leaveoptions == 'PER-001'){
                  Get.to(const newInventoryMobileRequest());
                } else if (leaveoptions == 'PER-002'){
                  webRequest();
                } else if (leaveoptions == 'PER-003'){
                  Get.to(const NewBusinessTripRequestMobile());
                } else if (leaveoptions == 'PER-004'){
                  Get.to(const newEmployeeLoanRequestMobile());
                } else if (leaveoptions == 'PER-005'){
                  Get.to(const newResignMobile());
                }
              }, 
              child: const Text('Kumpul')
            ),
          ],
        );
      }
    );
  }

  Future webRequest() {
    return showDialog(
      context: context, 
      builder: (_){
        return AlertDialog(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/error.png', width: MediaQuery.of(context).size.width * 0.5,),
              SizedBox(height: 14.sp,),
              Text('Error !!', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700,)),
              SizedBox(height: 1.sp,),
              Text('Pengajuan permohonan ini harus melalui web HR.', style: TextStyle(fontSize: 12.sp,), textAlign: TextAlign.center,),
            ],
          ),
          actions: [
            TextButton(
              onPressed: (){
                Get.back();
              }, 
              child: const Text('Oke')
            ),
          ],
        );
      }
    );
  }
}