// ignore_for_file: avoid_print, non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:hr_systems_web/web-version/full-access/PinjamanKaryawan/PinjamanKaryawanDetail.dart';
import 'package:hr_systems_web/web-version/full-access/PinjamanKaryawan/ViewAllMyPinjaman.dart';
import 'package:hr_systems_web/web-version/full-access/PinjamanKaryawan/ViewAllPinjaman.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class PinjamanKaryawanIndex extends StatefulWidget {
  const PinjamanKaryawanIndex({super.key});

  @override
  State<PinjamanKaryawanIndex> createState() => _PinjamanKaryawanIndexState();
}

class _PinjamanKaryawanIndexState extends State<PinjamanKaryawanIndex> {
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
  List<Map<String, dynamic>> LoanList = [];

  String myLoan = '';
  String totalMyLoan = '';
  String totalLoan = '';

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

      String url = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/loan/getloan.php?action=1&employee_id=$employeeId';
      var statisticResponse = await http.get(Uri.parse(url));

      if (statisticResponse.statusCode == 200) {
        var statisticData = json.decode(statisticResponse.body);

        if (statisticData['StatusCode'] == 200) {
          setState(() {
            myLoan = statisticData['Data']['myLoan'];
            totalMyLoan = statisticData['Data']['myTotalLoan'];
            totalLoan = statisticData['Data']['totalLoan'];
          });
        } else {
          print('Data fetch was successful but server returned an error: ${statisticData['Status']}');
        }
      } else {
        print('Failed to load data: ${statisticResponse.statusCode}');
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

      String apiUrlPinjamanKaryawan = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/loan/getloan.php?action=3';
      var responsePinjamanKaryawan = await http.get(Uri.parse(apiUrlPinjamanKaryawan));

      if (responsePinjamanKaryawan.statusCode == 200) {
        var dataPinjamanKaryawan = json.decode(responsePinjamanKaryawan.body);

        setState(() {
          LoanList = List<Map<String, dynamic>>.from(dataPinjamanKaryawan['Data']);
      
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
                        if(positionId != 'POS-HR-002')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Card(
                                shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12))),
                                color: Colors.white,
                                shadowColor: Colors.black,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.36,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 4.sp, top: 4.sp, bottom: 4.sp, right: 4.sp),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Jumlah Pinjaman saya', style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w400,)),
                                        SizedBox(height: 5.h,),
                                        Text(myLoan, style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)),
                                      ],
                                    ),
                                  )
                                ),
                              ),
                              SizedBox(width: 6.w,),
                              Card(
                                shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12))),
                                color: Colors.white,
                                shadowColor: Colors.black,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.36,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 4.sp, top: 4.sp, bottom: 4.sp, right: 4.sp),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Total Pinjaman Saya', style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w400,)),
                                        SizedBox(height: 5.h,),
                                        Text(formatCurrency2(totalMyLoan), style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)),
                                      ],
                                    ),
                                  )
                                ),
                              ),
                            ],
                          ),
                        if(positionId != 'POS-HR-002')
                          SizedBox(height: 10.sp,),
                        if(positionId != 'POS-HR-002' && positionId != 'POS-HR-001' && positionId != 'POS-HR-004' && positionId != 'POS-HR-024' && positionId != 'POS-HR-008')
                          Card(
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                            color: Colors.white,
                            shadowColor: Colors.black,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Padding(
                                padding: EdgeInsets.only(left: 4.sp, top: 4.sp, bottom: 4.sp, right: 4.sp),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Pinjaman Saya',style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w700,)),
                                            SizedBox(height: 1.sp,),
                                            Text( 'Kelola pinjaman saya', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w300,)),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                              Get.to(const ViewAllMyPinjaman());
                                              // Get.to(ViewMyPerjalananDinas());
                                              // Get.to(const allMyInventoryRequest());
                                          },
                                          child: Text('Lihat semua', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w400, color: const Color(0xFF2A85FF)))
                                        )
                                      ],
                                    ),
                                    SizedBox( height: 7.sp,),
                                    for (int indexA = 0; indexA < 3; indexA++)
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(PinjamanKaryawanDetail(pinjamanKaryawanID: myLoanList[indexA]['loan_id'], jumlahPinjaman: myLoanList[indexA]['loan_amount'], alasanPinjaman: myLoanList[indexA]['loan_reason'], caraBayarPinjaman: myLoanList[indexA]['loan_topay'], statusPinjaman: myLoanList[indexA]['status_name'], sudahLunasPinjaman: myLoanList[indexA]['is_paid'], tanggalPengajuan: myLoanList[indexA]['insert_dt'], namaKaryawan: myLoanList[indexA]['employee_name'], requestorID: myLoanList[indexA]['insert_by'], jabatan: myLoanList[indexA]['position_name'], departemen: myLoanList[indexA]['department_name'],));
                                                },
                                                child: Card(
                                                  child: ListTile(
                                                    title: Text(
                                                      indexA < myLoanList.length
                                                          ? '${myLoanList[indexA]['employee_name']}'
                                                          : '-',
                                                      style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    subtitle: Text(
                                                      indexA < myLoanList.length
                                                          ? formatCurrency2(myLoanList[indexA]['loan_amount'])
                                                          : '-',
                                                      style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),
                                                    ),
                                                    trailing: Text(
                                                      indexA < myLoanList.length
                                                          ? '${myLoanList[indexA]['status_name']}'
                                                          : '-',
                                                      style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 5.sp,),
                                            ],
                                          ),
                                  ],
                                ),
                              )
                            ),
                          ),
                        if(positionId == 'POS-HR-002')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Card(
                                shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12))),
                                color: Colors.white,
                                shadowColor: Colors.black,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.24,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 7.sp, top: 5.sp, bottom: 5.sp, right: 7.sp),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Jumlah Pinjaman saya', style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w400,)),
                                        SizedBox(height: 5.h,),
                                        Text(myLoan, style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)),
                                      ],
                                    ),
                                  )
                                ),
                              ),
                              Card(
                                shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12))),
                                color: Colors.white,
                                shadowColor: Colors.black,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.24,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 7.sp, top: 5.sp, bottom: 5.sp, right: 7.sp),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Total Pinjaman Saya', style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w400,)),
                                        SizedBox(height: 5.h,),
                                        Text(formatCurrency2(totalMyLoan), style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)),
                                      ],
                                    ),
                                  )
                                ),
                              ),
                              Card(
                                shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12))),
                                color: Colors.white,
                                shadowColor: Colors.black,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.24,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 7.sp, top: 5.sp, bottom: 5.sp, right: 7.sp),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Total Pinjaman', style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w400,)),
                                        SizedBox(height: 5.h,),
                                        Text(formatCurrency2(totalLoan), style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)),
                                      ],
                                    ),
                                  )
                                ),
                              ),
                            ],
                          ),
                        if(positionId == 'POS-HR-002' || positionId != 'POS-HR-001' || positionId != 'POS-HR-004' || positionId != 'POS-HR-024' || positionId != 'POS-HR-008')
                          SizedBox(height: 10.sp,),
                        if(positionId == 'POS-HR-002' || positionId == 'POS-HR-001' || positionId == 'POS-HR-004' || positionId == 'POS-HR-024' || positionId == 'POS-HR-008')
                          Row(
                            children: [
                              Card(
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                                color: Colors.white,
                                shadowColor: Colors.black,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.35,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 4.sp, top: 4.sp, bottom: 4.sp, right: 4.sp),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Pinjaman Saya',style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w700,)),
                                                SizedBox(height: 1.sp,),
                                                Text( 'Kelola pinjaman saya', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w300,)),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                  Get.to(const ViewAllMyPinjaman());
                                              },
                                              child: Text('Lihat semua', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w400, color: const Color(0xFF2A85FF)))
                                            )
                                          ],
                                        ),
                                        SizedBox( height: 7.sp,),
                                        for (int indexA = 0; indexA < 3; indexA++)
                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.to(PinjamanKaryawanDetail(pinjamanKaryawanID: myLoanList[indexA]['loan_id'], jumlahPinjaman: myLoanList[indexA]['loan_amount'], alasanPinjaman: myLoanList[indexA]['loan_reason'], caraBayarPinjaman: myLoanList[indexA]['loan_topay'], statusPinjaman: myLoanList[indexA]['status_name'], sudahLunasPinjaman: myLoanList[indexA]['is_paid'], tanggalPengajuan: myLoanList[indexA]['insert_dt'], namaKaryawan: myLoanList[indexA]['employee_name'], requestorID: myLoanList[indexA]['insert_by'], jabatan: myLoanList[indexA]['position_name'], departemen: myLoanList[indexA]['department_name'],));
                                                    },
                                                    child: Card(
                                                      child: ListTile(
                                                        title: Text(indexA < myLoanList.length ? '${myLoanList[indexA]['employee_name']}' : '-',
                                                          style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                        subtitle: Text(indexA < myLoanList.length ? formatCurrency2(myLoanList[indexA]['loan_amount']) : '-',
                                                          style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),
                                                        ),
                                                        trailing: Text(indexA < myLoanList.length ? '${myLoanList[indexA]['status_name']}' : '-',
                                                          style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5.sp,),
                                                ],
                                              ),
                                      ],
                                    ),
                                  )
                                ),
                              ),
                              SizedBox(width: 10.w,),
                              Card(
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                                color: Colors.white,
                                shadowColor: Colors.black,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.35,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 4.sp, top: 4.sp, bottom: 4.sp, right: 4.sp),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Pinjaman Karyawan',style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w700,)),
                                                SizedBox(height: 1.sp,),
                                                Text( 'Kelola pinjaman karyawan', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w300,)),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                  Get.to(const ViewAllPinjaman());
                                              },
                                              child: Text('Lihat semua', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w400, color: const Color(0xFF2A85FF)))
                                            )
                                          ],
                                        ),
                                        SizedBox( height: 7.sp,),
                                        for (int indexB = 0; indexB < 3; indexB++)
                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.to(PinjamanKaryawanDetail(pinjamanKaryawanID: LoanList[indexB]['loan_id'], jumlahPinjaman: LoanList[indexB]['loan_amount'], alasanPinjaman: LoanList[indexB]['loan_reason'], caraBayarPinjaman: LoanList[indexB]['loan_topay'], statusPinjaman: LoanList[indexB]['status_name'], sudahLunasPinjaman: LoanList[indexB]['is_paid'], tanggalPengajuan: LoanList[indexB]['insert_dt'], namaKaryawan: LoanList[indexB]['employee_name'], requestorID: LoanList[indexB]['insert_by'], jabatan:  LoanList[indexB]['position_name'], departemen: LoanList[indexB]['department_name'],));
                                                    },
                                                    child: Card(
                                                      child: ListTile(
                                                        title: Text( indexB < LoanList.length? '${LoanList[indexB]['employee_name']}' : '-',
                                                          style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                        subtitle: Text( indexB < LoanList.length ? formatCurrency2(LoanList[indexB]['loan_amount']) : '-',
                                                          style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),
                                                        ),
                                                        trailing: Text( indexB < LoanList.length ? '${LoanList[indexB]['status_name']}' : '-',
                                                          style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5.sp,),
                                                ],
                                              ),
                                      ],
                                    ),
                                  )
                                ),
                              ),
                            ],
                          ),
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