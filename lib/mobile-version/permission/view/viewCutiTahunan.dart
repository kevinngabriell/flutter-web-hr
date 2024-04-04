import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/mobile-version/absen.dart';
import 'package:hr_systems_web/mobile-version/indexMobile.dart';
import 'package:hr_systems_web/mobile-version/permission/viewAllMyPermission.dart';
import 'package:hr_systems_web/mobile-version/profileMobile.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class viewCutiTahunan extends StatefulWidget {
  final String permissionId;
  const viewCutiTahunan({super.key, required this.permissionId});

  @override
  State<viewCutiTahunan> createState() => _viewCutiTahunanState();
}

class _viewCutiTahunanState extends State<viewCutiTahunan> {
  final int _currentIndex = 3;
  String employeeId = GetStorage().read('employee_id').toString();
  bool isLoading = false;
  final storage = GetStorage();
  late Future<Map<String, dynamic>> permissionData;
  List<Map<String, dynamic>> historyList = [];

  @override
  void initState() {
    super.initState();
    permissionData = fetchDetailPermission();
    fetchLogPermissionData();
  }

  Future<Map<String, dynamic>> fetchDetailPermission() async {
    var id = widget.permissionId;

    final response = await http.get(
      Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/getdetailpermission.php?permission_id=$id'),
    );

    if (response.statusCode == 200) {
      print(response.statusCode);
      setState(() {});
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchLogPermissionData() async {
    var id = widget.permissionId;

    final response = await http.get(
      Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/getlogpermissiontable.php?permission_id=$id'),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      setState(() {
        historyList = List<Map<String, dynamic>>.from(data['Data']);
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
        Get.to(const viewAllMyPermissionMobile());
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
                      Center(child: Text('Formulir Izin Cuti Tahunan', style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),)),
                      FutureBuilder(
                        future: permissionData, 
                        builder: (context, snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return const Text('Terjadi kesahalan pada saat pengambilan data');
                          }  else if (snapshot.data == null || (snapshot.data as Map<String, dynamic>)['Data'] == null) {
                            return const Text('Data is null');
                          } else {
                            var data = (snapshot.data as Map<String, dynamic>)['Data'];
                            var firstData = data[0];

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 25.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width - 20.w) / 2,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Jenis Permohonan Izin",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromRGBO(116, 116, 116, 1)
                                              ),
                                            ),
                                          SizedBox(height: 7.h,),
                                          Text(firstData['permission_type_name'])
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width - 20.w) / 2,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Status Permohonan Izin",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromRGBO(116, 116, 116, 1)
                                              ),
                                            ),
                                          SizedBox(height: 7.h,),
                                          Text(firstData['permission_status_name'])
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width - 20.w) / 2,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Tanggal Permohonan Izin",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromRGBO(116, 116, 116, 1)
                                              ),
                                            ),
                                          SizedBox(height: 7.h,),
                                          Text(_formatDate(firstData['created_dt']))
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width - 20.w) / 2,
                                      child: const Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 25.h,),
                                Text("Detail Permohonan",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(0, 0, 0, 1)
                                  ),
                                ),
                                SizedBox(height: 15.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width - 20.w) / 2,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Nama Lengkap",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromRGBO(116, 116, 116, 1)
                                              ),
                                            ),
                                          SizedBox(height: 7.h,),
                                          Text(firstData['employee_name'])
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width - 20.w) / 2,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("NIK",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromRGBO(116, 116, 116, 1)
                                              ),
                                            ),
                                          SizedBox(height: 7.h,),
                                          Text(firstData != null ? firstData['employee_id'] ?? '' : '')
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width - 20.w) / 2,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Departemen",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromRGBO(116, 116, 116, 1)
                                              ),
                                            ),
                                          SizedBox(height: 7.h,),
                                          Text(firstData != null ? firstData['department_name'] ?? '' : '')
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width - 20.w) / 2,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Jabatan",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromRGBO(116, 116, 116, 1)
                                              ),
                                            ),
                                          SizedBox(height: 7.h,),
                                          Text(firstData != null ? firstData['position_name'] ?? '' : '')
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width - 20.w) / 2,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Tanggal mulai cuti",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromRGBO(116, 116, 116, 1)
                                              ),
                                            ),
                                          SizedBox(height: 7.h,),
                                          Text(firstData != null ? formatDate(firstData['start_date']) : '')
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width - 20.w) / 2,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Tanggal akhir cuti",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromRGBO(116, 116, 116, 1)
                                              ),
                                            ),
                                          SizedBox(height: 7.h,),
                                          Text(firstData != null ? formatDate(firstData['end_date']) : '')
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width - 20.w) / 2,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Nomor yang bisa dihubungi",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromRGBO(116, 116, 116, 1)
                                              ),
                                            ),
                                          SizedBox(height: 7.h,),
                                          Text(firstData != null ? firstData['cuti_phone'] ?? '' : '')
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width - 20.w) / 2,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Karyawan Pengganti",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromRGBO(116, 116, 116, 1)
                                              ),
                                            ),
                                          SizedBox(height: 7.h,),
                                          Text(firstData != null ? firstData['pengganti_cuti'] ?? '' : '')
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width - 20.w) / 2,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Keterangan atau alasan",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromRGBO(116, 116, 116, 1)
                                              ),
                                            ),
                                          SizedBox(height: 7.h,),
                                          Text(firstData != null ? firstData['permission_reason'] ?? '' : '')
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width - 20.w) / 2,
                                      child: const Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 35.h,),
                              ]
                            );
                          }
                        }
                      )
                    ]
                  )
                )
              )
            ),
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

  String _formatDate(String date) {
    // Parse the date string
    DateTime parsedDate = DateFormat("yyyy-MM-dd HH:mm").parse(date);

    // Format the date as "dd MMMM yyyy"
    return DateFormat("d MMMM yyyy HH:mm", 'id').format(parsedDate);
  }
}