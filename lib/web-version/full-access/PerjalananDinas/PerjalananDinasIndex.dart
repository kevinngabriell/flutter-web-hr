import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Event/event.dart';
import 'package:hr_systems_web/web-version/full-access/Performance/performance.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/AddNewPerjalananDinas.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/ViewAllApprovalLPD.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/ViewAllApprovalPerjalananDinas.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/ViewLPD.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/ViewMyLPD.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/ViewMyPerjalananDinas.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/ViewPerjalananDinas.dart';
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
                        SizedBox(height: 15.sp,),
                        Row(
                          children: [
                            Card(
                              shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12))),
                              color: Colors.white,
                              shadowColor: Colors.black,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.17,
                                child: Padding(
                                  padding: EdgeInsets.all(15.0.sp),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Perjalanan Dinas Saya', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400,)),
                                      SizedBox(height: 5.h,),
                                      Text(myBusinessTripStatistic, style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w700,)),
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
                                width: MediaQuery.of(context).size.width * 0.17,
                                child: Padding(
                                  padding: EdgeInsets.all(15.0.sp),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('LPD saya', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400,)),
                                      SizedBox(height: 5.h,),
                                      Text(myLDStatistic, style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w700,)),
                                    ],
                                  ),
                                )
                              ),
                            ),
                            SizedBox(width: 6.w,),
                            if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008')
                              Card(
                                shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12))),
                                color: Colors.white,
                                shadowColor: Colors.black,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.17,
                                  child: Padding(
                                    padding: EdgeInsets.all(15.0.sp),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Butuh persetujuan', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400,)),
                                        SizedBox(height: 5.h,),
                                        Text(needApprovalStatistic, style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w700,)),
                                      ],
                                    ),
                                  )
                                ),
                              ),
                            SizedBox(width: 6.w,),
                            if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008')                              
                              Card(
                                shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12))),
                                color: Colors.white,
                                shadowColor: Colors.black,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.17,
                                  child: Padding(
                                    padding: EdgeInsets.all(15.0.sp),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Total Perjalanan Dinas', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400,)),
                                        SizedBox(height: 5.h,),
                                        Text(allBusinessTripStatistic, style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w700,)),
                                      ],
                                    ),
                                  )
                                ),
                              )
                          ],
                        ),
                        SizedBox(height: 30.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 98.w) / 2,
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(15.0.sp),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Perjalanan Dinas Saya',style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700,)),
                                                SizedBox(height: 5.sp,),
                                                Text( 'Kelola perjalanan dinas saya', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300,)),
                                              ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(ViewMyPerjalananDinas());
                                              // Get.to(const allMyInventoryRequest());
                                            },
                                            child: Text('Lihat semua', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: const Color(0xFF2A85FF)))
                                          )
                                        ],
                                      ),
                                      for (int indexA = 0; indexA < 3; indexA++)
                                          Column(
                                            children: [
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
                                                child: Card(
                                                  child: ListTile(
                                                    title: Text(
                                                      indexA < myBusinessTrip.length
                                                          ? '${myBusinessTrip[indexA]['employee_name']}'
                                                          : '-',
                                                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    subtitle: Text(
                                                      indexA < myBusinessTrip.length
                                                          ? '${myBusinessTrip[indexA]['nama_kota']} (${myBusinessTrip[indexA]['duration_name']})'
                                                          : '-',
                                                      style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400),
                                                    ),
                                                    trailing: Text(
                                                      indexA < myBusinessTrip.length
                                                          ? '${myBusinessTrip[indexA]['status_name']}'
                                                          : '-',
                                                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10.sp,),
                                            ],
                                          ),
                                      // Text('Permintaan Saya',style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700,)),
                                      // SizedBox(height: 5.sp,),
                                      // Text( 'Kelola permintaan inventaris saya', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300,)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w,),
                            if(positionId == 'POS-HR-002' || positionId == 'POS-HR-001' || positionId == 'POS-HR-004' || positionId == 'POS-HR-024' || positionId == 'POS-HR-008')
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 98.w) / 2,
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(15.0.sp),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Perjalanan Dinas Karyawan',style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700,)),
                                                  SizedBox(height: 5.sp,),
                                                  Text( 'Kelola perjalanan dinas karyawan', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300,)),
                                                ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(ViewAllApprovalPerjalananDinas());
                                                // Get.to(const allMyInventoryRequest());
                                              },
                                              child: Text('Lihat semua', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: const Color(0xFF2A85FF)))
                                            )
                                          ],
                                        ),
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
                                                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    subtitle: Text(
                                                      indexB < businessTripHRDApproval.length
                                                          ? '${businessTripHRDApproval[indexB]['nama_kota']} (${businessTripHRDApproval[indexB]['duration_name']})'
                                                          : '-',
                                                      style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400),
                                                    ),
                                                    trailing: Text(
                                                      indexB < businessTripHRDApproval.length
                                                          ? '${businessTripHRDApproval[indexB]['status_name']}'
                                                          : '-',
                                                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                ),
                                                ),
                                                SizedBox(height: 10.sp,),
                                              ],
                                            ),
                                        // Text('Permintaan Saya',style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700,)),
                                        // SizedBox(height: 5.sp,),
                                        // Text( 'Kelola permintaan inventaris saya', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300,)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            if(positionId != 'POS-HR-002' && positionId != 'POS-HR-001' && positionId != 'POS-HR-004' && positionId != 'POS-HR-024' && positionId != 'POS-HR-008')
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 98.w) / 2,
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(15.0.sp),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('LPD Saya',style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700,)),
                                                  SizedBox(height: 5.sp,),
                                                  Text( 'Kelola laporan perjalan dinas saya', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300,)),
                                                ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(ViewMyLPD());
                                                // Get.to(ViewLPD(businessTripID: businessTripID));
                                                // Get.to(const allMyInventoryRequest());
                                              },
                                              child: Text('Lihat semua', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: const Color(0xFF2A85FF)))
                                            )
                                          ],
                                        ),
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
                                                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    subtitle: Text(
                                                      indexC < myLPD.length
                                                          ? '${myLPD[indexC]['name']} (${myLPD[indexC]['project_name']})'
                                                          : '-',
                                                      style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400),
                                                    ),
                                                    trailing: Text(
                                                      indexC < myLPD.length
                                                          ? '${myLPD[indexC]['status_name']}'
                                                          : '-',
                                                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10.sp,),
                                            ],
                                          ),
                                      ]
                                    )
                                  )
                                ),
                              )
                          ],
                        ),
                        SizedBox(height: 30.sp,),
                        if(positionId == 'POS-HR-002' || positionId == 'POS-HR-001' || positionId == 'POS-HR-004' || positionId == 'POS-HR-024' || positionId == 'POS-HR-008')
                          Row(
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 98.w) / 2,
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(15.0.sp),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('LPD Saya',style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700,)),
                                                  SizedBox(height: 5.sp,),
                                                  Text( 'Kelola laporan perjalan dinas saya', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300,)),
                                                ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(ViewMyLPD());
                                                // Get.to(const allMyInventoryRequest());
                                              },
                                              child: Text('Lihat semua', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: const Color(0xFF2A85FF)))
                                            )
                                          ],
                                        ),
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
                                                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    subtitle: Text(
                                                      indexD < myLPD.length
                                                          ? '${myLPD[indexD]['name']} (${myLPD[indexD]['project_name']})'
                                                          : '-',
                                                      style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400),
                                                    ),
                                                    trailing: Text(
                                                      indexD < myLPD.length
                                                          ? '${myLPD[indexD]['status_name']}'
                                                          : '-',
                                                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10.sp,),
                                            ],
                                          ),
                                      ]
                                    )
                                  )
                                ),
                              ),
                              SizedBox(width: 10.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 98.w) / 2,
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(15.0.sp),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Persetujuan LPD',style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700,)),
                                                  SizedBox(height: 5.sp,),
                                                  Text('Kelola dan berikan persetujuan anda pada LPD bawahan anda', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300,)),
                                                ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(ViewAllApprovalLPD());
                                                // Get.to(const allMyInventoryRequest());
                                              },
                                              child: Text('Lihat semua', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: const Color(0xFF2A85FF)))
                                            )
                                          ],
                                        ),
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
                                                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    subtitle: Text(
                                                      indexE < LPDApproval.length
                                                          ? '${LPDApproval[indexE]['name']} (${LPDApproval[indexE]['project_name']})'
                                                          : '-',
                                                      style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400),
                                                    ),
                                                    trailing: Text(
                                                      indexE < LPDApproval.length
                                                          ? '${LPDApproval[indexE]['status_name']}'
                                                          : '-',
                                                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10.sp,),
                                            ],
                                          ),
                                      ]
                                    )
                                  )
                                ),
                              )
                            ],
                          ),
                        if(positionId == 'POS-HR-002' || positionId == 'POS-HR-001' || positionId == 'POS-HR-004' || positionId == 'POS-HR-024' || positionId == 'POS-HR-008')
                          SizedBox(height: 30.sp,),
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

    // Format the date as "dd MMMM yyyy"
    return DateFormat("d MMMM yyyy HH:mm").format(parsedDate);
  }
}