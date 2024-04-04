// ignore_for_file: camel_case_types, avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:hr_systems_web/web-version/full-access/Settings/setting.dart';
import 'package:http/http.dart' as http;

class companySettingIndex extends StatefulWidget {
  const companySettingIndex({super.key});

  @override
  State<companySettingIndex> createState() => _companySettingIndexState();
}

class _companySettingIndexState extends State<companySettingIndex> {
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  String companyID = '';
  final storage = GetStorage();
  bool isLoading = false;
  TextEditingController txtNamaPerusahaan = TextEditingController();

  String inTime = '';
  String outTime = '';

  late TimeOfDay initialTimeinTime;
  late TimeOfDay initialTimeoutTime;

  @override
  void initState() {
    super.initState();
    fetchData();
    companyID = storage.read('company_id');
    fetchCompanySetting() ;
  }

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
          txtNamaPerusahaan.text = companyName;
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

  Future<void> fetchCompanySetting() async {

    try{
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/company/getjamabsensetting.php?company_id=$companyID';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('Data') && responseData['Data'] is List && (responseData['Data'] as List).isNotEmpty) {
           Map<String, dynamic> data = (responseData['Data'] as List).first;
           setState(() {
            inTime = data['In_Time'];
            outTime = data['Out_Time'];

            initialTimeinTime = _parseTime(inTime);
            initialTimeoutTime = _parseTime(outTime);

           });
        } else {
          print('Data is null or not found in the response data.');
        }

      } else {
        print('Failed to load data: ${response.statusCode}');
      }

    } catch (e){
      print('Error: $e');
    } finally {
      isLoading = false;
    }

  }

  TimeOfDay _parseTime(String timeString) {
    List<String> parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> updateCompanySetting() async{
    try{
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/company/updatejamabsen.php';
      String employeeId = storage.read('employee_id').toString();

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "company": companyID,
          "inTime": inTime,
          "outTime": outTime,
        }
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Sukses"),
              content: const Text("Data perusahaan anda telah berhasil diperbaharui"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.to(SettingIndex());
                  }, 
                  child: const Text("Oke")
                )
              ],
            );
          }
        );
        // Add any additional logic or UI updates after successful insertion
      } else {
        Get.snackbar('Gagal', response.body);
        // Handle the error or show an error message to the user
      }

    } catch (e){
      Get.snackbar('Gagal', '$e');
      print('Exception during API call: $e');
    } finally {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    var employeeId = storage.read('employee_id');
    var positionId = storage.read('position_id');
    var photo = storage.read('photo');

    return MaterialApp(
      title: "Pengaturan",
      home: Scaffold(
        body: isLoading ? const Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Side Menu
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
                        BerandaNonActive(employeeId: employeeId.toString()),
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
                        const PengaturanActive(),
                        SizedBox(height: 5.sp,),
                        const StrukturNonActive(),
                        SizedBox(height: 5.sp,),
                        const Logout(),
                      ],
                    ),
                  ),
              ),
              //Content
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
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 180.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nama perusahaan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(116, 116, 116, 1)
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtNamaPerusahaan,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama perusahaan anda'
                                  ),
                                  readOnly: true,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 15.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 110.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Jam masuk",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(116, 116, 116, 1)
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                                DateTimePicker(
                                  initialValue: inTime,
                                  initialTime: initialTimeinTime,
                                  type: DateTimePickerType.time,
                                  onChanged: (value) {
                                    setState(() {
                                      inTime = value.toString();
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 15.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 110.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Jam pulang",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(116, 116, 116, 1)
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                                DateTimePicker(
                                  initialValue: outTime,
                                  initialTime: initialTimeoutTime,
                                  type: DateTimePickerType.time,
                                  onChanged: (value) {
                                    setState(() {
                                      outTime = value.toString();
                                    });
                                  },
                                )
                              ],
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
                              updateCompanySetting();
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(60.w, 50.h),
                              foregroundColor: const Color(0xFFFFFFFF),
                              backgroundColor: const Color(0xff4ec3fc),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Perbaharui')
                          ),
                        ],
                      )
                    ]
                  )
                )
              )
            ]
          )
        )
      )
    );
  }
}