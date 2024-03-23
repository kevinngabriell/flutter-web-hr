import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/web-version/full-access/Event/event.dart';
import 'package:hr_systems_web/web-version/full-access/Structure/structure.dart';
import 'package:hr_systems_web/web-version/full-access/Report/report.dart';
import 'package:hr_systems_web/web-version/full-access/Settings/setting.dart';
import 'package:hr_systems_web/web-version/full-access/Performance/performance.dart';
import 'package:hr_systems_web/web-version/full-access/Training/traning.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Add%20New%20Employee/AddNewEmployeeEight.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Add%20New%20Employee/AddNewEmployeeFive.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Add%20New%20Employee/AddNewEmployeeFour.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Add%20New%20Employee/AddNewEmployeeSeven.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Add%20New%20Employee/AddNewEmployeeSix.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Add%20New%20Employee/AddNewEmployeeThree.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Add%20New%20Employee/AddNewEmployeeTwo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../login.dart';
import '../../employee.dart';
import '../../index.dart';
import 'package:intl/intl.dart'; 
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Salary/salary.dart';

class AddNewEmployeeOne extends StatefulWidget {
  const AddNewEmployeeOne({super.key});

  @override
  State<AddNewEmployeeOne> createState() => _AddNewEmployeeOneState();
}

class _AddNewEmployeeOneState extends State<AddNewEmployeeOne> {
  /* Define value */
  final TextEditingController idKaryawan = TextEditingController();
  final TextEditingController namaKaryawan = TextEditingController();
  final TextEditingController tempatLahir = TextEditingController();
  final TextEditingController nomorIdentitas = TextEditingController();
  final TextEditingController nomorJamsostek = TextEditingController();

  String idKaryawanText = '';
  String namaKaryawanText = '';
  String tempatLahirText = '';
  String nomorIdentitasText = '';
  String nomorJamsostekText = '';
String trimmedCompanyAddress = '';
  DateTime? dateTime;
  String selectedDateText = '';

  List<Map<String, String>> companies = [];
  String selectedCompany = '';

  List<Map<String, String>> departments = [];
  String selectedDepartment = '';
  bool showNoDepartments = false;

  List<Map<String, String>> genders = [];
  String selectedGender = '';

  List<Map<String, String>> employeeStatuses = [];
  String selectedEmployeeStatus = '';

  List<Map<String, String>> religions = [];
  String selectedReligion = '';

  List<Map<String, String>> positions = [];
  String selectedPosition = '';

  List<Map<String, String>> nationalities = [];
  String selectedNationality = '';

  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';

  List<dynamic> profileData = [];

