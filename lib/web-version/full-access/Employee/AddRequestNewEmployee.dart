// ignore_for_file: file_names, avoid_print, prefer_const_constructors, prefer_final_fields, unnecessary_string_interpolations, non_constant_identifier_names

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Event/event.dart';
import 'package:hr_systems_web/web-version/full-access/Performance/performance.dart';
import 'package:hr_systems_web/web-version/full-access/Report/report.dart';
import 'package:hr_systems_web/web-version/full-access/Salary/salary.dart';
import 'package:hr_systems_web/web-version/full-access/Settings/setting.dart';
import 'package:hr_systems_web/web-version/full-access/Structure/structure.dart';
import 'package:hr_systems_web/web-version/full-access/Training/traning.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../login.dart';
import '../employee.dart';
import '../index.dart';

class AddRequestNewEmployee extends StatefulWidget {
  const AddRequestNewEmployee({super.key});

  @override
  State<AddRequestNewEmployee> createState() => _AddRequestNewEmployeeState();
}

class _AddRequestNewEmployeeState extends State<AddRequestNewEmployee> {
  TextEditingController txtNomor = TextEditingController();
  TextEditingController txtNamaLengkap = TextEditingController();
  TextEditingController txtNIK = TextEditingController();
  TextEditingController txtDepartemen = TextEditingController();
  TextEditingController txtJabatan = TextEditingController();
  TextEditingController txtPosisiUsul = TextEditingController();
  TextEditingController txtJumlahUsul = TextEditingController();
  String? txtAlasan;
  String? txtJenisKelamin;
  String? txtStatusKaryawan;
  String? txtStatus;
  TextEditingController txtMinUsia = TextEditingController();
  TextEditingController txtMaxUsia = TextEditingController();
  TextEditingController txtTinggi = TextEditingController();
  TextEditingController txtBerat = TextEditingController();
  TextEditingController txtFakultas = TextEditingController();
  TextEditingController txtJurusan = TextEditingController();
  TextEditingController txtIpk = TextEditingController();
  TextEditingController txtTahunPengalaman = TextEditingController();
  TextEditingController txtPeranPengalaman = TextEditingController();
  TextEditingController txtKeahlianLain = TextEditingController();
  String? txtKualifikasiNama;
  String? txtKualifikasiJabatan;
  String? txtKualifikasiDepartemen;
  String? txtTanggungJawab;
  TextEditingController txtRincianTugas = TextEditingController();
  TextEditingController txtCatatanLain = TextEditingController();

  TextEditingController otpOne = TextEditingController();
  TextEditingController otpTwo = TextEditingController();
  TextEditingController otpThree = TextEditingController();
  TextEditingController otpFour = TextEditingController();
  TextEditingController otpFive = TextEditingController();
  TextEditingController otpSix = TextEditingController();
  DateTime? TanggalMulai;

  String? leaveoptions;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String employeeId = '';
  String departmentName = '';
  String positionName = '';
  int counter = 1;
  String trimmedCompanyAddress = '';
  bool isLoading = false;

  List<dynamic> profileData = [];  

  List<Map<String, String>> genders = [];
  String selectedGender = '';

  List<Map<String, String>> reasons = [];
  String selectedReason = '';

  String? selectedHubunganKerja;
  List<Map<String, String>> HubunganKerjaList = [];

  List<Map<String, String>> employeeStatuses = [];
  String selectedEmployeeStatus = '';

  List<Map<String, String>> employeeNameList= [];
  List<Map<String, String>> employeeNameListPIC= [];

