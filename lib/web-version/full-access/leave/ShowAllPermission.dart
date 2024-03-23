// ignore_for_file: unnecessary_string_interpolations, file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/web-version/full-access/Event/event.dart';
import 'package:hr_systems_web/web-version/full-access/Performance/performance.dart';
import 'package:hr_systems_web/web-version/full-access/Report/report.dart';
import 'package:hr_systems_web/web-version/full-access/Salary/salary.dart';
import 'package:hr_systems_web/web-version/full-access/Settings/setting.dart';
import 'package:hr_systems_web/web-version/full-access/Structure/structure.dart';
import 'package:hr_systems_web/web-version/full-access/Training/traning.dart';
import 'package:hr_systems_web/web-version/full-access/leave/ViewOnly.dart';
import 'package:hr_systems_web/web-version/full-access/profile.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../login.dart';
import '../employee.dart';
import '../index.dart';

class ShowAllPermissionPage extends StatefulWidget {
  const ShowAllPermissionPage({super.key});

  @override
  State<ShowAllPermissionPage> createState() => _ShowAllPermissionPageState();
}

class _ShowAllPermissionPageState extends State<ShowAllPermissionPage> {
  final storage = GetStorage();
  bool isLoading = false;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String employeeId = '';
  String departmentName = '';
  String positionName = '';
  bool isSearch = false;
  String trimmedCompanyAddress = '';
  TextEditingController txtNamaKaryawanCari = TextEditingController();

  List<Map<String, dynamic>> permissionData = [];
  List<Map<String, dynamic>> HRDpermissionData = [];
  List<Map<String, dynamic>> searchPermissionData = [];

  List<Map<String, dynamic>> notificationList = [];

  List<Map<String, String>> departmentList = [];
  String? selectedDepartment;

  List<Map<String, String>> permissionTypeList = [];
  String? selectedPermissionType;
  
