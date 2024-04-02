// ignore_for_file: avoid_print, file_names, prefer_interpolation_to_compose_strings, non_constant_identifier_names, unnecessary_string_interpolations

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; 
import 'AddNewEmployeeEight.dart';

class AddNewEmployeeSeven extends StatefulWidget {
  const AddNewEmployeeSeven({super.key});

  @override
  State<AddNewEmployeeSeven> createState() => _AddNewEmployeeSevenState();
}

class _AddNewEmployeeSevenState extends State<AddNewEmployeeSeven> {
  bool isYesBolehMenghubungi = false;
  bool isNoBolehMenghubungi = false;
  int? bolehMenghubungi;
  //1 is yes, 0 is no

  bool isYesPrestasi = false;
  bool isNoPrestasi = false;
  int? anyPrestasi;

  bool isYesOrganization = false;
  bool isNoOrganization = false;
  int? anyOrganization;

  bool isYesAnyDay = false;
  bool isNoAnyDay = false;
  int? anyDay;

  bool isYesSim = false;
  bool isNoSim = false;
  int? anySim;

  bool isYesFired = false;
  bool isNoFired = false;
  int? anyFired;

  bool isYesJailed = false;
  bool isNoJailed = false;
  int? anyJailed;

  bool isYesCacat = false;
  bool isNoCacat = false;
  int? anyCacat;

  bool isYesSmoke = false;
  bool isNoSmoke = false;
  int? anySmoke;

  TextEditingController txtSumberLowongan = TextEditingController();
  TextEditingController txtPosisiLamar = TextEditingController();
  TextEditingController txtPosisiAlternatif = TextEditingController();
  TextEditingController txtGaji = TextEditingController();
  TextEditingController txtPrestasi = TextEditingController();
  TextEditingController txtOrganisasi = TextEditingController();
  TextEditingController txtFired = TextEditingController();
  TextEditingController txtJailed = TextEditingController();
  TextEditingController txtDisable = TextEditingController();
  TextEditingController txtHari = TextEditingController();
  TextEditingController txtHobby = TextEditingController();

  DateTime? DateTimeSIMA;
  DateTime? DateTimeSIMC;

  TextEditingController txtEmergencyName1 = TextEditingController();
  TextEditingController txtEmergencyHubungan1 = TextEditingController();
  TextEditingController txtEmergencyNomor1 = TextEditingController();
  TextEditingController txtEmergencyAlamat1 = TextEditingController();
  TextEditingController txtEmergencyName2 = TextEditingController();
  TextEditingController txtEmergencyHubungan2 = TextEditingController();
  TextEditingController txtEmergencyNomor2 = TextEditingController();
  TextEditingController txtEmergencyAlamat2 = TextEditingController();


  String? selectedJobSource;
  List<Map<String, String>> jobSourceList = [];

  String? selectedHubunganKerja;
  List<Map<String, String>> HubunganKerjaList = [];

  String id = '';

  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
String trimmedCompanyAddress = '';
  List<dynamic> profileData = [];

