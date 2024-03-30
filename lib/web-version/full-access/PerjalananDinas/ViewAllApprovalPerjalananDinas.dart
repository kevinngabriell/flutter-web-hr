// ignore_for_file: avoid_print, file_names

import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/ViewPerjalananDinas.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ViewAllApprovalPerjalananDinas extends StatefulWidget {
  const ViewAllApprovalPerjalananDinas({super.key});

  @override
  State<ViewAllApprovalPerjalananDinas> createState() => _ViewAllApprovalPerjalananDinasState();
}

class _ViewAllApprovalPerjalananDinasState extends State<ViewAllApprovalPerjalananDinas> {
  String? leaveoptions;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  bool isLoading = false;

  List<Map<String, dynamic>> noticationList = [];
  List<Map<String, dynamic>> businessTripHRDApproval = [];

  @override
  void initState() {
    super.initState();
    fetchNotification();
    fetchData();
    fetchPerjalananDinas();
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

  Future<void> fetchPerjalananDinas() async {
    String employeeId = storage.read('employee_id').toString();

    try{
      isLoading = true;

      String hrdapiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/getperjalanandinas.php?action=7';
      var hrdResponse = await http.get(Uri.parse(hrdapiUrl));

      if (hrdResponse.statusCode == 200) {
        var hrdData = json.decode(hrdResponse.body);

        setState(() {
          businessTripHRDApproval = List<Map<String, dynamic>>.from(hrdData['Data']);
        });
      } else {
        print('Failed to load data: ${hrdResponse.statusCode}');
      }
    } catch (e){
      print(e.toString());
    } finally {
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
      title: 'Persetujuan Perjalanan Dinas',
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            itemCount: businessTripHRDApproval.length,
                            itemBuilder: (context, index){
                              return GestureDetector(
                                onTap: () {
                                  Get.to(ViewPerjalananDinas(perjalananDinasID: businessTripHRDApproval[index]['businesstrip_id'], perjalananDinasStatus: businessTripHRDApproval[index]['status_name'],  tanggalPermohonan: businessTripHRDApproval[index]['insert_dt'], namaKota: businessTripHRDApproval[index]['nama_kota'], lamaDurasi: businessTripHRDApproval[index]['duration_name'], keterangan: businessTripHRDApproval[index]['reason'], tim: businessTripHRDApproval[index]['team'], pembayaran: businessTripHRDApproval[index]['payment_name'], tranportasi: businessTripHRDApproval[index]['transport_name'], namaKaryawan: businessTripHRDApproval[index]['employee_name'], namaDepartemen: businessTripHRDApproval[index]['department_name'], requestorID: businessTripHRDApproval[index]['insert_by'],));
                                },
                                child: Card(
                                  child: ListTile(
                                    title: Text(businessTripHRDApproval[index]['employee_name'], style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w700),),
                                    subtitle: Text('${businessTripHRDApproval[index]['nama_kota']} (${businessTripHRDApproval[index]['duration_name']})', style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),),
                                    trailing: Text(businessTripHRDApproval[index]['status_name'], style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),),
                                  ),
                                ),
                              );
                            }
                          ),
                        )
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

}