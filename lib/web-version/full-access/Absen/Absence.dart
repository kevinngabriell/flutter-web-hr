// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unused_field, prefer_interpolation_to_compose_strings, avoid_print, file_names

import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart' as dio;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:hr_systems_web/web-version/full-access/index.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();

    final cameras = await availableCameras();

    final firstCamera = cameras.first;

    runApp(
      MaterialApp(
        theme: ThemeData.dark(),
        home: Absence(
          camera: firstCamera,
        ),
      ),
    );
  }

class Absence extends StatefulWidget {
  final CameraDescription camera;
  const Absence({super.key, required this.camera});

  @override
  State<Absence> createState() => _AbsenceState();
}

class _AbsenceState extends State<Absence> {
  bool isLoading = false;
  final storage = GetStorage();
  late CameraController controller;
  late Future<void> initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    getTipeAbsen();
    _getCurrentLocation();
  }

  Future<void> getTipeAbsen() async {
    // Replace with your actual API endpoint
    var apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-systems-data-v.1/AbsenceProcess/GetTipeAbsen.php';
    final storage = GetStorage();
    var employeeId = storage.read('employee_id'); // Replace with your employee_id value

    try {
      isLoading = true;
      var response = await http.get(
        Uri.parse('$apiUrl?employee_id=$employeeId'),
      );

      if (response.statusCode == 200) {
        // Successful API call, parse the JSON response
        var result = json.decode(response.body);

      if (result['status'] == 'success') {
        var absenceType = result['result']['absence_type'];
        print(absenceType);
        GetStorage().write('absence_type', result['result']['absence_type']);
        GetStorage().write('absence_type_id', result['result']['absence_type_id']);

      } else {
        // Handle API error
        setState(() {
          isLoading = false;
          showDialog(
            context: context, 
            builder: (_){
              return AlertDialog(
                title: Text('Error'),
                content: Text('Anda tidak dapat absen lebih dari 2 kali dalam 1 hari'),
                actions: [
                  TextButton(onPressed: (){Get.to(FullIndexWeb(employeeId));}, child: Text('Kembali'))
                ],
              );
            }
          );
        });
      }

      } else {
        // Handle other status codes
        setState(() {
          isLoading = false;
          showDialog(
            context: context, 
            builder: (_){
              return AlertDialog(
                title: Text('Error'),
                content: Text('Anda tidak dapat absen lebih dari 2 kali dalam 1 hari'),
                actions: [
                  TextButton(onPressed: (){
                    Get.to(FullIndexWeb(employeeId));
                  }, child: Text('Kembali'))
                ],
              );
            }
          );
        });
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Exception: $e');
      Get.snackbar('Error', 'An error occurred. Please try again later.');
    } finally {
      isLoading = false;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      isLoading = true;
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
              final cameras = await availableCameras();
              final firstCamera = cameras.last;
              setState(() {
                controller = CameraController(
                  widget.camera,
                  ResolutionPreset.medium,
                );

                initializeControllerFuture = controller.initialize();
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
                  final cameras = await availableCameras();
                  final firstCamera = cameras.last;
                  setState(() {
                    isLoading = false;
                  });
                } else {
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

      await controller.dispose();

      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Absence2(
            base64Image: base64Image,
            timestamp: timestamp,
          ),
        ),
      );
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Absen',
      home: isLoading ? Center(child: CircularProgressIndicator(),) : Scaffold(
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
      )
    );
  }
}

class Absence2 extends StatefulWidget {
  final String base64Image;
  final String timestamp;
  const Absence2({super.key, required this.base64Image,required this.timestamp});

  @override
  State<Absence2> createState() => _Absence2State();
}

class _Absence2State extends State<Absence2> {
  bool isLoading = false;
  String? leaveoptions;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  List<Map<String, dynamic>> noticationList = [];

  @override
  void initState() {
    super.initState();
    fetchNotification();
    fetchData();
  }

  Future<void> fetchNotification() async{
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

  Future<void> fetchData() async {
    String employeeId = storage.read('employee_id').toString();
    isLoading = true;
    try {
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
    } finally {
      isLoading = false;
    }
  }
  
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
                    Get.to(FullIndexWeb(employeeId));
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
                  onPressed: () {Get.to(FullIndexWeb(employeeId));}, 
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
                onPressed: () {Get.to(FullIndexWeb(employeeId));}, 
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
      var employeeId = storage.read('employee_id');
      var positionId = storage.read('position_id');
      var photo = storage.read('photo');
      Uint8List bytes = base64Decode(widget.base64Image);
      String absenceType = GetStorage().read('absence_type');

      return MaterialApp(
        title: "Absen",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 2,
                              child: Card(
                                shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12))),
                                color: Colors.white,
                                shadowColor: Colors.black,
                                child: Image.memory(bytes),
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Jam Absen', style: TextStyle(color: const Color.fromRGBO(116, 116, 116, 1), fontSize: 5.sp, fontWeight: FontWeight.w600,),),
                                  SizedBox(height: 5.h,),
                                  TextFormField(
                                    initialValue: _formatDate(widget.timestamp),
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1)
                                    ),
                                  ),
                                  SizedBox(height: 20.h,),
                                  Text('Tipe Absen', style: TextStyle(color: const Color.fromRGBO(116, 116, 116, 1), fontSize: 5.sp, fontWeight: FontWeight.w600,),),
                                  SizedBox(height: 5.h,),
                                  TextFormField(
                                    initialValue: absenceType,
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1)
                                    ),
                                  ),
                                  SizedBox(height: 20.h,),
                                  Text('Deskripsi', style: TextStyle(color: const Color.fromRGBO(116, 116, 116, 1), fontSize: 5.sp, fontWeight: FontWeight.w600,),),
                                  SizedBox(height: 5.h,),
                                  TextFormField(
                                    maxLines: 3,
                                    readOnly: false,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: "Isi deskripsi absen anda (Optional)"
                                    ),
                                  ),
                                ],
                              )
                            )
                          ],
                        ),
                        SizedBox(height: 40.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: (){
                                String a = widget.base64Image;
                                String absenceTypeId = GetStorage().read('absence_type_id');
                                int employeeId = GetStorage().read('employee_id');
                                String companyId = GetStorage().read('company_id');
                                String formattedTime = DateFormat('HH:mm').format(DateTime.parse(widget.timestamp));
                                String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.timestamp));
                                sendAbsence(a, absenceTypeId, employeeId, companyId, 'Absen melalui web', formattedTime, formattedDate);
                              }, 
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                alignment: Alignment.center,
                                minimumSize: Size(40.w, 55.h),
                                foregroundColor: const Color(0xFFFFFFFF),
                                backgroundColor: const Color(0xff4ec3fc),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text('Kumpul')
                            )
                          ],
                        )
                      ]
                    )
                  )
                )
            ]
          )
        ))          
      );
  }

  String _formatDate(String date) {
    // Parse the date string
    DateTime parsedDate = DateFormat("yyyy-MM-dd HH:mm").parse(date);

    // Format the date as "dd MMMM yyyy"
    return DateFormat("d MMMM yyyy HH:mm", "id").format(parsedDate);
  }
}