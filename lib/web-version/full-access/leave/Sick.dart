// ignore_for_file: use_build_context_synchronously, avoid_print, non_constant_identifier_names, file_names
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:hr_systems_web/web-version/full-access/index.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'dart:convert';

import 'package:intl/intl.dart';

class SickPermission extends StatefulWidget {
  const SickPermission({super.key});

  @override
  State<SickPermission> createState() => _SickPermissionState();
}

class _SickPermissionState extends State<SickPermission> {
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String employeeId = '';
  String departmentName = '';
  String positionName = '';
  String trimmedCompanyAddress = '';
  bool isLoading = false;
  TextEditingController txtNamaLengkap = TextEditingController();
  String namaLengkapText = '';
  TextEditingController txtNIK = TextEditingController();
  String nikText = '';
  TextEditingController txtAlasan = TextEditingController();
  String alasanText = '';
  TextEditingController txtDepartemen = TextEditingController();
  String departemenText = '';
  TextEditingController txtJabatan = TextEditingController();
  String jabatanText = '';
  DateTime? TanggalMulai;
  DateTime? TanggalAkhir;
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDataforFilled();
  }

  Future<void> fetchData() async {
    try {
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/account/getprofileforallpage.php';

      String employeeId = storage.read('employee_id').toString(); // replace with your logic to get employee ID

      // Create a Map for the request body
      Map<String, dynamic> requestBody = {'employee_id': employeeId};

      // Convert the Map to a JSON string
      String requestBodyJson = json.encode(requestBody);

      // Make the API call with a POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'employee_id': employeeId,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        // Ensure that the fields are of the correct type
        setState(() {
          companyName = data['company_name'] as String;
          companyAddress = data['company_address'] as String;
          employeeName = data['employee_name'] as String;
          employeeEmail = data['employee_email'] as String;
          trimmedCompanyAddress = companyAddress.substring(0, 15);
          txtNamaLengkap.text = employeeName;
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

  Future<void> fetchDataforFilled() async {
    try {
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/getdataforrequestor.php';

      // Replace 'employee_id' with the actual employee ID from storage
      String employeeId = storage.read('employee_id').toString(); // replace with your logic to get employee ID

      // Create a Map for the request body
      Map<String, dynamic> requestBody = {'employee_id': employeeId};

      // Convert the Map to a JSON string
      String requestBodyJson = json.encode(requestBody);

      // Make the API call with a POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'employee_id': employeeId,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        setState(() {
          employeeName = data['Data']['employee_name'] as String;
          employeeId = data['Data']['employee_id'] as String;
          departmentName = data['Data']['department_name'] as String;
          positionName = data['Data']['position_name'] as String;

          txtNIK.text = employeeId;
          txtDepartemen.text = departmentName;
          txtJabatan.text = positionName;
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> pickFile() async {
    // try {
      try{
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
        );

        if (result != null){
          String selectedFileName = result.files.first.name;
          List<int> imageBytes = result.files.first.bytes!;

          // Convert the image bytes to base64
          String base64Image = base64Encode(imageBytes);
          isLoading = true;
          String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/insertpermission.php';
          String employeeId = storage.read('employee_id').toString();
          DateTime dateNow = DateTime.now();

          var data = {
            'action' : '5',
            'id' : employeeId,
            'attachment': base64Image,
            'start_date': TanggalMulai.toString(),
            'end_date': TanggalAkhir.toString(),
            'date_now': dateNow.toString()
          };

          var dioClient = dio.Dio();
          dio.Response response = await dioClient.post(apiUrl, data: dio.FormData.fromMap(data));

          if (response.statusCode == 200) {
            showDialog(
              context: context, // Make sure to have access to the context
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Sukses'),
                  content: const Text('Pengajuan izin sakit anda telah berhasil dilakukan'),
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
        } else {
          Get.snackbar("Error", "");
        }
      } catch (e){
        print(e);
      }

  }

  @override
  Widget build(BuildContext context) {
    // Access the GetStorage instance
    final storage = GetStorage();

    // Retrieve the stored employee_id
    var employeeId = storage.read('employee_id');
    var photo = storage.read('photo');
    var positionId = storage.read('position_id');

    DateTime now = DateTime.now();
    DateTime nextweek = now.add(const Duration(days: 7));

    return MaterialApp(
      title: 'Pengajuan Izin Sakit',
      home: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //side menu
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      SizedBox(height: 30.sp,), 
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Padding(
                  padding: EdgeInsets.only(left: 7.w, right: 7.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5.sp,),
                      NotificationnProfile(employeeName: employeeName, employeeAddress: employeeEmail, photo: photo),
                      SizedBox(height: 7.sp,),
                      Center(
                        child: Text(
                          "Pengajuan Izin Sakit",
                          style: TextStyle(
                            fontSize: 7.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color.fromRGBO(116, 116, 116, 1)
                          ),
                        ),
                      ),
                      SizedBox(height: 10.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 15.sp),
                            child: SizedBox(
                              width: (MediaQuery.of(context).size.width - 210.w) / 2,
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
                                      controller: txtNamaLengkap,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                                        hintText: 'Masukkan nama anda'
                                      ),
                                      readOnly: true,
                                    )
                                ],
                              )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 15.sp),
                            child: SizedBox(
                              width: (MediaQuery.of(context).size.width - 210.w) / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "NIK",
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
                                      controller: txtNIK,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                                        hintText: 'Masukkan NIK anda'
                                      ),
                                      readOnly: true,
                                    )
                                ],
                              )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 15.sp),
                            child: SizedBox(
                              width: (MediaQuery.of(context).size.width - 210.w) / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Departemen",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 7.h,),
                                  TextFormField(
                                    controller: txtDepartemen,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan departemen anda'
                                    ),
                                    readOnly: true,
                                  )
                                ],
                              )
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.sp,),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 15.sp),
                            child: SizedBox(
                              width: (MediaQuery.of(context).size.width - 210.w) / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Jabatan",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 7.h,),
                                  TextFormField(
                                    controller: txtJabatan,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan jabatan anda'
                                    ),
                                    readOnly: true,
                                  )
                                ],
                              )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 15.sp),
                            child: SizedBox(
                              width: (MediaQuery.of(context).size.width - 210.w) / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tanggal mulai izin",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 7.h,),
                                  DateTimePicker(
                                    firstDate: DateTime.now(),
                                    lastDate: nextweek,
                                    initialDate: DateTime.now(),
                                    dateMask: 'd MMM yyyy',
                                    onChanged: (value) {
                                      setState(() {
                                        TanggalMulai = DateFormat('yyyy-MM-dd').parse(value);
                                      });
                                    },
                                  )
                                ],
                              )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 15.sp),
                            child: SizedBox(
                              width: (MediaQuery.of(context).size.width - 210.w) / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tanggal akhir izin",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 7.h,),
                                  DateTimePicker(
                                    firstDate: DateTime.now(),
                                    lastDate: nextweek,
                                    initialDate: DateTime.now(),
                                    dateMask: 'd MMM yyyy',
                                    onChanged: (value) {
                                      setState(() {
                                        TanggalAkhir = DateFormat('yyyy-MM-dd').parse(value);
                                      });
                                    },
                                  )
                                ],
                              )
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.sp,),
                      Row(
                         mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                    context: context,
                                    builder: (_) {
                                      return const AlertDialog(
                                        content: Row(
                                          children: [
                                            CircularProgressIndicator(),
                                            SizedBox(width: 20),
                                            Text('Loading ...'),
                                          ],
                                        ),
                                      );
                                    },
                                  );

                              try {
                                await pickFile(); 
                              } finally {
                                Get.to(FullIndexWeb(employeeId));
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
                            child: const Text('Kumpulkan')
                          ),
                        ],
                      )
                      
                    ],
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}