  List<Map<String, String>> kualifikasi = [];
  bool showNoKualifikasi = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDataforFilled();
    // txtNomor.text = generateAutoIncrementId();
    fetchGenders();
    fetchReason();
    fetchHubunganKerja();
    fetchEmployeeStatuses();
    fetchEmployeeName();
    fetchEmployeeNamePIC();
  }

  final storage = GetStorage();

  Future<void> fetchKualifikasi(String employeeId) async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/requestemployee/getemployeekualifikasi.php?employee_id=$employeeId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        setState(() {
          kualifikasi = (data['Data'] as List)
              .map((kualifikass) => Map<String, String>.from(kualifikass))
              .toList();
          if (kualifikasi.isNotEmpty) {
            txtKualifikasiJabatan = kualifikasi[0]['id']!;
            txtKualifikasiDepartemen = kualifikasi[0]['id']!;
            showNoKualifikasi = false;
          } else {
            showNoKualifikasi = true;
          }
        });
      } else {
        // Handle API error
        print('Failed to fetch data');
      }
    } else if (response.statusCode == 404) {
      // Show "Tidak ada departemen" if departments are not found
      setState(() {
        showNoKualifikasi = true;
      });
    } else {
      // Handle other HTTP errors
      print('Failed to fetch data');
    }
  }

  Future<void> fetchEmployeeNamePIC() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployeelist.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        setState(() {
          employeeNameListPIC = (data['Data'] as List)
              .map((status) => Map<String, String>.from(status))
              .toList();
          if (employeeNameListPIC.isNotEmpty) {
            txtTanggungJawab = employeeNameListPIC[0]['id']!;
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

  Future<void> fetchEmployeeName() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployeelist.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        setState(() {
          employeeNameList = (data['Data'] as List)
              .map((status) => Map<String, String>.from(status))
              .toList();
          if (employeeNameList.isNotEmpty) {
            txtKualifikasiNama = employeeNameList[0]['id']!;
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

  Future<void> fetchHubunganKerja() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/gethubungankerja.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        final HubunganKerja = (data['Data'] as List)
            .map((HubKerja) => Map<String, String>.from({
                  'hubungan_kerja_id': HubKerja['hubungan_kerja_id'],
                  'hubungan_kerja_name': HubKerja['hubungan_kerja_name'],
                }))
            .toList();

        setState(() {
          HubunganKerjaList = HubunganKerja;
          if (HubunganKerjaList.isNotEmpty) {
            selectedHubunganKerja = HubunganKerjaList[0]['hubungan_kerja_id'];
          }
        });
      } else {
        // Handle API error
        print('Failed to fetch hubungan kerja list');
      }
    } else {
      // Handle HTTP error
      print('Failed to fetch data');
    }
  }

  Future<void> fetchReason() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/requestemployee/getreason.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        setState(() {
          reasons = (data['Data'] as List)
              .map((reason) => Map<String, String>.from(reason))
              .toList();
          if (reasons.isNotEmpty) {
            selectedReason = reasons[0]['reason_request_id']!;
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

  Future<void> fetchDataforFilled() async {
    setState(() {
      isLoading = true;
    });

    try {
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-systems-data-v.1/GetDataForPermission.php';

      // Replace 'employee_id' with the actual employee ID from storage
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

        setState(() {
          employeeName = data['Data']['employee_name'] as String;
          employeeId = data['Data']['employee_id'] as String;
          departmentName = data['Data']['department_name'] as String;
          positionName = data['Data']['position_name'] as String;

          txtNamaLengkap.text = employeeName;
          txtNIK.text = employeeId;
          txtDepartemen.text = departmentName;
          txtJabatan.text = positionName;
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  
  String generateAutoIncrementId() {
    String prefix = 'AS'; // Your desired prefix
    String id = '$prefix${counter.toString().padLeft(4, '0')}';
    return id;
  }

  Future<void> insertRequest() async {
    try{
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/requestemployee/insertnewrequest.php';

      String employeeId = storage.read('employee_id').toString(); // replace with your logic to get employee ID
      DateTime dateNow = DateTime.now();

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "employeeId": employeeId,
          "requestId": txtNomor.text,
          "requestPosisi": txtPosisiUsul.text,
          "requestJumlah": txtJumlahUsul.text,
          "requestAlasan": selectedReason,
          "requestGender" : selectedGender,
          "requestHubunganKerja" : selectedHubunganKerja,
          "requestStatusKaryawan" : selectedEmployeeStatus,
          "requestMinUsia" : txtMinUsia.text,
          "requestMaxUsia" : txtMaxUsia.text,
          "requestTinggiBadan" : txtTinggi.text,
          "requestBeratBadan" : txtBerat.text,
          "requestFakultas" : txtFakultas.text,
          "requestJurusan" : txtJurusan.text,
          "requestIPK" : txtIpk.text,
          "requestLamaPengalaman" : txtTahunPengalaman.text,
          "requestPeran" : txtPeranPengalaman.text,
          "requestKeahlianLain" : txtKeahlianLain.text,
          "requestKualifikasi" : txtKualifikasiNama,
          "requestPIC" : txtTanggungJawab,
          "requestRincianTugas" : txtRincianTugas.text,
          "requestMulaiKerja" : TanggalMulai.toString(),
          "requestCatatanlain" : txtCatatanLain.text,
          "requestDateInsert" : dateNow.toString(),
        }
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Sukses"),
              content: const Text("Permohonan karyawan baru anda telah berhasil diajukan"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.to(FullIndexWeb(employeeId));
                  }, 
                  child: const Text("Kembali ke halaman utama")
                ),
                TextButton(
                  onPressed: () {
                    //Get.to(EmployeeListPage());
                  }, 
                  child: const Text("Lihat detail pengajuan")
                )
              ],
            );
          }
        );
        // Add any additional logic or UI updates after successful insertion
      } else {
        Get.snackbar('Gagal', '${response.body}');
        // Handle the error or show an error message to the user
      }

    } catch (e){
      Get.snackbar('Gagal', '$e');
      // Handle exceptions or show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the GetStorage instance
    final storage = GetStorage();

    // Retrieve the stored employee_id
    var employeeId = storage.read('employee_id');
    var photo = storage.read('photo');

    return MaterialApp(
      title: "New Request Employee",
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
                                      title: const Text("Keluar"),
                                      content: const Text('Apakah anda yakin akan keluar ?'),
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
                flex: 8,
                child: Padding(
                  padding: EdgeInsets.only(left: 7.w, right: 7.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15.sp,),
                      //Profile Name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 5,
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
                              subtitle: Text('$employeeEmail',
                                style: TextStyle( fontSize: 15.sp, fontWeight: FontWeight.w300,),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.sp,),
                      Text("DATA KARYAWAN", 
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 20.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nomor",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtNomor,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nomor pengajuan'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nama",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtNamaLengkap,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama anda'
                                  ),
                                  readOnly: true,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 2,
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
                                TextFormField(
                                  controller: txtJabatan,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan departemen anda'
                                  ),
                                  readOnly: true,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
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
                                TextFormField(
                                  controller: txtDepartemen,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama anda'
                                  ),
                                  readOnly: true,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Posisi yang diusulkan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtPosisiUsul,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan posisi usulan'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Jumlah yang diusulkan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DropdownButtonFormField(
                                  value: '1',
                                  validator: (value) => value == null ? 'Mohon diisi' : null,
                                  items: const [
                                    DropdownMenuItem(
                                      value: '1',
                                      child: Text('1')
                                    ),
                                    DropdownMenuItem(
                                      value: '2',
                                      child: Text('2')
                                    ),
                                     DropdownMenuItem(
                                      value: '3',
                                      child: Text('3')
                                    ),
                                    DropdownMenuItem(
                                      value: '4',
                                      child: Text('4')
                                    ),
                                     DropdownMenuItem(
                                      value: '5',
                                      child: Text('5')
                                    ),
                                    DropdownMenuItem(
                                      value: '6',
                                      child: Text('6')
                                    ),
                                  ], 
                                  onChanged: (value){
                                    txtJumlahUsul.text = value.toString();
                                  }
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 50.sp,),
                      Text("ALASAN KARYAWAN", 
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 20.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Alasan Pengadaan Karyawan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DropdownButtonFormField<String>(
                                    value: selectedReason,
                                    hint: Text('Pilih alasan pengadaan karyawan'),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedReason = newValue!;
                                      });
                                    },
                                    items: reasons.map<DropdownMenuItem<String>>(
                                      (Map<String, String> reason) {
                                        return DropdownMenuItem<String>(
                                          value: reason['reason_request_id'],
                                          child: Text(reason['request_reason']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Jenis kelamin",
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
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Status karyawan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DropdownButtonFormField<String>(
                                    value: selectedHubunganKerja,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedHubunganKerja = newValue;
                                      });
                                    },
                                    items: HubunganKerjaList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> HubKerja) {
                                        return DropdownMenuItem<String>(
                                          value: HubKerja['hubungan_kerja_id']!,
                                          child: Text(HubKerja['hubungan_kerja_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                              ],
                            ),
                          ),
                          
                        ],
                      ),
                      SizedBox(height: 50.sp,),
                      Text("SYARAT UMUM", 
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 20.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
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
                                        print(selectedEmployeeStatus);
                                      });
                                    },
                                    items: employeeStatuses.map<DropdownMenuItem<String>>(
                                      (Map<String, String> status) {
                                        return DropdownMenuItem<String>(
                                          value: status['status_id'],
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
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Minimal usia",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtMinUsia,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan minimal usia'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Maksimal usia",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtMaxUsia,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan maksimal usia'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Tinggi badan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtTinggi,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan tinggi badan'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Berat badan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtBerat,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan berat badan'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                        ],
                      ),
                      SizedBox(height: 50.sp,),
                      Text("SYARAT KHUSUS", 
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 20.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Fakultas",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtFakultas,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama fakultas'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Jurusan",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtJurusan,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama jurusan'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("IPK",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtIpk,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan IPK'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Lama pengalaman",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtTahunPengalaman,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan lama pengalaman'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Peran",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtPeranPengalaman,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan peran pengalaman'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Keahilan lain",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtKeahlianLain,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan keahlian lain'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50.sp,),
                      Text("KUALIFIKASI", 
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 20.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 120.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nama",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DropdownButtonFormField<String>(
                                    value: txtKualifikasiNama,
                                    hint: Text('Pilih alasan pengadaan karyawan'),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        txtKualifikasiNama = newValue!;
                                        fetchKualifikasi(txtKualifikasiNama!);
                                      });
                                    },
                                    items: employeeNameListPIC.map<DropdownMenuItem<String>>(
                                      (Map<String, String> employeeNamePIC) {
                                        return DropdownMenuItem<String>(
                                          value: employeeNamePIC['id'],
                                          child: Text(employeeNamePIC['employee_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
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
                                if (showNoKualifikasi)
                                    Text(
                                      'Tidak ada jabatan',
                                      style: TextStyle(fontSize: 18),
                                    )
                                  else
                                    DropdownButtonFormField<String>(
                                      value: txtKualifikasiJabatan,
                                      hint: Text('Pilih Jabatan'),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          txtKualifikasiJabatan = newValue!;
                                        });
                                      },
                                      items: kualifikasi.map<DropdownMenuItem<String>>(
                                        (Map<String, String> kuali) {
                                          return DropdownMenuItem<String>(
                                            value: kuali['id']!,
                                            child: Text(kuali['position_name']!),
                                          );
                                        },
                                      ).toList(),
                                    ),
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
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
                                if (showNoKualifikasi)
                                    Text(
                                      'Tidak ada departemen',
                                      style: TextStyle(fontSize: 18),
                                    )
                                  else
                                    DropdownButtonFormField<String>(
                                      value: txtKualifikasiDepartemen,
                                      hint: Text('Pilih Departemen'),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          txtKualifikasiDepartemen = newValue!;
                                        });
                                      },
                                      items: kualifikasi.map<DropdownMenuItem<String>>(
                                        (Map<String, String> kuali) {
                                          return DropdownMenuItem<String>(
                                            value: kuali['id']!,
                                            child: Text(kuali['department_name']!),
                                          );
                                        },
                                      ).toList(),
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50.sp,),
                      Text("LAINNYA", 
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 20.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 120.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("PIC karyawan baru",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DropdownButtonFormField<String>(
                                    value: txtTanggungJawab,
                                    hint: Text('Pilih alasan pengadaan karyawan'),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        txtTanggungJawab = newValue!;
                                      });
                                    },
                                    items: employeeNameListPIC.map<DropdownMenuItem<String>>(
                                      (Map<String, String> employeeNamePIC) {
                                        return DropdownMenuItem<String>(
                                          value: employeeNamePIC['id'],
                                          child: Text(employeeNamePIC['employee_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Rincian tugas",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtRincianTugas,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan rincian tugas'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 160.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Tanggal mulai kerja",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DateTimePicker(
                                    firstDate: DateTime(2023),
                                    lastDate: DateTime(2100),
                                    initialDate: DateTime.now(),
                                    dateMask: 'd MMM yyyy',
                                    onChanged: (value) {
                                      setState(() {
                                        TanggalMulai = DateFormat('yyyy-MM-dd').parse(value);
                                      });
                                    },
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 150.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Catatan lainnya",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  maxLines: 3,
                                  controller: txtCatatanLain,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan catatan lainnya'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50.sp,),
                      ElevatedButton(
                        onPressed: () {
                          if (txtNomor.text == ''){
                            showDialog(
                              context: context, 
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text('Nomor pengajuan tidak dapat kosong'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {Get.back();},
                                      child: const Text('Oke'),
                                    ),
                                  ],
                                );
                              }
                            );
                          } else if (txtPosisiUsul.text == ''){
                            showDialog(
                              context: context, 
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text('Posisi yang diusulkan tidak dapat kosong'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {Get.back();},
                                      child: const Text('Oke'),
                                    ),
                                  ],
                                );
                              }
                            );
                          } else if (txtJumlahUsul.text.isEmpty){
                            showDialog(
                              context: context, 
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text('Harap memilih jumlah karyawan yang diusulkan'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {Get.back();},
                                      child: const Text('Oke'),
                                    ),
                                  ],
                                );
                              }
                            );
                          } else if (selectedReason.isEmpty){
                            showDialog(
                              context: context, 
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text('Harap memilih alasan penambahan karyawan'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {Get.back();},
                                      child: const Text('Oke'),
                                    ),
                                  ],
                                );
                              }
                            );
                          }else if (txtMinUsia.text.isEmpty || int.tryParse(txtMinUsia.text) == null || txtMinUsia.text.length != 2){
                            showDialog(
                              context: context, 
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text('Minimal usia tidak valid, harus berupa angka dan tidak dapat kosong'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {Get.back();},
                                      child: const Text('Oke'),
                                    ),
                                  ],
                                );
                              }
                            );
                          } else if (txtMaxUsia.text.isEmpty || int.tryParse(txtMaxUsia.text) == null || txtMaxUsia.text.length != 2){
                            showDialog(
                              context: context, 
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text('Maximal usia tidak valid, harus berupa angka dan tidak dapat kosong'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {Get.back();},
                                      child: const Text('Oke'),
                                    ),
                                  ],
                                );
                              }
                            );
                          } else if (txtTinggi.text.isEmpty || int.tryParse(txtTinggi.text) == null || txtTinggi.text.length != 3){
                            showDialog(
                              context: context, 
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text('Tinggi badan tidak valid, harus berupa angka dan tidak dapat kosong'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {Get.back();},
                                      child: const Text('Oke'),
                                    ),
                                  ],
                                );
                              }
                            );
                          } else if (txtBerat.text.isEmpty || int.tryParse(txtBerat.text) == null || txtBerat.text.length != 2 ){
                            showDialog(
                              context: context, 
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text('Berat badan tidak valid, harus berupa angka dan tidak dapat kosong'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {Get.back();},
                                      child: const Text('Oke'),
                                    ),
                                  ],
                                );
                              }
                            );
                          } else if (txtFakultas.text.isEmpty){
                            showDialog(
                              context: context, 
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text('Syarat fakultas tidak dapat kosong'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {Get.back();},
                                      child: const Text('Oke'),
                                    ),
                                  ],
                                );
                              }
                            );
                          } else if (txtJurusan.text.isEmpty){
                            showDialog(
                              context: context, 
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text('Syarat jurusan tidak dapat kosong'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {Get.back();},
                                      child: const Text('Oke'),
                                    ),
                                  ],
                                );
                              }
                            );
                          } else if (txtIpk.text.isEmpty){
                            showDialog(
                              context: context, 
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text('Syarat IPK tidak dapat kosong'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {Get.back();},
                                      child: const Text('Oke'),
                                    ),
                                  ],
                                );
                              }
                            );
                          } else if (txtTahunPengalaman.text.isEmpty || int.tryParse(txtTahunPengalaman.text) == null){
                            showDialog(
                              context: context, 
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text('Lama pengalaman tidak valid, harus berupa angka dan tidak dapat kosong'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {Get.back();},
                                      child: const Text('Oke'),
                                    ),
                                  ],
                                );
                              }
                            );
                          } else if (txtPeranPengalaman.text.isEmpty){
                            showDialog(
                              context: context, 
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text('Syarat peran tidak dapat kosong'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {Get.back();},
                                      child: const Text('Oke'),
                                    ),
                                  ],
                                );
                              }
                            );
                          } else if (txtKeahlianLain.text.isEmpty){
                            showDialog(
                              context: context, 
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text('Syarat keahlian lain tidak dapat kosong'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {Get.back();},
                                      child: const Text('Oke'),
                                    ),
                                  ],
                                );
                              }
                            );
                          } else if (txtRincianTugas.text.isEmpty){
                            showDialog(
                              context: context, 
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text('Syarat rincian tugas tidak dapat kosong'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {Get.back();},
                                      child: const Text('Oke'),
                                    ),
                                  ],
                                );
                              }
                            );
                          } else if (TanggalMulai == null){
                            showDialog(
                              context: context, 
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text('Tanggal mulai tidak dapat kosong'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {Get.back();},
                                      child: const Text('Oke'),
                                    ),
                                  ],
                                );
                              }
                            );
                          } else {
                            
                            insertRequest();
                          }
                         
                        }, 
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(0.sp, 45.sp),
                          foregroundColor: const Color(0xFFFFFFFF),
                          backgroundColor: const Color(0xff4ec3fc),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Kumpulkan')
                      ),
                      SizedBox(height: 50.sp,),
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