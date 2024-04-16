// ignore_for_file: unnecessary_string_interpolations, file_names, avoid_print, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:hr_systems_web/web-version/full-access/leave/ViewOnly.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
                  padding: EdgeInsets.only(left: 7.w, right: 7.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5.sp,),
                      NotificationnProfile(employeeName: employeeName, employeeAddress: employeeEmail, photo: photo),
                      SizedBox(height: 7.sp,),
                        if(isSearch == true && permissionData.isNotEmpty && (positionId == 'POS-HR-001' || positionId == 'POS-HR-004' || positionId == 'POS-HR-024'))
                          const SizedBox(
                            child: Text(''),
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
                                      Text('Nama', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 4.sp),),
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
                                      Text('Departemen', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 4.sp)),
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
                                      Text('Jenis Izin', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 4.sp)),
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
                                  Text('Belum ada izin yang membutuhkan persetujuan anda', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 4.sp),)
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
                                      Text('Nama', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 4.sp),),
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
                                      Text('Departemen', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 4.sp)),
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
                                      Text('Jenis Izin', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 4.sp)),
                                      SizedBox(height: 5.sp,),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width / 6,
                                        child: DropdownButtonFormField(
                                          items: const [],
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
                                  Text('Belum ada izin yang membutuhkan persetujuan anda', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 4.sp),)
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
                                      Text('Nama', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 4.sp),),
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
                                      Text('Departemen', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 4.sp)),
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
                                      Text('Jenis Izin', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 4.sp)),
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
                              SizedBox(height: 4.sp,),
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
                                                  Text(permissionstatus, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 4.sp, color: textColor),),
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
                        SizedBox(height: 10.h,)
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
    return DateFormat("d MMMM yyyy", 'id').format(parsedDate);
  }
}