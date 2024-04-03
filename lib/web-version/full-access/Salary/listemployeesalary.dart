// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:hr_systems_web/web-version/full-access/Salary/detailsalary.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class ListEmployeeSalary extends StatefulWidget {
  const ListEmployeeSalary({super.key});

  @override
  State<ListEmployeeSalary> createState() => _ListEmployeeSalaryState();
}

class _ListEmployeeSalaryState extends State<ListEmployeeSalary> {
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String employeeId = '';
  String departmentName = '';
  String positionName = '';
  String trimmedCompanyAddress = '';
  bool isLoading = false;
  DateTime? TanggalMulai;
  DateTime? TanggalAkhir;
  Duration? difference;
  int? differenceDays;
  int? monthSelected;
  int? yearSelected;
  String ID = '';
  String selectedEmployeeName = '';

  late Future<List<Map<String, dynamic>>> employeeList;

  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
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
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    }
  }

  Future<void> dateFilter() async {
    setState(() {
      isLoading = true;
    });

    if (TanggalMulai != null && TanggalAkhir != null) {
      difference = TanggalAkhir!.difference(TanggalMulai!);
      differenceDays = difference?.inDays;

      if(differenceDays! >= 28){        
        setState(() {
          monthSelected = TanggalMulai?.month;
          yearSelected = TanggalMulai?.year;
          employeeList = fetchEmployeeList();
        });

      } else {
        print('Days is not valid');
      }
    } else {
      print('TanggalMulai or TanggalAkhir is null');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<List<Map<String, dynamic>>> fetchEmployeeList() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/absent/getsalarylistemployee.php?month=$monthSelected&year=$yearSelected'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['Data'];
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // Handle error or log it if needed
      print('Error: $error');
      return []; // Return an empty list in case of an error
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
    return MaterialApp(
      title: 'List karyawan',
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
                        KaryawanNonActive(employeeId: employeeId.toString()),
                        SizedBox(height: 5.sp,),
                        const GajiActive(),
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
                      const Text('Tanggal pengambilan absen'),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 250.w) / 2,
                            child: DateTimePicker(
                              lastDate: DateTime(2045),
                              firstDate: DateTime(2024),
                              initialDate: DateTime.now(),
                              dateHintText: 'Pilih tanggal mulai',
                              onChanged: (value) {
                                setState(() {
                                  TanggalMulai = DateFormat('yyyy-MM-dd').parse(value);
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 10.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 250.w) / 2,
                            child: DateTimePicker(
                              lastDate: DateTime(2045),
                              firstDate: DateTime(2024),
                              initialDate: DateTime.now(),
                              dateHintText: 'Pilih tanggal akhir',
                              onChanged: (value) {
                                setState(() {
                                  TanggalAkhir = DateFormat('yyyy-MM-dd').parse(value);
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 10.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 300.w) / 2,
                            child: ElevatedButton(
                              onPressed: (){
                                dateFilter();
                              }, 
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                alignment: Alignment.center,
                                minimumSize: Size(60.w, 50.h),
                                foregroundColor: const Color(0xFFFFFFFF),
                                backgroundColor: const Color(0xff4ec3fc),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Cari')
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 50.sp,),
                      if (isLoading)
                        const CircularProgressIndicator()
                      else if (TanggalMulai == null || TanggalAkhir == null)
                        const Text('Silahkan mengisi tanggal mulai dan akhir untuk melihat rekap absen')
                      else if (differenceDays != null && differenceDays! <= 28)
                        const Text('Rentang waktu yang anda pilih kurang dari 28 hari kalender')
                      else if (differenceDays != null && differenceDays! >= 28)
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: fetchEmployeeList(), // Assuming you have a function to fetch the employee list
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.hasData) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    // Your other widgets here
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height - 130.h,
                                      child: ListView.builder(
                                        itemCount: snapshot.data?.length,
                                        itemBuilder: (context, index) {
                                          Map<String, dynamic> employeeData = snapshot.data![index];
                                          
                                          String statusText;
                                          String complete;                                            
                                          if (employeeData['is_complete'] == null || employeeData['is_complete'] == '0') {
                                            statusText = 'Belum Selesai';
                                            complete = '0';
                                          } else {
                                            statusText = 'Selesai';
                                            complete = '1';
                                          }
                                          // ID = employeeData['id'];
                                          Color cardColor = statusText == 'Belum Selesai' ? Colors.red : Colors.green;
                        
                                          return SizedBox(
                                            width: 150,
                                            height: MediaQuery.of(context).size.height / 10,
                                            child: GestureDetector(
                                              onTap: () {
                                                selectedEmployeeName = employeeData['employee_name'];
                                                ID = employeeData['id'];
                                                Get.to(DetailSalaryPage(TanggalMulai!, TanggalAkhir!, ID, selectedEmployeeName, complete));
                                              },
                                              child: Card(
                                                child: Center(
                                                  child: ListTile(
                                                    title: Text(employeeData['employee_name']),
                                                    trailing: Card(
                                                      color: cardColor,
                                                      child: Padding(
                                                        padding: EdgeInsets.only(left: 10.sp, right: 10.sp, top: 7.sp, bottom: 7.sp),
                                                        child: Text(statusText, style: const TextStyle(color: Colors.white),),
                                                      )
                                                    ),
                                                    // Other properties based on your data
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return const Text('No data available'); // Adjust this text as needed
                            }
                          },
                        ),
                      SizedBox(height: 30.sp,),
                    ],
                  ),
                )
              )
            ],
          ),
        )
      ),
    );
  }
}