  @override
  void initState() {
    super.initState();
    fetchCompanies();
    fetchGenders();
    fetchEmployeeStatuses();
    fetchReligions();
    fetchNationalities();
    fetchData();
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

  Future<void> fetchCompanies() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getcompanydata.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        setState(() {
          companies = (data['Data'] as List)
              .map((company) => Map<String, String>.from(company))
              .toList();

          if (companies.isNotEmpty) {
            // Set the selectedCompany to the first item in the list by default
            selectedCompany = companies[0]['company_id'].toString();
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

  Future<void> fetchDepartments(String companyId) async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getdepartment.php?company_id=$selectedCompany'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        setState(() {
          departments = (data['Data'] as List)
              .map((department) => Map<String, String>.from(department))
              .toList();
          if (departments.isNotEmpty) {
            selectedDepartment = departments[0]['department_id']!;
            showNoDepartments = false;
          } else {
            showNoDepartments = true;
          }
        });
      } else {
        // Handle API error
        print('Failed to fetch data');
      }
    } else if (response.statusCode == 404) {
      // Show "Tidak ada departemen" if departments are not found
      setState(() {
        showNoDepartments = true;
      });
    } else {
      // Handle other HTTP errors
      print('Failed to fetch data');
    }
  }

  Future<void> fetchGenders() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getgender.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        setState(() {
          genders = (data['Data'] as List)
              .map((gender) => Map<String, String>.from(gender))
              .toList();
          if (genders.isNotEmpty) {
            selectedGender = genders[0]['gender_id']!;
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
  
  Future<void> fetchEmployeeStatuses() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getemployeestatus.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        setState(() {
          employeeStatuses = (data['Data'] as List)
              .map((status) => Map<String, String>.from(status))
              .toList();
          if (employeeStatuses.isNotEmpty) {
            selectedEmployeeStatus = employeeStatuses[0]['status_id']!;
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
  
  Future<void> fetchReligions() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getreligion.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        setState(() {
          religions = (data['Data'] as List)
              .map((religion) => Map<String, String>.from(religion))
              .toList();
          if (religions.isNotEmpty) {
            selectedReligion = religions[0]['religion_id']!;
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
  
  Future<void> fetchPositions(String companyId, String departmentId) async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getposition.php?company_id=$selectedCompany&department_id=$selectedDepartment'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        setState(() {
          positions = (data['Data'] as List)
              .map((position) => Map<String, String>.from(position))
              .toList();
          if (positions.isNotEmpty) {
            selectedPosition = positions[0]['position_id']!;
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
  
  Future<void> fetchNationalities() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getnationality.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        setState(() {
          nationalities = (data['Data'] as List)
              .map((nationality) => Map<String, String>.from(nationality))
              .toList();
          if (nationalities.isNotEmpty) {
            selectedNationality = nationalities[0]['num_code']!;
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

  Future<void> insertEmployee() async {
    try {
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/insertemployee/insertone.php';

      // Make the API call with a POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
            'employee_id': idKaryawanText,
            'employee_name': namaKaryawanText,
            'department_id': selectedDepartment,
            'position_id': selectedPosition,
            'company_id': selectedCompany,
            'gender': selectedGender,
            'employee_pob': tempatLahirText,
            'employee_dob': dateTime.toString(),
            'employee_nationality': selectedNationality,
            'employee_identity': nomorIdentitasText, 
            'employee_jamsostek': nomorJamsostekText,
            'employee_status': selectedEmployeeStatus,
            'employee_religion': selectedReligion,
        },
      );

      if (response.statusCode == 200) {
        print('Employee inserted successfully');
        Get.to(AddNewEmployeeTwo());
        // Add any additional logic or UI updates after successful insertion
      } else {
        Get.snackbar('Gagal', '${response.body}');
        print('Failed to insert employee. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Handle the error or show an error message to the user
      }
    } catch (e) {
      Get.snackbar('Gagal', '$e');
      print('Exception during API call: $e');
      // Handle exceptions or show an error message to the user
    }
  }
  var dropdownvalue;
  
  @override
  Widget build(BuildContext context) {
    // Access the GetStorage instance
    final storage = GetStorage();

    // Retrieve the stored employee_id
    var employeeId = storage.read('employee_id');
    var photo = storage.read('photo');
    return MaterialApp(
      title: "Tambah Karyawan - Informasi Pribadi",
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
                        SizedBox(height: 15.sp,),
                        //company logo and name
                        ListTile(
                        contentPadding: const EdgeInsets.only(left: 0, right: 0),
                        dense: true,
                        horizontalTitleGap: 0.0, // Adjust this value as needed
                        leading: Container(
                          margin: EdgeInsets.only(right: 2.0), // Add margin to the right of the image
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
                        //halaman utama title
                        Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: Text("Halaman utama", 
                            style: TextStyle( fontSize: 20.sp, fontWeight: FontWeight.w600,)
                          ),
                        ),
                        SizedBox(height: 10.sp,),
                        //beranda button
                        Padding(
                          padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          child: ElevatedButton(
                            onPressed: () {Get.to(FullIndexWeb(employeeId));},
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
                                  child: Image.asset('images/home-inactive.png')
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
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: const Color(0xff4ec3fc),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Image.asset('images/employee-active.png')
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
                                  Get.to(SalaryIndex());
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
                                  Get.to(PerformanceIndex());
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
                            //pelatihan button
                            Padding(
                              padding: EdgeInsets.only(left: 5.w, right: 5.w),
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(TrainingIndex());
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
                            //acara button
                            Padding(
                              padding: EdgeInsets.only(left: 5.w, right: 5.w),
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(EventIndex());
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
                                  Get.to(ReportIndex());
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
                                  Get.to(SettingIndex());
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
                                  Get.to(StructureIndex());
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
                                        title: Text("Keluar"),
                                        content: Text('Apakah anda yakin akan keluar ?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {Get.back();},
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {Get.off(LoginPageDesktop());},
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
                //content menu
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: EdgeInsets.only(left: 7.w, right: 7.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 100.sp,),
                        //statistik card
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width- 170.w) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("ID Karyawan",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  TextFormField(
                                    controller: idKaryawan,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan ID karyawan'
                                    ),
                                    readOnly: false,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width- 170.w) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Nama Lengkap",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  TextFormField(
                                    controller: namaKaryawan,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan nama lengkap karyawan'
                                    ),
                                    readOnly: false,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width- 170.w) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Jenis Kelamin",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedGender,
                                    hint: Text('Select Gender'),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedGender = newValue!;
                                      });
                                    },
                                    items: genders.map<DropdownMenuItem<String>>(
                                      (Map<String, String> gender) {
                                        return DropdownMenuItem<String>(
                                          value: gender['gender_id']!,
                                          child: Text(gender['gender_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width- 170.w) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Tempat Lahir",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  TextFormField(
                                    controller: tempatLahir,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan tempat lahir karyawan'
                                    ),
                                    readOnly: false,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width- 170.w) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Tanggal Lahir",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DateTimePicker(
                                      firstDate: DateTime(1700),
                                      lastDate: DateTime(2100),
                                      initialDate: DateTime.now(),
                                      dateMask: 'd MMM yyyy',
                                      onChanged: (value) {
                                        dateTime = DateFormat('yyyy-MM-dd').parse(value);
                                      },
                                    )
                                ],
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width- 170.w) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Kewarganegaraan",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedNationality,
                                    hint: Text('Pilih kewarganegaraan'),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedNationality = newValue!;
                                      });
                                    },
                                    items: nationalities.map<DropdownMenuItem<String>>(
                                      (Map<String, String> nationality) {
                                        return DropdownMenuItem<String>(
                                          value: nationality['num_code']!,
                                          child: Text(nationality['nationality']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width- 170.w) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Perusahaan",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedCompany,
                                    hint: Text('Select Company'),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedCompany = newValue.toString();
                                        fetchDepartments(selectedCompany);
                                      });
                                    },
                                    items: companies.map<DropdownMenuItem<String>>((Map<String, String> company) {
                                      return DropdownMenuItem<String>(
                                        value: company['company_id']!,
                                        child: Text(company['company_name']!),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width- 170.w) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Departemen",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  if (showNoDepartments)
                                    Text(
                                      'Tidak ada departemen',
                                      style: TextStyle(fontSize: 18),
                                    )
                                  else
                                    DropdownButtonFormField<String>(
                                      value: selectedDepartment,
                                      hint: Text('Pilih Departemen'),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedDepartment = newValue!;
                                          fetchPositions(selectedCompany, selectedDepartment);
                                        });
                                      },
                                      items: departments.map<DropdownMenuItem<String>>(
                                        (Map<String, String> department) {
                                          return DropdownMenuItem<String>(
                                            value: department['department_id']!,
                                            child: Text(department['department_name']!),
                                          );
                                        },
                                      ).toList(),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width- 170.w) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Jabatan",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedPosition,
                                    hint: Text('Select Position'),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedPosition = newValue!;
                                      });
                                    },
                                    items: positions.map<DropdownMenuItem<String>>(
                                      (Map<String, String> position) {
                                        return DropdownMenuItem<String>(
                                          value: position['position_id']!,
                                          child: Text(position['position_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width- 170.w) / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Nomor Identitas",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  TextFormField(
                                    controller: nomorIdentitas,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan nomor identitas'
                                    ),
                                    readOnly: false,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width- 170.w) / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Nomor Jamsostek",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  TextFormField(
                                    controller: nomorJamsostek,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan nomor jamsostek'
                                    ),
                                    readOnly: false,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width- 170.w) / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Status",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedEmployeeStatus,
                                    hint: Text('Pilih status karyawan'),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedEmployeeStatus = newValue!;
                                      });
                                    },
                                    items: employeeStatuses.map<DropdownMenuItem<String>>(
                                      (Map<String, String> status) {
                                        return DropdownMenuItem<String>(
                                          value: status['status_id']!,
                                          child: Text(status['status_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width- 170.w) / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Agama",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedReligion,
                                    hint: Text('Pilih agama'),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedReligion = newValue!;
                                      });
                                    },
                                    items: religions.map<DropdownMenuItem<String>>(
                                      (Map<String, String> religion) {
                                        return DropdownMenuItem<String>(
                                          value: religion['religion_id']!,
                                          child: Text(religion['religion_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                          onPressed: () {
                             idKaryawanText = idKaryawan.text;
                             namaKaryawanText = namaKaryawan.text;
                             tempatLahirText = tempatLahir.text;
                             nomorIdentitasText = nomorIdentitas.text;
                             nomorJamsostekText = nomorJamsostek.text;

                            //validation 
                            if(idKaryawanText.isEmpty){
                              Get.dialog(Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 550.sp),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(20.0.sp),
                                        child: Material(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              Text(
                                                "Invalid",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 30.sp,
                                                    fontWeight: FontWeight.w900),
                                              ),
                                              SizedBox(height: 15.sp),
                                              Text(
                                                "ID Karyawan anda masih kosong!! Silahkan diisi ID Karyawan anda",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w300),
                                              ),
                                              SizedBox(height: 25.sp),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      child: const Text(
                                                        'Oke',
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                        minimumSize:
                                                            Size(0.sp, 45.sp),
                                                        foregroundColor:
                                                            const Color(0xFFFFFFFF),
                                                        backgroundColor:
                                                            const Color(0xff4ec3fc),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  8),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ));
                            } else if (namaKaryawanText.isEmpty){
                              Get.dialog(Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 550.sp),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(20.0.sp),
                                        child: Material(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              Text(
                                                "Invalid",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 30.sp,
                                                    fontWeight: FontWeight.w900),
                                              ),
                                              SizedBox(height: 15.sp),
                                              Text(
                                                "Nama Karyawan anda masih kosong!! Silahkan diisi Nama Karyawan anda",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w300),
                                              ),
                                              SizedBox(height: 25.sp),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      child: const Text(
                                                        'Oke',
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                        minimumSize:
                                                            Size(0.sp, 45.sp),
                                                        foregroundColor:
                                                            const Color(0xFFFFFFFF),
                                                        backgroundColor:
                                                            const Color(0xff4ec3fc),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  8),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ));
                            } else if (selectedGender.isEmpty){
                               Get.dialog(Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 550.sp),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(20.0.sp),
                                        child: Material(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              Text(
                                                "Invalid",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 30.sp,
                                                    fontWeight: FontWeight.w900),
                                              ),
                                              SizedBox(height: 15.sp),
                                              Text(
                                                "Anda belum memilih jenis kelamin !!",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w300),
                                              ),
                                              SizedBox(height: 25.sp),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      child: const Text(
                                                        'Oke',
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                        minimumSize:
                                                            Size(0.sp, 45.sp),
                                                        foregroundColor:
                                                            const Color(0xFFFFFFFF),
                                                        backgroundColor:
                                                            const Color(0xff4ec3fc),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  8),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ));
                            } else if (tempatLahirText.isEmpty){
                              Get.dialog(Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 550.sp),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(20.0.sp),
                                        child: Material(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              Text(
                                                "Invalid",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 30.sp,
                                                    fontWeight: FontWeight.w900),
                                              ),
                                              SizedBox(height: 15.sp),
                                              Text(
                                                "Tempat lahir anda masih kosong!! Silahkan diisi Tempat lahir anda",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w300),
                                              ),
                                              SizedBox(height: 25.sp),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      child: const Text(
                                                        'Oke',
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                        minimumSize:
                                                            Size(0.sp, 45.sp),
                                                        foregroundColor:
                                                            const Color(0xFFFFFFFF),
                                                        backgroundColor:
                                                            const Color(0xff4ec3fc),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  8),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ));
                            } else if (selectedDepartment.isEmpty){
                              Get.dialog(Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 550.sp),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(20.0.sp),
                                        child: Material(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              Text(
                                                "Invalid",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 30.sp,
                                                    fontWeight: FontWeight.w900),
                                              ),
                                              SizedBox(height: 15.sp),
                                              Text(
                                                "Silahkan pilih terlebih dahulu perusahaan dan departemen !!",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w300),
                                              ),
                                              SizedBox(height: 25.sp),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      child: const Text(
                                                        'Oke',
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                        minimumSize:
                                                            Size(0.sp, 45.sp),
                                                        foregroundColor:
                                                            const Color(0xFFFFFFFF),
                                                        backgroundColor:
                                                            const Color(0xff4ec3fc),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  8),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ));
                            } else if (selectedPosition == null){
                              Get.dialog(Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 550.sp),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(20.0.sp),
                                        child: Material(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              Text(
                                                "Invalid",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 30.sp,
                                                    fontWeight: FontWeight.w900),
                                              ),
                                              SizedBox(height: 15.sp),
                                              Text(
                                                "Silahkan pilih terlebih dahulu perusahaan, departemen, dan posisi !!",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w300),
                                              ),
                                              SizedBox(height: 25.sp),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      child: const Text(
                                                        'Oke',
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                        minimumSize:
                                                            Size(0.sp, 45.sp),
                                                        foregroundColor:
                                                            const Color(0xFFFFFFFF),
                                                        backgroundColor:
                                                            const Color(0xff4ec3fc),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  8),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ));
                            } else if (nomorIdentitasText.isEmpty){
                               Get.dialog(Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 550.sp),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(20.0.sp),
                                        child: Material(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              Text(
                                                "Invalid",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 30.sp,
                                                    fontWeight: FontWeight.w900),
                                              ),
                                              SizedBox(height: 15.sp),
                                              Text(
                                                "Nomor identitas anda masih kosong !! Silahkan isi nomor identitas anda !!",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w300),
                                              ),
                                              SizedBox(height: 25.sp),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      child: const Text(
                                                        'Oke',
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                        minimumSize:
                                                            Size(0.sp, 45.sp),
                                                        foregroundColor:
                                                            const Color(0xFFFFFFFF),
                                                        backgroundColor:
                                                            const Color(0xff4ec3fc),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  8),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ));
                            } else {
                              // print('ID Karyawan : ' + idKaryawanText + '\n');
                              // print('Nama Karyawan : ' + namaKaryawanText + '\n');
                              // print('Jenis kelamin : ' + selectedGender + '\n');
                              // print('Tempat lahir : ' + tempatLahirText + '\n');
                              // print('Tanggal lahir : ' + dateTime.toString() + '\n');
                              // print('Kewarganegaraan : ' + selectedNationality + '\n');
                              // print('Perusahaan : ' + selectedCompany + '\n');
                              // print('Departemen : ' + selectedDepartment + '\n');
                              // print('Jabatan : ' + selectedDepartment + '\n');
                              // print('Posisi : ' + selectedPosition + '\n');
                              // print('Identitas : ' + nomorIdentitasText + '\n');
                              // print('Jamsostek : ' + nomorJamsostekText + '\n');
                              // print('Status : ' + selectedEmployeeStatus + '\n');
                              // print('Agaman : ' + selectedReligion + '\n');

                              insertEmployee();                 
                            }

                            // Get.to(AddNewEmployeeTwo());
                          }, 
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(0.sp, 45.sp),
                            foregroundColor: const Color(0xFFFFFFFF),
                            backgroundColor: const Color(0xff4ec3fc),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Berikutnya')
                        ),
                          ],
                        )
                      ],
                    ),
                  )
                ),
                //right profile
                Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15.sp,),
                        //photo profile and name
                        ListTile(
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
                          subtitle: Text('$employeeEmail',
                            style: TextStyle( fontSize: 15.sp, fontWeight: FontWeight.w300,),
                          ),
                        ),
                        SizedBox(height: 30.sp,),
                        SizedBox(
                          child: Card(
                            shape: const RoundedRectangleBorder( 
                              borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            color: Colors.white,
                            shadowColor: Colors.black,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.495 / 2,
                              child: Padding(
                                padding: EdgeInsets.only(left: 17.sp, top: 5.sp, bottom: 15.sp,right: 7.sp),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:  EdgeInsets.only(top: 15.sp, bottom: 15.sp),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(AddNewEmployeeOne());
                                        },
                                        child: Text("Informasi pribadi", 
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            color: const Color.fromRGBO(78, 195, 252, 1)
                                          ),
                                        )
                                      ),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.only(top: 15.sp, bottom: 15.sp),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(AddNewEmployeeTwo());
                                        },
                                        child: Text("Data alamat", 
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            //color: const Color.fromRGBO(78, 195, 252, 1)
                                          ),
                                        )
                                      ),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.only(top: 15.sp, bottom: 15.sp),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(AddNewEmployeeThree());
                                        },
                                        child: Text("Riwayat kerja", 
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            //color: const Color.fromRGBO(78, 195, 252, 1)
                                          ),
                                        )
                                      ),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.only(top: 15.sp, bottom: 15.sp),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(AddNewEmployeeFour());
                                        },
                                        child: Text("Pendidikan", 
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            //color: const Color.fromRGBO(78, 195, 252, 1)
                                          ),
                                        )
                                      ),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.only(top: 15.sp, bottom: 15.sp),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(AddNewEmployeeFive());
                                        },
                                        child: Text("Kemampuan bahasa", 
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            //color: const Color.fromRGBO(78, 195, 252, 1)
                                          ),
                                        )
                                      ),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.only(top: 15.sp, bottom: 15.sp),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(AddNewEmployeeSix());
                                        },
                                        child: Text("Data keluarga", 
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            //color: const Color.fromRGBO(78, 195, 252, 1)
                                          ),
                                        )
                                      ),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.only(top: 15.sp, bottom: 15.sp),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(AddNewEmployeeSeven());
                                        },
                                        child: Text("Pertanyaan", 
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            //color: const Color.fromRGBO(78, 195, 252, 1)
                                          ),
                                        )
                                      ),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.only(top: 15.sp, bottom: 15.sp),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(AddNewEmployeeEight());
                                        },
                                        child: Text("Pernyataan", 
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            //color: const Color.fromRGBO(78, 195, 252, 1)
                                          ),
                                        )
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                ),
              ],
            )
        ),
      ),
    );
  }
}