// ignore_for_file: avoid_print, file_names, unnecessary_string_interpolations, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/AddRequestNewEmployee.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/ViewandApproveNewEmployeeRequest.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class RequestNewEmployee extends StatefulWidget {
  const RequestNewEmployee({super.key});

  @override
  State<RequestNewEmployee> createState() => _RequestNewEmployeeState();
}

class _RequestNewEmployeeState extends State<RequestNewEmployee> {
  String? leaveoptions;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  List<dynamic> profileData = [];
  int One = 0;
  int Two = 0;
  int Three = 0;
  int Four = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
    requestList = fetchAllRequest();
    fetchOne();
    fetchTwo();
    fetchThree();
    fetchFour();
  }

  final storage = GetStorage();

  late Future<List<Map<String, dynamic>>> requestList;

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

  Future<List<Map<String, dynamic>>> fetchAllRequest() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/requestemployee/getallnewrequest.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['Data'];
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchOne() async {
    try {
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/requestemployee/getrequeststatisticone.php';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('Data') && responseData['Data'] is List && (responseData['Data'] as List).isNotEmpty) {

          Map<String, dynamic> data = (responseData['Data'] as List).first;
          if (data.containsKey('count') && data['count'] != null) {

            setState(() {
              One = int.parse(data['count'].toString());
            });
            
          } else {
            print('count is null or not found in the response data.');
          }
        } else {
          print('Data is null or not found in the response data.');
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchTwo() async {
    try {
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/requestemployee/getrequeststatistictwo.php';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('Data') && responseData['Data'] is List && (responseData['Data'] as List).isNotEmpty) {

          Map<String, dynamic> data = (responseData['Data'] as List).first;
          if (data.containsKey('count') && data['count'] != null) {

            setState(() {
              Two = int.parse(data['count'].toString());
            });
            
          } else {
            print('count is null or not found in the response data.');
          }
        } else {
          print('Data is null or not found in the response data.');
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchThree() async {
    try {
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/requestemployee/getrequeststatisticthree.php';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('Data') && responseData['Data'] is List && (responseData['Data'] as List).isNotEmpty) {

          Map<String, dynamic> data = (responseData['Data'] as List).first;
          if (data.containsKey('count') && data['count'] != null) {

            setState(() {
              Three = int.parse(data['count'].toString());
            });
            
          } else {
            print('count is null or not found in the response data.');
          }
        } else {
          print('Data is null or not found in the response data.');
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchFour() async {
    try {
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/requestemployee/getrequeststatisticfour.php';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('Data') && responseData['Data'] is List && (responseData['Data'] as List).isNotEmpty) {

          Map<String, dynamic> data = (responseData['Data'] as List).first;
          if (data.containsKey('count') && data['count'] != null) {

            setState(() {
              Four = int.parse(data['count'].toString());
            });
            
          } else {
            print('count is null or not found in the response data.');
          }
        } else {
          print('Data is null or not found in the response data.');
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    var employeeId = storage.read('employee_id');
    var positionId = storage.read('position_id');
    var photo = storage.read('photo');

    return MaterialApp(
      title: "Permintaan Karyawan",
      home: SafeArea(
        child: Scaffold(
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
                        SizedBox(height: 5.sp,),
                        NamaPerusahaanMenu(companyName: companyName, companyAddress: trimmedCompanyAddress),
                        SizedBox(height: 10.sp,),
                        const HalamanUtamaMenu(),
                        SizedBox(height: 5.sp,),
                        BerandaNonActive(employeeId: employeeId.toString()),
                        SizedBox(height: 5.sp,),
                        KaryawanActive(employeeId: employeeId.toString()),
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
                //content menu
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
                            Card(
                              shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12))),
                              color: Colors.white,
                              shadowColor: Colors.black,
                              child: SizedBox(
                                width: (MediaQuery.of(context).size.width - 125.w) / 4,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 7.sp, top: 5.sp, bottom: 5.sp, right: 7.sp),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Menunggu\nHRD',
                                            style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w400,)
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(One.toString(),
                                            style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ),
                            Card(
                              shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12))),
                              color: Colors.white,
                              shadowColor: Colors.black,
                              child: SizedBox(
                                width: (MediaQuery.of(context).size.width - 125.w) / 4,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 7.sp, top: 5.sp, bottom: 5.sp, right: 7.sp),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Menunggu\nDirektur',
                                            style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w400,)
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(Two.toString(),
                                            style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ),
                            Card(
                              shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12))),
                              color: Colors.white,
                              shadowColor: Colors.black,
                              child: SizedBox(
                                width: (MediaQuery.of(context).size.width - 125.w) / 4,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 7.sp, top: 5.sp, bottom: 5.sp, right: 7.sp),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Posisi yang\ndibuka',
                                            style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w400,)
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(Three.toString(),
                                            style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ),
                            Card(
                              shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12))),
                              color: Colors.white,
                              shadowColor: Colors.black,
                              child: SizedBox(
                                width: (MediaQuery.of(context).size.width - 125.w) / 4,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 7.sp, top: 5.sp, bottom: 5.sp, right: 7.sp),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Posisi yang\nditutup',
                                            style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w400,)
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(Four.toString(),
                                            style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ),
                          ],
                        ),
                        SizedBox(height: 7.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Get.to(const AddRequestNewEmployee());
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  alignment: Alignment.center,
                                  minimumSize: Size(60.w, 40.h),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: const Color(0xff4ec3fc),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 3.sp, bottom: 3.sp),
                                      child: Text('+ Request',
                                        style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w600,)
                                      ),
                                    ),
                                  ],
                                )
                              ),
                          ],
                        ),
                        SizedBox(height: 10.sp,),
                        SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: requestList,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.hasData) {
                              return DataTable(
                                showCheckboxColumn: false,
                                columns: const <DataColumn>[
                                  DataColumn(label: Text('Posisi')),
                                  DataColumn(label: Text('Departemen')),
                                  DataColumn(label: Text('Tanggal Pengajuan')),
                                  DataColumn(label: Text('Status')),
                                ],
                                rows: snapshot.data!.map<DataRow>((employee) {
                                  return DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(employee['posisi_diajukan'])),
                                      DataCell(Text(employee['department_name'])),
                                      DataCell(Text(formatDate(employee['created_dt']))),
                                      DataCell(Text(employee['status_name'])),
                                    ],
                                    onSelectChanged: (selected) {
                                      if (selected!) {
                                        Get.to(ViewApproveNewEmployeeRequest(employee['id_new_employee_request']));
                                        // Get.to(EmployeeOverviewPage(employee['id']));
                                      }
                                    },
                                  );
                                }).toList(),
                              );
                            } else {
                              return const Center(child: Text('Tidak ada permintaan karyawan baru'));
                            }
                          },
                        ),
                      )
                      ],
                    ),
                  )
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
  String formatDate(String inputDate) {
    // Parse the input string to a DateTime object
    DateTime dateTime = DateTime.parse(inputDate);

    // Format the DateTime object as a string in the "dd MM yyyy" format
    String formattedDate = DateFormat('dd MMMM yyyy', 'id').format(dateTime);

    return formattedDate;
  }
}