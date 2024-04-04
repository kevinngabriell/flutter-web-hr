import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/mobile-version/login.dart';
import 'package:http/http.dart' as http;

class changePasswordMobile extends StatefulWidget {
  final String username;
  const changePasswordMobile({super.key, required this.username});

  @override
  State<changePasswordMobile> createState() => _changePasswordMobileState();
}

class _changePasswordMobileState extends State<changePasswordMobile> {
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
          Get.to(const MobileLogin());
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
                  Text('Ubah Password',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 7.h,),
                  Text('Silahkan masukkan password baru anda',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w300,
                    )
                  ),
                ]
              ),
              SizedBox(
                height: 10.sp,
              ),
              Text('Password Baru',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                )
              ),
              SizedBox(height: 5.h,),
              TextFormField(
                controller: txtPass1,
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
                  hintText: 'Mohon masukkan password baru anda'
                  ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text('Konfirmasi Password Baru',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                )
              ),
              SizedBox(height: 5.h,),
              TextFormField(
                controller: txtPass2,
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
                  hintText: 'Mohon konfirmasi password baru anda'
                  ),
              ),
              SizedBox(height: 25.h,),
              Center(
              child: ElevatedButton(
                onPressed: () async {
                  if(txtPass1.text == '' || txtPass2.text == ''){
                      Get.snackbar('Invalid', 'Password baru tidak dapat kosong !!');
                    } else if (txtPass1.text.length <= 8 || !containsWordsAndNumbers(txtPass1.text)){
                      Get.snackbar('Invalid', 'Password baru minimal 8 karakter dan harus terdapat angka dan huruf !!');
                    } else{
                      updatePassword();
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
                      'Ubah Password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w700),
                    ),
                )
              ),
            )
            ]
          )
        )
      )
    );
  }
}