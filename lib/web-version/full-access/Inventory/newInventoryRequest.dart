// ignore_for_file: use_build_context_synchronously, avoid_print, file_names

import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:hr_systems_web/web-version/full-access/index.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class NewInventoryRequest extends StatefulWidget {
  const NewInventoryRequest({super.key});

  @override
  State<NewInventoryRequest> createState() => _NewInventoryRequestState();
}

class _NewInventoryRequestState extends State<NewInventoryRequest> {
  final storage = GetStorage();
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String employeeId = '';
  String departmentName = '';
  String positionName = '';
  String trimmedCompanyAddress = '';
  bool isLoading = false;
  TextEditingController txtNamaLengkap = TextEditingController();
  String namaLengkapText = '';
  TextEditingController txtNIK = TextEditingController();
  String nikText = '';
  TextEditingController txtDepartemen = TextEditingController();
  String departemenText = '';
  TextEditingController txtJabatan = TextEditingController();
  String jabatanText = '';

  List<Map<String, String>> reasons = [];
  String selectedReason = '';

  TextEditingController txtDescInventory = TextEditingController();
  TextEditingController txtKeterangan = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDataforFilled();
    fetchReason();
  }

  Future<void> fetchReason() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/newinventoryreason.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        setState(() {
          reasons = (data['Data'] as List)
              .map((reason) => Map<String, String>.from(reason))
              .toList();

          if (reasons.isNotEmpty) {
            // Set the selectedCompany to the first item in the list by default
            selectedReason = reasons[0]['id_reason'].toString();
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
          txtNamaLengkap.text = employeeName;
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
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/getdataforrequestor.php';

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
  
  Future<void> sendRequest() async{

    try{
      setState(() {
        isLoading = true;
      });

       String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/newinventoryrequest.php';
       String employeeId = storage.read('employee_id').toString();

       final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "employee_id": employeeId,
            "inventaris": txtDescInventory.text,
            "reason": selectedReason,
            "keterangan": txtKeterangan.text
          }
        );

        if(response.statusCode == 200){
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text("Sukses"),
                content: const Text("Permintaan inventaris anda telah berhasil diajukan"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(FullIndexWeb(employeeId));
                    }, 
                    child: const Text("Oke")
                  ),
                 
                ],
              );
            }
          );
        } else {
          setState(() {
            isLoading = false;
          });
          Get.snackbar('Gagal', response.body);
        }

    } catch (e){
      setState(() {
        isLoading = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    var employeeId = storage.read('employee_id');
    var photo = storage.read('photo');
    var positionId = storage.read('position_id');

    return MaterialApp(
      title: 'Pengajuan Inventaris',
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
                      //Title
                      Center(
                        child: Text(
                          "Pengajuan Inventaris Baru",
                          style: TextStyle(
                            fontSize: 7.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color.fromRGBO(116, 116, 116, 1)
                          ),
                        ),
                      ),
                      SizedBox(height: 10.sp,),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 110.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nama Lengkap",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(116, 116, 116, 1)
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                                if(isLoading)
                                  const CircularProgressIndicator()
                                else
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
                            )
                          ),
                          SizedBox(width: 15.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 110.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "NIK",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(116, 116, 116, 1)
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                                if(isLoading)
                                  const CircularProgressIndicator()
                                else
                                  TextFormField(
                                    controller: txtNIK,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan NIK anda'
                                    ),
                                    readOnly: true,
                                  )
                              ],
                            )
                          ),
                        ],
                      ),
                      SizedBox(height: 10.sp,),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 110.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Departemen",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(116, 116, 116, 1)
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtDepartemen,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan departemen anda'
                                  ),
                                  readOnly: true,
                                )
                              ],
                            )
                          ),
                          SizedBox(width: 15.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 110.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Jabatan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(116, 116, 116, 1)
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtJabatan,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan jabatan anda'
                                  ),
                                  readOnly: true,
                                )
                              ],
                            )
                          ),
                        ],
                      ),
                      SizedBox(height: 10.sp,),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 110.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Inventaris yang Diajukan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(116, 116, 116, 1)
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtDescInventory,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan inventaris yang anda ajukan'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            )
                          ),
                          SizedBox(width: 15.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 110.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Alasan Pengajuan Inventaris",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(116, 116, 116, 1)
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                                DropdownButtonFormField<String>(
                                  value: selectedReason,
                                  hint: const Text('Select Reason'),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedReason = newValue.toString();
                                    });
                                  },
                                  items: reasons.map<DropdownMenuItem<String>>((Map<String, String> reason) {
                                    return DropdownMenuItem<String>(
                                      value: reason['id_reason']!,
                                      child: Text(reason['request_reason']!),
                                    );
                                  }).toList(),
                                )
                              ],
                            )
                          ),
                        ],
                      ),
                      SizedBox(height: 10.sp,),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 90.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Keterangan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(116, 116, 116, 1)
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtKeterangan,
                                  maxLines: 4,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan detail dari permintaan anda atau alasan lainnya'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            )
                          ),
                        ],
                      ),
                      SizedBox(height: 10.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              sendRequest();
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(40.w, 55.h),
                              foregroundColor: const Color(0xFFFFFFFF),
                              backgroundColor: const Color(0xff4ec3fc),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Kumpulkan')
                          ),
                        ],
                      )
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