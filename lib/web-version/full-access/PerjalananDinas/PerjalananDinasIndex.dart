// ignore_for_file: non_constant_identifier_names, avoid_print, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/AddNewPerjalananDinas.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/ViewAllApprovalLPD.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/ViewAllApprovalPerjalananDinas.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/ViewLPD.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/ViewMyLPD.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/ViewMyPerjalananDinas.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/ViewPerjalananDinas.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PerjalananDinasIndex extends StatefulWidget {
  const PerjalananDinasIndex({super.key});

  @override
  State<PerjalananDinasIndex> createState() => _PerjalananDinasIndexState();
}

class _PerjalananDinasIndexState extends State<PerjalananDinasIndex> {
  String? leaveoptions;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  bool isLoading = false;

  List<Map<String, dynamic>> noticationList = [];
  List<Map<String, dynamic>> myBusinessTrip = [];
  List<Map<String, dynamic>> businessTripHRDApproval = [];
  List<Map<String, dynamic>> businessTripManagerApproval = [];
  List<Map<String, dynamic>> myLPD = [];
  List<Map<String, dynamic>> LPDApproval = [];

  String myBusinessTripStatistic = '0';
  String myLDStatistic = '0';
  String needApprovalStatistic = '0';
  String allBusinessTripStatistic = '0';

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

      String url = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/getperjalanandinas.php?action=12&employee_id=$employeeId';
      var statisticResponse = await http.get(Uri.parse(url));

      if (statisticResponse.statusCode == 200) {
        var statisticData = json.decode(statisticResponse.body);

        if (statisticData['StatusCode'] == 200) {
          setState(() {
            myBusinessTripStatistic = statisticData['Data']['myBusinessTrip'];
            myLDStatistic = statisticData['Data']['myLPD'];
            needApprovalStatistic = statisticData['Data']['needApproval'];
            allBusinessTripStatistic = statisticData['Data']['allBusinessTrip'];
          });
        } else {
          print('Data fetch was successful but server returned an error: ${statisticData['Status']}');
        }
      } else {
        print('Failed to load data: ${statisticResponse.statusCode}');
      }

      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/getperjalanandinas.php?action=6&employee_id=$employeeId';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          myBusinessTrip = List<Map<String, dynamic>>.from(data['Data']);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }

      String hrdapiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/getperjalanandinas.php?action=7';
      var hrdResponse = await http.get(Uri.parse(hrdapiUrl));

