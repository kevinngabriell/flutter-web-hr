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

class changeProfileMobile extends StatefulWidget {
  const changeProfileMobile({super.key});

  @override
  State<changeProfileMobile> createState() => _changeProfileMobileState();
}

class _changeProfileMobileState extends State<changeProfileMobile> {
  final storage = GetStorage();
  bool isLoading = false;
  String employeeId = GetStorage().read('employee_id').toString();
  final int _currentIndex = 4;
  TextEditingController txtPass1 = TextEditingController();
  TextEditingController txtPass2 = TextEditingController();
  TextEditingController employeeUsername = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchEmployeeUsername();
  }

  Future<void> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
    );

    if (result != null) {
      String selectedFileName = result.files.first.name;
      List<int> imageBytes = result.files.first.bytes!;

      // Convert the image bytes to base64
      String base64Image = base64Encode(imageBytes);

      try{
        setState(() {
          isLoading = true;
        });

        String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/uploademployeephoto.php';

        var data = {
          'employee_id' : employeeId,
          'photo': base64Image
        };

        // Send the request using dio for multipart/form-data
        var dioClient = dio.Dio();
        dio.Response response = await dioClient.post(apiUrl, data: dio.FormData.fromMap(data));
        if (response.statusCode == 200) {

          showDialog(
            context: context, // Make sure to have access to the context
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Upload foto karyawan telah berhasil dilakukan'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Oke'),
                  ),
                ],
              );
            },
          );
        } else {
          Get.snackbar("Error", "Error: ${response.statusCode}, ${response.data}");
        }
      } catch(e){
        Get.snackbar("Error", "Error: $e");
      } finally{
        setState(() {
          isLoading = false;
        });
      }

    } else {
      // User canceled the file picking
    }
  }

  Future<void> fetchEmployeeUsername() async {
    String employeeId = storage.read('employee_id').toString();

    try {
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/account/getusername.php';
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
          employeeUsername.text = data['username'] as String;
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

  Future<void> updatePassword() async{
      var username = employeeUsername.text;

      try {
        isLoading = true;
        String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/account/changepassword.php';

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "username": username,
            "new_pass": txtPass1.text
          }
        );

        if(response.statusCode == 200){
          Get.snackbar('Sukses', 'Password anda telah berhasil diubah');
          Get.back();
        } else {
          Get.snackbar('Gagal', response.body);
          print('Failed to insert employee. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }

      } catch (e){
        Get.snackbar('Gagal', '$e');
        print('Exception during API call: $e');
      } finally {
        isLoading = false;  
      }
    }

    Future<void> updateUsername() async {
      var username = employeeUsername.text;
      String employeeId = storage.read('employee_id').toString();
      
      try {
        isLoading = true;
        String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/account/changeusername.php';

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "employee_id": employeeId,
            "new_username": employeeUsername.text
          }
        );

        if(response.statusCode == 200) {
          Get.snackbar('Sukses', 'Username anda telah berhasil diubah');
          Get.back();
        } else {
          Get.snackbar('Gagal', response.body);
          print('Failed to insert employee. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        Get.snackbar('Gagal', '$e');
        print('Exception during API call: $e');
      } finally {
        isLoading = false;  
        Get.to(MyProfileMobile(employeeId: employeeId,));  
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

    bool containsWordsAndNumbers(String text) {
      return RegExp(r'(?=.*[a-zA-Z])(?=.*\d)').hasMatch(text);
    }

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
              Padding(
                      padding: EdgeInsets.only(top: 10.sp, left: 15.sp),
                      child: Row(
                        children: [
                          Image.memory(base64Decode(photo), width: MediaQuery.of(context).size.width * 0.13,),
                          SizedBox(width: 10.w,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(employee_name,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              Text(position_name,
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
              SizedBox(height: 35.h,),
              Text("Username",
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromRGBO(116, 116, 116, 1)
                ),
              ),
              SizedBox(height: 7.h,),
              TextFormField(
                controller: employeeUsername,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                  hintText: 'Masukkan username anda'
                ),
              ),
              SizedBox(height: 20.h,),
              Text("Password Baru",
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromRGBO(116, 116, 116, 1)
                ),
              ),
              SizedBox(height: 7.h,),
              TextFormField(
                controller: txtPass1,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                  hintText: 'Masukkan password baru anda'
                ),
              ),
              SizedBox(height: 20.h,),
              Text("Konfirmasi Password Baru",
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromRGBO(116, 116, 116, 1)
                ),
              ),
              SizedBox(height: 7.h,),
              TextFormField(
                controller: txtPass2,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                  hintText: 'Masukkan konfirmasi password baru anda'
                ),
              ),
              SizedBox(height: 40.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 50.w) / 2,
                    child: ElevatedButton(
                      onPressed: (){
                        selectFile();
                      }, 
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(40.w, 55.h),
                        foregroundColor: const Color(0xFFFFFFFF),
                        backgroundColor: const Color(0xff4ec3fc),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Upload Foto Profil')
                    ),
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 50.w) / 2,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (employeeUsername.text != '') {
                                    if (txtPass1.text != '' || txtPass2.text != '') {
                                      if (txtPass1.text == '' || txtPass2.text == '') {
                                        Get.snackbar('Invalid', 'Password baru tidak dapat kosong !!');
                                      } else if (txtPass1.text.length <= 8 || !containsWordsAndNumbers(txtPass1.text)) {
                                        Get.snackbar('Invalid', 'Password baru minimal 8 karakter dan harus terdapat angka dan huruf !!');
                                      } else {
                                        // await updateUsername(),
                                        updatePassword();
                                        Get.dialog(
                                        AlertDialog(
                                          title: const Text('Sukses'),
                                          content: const Text('Password telah berhasil diupdate !!'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {Get.to(indexMobile(EmployeeID: employeeId,));},
                                              child: const Text('Oke'),
                                            ),
                                          ],
                                        )
                                      );
                                        
                                      }
                                    } else {
                                      await updateUsername();
                                      Get.dialog(
                                        AlertDialog(
                                          title: const Text('Sukses'),
                                          content: const Text('Username telah berhasil diupdate !!'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {Get.to(indexMobile(EmployeeID: employeeId,));},
                                              child: const Text('Oke'),
                                            ),
                                          ],
                                        )
                                      );
                                    }
                                  } else {
                                    // Handle the case when employeeUsername.text is empty
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
                      child: Text('Update')
                    ),
                  )
                ],
              )
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
}