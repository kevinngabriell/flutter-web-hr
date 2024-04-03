// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/EmployeeList.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/UpdateData/UpdateDataTwo.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UpdateDataOne extends StatefulWidget {
  final String employeeId;
  const UpdateDataOne({super.key, required this.employeeId});

  @override
  State<UpdateDataOne> createState() => _UpdateDataOneState();
}

class _UpdateDataOneState extends State<UpdateDataOne> {
  bool isLoading = false;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();

  TextEditingController txtNIK = TextEditingController();
  TextEditingController txtNamaKaryawan = TextEditingController();
  TextEditingController txtTempatLahir = TextEditingController();
  TextEditingController txtNomorIdentitas = TextEditingController();
  TextEditingController txtNomorJamsostek = TextEditingController();
  DateTime? employeeDoB;
  String? selectedJenisKelamin;
  List<Map<String, String>> jenisKelaminList = [];
  String date = '';
  String? selectedKewarganegraan;
  List<Map<String, String>> kewarganegaraanList = [];

  String? selectedPerusahaan;
  List<Map<String, String>> perusahaanList = [];
  String? selectedDepartemen;
  List<Map<String, String>> departemenList = [];
  String? selectedPosition;
  List<Map<String, String>> positionList = [];

  String? selectedStatus;
  List<Map<String, String>> statusList = [];
  String? selectedReligion;
  List<Map<String, String>> religionList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchMasterData();
    fetchDetailData();
  }

  Future<void> fetchDetailData() async {
    try{
      isLoading = true;

      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployee.php?action=1&employee_id=${widget.employeeId}';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        Map<String, dynamic> data = (responseData['Data'] as List).first;

        setState(() {
          txtNIK.text = data['employee_id'] ?? '-';
          txtNamaKaryawan.text = data['employee_name'] ?? '-';
          txtTempatLahir.text = data['employee_pob'] ?? '-';
          txtNomorIdentitas.text = data['employee_identity'] ?? '-';
          txtNomorJamsostek.text = data['employee_jamsostek'] ?? '-';
          date = data['employee_dob'];
        });

      } else {
        print('Failed to load data: ${response.statusCode}');
      }

    } catch (e){
      print('Error at fetching detail one data : $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchData() async {
    String employeeId = storage.read('employee_id').toString();

    try {
      isLoading = true;
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
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchMasterData() async {
    try{
      isLoading = true;
      String constUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2';
      String genderUrl = '$constUrl/masterdata/getgender.php';

      final genderRespond = await http.get(Uri.parse(genderUrl));

      if(genderRespond.statusCode == 200){
        final genderData = json.decode(genderRespond.body);

        if(genderData['StatusCode'] == 200){
          final genders = (genderData['Data'] as List).map((gender) => Map<String, String>.from({
            'gender_id' : gender['gender_id'],
            'gender_name' : gender['gender_name']
          })).toList();

          setState(() {
            jenisKelaminList = genders;
            if(jenisKelaminList.isNotEmpty){
              selectedJenisKelamin = jenisKelaminList[0]['gender_id'];
            }
          });
        }
      } else {
        print('Error : ${genderRespond.body}');
      }

      String nationalityUrl = '$constUrl/masterdata/getnationality.php';
      final nationalityRespond = await http.get(Uri.parse(nationalityUrl));

      if(nationalityRespond.statusCode == 200){
        final nationalityData = json.decode(nationalityRespond.body);

        if(nationalityData['StatusCode'] == 200){
          final nationalits = (nationalityData['Data'] as List).map((nationality) => Map<String, String>.from({
            'num_code' : nationality['num_code'],
            'nationality' : nationality['nationality']
          })).toList();

          setState(() {
            kewarganegaraanList = nationalits;
            if(kewarganegaraanList.isNotEmpty){
              selectedKewarganegraan = kewarganegaraanList[0]['num_code'];
            }
          });
        }
      } else {
        print('Error : ${genderRespond.body}');
      }

      String companyUrl = '$constUrl/masterdata/getcompanydata.php';
      final companyRespond = await http.get(Uri.parse(companyUrl));

      if(companyRespond.statusCode == 200){
        final companyData = json.decode(companyRespond.body);

        if(companyData['StatusCode'] == 200){
          final companies = (companyData['Data'] as List).map((company) => Map<String, String>.from({
            'company_id' : company['company_id'],
            'company_name' : company['company_name']
          })).toList();

          setState(() {
            perusahaanList = companies;
            if(perusahaanList.isNotEmpty){
              selectedPerusahaan = perusahaanList[0]['company_id'];
              fetchDepartments(selectedPerusahaan!);
            }
          });
        }
      } else {
        print('Error : ${companyRespond.body}');
      }

      String statusUrl = '$constUrl/masterdata/getemployeestatus.php';
      final statusRespond = await http.get(Uri.parse(statusUrl));

      if(statusRespond.statusCode == 200){
        final statusData = json.decode(statusRespond.body);

        if(statusData['StatusCode'] == 200){
          final statuses = (statusData['Data'] as List).map((status) => Map<String, String>.from({
            'status_id' : status['status_id'],
            'status_name' : status['status_name']
          })).toList();

          setState(() {
            statusList = statuses;
            if(statusList.isNotEmpty){
              selectedStatus = statusList[0]['status_id'];
            }
          });
        }
      } else {
        print('Error : ${statusRespond.body}');
      }

      String agamaUrl = '$constUrl/masterdata/getreligion.php';
      final agamaRespond = await http.get(Uri.parse(agamaUrl));

      if(agamaRespond.statusCode == 200){
        final agamaData = json.decode(agamaRespond.body);

        if(agamaData['StatusCode'] == 200){
          final agamaes = (agamaData['Data'] as List).map((agama) => Map<String, String>.from({
            'religion_id' : agama['religion_id'],
            'religion_name' : agama['religion_name']
          })).toList();

          setState(() {
            religionList = agamaes;
            if(religionList.isNotEmpty){
              selectedReligion = religionList[0]['religion_id'];
            }
          });
        }
      } else {
        print('Error : ${agamaRespond.body}');
      }

    } catch (e){
      isLoading = false;
      showDialog(
        context: context, 
        builder: (_){
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Server error, silahkan periksa melalui tim IT'),
            actions: [
              TextButton(
                onPressed: (){
                  Get.back();
                }, 
                child: const Text('Kembali')
              )
            ],
          );
        }
      );
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchDepartments(String companyId) async {
    try{
      isLoading = true;
      final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getdepartment.php?company_id=$selectedPerusahaan'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['StatusCode'] == 200) {
          setState(() {
            departemenList = (data['Data'] as List)
                .map((department) => Map<String, String>.from(department))
                .toList();
            if (departemenList.isNotEmpty) {
              selectedDepartemen = departemenList[0]['department_id']!;
              fetchPositions(selectedPerusahaan!, selectedDepartemen!);
            }
          });
        } else {
          // Handle API error
          print('Failed to fetch data');
        }
      } else if (response.statusCode == 404) {

      } else {
        // Handle other HTTP errors
        print('Failed to fetch data');
      }
    } catch (e){
      isLoading = false;
      showDialog(
        context: context, 
        builder: (_){
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Server error, silahkan periksa melalui tim IT'),
            actions: [
              TextButton(
                onPressed: (){
                  Get.back();
                }, 
                child: const Text('Kembali')
              )
            ],
          );
        }
      );
    } finally{
      isLoading = false;
    }
  }

  Future<void> fetchPositions(String companyId, String departmentId) async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getposition.php?company_id=$selectedPerusahaan&department_id=$selectedDepartemen'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        setState(() {
          positionList = (data['Data'] as List)
              .map((position) => Map<String, String>.from(position))
              .toList();
          if (positionList.isNotEmpty) {
            selectedPosition = positionList[0]['position_id']!;
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
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/updateemployee/updateone.php';

      // Make the API call with a POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
            'employee_id': txtNIK.text,
            'employee_name': txtNamaKaryawan.text,
            'department_id': selectedDepartemen,
            'position_id': selectedPosition,
            'company_id': selectedPerusahaan,
            'gender': selectedJenisKelamin,
            'employee_pob': txtTempatLahir.text,
            'employee_dob': employeeDoB.toString(),
            'employee_nationality': selectedKewarganegraan,
            'employee_identity': txtNomorIdentitas.text, 
            'employee_jamsostek': txtNomorJamsostek.text,
            'employee_status': selectedStatus,
            'employee_religion': selectedReligion,
            'id' : widget.employeeId
        },
      );

      if (response.statusCode == 200) {
        Get.to(UpdateDataTwo(employeeId: widget.employeeId,));
        // Add any additional logic or UI updates after successful insertion
      } else {
        isLoading = false;
        showDialog(
          context: context, 
          builder: (_){
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Error dengan response ${response.body}'),
              actions: [
                TextButton(
                  onPressed: (){
                    Get.to(const EmployeeListPage());
                  }, 
                  child: const Text('Kembali')
                )
              ],
            );
          }
        );
      }
    } catch (e) {
      showDialog(
          context: context, 
          builder: (_){
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Error dengan response $e'),
              actions: [
                TextButton(
                  onPressed: (){
                    Get.to(const EmployeeListPage());
                  }, 
                  child: const Text('Kembali')
                )
              ],
            );
          }
        );
      // Handle exceptions or show an error message to the user
    } finally{
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();

    var employeeId = storage.read('employee_id');
    var photo = storage.read('photo');
    var positionId = storage.read('position_id');

    return MaterialApp(
      title: "Update Karyawan - Informasi Pribadi",
      home: Scaffold(
        body: isLoading ? const Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
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
                        Center(child: Text('Update Data ${txtNamaKaryawan.text}', style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w600,))),
                        SizedBox(height: 7.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ID Karyawan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                  SizedBox(height: 2.sp,),
                                  TextFormField(
                                    controller: txtNIK,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan ID karyawan'
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nama Lengkap',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                  SizedBox(height: 2.sp,),
                                  TextFormField(
                                    controller: txtNamaKaryawan,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan nama lengkap karyawan'
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Jenis Kelamin',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                  SizedBox(height: 2.sp,),
                                  DropdownButtonFormField<String>(
                                      value: selectedJenisKelamin,
                                      hint: const Text('Pilih jenis kelamin'),
                                      onChanged: (String? newValue) {
                                        selectedJenisKelamin = newValue!;
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      ),
                                      items: jenisKelaminList.map<DropdownMenuItem<String>>(
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
                            )
                          ],
                        ),
                        SizedBox(height: 7.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tempat Lahir',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                  SizedBox(height: 2.sp,),
                                  TextFormField(
                                    controller: txtTempatLahir,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan tempat lahir karyawan'
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tanggal Lahir',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                  SizedBox(height: 2.sp,),
                                  DateTimePicker(
                                    initialValue: date,
                                    type: DateTimePickerType.date,
                                    dateMask: 'd MMMM yyyy', // Format date as "30 April 2002"
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    dateHintText: 'Pilih tanggal lahir',
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Pilih tanggal lahir'
                                    ),
                                    onChanged: (val) {
                                      employeeDoB = DateFormat('yyyy-MM-dd').parse(val);
                                    },
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Kewarganegaraan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                  SizedBox(height: 2.sp,),
                                  DropdownButtonFormField<String>(
                                    value: selectedKewarganegraan,
                                    hint: const Text('Pilih kewarganegaraan'),
                                    onChanged: (String? newValue) {
                                      selectedKewarganegraan = newValue!;
                                    },
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      ),
                                    items: kewarganegaraanList.map<DropdownMenuItem<String>>(
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
                            )
                          ],
                        ),
                        SizedBox(height: 7.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Perusahaan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                  SizedBox(height: 2.sp,),
                                  DropdownButtonFormField<String>(
                                    value: selectedPerusahaan,
                                    hint: const Text('Pilih perusahaan'),
                                    onChanged: (String? newValue) {
                                      selectedPerusahaan = newValue!;
                                      fetchDepartments(selectedPerusahaan!);
                                    },
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      ),
                                    items: perusahaanList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> company) {
                                        return DropdownMenuItem<String>(
                                          value: company['company_id']!,
                                          child: Text(company['company_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Departemen',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                  SizedBox(height: 2.sp,),
                                  DropdownButtonFormField<String>(
                                      value: selectedDepartemen,
                                      hint: const Text('Pilih Departemen'),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedDepartemen = newValue!;
                                          fetchPositions(selectedPerusahaan!, selectedDepartemen!);
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      ),
                                      items: departemenList.map<DropdownMenuItem<String>>(
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
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Jabatan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                  SizedBox(height: 2.sp,),
                                  DropdownButtonFormField<String>(
                                    value: selectedPosition,
                                    hint: const Text('Pilih Jabatan'),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedPosition = newValue!;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      ),
                                    items: positionList.map<DropdownMenuItem<String>>(
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
                            )
                          ],
                        ),
                        SizedBox(height: 7.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nomor Identitas',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                  SizedBox(height: 2.sp,),
                                  TextFormField(
                                    controller: txtNomorIdentitas,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan nomor identitas'
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nomor Jamsostek',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                  SizedBox(height: 2.sp,),
                                  TextFormField(
                                    controller: txtNomorJamsostek,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan nomor jamsostek'
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 7.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Status',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                  SizedBox(height: 2.sp,),
                                  DropdownButtonFormField<String>(
                                    value: selectedStatus,
                                    hint: const Text('Pilih status karyawan'),
                                    onChanged: (String? newValue) {
                                      selectedStatus = newValue!;
                                    },
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      ),
                                    items: statusList.map<DropdownMenuItem<String>>(
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
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Agama',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                  SizedBox(height: 2.sp,),
                                  DropdownButtonFormField<String>(
                                    value: selectedReligion,
                                    hint: const Text('Pilih agama'),
                                    onChanged: (String? newValue) {
                                      selectedReligion = newValue!;
                                    },
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      ),
                                    items: religionList.map<DropdownMenuItem<String>>(
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
                        SizedBox(height: 10.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                  onPressed: (){
                                    Get.back();
                                  }, 
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    alignment: Alignment.center,
                                    minimumSize: Size(60.w, 55.h),
                                    foregroundColor: const Color(0xFFFFFFFF),
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('Kembali')
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: (){
                                    insertEmployee();
                                  }, 
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    alignment: Alignment.center,
                                    minimumSize: Size(60.w, 55.h),
                                    foregroundColor: const Color(0xFFFFFFFF),
                                    backgroundColor: const Color(0xff4ec3fc),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('Update & Berikutnya')
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10.sp,),
                      ]
                  )
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}