  @override
  void initState() {
    super.initState();
    fetchData();
    fetchPermission();
    fetchNotification();
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

  Future<void> fetchSearch(employeeName, departmentID, permissionType) async {
    try{
      isLoading = true;

      String apiURL = "https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/getpermission.php?action=3&employee_name=$employeeName&department_id=$departmentID&permission_id=$permissionType";

      var response = await http.get(Uri.parse(apiURL));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          searchPermissionData = List<Map<String, dynamic>>.from(data['Data']);
          print(searchPermissionData);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }    

    } catch (e){

    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchPermission() async { 
    try {
      isLoading = true;
      //Fetch the department list
      final deptResponse = await http.get(
          Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/general/hrsystemsapi.php?action=1'));

      if (deptResponse.statusCode == 200) {
        final data = json.decode(deptResponse.body);
        if (data['StatusCode'] == 200) {
          setState(() {
            departmentList = (data['Data'] as List)
                .map((department) => Map<String, String>.from(department))
                .toList();

            if (departmentList.isNotEmpty) {
              // Set the selectedCompany to the first item in the list by default
              selectedDepartment = departmentList[0]['department_id'].toString();
            }
          });
        } else {
          // Handle API error
          print('Failed to fetch data');
        }
      } else {
        // Handle HTTP error
        print('Failed to fetch data');
      }

      //Fetch the permission list
      final permissionResponse = await http.get(
          Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/getpermission.php?action=2'));

      if (permissionResponse.statusCode == 200) {
        final data = json.decode(permissionResponse.body);
        if (data['StatusCode'] == 200) {
          setState(() {
            permissionTypeList = (data['Data'] as List)
                .map((permission) => Map<String, String>.from(permission))
                .toList();

            if (permissionTypeList.isNotEmpty) {
              // Set the selectedCompany to the first item in the list by default
              selectedPermissionType = permissionTypeList[0]['id_permission_type'].toString();
            }
          });
        } else {
          // Handle API error
          print('Failed to fetch data');
        }
      } else {
        // Handle HTTP error
        print('Failed to fetch data');
      }

      //Fetch the all permission
      String employeeId = storage.read('employee_id').toString();
      String apiURL = "https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/getpermission.php?action=1&id=$employeeId";

      var response = await http.get(Uri.parse(apiURL));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          permissionData = List<Map<String, dynamic>>.from(data['Data']['managerApproval']);
          HRDpermissionData = List<Map<String, dynamic>>.from(data['Data']['HRDApproval']);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }

    } catch (e) {

    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchNotification() async{
    try{  
      String employeeId = storage.read('employee_id').toString();
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/notification/getlimitnotif.php?employee_id=$employeeId';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          notificationList = List<Map<String, dynamic>>.from(data['Data']);
        });
      } else if (response.statusCode == 404){
        print('404, No Data Found');
      }

    } catch (e){
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var photo = storage.read('photo');
    var positionId = storage.read('position_id');
    
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
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
                      SizedBox(height: 15.sp,),
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 0, right: 0),
                        dense: true,
                        horizontalTitleGap: 0.0, 
                        leading: Container(
                          margin: const EdgeInsets.only(right: 2.0),
                          child: Image.asset(
                            'images/kinglab.png',
                            width: MediaQuery.of(context).size.width * 0.08,
                          ),
                        ),
                        title: Text(
                          "$companyName",
                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w300),
                        ),
                        subtitle: Text(
                          '$trimmedCompanyAddress',
                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w300),
                        ),
                      ),
                      SizedBox(height: 30.sp,),
                      Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: Text("Halaman utama", 
                            style: TextStyle( fontSize: 20.sp, fontWeight: FontWeight.w600,)
                          ),
                      ),
                      SizedBox(height: 10.sp,),
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: ElevatedButton(
                          onPressed: () {Get.to(FullIndexWeb(employeeId));},
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            alignment: Alignment.centerLeft,
                            minimumSize: Size(60.w, 55.h),
                            foregroundColor: const Color(0xFFFFFFFF),
                            backgroundColor: const Color(0xff4ec3fc),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Image.asset('images/home-active.png')
                              ),
                              SizedBox(width: 2.w),
                              Text('Beranda',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,)
                              )
                            ],
                          )
                        ),
                      ),
                      SizedBox(height: 10.sp,),
                      //karyawan button
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: ElevatedButton(
                          onPressed: () {Get.to(EmployeePage(employee_id: employeeId,));},
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            alignment: Alignment.centerLeft,
                            minimumSize: Size(60.w, 55.h),
                            foregroundColor: const Color(0xDDDDDDDD),
                            backgroundColor: const Color(0xFFFFFFFF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Image.asset('images/employee-inactive.png')
                              ),
                              SizedBox(width: 2.w),
                              Text('Karyawan',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,)
                              )
                            ],
                          )
                        ),
                      ),
                      SizedBox(height: 10.sp,),
                      //gaji button
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(const SalaryIndex());
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            alignment: Alignment.centerLeft,
                            minimumSize: Size(60.w, 55.h),
                            foregroundColor: const Color(0xDDDDDDDD),
                            backgroundColor: const Color(0xFFFFFFFF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Image.asset('images/gaji-inactive.png')
                              ),
                              SizedBox(width: 2.w),
                              Text('Gaji',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,)
                              )
                            ],
                          )
                        ),
                      ),
                      SizedBox(height: 10.sp,),
                      //performa button
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(const PerformanceIndex());
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            alignment: Alignment.centerLeft,
                            minimumSize: Size(60.w, 55.h),
                            foregroundColor: const Color(0xDDDDDDDD),
                            backgroundColor: const Color(0xFFFFFFFF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Image.asset('images/performa-inactive.png')
                              ),
                              SizedBox(width: 2.w),
                              Text('Performa',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,)
                              )
                            ],
                          )
                        ),
                      ),
                      SizedBox(height: 10.sp,),
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(const TrainingIndex());
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            alignment: Alignment.centerLeft,
                            minimumSize: Size(60.w, 55.h),
                            foregroundColor: const Color(0xDDDDDDDD),
                            backgroundColor: const Color(0xFFFFFFFF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Image.asset('images/pelatihan-inactive.png')
                              ),
                              SizedBox(width: 2.w),
                              Text('Pelatihan',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,)
                              )
                            ],
                          )
                        ),
                      ),
                      SizedBox(height: 10.sp,),
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(const EventIndex());
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            alignment: Alignment.centerLeft,
                            minimumSize: Size(60.w, 55.h),
                            foregroundColor: const Color(0xDDDDDDDD),
                            backgroundColor: const Color(0xFFFFFFFF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Image.asset('images/acara-inactive.png')
                              ),
                              SizedBox(width: 2.w),
                              Text('Acara',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,)
                              )
                            ],
                          )
                        ),
                      ),
                      SizedBox(height: 10.sp,),
                      //laporan button
                      Padding(
                              padding: EdgeInsets.only(left: 5.w, right: 5.w),
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(const ReportIndex());
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  alignment: Alignment.centerLeft,
                                  minimumSize: Size(60.w, 55.h),
                                  foregroundColor: const Color(0xDDDDDDDD),
                                  backgroundColor: const Color(0xFFFFFFFF),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Image.asset('images/laporan-inactive.png')
                                    ),
                                    SizedBox(width: 2.w),
                                    Text('Laporan',
                                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,)
                                    )
                                  ],
                                )
                              ),
                            ),
                      SizedBox(height: 30.sp,),
                      //pengaturan title
                      Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: Text("Pengaturan", 
                            style: TextStyle( fontSize: 20.sp, fontWeight: FontWeight.w600,)
                          ),
                      ),
                      SizedBox(height: 10.sp,),
                      //pengaturan button
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(const SettingIndex());
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            alignment: Alignment.centerLeft,
                            minimumSize: Size(60.w, 55.h),
                            foregroundColor: const Color(0xDDDDDDDD),
                            backgroundColor: const Color(0xFFFFFFFF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Image.asset('images/pengaturan-inactive.png')
                              ),
                              SizedBox(width: 2.w),
                              Text('Pengaturan',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,)
                              )
                            ],
                          )
                        ),
                      ),
                      SizedBox(height: 10.sp,),
                      //struktur button
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(const StructureIndex());
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            alignment: Alignment.centerLeft,
                            minimumSize: Size(60.w, 55.h),
                            foregroundColor: const Color(0xDDDDDDDD),
                            backgroundColor: const Color(0xFFFFFFFF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Image.asset('images/struktur-inactive.png')
                              ),
                              SizedBox(width: 2.w),
                              Text('Struktur',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,)
                              )
                            ],
                          )
                        ),
                      ),
                      SizedBox(height: 10.sp,),
                      //keluar button
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: ElevatedButton(
                          onPressed: () async {
                            //show dialog sure to exit ?
                            showDialog(
                              context: context, 
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text("Keluar"),
                                  content: const Text('Apakah anda yakin akan keluar ?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {Get.back();},
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {Get.off(const LoginPageDesktop());},
                                      child: const Text('OK',),
                                    ),
                                  ],
                                );
                              }
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            alignment: Alignment.centerLeft,
                            minimumSize: Size(60.w, 55.h),
                            foregroundColor: const Color(0xDDDDDDDD),
                            backgroundColor: const Color(0xFFFFFFFF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Image.asset('images/logout.png')
                              ),
                              SizedBox(width: 2.w),
                              Text('Keluar',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.red)
                              )
                            ],
                          )
                        ),
                      ),
                      SizedBox(height: 30.sp,),
                    ],
                  ),
                ),
              ),
              //content
              Expanded(
                flex: 8,
                child: Padding(
                  padding: EdgeInsets.only(left: 7.w, right: 7.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 35.sp,),
                        Padding(
                          padding: EdgeInsets.only(right: 20.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context, 
                                    builder: (BuildContext context){
                                      return AlertDialog(
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Notifikasi', style: TextStyle(
                                              fontSize: 20.sp, fontWeight: FontWeight.w700,
                                            )),
                                            GestureDetector(
                                              onTap: () {
                                                
                                              },
                                              child: Text('Hapus semua', style: TextStyle(
                                                fontSize: 12.sp, fontWeight: FontWeight.w600,
                                              )),
                                            ),
                                          ],
                                        ),
                                        content: SizedBox(
                                          width: MediaQuery.of(context).size.width / 2,
                                          height: MediaQuery.of(context).size.height / 2,
                                          child: ListView.builder(
                                            itemCount: notificationList.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: (){
                                                  if(notificationList[index]['sender'] != ''){
                                                      showDialog(
                                                      context: context, 
                                                      builder: (_) {
                                                        return AlertDialog(
                                                          title: Center(child: Text("${notificationList[index]['title']} ", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700))),
                                                          content: SizedBox(
                                                            width: MediaQuery.of(context).size.width / 4,
                                                            height: MediaQuery.of(context).size.height / 4,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text('Tanggal : ${_formatDate('${notificationList[index]['send_date']}')}'),
                                                                SizedBox(height: 2.h,),
                                                                Text('Dari : ${notificationList[index]['sender'] == 'Kevin Gabriel Florentino' ? 'System' : notificationList[index]['sender']} '),
                                                                SizedBox(height: 10.h,),
                                                                Text('${notificationList[index]['message']} ')
                                                              ],
                                                            ),
                                                          ),
                                                          actions: [
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
                                                  }
                                                },
                                                child: Card(
                                                  child: ListTile(
                                                    title: Text(index < notificationList.length ? '${notificationList[index]['title']} ' : '-',
                                                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    subtitle: Text(
                                                        index < notificationList.length
                                                        ? 'From ${notificationList[index]['sender'] == 'Kevin Gabriel Florentino' ? 'System' : notificationList[index]['sender']} '
                                                        : '-',
                                                        style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400),
                                                      ),
                                                  ),
                                                ),
                                              );
                                            }
                                          ),
                                        ),
                                      );
                                    }
                                  );
                                },
                                child: Stack(
                                  children: [
                                    const Icon(Icons.notifications),
                                    // if (noti.isNotEmpty)
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(1),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            notificationList.length.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 40.sp,),
                              GestureDetector(
                                onTap: () {
                                  Get.to(const ProfilePage());
                                },
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 290.w,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.only(left: 0, right: 0),
                                    dense: true,
                                    horizontalTitleGap: 20.0,
                                    leading: Container(
                                      margin: const EdgeInsets.only(right: 2.0),
                                      child: Image.memory(
                                        base64Decode(photo),
                                      ),
                                    ),
                                    title: Text("$employeeName",
                                      style: TextStyle( fontSize: 15.sp, fontWeight: FontWeight.w300,),
                                    ),
                                    subtitle: Text("$employeeEmail",
                                      style: TextStyle( fontSize: 15.sp, fontWeight: FontWeight.w300,),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40.sp,),
                        if(isSearch == true && permissionData.isNotEmpty && (positionId == 'POS-HR-001' || positionId == 'POS-HR-004' || positionId == 'POS-HR-024'))
                          const SizedBox(
                            child: Text('Cari apa om ?'),
                          ),
                        if(isSearch == true && permissionData.isNotEmpty && (positionId == 'POS-HR-002'))
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Nama', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp),),
                                      SizedBox(height: 5.sp,),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width / 6,
                                        child: TextFormField(
                                          controller: txtNamaKaryawanCari,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            fillColor: Color.fromRGBO(235, 235, 235, 1),
                                            hintText: 'Masukkan nama anda'
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(width: 8.w,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Departemen', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp)),
                                      SizedBox(height: 5.sp,),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width / 6,
                                        child: DropdownButtonFormField<String>(
                                          value: selectedDepartment,
                                          hint: const Text('Pilih departemen'),
                                          onChanged: (String? newValue) {
                                            selectedDepartment = newValue.toString();
                                          },
                                          items: departmentList.map<DropdownMenuItem<String>>((Map<String, String> departemen) {
                                            return DropdownMenuItem<String>(
                                              value: departemen['department_id']!,
                                              child: Text(departemen['department_name']!),
                                            );
                                          }).toList(),
                                        )
                                      )
                                    ],
                                  ),
                                  SizedBox(width: 8.w,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Jenis Izin', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp)),
                                      SizedBox(height: 5.sp,),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width / 6,
                                        child: DropdownButtonFormField<String>(
                                          value: selectedPermissionType,
                                          hint: const Text('Pilih tipe izin'),
                                          onChanged: (String? newValue) {
                                            selectedPermissionType = newValue.toString();
                                          },
                                          items: permissionTypeList.map<DropdownMenuItem<String>>((Map<String, String> permission) {
                                            return DropdownMenuItem<String>(
                                              value: permission['id_permission_type']!,
                                              child: Text(permission['permission_type_name']!),
                                            );
                                          }).toList(),
                                        )
                                      )
                                    ],
                                  ),
                                  SizedBox(width: 8.w,),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      alignment: Alignment.center,
                                      minimumSize: Size(30.w, 55.h),
                                      foregroundColor: const Color(0xFFFFFFFF),
                                      backgroundColor: const Color(0xff4ec3fc),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    onPressed: (){
                                      print('${txtNamaKaryawanCari.text} + ${selectedDepartment!} + ${selectedPermissionType!}');
                                      setState(() {
                                        isSearch = true;
                                        fetchSearch(txtNamaKaryawanCari.text, selectedDepartment, selectedPermissionType);
                                      });
                                    }, 
                                    child: const Text('Cari')
                                  )
                                ],
                              ),
                              SizedBox(height: 25.sp,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width),
                                height: (MediaQuery.of(context).size.height - 100.h),
                              )
                            ],
                          ),
                        if(isSearch == false && permissionData.isEmpty && (positionId == 'POS-HR-001' || positionId == 'POS-HR-004' || positionId == 'POS-HR-024'))
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: (MediaQuery.of(context).size.height - 100.h),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Kosong', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 45.sp),),
                                  SizedBox(height: 15.h,),
                                  Text('Belum ada izin yang membutuhkan persetujuan anda', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.sp),)
                                ],
                              )
                            ),
                          ),
                        if(isSearch == false && permissionData.isNotEmpty && (positionId == 'POS-HR-001' || positionId == 'POS-HR-004' || positionId == 'POS-HR-024'))
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Nama', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp),),
                                      SizedBox(height: 5.sp,),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width / 6,
                                        child: TextFormField(
                                          controller: txtNamaKaryawanCari,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            fillColor: Color.fromRGBO(235, 235, 235, 1),
                                            hintText: 'Masukkan nama anda'
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(width: 8.w,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Departemen', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp)),
                                      SizedBox(height: 5.sp,),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width / 6,
                                        child: DropdownButtonFormField<String>(
                                          value: selectedDepartment,
                                          hint: const Text('Pilih departemen'),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedDepartment = newValue.toString();
                                            });
                                          },
                                          items: departmentList.map<DropdownMenuItem<String>>((Map<String, String> departemen) {
                                            return DropdownMenuItem<String>(
                                              value: departemen['department_id']!,
                                              child: Text(departemen['department_name']!),
                                            );
                                          }).toList(),
                                        )
                                      )
                                    ],
                                  ),
                                  SizedBox(width: 8.w,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Jenis Izin', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp)),
                                      SizedBox(height: 5.sp,),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width / 6,
                                        child: DropdownButtonFormField(
                                          items: [],
                                          onChanged: (value) {
                                            
                                          },
                                        )
                                      )
                                    ],
                                  ),
                                  SizedBox(width: 8.w,),
                                  ElevatedButton(
                                    onPressed: (){
                                      print('${txtNamaKaryawanCari.text} + ${selectedDepartment!} + ${selectedPermissionType!}');
                                      setState(() {
                                        isSearch = true;
                                      });
                                    }, 
                                    child: const Text('Cari')
                                  )
                                ],
                              ),
                              SizedBox(height: 25.sp,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width),
                                height: (MediaQuery.of(context).size.height - 100.h),
                                child: ListView.builder(
                                  itemCount: permissionData.length,
                                  itemBuilder: (context, index){
                                    var employeeName = permissionData[index]['employee_name'] as String;
                                    var permissiontype = permissionData[index]['permission_type_name'] as String;
                                    var permissionDate = _formatDate(permissionData[index]['permission_date'] as String? ?? permissionData[index]['start_date'] as String);
                                    var permissionstatus = permissionData[index]['permission_status_name'] as String;
                                    var permissionid = permissionData[index]['id_permission'] as String;

                                    if (permissionstatus == 'Menunggu persetujuan manajer' || permissionstatus == 'Menunggu persetujuan HRD') {
                                      permissionstatus = 'Pending';
                                    }

                                    Color backgroundColor = Colors.transparent;
                                    if (permissionstatus == 'Pending') {
                                      backgroundColor = Colors.yellow;
                                    }
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 10.sp),
                                      child: Card(
                                        child: ListTile(
                                          title: Text('$employeeName | $permissiontype', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.sp),),
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
                                                  Text(permissionstatus, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14.sp),),
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
                        if(isSearch == false && HRDpermissionData.isEmpty && positionId == 'POS-HR-002')
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: (MediaQuery.of(context).size.height - 100.h),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Kosong', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 45.sp),),
                                  SizedBox(height: 15.h,),
                                  Text('Belum ada izin yang membutuhkan persetujuan anda', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.sp),)
                                ],
                              )
                            ),
                          ),
                        if(isSearch == false && HRDpermissionData.isNotEmpty && positionId == 'POS-HR-002')
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Nama', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp),),
                                      SizedBox(height: 5.sp,),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width / 6,
                                        child: TextFormField(
                                          controller: txtNamaKaryawanCari,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            fillColor: Color.fromRGBO(235, 235, 235, 1),
                                            hintText: 'Masukkan nama anda'
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(width: 8.w,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Departemen', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp)),
                                      SizedBox(height: 5.sp,),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width / 6,
                                        child: DropdownButtonFormField<String>(
                                          value: selectedDepartment,
                                          hint: const Text('Pilih departemen'),
                                          onChanged: (String? newValue) {
                                            selectedDepartment = newValue.toString();
                                          },
                                          items: departmentList.map<DropdownMenuItem<String>>((Map<String, String> departemen) {
                                            return DropdownMenuItem<String>(
                                              value: departemen['department_id']!,
                                              child: Text(departemen['department_name']!),
                                            );
                                          }).toList(),
                                        )
                                      )
                                    ],
                                  ),
                                  SizedBox(width: 8.w,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Jenis Izin', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp)),
                                      SizedBox(height: 5.sp,),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width / 6,
                                        child: DropdownButtonFormField<String>(
                                          value: selectedPermissionType,
                                          hint: const Text('Pilih tipe izin'),
                                          onChanged: (String? newValue) {
                                            selectedPermissionType = newValue.toString();
                                          },
                                          items: permissionTypeList.map<DropdownMenuItem<String>>((Map<String, String> permission) {
                                            return DropdownMenuItem<String>(
                                              value: permission['id_permission_type']!,
                                              child: Text(permission['permission_type_name']!),
                                            );
                                          }).toList(),
                                        )
                                      )
                                    ],
                                  ),
                                  SizedBox(width: 8.w,),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      alignment: Alignment.center,
                                      minimumSize: Size(30.w, 55.h),
                                      foregroundColor: const Color(0xFFFFFFFF),
                                      backgroundColor: const Color(0xff4ec3fc),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    onPressed: (){
                                      print('${txtNamaKaryawanCari.text} + ${selectedDepartment!} + ${selectedPermissionType!}');
                                      setState(() {
                                        isSearch = true;
                                        fetchSearch(txtNamaKaryawanCari.text, selectedDepartment, selectedPermissionType);
                                      });
                                    }, 
                                    child: const Text('Cari')
                                  )
                                ],
                              ),
                              SizedBox(height: 15.sp,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width),
                                height: (MediaQuery.of(context).size.height - 100.h),
                                child: ListView.builder(
                                  itemCount: permissionData.length,
                                  itemBuilder: (context, index){
                                    var employeeName = permissionData[index]['employee_name'] as String;
                                    var permissiontype = permissionData[index]['permission_type_name'] as String;
                                    var permissionDate = _formatDate(permissionData[index]['permission_date'] as String? ?? permissionData[index]['start_date'] as String);
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
                                      padding: EdgeInsets.only(bottom: 10.sp),
                                      child: Card(
                                        child: ListTile(
                                          title: Text('$employeeName | $permissiontype', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.sp),),
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
                                                  Text(permissionstatus, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14.sp, color: textColor),),
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
                        SizedBox(height: 50.h,)
                      // FutureBuilder(
                      //   future: Future.value(storage.read('position_id')),
                      //   builder: (context, snapshot){
                      //       if (snapshot.connectionState == ConnectionState.waiting) {
                      //         return const CircularProgressIndicator();
                      //       } else if (snapshot.hasError) {
                      //         return Column(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: const [
                      //             //Image.asset('assets/no_data.png'), // Ganti dengan path gambar yang sesuai
                      //             Text('Anda belum pernah mengajukan izin apapun'),
                      //           ],
                      //         );
                      //       } else {
                      //         String? positionId = snapshot.data as String?;

                      //         if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008'){
                      //           return FutureBuilder(
                      //             future: HRDpermissionData,
                      //             builder: (context, snapshot) {
                      //               if (snapshot.connectionState == ConnectionState.waiting) {
                      //                 // If the data is still loading, show a loading indicator
                      //                 return Center(
                      //                   child: CircularProgressIndicator(),
                      //                 );
                      //               } else if (snapshot.hasError) {
                      //                 // If an error occurred, display an error message
                      //                 return Column(
                      //                   mainAxisAlignment: MainAxisAlignment.center,
                      //                   children: const [
                      //                     Text('Error fetching HRD permission data'),
                      //                   ],
                      //                 );
                      //               } else if (snapshot.data!.isEmpty) {
                      //                 // If the data is empty, display a message indicating that no data is available
                      //                 return Column(
                      //                   mainAxisAlignment: MainAxisAlignment.center,
                      //                   children: const [
                      //                     Text('No HRD permission data available'),
                      //                   ],
                      //                 );
                      //               } else {
                      //                 // If the data is available, display it in a DataTable
                      //                 return DataTable(
                      //                   showCheckboxColumn: false,
                      //                   columns: const <DataColumn>[
                      //                     DataColumn(label: Text('Jenis izin')),
                      //                     DataColumn(label: Text('Nama')),
                      //                     DataColumn(label: Text('Tanggal izin')),
                      //                     DataColumn(label: Text('Status izin')),
                      //                   ],
                      //                   rows: snapshot.data!.map((data) {
                      //                     return DataRow(
                      //                       cells: <DataCell>[
                      //                         DataCell(Text(data['permission_type_name'] ?? 'N/A')),
                      //                         DataCell(Text(data['employee_name'] ?? 'N/A')),
                      //                         DataCell(
                      //                           Text(data['permission_date'] ?? data['start_cuti'] ?? 'N/A'),
                      //                         ),
                      //                         DataCell(Text(data['permission_status_name'] ?? 'N/A')),
                      //                       ],
                      //                       onSelectChanged: (bool? selected) {
                      //                         if (selected!) {
                      //                           Get.to(ViewOnlyPermission(permission_id: data['id_permission'].toString()));
                      //                         }
                      //                       },
                      //                     );
                      //                   }).toList(),
                      //                 );
                      //               }
                      //             },
                      //           );

                      //         } else if (positionId == 'POS-HR-001' || positionId == 'POS-HR-004' || positionId == 'POS-HR-024'){
                      //           return FutureBuilder(
                      //             future: permissionData,
                      //             builder: (context, snapshot) {
                      //               if (snapshot.connectionState == ConnectionState.waiting) {
                      //                 // If the data is still loading, show a loading indicator
                      //                 return Center(
                      //                   child: CircularProgressIndicator(),
                      //                 );
                      //               } else if (snapshot.hasError) {
                      //                 // If an error occurs, display an error message
                      //                 return Column(
                      //                   mainAxisAlignment: MainAxisAlignment.center,
                      //                   children: const [
                      //                     Text('Error fetching permission data'),
                      //                   ],
                      //                 );
                      //               } else if (snapshot.data!.isEmpty) {
                      //                 // If the data is empty, display a message indicating that no data is available
                      //                 return Column(
                      //                   mainAxisAlignment: MainAxisAlignment.center,
                      //                   children: const [
                      //                     Text('No permission data available'),
                      //                   ],
                      //                 );
                      //               } else {
                      //                 // If the data is available, display it in the DataTable
                      //                 return DataTable(
                      //                   showCheckboxColumn: false,
                      //                   columns: const <DataColumn>[
                      //                     DataColumn(label: Text('Jenis izin')),
                      //                     DataColumn(label: Text('Nama')),
                      //                     DataColumn(label: Text('Tanggal izin')),
                      //                     DataColumn(label: Text('Status izin')),
                      //                   ],
                      //                   rows: snapshot.data!.map((data) {
                      //                     return DataRow(
                      //                       cells: <DataCell>[
                      //                         DataCell(Text(data['permission_type_name'] ?? 'N/A')),
                      //                         DataCell(Text(data['employee_name'] ?? 'N/A')),
                      //                         DataCell(
                      //                           Text(data['permission_date'] ?? data['start_cuti'] ?? 'N/A'),
                      //                         ),
                      //                         DataCell(Text(data['permission_status_name'])),
                      //                       ],
                      //                       onSelectChanged: (bool? selected) {
                      //                         if (selected!) {
                      //                           Get.to(ViewOnlyPermission(permission_id: data['id_permission'].toString()));
                      //                         }
                      //                       },
                      //                     );
                      //                   }).toList(),
                      //                 );
                      //               }
                      //             },
                      //           );

                      //         } else {
                      //             return Container(
                                    
                      //             );
                      //         }

                      //       } 
                      //   }
                      // )
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

  String _formatDate(String date) {
    // Parse the date string
    DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(date);

    // Format the date as "dd MMMM yyyy"
    return DateFormat("d MMMM yyyy").format(parsedDate);
  }
}