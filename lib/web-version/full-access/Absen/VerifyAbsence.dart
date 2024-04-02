// ignore_for_file: file_names, avoid_print, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:hr_systems_web/web-version/full-access/index.dart';
import 'package:http/http.dart' as http;

class VerifyAbsence extends StatefulWidget {
  const VerifyAbsence({super.key});

  @override
  State<VerifyAbsence> createState() => _VerifyAbsenceState();
}

class _VerifyAbsenceState extends State<VerifyAbsence> {
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  List<dynamic> profileData = [];
  List<Map<String, dynamic>> jsonData = [];
  String absenceType = '';
  String dateTimeValue = '';
  bool isLoading = false;
  String? txtMonthSelected;
  String? txtYearSelected;
  late Future<List<Map<String, dynamic>>> employeeList;

  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    fetchData();
    employeeList = fetchEmployeeList();
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
  
  Future<List<Map<String, dynamic>>> fetchEmployeeList() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/absent/getlistemployeeisnotvalid.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['Data'];
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Tidak ada absen yang perlu verifikasi');
    }
  }

  Future<void> updateVerify(absence_id) async {

      isLoading = true;

      try {
        String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/absent/verifyabsent.php';

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "absence_id": absence_id
          }
        );

        if(response.statusCode == 200){
         
          // Access the GetStorage instance
          final storage = GetStorage();

          // Retrieve the stored employee_id
          var employeeId = storage.read('employee_id');
          isLoading = false;
          Get.to(FullIndexWeb(employeeId));
        } else {
          Get.snackbar('Gagal', response.body);
          print('Failed to insert employee. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }

      } catch (e){
        Get.snackbar('Gagal', '$e');
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
      title: 'Employee Absence Verify',
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
                      //Profile Name
                      NotificationnProfile(employeeName: employeeName, employeeAddress: employeeEmail, photo: photo),
                      SizedBox(height: 7.sp,),
                      //Title
                      Center(
                        child: Text(
                          "Verifikasi Absen Karyawan",
                          style: TextStyle(
                            fontSize: 6.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color.fromRGBO(116, 116, 116, 1)
                          ),
                        ),
                      ),
                      //Form
                      SizedBox(height: 10.sp,),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 100.sp,
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
                                  DataColumn(label: Text('Tanggal Absen')),
                                  DataColumn(label: Text('Jam Absen')),
                                  DataColumn(label: Text('Lokasi Absen')),
                                  DataColumn(label: Text('Verifikasi')),
                                  // DataColumn(label: Text('Status')),
                                ],
                                rows: snapshot.data!.map<DataRow>((employee) {
                                  return DataRow(
                                    cells: <DataCell>[
                                      DataCell(
                                        SizedBox(
                                          width: 60.w,
                                          child: Text(employee['employee_name'])
                                        )
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: 26.w,
                                          child: Text(employee['date'])
                                        )
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: 26.w,
                                          child: Text(employee['time'])
                                        )
                                      ),
                                      DataCell(
                                        SizedBox(
                                          child: Text(employee['location'])
                                        )
                                      ),
                                      DataCell(
                                        ElevatedButton(
                                          onPressed: () async {
                                            showDialog(
                                              context: context, 
                                              builder: (_) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Detail Absen', 
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 7.sp,
                                                      fontWeight: FontWeight.w800
                                                    ),
                                                  ),
                                                  content: SingleChildScrollView(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(employee['absence_id']),
                                                            const SizedBox(width: 30),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                buildDetailField('Tipe Absen', employee['presence_type_name']),
                                                                buildDetailField('Tanggal Absen', employee['date']),
                                                                buildDetailField('Jam Absen', employee['time']),
                                                                buildDetailField('Lokasi', employee['location'], maxLines: 3),
                                                              ],
                                                            ),
                                                          ]
                                                        )
                                                      ]
                                                    )
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () async {await updateVerify(employee['absence_id']);},
                                                      child: const Text('Verifikasi Absen')
                                                    ),
                                                    TextButton(
                                                      onPressed: () => Navigator.of(context).pop(),
                                                      child: const Text('Kembali'),
                                                    ),
                                                  ],
                                                );
                                              }
                                            );
                                              // showDialog(
                                              //   context: context,
                                              //   builder: (_) {
                                              //     return const AlertDialog(
                                              //       content: Row(
                                              //         children: [
                                              //           CircularProgressIndicator(),
                                              //           SizedBox(width: 20),
                                              //           Text('Loading ...'),
                                              //         ],
                                              //       ),
                                              //     );
                                              //   },
                                              // );

                                              // try {
                                              //   await updateVerify(employee['absence_id']);
                                              //   // await pickFile(); // Wait for pickFile to complete
                                              //   // Handle the file data as needed after picking is complete
                                              // } finally {
                                              //   isLoading = false;
                                              //   Get.snackbar('Sukses', 'Absen telah berhasil diverifikasi');
                                              //   Get.to(FullIndexWeb(employeeId));
                                              // }
                                          }, 
                                          child: const Text('Verifikasi')
                                        )
                                      ),
                                      // DataCell(Text(employee['employee_name'])),
                                      // DataCell(Text(employee['department_name'])),
                                    ],
                                    onSelectChanged: (selected) {
                                      if (selected!) {
                                        // Get.to(EmployeeOverviewPage(employee['id']));
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
                      ),
                      SizedBox(height: 30.sp,),
                    ]
                  )
                )  
              )
            ],
          ),
        )
      ),
    );
  }

  Widget buildDetailField(String label, String value, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 4.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          child: TextFormField(
            maxLines: maxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
            readOnly: true,
            initialValue: value,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}