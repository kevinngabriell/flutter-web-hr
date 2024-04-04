// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:hr_systems_web/web-version/full-access/Settings/companysetting.dart';
import 'package:http/http.dart' as http;

class SettingIndex extends StatefulWidget {
  const SettingIndex({super.key});

  @override
  State<SettingIndex> createState() => _SettingIndexState();
}

class _SettingIndexState extends State<SettingIndex> {
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    String employeeId = storage.read('employee_id').toString();

    try {
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
        body: SingleChildScrollView(
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
                        SizedBox(height: 5.sp,),
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
                        SizedBox(height: 30.sp,),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 4,
                            child: GestureDetector(
                              onTap: () {
                                Get.to(const companySettingIndex());
                              },
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 5.sp, bottom: 5.sp, left: 7.sp, right: 7.sp),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Center(child: Text('Pengaturan', style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w700,))),
                                      SizedBox(height: 10.h,),
                                      Text('Mengatur peraturan perusahaan anda terkait privasi, akses terbatas ke daftar lengkap karyawan dengan data dan detail personal mereka.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: const Color.fromRGBO(116, 116, 116, 1),
                                          fontSize: 3.sp,
                                          fontWeight: FontWeight.w400,
                                        )
                                      ),
                                      SizedBox(height: 10.h,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 4,
                            child: GestureDetector(
                              onTap: () {
                                
                              },
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 5.sp, bottom: 5.sp, left: 7.sp, right: 7.sp),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('Panduan Pengguna', style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w700,)),
                                      SizedBox(height: 10.h,),
                                      Text('Lihat Panduan Pengguna kami untuk petunjuk mengenai cara mengakses daftar lengkap karyawan, beserta data dan detail pribadi mereka.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: const Color.fromRGBO(116, 116, 116, 1),
                                          fontSize: 3.sp,
                                          fontWeight: FontWeight.w400,
                                        )
                                      ),
                                      SizedBox(height: 10.h,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 4,
                            // child: Card(
                            //   child: Padding(
                            //     padding: EdgeInsets.only(top: 10.sp, bottom: 10.sp, left: 15.sp, right: 15.sp),
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         // Text('Total kehadiran karyawan', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400,)),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 4,
                            // child: Card(
                            //   child: Padding(
                            //     padding: EdgeInsets.only(top: 10.sp, bottom: 10.sp, left: 15.sp, right: 15.sp),
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         // Text('Total kehadiran karyawan', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400,)),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ),
                        ],
                      )
                    ],
                  )
                )
              )
            ],
          ),
        )
      )
    );
  }
}