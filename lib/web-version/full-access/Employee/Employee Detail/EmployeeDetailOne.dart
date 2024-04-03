// ignore_for_file: file_names, non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Employee%20Detail/EmployeeDetailTwo.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/UpdateData/UpdateDataOne.dart';
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

  String namaKaryawan = '';
  String idKaryawan = '';
  String jenisKelamin = '';
  String tempatLahir = '';
  String tanggalLahir = '';
  String kewarganegaraan = '';
  String perusahaan = '';
  String departemen = '';
  String jabatan = '';
  String nomorIdentitas = '';
  String nomorJamsostek = '';
  String status = '';
  String agama = '';

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDetailData();
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
          idKaryawan = data['employee_id'] ?? '-';
          namaKaryawan = data['employee_name'] ?? '-';
          tempatLahir = data['employee_pob'] ?? '-';
          nomorIdentitas = data['employee_identity'] ?? '-';
          nomorJamsostek = data['employee_jamsostek'] ?? '-';
          jenisKelamin = data['gender_name'] ?? '-';
          kewarganegaraan = data['nationality'] ?? '-';
          status = data['status_name'] ?? '-';
          agama = data['religion_name'] ?? '-';
          jabatan = data['position_name'] ?? '-';
          perusahaan  = data['company_name'] ?? '-';
          departemen = data['department_name'] ?? '-';
          tanggalLahir = _formatDate(data['employee_dob']);
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
                                Text(idKaryawan)
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
                                Text(namaKaryawan)
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
                                Text(jenisKelamin)
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
                                Text(tempatLahir)
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
                                Text(tanggalLahir)
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
                                Text(kewarganegaraan)
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
                                Text(perusahaan)
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
                                Text(departemen)
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
                                Text(jabatan)
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
                                Text(nomorIdentitas)
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
                                Text(nomorJamsostek)
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
                                Text(status)
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
                                Text(agama)
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
                                  Get.to(UpdateDataOne(employeeId: widget.employeeID));
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

  String _formatDate(String date) {
    // Parse the date string
    DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(date);

    // Format the date as "dd MMMM yyyy"
    return DateFormat("d MMMM yyyy", 'id').format(parsedDate);
  }
}