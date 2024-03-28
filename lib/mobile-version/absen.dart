// ignore_for_file: unused_local_variable, unused_import, depend_on_referenced_packages, avoid_web_libraries_in_flutter, avoid_print, use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui'as ui;
import 'package:camera/camera.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';  // Import for location information
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/mobile-version/indexMobile.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker_web/image_picker_web.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:html' as html;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  CameraDescription? frontCamera;

  // Iterate through the list of available cameras to find the front camera.
  for (CameraDescription camera in cameras) {
    if (camera.lensDirection == CameraLensDirection.front) {
      frontCamera = camera;
      break; // Stop the loop once the front camera is found
    }
  }

  if (frontCamera == null) {
    Get.snackbar('Error','No front camera found!');
    return; // or handle this case appropriately
  }

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        camera: frontCamera,
      ),
    ),
  );
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();

  
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController controller;
  late Future<void> initializeControllerFuture;

  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String employeeId = '';
  String departmentName = '';
  String positionName = '';

  bool isLoading = false;
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    GetStorage().remove('absence_type');
    GetStorage().remove('absence_type_id');
    getTipeAbsen();
    controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    initializeControllerFuture = controller.initialize();
  }

  Future<void> getTipeAbsen() async {

    // Replace with your actual API endpoint
    var apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-systems-data-v.1/AbsenceProcess/GetTipeAbsen.php';
    final storage = GetStorage();
    var employeeId = storage.read('employee_id'); // Replace with your employee_id value

    try {
      var response = await http.get(
        Uri.parse('$apiUrl?employee_id=$employeeId'),
      );

      if (response.statusCode == 200) {
        // Successful API call, parse the JSON response
        var result = json.decode(response.body);

      if (result['status'] == 'success') {
        var absenceType = result['result']['absence_type'];
        GetStorage().write('absence_type', result['result']['absence_type']);
        GetStorage().write('absence_type_id', result['result']['absence_type_id']);

      } else {
        // Handle API error
        print('API Error: ${result['status']}');
        Get.snackbar('Error', 'An error occurred. Please try again later.');
      }

      } else {
        // Handle other status codes
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        Get.snackbar('Error', 'An error occurred. Please try again later.');
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Exception: $e');
      Get.snackbar('Error', 'An error occurred. Please try again later.');
    } finally {

    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

   Future<void> _captureImage() async {
    try {
      isLoading = true;
      final image = await controller.takePicture();
      final Uint8List imageData = await image.readAsBytes();
      final String base64Image = base64Encode(imageData);

      var datenow = DateTime.now();
      String timestamp = datenow.toString();

      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            imagePath: base64Image,
            timestamp: timestamp,
          ),
        ),
      );

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Absen'),
      ),
      body: FutureBuilder<void>(
        future: initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        onPressed: _captureImage,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final String timestamp;
  // final String location;

  const DisplayPictureScreen({
    super.key,
    required this.imagePath,
    required this.timestamp,
    // required this.location,
  });

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  bool isLoading = false;
  String? leaveoptions;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  List<Map<String, dynamic>> noticationList = [];

  Future<void> sendAbsence(String based64Image, String absenceTypeId, int employeeId, String companyId, String location, String formattedTime, String formattedDate) async {
    try{
      isLoading = true;

      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-systems-data-v.1/AbsenceProcess/InsertAbsen.php';

      var data = {
        'employee_id': employeeId,
        'company_id': companyId,
        'date': formattedDate,
        'time': formattedTime,
        'location': 'Absen melalui web',
        'absence_type': absenceTypeId,
        'photo': based64Image,
      };

      var dioClient = dio.Dio();
      dio.Response response = await dioClient.post(apiUrl, data: dio.FormData.fromMap(data));

      if (response.statusCode == 200) {
        showDialog(
          context: context, // Make sure to have access to the context
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sukses'),
              content: const Text('Anda telah berhasil melakukan absensi'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    final GetStorage storage = GetStorage();

                    String employeeName = storage.read('employee_name') ?? '';
                    String positionName = storage.read('position_name') ?? '';
                    Get.to(indexMobile(EmployeeID: employeeId.toString()));
                  },
                  child: const Text('Kembali ke Halaman Utama'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
            context: context, 
            builder: (_) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Error ' + response.data),
              actions: <Widget>[
                TextButton(
                  onPressed: () {Get.to(indexMobile(EmployeeID: employeeId.toString()));}, 
                  child: const Text("Oke")
                ),
              ],
            );
          }
        );
      }

    } catch (e){
      showDialog(
          context: context, 
          builder: (_) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Error $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {Get.to(indexMobile(EmployeeID: employeeId.toString()));}, 
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

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    String absenceType = GetStorage().read('absence_type');
    Uint8List bytes = base64Decode(widget.imagePath);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Absen'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.only(left: 15.sp, right: 15.sp, top: 10.sp),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Jam',
                  style: TextStyle(
                    color: const Color.fromRGBO(116, 116, 116, 1),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  )
                  ),
                ],
              ),
              SizedBox(height: 5.h,),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 50 , // Set a specific width
                    child: TextFormField(
                      initialValue: DateFormat('dd MMM yyyy HH:mm').format(DateTime.parse(widget.timestamp)),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                      ),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h,),
              Row(
                children: [
                  Text(
                    'Lokasi',
                    style: TextStyle(
                      color: const Color.fromRGBO(116, 116, 116, 1),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h,),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 50, // Set a specific width
                    child: TextFormField(
                      maxLines: 3,
                      // initialValue: location,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                      ),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h,),
              Row(
                children: [
                  Text(
                    'Tipe absen',
                    style: TextStyle(
                      color: const Color.fromRGBO(116, 116, 116, 1),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h,),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 50, // Set a specific width
                      child: TextFormField(
                        initialValue: absenceType,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          fillColor: Color.fromRGBO(235, 235, 235, 1),
                        ),
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h,),
                Row(
                children: [
                  Text(
                    'Deskripsi',
                    style: TextStyle(
                      color: const Color.fromRGBO(116, 116, 116, 1),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h,),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 50, // Set a specific width
                      child: TextFormField(
                        maxLines: 3,
                        
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                        hintText: "Isi deskripsi absen anda (Optional)"
                      ),
                      readOnly: false,
                    ),
                    ),
                  ],
                ),
                 SizedBox(height: 20.h,),
              Row(
                children: [
                  Text('Foto',
                  style: TextStyle(
                    color: const Color.fromRGBO(116, 116, 116, 1),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  )
                  ),
                ],
              ),
              SizedBox(height: 5.h,),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Image.memory(bytes),
                  ),
                ],
              ),
              SizedBox(height: 20.h,),
              ElevatedButton(
                onPressed: ()  {
                  File imageFile = File(widget.imagePath);
                  String absenceTypeId = GetStorage().read('absence_type_id');
                  // Assuming 'employee_id' is stored as a String
                  int employeeId = GetStorage().read('employee_id'); 

                  String companyId = GetStorage().read('company_id');
                  String formattedTime = DateFormat('HH:mm').format(DateTime.parse(widget.timestamp));
                  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.timestamp));
                  String a = widget.imagePath;
                  sendAbsence(a, absenceTypeId, employeeId, companyId, 'Absen melalui web', formattedTime, formattedDate);
                }, 
                child: const Text('Kumpulkan')
              )

            ],
          ),
        ),
      ),
    );
  }
}