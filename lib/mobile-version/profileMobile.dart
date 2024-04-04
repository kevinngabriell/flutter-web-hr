// ignore_for_file: file_names

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/logout.dart';
import 'package:hr_systems_web/mobile-version/absen.dart';
import 'package:hr_systems_web/mobile-version/indexMobile.dart';
import 'package:hr_systems_web/mobile-version/permission/viewAllMyPermission.dart';
import 'package:hr_systems_web/mobile-version/settings/changeprofile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyProfileMobile extends StatefulWidget {
  final String employeeId;
  const MyProfileMobile({super.key, required this.employeeId});

  @override
  State<MyProfileMobile> createState() => _MyProfileMobileState();
}

class _MyProfileMobileState extends State<MyProfileMobile> {
  final int _currentIndex = 4;
  bool isLoading = false;
  final storage = GetStorage();

  Future<void> checkLocation() async {
    setState(() {
      isLoading = true;
    });
    try {
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
    }
  }

  void _changeSelectedNavBar(int index) {
        setState(() {
    
          if (index == 0) {
            Get.to(indexMobile(EmployeeID: widget.employeeId,));
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
            Get.to(MyProfileMobile(employeeId: widget.employeeId,));
          }
        });
      }

  @override
  Widget build(BuildContext context) {
    var photo = storage.read('photo');
    var employee_name = storage.read('employee_name');
    var position_name = storage.read('position_name');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.only(left: 7.sp, right: 7.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30.h,),
              GestureDetector(
                onTap: () {
                  Get.to(changeProfileMobile());
                },
                child: Column(
                  children: [
                    Image.memory(base64Decode(photo), width: MediaQuery.of(context).size.width * 0.15,),
                    SizedBox(height: 10.h,),
                    Text(employee_name, style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w600),),
                    SizedBox(height: 3.h,),
                    Text(position_name, style: TextStyle(fontSize: 9.sp),),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Pengaturan', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                onTap: () {
                  Get.to(changeProfileMobile());
                },
              ),
              ListTile(
                leading: Image.asset('images/logout.png'),
                title: Text('Keluar', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.red)),
                onTap: () {
                  logoutServicesMobile();
                },
              )
            ],
          ),
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
}