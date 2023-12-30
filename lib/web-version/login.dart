import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/forgot-pass.dart';
import 'package:hr_systems_web/web-version/full-access/index.dart';

class LoginPageDesktop extends StatelessWidget {
  LoginPageDesktop({super.key});

  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

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
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Masuk',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 48.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 6.sp,
                ),
                Text('Silahkan masukkan username dan password anda untuk masuk',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w300,
                    )),
                SizedBox(
                  height: 40.sp,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 18.w, bottom: 2.w),
                      child: Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 16.sp,
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
                  height: 20.sp,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 18.w, bottom: 2.w),
                      child: Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 16.sp,
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
                  height: 10.sp,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(top: 1.w, left: 130.w, bottom: 10.w),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(ForgotPassWeb());
                        },
                        child: Text('Lupa password',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xff4ec3fc)),
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
                          fontSize: 20.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                  onPressed: () => {
                    if (txtUsername.text == "")
                      {
                        Get.dialog(Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 550.sp),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(20.0.sp),
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
                                                child: const Text(
                                                  'Oke',
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  minimumSize:
                                                      Size(0.sp, 45.sp),
                                                  foregroundColor:
                                                      const Color(0xFFFFFFFF),
                                                  backgroundColor:
                                                      const Color(0xff4ec3fc),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Get.back();
                                                },
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
                              padding: EdgeInsets.symmetric(horizontal: 550.sp),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(20.0.sp),
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
                                                child: const Text(
                                                  'Oke',
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  minimumSize:
                                                      Size(0.sp, 45.sp),
                                                  foregroundColor:
                                                      const Color(0xFFFFFFFF),
                                                  backgroundColor:
                                                      const Color(0xff4ec3fc),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Get.back();
                                                },
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
                      {Get.to(const FullIndexWeb())}
                  },
                ),
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
        )
      ],
    ));
  }
}
