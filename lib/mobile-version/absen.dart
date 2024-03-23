// ignore_for_file: unused_local_variable, unused_import, depend_on_referenced_packages, avoid_web_libraries_in_flutter, avoid_print, use_build_context_synchronously

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

  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        camera: firstCamera,
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
      final image = await controller.takePicture();
      final Uint8List imageData = await image.readAsBytes();
      final String base64Image = base64Encode(imageData);
      print(base64Image);

      var datenow = DateTime.now();
      String timestamp = datenow.toString();

      // Combine timestamp and location information
      String stampText = "Waktu: $timestamp\n\nLokasi: ";
      print(stampText);

      // Add timestamp and location information to the image
      // addTextWatermark(base64Image, stampText);

            if (!mounted) return;
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: image.path,
                  timestamp: timestamp,
                  // location: location,
                ),
              ),
            );

      // final html.Image capturedImage = html.Image.memory(imageData);
      // html.document.body.append(capturedImage);
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
      //  onPressed: () async {
      //   try {
      //     final image = await ImagePickerWeb.getImageAsFile();
      //     if (image != null) {
      //       print('masuk');
      //       // Handle the captured image
      //       // Get current timestamp
      //       var datenow = DateTime.now();
      //       String timestamp = datenow.toString();

      //       // Get current location (using Geolocator package)
      //       // String location = await _getCurrentLocation();

      //       // Combine timestamp and location information
      //       String stampText = "Waktu: $timestamp\n\nLokasi: ";

      //       // Add timestamp and location information to the image
      //       // _addTextWatermark(image.path, stampText);

      //       // if (!mounted) return;
      //       // await Navigator.of(context).push(
      //       //   MaterialPageRoute(
      //       //     builder: (context) => DisplayPictureScreen(
      //       //       imagePath: image.path,
      //       //       timestamp: timestamp,
      //       //       // location: location,
      //       //     ),
      //       //   ),
      //       // );
      //     }
      //   } catch (e) {
      //     print(e);
      //   }
      // },

        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  void addTextWatermark(String base64Image, String watermarkText) {
  // Decode base64 image to bytes
  Uint8List bytes = base64Decode(base64Image);

  // Decode image using image package
  img.Image image = img.decodeImage(bytes)!;

  // Create a recorder to draw on a canvas
  ui.PictureRecorder recorder = ui.PictureRecorder();
  Canvas canvas = Canvas(recorder, Rect.fromPoints(const Offset(0.0, 0.0), Offset(image.width.toDouble(), image.height.toDouble())));

  ui.ParagraphBuilder builder = ui.ParagraphBuilder(
    ui.ParagraphStyle(
      textAlign: TextAlign.left,
      fontSize: 24.0,
    ),
  );

  ui.Paragraph paragraph = builder.build()..layout(ui.ParagraphConstraints(width: image.width.toDouble()));

  // Draw the image onto the canvas
  // canvas.drawImage(img.Image.fromBytes(image.width, image.height, image.getBytes(), width: 150, height: 15, bytes: 15), Offset.zero, Paint());

  // // Draw the text watermark on the canvas
  canvas.drawParagraph(paragraph, Offset(10.0, image.height.toDouble() - 50.0));

}
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final storage = GetStorage();
    String absenceType = GetStorage().read('absence_type');

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
                      initialValue: DateFormat('dd MMM yyyy HH:mm').format(DateTime.parse(timestamp)),
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
                    child: Image.file(File(imagePath)),
                  ),
                ],
              ),
              SizedBox(height: 20.h,),
              ElevatedButton(
                onPressed: ()  {
                  File imageFile = File(imagePath);
                  print(File(imagePath));

                  // Get other necessary data
                  String absenceTypeId = GetStorage().read('absence_type_id');
                  // Assuming 'employee_id' is stored as a String
                  //String employeeIdString = GetStorage().read('employee_id');

                  // Parse the String to an int
                  int employeeId = GetStorage().read('employee_id'); // 0 is the default value if parsing fails

                  String companyId = GetStorage().read('company_id');
                  // String locationSend = location;
                  String formattedTime = DateFormat('HH:mm').format(DateTime.parse(timestamp));
                  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(timestamp));
                  // sendAbsenceData(imageFile, absenceTypeId, employeeId, companyId, locationSend, formattedTime, formattedDate);
                  // String absenceType_id = GetStorage().read('absence_type_id');
                  // String employee_id = GetStorage().read('employee_id');

                  // String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(timestamp));
                  // String formattedTime = DateFormat('HH:mm').format(DateTime.parse(timestamp));

                  // Future<Uint8List> getImageBytes(File file) async {
                  //   final bytes = await file.readAsBytes();
                  //   final image = img.decodeImage(Uint8List.fromList(bytes));

                  //   // Encode the image to PNG format
                  //   final pngBytes = img.encodePng(image!);

                  //   // Convert to Uint8List
                  //   return Uint8List.fromList(pngBytes);
                  // }

                  // // Usage:
                  // Uint8List imageBytes = getImageBytes(File(imagePath)) as Uint8List;

                  // print('Absence Type ID: $absenceType_id');
                  // print('Employee ID: $employee_id');
                  // print('Formatted Date: $formattedDate');
                  // print('Formatted Time: $formattedTime');
                  // print('Image Bytes Length: ${imageBytes.length}');

                  // Here you can use imageBytes for further processing or upload it to a server
                  // For example, you might want to upload the image using an HTTP package:
                  // await uploadImageToServer(imageBytes);

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