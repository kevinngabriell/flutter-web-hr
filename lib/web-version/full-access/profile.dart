// ignore_for_file: implementation_imports, avoid_print
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'index.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  bool isLoading = false;
  TextEditingController txtPass1 = TextEditingController();
  TextEditingController txtPass2 = TextEditingController();

  TextEditingController employeeUsername = TextEditingController();
  TextEditingController employeeNameText = TextEditingController();

  final storage = GetStorage();

  Future<void> fetchData() async {
    String employeeId = storage.read('employee_id').toString();

    try {
      isLoading = true;
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
          employeeNameText.text = data['employee_name'] as String;
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
        Get.to(const ProfilePage());  
      }
    }

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchEmployeeUsername();
  }

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    var employeeId = storage.read('employee_id');
    var positionId = storage.read('position_id');
    var photo = storage.read('photo');
    
    bool containsWordsAndNumbers(String text) {
      return RegExp(r'(?=.*[a-zA-Z])(?=.*\d)').hasMatch(text);
    }

    return MaterialApp(
      title: "Profile",
      home: Scaffold(
        body: isLoading ? const Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
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
                        SizedBox(height: 10.sp,),
                      ],
                    ),
                  ),
                ),
                //content menu
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: EdgeInsets.only(left: 7.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15.sp,),
                        //Profile Name
                        NotificationnProfile(employeeName: employeeName, employeeAddress: employeeEmail, photo: photo),
                        SizedBox(height: 10.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 160.w) / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Nama Lengkap",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 7.h,),
                                  if(isLoading)
                                    const CircularProgressIndicator()
                                  else
                                    TextFormField(
                                      controller: employeeNameText,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                                        hintText: 'Masukkan nama anda'
                                      ),
                                      readOnly: true,
                                    )
                                ],
                              ),
                            ),
                            SizedBox(width: 10.sp,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 160.w) / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Username",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 7.h,),
                                  if(isLoading)
                                    const CircularProgressIndicator()
                                  else
                                    TextFormField(
                                      controller: employeeUsername,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                                        hintText: 'Masukkan username anda'
                                      ),
                                      readOnly: false,
                                    )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 160.w) / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Password baru",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 7.h,),
                                  if(isLoading)
                                    const CircularProgressIndicator()
                                  else
                                    TextField(
                                      //controller: txtNamaLengkap,
                                      controller: txtPass1,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                                        hintText: 'Masukkan password baru anda'
                                      ),
                                    )
                                ],
                              ),
                            ),
                            SizedBox(width: 10.sp,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 160.w) / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Konfirmasi password baru",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 7.h,),
                                  if(isLoading)
                                    const CircularProgressIndicator()
                                  else
                                    TextField(
                                      //controller: txtNamaLengkap,
                                      controller: txtPass2,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                                        hintText: 'Konfirmasi password baru anda'
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 160.w) / 4,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize:
                                    Size(0.sp, 15.sp),
                                    foregroundColor:
                                      const Color(0xFFFFFFFF),
                                    backgroundColor:
                                      const Color(0xff4ec3fc),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                        BorderRadius.circular(8),
                                    ),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Update',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                onPressed: () async => {
                                  if (employeeUsername.text != '') {
                                    if (txtPass1.text != '' || txtPass2.text != '') {
                                      if (txtPass1.text == '' || txtPass2.text == '') {
                                        Get.snackbar('Invalid', 'Password baru tidak dapat kosong !!')
                                      } else if (txtPass1.text.length <= 8 || !containsWordsAndNumbers(txtPass1.text)) {
                                        Get.snackbar('Invalid', 'Password baru minimal 8 karakter dan harus terdapat angka dan huruf !!')
                                      } else {
                                        // await updateUsername(),
                                        updatePassword(),
                                        Get.dialog(
                                        AlertDialog(
                                          title: const Text('Sukses'),
                                          content: const Text('Password telah berhasil diupdate !!'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {Get.to(FullIndexWeb(employeeId));},
                                              child: const Text('Oke'),
                                            ),
                                          ],
                                        )
                                      )
                                        
                                      }
                                    } else {
                                      await updateUsername(),
                                      Get.dialog(
                                        AlertDialog(
                                          title: const Text('Sukses'),
                                          content: const Text('Username telah berhasil diupdate !!'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {Get.to(FullIndexWeb(employeeId));},
                                              child: const Text('Oke'),
                                            ),
                                          ],
                                        )
                                      )
                                    }
                                  } else {
                                    // Handle the case when employeeUsername.text is empty
                                  }

  
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ),
                
            ],
          )
        ),
      ),
    );
  }
}