// ignore_for_file: avoid_print, file_names, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Add%20New%20Employee/AddNewEmployeeOne.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Overview/EmployeeOverview.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  TextEditingController txtSearchName = TextEditingController();

  List<Map<String, String>> departments = [];
  String selectedDepartment = '';

  late Future<List<Map<String, dynamic>>> employeeList;

  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  List<dynamic> profileData = [];

  @override
  void initState() {
    super.initState();
    fetchDepartments('COM-HR-001');
    employeeList = fetchEmployeeList();
    fetchData();
  }

  Future<void> fetchDepartments(String companyId) async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getdepartment.php?company_id=$companyId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        setState(() {
          departments = (data['Data'] as List)
              .map((department) => Map<String, String>.from(department))
              .toList();
          if (departments.isNotEmpty) {
            selectedDepartment = departments[0]['department_id']!;
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
  }

  Future<List<Map<String, dynamic>>> fetchEmployeeList() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployeelist.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['Data'];
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load data');
    }
  }
  
  final storage = GetStorage();
  Future<void> fetchData() async {
    String employeeId = storage.read('employee_id').toString();

    try {
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/account/getprofileforallpage.php';

      //String employeeId = storage.read('employee_id'); // replace with your logic to get employee ID

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
    // Access the GetStorage instance
    final storage = GetStorage();

    // Retrieve the stored employee_id
    var employeeId = storage.read('employee_id');
    var positionId = storage.read('position_id');
    var photo = storage.read('photo');

    return MaterialApp(
      title: 'Employee',
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
                      SizedBox(height: 10.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 6,
                                child: TextFormField(
                                  controller: txtSearchName,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama karyawan'
                                  ),
                                ),
                              ),
                              SizedBox(width: 7.w,),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 6,
                                child: DropdownButtonFormField<String>(
                                  value: selectedDepartment,
                                  hint: const Text('Pilih departemen'),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedDepartment = newValue!;
                                    });
                                  },
                                  items: departments.map<DropdownMenuItem<String>>((Map<String, String> department) {
                                    return DropdownMenuItem<String>(
                                      value: department['department_id']!,
                                      child: Text(department['department_name']!),
                                    );
                                  }).toList(),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008')
                                ElevatedButton(
                                  onPressed: () {
                                    Get.to(const AddNewEmployeeFirst());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    alignment: Alignment.center,
                                    minimumSize: Size(60.w, 50.h),
                                    foregroundColor: const Color(0xFFFFFFFF),
                                    backgroundColor: const Color(0xff4ec3fc),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('Tambah Karyawan Baru',),
                                    ],
                                  )
                                ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 10.sp,),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: employeeList,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.hasData) {
                              return DataTable(
                                showCheckboxColumn: false,
                                columns: const <DataColumn>[
                                  DataColumn(label: Text('Nama Karyawan')),
                                  DataColumn(label: Text('Departemen')),
                                  // DataColumn(label: Text('Periode Kerja')),
                                  // DataColumn(label: Text('Status')),
                                ],
                                rows: snapshot.data!.map<DataRow>((employee) {
                                  return DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(employee['employee_name'])),
                                      DataCell(Text(employee['department_name'])),
                                      // DataCell(Text(employee['employee_name'])),
                                      // DataCell(Text(employee['department_name'])),
                                    ],
                                    onSelectChanged: (selected) {
                                      if (selected!) {
                                        Get.to(EmployeeOverviewPage(employee['id'], employee['employee_name']));
                                      }
                                    },
                                  );
                                }).toList(),
                              );
                            } else {
                              return const Center(child: Text('No data available'));
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
    );
  }
}