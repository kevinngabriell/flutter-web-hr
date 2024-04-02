// ignore_for_file: avoid_print, file_names, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/EmployeeList.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'AddNewEmployeeSix.dart';

class AddNewEmployeeFive extends StatefulWidget {
  const AddNewEmployeeFive({super.key});

  @override
  State<AddNewEmployeeFive> createState() => _AddNewEmployeeFiveState();
}

class _AddNewEmployeeFiveState extends State<AddNewEmployeeFive> {
  String? selectedAbility;
  String? selectedAbility2;
  String? selectedAbility3;
  String? selectedAbility4;
  String? selectedAbility5;
  String? selectedAbility6;
  String? selectedAbility7;
  String? selectedAbility8;
  String? selectedAbility9;
  String? selectedAbility10;
  String? selectedAbility11;
  String? selectedAbility12;
  String? selectedAbility13;
  String? selectedAbility14;
  String? selectedAbility15;
  String? selectedAbility16;
  List<Map<String, String>> abilityList = [];

  TextEditingController txtBahasa1 = TextEditingController();
  TextEditingController txtBahasa2 = TextEditingController();
  TextEditingController txtBahasa3 = TextEditingController();
  TextEditingController txtBahasa4 = TextEditingController();
  bool isLoading = false;
  String id = '';
String trimmedCompanyAddress = '';
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';

  List<dynamic> profileData = [];

  @override
  void initState() {
    super.initState();
    fetchAbilityList();
    fetchLastID();
    fetchData();
  }

  final storage = GetStorage();

  Future<void> fetchData() async {
    String employeeId = storage.read('employee_id').toString();

    try {
      isLoading = true;
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
      isLoading = false;
      print('Exception during API call: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchAbilityList() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getability.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        final abilities = (data['Data'] as List)
            .map((ability) => Map<String, String>.from({
                  'ability_id': ability['ability_id'],
                  'ability_name': ability['ability_name'],
                }))
            .toList();

        setState(() {
          abilityList = abilities;
          if (abilityList.isNotEmpty) {
            selectedAbility = abilityList[0]['ability_id'];
            selectedAbility2 = abilityList[0]['ability_id'];
            selectedAbility3 = abilityList[0]['ability_id'];
            selectedAbility4 = abilityList[0]['ability_id'];
            selectedAbility5 = abilityList[0]['ability_id'];
            selectedAbility6 = abilityList[0]['ability_id'];
            selectedAbility7 = abilityList[0]['ability_id'];
            selectedAbility8 = abilityList[0]['ability_id'];
            selectedAbility9 = abilityList[0]['ability_id'];
            selectedAbility10 = abilityList[0]['ability_id'];
            selectedAbility11 = abilityList[0]['ability_id'];
            selectedAbility12 = abilityList[0]['ability_id'];
            selectedAbility13 = abilityList[0]['ability_id'];
            selectedAbility14 = abilityList[0]['ability_id'];
            selectedAbility15 = abilityList[0]['ability_id'];
            selectedAbility16 = abilityList[0]['ability_id'];

          }
        });
      } else {
        // Handle API error
        print('Failed to fetch ability list');
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
    isLoading = true;
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
    isLoading = false;
    print('Error: $e');
  } finally {
    isLoading = false;
  }
}

  Future<void> insertemployee() async {
    try{
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/insertemployee/insertfive.php';

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "id": id,
          "language_1" : "Bahasa Indonesia",
          "language_2" : "Bahasa Inggris",
          "language_3" : txtBahasa3.text,
          "language_4" : txtBahasa4.text,
          "ability_1" : selectedAbility,
          "ability_2" : selectedAbility2,
          "ability_3" : selectedAbility3,
          "ability_4" : selectedAbility4,
          "ability_5" : selectedAbility5,
          "ability_6" : selectedAbility6,
          "ability_7" : selectedAbility7,
          "ability_8" : selectedAbility8,
          "ability_9" : selectedAbility9,
          "ability_10" : selectedAbility10,
          "ability_11" : selectedAbility11,
          "ability_12" : selectedAbility12,
          "ability_13" : selectedAbility13,
          "ability_14" : selectedAbility14,
          "ability_15" : selectedAbility15,
          "ability_16" : selectedAbility16,
        }
      );

      if (response.statusCode == 200) {
        print('Employee inserted successfully');
        Get.to(const AddNewEmployeeSix());
        // Add any additional logic or UI updates after successful insertion
      } else {
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
      isLoading = false;
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
    } finally {
      isLoading = false;
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
                      Text('Kemampuan Bahasa Pertama',style: TextStyle(fontSize: 5.sp,fontWeight: FontWeight.w700,)),
                      SizedBox(height: 5.sp,),
                      //Bahasa Indonesia
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 130.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Bahasa",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.h,),
                                TextFormField(
                                  controller: txtBahasa1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan bahasa indonesia'
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Mendengar",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 2.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Berbicara",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 2.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility2,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility2 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Membaca",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility3,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility3 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
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
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Menulis',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                DropdownButtonFormField<String>(
                                    value: selectedAbility4,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility4 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 130.w) / 3,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      const Divider(),
                      SizedBox(height: 7.sp,),
                      Text('Kemampuan Bahasa Kedua',style: TextStyle(fontSize: 5.sp,fontWeight: FontWeight.w700,)),
                      SizedBox(height: 5.sp,),
                      //Bahasa Inggris
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 130.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Bahasa",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.h,),
                                TextFormField(
                                  controller: txtBahasa2,
                                  //initialValue: 'Bahasa Inggris',
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan bahasa inggris'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Mendengar",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility5,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility5 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Berbicara",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility6,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility6 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Membaca",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility7,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility7 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
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
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Menulis',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                DropdownButtonFormField<String>(
                                    value: selectedAbility8,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility8 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 130.w) / 3,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      const Divider(),
                      SizedBox(height: 7.sp,),
                      Text('Kemampuan Bahasa Ketiga',style: TextStyle(fontSize: 5.sp,fontWeight: FontWeight.w700,)),
                      SizedBox(height: 5.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 130.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Bahasa",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.h,),
                                TextFormField(
                                  controller: txtBahasa3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan bahasa yang anda kuasai'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Mendengar",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility9,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility9 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Berbicara",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility10,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility10 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Membaca",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility11,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility11 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
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
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Menulis',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                DropdownButtonFormField<String>(
                                    value: selectedAbility12,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility12 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 130.w) / 3,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      const Divider(),
                      SizedBox(height: 7.sp,),
                      Text('Kemampuan Bahasa Keempat',style: TextStyle(fontSize: 5.sp,fontWeight: FontWeight.w700,)),
                      SizedBox(height: 5.sp,),
                      //Bahasa 4
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 130.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Bahasa",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.h,),
                                TextFormField(
                                  controller: txtBahasa4,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan bahasa yang anda kuasai'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Mendengar",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility13,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility13 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Berbicara",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility14,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility14 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Membaca",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedAbility15,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility15 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
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
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Menulis',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                DropdownButtonFormField<String>(
                                    value: selectedAbility16,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAbility16 = newValue;
                                      });
                                    },
                                    items: abilityList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> ability) {
                                        return DropdownMenuItem<String>(
                                          value: ability['ability_id']!,
                                          child: Text(ability['ability_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 130.w) / 3,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                        onPressed: () {
                          insertemployee();
                          // Get.to(AddNewEmployeeSix());
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
                      SizedBox(height: 7.sp,),
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