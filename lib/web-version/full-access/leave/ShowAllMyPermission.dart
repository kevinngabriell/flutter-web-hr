
// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:hr_systems_web/web-version/full-access/leave/ViewOnly.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class ShowAllMyPermission extends StatefulWidget {
  const ShowAllMyPermission({super.key});

  @override
  State<ShowAllMyPermission> createState() => _ShowAllMyPermissionState();
}

class _ShowAllMyPermissionState extends State<ShowAllMyPermission> {
  final storage = GetStorage();
  bool isSearch = false;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String employeeId = '';
  String departmentName = '';
  String positionName = '';
  String trimmedCompanyAddress = '';
  List<Map<String, dynamic>> permissionData = [];

  List<Map<String, String>> departmentList = [];
  String? selectedDepartment;

  List<Map<String, String>> permissionTypeList = [];
  String? selectedPermissionType;
  TextEditingController txtNamaKaryawanCari = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchPermissionData();
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

  Future<void> fetchPermissionData() async {
    String employeeId = storage.read('employee_id').toString();

    final response = await http.get(
      Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/showallmypermission.php?id=$employeeId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        var data = json.decode(response.body);

        setState(() {
          permissionData = List<Map<String, dynamic>>.from(data['Data']);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    var employeeId = storage.read('employee_id');
    var positionId = storage.read('position_id');
    var photo = storage.read('photo');

    return SafeArea(
      child: Scaffold(
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
              //content
              Expanded(
                flex: 8,
                child: Padding(
                  padding: EdgeInsets.only(left: 7.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5.sp,),
                      //Profile Name
                      NotificationnProfile(employeeName: employeeName, employeeAddress: employeeEmail, photo: photo),
                      SizedBox(height: 7.sp,),
                      if(isSearch == true && permissionData.isNotEmpty)
                        const SizedBox(
                          child: Text(''),
                        ),
                      if(isSearch == false && permissionData.isEmpty)  
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: (MediaQuery.of(context).size.height - 100.h),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Kosong', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 45.sp),),
                                  SizedBox(height: 15.h,),
                                  Text('Belum ada izin yang membutuhkan persetujuan anda', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 4.sp),)
                                ],
                              )
                            ),
                          ),
                      if(isSearch == false && permissionData.isNotEmpty)  
                        Column(
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width),
                                height: (MediaQuery.of(context).size.height - 100.h),
                                child: ListView.builder(
                                  itemCount: permissionData.length,
                                  itemBuilder: (context, index){
                                    var employeeName = permissionData[index]['employee_name'] as String;
                                    var permissiontype = permissionData[index]['permission_type_name'] as String;
                                    var permissionDate = formatDate(permissionData[index]['permission_date'] as String? ?? permissionData[index]['start_date'] as String);
                                    var permissionstatus = permissionData[index]['permission_status_name'] as String;
                                    var permissionid = permissionData[index]['id_permission'] as String;

                                    if (permissionstatus == 'Menunggu persetujuan manajer' || permissionstatus == 'Menunggu persetujuan HRD') {
                                      permissionstatus = 'Pending';
                                    } else if (permissionstatus == 'Izin telah disetujui '){
                                      permissionstatus = 'Diterima';
                                    } else if (permissionstatus == 'Izin ditolak dengan alasan tertentu'){
                                      permissionstatus = 'Ditolak';
                                    }

                                    Color backgroundColor = Colors.transparent;
                                    Color textColor = Colors.transparent;
                                    if (permissionstatus == 'Pending') {
                                      backgroundColor = Colors.yellow;
                                      textColor = Colors.black;
                                    } else if (permissionstatus == 'Diterima'){
                                      backgroundColor = Colors.green;
                                      textColor = Colors.white;
                                    } else if (permissionstatus == 'Ditolak'){
                                      backgroundColor = Colors.red;
                                      textColor = Colors.white;
                                    }

                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 4.sp),
                                      child: Card(
                                        child: ListTile(
                                          title: Text('$employeeName | $permissiontype', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 4.sp),),
                                          subtitle: Text(permissionDate),
                                          trailing: Container(
                                            constraints: BoxConstraints(
                                              minWidth: 25.w,
                                              minHeight: 50.h
                                            ),
                                            child: Card(
                                              color: backgroundColor,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(permissionstatus, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 4.sp),),
                                                ],
                                              )
                                            ),
                                          ),
                                          minVerticalPadding: 13.0,
                                          onTap: () {
                                            Get.to(ViewOnlyPermission(permission_id: permissionid,));
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                ),
                              ),
                            ],
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  String formatDate(String date) {
    // Parse the date string
    DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(date);

    // Format the date as "dd MMMM yyyy"
    return DateFormat("d MMMM yyyy", 'id').format(parsedDate);
  }

}