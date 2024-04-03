// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Employee%20Detail/EmployeeDetailOne.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as dio;

class GeneralInformation extends StatefulWidget {
  final String employeeId;
  const GeneralInformation({super.key, required this.employeeId});

  @override
  State<GeneralInformation> createState() => _GeneralInformationState();
}

class _GeneralInformationState extends State<GeneralInformation> {
  String employeeID = '';
  String employeeNIK = '';
  String username = '';
  String gender = '';
  String dob = '';
  String pob = '';
  String status = '';
  String phone = '';
  String namaKaryawan = '';
  String emailKaryawan = '';
  String? namaSPV;
  bool isLoading = false;
  String spvID = '';
  List<Map<String, String>> spvName = [];
  String selectedSPV = '';

  String formatDate(String date) {
    // Parse the date string
    DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(date);

    // Format the date as "dd MMMM yyyy" in Indonesian locale
    return DateFormat("d MMMM yyyy", 'id').format(parsedDate);
  }

  @override
  void initState() {
    super.initState();
    fetchEmployeeData(widget.employeeId);
    fetchSPVdata();
  }

  Future<void> fetchSPVdata() async {
    try{
      isLoading = true;
      final response = await http.get(Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/account/getspvlist.php'));

      if(response.statusCode == 200){
        final data = json.decode(response.body);
        spvName= (data['Data'] as List).map((spv) => Map<String, String>.from(spv)).toList();
        selectedSPV = spvName[0]['id']!;
      } else {
        print('Failed to fetch data');
      }
    } catch (e){
      print('error : $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> deleteAccount(String employeeId) async {
    const String apiUrl = "https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/account/deleteaccount.php";

    try{
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'id': employeeId
        }
      );

      if(response.statusCode == 200){
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Sukses"),
              content: const Text("Akun telah berhasil dihapus"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.back();
                  }, 
                  child: const Text("Kembali")
                ),
              ],
            );
          }
        );
      } else if (response.statusCode == 300){
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Gagal"),
              content: const Text("User tidak terdaftar. Silahkan buat user terlebih dahulu"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.back();
                  }, 
                  child: const Text("Ok")
                ),
              ],
            );
          }
        );
      } else {
        Get.snackbar("Error", "Gagal hapus akun");
      }


    } catch (e){
      Get.snackbar("Error", "Error message : $e");
    }
  }

  Future<void> resetAccount(String employeeId) async {
    const String apiUrl = "https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/account/resetaccount.php";

    try{
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'id': employeeId
        }
      );

      if(response.statusCode == 200){
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Sukses"),
              content: const Text("Password user telah berhasil direset"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.back();
                  }, 
                  child: const Text("Kembali")
                ),
              ],
            );
          }
        );
      } else if (response.statusCode == 300){
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Gagal"),
              content: const Text("User tidak terdaftar. Silahkan buat user terlebih dahulu"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.back();
                  }, 
                  child: const Text("Ok")
                ),
              ],
            );
          }
        );
      } else {
        Get.snackbar("Error", "Gagal reset akun");
      }


    } catch (e){
      Get.snackbar("Error", "Error message : $e");
    }
  }

  Future<void> createAccount(String employeeId) async {
    const String apiUrl = "https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/account/createaccount.php";

    try{
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'id': employeeId
        }
      );

      if(response.statusCode == 200){
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Sukses"),
              content: const Text("User telah berhasil dibuat"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.back();
                  }, 
                  child: const Text("Kembali")
                ),
              ],
            );
          }
        );
      } else if (response.statusCode == 300){
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Gagal"),
              content: const Text("User telah terdaftar. Silahkan periksa kembali username dan password anda"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.back();
                  }, 
                  child: const Text("Ok")
                ),
              ],
            );
          }
        );
      } else {
        Get.snackbar("Error", "Gagal membuat akun");
      }

    } catch (e){
      Get.snackbar("Error", "Error message : $e");
    }

  }

  Future<void> fetchEmployeeData(String employeeId) async {
    try{
      isLoading = true;

      final response = await http.get(Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployeeoverview.php?employee_id=$employeeId'),);
     
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        
        employeeID = jsonData['Data'][0]['employee_id'];
        status = jsonData['Data'][0]['employee_status_name'];
        phone = jsonData['Data'][0]['employee_phone_number'];
        namaKaryawan = jsonData['Data'][0]['employee_name'];
        emailKaryawan = jsonData['Data'][0]['employee_email'];
        pob = jsonData['Data'][0]['employee_pob'];
        dob = jsonData['Data'][0]['employee_dob'];
        gender = jsonData['Data'][0]['gender_name'];
        username = jsonData['Data'][0]['username'] ?? '-';
        employeeNIK = jsonData['Data'][0]['employee_identity'];
        spvID = jsonData['Data'][0]['employee_spv'];

        final responseSPVName = await http.get(Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployee.php?action=3&spv_id=$spvID'));

        if(responseSPVName.statusCode == 200){
          final SPVNamedata = json.decode(responseSPVName.body);
          spvName= (SPVNamedata['Data'] as List).map((spv) => Map<String, String>.from(spv)).toList();

          setState(() {
            namaSPV = spvName[0]['employee_name'];
          });
        } else {
          setState(() {
            namaSPV = '-';
          });
        }
      } else {
        throw Exception('Failed to load employee data');
      }
    } catch (e){
      print('error : $e');
    } finally {
      isLoading = false;
    }
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
          'employee_id' : widget.employeeId,
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

  @override
  Widget build(BuildContext context) {
    print('selectedSPV : ${selectedSPV}');
    return Padding(
      padding: EdgeInsets.only(top: 5.sp, right: 10.sp),
      child: isLoading ? const Center(child: CircularProgressIndicator(),) : Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              children: [
                Card(
                  shape: const RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(12))),
                  color: Colors.white,
                  shadowColor: Colors.black,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Padding(
                      padding: EdgeInsets.all(4.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Informasi Umum', style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,),),
                            SizedBox(height: 10.h,),
                            Row(
                              children: [
                                SizedBox(
                                  width: (MediaQuery.of(context).size.width - 900) / 2,
                                  child: Text('NIK', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700,))
                                ),
                                SizedBox(
                                  width: (MediaQuery.of(context).size.width - 800) / 2,
                                  child: Text(employeeID)
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h,),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 900) / 2,
                                                              child: Text('Nama lengkap', 
                                                                style: TextStyle(
                                                                  fontSize: 4.sp,
                                                                  fontWeight: FontWeight.w700,
                                                                )
                                                              )
                                                            ),
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 800) / 2,
                                                              child: Text(namaKaryawan)
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 20.h,),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 900) / 2,
                                                              child: Text('Tempat, tanggal lahir', 
                                                                style: TextStyle(
                                                                  fontSize: 4.sp,
                                                                  fontWeight: FontWeight.w700,
                                                                )
                                                              )
                                                            ),
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 800) / 2,
                                                              child: Text('$pob, ${formatDate(dob)}')
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 20.h,),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 900) / 2,
                                                              child: Text('Jenis kelamin', 
                                                                style: TextStyle(
                                                                  fontSize: 4.sp,
                                                                  fontWeight: FontWeight.w700,
                                                                )
                                                              )
                                                            ),
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 800) / 2,
                                                              child: Text(gender)
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 20.h,),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 900) / 2,
                                                              child: Text('Nomor KTP', 
                                                                style: TextStyle(
                                                                  fontSize: 4.sp,
                                                                  fontWeight: FontWeight.w700,
                                                                )
                                                              )
                                                            ),
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 800) / 2,
                                                              child: Text(employeeNIK)
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 20.h,),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 900) / 2,
                                                              child: Text('Username', 
                                                                style: TextStyle(
                                                                  fontSize: 4.sp,
                                                                  fontWeight: FontWeight.w700,
                                                                )
                                                              )
                                                            ),
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 800) / 2,
                                                              child: Text(username)
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 20.h,),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 900) / 2,
                                                              child: Text('Email', 
                                                                style: TextStyle(
                                                                  fontSize: 4.sp,
                                                                  fontWeight: FontWeight.w700,
                                                                )
                                                              )
                                                            ),
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 800) / 2,
                                                              child: Text(emailKaryawan)
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 20.h,),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 900) / 2,
                                                              child: Text('Nomor handphone', 
                                                                style: TextStyle(
                                                                  fontSize: 4.sp,
                                                                  fontWeight: FontWeight.w700,
                                                                )
                                                              )
                                                            ),
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 800) / 2,
                                                              child: Text(phone)
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 20.h,),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 900) / 2,
                                                              child: Text('Status', 
                                                                style: TextStyle(
                                                                  fontSize: 4.sp,
                                                                  fontWeight: FontWeight.w700,
                                                                )
                                                              )
                                                            ),
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 800) / 2,
                                                              child: Text(status)
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 20.h,),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 900) / 2,
                                                              child: Text('Supervisor', 
                                                                style: TextStyle(
                                                                  fontSize: 4.sp,
                                                                  fontWeight: FontWeight.w700,
                                                                )
                                                              )
                                                            ),
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 800) / 2,
                                                              child: Text(namaSPV!)
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 20.h,),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.sp),
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: (){Get.to(EmployeeDetailOne(widget.employeeId));}, 
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(80.w, 45.h),
                      foregroundColor: const Color(0xFFFFFFFF),
                      backgroundColor: const Color(0xff4ec3fc),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Detail karyawan')
                  ),
                  SizedBox(height: 3.sp,),
                  ElevatedButton(
                    onPressed: (){createAccount(widget.employeeId);}, 
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(80.w, 45.h),
                      foregroundColor: const Color(0xFFFFFFFF),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Buat akun')
                  ),
                  SizedBox(height: 3.sp,),
                  ElevatedButton(
                    onPressed: (){resetAccount(widget.employeeId);}, 
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(80.w, 45.h),
                      foregroundColor: const Color(0xFFFFFFFF),
                      backgroundColor: const Color(0xff4ec3fc),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Reset akun')
                  ),
                  SizedBox(height: 3.sp,),
                  ElevatedButton(
                    onPressed: (){deleteAccount(widget.employeeId);}, 
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(80.w, 45.h),
                      foregroundColor: const Color(0xFFFFFFFF),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Tutup Akun')
                  ),
                  SizedBox(height: 3.sp,),
                  ElevatedButton(
                    onPressed: (){
                      showDialog(
                        context: context, 
                        builder: (_){
                          return AlertDialog(
                            title: Text('Pilih supervisor'),
                            content: DropdownButtonFormField<String>(
                              value: '000',
                              hint: Text('Pilih Supervisor'),
                              items: spvName.map<DropdownMenuItem<String>>((Map<String, String> spv) {
                                return DropdownMenuItem<String>(
                                  value: spv['id']!,
                                  child: Text(spv['name']!),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedSPV = newValue!;
                                });
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: (){
                                  Get.back();
                                }, 
                                child: Text('Batal')
                              ),
                              TextButton(
                                onPressed: (){
                                  
                                }, 
                                child: Text('Kumpul')
                              )
                            ],
                          );
                        }
                      );
                    }, 
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(80.w, 45.h),
                      foregroundColor: const Color(0xFFFFFFFF),
                      backgroundColor: const Color(0xff4ec3fc),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Set Supervisor')
                  ),
                  SizedBox(height: 3.sp,),
                  ElevatedButton(
                    onPressed: (){
                      showDialog(
                        context: context, 
                        builder: (_){
                          return AlertDialog(
                            title: Text('Pilih supervisor'),
                            content: DropdownButtonFormField<String>(
                              value: selectedSPV,
                              hint: Text('Pilih Supervisor'),
                              items: spvName.map<DropdownMenuItem<String>>((Map<String, String> spv) {
                                return DropdownMenuItem<String>(
                                  value: spv['id']!,
                                  child: Text(spv['name']!),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedSPV = newValue!;
                                });
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: (){
                                  Get.back();
                                }, 
                                child: Text('Batal')
                              ),
                              TextButton(
                                onPressed: (){
                                  
                                }, 
                                child: Text('Kumpul')
                              )
                            ],
                          );
                        }
                      );
                    }, 
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(80.w, 45.h),
                      foregroundColor: const Color(0xFFFFFFFF),
                      backgroundColor: const Color(0xff4ec3fc),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Set Lokasi Absen')
                  ),
                  SizedBox(height: 3.sp,),
                  ElevatedButton(
                    onPressed: (){selectFile();}, 
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(80.w, 45.h),
                      foregroundColor: const Color(0xFFFFFFFF),
                      backgroundColor: const Color(0xff4ec3fc),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Upload Foto Profil Karyawan')
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}