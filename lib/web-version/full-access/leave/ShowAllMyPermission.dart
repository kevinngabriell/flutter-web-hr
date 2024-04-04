
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

  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String employeeId = '';
  String departmentName = '';
  String positionName = '';
String trimmedCompanyAddress = '';
late Future<List<Map<String, dynamic>>> permissionData;

  @override
  void initState() {
    super.initState();
    fetchData();
    permissionData = fetchPermissionData();
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

  Future<List<Map<String, dynamic>>> fetchPermissionData() async {
    String employeeId = storage.read('employee_id').toString();

    final response = await http.get(
      Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/showallmypermission.php?id=$employeeId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        return List<Map<String, dynamic>>.from(data['Data']);
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
                      FutureBuilder(
                        future: Future.value(storage.read('position_id')),
                        builder: (context, snapshot){
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //Image.asset('assets/no_data.png'), // Ganti dengan path gambar yang sesuai
                                  Text('Anda belum pernah mengajukan izin apapun'),
                                ],
                              );
                            } else {
                              String? positionId = snapshot.data as String?;

                              return FutureBuilder(
                                  future: permissionData,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      // If the data is still loading, show a loading indicator
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.hasError) {
                                      // If an error occurred, display an error message
                                      return const Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Error fetching permission data'),
                                        ],
                                      );
                                    } else if (snapshot.data!.isEmpty) {
                                      // If the data is empty, display a message indicating that no data is available
                                      return const Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('No permission data available'),
                                        ],
                                      );
                                    } else {
                                      // If the data is available, display it in a DataTable
                                      return DataTable(
                                        showCheckboxColumn: false,
                                        columns: const <DataColumn>[
                                          DataColumn(label: Text('Jenis izin')),
                                          DataColumn(label: Text('Nama')),
                                          DataColumn(label: Text('Tanggal izin')),
                                          DataColumn(label: Text('Status izin')),
                                        ],
                                        rows: snapshot.data!.map((data) {
                                          return DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text(data['permission_type_name'] ?? 'N/A')),
                                              DataCell(Text(data['employee_name'] ?? 'N/A')),
                                              DataCell(
                                                Text(formatDate(data['permission_date'] ?? data['start_cuti'] ?? data['start_date'] ?? '-')),
                                              ),
                                              DataCell(Text(data['permission_status_name'] ?? 'N/A')),
                                            ],
                                            onSelectChanged: (bool? selected) {
                                              if (selected!) {
                                                Get.to(ViewOnlyPermission(permission_id: data['id_permission'].toString()));
                                              }
                                            },
                                          );
                                        }).toList(),
                                      );
                                    }
                                  },
                                );

                              
                        }}
                      )
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