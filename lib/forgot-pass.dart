import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/web-version/login.dart';

class ForgotPassWeb extends StatelessWidget {
  const ForgotPassWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Reset Akun',
                  style: TextStyle(
                    fontSize: 48.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 3.sp,
                ),
                Text('Masukkan username anda untuk dilakukan reset akun',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w300,
                    )),
                SizedBox(
                  height: 35.sp,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, bottom: 2.w),
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
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 0.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 0.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: 'Mohon masukkan username anda'),
                  ),
                ),
                SizedBox(
                  height: 55.sp,
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
                      'Reset Akun',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                  onPressed: () => {
                    Get.dialog(
                      Column(
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
                                      Image.asset(
                                        'images/success-check-02.png',
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3.sp,
                                      ),
                                      SizedBox(height: 10.sp),
                                      Text(
                                        "Sukses",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 30.sp,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      SizedBox(height: 15.sp),
                                      Text(
                                        "Akun anda telah berhasil di reset. Silahkan login kembali",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      SizedBox(height: 25.sp),
                                      //Buttons
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              child: const Text(
                                                'Oke',
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size(0.sp, 45.sp),
                                                foregroundColor: const Color(0xFFFFFFFF), 
                                                backgroundColor: const Color(0xff4ec3fc),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              onPressed: () {
                                                Get.to(LoginPageDesktop());
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
                          ),
                        ],
                      ),
                    )
                    // Get.defaultDialog(
                    //   content: Container(
                    //     width: MediaQuery.of(context).size.width * 0.2,
                    //     child: Image.asset('images/login.png'),
                    //   ),
                    //   title: "Sukses",
                    //   titleStyle: TextStyle(
                    //     fontSize: 35.sp,
                    //     fontWeight: FontWeight.w700
                    //   ),
                    //   middleText: "Akun anda telah berhasil di reset. Silahkan login kembali",
                    //   middleTextStyle: TextStyle(
                    //     fontSize: 16.sp,
                    //     fontWeight: FontWeight.w500
                    //   ),
                    //   textConfirm: "Oke",
                    //   buttonColor: Color(0xff4ec3fc),
                    //   confirmTextColor: Colors.white,
                    //   onConfirm: () {
                    //     Get.to(LoginPageDesktop());
                    //   }
                    // )
                  },
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('data'), Text('data')],
            ),
          )
        ],
      ),
    );
  }
}
