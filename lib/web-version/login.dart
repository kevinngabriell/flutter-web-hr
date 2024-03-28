// ignore_for_file: must_be_immutable, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/forgot-pass.dart';
import 'package:hr_systems_web/web-version/full-access/index.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPageDesktop extends StatefulWidget {
  const LoginPageDesktop({super.key});

  @override
  State<LoginPageDesktop> createState() => _LoginPageDesktopState();
}

class _LoginPageDesktopState extends State<LoginPageDesktop> {
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool isLoading = false;

  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
    });

    var apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/account/login.php';
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
        },
      );


      if (response.statusCode == 200) {
        var result = json.decode(response.body);

        if(txtPassword.text == '123456'){
          Get.to(ForgotPassWeb(username: txtUsername.text));
        } else {
          GetStorage().write('employee_id', result['employee_id']);
          GetStorage().write('company_id', result['company_id']);
          GetStorage().write('username', result['username']);

          checkPosition();
        }

      } else if (response.statusCode == 400) {
        Get.snackbar('Error', 'Silahkan periksa kembali username dan password anda');
      } else {
        print('Error: ${response.statusCode}');
        Get.snackbar('Error', 'An error occurred. Please try again later.');
      }
    } catch (e) {
      showDialog(
        context: context, 
        builder: (_){
          return AlertDialog(
            title: const Text('Server Error'),
            content: const Text('Silahkan hubungi dept IT untuk pemeriksaan server'),
            actions: [
              TextButton(
                onPressed: (){
                  Get.back();
                }, 
                child: const Text('Oke')
              )
            ],
          );
        }
      );
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

    var apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-systems-data-v.1/PositionSelectionMethod.php';

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'username': txtUsername.text,
        },
      );

      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        
        final storage = GetStorage();

        var employeeId = storage.read('employee_id');
        GetStorage().write('position_id', result['position_id']);

        getProfileImage();
      } else {
        print('Response body: ${response.body}');
        Get.snackbar('Error', 'An error occurred. Please try again later.');
      }
    } catch (e) {
      print('Exception: $e ini ya yg error');
      Get.snackbar('Error', 'An error occurred. Please try again later.');
    } finally {
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
        Get.to(FullIndexWeb(employeeId));
        
        
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
    return Scaffold(
        body: Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text(
                  'Masuk',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 3.sp,
                ),
                Text('Silahkan masukkan username dan password anda untuk masuk',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 5.sp,
                      fontWeight: FontWeight.w300,
                    )),
                SizedBox(
                  height: 10.sp,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 18.w, bottom: 2.w),
                      child: Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 5.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.6,
                  child: TextField(
                    controller: txtUsername,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          // Border when the field is enabled
                          borderSide: const BorderSide(width: 0.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          // Border when the field is focused
                          borderSide: const BorderSide(width: 0.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: 'Mohon masukkan username anda'),
                  ),
                ),
                SizedBox(
                  height: 8.sp,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 18.w, bottom: 2.w),
                      child: Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 5.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.6,
                  child: TextField(
                    controller: txtPassword,
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
                        hintText: 'Mohon masukkan password anda'),
                  ),
                ),
                SizedBox(
                  height: 8.sp,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(top: 1.w, left: 130.w, bottom: 10.w),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                                      context: context, 
                                      builder: (_) {
                                        return AlertDialog(
                                          title: const Text("Error"),
                                          content: const Text('Anda tidak dapat mengganti password anda. Silahkan hubungi HRD atau tim IT support untuk melakukan reset password'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {Get.back();},
                                              child: const Text('Oke'),
                                            ),
                                          ],
                                        );
                                      }
                                    );
                        },
                        child: Text('Lupa password',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 5.sp,
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(const Color(0xff4ec3fc)),
                    foregroundColor: MaterialStateProperty.all(const Color(0xFFFFFFFF)),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2.8,
                    height: MediaQuery.of(context).size.height * 0.07,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Masuk',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 5.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                  onPressed: () => {
                    if (txtUsername.text == "")
                      {
                        Get.dialog(Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 350.sp),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10.0.sp),
                                  child: Material(
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Invalid",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 30.sp,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        SizedBox(height: 15.sp),
                                        Text(
                                          "Username anda masih kosong!! Silahkan diisi username anda",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        SizedBox(height: 25.sp),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  minimumSize: Size(0.sp, 45.sp),
                                                  foregroundColor: const Color(0xFFFFFFFF),
                                                  backgroundColor: const Color(0xff4ec3fc),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: const Text(
                                                  'Oke',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ))
                      }
                    else if (txtPassword.text == "")
                      {
                        Get.dialog(Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 350.sp),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10.0.sp),
                                  child: Material(
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Invalid",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 30.sp,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        SizedBox(height: 15.sp),
                                        Text(
                                          "Password anda masih kosong!! Silahkan diisi password anda",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        SizedBox(height: 25.sp),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  minimumSize: Size(0.sp, 45.sp),
                                                  foregroundColor: const Color(0xFFFFFFFF),
                                                  backgroundColor: const Color(0xff4ec3fc),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: const Text(
                                                  'Oke',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ))
                      }
                    else if (txtUsername.text != "" && txtPassword.text != "")
                      {
                        loginUser()
                      }
                  },
                ),
                if (isLoading) const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 2,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset('images/login.png')],
          ),
        ),
        
      ],
    ),
    
    );
  }
}