      if (hrdResponse.statusCode == 200) {
        var hrdData = json.decode(hrdResponse.body);

        setState(() {
          businessTripHRDApproval = List<Map<String, dynamic>>.from(hrdData['Data']);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }

      String mylpdUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/getlpd.php?action=2&employee_id=$employeeId';
      var mylpdResponse = await http.get(Uri.parse(mylpdUrl));

      if (mylpdResponse.statusCode == 200) {
        var mylpdData = json.decode(mylpdResponse.body);

        setState(() {
          myLPD = List<Map<String, dynamic>>.from(mylpdData['Data']);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }

      String lpdApprovalUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/getlpd.php?action=3';
      var lpdApprovalResponse = await http.get(Uri.parse(lpdApprovalUrl));

      if (lpdApprovalResponse.statusCode == 200) {
        var lpdApprovalData = json.decode(lpdApprovalResponse.body);

        setState(() {
          LPDApproval = List<Map<String, dynamic>>.from(lpdApprovalData['Data']);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
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

    // print(positionId);
    // print(employeeSPV);

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: (){
                                Get.to(const AddNewPerjalananDinas());
                              }, 
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                alignment: Alignment.center,
                                minimumSize: Size(40.w, 55.h),
                                foregroundColor: const Color(0xFFFFFFFF),
                                backgroundColor: const Color(0xff4ec3fc),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Tambah Perjalanan Dinas')
                            )
                          ],
                        ),
                        SizedBox(height: 10.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                              shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12))),
                              color: Colors.white,
                              shadowColor: Colors.black,
                              child: SizedBox(
                                width: (MediaQuery.of(context).size.width - 125.w) / 4,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 7.sp, top: 5.sp, bottom: 5.sp, right: 7.sp),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Perjalanan Dinas Saya', style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w400,)),
                                      SizedBox(height: 5.h,),
                                      Text(myBusinessTripStatistic, style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)),
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
                                width: (MediaQuery.of(context).size.width - 125.w) / 4,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 7.sp, top: 5.sp, bottom: 5.sp, right: 7.sp),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('LPD\nSaya', style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w400,)),
                                      SizedBox(height: 5.h,),
                                      Text(myLDStatistic, style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)),
                                    ],
                                  ),
                                )
                              ),
                            ),
                            if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008')
                              Card(
                                shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12))),
                                color: Colors.white,
                                shadowColor: Colors.black,
                                child: SizedBox(
                                  width: (MediaQuery.of(context).size.width - 125.w) / 4,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 7.sp, top: 5.sp, bottom: 5.sp, right: 7.sp),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Butuh\npersetujuan', style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w400,)),
                                        SizedBox(height: 5.h,),
                                        Text(needApprovalStatistic, style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)),
                                      ],
                                    ),
                                  )
                                ),
                              ),
                            if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008')                              
                              Card(
                                shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12))),
                                color: Colors.white,
                                shadowColor: Colors.black,
                                child: SizedBox(
                                  width: (MediaQuery.of(context).size.width - 125.w) / 4,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 7.sp, top: 5.sp, bottom: 5.sp, right: 7.sp),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Total Perjalanan Dinas', style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w400,)),
                                        SizedBox(height: 5.h,),
                                        Text(allBusinessTripStatistic, style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)),
                                      ],
                                    ),
                                  )
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 10.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                              shape: const RoundedRectangleBorder( 
                                borderRadius: BorderRadius.all(Radius.circular(12))
                              ),
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
                                                Text('Perjalanan Dinas Saya',style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w700,)),
                                                SizedBox(height: 1.sp,),
                                                Text( 'Kelola perjalanan dinas saya', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w300,)),
                                              ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(const ViewMyPerjalananDinas());
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
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.to(ViewPerjalananDinas(perjalananDinasID: myBusinessTrip[indexA]['businesstrip_id'], 
                                                      perjalananDinasStatus: myBusinessTrip[indexA]['status_name'], 
                                                      tanggalPermohonan: myBusinessTrip[indexA]['insert_dt'], 
                                                      namaKota: myBusinessTrip[indexA]['nama_kota'], 
                                                      lamaDurasi: myBusinessTrip[indexA]['duration_name'], 
                                                      keterangan: myBusinessTrip[indexA]['reason'], 
                                                      tim: myBusinessTrip[indexA]['team'], 
                                                      pembayaran: myBusinessTrip[indexA]['payment_name'], 
                                                      tranportasi: myBusinessTrip[indexA]['transport_name'], namaKaryawan: myBusinessTrip[indexA]['employee_name'], namaDepartemen: myBusinessTrip[indexA]['department_name'], requestorID: myBusinessTrip[indexA]['insert_by'],));
                                                      // Get.to(DetailInventoryRequest('${myRequestInventory[indexA]['request_id']}'));
                                                    },
                                                  );
                                                },
                                                child: Card(
                                                  child: ListTile(
                                                    title: Text(
                                                      indexA < myBusinessTrip.length
                                                          ? '${myBusinessTrip[indexA]['employee_name']}'
                                                          : '-',
                                                      style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    subtitle: Text(
                                                      indexA < myBusinessTrip.length
                                                          ? '${myBusinessTrip[indexA]['nama_kota']} (${myBusinessTrip[indexA]['duration_name']})'
                                                          : '-',
                                                      style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),
                                                    ),
                                                    trailing: Text(
                                                      indexA < myBusinessTrip.length
                                                          ? '${myBusinessTrip[indexA]['status_name']}'
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
                                ),
                              ),
                            ),
                            if(positionId == 'POS-HR-002' || positionId == 'POS-HR-001' || positionId == 'POS-HR-004' || positionId == 'POS-HR-024' || positionId == 'POS-HR-008')
                              Card(
                                shape: const RoundedRectangleBorder( 
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                                ),
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
                                                  Text('Perjalanan Dinas Karyawan',style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w700,)),
                                                  SizedBox(height: 1.sp,),
                                                  Text( 'Kelola perjalanan dinas karyawan', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w300,)),
                                                ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(const ViewAllApprovalPerjalananDinas());
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
                                                    Get.to(ViewPerjalananDinas(perjalananDinasID: businessTripHRDApproval[indexB]['businesstrip_id'], 
                                                  perjalananDinasStatus: businessTripHRDApproval[indexB]['status_name'], 
                                                  tanggalPermohonan: businessTripHRDApproval[indexB]['insert_dt'], 
                                                  namaKota: businessTripHRDApproval[indexB]['nama_kota'], 
                                                  lamaDurasi: businessTripHRDApproval[indexB]['duration_name'], 
                                                  keterangan: businessTripHRDApproval[indexB]['reason'], 
                                                  tim: businessTripHRDApproval[indexB]['team'], 
                                                  pembayaran: businessTripHRDApproval[indexB]['payment_name'], 
                                                  tranportasi: businessTripHRDApproval[indexB]['transport_name'], namaKaryawan: businessTripHRDApproval[indexB]['employee_name'], namaDepartemen: businessTripHRDApproval[indexB]['department_name'], requestorID: businessTripHRDApproval[indexB]['insert_by'],));
                                                  },
                                                  child: Card(
                                                  child: ListTile(
                                                    title: Text(
                                                      indexB < businessTripHRDApproval.length
                                                          ? '${businessTripHRDApproval[indexB]['employee_name']}'
                                                          : '-',
                                                      style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    subtitle: Text(
                                                      indexB < businessTripHRDApproval.length
                                                          ? '${businessTripHRDApproval[indexB]['nama_kota']} (${businessTripHRDApproval[indexB]['duration_name']})'
                                                          : '-',
                                                      style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),
                                                    ),
                                                    trailing: Text(
                                                      indexB < businessTripHRDApproval.length
                                                          ? '${businessTripHRDApproval[indexB]['status_name']}'
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
                                  ),
                                ),
                              ),
                            if(positionId != 'POS-HR-002' && positionId != 'POS-HR-001' && positionId != 'POS-HR-004' && positionId != 'POS-HR-024' && positionId != 'POS-HR-008')
                              Card(
                                shape: const RoundedRectangleBorder( 
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                                ),
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
                                                  Text('LPD Saya',style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w700,)),
                                                  SizedBox(height: 1.sp,),
                                                  Text( 'Kelola laporan perjalan dinas saya', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w300,)),
                                                ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(const ViewMyLPD());
                                                // Get.to(ViewLPD(businessTripID: businessTripID));
                                                // Get.to(const allMyInventoryRequest());
                                              },
                                              child: Text('Lihat semua', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w400, color: const Color(0xFF2A85FF)))
                                            )
                                          ],
                                        ),
                                        SizedBox( height: 7.sp,),
                                        for (int indexC = 0; indexC < 3; indexC++)
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(ViewLPD(businessTripID: myLPD[indexC]['businesstrip_id']));
                                                },
                                                child: Card(
                                                  child: ListTile(
                                                    title: Text(
                                                      indexC < myLPD.length
                                                          ? '${myLPD[indexC]['employee_name']}'
                                                          : '-',
                                                      style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    subtitle: Text(
                                                      indexC < myLPD.length
                                                          ? '${myLPD[indexC]['name']} (${myLPD[indexC]['project_name']})'
                                                          : '-',
                                                      style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),
                                                    ),
                                                    trailing: Text(
                                                      indexC < myLPD.length
                                                          ? '${myLPD[indexC]['status_name']}'
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
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 10.sp,),
                        if(positionId == 'POS-HR-002' || positionId == 'POS-HR-001' || positionId == 'POS-HR-004' || positionId == 'POS-HR-024' || positionId == 'POS-HR-008')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Card(
                                shape: const RoundedRectangleBorder( 
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                                ),
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
                                                  Text('LPD Saya',style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w700,)),
                                                  SizedBox(height: 1.sp,),
                                                  Text( 'Kelola laporan perjalan dinas saya', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w300,)),
                                                ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(const ViewMyLPD());
                                                // Get.to(ViewLPD(businessTripID: businessTripID));
                                                // Get.to(const allMyInventoryRequest());
                                              },
                                              child: Text('Lihat semua', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w400, color: const Color(0xFF2A85FF)))
                                            )
                                          ],
                                        ),
                                        SizedBox( height: 7.sp,),
                                        for (int indexD = 0; indexD < 3; indexD++)
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(ViewLPD(businessTripID: myLPD[indexD]['businesstrip_id']));
                                                },
                                                child: Card(
                                                  child: ListTile(
                                                    title: Text(
                                                      indexD < myLPD.length
                                                          ? '${myLPD[indexD]['employee_name']}'
                                                          : '-',
                                                      style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    subtitle: Text(
                                                      indexD < myLPD.length
                                                          ? '${myLPD[indexD]['name']} (${myLPD[indexD]['project_name']})'
                                                          : '-',
                                                      style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),
                                                    ),
                                                    trailing: Text(
                                                      indexD < myLPD.length
                                                          ? '${myLPD[indexD]['status_name']}'
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
                                  ),
                                ),
                              ),
                              Card(
                                shape: const RoundedRectangleBorder( 
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                                ),
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
                                                  Text('Persetujuan LPD',style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w700,)),
                                                  SizedBox(height: 1.sp,),
                                                  Text('Kelola LPD bawahan anda', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w300,)),
                                                ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(const ViewAllApprovalLPD());
                                              },
                                              child: Text('Lihat semua', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w400, color: const Color(0xFF2A85FF)))
                                            )
                                          ],
                                        ),
                                        SizedBox( height: 7.sp,),
                                        for (int indexE = 0; indexE < 3; indexE++)
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(ViewLPD(businessTripID: LPDApproval[indexE]['businesstrip_id']));
                                                },
                                                child: Card(
                                                  child: ListTile(
                                                    title: Text(
                                                      indexE < LPDApproval.length
                                                          ? '${LPDApproval[indexE]['employee_name']}'
                                                          : '-',
                                                      style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    subtitle: Text(
                                                      indexE < LPDApproval.length
                                                          ? '${LPDApproval[indexE]['name']} (${LPDApproval[indexE]['project_name']})'
                                                          : '-',
                                                      style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),
                                                    ),
                                                    trailing: Text(
                                                      indexE < LPDApproval.length
                                                          ? '${LPDApproval[indexE]['status_name']}'
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
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if(positionId == 'POS-HR-002' || positionId == 'POS-HR-001' || positionId == 'POS-HR-004' || positionId == 'POS-HR-024' || positionId == 'POS-HR-008')
                          SizedBox(height: 10.sp,),
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