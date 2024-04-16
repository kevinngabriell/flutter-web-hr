import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
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
import 'package:dio/dio.dart' as dio;
import 'dart:html' as html;

class documentMobile extends StatefulWidget {
  const documentMobile({super.key});

  @override
  State<documentMobile> createState() => _documentMobileState();
}

class _documentMobileState extends State<documentMobile> {
  final storage = GetStorage();
  bool isLoading = false;
  String employeeId = GetStorage().read('employee_id').toString();
  final int _currentIndex = 0;

  String ktp = '-';
  String bpjs = '-';
  String npwp = '-';
  String simA = '-';
  String simC = '-';

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
  void initState() {
    super.initState();
    getProfileImage();
    getProfileImageBPJS();
    getProfileImageNPWP();
    getProfileImageSimA();
    getProfileImageSimC();
  }

  Future<void> getProfileImageSimC() async {
    setState(() => isLoading = true);
    try {
      final storage = GetStorage();
      String simCUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployeedoc.php?action=3&employee_id=${employeeId}';
      final simCresponse = await http.get(Uri.parse(simCUrl));

      if (simCresponse.statusCode == 200) {
        setState(() {
          Map<String, dynamic> simCdata = json.decode(simCresponse.body);
          simC = simCdata['simC'];
        });

      } else {
        setState(() {
          simC = '-';
        });
      }
    } catch (error) {
      simC = '-';
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> simCFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
    );

    if (result != null) {
      setState(() => isLoading = true);
      try {
        String base64Image = base64Encode(result.files.first.bytes!);
        String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/uploaddoc.php';
        var dioClient = dio.Dio();
        var data = {
          'employee_id': employeeId,
          'doc': base64Image,
          'action_id': '3'
        };

        dio.Response response = await dioClient.post(apiUrl, data: dio.FormData.fromMap(data));

        if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: Text('Upload sim C telah berhasil dilakukan'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                        Get.to(indexMobile(EmployeeID: employeeId,));
                      },
                    child: const Text('Oke'),
                  ),
                ],
              );
            },
          );
        } else {
          print(response.data);
          Get.snackbar("Error", "Error: ${response.statusCode}, ${response.data}");
        }
      } catch (e) {
        print('Error during file upload: $e');
      } finally {
        if (mounted) {
          setState(() => isLoading = false);
        }
      }
    }
  }


  Future<void> getProfileImageSimA() async {
    setState(() => isLoading = true);
    try {
      String simAUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployeedoc.php?action=2&employee_id=${employeeId}';
      final simAresponse = await http.get(Uri.parse(simAUrl));

      if (simAresponse.statusCode == 200) {
        Map<String, dynamic> simAdata = json.decode(simAresponse.body);
        simA = simAdata['simA'];
      } else {
        simA = '-';
      }
    } catch (error) {
      simA = '-';
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> simAFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
    );

    if (result != null) {
      setState(() => isLoading = true);
      try {
        String base64Image = base64Encode(result.files.first.bytes!);
        String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/uploaddoc.php';
        var data = {
          'employee_id': employeeId,
          'doc': base64Image,
          'action_id': '2'
        };

        var dioClient = dio.Dio();
        dio.Response response = await dioClient.post(apiUrl, data: dio.FormData.fromMap(data));

        if (response.statusCode == 200) {
          Get.dialog(
            AlertDialog(
              title: const Text('Sukses'),
              content: Text('Upload SIM A telah berhasil'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                        Get.to(indexMobile(EmployeeID: employeeId,));
                      },
                  child: const Text('Oke'),
                ),
              ],
            ),
          );
        } else {
          Get.snackbar("Error", "Error: ${response.statusCode}, ${response.data}");
        }
      } catch (e) {
        Get.snackbar("Error", "Exception occurred: $e");
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> getProfileImageNPWP() async {
    try {
      setState(() => isLoading = true);
      String npwpUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployeedoc.php?action=4&employee_id=${employeeId}';
      final npwpResponse = await http.get(Uri.parse(npwpUrl));

      if (npwpResponse.statusCode == 200) {
        setState(() {
          Map<String, dynamic> npwpData = json.decode(npwpResponse.body);
          npwp = npwpData['npwp'];
        });
      } else {
        setState(() {
          npwp = '-';
        });
      }
    } catch (error) {
      debugPrint('Error fetching NPWP document: $error');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> npwpFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
    );

    if (result != null) {
      setState(() => isLoading = true);
      try {
        String base64Image = base64Encode(result.files.first.bytes!);
        String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/uploaddoc.php';
        var data = {
          'employee_id': employeeId,
          'doc': base64Image,
          'action_id': '4'
        };

        var dioClient = dio.Dio();
        dio.Response response = await dioClient.post(apiUrl, data: dio.FormData.fromMap(data));

        if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Sukses'),
              content: Text('Upload NPWP telah berhasil dilakukan'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                        Get.to(indexMobile(EmployeeID: employeeId,));
                      },
                  child: const Text('Oke'),
                ),
              ],
            ),
          );
        } else {
          Get.snackbar("Error", "Error: ${response.statusCode}, ${response.data}");
        }
      } catch (e) {
        Get.snackbar("Error", "Exception occurred: $e");
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> bpjsFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
    );

    if (result != null) {
      setState(() => isLoading = true);
      try {
        String base64Image = base64Encode(result.files.first.bytes!);
        String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/uploaddoc.php';

        var data = {
          'employee_id': employeeId,
          'doc': base64Image,
          'action_id': '5'
        };

        var dioClient = dio.Dio();
        dio.Response response = await dioClient.post(apiUrl, data: dio.FormData.fromMap(data));

        if (response.statusCode == 200) {
          Get.dialog(
            AlertDialog(
              title: const Text('Sukses'),
              content: Text('Upload BPJS telah berhasil dilakukan'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                        Get.to(indexMobile(EmployeeID: employeeId,));
                      },
                  child: const Text('Oke'),
                ),
              ],
            ),
          );
        } else {
          Get.snackbar("Error", "Error: ${response.statusCode}, ${response.data}");
        }
      } catch (e) {
        Get.snackbar("Error", "Exception occurred: $e");
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  void downloadBase64Image(String base64String, String fileName) {
    // Remove the header from the base64 string
    String base64Data = base64String.split(',').last;

    // Convert the base64 string to a Uint8List
    Uint8List bytes = base64.decode(base64Data);

    // Create a Blob from the Uint8List
    final blob = html.Blob([bytes]);

    // Create a URL for the Blob
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Create an anchor element and trigger a download
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();

    // Revoke the URL after the download starts
    html.Url.revokeObjectUrl(url);
  }

  Future<void> getProfileImage() async {
    if (mounted) {
      setState(() => isLoading = true);
    }
    try {
      final storage = GetStorage();
      String imageUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployeedoc.php?action=1&employee_id=${employeeId}';
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (mounted) {
          setState(() {
            ktp = data['ktp'];
            isLoading = false;
          });
        }
      } else {
        ktp = '-';
        bpjs = '-';
      }
    } catch (error) {
      ktp = '-';
      print('Error KTP Document: $error');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> getProfileImageBPJS() async {
    setState(() => isLoading = true);
    try {
      String bpjsUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployeedoc.php?action=5&employee_id=${employeeId}';
      final bpjsResponse = await http.get(Uri.parse(bpjsUrl));

      if (bpjsResponse.statusCode == 200) {
        Map<String, dynamic> bpjsData = json.decode(bpjsResponse.body);
        bpjs = bpjsData['bpjs'];
      } else {
        bpjs = '-';
      }
    } catch (error) {
      bpjs = '-';
      print('Error fetching BPJS document: $error');
    } finally {
      setState(() => isLoading = false);
    }
  }
  
  Future<void> ktpFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
    );

    if (result != null) {
      if (mounted) {
        setState(() => isLoading = true);
      }
      try {
        String base64Image = base64Encode(result.files.first.bytes!);
        String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/uploaddoc.php';
        var dioClient = dio.Dio();
        var data = {
          'employee_id': employeeId,
          'doc': base64Image,
          'action_id': '1'
        };

        dio.Response response = await dioClient.post(apiUrl, data: dio.FormData.fromMap(data));
        if (response.statusCode == 200) {
          if (mounted) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Sukses'),
                  content: Text('Upload ktp telah berhasil dilakukan'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Get.to(indexMobile(EmployeeID: employeeId,));
                      },
                      child: const Text('Oke'),
                    ),
                  ],
                );
              },
            );
          }
        } else {
          print('Error: ${response.statusCode}, ${response.data}');
        }
      } catch (e) {
        print('Error during file upload: $e');
      } finally {
        if (mounted) {
          setState(() => isLoading = false);
        }
      }
    }
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
                child: Column(
                  children: [
                    SizedBox(height: 20.h,),
                    Padding(
                      padding: EdgeInsets.all(4.sp),
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        color: Colors.white,
                        shadowColor: Colors.black,
                        child: Padding(
                          padding: EdgeInsets.all(8.sp),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(child: Text('File KTP', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700))),
                              SizedBox(height: 5.sp),
                              Image.memory(base64Decode(ktp)),
                              SizedBox(height: 5.sp),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: (){
                                      String base64Image = 'data:image/jpeg;base64,$ktp';
                                      downloadBase64Image(base64Image, 'KTP.jpg');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(50.w, 55.h),
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color(0xff4ec3fc),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Download KTP')
                                  ),
                                  ElevatedButton(
                                    onPressed: ktpFile,
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(50.w, 55.h),
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color(0xff4ec3fc),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Upload KTP')
                                  ),
                                ],
                              )
                            ]
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    Padding(
                      padding: EdgeInsets.all(4.sp),
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        color: Colors.white,
                        shadowColor: Colors.black,
                        child: Padding(
                          padding: EdgeInsets.all(8.sp),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(child: Text('File BPJS', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700))),
                              SizedBox(height: 5.sp),
                              Image.memory(base64Decode(bpjs)),
                              SizedBox(height: 5.sp),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: (){
                                      String base64Image = 'data:image/jpeg;base64,$bpjs';
                                      downloadBase64Image(base64Image, 'BPJS.jpg');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(50.w, 55.h),
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color(0xff4ec3fc),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Download BPJS')
                                  ),
                                  ElevatedButton(
                                    onPressed: bpjsFile,
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(50.w, 55.h),
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color(0xff4ec3fc),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Upload BPJS')
                                  ),
                                ],
                              )
                            ]
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    Padding(
                      padding: EdgeInsets.all(4.sp),
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        color: Colors.white,
                        shadowColor: Colors.black,
                        child: Padding(
                          padding: EdgeInsets.all(8.sp),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(child: Text('File NPWP', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700))),
                              SizedBox(height: 5.sp),
                              Image.memory(base64Decode(npwp)),
                              SizedBox(height: 5.sp),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: (){
                                      String base64Image = 'data:image/jpeg;base64,$npwp';
                                      downloadBase64Image(base64Image, 'NPWP.jpg');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(50.w, 55.h),
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color(0xff4ec3fc),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Download NPWP')
                                  ),
                                  ElevatedButton(
                                    onPressed: npwpFile,
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(50.w, 55.h),
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color(0xff4ec3fc),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Upload NPWP')
                                  ),
                                ],
                              )
                            ]
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    Padding(
                      padding: EdgeInsets.all(4.sp),
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        color: Colors.white,
                        shadowColor: Colors.black,
                        child: Padding(
                          padding: EdgeInsets.all(8.sp),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(child: Text('File SIM A', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700))),
                              SizedBox(height: 5.sp),
                              Image.memory(base64Decode(simA)),
                              SizedBox(height: 5.sp),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: (){
                                      String base64Image = 'data:image/jpeg;base64,$simA';
                                      downloadBase64Image(base64Image, 'SIM A.jpg');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(50.w, 55.h),
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color(0xff4ec3fc),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Download SIM A')
                                  ),
                                  ElevatedButton(
                                    onPressed: simAFile,
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(50.w, 55.h),
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color(0xff4ec3fc),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Upload SIM A')
                                  ),
                                ],
                              )
                            ]
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    Padding(
                      padding: EdgeInsets.all(4.sp),
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        color: Colors.white,
                        shadowColor: Colors.black,
                        child: Padding(
                          padding: EdgeInsets.all(8.sp),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(child: Text('File SIM C', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700))),
                              SizedBox(height: 5.sp),
                              Image.memory(base64Decode(simC)),
                              SizedBox(height: 5.sp),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: (){
                                      String base64Image = 'data:image/jpeg;base64,$simC';
                                      downloadBase64Image(base64Image, 'SIM C.jpg');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(50.w, 55.h),
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color(0xff4ec3fc),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Download SIM C')
                                  ),
                                  ElevatedButton(
                                    onPressed: simCFile,
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(50.w, 55.h),
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color(0xff4ec3fc),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Upload SIM C')
                                  ),
                                ],
                              )
                            ]
                          ),
                        ),
                      ),
                    ),
                  ]
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
}