  @override
  void initState() {
    super.initState();
    fetchJobSourceList();
    fetchHubunganKerja();
    fetchLastID();
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

  Future<void> fetchJobSourceList() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getjobsource.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        final jobSources = (data['Data'] as List)
            .map((jobSource) => Map<String, String>.from({
                  'job_source_id': jobSource['job_source_id'],
                  'job_source_name': jobSource['job_source_name'],
                }))
            .toList();

        setState(() {
          jobSourceList = jobSources;
          if (jobSourceList.isNotEmpty) {
            selectedJobSource = jobSourceList[0]['job_source_id'];
          }
        });
      } else {
        // Handle API error
        print('Failed to fetch job source list');
      }
    } else {
      // Handle HTTP error
      print('Failed to fetch data');
    }
  }

  Future<void> fetchLastID() async {
  const apiUrl =
      'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getlastidforinput.php';

  try {
    // Making GET request
    final response = await http.get(Uri.parse(apiUrl));

    // Checking if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parsing the response body
      final Map<String, dynamic> responseBody = json.decode(response.body);

      // Extracting the 'Data' array from the response
      final List<dynamic> data = responseBody['Data'];

      // Accessing the first object in the 'Data' array
      final Map<String, dynamic> firstDataObject = data.isNotEmpty ? data[0] : {};

      // Extracting the 'id' value from the first object
      id = firstDataObject['id'];

      // Now you can use the 'id' variable as needed
      print('Last ID: $id');
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

  Future<void> insertEmployee() async {
    try{
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/insertemployee/insertseven.php';

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "id": id,
          "job_source_answer" : selectedJobSource,
          "job_source_answer_exp" : txtSumberLowongan.text,
          "contact_last_comp" : bolehMenghubungi.toString(),
          "position_applied" : txtPosisiLamar.text,
          "position_alternate" : txtPosisiAlternatif.text,
          "expected_salary" : txtGaji.text,
          "hubungan_kerja_answer" : selectedHubunganKerja,
          "is_ever_award" : anyPrestasi.toString(),
          "is_ever_award_exp" : txtPrestasi.text,
          "hobby_answer" : txtHobby.text,
          "is_ever_org" : anyOrganization.toString(),
          "is_ever_org_exp" : txtOrganisasi.text,
          "is_day_unv" : anyDay.toString(),
          "is_day_unv_exp" : txtHari.text,
          "is_any_sim" : anySim.toString(),
          "sim_a_end" : DateTimeSIMA.toString(),
          "sim_c_end" : DateTimeSIMC.toString(),
          "is_fired" : anyFired.toString(),
          "is_fired_exp" : txtFired.text,
          "is_jailed" : anyJailed.toString(),
          "is_jailed_exp" : txtJailed.text,
          "is_sick" : anyCacat.toString(),
          "is_sick_exp" : txtDisable.text,
          "is_smoke" : anySmoke.toString(),
          "emergency_name" : txtEmergencyName1.text,
          "emergency_hubungan" : txtEmergencyHubungan1.text,
          "emergency_phone" : txtEmergencyNomor1.text,
          "emergency_address" : txtEmergencyAlamat1.text,
          "emergency_name_2" : txtEmergencyName2.text,
          "emergency_hubungan_2" : txtEmergencyHubungan2.text,
          "emergency_phone_2" : txtEmergencyNomor2.text,
          "emergency_address_2" : txtEmergencyAlamat2.text
        }
      );

      if (response.statusCode == 200) {
        print('Employee inserted successfully');
        Get.to(const AddNewEmployeeEight());
        // Add any additional logic or UI updates after successful insertion
      } else {
        Get.snackbar('Gagal', '${response.body}');
        // Handle the error or show an error message to the user
      }

    } catch (e){
      Get.snackbar('Gagal', '$e');
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
                      LaporanNonActive(positionId: positionId),
                      SizedBox(height: 10.sp,),
                      const PengaturanMenu(),
                      SizedBox(height: 5.sp,),
                      const PengaturanNonActive(),
                      SizedBox(height: 5.sp,),
                      const StrukturNonActive(),
                      SizedBox(height: 5.sp,),
                      const Logout(),
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
                      //statistik card
                      Text("Dari mana anda mengetahui tentang lowongan ini ?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 7.h,),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 240.w) / 2,
                            child: DropdownButtonFormField<String>(
                                    value: selectedJobSource,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedJobSource = newValue;
                                      });
                                    },
                                    items: jobSourceList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> jobSource) {
                                        return DropdownMenuItem<String>(
                                          value: jobSource['job_source_id']!,
                                          child: Text(jobSource['job_source_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 240.w) / 2,
                            child: TextFormField(
                              controller: txtSumberLowongan,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                fillColor: Color.fromRGBO(235, 235, 235, 1),
                                hintText: 'Masukkan sumber lowongan'
                              ),
                              readOnly: false,
                            )
                          )
                        ],
                      ),
                      SizedBox(height: 30.h,),
                      Text("Bolehkah kami menghubungi perusahaan sebelumnya tempat Anda bekerja?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 7.h,),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 300.w) / 2 ,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isYesBolehMenghubungi, 
                                  onChanged: (value){
                                    setState(() {
                                      isYesBolehMenghubungi = value!;
                                      if (value == true){
                                        isNoBolehMenghubungi = false;
                                      }
                                    });
                                  }
                                ),
                                Text("Yes",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 250.w) / 2 ,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isNoBolehMenghubungi, 
                                  onChanged: (value){
                                    setState(() {
                                      isNoBolehMenghubungi = value!;
                                      if (value == true){
                                        isYesBolehMenghubungi = false;
                                      }
                                    });
                                  }
                                ),
                                Text("No",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 30.h,),
                      Text("Posisi apa yang anda lamar?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 7.h,),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 180.w) / 2,
                        child: TextFormField(
                          controller: txtPosisiLamar,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            fillColor: Color.fromRGBO(235, 235, 235, 1),
                            hintText: 'Masukkan posisi yang anda lamar'
                          ),
                          readOnly: false,
                        ),
                      ),
                      SizedBox(height: 30.h,),
                      Text("Apa posisi alternatif yang anda inginkan?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 7.h,),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 180.w) / 2,
                        child: TextFormField(
                          controller: txtPosisiAlternatif,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            fillColor: Color.fromRGBO(235, 235, 235, 1),
                            hintText: 'Masukkan posisi alternatif anda'
                          ),
                          readOnly: false,
                        ),
                      ),
                      SizedBox(height: 30.h,),
                      Text("Berapa gaji yang anda harapkan?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 7.h,),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 180.w) / 2,
                        child: TextFormField(
                          controller: txtGaji,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            fillColor: Color.fromRGBO(235, 235, 235, 1),
                            hintText: 'Masukkan gaji yang anda inginkan'
                          ),
                          readOnly: false,
                        ),
                      ),
                      SizedBox(height: 30.h,),
                      Text("Apa hubungan kerja yang anda inginkan?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 7.h,),
                      SizedBox(
                            width: (MediaQuery.of(context).size.width - 240.w) / 2,
                            child: DropdownButtonFormField<String>(
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
                          ),
                      SizedBox(height: 30.h,),
                       //is prestasi 
                      Text("Apakah anda pernah mendapatkan prestasi?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 7.h,),
                      //is prestasi 
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 300.w) / 2 ,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isYesPrestasi, 
                                  onChanged: (value){
                                    setState(() {
                                      isYesPrestasi = value!;
                                      if (value == true){
                                        isNoPrestasi =  false;
                                      }
                                    });
                                  }
                                ),
                                Text("Yes",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 280.w) / 2 ,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isNoPrestasi, 
                                  onChanged: (value){
                                    setState(() {
                                      isNoPrestasi = value!;
                                      if (value == true){
                                        isYesPrestasi= false;
                                      }
                                    });
                                  }
                                ),
                                Text("No",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                              ],
                            ),
                          ),
                          if(isYesPrestasi == true)
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 160.w) / 3,
                              child: TextFormField(
                                      controller: txtPrestasi,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                                        hintText: 'Masukkan prestasi anda'
                                      ),
                                      readOnly: false,
                                    ),
                            )
                        ],
                      ),
                      SizedBox(height: 30.h,),
                       //is prestasi 
                      Text("Apa hobby, olahraga atau minat anda?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 7.h,),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 180.w) / 2,
                        child: TextFormField(
                          controller: txtHobby,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            fillColor: Color.fromRGBO(235, 235, 235, 1),
                            hintText: 'Masukkan hobby anda'
                          ),
                          readOnly: false,
                        ),
                      ),
                      SizedBox(height: 30.h,),
                       //is prestasi 
                      Text("Apakah anda pernah menjadi bagian dari sebuah organisasi?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 7.h,),
                      //is prestasi 
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 300.w) / 2 ,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isYesOrganization, 
                                  onChanged: (value){
                                    setState(() {
                                      isYesOrganization = value!;
                                      if (value == true){
                                        isNoOrganization =  false;
                                      }
                                    });
                                  }
                                ),
                                Text("Yes",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 280.w) / 2 ,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isNoOrganization, 
                                  onChanged: (value){
                                    setState(() {
                                      isNoOrganization = value!;
                                      if (value == true){
                                        isYesOrganization= false;
                                      }
                                    });
                                  }
                                ),
                                Text("No",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                              ],
                            ),
                          ),
                          if(isYesOrganization == true)
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 160.w) / 3,
                              child: TextFormField(
                                controller: txtOrganisasi,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                                        hintText: 'Masukkan organisasi yang anda ikuti'
                                      ),
                                      readOnly: false,
                                    ),
                            )
                        ],
                      ),
                      SizedBox(height: 30.h,),
                       //is prestasi 
                      Text("Apakah ada hari tertentu anda tidak dapat bekerja?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 7.h,),
                      //is prestasi 
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 300.w) / 2 ,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isYesAnyDay, 
                                  onChanged: (value){
                                    setState(() {
                                      isYesAnyDay = value!;
                                      if (value == true){
                                        isNoAnyDay=  false;
                                      }
                                    });
                                  }
                                ),
                                Text("Yes",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 280.w) / 2 ,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isNoAnyDay, 
                                  onChanged: (value){
                                    setState(() {
                                      isNoAnyDay= value!;
                                      if (value == true){
                                        isYesAnyDay= false;
                                      }
                                    });
                                  }
                                ),
                                Text("No",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                              ],
                            ),
                          ),
                          if(isYesAnyDay == true)
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 160.w) / 3,
                              child: TextFormField(
                                controller: txtHari,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                                        hintText: 'Masukkan hari yang anda berhalangan'
                                      ),
                                      readOnly: false,
                                    ),
                            )
                        ],
                      ),
                      SizedBox(height: 30.h,),
                      //is SIM 
                      Text("Apakah anda memiliki SIM?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 7.h,),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 300.w) / 2 ,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isYesSim, 
                                  onChanged: (value){
                                    setState(() {
                                      isYesSim= value!;
                                      if (value == true){
                                        isNoSim =  false;
                                      }
                                    });
                                  }
                                ),
                                Text("Yes",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 280.w) / 2 ,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isNoSim, 
                                  onChanged: (value){
                                    setState(() {
                                      isNoSim = value!;
                                      if (value == true){
                                        isYesSim = false;
                                      }
                                    });
                                  }
                                ),
                                Text("No",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if(isYesSim == true)
                        SizedBox(height: 30.h,),
                      if(isYesSim == true)
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 240.w) / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Masa akhir SIM A",
                                    style: TextStyle(
                                      fontSize: 4.sp,
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
                                        DateTimeSIMA = DateFormat('yyyy-MM-dd').parse(value);
                                        //txtTanggal = value;
                                        //selectedDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(txtTanggal);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 7.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 240.w) / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Masa akhir SIM C",
                                    style: TextStyle(
                                      fontSize: 4.sp,
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
                                        DateTimeSIMC = DateFormat('yyyy-MM-dd').parse(value);
                                        //txtTanggal = value;
                                        //selectedDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(txtTanggal);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      SizedBox(height: 30.h,),
                       //is prestasi 
                      Text("Apakah anda diberhentikan dari perusahaan sebelumnya?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 7.h,),
                      //is prestasi 
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 300.w) / 2 ,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isYesFired, 
                                  onChanged: (value){
                                    setState(() {
                                      isYesFired= value!;
                                      if (value == true){
                                        isNoFired = false;
                                      }
                                    });
                                  }
                                ),
                                Text("Yes",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 280.w) / 2 ,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isNoFired, 
                                  onChanged: (value){
                                    setState(() {
                                      isNoFired = value!;
                                      if (value == true){
                                        isYesFired = false;
                                      }
                                    });
                                  }
                                ),
                                Text("No",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                              ],
                            ),
                          ),
                          if(isYesFired == true)
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 160.w) / 3,
                              child: TextFormField(
                                controller: txtFired,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                                        hintText: 'Masukkan alasan anda diberhentikan'
                                      ),
                                      readOnly: false,
                                    ),
                            )
                        ],
                      ),
                      SizedBox(height: 30.h,),
                      Text("Apakah anda pernah dihukum?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 7.h,),
                      //is prestasi 
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 300.w) / 2 ,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isYesJailed, 
                                  onChanged: (value){
                                    setState(() {
                                      isYesJailed = value!;
                                      if (value == true){
                                        isNoJailed = false;
                                      }
                                    });
                                  }
                                ),
                                Text("Yes",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 280.w) / 2 ,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isNoJailed, 
                                  onChanged: (value){
                                    setState(() {
                                      isNoJailed = value!;
                                      if (value == true){
                                        isYesJailed= false;
                                      }
                                    });
                                  }
                                ),
                                Text("No",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                              ],
                            ),
                          ),
                          if(isYesJailed == true)
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 160.w) / 3,
                              child: TextFormField(
                                controller: txtJailed,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                                        hintText: 'Jelaskan'
                                      ),
                                      readOnly: false,
                                    ),
                            )
                        ],
                      ),
                      SizedBox(height: 30.h,),
                      Text("Apakah anda mempunyai penyakit/cacat yang dapat menganggu aktivitas?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 7.h,),
                      //is prestasi 
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 300.w) / 2 ,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isYesCacat, 
                                  onChanged: (value){
                                    setState(() {
                                      isYesCacat = value!;
                                      if (value == true){
                                        isNoCacat = false;
                                      }
                                    });
                                  }
                                ),
                                Text("Yes",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 280.w) / 2 ,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isNoCacat, 
                                  onChanged: (value){
                                    setState(() {
                                      isNoCacat= value!;
                                      if (value == true){
                                        isYesCacat= false;
                                      }
                                    });
                                  }
                                ),
                                Text("No",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                              ],
                            ),
                          ),
                          if(isYesCacat == true)
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 160.w) / 3,
                              child: TextFormField(
                                controller: txtDisable,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                                        hintText: 'Jelaskan'
                                      ),
                                      readOnly: false,
                                    ),
                            )
                        ],
                      ),
                       SizedBox(height: 30.h,),
                       //is prestasi 
                      Text("Apakah anda merokok?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 7.h,),
                      //is prestasi 
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 300.w) / 2 ,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isYesSmoke, 
                                  onChanged: (value){
                                    setState(() {
                                      isYesSmoke = value!;
                                      if (value == true){
                                        isNoSmoke =  false;
                                      }
                                    });
                                  }
                                ),
                                Text("Yes",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 280.w) / 2 ,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isNoSmoke, 
                                  onChanged: (value){
                                    setState(() {
                                      isNoSmoke = value!;
                                      if (value == true){
                                        isYesSmoke = false;
                                      }
                                    });
                                  }
                                ),
                                Text("No",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h,),
                      const Divider(),
                      SizedBox(height: 10.h,),
                      Text("Kontak Darurat",
                        style: TextStyle(
                          fontSize: 6.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 7.h,),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 170.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nama Lengkap",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtEmergencyName1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama lengkap'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 170.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Hubungan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtEmergencyHubungan1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan hubungan dengan anda'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 170.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nomor Telepon",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtEmergencyNomor1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan kontak darurat'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h,),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 160.w) ,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Alamat",
                              style: TextStyle(
                                fontSize: 4.sp,
                                fontWeight: FontWeight.w600,
                              )
                            ),
                            SizedBox(height: 7.h,),
                            TextFormField(
                              maxLines: 4,
                              controller: txtEmergencyAlamat1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                fillColor: Color.fromRGBO(235, 235, 235, 1),
                                hintText: 'Masukkan alamat lengkap'
                              ),
                              readOnly: false,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 30.h,),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 170.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nama Lengkap",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtEmergencyName2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama lengkap'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 170.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Hubungan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtEmergencyHubungan2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan hubungan dengan anda'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 170.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nomor Telepon",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtEmergencyNomor2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan kontak darurat'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h,),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 160.w) ,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Alamat",
                              style: TextStyle(
                                fontSize: 4.sp,
                                fontWeight: FontWeight.w600,
                              )
                            ),
                            SizedBox(height: 7.h,),
                            TextFormField(
                              maxLines: 4,
                              controller: txtEmergencyAlamat2,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                fillColor: Color.fromRGBO(235, 235, 235, 1),
                                hintText: 'Masukkan alamat lengkap'
                              ),
                              readOnly: false,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 40.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                        onPressed: () {
                          if(isYesBolehMenghubungi == true){
                            bolehMenghubungi = 1;
                          } else if (isNoBolehMenghubungi == true){
                            bolehMenghubungi = 0;
                          } 
                          
                          if (isYesPrestasi == true) {
                            anyPrestasi = 1;
                          } else if (isNoPrestasi == true){
                            anyPrestasi = 0;
                          }
                          
                          if (isYesOrganization == true){
                            anyOrganization = 1;
                          } else if (isNoOrganization == true){
                            anyOrganization = 0;
                          } 
                          
                          if (isYesAnyDay == true){
                            anyDay = 1;
                          } else if (isNoAnyDay == true){
                            anyDay = 0;
                          } 
                          
                          if (isYesSim == true){
                            anySim = 1;
                          } else if (isNoSim == true){
                            anySim = 0;
                          } 
                          
                          if (isYesFired == true){
                            anyFired = 1;
                          } else if (isNoFired == true){
                            anyFired = 0;
                          }  
                          
                          if (isYesJailed == true){
                            anyJailed = 1;
                          } else if (isNoJailed == true){
                            anyJailed = 0;
                          }  
                          
                          if (isYesCacat == true){
                            anyCacat = 1;
                          } else if (isNoCacat == true){
                            anyCacat = 0;
                          }  
                          
                          if (isYesSmoke == true){
                            anySmoke = 1;
                          } else if (isNoSmoke == true){
                            anySmoke = 0;
                          }

                          insertEmployee();
                          
                        }, 
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(50.w, 55.h),
                          foregroundColor: const Color(0xFFFFFFFF),
                          backgroundColor: const Color(0xff4ec3fc),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Berikutnya')
                      ),
                        ],
                      ),
                      SizedBox(height: 40.sp,),
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