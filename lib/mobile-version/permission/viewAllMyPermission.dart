import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/mobile-version/absen.dart';
import 'package:hr_systems_web/mobile-version/indexMobile.dart';
import 'package:hr_systems_web/mobile-version/permission/view/viewCutiTahunan.dart';
import 'package:hr_systems_web/mobile-version/permission/view/viewLemburMobile.dart';
import 'package:hr_systems_web/mobile-version/permission/view/viewPulangAwalMobile.dart';
import 'package:hr_systems_web/mobile-version/permission/view/viewSakitMobile.dart';
import 'package:hr_systems_web/mobile-version/profileMobile.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class viewAllMyPermissionMobile extends StatefulWidget {
  const viewAllMyPermissionMobile({super.key});

  @override
  State<viewAllMyPermissionMobile> createState() => _viewAllMyPermissionMobileState();
}

class _viewAllMyPermissionMobileState extends State<viewAllMyPermissionMobile> {
  List<Map<String, dynamic>> permissionTypeList = [];
  final storage = GetStorage();
  String employeeId = GetStorage().read('employee_id').toString();
  bool isLoading = false;
  final int _currentIndex = 3;

  @override
  void initState() {
    super.initState();
    fetchPermissionData();
  }

  Future<void> fetchPermissionData() async {
    String employeeId = storage.read('employee_id').toString();

    final response = await http.get(
      Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/showallmypermission.php?id=$employeeId'),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        permissionTypeList = List<Map<String, dynamic>>.from(data['Data']);
      });
      
    } else {
      throw Exception('Failed to load data');
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
              final firstCamera = cameras.last;
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
  
  void _changeSelectedNavBar(int index) {
    setState(() {
      if (index == 0) {
        Get.to(indexMobile(EmployeeID: employeeId,));
      }else if(index == 1){
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
        Get.to(viewAllMyPermissionMobile());
      } else if (index == 4){
        Get.to(MyProfileMobile(employeeId: employeeId,));
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
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
                child: Padding(
                  padding: EdgeInsets.only(left: 10.sp, right: 10.sp),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 25.h,),
                       Center(child: Text('Izin Saya', style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),)),
                      SizedBox(height: 25.h,),
                      SizedBox(
                                width: (MediaQuery.of(context).size.width),
                                height: (MediaQuery.of(context).size.height - 100.h),
                                child: ListView.builder(
                                  itemCount: permissionTypeList.length,
                                  itemBuilder: (context, index){
                                    var employeeName = permissionTypeList[index]['employee_name'] as String;
                                    var permissiontype = permissionTypeList[index]['permission_type_name'] as String;
                                    var permissionDate = formatDate(permissionTypeList[index]['permission_date'] as String? ?? permissionTypeList[index]['start_date'] as String);
                                    var permissionstatus = permissionTypeList[index]['permission_status_name'] as String;
                                    var permissionid = permissionTypeList[index]['id_permission'] as String;

                                    if (permissionstatus == 'Menunggu persetujuan manajer' || permissionstatus == 'Menunggu persetujuan HRD') {
                                      permissionstatus = 'Pending';
                                    }

                                    if (permissionstatus == 'Izin ditolak dengan alasan tertentu') {
                                      permissionstatus = ' Ditolak ';
                                    }

                                    if (permissionstatus == 'Izin telah disetujui ') {
                                      permissionstatus = 'Diterima';
                                    }

                                    Color backgroundColor = Colors.transparent;
                                    if (permissionstatus == 'Pending') {
                                      backgroundColor = Colors.yellow;
                                    }

                                    if (permissionstatus == ' Ditolak ') {
                                      backgroundColor = Colors.red;
                                    }

                                    if (permissionstatus == 'Diterima') {
                                      backgroundColor = Colors.green;
                                    }
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 7.sp),
                                      child: Card(
                                        child: ListTile(
                                          title: Text('$employeeName | $permissiontype', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 10.sp),),
                                          subtitle: Text(permissionDate),
                                          trailing: Container(
                                            constraints: BoxConstraints(
                                              minWidth: 25.w,
                                              minHeight: 50.h
                                            ),
                                            child: Card(
                                              color: backgroundColor,
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 5.sp, right: 5.sp, top: 5.sp, bottom: 5.sp),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(permissionstatus, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 10.sp),),
                                                  ],
                                                ),
                                              )
                                            ),
                                          ),
                                          minVerticalPadding: 13.0,
                                          onTap: () {
                                            if(permissiontype == 'Sakit'){
                                              Get.to(viewSakitMobile(permissionId: permissionid,));
                                            } else if (permissiontype == 'Lembur'){
                                              Get.to(viewLemburMobile(permissionId: permissionid,));
                                            } else if (permissiontype == 'Izin pulang awal'){
                                              Get.to(viewPulangAwalMobile(permissionId: permissionid,));
                                            } else if (permissiontype == 'Izin datang telat'){
                                              Get.to(viewPulangAwalMobile(permissionId: permissionid,));
                                            } else if (permissiontype == 'Cuti tahunan'){
                                              Get.to(viewCutiTahunan(permissionId: permissionid,));
                                            } 
                                            // Get.to(ViewOnlyPermission(permission_id: permissionid,));
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                ),
                              ),
                    ]
                  )
                )
              )
            )
          ]
        )
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

  String formatDate(String date) {
    // Parse the date string
    DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(date);

    // Format the date as "dd MMMM yyyy"
    return DateFormat("d MMMM yyyy", 'id').format(parsedDate);
  }
}