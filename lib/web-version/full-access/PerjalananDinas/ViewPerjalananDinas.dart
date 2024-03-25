// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/services/pdf_downloader.dart';
import 'package:hr_systems_web/web-version/full-access/Event/event.dart';
import 'package:hr_systems_web/web-version/full-access/Performance/performance.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/AddNewLPD.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/PerjalananDinasIndex.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/ViewLPD.dart';
import 'package:hr_systems_web/web-version/full-access/Report/report.dart';
import 'package:hr_systems_web/web-version/full-access/Salary/salary.dart';
import 'package:hr_systems_web/web-version/full-access/Settings/setting.dart';
import 'package:hr_systems_web/web-version/full-access/Structure/structure.dart';
import 'package:hr_systems_web/web-version/full-access/Training/traning.dart';
import 'package:hr_systems_web/web-version/full-access/profile.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import '../../login.dart';
import '../employee.dart';
import '../index.dart';


class ViewPerjalananDinas extends StatefulWidget {
  final String perjalananDinasID;
  final String perjalananDinasStatus;
  final String tanggalPermohonan;
  final String namaKota;
  final String lamaDurasi;
  final String keterangan;
  final String tim;
  final String pembayaran;
  final String tranportasi;
  final String namaKaryawan;
  final String namaDepartemen;
  final String requestorID;

  const ViewPerjalananDinas({super.key, required this.perjalananDinasID, required this.perjalananDinasStatus, required this.tanggalPermohonan, required this.namaKota, required this.lamaDurasi, required this.keterangan, required this.tim, required this.pembayaran, required this.tranportasi, required this.namaKaryawan, required this.namaDepartemen, required this.requestorID});

  @override
  State<ViewPerjalananDinas> createState() => _ViewPerjalananDinasState();
}

class _ViewPerjalananDinasState extends State<ViewPerjalananDinas> {
  String? leaveoptions;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  bool isLoading = false;

  List<Map<String, dynamic>> noticationList = [];
  List<Map<String, dynamic>> historyList = [];

  TextEditingController txtReason = TextEditingController();

  String memberOne = '-';
  String memberTwo = '-';
  String memberThree = '-';
  String memberFour = '-';
  String employeeSPV = '';

  String namaMengetahui = '';
  String tanggalMengetahui = '';
  String namaMenyetujui = '';
  String tanggalMenyetujui = '';

  @override
  void initState() {
    super.initState();
    fetchNotification();
    fetchData();
    fetchMembersData();
    fetchHistory();
    fetchEmployeeSPV();
  }

