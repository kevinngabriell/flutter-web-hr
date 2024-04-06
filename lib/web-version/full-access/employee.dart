// ignore_for_file: non_constant_identifier_names, avoid_print, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Applicant/applicantdashboard.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/EmployeeList.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/RequestNewEmployee.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Resign/ViewListAllResign.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Resign/ViewListMyResign.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/InventoryDashboard.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/PerjalananDinasIndex.dart';
import 'package:hr_systems_web/web-version/full-access/PinjamanKaryawan/PinjamanKaryawanIndex.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key, required employee_id});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  List<dynamic> profileData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  final storage = GetStorage();

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
    
    return MaterialApp(
      title: "Menu Karyawan",
      home: SafeArea(
        child: Scaffold(
          body: isLoading ? const Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
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
                        NotificationnProfile(employeeName: employeeName, employeeAddress: employeeEmail, photo: photo),
                        SizedBox(height: 7.sp,),
                        //4 card diatas
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //card pertama
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 95.sp) / 4,
                              height: MediaQuery.of(context).size.height - 65.sp,
                              child: GestureDetector(
                                onTap: () {
                                  // Get.snackbar('Under Construction', 'This feature is under construction stay tune');
                                  if(positionId == 'POS-HR-001' || positionId == 'POS-HR-002' || positionId == 'POS-HR-004' || positionId == 'POS-HR-005' || positionId == 'POS-HR-008' || positionId == 'POS-HR-024'){
                                    Get.to(const RequestNewEmployee());
                                  } else {
                                    showDialog(
                                      context: context, 
                                      builder: (_) {
                                        return AlertDialog(
                                          title: const Text("Error"),
                                          content: const Text("Maaf anda tidak memiliki akses ke menu ini"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Get.back();
                                              }, 
                                              child: const Text("Oke")
                                            ),
                                          ],
                                        );
                                      }
                                    );
                                  }
                                },
                                child: Card(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12))
                                  ),
                                  color: Colors.white,
                                  shadowColor: Colors.black,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 7.sp, top: 10.sp, bottom: 10.sp, right: 7.sp),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset('images/NewEmployeeRequest.png'),
                                        SizedBox(height: 5.sp,),
                                        Text('Pengajuan',
                                          style: TextStyle(
                                            fontSize: 6.sp,
                                            fontWeight: FontWeight.w700,
                                          )
                                        ),
                                        SizedBox(height: 3.sp,),
                                        Text('Ajukan karyawan baru dan lengkapi semua informasi yang diperlukan untuk proses perekrutan dan penerimaan',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color.fromRGBO(116, 116, 116, 1),
                                            fontSize: 4.sp,
                                            fontWeight: FontWeight.w400,
                                          )
                                        )
                                      ],
                                    ),
                                  )
                                ),
                              ),
                            ),
                            //card kedua
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 95.sp) / 4,
                              height: MediaQuery.of(context).size.height - 65.sp,
                              child: GestureDetector(
                                onTap: () {
                                  if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008'){
                                    Get.to(const ApplicantIndex());
                                  } else {
                                    showDialog(
                                      context: context, 
                                      builder: (_) {
                                        return AlertDialog(
                                          title: const Text("Error"),
                                          content: const Text("Maaf anda tidak memiliki akses ke menu ini"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Get.back();
                                              }, 
                                              child: const Text("Oke")
                                            ),
                                          ],
                                        );
                                      }
                                    );
                                  }
                                },
                                child: Card(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12))
                                  ),
                                  color: Colors.white,
                                  shadowColor: Colors.black,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 7.sp, top: 10.sp, bottom: 10.sp, right: 7.sp),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset('images/Applicant.png'),
                                        SizedBox(height: 5.sp,),
                                        Text('Pelamar',
                                          style: TextStyle(
                                            fontSize: 6.sp,
                                            fontWeight: FontWeight.w700,
                                          )
                                        ),
                                        SizedBox(height: 3.sp,),
                                        Text('Lihat semua pelamar kerja yang masuk, kelola data mereka, dan pantau status lamaran mereka',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color.fromRGBO(116, 116, 116, 1),
                                            fontSize: 4.sp,
                                            fontWeight: FontWeight.w400,
                                          )
                                        )
                                      ],
                                    ),
                                  )
                                ),
                              ),
                            ),
                            //card ketiga
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 95.sp) / 4,
                              height: MediaQuery.of(context).size.height - 65.sp,
                              child: GestureDetector(
                                onTap: () {
                                  if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008'){
                                    Get.to(const EmployeeListPage());
                                  } else {
                                    showDialog(
                                      context: context, 
                                      builder: (_) {
                                        return AlertDialog(
                                          title: const Text("Error"),
                                          content: const Text("Maaf anda tidak memiliki akses ke menu ini"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Get.back();
                                              }, 
                                              child: const Text("Oke")
                                            ),
                                          ],
                                        );
                                      }
                                    );
                                  }
                                },
                                child: Card(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12))
                                  ),
                                  color: Colors.white,
                                  shadowColor: Colors.black,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 7.sp, top: 10.sp, bottom: 10.sp, right: 7.sp),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset('images/Employee.png'),
                                        SizedBox(height: 5.sp,),
                                        Text('Karyawan',
                                          style: TextStyle(
                                            fontSize: 6.sp,
                                            fontWeight: FontWeight.w700,
                                          )
                                        ),
                                        SizedBox(height: 3.sp,),
                                        Text('Lihat daftar lengkap karyawan yang bekerja di perusahaan, termasuk data dan detail personal mereka',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color.fromRGBO(116, 116, 116, 1),
                                            fontSize: 4.sp,
                                            fontWeight: FontWeight.w400,
                                          )
                                        )
                                      ],
                                    ),
                                  )
                                ),
                              ),
                            ),
                            //card keempat
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 95.sp) / 4,
                              height: MediaQuery.of(context).size.height - 65.sp,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(const InventoryIndex());
                                },
                                child: Card(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12))
                                  ),
                                  color: Colors.white,
                                  shadowColor: Colors.black,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 7.sp, top: 10.sp, bottom: 10.sp, right: 7.sp),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset('images/NewEmployeeRequest.png'),
                                        SizedBox(height: 5.sp,),
                                        Text('Inventaris',
                                          style: TextStyle(
                                            fontSize: 6.sp,
                                            fontWeight: FontWeight.w700,
                                          )
                                        ),
                                        SizedBox(height: 3.sp,),
                                        Text('Lakukan pendataan dan ajukan permintaan inventaris baru melalui menu ini',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color.fromRGBO(116, 116, 116, 1),
                                            fontSize: 4.sp,
                                            fontWeight: FontWeight.w400,
                                          )
                                        )
                                      ],
                                    ),
                                  )
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.sp,),
                        //4 card dibawah
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //card pertama
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 95.sp) / 4,
                              height: MediaQuery.of(context).size.height - 65.sp,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(const PerjalananDinasIndex());
                                },
                                child: Card(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12))
                                  ),
                                  color: Colors.white,
                                  shadowColor: Colors.black,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 7.sp, top: 10.sp, bottom: 10.sp, right: 7.sp),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset('images/NewEmployeeRequest.png'),
                                        SizedBox(height: 5.sp,),
                                        Text('Perjalanan Dinas',
                                          style: TextStyle(
                                            fontSize: 6.sp,
                                            fontWeight: FontWeight.w700,
                                          )
                                        ),
                                        SizedBox(height: 3.sp,),
                                        Text('Fitur segera hadir! Tetap tunggu kabar lebih lanjut tentang fitur menarik yang akan segera kami luncurkan',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color.fromRGBO(116, 116, 116, 1),
                                            fontSize: 4.sp,
                                            fontWeight: FontWeight.w400,
                                          )
                                        )
                                      ],
                                    ),
                                  )
                                ),
                              ),
                            ),
                            //card kedua
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 95.sp) / 4,
                              height: MediaQuery.of(context).size.height - 65.sp,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(const PinjamanKaryawanIndex());
                                },
                                child: Card(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12))
                                  ),
                                  color: Colors.white,
                                  shadowColor: Colors.black,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 7.sp, top: 10.sp, bottom: 10.sp, right: 7.sp),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset('images/NewEmployeeRequest.png'),
                                        SizedBox(height: 5.sp,),
                                        Text('Pinjaman Karyawan',
                                          style: TextStyle(
                                            fontSize: 6.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 3.sp,),
                                        Text('Fitur segera hadir! Tetap tunggu kabar lebih lanjut tentang fitur menarik yang akan segera kami luncurkan',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color.fromRGBO(116, 116, 116, 1),
                                            fontSize: 4.sp,
                                            fontWeight: FontWeight.w400,
                                          )
                                        )
                                      ],
                                    ),
                                  )
                                ),
                              ),
                            ),
                            //card ketiga
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 95.sp) / 4,
                              height: MediaQuery.of(context).size.height - 65.sp,
                              child: GestureDetector(
                                onTap: () {
                                  if(positionId == 'POS-HR-002'){
                                    Get.to(const viewListAllResign());
                                  } else {
                                    Get.to(const ViewListMyResign());
                                  }
                                },
                                child: Card(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12))
                                  ),
                                  color: Colors.white,
                                  shadowColor: Colors.black,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 7.sp, top: 10.sp, bottom: 10.sp, right: 7.sp),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset('images/NewEmployeeRequest.png'),
                                        SizedBox(height: 5.sp,),
                                        Text('Pemunduran Diri',
                                          style: TextStyle(
                                            fontSize: 6.sp,
                                            fontWeight: FontWeight.w700,
                                          )
                                        ),
                                        SizedBox(height: 3.sp,),
                                        Text('Lihat dan pantau pemunduran diri anda melalui menu ini.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color.fromRGBO(116, 116, 116, 1),
                                            fontSize: 4.sp,
                                            fontWeight: FontWeight.w400,
                                          )
                                        )
                                      ],
                                    ),
                                  )
                                ),
                              ),
                            ),
                            //card keempat
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 95.sp) / 4,
                              height: MediaQuery.of(context).size.height - 65.sp,
                              child: GestureDetector(
                                onTap: () {
                                  
                                },
                                child: Card(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12))
                                  ),
                                  color: Colors.white,
                                  shadowColor: Colors.black,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 7.sp, top: 10.sp, bottom: 10.sp, right: 7.sp),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset('images/NewEmployeeRequest.png'),
                                        SizedBox(height: 5.sp,),
                                        Text('Soon',
                                          style: TextStyle(
                                            fontSize: 6.sp,
                                            fontWeight: FontWeight.w700,
                                          )
                                        ),
                                        SizedBox(height: 3.sp,),
                                        Text('Fitur segera hadir! Tetap tunggu kabar lebih lanjut tentang fitur menarik yang akan segera kami luncurkan',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color.fromRGBO(116, 116, 116, 1),
                                            fontSize: 4.sp,
                                            fontWeight: FontWeight.w400,
                                          )
                                        )
                                      ],
                                    ),
                                  )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}
