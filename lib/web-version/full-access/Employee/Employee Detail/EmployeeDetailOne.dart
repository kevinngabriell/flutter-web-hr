// ignore_for_file: file_names, non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Employee%20Detail/EmployeeDetailTwo.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class EmployeeDetailOne extends StatefulWidget {
  final String employeeID;
  const EmployeeDetailOne(this.employeeID, {super.key});

  @override
  State<EmployeeDetailOne> createState() => _EmployeeDetailOneState();
}

class _EmployeeDetailOneState extends State<EmployeeDetailOne> {
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  bool isLoading = false;

  TextEditingController txtNIKKaryawan = TextEditingController();
  TextEditingController txtNamaKayrawan = TextEditingController();
  TextEditingController txtTempatLahir = TextEditingController();
  TextEditingController txtNomorIdentitas = TextEditingController();
  TextEditingController txtNomorJamsostek = TextEditingController();

  DateTime? employeeDob;

  String selectedGender = '';
  List<Map<String, String>> genders = [];
  List<Map<String, String>> nationalities = [];
  String selectedNationality = '';
  List<Map<String, String>> employeeStatuses = [];
  String selectedEmployeeStatus = '';
  List<Map<String, String>> religions = [];
  String selectedReligion = '';
  List<Map<String, String>> positions = [];
  String selectedPosition = '';
  List<Map<String, String>> companies = [];
  String selectedCompany = '';
  List<Map<String, String>> departments = [];
  String selectedDepartment = '';
  bool showNoDepartments = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDetailData();
    fetchGenders();
    fetchNationalities();
    fetchEmployeeStatuses();
    fetchReligions();
    fetchCompanies();
  }

  Future<void> fetchPositions(String companyId, String departmentId) async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getposition.php?company_id=$selectedCompany&department_id=$selectedDepartment'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        setState(() {
          positions = (data['Data'] as List).map((position) => Map<String, String>.from(position)).toList();
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

  Future<void> fetchCompanies() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getcompanydata.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        setState(() {
          companies = (data['Data'] as List).map((company) => Map<String, String>.from(company)).toList();
        });
      } else {
        print('Failed to fetch data');
      }
    } else {
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
          departments = (data['Data'] as List).map((department) => Map<String, String>.from(department)).toList();
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

  Future<void> fetchReligions() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getreligion.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        setState(() {
          religions = (data['Data'] as List).map((religion) => Map<String, String>.from(religion)).toList();
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
          employeeStatuses = (data['Data'] as List).map((status) => Map<String, String>.from(status)).toList();
        });
      } else {
        print('Failed to fetch data');
      }
    } else {
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
          nationalities = (data['Data'] as List).map((nationality) => Map<String, String>.from(nationality)).toList();
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

  Future<void> fetchDetailData() async {
    try{
      isLoading = true;

      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployee.php?action=1&employee_id=${widget.employeeID}';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        Map<String, dynamic> data = (responseData['Data'] as List).first;

        setState(() {
          txtNIKKaryawan.text = data['employee_id'];
          txtNamaKayrawan.text = data['employee_name'];
          txtTempatLahir.text = data['employee_pob'];
          txtNomorIdentitas.text = data['employee_identity'];
          txtNomorJamsostek.text = data['employee_jamsostek'];
          selectedGender = data['gender_id'];
          selectedNationality = data['num_code'];
          selectedEmployeeStatus = data['status_id'];
          selectedReligion = data['religion_id'];
          selectedPosition = data['position_id'];
          selectedCompany  = data['company_id'];
          selectedDepartment = data['department_id'];
          selectedPosition = data['position_id'];
          fetchPositions(selectedCompany, selectedDepartment);
          fetchDepartments(selectedCompany);
          employeeDob = DateFormat("yyyy-MM-dd").parse(data['employee_dob']);
        });

      } else {
        txtNIKKaryawan.text = '';
        txtNamaKayrawan.text = '';
        txtTempatLahir.text = '';
        txtNomorIdentitas.text = '';
        txtNomorJamsostek.text = '';
        print('Failed to load data: ${response.statusCode}');
      }

    } catch (e){
      print('Error at fetching detail one data : $e');
      txtNIKKaryawan.text = '';
      txtNamaKayrawan.text = '';
      txtTempatLahir.text = '';
      txtNomorIdentitas.text = '';
      txtNomorJamsostek.text = '';
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchGenders() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getgender.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        setState(() {
          genders = (data['Data'] as List).map((gender) => Map<String, String>.from(gender)).toList();
        });
      } else {
        print('Failed to fetch data');
      }
    } else {
      print('Failed to fetch data');
    }
  }
  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    var employeeId = storage.read('employee_id');
    var positionId = storage.read('position_id');
    var photo = storage.read('photo');
    int storedEmployeeIdNumber = int.parse(widget.employeeID);
    
    return MaterialApp(
      title: "Data Karyawan",
      home: Scaffold(
        body: isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
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
                        LaporanNonActive(positionId: positionId.toString(),),
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
              //Content
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
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ID Karyawan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  controller: txtNIKKaryawan,
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
                                  controller: txtNamaKayrawan,
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
                                    value: selectedGender,
                                    hint: const Text('Pilih jenis kelamin'),
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
                                  type: DateTimePickerType.date,
                                  dateMask: 'd MMMM yyyy', // Format date as "30 April 2002"
                                  initialValue: employeeDob.toString(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100),
                                  onChanged: (val) {
                                    setState(() {
                                      employeeDob = DateFormat("yyyy-MM-dd").parse(val);
                                    });
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
                                  value: selectedNationality,
                                  hint: const Text('Pilih kewarganegaraan'),
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
                                  value: selectedCompany,
                                  hint: const Text('Select Company'),
                                  onChanged: null,
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
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Departemen',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                DropdownButtonFormField<String>(
                                  value: selectedDepartment,
                                  hint: const Text('Pilih Departemen'),
                                  onChanged: null,
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
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Jabatan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                DropdownButtonFormField<String>(
                                  value: selectedPosition,
                                  hint: const Text('Select Position'),
                                  onChanged: null,
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
                                  value: selectedEmployeeStatus,
                                  hint: const Text('Pilih status karyawan'),
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
                      SizedBox(height: 7.sp,),
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
                                  minimumSize: Size(50.w, 55.h),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Kembali')
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: (){
                          
                                }, 
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(50.w, 55.h),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Update')
                              ),
                              SizedBox(width: 10.w,),
                              ElevatedButton(
                                onPressed: (){
                                  Get.to(EmployeeDetailTwo(widget.employeeID));
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
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 17.sp,)
                    ]
                  )
                )
              )
            ]
          )
        )
      )
    );
  }
}