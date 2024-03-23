// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/web-version/login.dart';
import 'package:http/http.dart' as http;

class ForgotPassWeb extends StatefulWidget {
  final String username;
  const ForgotPassWeb({super.key, required  this.username});

  @override
  State<ForgotPassWeb> createState() => _ForgotPassWebState();
}

class _ForgotPassWebState extends State<ForgotPassWeb> {
  TextEditingController txtPass1 = TextEditingController();

  TextEditingController txtPass2 = TextEditingController();

  @override
  Widget build(BuildContext context) {

    bool containsWordsAndNumbers(String text) {
      // Check if the text contains both words and numbers
      return RegExp(r'(?=.*[a-zA-Z])(?=.*\d)').hasMatch(text);
    }
    
    Future<void> updatePassword() async{
      var username = widget.username;
      try {
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
          Get.to(const LoginPageDesktop());
        } else {
          Get.snackbar('Gagal', response.body);
          print('Failed to insert employee. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }

      } catch (e){
        Get.snackbar('Gagal', '$e');
        print('Exception during API call: $e');
      }
    }

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
                  'Ubah Password',
                  style: TextStyle(
                    fontSize: 48.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 3.sp,
                ),
                Text('Silahkan masukkan password baru anda',
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
                        'Password Baru',
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
                    controller: txtPass1,
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
                        hintText: 'Mohon masukkan password baru anda'),
                  ),
                ),
                SizedBox(
                  height: 20.sp,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, bottom: 2.w),
                      child: Text(
                        'Konfirmasi Password Baru',
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
                    controller: txtPass2,
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
                        hintText: 'Mohon konfirmasi password baru anda'),
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
                    if(txtPass1.text == '' || txtPass2.text == ''){
                      Get.snackbar('Invalid', 'Password baru tidak dapat kosong !!')
                    } else if (txtPass1.text.length <= 8 || !containsWordsAndNumbers(txtPass1.text)){
                      Get.snackbar('Invalid', 'Password baru minimal 8 karakter dan harus terdapat angka dan huruf !!')
                    } else{
                      updatePassword()
                    }
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
              children: [Image.asset('images/login.png')],
            ),
          )
        ],
      ),
    );
  }
}
