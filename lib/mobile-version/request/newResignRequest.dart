import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/mobile-version/absen.dart';
import 'package:hr_systems_web/mobile-version/indexMobile.dart';
import 'package:hr_systems_web/mobile-version/permission/viewAllMyPermission.dart';
import 'package:hr_systems_web/mobile-version/profileMobile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class newResignMobile extends StatefulWidget {
  const newResignMobile({super.key});

  @override
  State<newResignMobile> createState() => _newResignMobileState();
}

class _newResignMobileState extends State<newResignMobile> {
  final storage = GetStorage();
  bool isLoading = false;
  String employeeId = GetStorage().read('employee_id').toString();
  final int _currentIndex = 0;

  DateTime? tanggalResign;
  String inventory = '';
  String totalloan = '';
  String totalkasbon = '';

  TextEditingController txtNamaKaryawan = TextEditingController();
  TextEditingController txtJabatanKaryawan = TextEditingController();
  TextEditingController txtDepartemenKaryawan = TextEditingController();
  TextEditingController txtAlasanKaryawan = TextEditingController();

  List<Map<String, dynamic>> noticationList = [];
  List<dynamic> kasbons = [];

  @override
  void initState() {
    super.initState();
    fetchDataforFilled();
    fetchResignData();
  }

  Future<void> actionKasbon() async {
    try{
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/resign/resign.php';
      employeeId = storage.read('employee_id').toString();

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "action" : "2",
          "employee_id" : employeeId,
          "effective_date" : tanggalResign.toString(),
          "resign_reason" : txtAlasanKaryawan.text,
        }
      );

      if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil mengajukan pemunduran diri'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(indexMobile(EmployeeID: employeeId,));
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        } else {
          print(response.body + response.statusCode.toString());
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error ${response.statusCode}'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(indexMobile(EmployeeID: employeeId,));
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        }
    } catch (e){
      isLoading = false;
      showDialog(
        context: context, 
        builder: (_) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text('Error $e'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.to(indexMobile(EmployeeID: employeeId,));
              }, 
              child: const Text("Oke")
            ),
          ],
        );}
      );
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchResignData() async {
    employeeId = storage.read('employee_id').toString();
   String url = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/resign/getresign.php?action=1&employee_id=$employeeId';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final data = jsonResponse['Data'] as Map<String, dynamic>;

      inventory = data['inventory'] ?? '0';
      totalloan = data['totalloan'] ?? '0';
      totalkasbon = data['totalkasbon'] ?? '0';

      // Ensuring the values are stored as strings, even if null
      inventory = inventory.isNotEmpty ? inventory : '0';
      totalloan = totalloan.isNotEmpty ? totalloan : '0';
      totalkasbon = totalkasbon.isNotEmpty ? totalkasbon : '0';

    } else {
      print('Failed to load data');
    }
  } catch (e) {
    print('Error: $e');
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
          txtNamaKaryawan.text = data['Data']['employee_name'] as String;
          txtDepartemenKaryawan.text = data['Data']['department_name'] as String;
          txtJabatanKaryawan.text = data['Data']['position_name'] as String;

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

  String formatCurrency2(String value) {
    // Parse the string to a number.
    double numberValue = double.tryParse(value) ?? 0;

    // Format the number as currency.
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0).format(numberValue);
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
  String employeeId = storage.read('employee_id').toString();
    setState(() {
      if (index == 0) {
        Get.to(indexMobile(EmployeeID: employeeId,));
      }else if(index == 1){
        // _currentMenu = 'Order';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h,),
              Center(child: Text('Formulir Permohonan Berhenti', style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),)),
              SizedBox(height: 15.h,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp,),
                  Text('Nama Lengkap',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromRGBO(116, 116, 116, 1)
                    ),
                  ),
                  SizedBox(height: 7.h,),
                  Text(txtNamaKaryawan.text)
                ]
              ),
              SizedBox(height: 10.h,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp,),
                  Text('Departemen',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromRGBO(116, 116, 116, 1)
                    ),
                  ),
                  SizedBox(height: 7.h,),
                  Text(txtDepartemenKaryawan.text)
                ]
              ),
              SizedBox(height: 10.h,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp,),
                  Text('Jabatan',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromRGBO(116, 116, 116, 1)
                    ),
                  ),
                  SizedBox(height: 7.h,),
                  Text(txtJabatanKaryawan.text)
                ]
              ),
              SizedBox(height: 10.h,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp,),
                  Text('Tanggal Efektif',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromRGBO(116, 116, 116, 1)
                    ),
                  ),
                  SizedBox(height: 7.h,),
                  DateTimePicker(
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2500),
                                     decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Pilih Tanggal Efektif' ,
                                    ),
                                    onChanged: (value) {
                                      tanggalResign = DateFormat('yyyy-MM-dd').parse(value);
                                    },
                                  )
                ]
              ),
              SizedBox(height: 10.h,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp,),
                  Text('Alasan',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromRGBO(116, 116, 116, 1)
                    ),
                  ),
                  SizedBox(height: 7.h,),
                  TextFormField(
                    maxLines: 2,
                    controller: txtAlasanKaryawan,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                      hintText: 'Masukkan alasan berhenti' 
                    ),
                  )
                ]
              ),
              SizedBox(height: 10.h,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp,),
                  Text('Inventaris',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromRGBO(116, 116, 116, 1)
                    ),
                  ),
                  SizedBox(height: 7.h,),
                  Text(inventory)
                ]
              ),
              SizedBox(height: 10.h,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp,),
                  Text('Jumlah Sisa Pinjaman',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromRGBO(116, 116, 116, 1)
                    ),
                  ),
                  SizedBox(height: 7.h,),
                  Text(formatCurrency2(totalloan))
                ]
              ),
              SizedBox(height: 10.h,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp,),
                  Text('Jumlah Sisa Kasbon',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromRGBO(116, 116, 116, 1)
                    ),
                  ),
                  SizedBox(height: 7.h,),
                  Text(formatCurrency2(totalkasbon))
                ]
              ),
              SizedBox(height: 35.h,),
                        Center(
                          child: 
                          ElevatedButton(
                            onPressed: () {
                              if(tanggalResign == null){
                                  dialogError('Tanggal efektif tidak dapat kosong !!');
                                } else if (txtAlasanKaryawan.text == ''){
                                  dialogError('Alasan berhenti tidak dapat kosong !!');
                                } else{
                                  actionKasbon();
                                }
                            }, 
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(40.w, 55.h),
                              foregroundColor: const Color(0xFFFFFFFF),
                              backgroundColor: const Color(0xff4ec3fc),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Kumpulkan')
                          ),
                        ),
                        SizedBox(height: 35.h,),
            ]
          )
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

  Future <void> dialogError (String message) async {
    return showDialog(
      context: context, 
      builder: (_){
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: (){
                Get.back();
              }, 
              child: Text('Kembali')
            )
          ],
        );
      }
    );
  }
}