  Future<void> fetchMembersData() async {
    String url = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/getperjalanandinas.php?action=8&businesstrip_id=${widget.perjalananDinasID}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      setState(() {
        List<dynamic> members = data['Data'];
        if (members.isNotEmpty) {
          memberOne = members.isNotEmpty ? members[0]['member_name'] : '-';
          memberTwo = members.length > 1 ? members[1]['member_name'] : '-';
          memberThree = members.length > 2 ? members[2]['member_name'] : '-';
          memberFour = members.length > 3 ? members[3]['member_name'] : '-';
        }
      });
    } else {
      // Handle the case where the server did not return a 200 OK response
      print("Failed to load members data");
    }
  }

  Future<void> fetchNotification() async{
    try{  
      String employeeId = storage.read('employee_id').toString();
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/notification/getlimitnotif.php?employee_id=$employeeId';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          noticationList = List<Map<String, dynamic>>.from(data['Data']);
        });
      } else if (response.statusCode == 404){
        print('404, No Data Found');
      }

    } catch (e){
      print('Error: $e');
    }
  }

  Future<void> fetchData() async {
    String employeeId = storage.read('employee_id').toString();
    isLoading = true;
    try {
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

  Future<void> fetchHistory() async {
    try{  
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/getperjalanandinas.php?action=9&businesstrip_id=${widget.perjalananDinasID}';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          historyList = List<Map<String, dynamic>>.from(data['Data']);
        });
      } else if (response.statusCode == 404){
        print('404, No Data Found');
      }

    } catch (e){
      print('Error: $e');
    }
  }

  Future<void> fetchEmployeeSPV() async {
    String employeeId = storage.read('employee_id').toString();
    String url = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployee.php?action=2&employee_id=${widget.requestorID}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      setState(() {
        List<dynamic> employee = data['Data'];
        if (employee.isNotEmpty) {
          employeeSPV = employee.isNotEmpty ? employee[0]['employee_spv'] : '-';
        }
      });
    } else {
      // Handle the case where the server did not return a 200 OK response
      print("Failed to load members data");
    }

    String mengetahuiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/getperjalanandinas.php?action=11&businesstrip_id=${widget.perjalananDinasID}';
    final mengetahuiResponse = await http.get(Uri.parse(mengetahuiUrl));

    if (mengetahuiResponse.statusCode == 200) {
      var mengetahuiData = json.decode(mengetahuiResponse.body);

      setState(() {
        List<dynamic> mengetahuiHasil = mengetahuiData['Data'];
        if (mengetahuiHasil.isNotEmpty) {
          namaMengetahui = mengetahuiHasil.isNotEmpty ? mengetahuiHasil[0]['employee_name'] : '-';
          tanggalMengetahui = mengetahuiHasil.isNotEmpty ? _formatDate(mengetahuiHasil[0]['action_dt']) : '-';
        }
      });
    } else {
      // Handle the case where the server did not return a 200 OK response
      print("Failed to load members data");
    }

    String menyetujuiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/getperjalanandinas.php?action=10&businesstrip_id=${widget.perjalananDinasID}';
    final menyetujuiResponse = await http.get(Uri.parse(menyetujuiUrl));

    if (menyetujuiResponse.statusCode == 200) {
      var menyetujuiData = json.decode(menyetujuiResponse.body);

      setState(() {
        List<dynamic> menyetujuiHasil = menyetujuiData['Data'];
        if (menyetujuiHasil.isNotEmpty) {
          namaMenyetujui = menyetujuiHasil.isNotEmpty ? menyetujuiHasil[0]['employee_name'] : '-';
          tanggalMenyetujui = menyetujuiHasil.isNotEmpty ? _formatDate(menyetujuiHasil[0]['action_dt']) : '-';
        }
      });
    } else {
      // Handle the case where the server did not return a 200 OK response
      print("Failed to load members data");
    }
  }
  
  Future<void> actionPerjalananDinas (action_id) async {

    String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/perjalanandinas.php';
    String employeeId = storage.read('employee_id').toString();

    if(action_id == '1'){
      try{
        isLoading = true;

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "action" : "6",
            "businesstrip_id": widget.perjalananDinasID,
            "employee_id": widget.requestorID,
            "spv_id" : employeeId,
            "reason" : txtReason.text
          }
        );

        if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil mengubah status perjalanan dinas'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PerjalananDinasIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        } else {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error ${response.body}'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PerjalananDinasIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        }

      } catch (e){
        showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error $e'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PerjalananDinasIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
      } finally {
        isLoading = false;
      }
    } else if (action_id == '2'){
      try{
        isLoading = true;

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "action" : "7",
            "businesstrip_id": widget.perjalananDinasID,
            "employee_id": widget.requestorID,
            "spv_id" : employeeId,
            "employee_name" : widget.namaKaryawan
          }
        );

        if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil mengubah status perjalanan dinas'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PerjalananDinasIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        } else {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error ${response.body}'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PerjalananDinasIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        }

      } catch (e){
        showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error $e'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PerjalananDinasIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
      } finally {
        isLoading = false;
      }
    } else if (action_id == '3'){
      try{
        isLoading = true;

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "action" : "8",
            "businesstrip_id": widget.perjalananDinasID,
            "employee_id": widget.requestorID,
            "hrd_id" : employeeId,
            "reason" : txtReason.text
          }
        );

        if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil mengubah status perjalanan dinas'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PerjalananDinasIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        } else {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error ${response.body}'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PerjalananDinasIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        }
      } catch (e){
        showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error $e'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PerjalananDinasIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
      } finally {
        isLoading = false;
      }
    } else if (action_id == '4'){
      try{
        isLoading = true;

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "action" : "9",
            "businesstrip_id": widget.perjalananDinasID,
            "employee_id": widget.requestorID,
            "hrd_id" : employeeId,
            "employee_name" : widget.namaKaryawan
          }
        );

        if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil mengubah status perjalanan dinas'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PerjalananDinasIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        } else {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error ${response.body}'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PerjalananDinasIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        }

      } catch (e){
        showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error $e'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PerjalananDinasIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
      } finally {
        isLoading = false;
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    var employeeId = storage.read('employee_id');
    var photo = storage.read('photo');
    var positionId = storage.read('position_id');
    String numberAsString = employeeId.toString().padLeft(10, '0');

    return MaterialApp(
      title: 'Perjalanan Dinas',
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
                        SizedBox(height: 15.sp,),
                        //company logo and name
                        ListTile(
                        contentPadding: const EdgeInsets.only(left: 0, right: 0),
                        dense: true,
                        horizontalTitleGap: 0.0, // Adjust this value as needed
                        leading: Container(
                          margin: const EdgeInsets.only(right: 2.0), // Add margin to the right of the image
                          child: Image.asset(
                            'images/kinglab.png',
                            width: MediaQuery.of(context).size.width * 0.08,
                          ),
                        ),
                        title: Text(
                          companyName,
                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w300),
                        ),
                        subtitle: Text(
                          trimmedCompanyAddress,
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
                                  Get.to(const SalaryIndex());
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
                                  Get.to(const PerformanceIndex());
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
                                  Get.to(const TrainingIndex());
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
                                  Get.to(const EventIndex());
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
                                  Get.to(const ReportIndex());
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
                                  Get.to(const SettingIndex());
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
                                  Get.to(const StructureIndex());
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
                                            onPressed: () {Get.off(const LoginPageDesktop());},
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
                        SizedBox(height: 35.sp,),
                        Padding(
                          padding: EdgeInsets.only(right: 20.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context, 
                                    builder: (BuildContext context){
                                      return AlertDialog(
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Notifikasi', style: TextStyle(
                                              fontSize: 20.sp, fontWeight: FontWeight.w700,
                                            )),
                                            GestureDetector(
                                              onTap: () {
                                                
                                              },
                                              child: Text('Hapus semua', style: TextStyle(
                                                fontSize: 12.sp, fontWeight: FontWeight.w600,
                                              )),
                                            ),
                                          ],
                                        ),
                                        content: SizedBox(
                                          width: MediaQuery.of(context).size.width / 2,
                                          height: MediaQuery.of(context).size.height / 2,
                                          child: ListView.builder(
                                            itemCount: noticationList.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: (){
                                                  if(noticationList[index]['sender'] != ''){
                                                      showDialog(
                                                      context: context, 
                                                      builder: (_) {
                                                        return AlertDialog(
                                                          title: Center(child: Text("${noticationList[index]['title']} ", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700))),
                                                          content: SizedBox(
                                                            width: MediaQuery.of(context).size.width / 4,
                                                            height: MediaQuery.of(context).size.height / 4,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text('Tanggal : ${_formatDate('${noticationList[index]['send_date']}')}'),
                                                                SizedBox(height: 2.h,),
                                                                Text('Dari : ${noticationList[index]['sender'] == 'Kevin Gabriel Florentino' ? 'System' : noticationList[index]['sender']} '),
                                                                SizedBox(height: 10.h,),
                                                                Text('${noticationList[index]['message']} ')
                                                              ],
                                                            ),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Get.back();
                                                              }, 
                                                              child: const Text("Ok")
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                    );
                                                  }
                                                },
                                                child: Card(
                                                  child: ListTile(
                                                    title: Text(index < noticationList.length ? '${noticationList[index]['title']} ' : '-',
                                                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    subtitle: Text(
                                                        index < noticationList.length
                                                        ? 'From ${noticationList[index]['sender'] == 'Kevin Gabriel Florentino' ? 'System' : noticationList[index]['sender']} '
                                                        : '-',
                                                        style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400),
                                                      ),
                                                  ),
                                                ),
                                              );
                                            }
                                          ),
                                        ),
                                      );
                                    }
                                  );
                                },
                                child: Stack(
                                  children: [
                                    const Icon(Icons.notifications),
                                    // if (noti.isNotEmpty)
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(1),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            noticationList.length.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 40.sp,),
                              GestureDetector(
                                onTap: () {
                                  Get.to(const ProfilePage());
                                },
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 290.w,
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
                                    subtitle: Text("$employeeEmail",
                                      style: TextStyle( fontSize: 15.sp, fontWeight: FontWeight.w300,),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.sp,),
                        Padding(
                          padding: EdgeInsets.only(right: 10.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Nomor Permohonan', style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(widget.perjalananDinasID),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Status Permohonan', style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(widget.perjalananDinasStatus),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Tanggal Permohonan', style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(_formatDate(widget.tanggalPermohonan)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 15.sp,),
                        Text('Detail Permohonan', style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                        SizedBox(height: 15.sp,),
                        Padding(
                          padding: EdgeInsets.only(right: 10.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Nama Karyawan', style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(widget.namaKaryawan),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Departemen', style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(widget.namaDepartemen),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Kota Tujuan', style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(widget.namaKota),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 30.sp,),
                        Padding(
                          padding: EdgeInsets.only(right: 10.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Lama Perjalanan', style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(widget.lamaDurasi),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Keperluan', style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(widget.keterangan),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Tim Analis/Teknisi', style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(widget.tim),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 30.sp,),
                        Padding(
                          padding: EdgeInsets.only(right: 10.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Anggota 1', style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(memberOne),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Anggota 2', style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(memberTwo),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Anggota 3', style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(memberThree),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 30.sp,),
                        Padding(
                          padding: EdgeInsets.only(right: 10.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Anggota 4', style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(memberFour),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Biaya', style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(widget.pembayaran),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Transportasi', style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(widget.tranportasi),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 30.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if(positionId == 'POS-HR-002' && widget.perjalananDinasStatus == 'Draft LPD' || widget.perjalananDinasStatus == 'Laporan disetujui HRD' || widget.perjalananDinasStatus == 'Laporan ditolak oleh HRD' || widget.perjalananDinasStatus == 'Laporan disetujui Keuangan' || widget.perjalananDinasStatus == 'Laporan ditolak oleh Keuangan')
                              ElevatedButton(
                                onPressed: (){
                                  Get.to(ViewLPD(businessTripID: widget.perjalananDinasID,));
                                }, 
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  alignment: Alignment.center,
                                  minimumSize: Size(40.w, 55.h),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: const Color(0xff4ec3fc),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Lihat LPD')
                              ),
                            if(positionId == 'POS-HR-002' && widget.perjalananDinasStatus == 'Draft LPD' || widget.perjalananDinasStatus == 'Laporan disetujui HRD' || widget.perjalananDinasStatus == 'Laporan ditolak oleh HRD' || widget.perjalananDinasStatus == 'Laporan disetujui Keuangan' || widget.perjalananDinasStatus == 'Laporan ditolak oleh Keuangan')
                              SizedBox(width: 10.w,),
                            if(widget.perjalananDinasStatus == 'Disetujui oleh HRD' || widget.perjalananDinasStatus == 'Draft LPD' || widget.perjalananDinasStatus == 'Laporan disetujui HRD' || widget.perjalananDinasStatus == 'Laporan ditolak oleh HRD' || widget.perjalananDinasStatus == 'Laporan disetujui Keuangan' || widget.perjalananDinasStatus == 'Laporan ditolak oleh Keuangan')
                              ElevatedButton(
                                onPressed: (){
                                  String namaA = widget.namaKaryawan;
                                  String departemenA = widget.namaDepartemen;
                                  String kotaTujuan = widget.namaKota;
                                  String lamaPerjalanan = widget.lamaDurasi;
                                  String keperluan = widget.keterangan;
                                  String tim = widget.tim;
                                  String biaya = widget.pembayaran;
                                  String transport = widget.tranportasi;
                                  String tanggalPermohonan = _formatDate(widget.tanggalPermohonan);
                                  String buisnessTripId = widget.perjalananDinasID;
                                  generateAndDisplayPDFPerjalananDinas(buisnessTripId, companyName, companyAddress, namaA, departemenA, kotaTujuan, lamaPerjalanan, keperluan, tim, memberOne, memberTwo, memberThree, memberFour, biaya, transport, tanggalPermohonan, namaMengetahui, namaMenyetujui, tanggalMengetahui, tanggalMenyetujui);
                                }, 
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  alignment: Alignment.center,
                                  minimumSize: Size(40.w, 55.h),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: const Color(0xff4ec3fc),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Download PDF Perjalanan Dinas')
                              ),
                            if(widget.requestorID == numberAsString && widget.perjalananDinasStatus == 'Disetujui oleh HRD')  
                              SizedBox(width: 10.w,),
                            if(widget.requestorID == numberAsString && widget.perjalananDinasStatus == 'Disetujui oleh HRD')
                              ElevatedButton(
                                onPressed: (){
                                  Get.to(AddNewLPD(
                                    businesstrip_id: widget.perjalananDinasID, 
                                    employeeName: widget.namaKaryawan, 
                                    departmentName: widget.namaDepartemen, 
                                    memberOne: memberOne, 
                                    memberTwo: memberTwo, 
                                    memberThree: memberThree, 
                                    memberFour: memberFour,
                                    spvId : employeeSPV
                                  ));
                                }, 
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  alignment: Alignment.center,
                                  minimumSize: Size(40.w, 55.h),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: const Color(0xff4ec3fc),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Buat laporan ')
                              ),
                            if(positionId == 'POS-HR-002' && widget.perjalananDinasStatus == 'Disetujui oleh Manager')
                              ElevatedButton(
                                onPressed: (){
                                  actionPerjalananDinas('4');
                                }, 
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  alignment: Alignment.center,
                                  minimumSize: Size(40.w, 55.h),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Terima')
                              ),
                            if(positionId == 'POS-HR-002' && widget.perjalananDinasStatus == 'Disetujui oleh Manager')
                              SizedBox(width: 10.w,),
                            if(positionId == 'POS-HR-002' && widget.perjalananDinasStatus == 'Disetujui oleh Manager')
                              ElevatedButton(
                                onPressed: (){
                                  showDialog(
                                    context: context, 
                                    builder: (_){
                                      return AlertDialog(
                                        title: const Text('Alasan Penolakan Perjalanan Dinas'),
                                        content: TextFormField(
                                          maxLines: 3,
                                          controller: txtReason,
                                          decoration: const InputDecoration(
                                            hintText: 'Masukkan alasan penolakan anda'
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: (){
                                              Get.back();
                                            }, 
                                            child: const Text('Batal')
                                          ),
                                          TextButton(
                                            onPressed: (){
                                              actionPerjalananDinas('3');
                                            }, 
                                            child: const Text('Kumpul')
                                          )
                                        ],
                                      );
                                    }
                                  );
                                }, 
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  alignment: Alignment.center,
                                  minimumSize: Size(40.w, 55.h),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Tolak')
                              ),
                            if(numberAsString == employeeSPV && widget.perjalananDinasStatus == 'Draft')
                              ElevatedButton(
                                onPressed: (){
                                  actionPerjalananDinas('2');
                                }, 
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  alignment: Alignment.center,
                                  minimumSize: Size(40.w, 55.h),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Terima')
                              ),
                            if(numberAsString == employeeSPV && widget.perjalananDinasStatus == 'Draft')
                              SizedBox(width: 10.w,),
                            if(numberAsString == employeeSPV && widget.perjalananDinasStatus == 'Draft')
                              ElevatedButton(
                                onPressed: (){
                                  showDialog(
                                    context: context, 
                                    builder: (_){
                                      return AlertDialog(
                                        title: const Text('Alasan Penolakan Perjalanan Dinas'),
                                        content: TextFormField(
                                          maxLines: 3,
                                          controller: txtReason,
                                          decoration: const InputDecoration(
                                            hintText: 'Masukkan alasan penolakan anda'
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: (){
                                              Get.back();
                                            }, 
                                            child: const Text('Batal')
                                          ),
                                          TextButton(
                                            onPressed: (){
                                              actionPerjalananDinas('1');
                                            }, 
                                            child: const Text('Kumpul')
                                          )
                                        ],
                                      );
                                    }
                                  );
                                }, 
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  alignment: Alignment.center,
                                  minimumSize: Size(40.w, 55.h),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Tolak')
                              ),
                          ],
                        ),
                        SizedBox(height: 30.sp,),
                        Text('Riwayat Permohonan', style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.w600,)),
                        SizedBox(height: 30.sp,),
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            itemCount: historyList.length,
                            itemBuilder: (context, index){
                              var item = historyList[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xff4ec3fc),
                                  child: Text('${index + 1}', style: const TextStyle(color: Colors.white),),
                                ),
                                title: Text(item['employee_name'], style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),),
                                subtitle: Text(item['action'], style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400),),
                                trailing: Text(_formatDate(item['action_dt']), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400),),
                              );
                            }
                          ),
                        ),
                        SizedBox(height: 50.sp,),
                      ]
                    )
                  )
                )
              ]
            )
          )
        )
      )
    );
  }

  String _formatDate(String date) {
    // Parse the date string
    DateTime parsedDate = DateFormat("yyyy-MM-dd HH:mm").parse(date);

    // Format the date as "dd MMMM yyyy" in Indonesian locale
    return DateFormat("d MMMM yyyy", 'id').format(parsedDate);
  }

}