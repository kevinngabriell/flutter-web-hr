// ignore_for_file: avoid_print, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:hr_systems_web/web-version/full-access/PinjamanKaryawan/PinjamanKaryawanDetail.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class ViewAllMyPinjaman extends StatefulWidget {
  const ViewAllMyPinjaman({super.key});

  @override
  State<ViewAllMyPinjaman> createState() => _ViewAllMyPinjamanState();
}

class _ViewAllMyPinjamanState extends State<ViewAllMyPinjaman> {
  String? leaveoptions;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  bool isLoading = false;

  List<Map<String, dynamic>> noticationList = [];
  List<Map<String, dynamic>> myLoanList = [];

  @override
  void initState() {
    super.initState();
    fetchNotification();
    fetchData();
  }

  String formatCurrency2(String value) {
    // Parse the string to a number.
    double numberValue = double.tryParse(value) ?? 0;

    // Format the number as currency.
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0).format(numberValue);
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

      String apiUrlPinjaman = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/loan/getloan.php?action=2&employee_id=$employeeId';
      var responsePinjaman = await http.get(Uri.parse(apiUrlPinjaman));

      if (responsePinjaman.statusCode == 200) {
        var dataPinjaman = json.decode(responsePinjaman.body);

        setState(() {
          myLoanList = List<Map<String, dynamic>>.from(dataPinjaman['Data']);


        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e){
      print('Exception during API call: $e');
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
      title: 'Pinjaman Karyawan',
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
                            itemCount: myLoanList.length,
                            itemBuilder: (context, index){
                              return GestureDetector(
                                onTap: () {
                                  Get.to(PinjamanKaryawanDetail(pinjamanKaryawanID: myLoanList[index]['loan_id'], jumlahPinjaman: myLoanList[index]['loan_amount'], alasanPinjaman: myLoanList[index]['loan_reason'], caraBayarPinjaman: myLoanList[index]['loan_topay'], statusPinjaman: myLoanList[index]['status_name'], sudahLunasPinjaman: myLoanList[index]['is_paid'], tanggalPengajuan: myLoanList[index]['insert_dt'], namaKaryawan: myLoanList[index]['employee_name'], requestorID: myLoanList[index]['insert_by'], jabatan: myLoanList[index]['position_name'], departemen: myLoanList[index]['department_name'],));
                                },
                                child: Card(
                                  child: ListTile(
                                    title: Text(myLoanList[index]['employee_name'], style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w700),),
                                    subtitle: Text(formatCurrency2(myLoanList[index]['loan_amount']), style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w400),),
                                    trailing: Text(myLoanList[index]['status_name'], style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),),
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