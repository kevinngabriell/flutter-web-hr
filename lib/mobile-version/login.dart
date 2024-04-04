// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/mobile-version/changepassword.dart';
import 'package:hr_systems_web/mobile-version/indexMobile.dart';
import 'package:http/http.dart' as http;

class MobileLogin extends StatefulWidget {
  const MobileLogin({super.key});

  @override
  State<MobileLogin> createState() => _MobileLoginState();
}

class _MobileLoginState extends State<MobileLogin> {
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool isLoading = false;
  String? leaveoptions;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String positionName = '';
  String sisaCuti = '';

  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
    });

    // Replace 'your_api_endpoint' with your actual API endpoint
    var apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-systems-data-v.1/LoginAPI.php';
    var client = http.Client();
    
    try {
      var response = await client.post(
        Uri.parse(apiUrl),
        body: {
          'username': txtUsername.text,
          'password': txtPassword.text,
        },
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          // Add other headers as needed
        },
        // withCredentials: true,
      );


      if (response.statusCode == 200) {
        // Successful login, handle the response data here
        var result = json.decode(response.body);

        if(txtPassword.text == '123456'){
          Get.to(changePasswordMobile(username: txtUsername.text));
        } else {
          // Save user data to session using GetStorage
          GetStorage().write('employee_id', result['employee_id']);
          GetStorage().write('company_id', result['company_id']);
          GetStorage().write('username', result['username']);

          // Navigate to the FullIndexWeb screen
          checkPosition();
        }

      } else if (response.statusCode == 400) {
        // Show an alert dialog for a bad request
        Get.snackbar('Error', 'Invalid credentials. Please try again.');
      } else {
        // Handle other status codes here
        print('Error: ${response.statusCode}');
        Get.snackbar('Error', '${response.statusCode} An error occurred. Please try again later.');
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Exception: $e');
      Get.snackbar('Error', '$e');
    } finally {
      client.close();

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> checkPosition() async{
    setState(() {
      isLoading = true;
    });

    // Replace with your actual API endpoint
    var apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-systems-data-v.1/PositionSelectionMethod.php';

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'username': txtUsername.text,
        },
      );

      if (response.statusCode == 200) {
        // Successful API call, parse the JSON response
        var result = json.decode(response.body);
        
        // Access the GetStorage instance
        final storage = GetStorage();

        // Retrieve the stored employee_id
        var employeeId = storage.read('employee_id');
        GetStorage().write('position_id', result['position_id']);

        fetchData();
      } else {
        // Handle other status codes
        print('Error: ${response.statusCode} sini');
        print('Response body: ${response.body}');
        Get.snackbar('Error', 'An error occurred. Please try again later.');
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Exception: $e ini ya yg error');
      Get.snackbar('Error', 'An error occurred. Please try again later.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  final GetStorage storage = GetStorage();

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    String employeeId = GetStorage().read('employee_id').toString();

    try {
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

         setState(() {
          isLoading = false;
        });

        getProfileImage();

      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
          setState(() {
            isLoading = false;
          });
      }
    } catch (e) {
      print('Exception during API call: $e');
        setState(() {
          isLoading = false;
        });
    }
  }

  Future<void> getProfileImage() async{
    setState(() {
      isLoading = true;
    });

    try {
      final storage = GetStorage();

      var employeeId = storage.read('employee_id');
      String imageUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/account/getprofilepicture.php?employee_id=$employeeId';

      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        // Decode base64 image
        Map<String, dynamic> data = json.decode(response.body);
        String profilePictureBased64 = data['photo'];

        GetStorage().write('photo', profilePictureBased64);
        final storage = GetStorage();

        var employeeId = storage.read('employee_id');
        Get.to(indexMobile(EmployeeID: employeeId.toString()));
      } else {
        // Handle error
        print('Failed to load image. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle exception
      print('Error: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile HR Kinglab',
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.h,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp,),
                  Text('Halo, selamat datang! ',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 7.h,),
                  Text('Silahkan mengisi username dan password untuk masuk ke dalam aplikasi',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w300,
                    )
                  ),
                ],
              ),
              SizedBox(height: 30.h,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ 
                Text('Masukkan username',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  )
                ),
                SizedBox(height: 5.h,),
                TextFormField(
                  controller: txtUsername,
                  textCapitalization: TextCapitalization.none,
                  obscureText: false,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 0.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 0.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: 'Mohon masukkan username anda'
                  ),
                ),
                SizedBox(height: 20.h,),
                Text('Masukkan password',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  )
                ),
                SizedBox(height: 5.h,),
                TextFormField(
                  controller: txtPassword,
                  textCapitalization: TextCapitalization.none,
                  obscureText: true,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 0.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 0.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: 'Mohon masukkan password anda'
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context, 
                          builder: (_) {
                            return AlertDialog(
                              title: const Text('Error', textAlign: TextAlign.center,),
                              content: const Text('Anda tidak dapat melakukan reset password. Silahkan hubungi HRD atau IT Support untuk melakukan reset password', textAlign: TextAlign.justify,),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  }, 
                                  child: const Text('Oke')
                                )
                              ],
                            );
                          }
                        );
                      },
                      child: Text(
                        'Lupa password',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 25.h,),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if(txtUsername.text == ''){
                    Get.snackbar('Error', 'Username anda masih kosong');
                  } else if(txtPassword.text == ''){
                    Get.snackbar('Error', 'Password anda masih kosong');
                  } else {
                    loginUser();
                  }
                }, 
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  alignment: Alignment.centerLeft,
                  minimumSize: Size(60.w, 55.h),
                  foregroundColor: const Color(0xFFFFFFFF),
                  backgroundColor: const Color(0xff4ec3fc),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height * 0.05,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    
                    child: Text(
                      'Masuk',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w700),
                    ),
                )
              ),
            )
            ],
          ),
        )
      ),
    );
  }
}