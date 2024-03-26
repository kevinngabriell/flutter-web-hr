import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Event/event.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/addNewInventory.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/alIInventory.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/allApprovalInventoryRequest.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/allMyInventory.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/allMyInventoryRequest.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/detailInventory.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/detailInventoryRequest.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/newInventoryRequest.dart';
import 'package:hr_systems_web/web-version/full-access/Performance/performance.dart';
import 'package:hr_systems_web/web-version/full-access/Report/report.dart';
import 'package:hr_systems_web/web-version/full-access/Salary/salary.dart';
import 'package:hr_systems_web/web-version/full-access/Settings/setting.dart';
import 'package:hr_systems_web/web-version/full-access/Structure/structure.dart';
import 'package:hr_systems_web/web-version/full-access/Training/traning.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../login.dart';
import '../employee.dart';
import '../index.dart';

class InventoryIndex extends StatefulWidget {
  const InventoryIndex({super.key});

  @override
  State<InventoryIndex> createState() => _InventoryIndexState();
}

class _InventoryIndexState extends State<InventoryIndex> {
  String? leaveoptions;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  bool isLaoding = false;

  List<Map<String, dynamic>> myRequestInventory = [];
  List<Map<String, dynamic>> myInventory = [];
  List<Map<String, dynamic>> companyInventory = [];
  List<Map<String, dynamic>> approvalRequestInventory = [];

  String angkaPermintaanSaya = '0';
  String inventarisSaya = '0';
  String butuhPersetujuan = '0';
  String barangTidakTerpakai = '0';

  String selectedMenu = 'menu1';

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchTopMyRequest();
    fetchTopApprovalRequest();
    fetchMyInventory();
    fetchAllInventory();
  }

  Future<void> fetchData() async {
    String employeeId = storage.read('employee_id').toString();
    isLaoding = true;
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
      isLaoding = false;
    }
  }

  Future<void> fetchTopMyRequest() async{
    String employeeId = storage.read('employee_id').toString();
    setState(() {
      isLaoding = true;
    });

    try{  
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/mytoprequest.php?employee_id=$employeeId';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          myRequestInventory = List<Map<String, dynamic>>.from(data['Data']);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }

      String url = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/getinventory.php?action=12&employee_id=$employeeId';
      var statisticResponse = await http.get(Uri.parse(url));

      if (statisticResponse.statusCode == 200) {
        var statisticData = json.decode(statisticResponse.body);

        if (statisticData['StatusCode'] == 200) {
          setState(() {
            angkaPermintaanSaya = statisticData['Data']['myRequest'];
            inventarisSaya = statisticData['Data']['myInventory'];
            butuhPersetujuan = statisticData['Data']['needApproval'];
            barangTidakTerpakai = statisticData['Data']['inactiveInventory'];
          });
        } else {
          print('Data fetch was successful but server returned an error: ${statisticData['Status']}');
        }
      } else {
        print('Failed to load data: ${statisticResponse.statusCode}');
      }


    } catch (e){
      print('Error: $e');
    } finally {
      setState(() {
        isLaoding = false;
      });
    }
  }

  Future<void> fetchTopApprovalRequest() async{
    setState(() {
      isLaoding = true;
    });

    try{  
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/approvaltoprequest.php';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          approvalRequestInventory = List<Map<String, dynamic>>.from(data['Data']);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }

    } catch (e){
      print('Error: $e');
    } finally {
      setState(() {
        isLaoding = false;
      });
    }
  }

  Future<void> fetchMyInventory() async {
    String employeeId = storage.read('employee_id').toString();
    try{
      isLaoding = true;

      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/getinventory.php?action=7&employee_id=$employeeId';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          myInventory = List<Map<String, dynamic>>.from(data['Data']);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch(e) {
      print('Error at fetching my inventory $e');
    } finally {
      isLaoding = false;
    }
  }

  Future<void> fetchAllInventory() async {
    String employeeId = storage.read('employee_id').toString();
    try{
      isLaoding = true;

      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/getinventory.php?action=8';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          companyInventory = List<Map<String, dynamic>>.from(data['Data']);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch(e) {
      print('Error at fetching my inventory $e');
    } finally {
      isLaoding = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    var employeeId = storage.read('employee_id');
    var photo = storage.read('photo');
    var positionId = storage.read('position_id');
    
    return MaterialApp(
      title: 'Inventaris',
      home: SafeArea(
        child: Scaffold(
          body: isLaoding ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
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
                          "$companyName",
                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w300),
                        ),
                        subtitle: Text(
                          '$trimmedCompanyAddress',
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
                        SizedBox(height: 15.sp,),
                        //Profile Name
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 5,
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
                                subtitle: Text('$employeeEmail',
                                  style: TextStyle( fontSize: 15.sp, fontWeight: FontWeight.w300,),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008')
                              ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context, 
                                      builder: (context){
                                        return AlertDialog(
                                          title: const Text('Menu Inventaris'),
                                          content: DropdownButtonFormField(
                                            value: selectedMenu,
                                            items: const [
                                              DropdownMenuItem(
                                                value: 'menu1',
                                                child: Text('Permintaan Inventaris Baru')
                                              ),
                                              DropdownMenuItem(
                                                value: 'menu2',
                                                child: Text('Tambah Inventaris')
                                              )
                                            ],
                                            onChanged: (value){
                                              selectedMenu = value.toString();
                                            },
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
                                                if(selectedMenu == 'menu1'){
                                                  Get.to(const NewInventoryRequest());
                                                } else if (selectedMenu == 'menu2'){
                                                  Get.to(const addNewInventory());
                                                }
                                              }, 
                                              child: const Text('Oke')
                                            )
                                          ],
                                        );
                                      }
                                    );
                                    // Get.to(const addNewInventory());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    alignment: Alignment.center,
                                    minimumSize: Size(50.w, 45.h),
                                    foregroundColor: const Color(0xFFFFFFFF),
                                    backgroundColor: const Color(0xff4ec3fc),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('Tambah',
                                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,)
                                      ),
                                    ],
                                  )
                                ),
                          ],
                        ),
                        SizedBox(height: 30.sp,),
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
                                      Text('Permintaan saya', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400,)),
                                      SizedBox(height: 5.h,),
                                      Text(angkaPermintaanSaya, style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w700,)),
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
                                      Text('Inventaris saya', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400,)),
                                      SizedBox(height: 5.h,),
                                      Text(inventarisSaya, style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w700,)),
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
                                        Text(butuhPersetujuan, style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w700,)),
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
                                        Text('Inventaris Non-Aktif', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400,)),
                                        SizedBox(height: 5.h,),
                                        Text(barangTidakTerpakai, style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w700,)),
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
                                                Text('Permintaan Saya',style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700,)),
                                                SizedBox(height: 5.sp,),
                                                Text( 'Kelola permintaan inventaris saya', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300,)),
                                              ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(const allMyInventoryRequest());
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
                                                  Get.to(DetailInventoryRequest('${myRequestInventory[indexA]['request_id']}'));
                                                },
                                                child: Card(
                                                  child: ListTile(
                                                    title: Text(
                                                      indexA < myRequestInventory.length
                                                          ? '${myRequestInventory[indexA]['employee_name']} | ${myRequestInventory[indexA]['item_request']}'
                                                          : '-',
                                                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    subtitle: Text(
                                                      indexA < myRequestInventory.length
                                                          ? myRequestInventory[indexA]['status_name']
                                                          : '-',
                                                      style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400),
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
                            if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008')
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 98.w) / 2,
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 15.sp, right: 10.sp, top: 10.sp, bottom: 10.sp),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                               Text('Persetujuan Inventaris', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700,)),
                                              SizedBox(height: 5.sp,),
                                              Text( 'Terima atau tolak permintaan inventaris', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300,)),
                                              ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                                Get.to(const allApprovalInventoryRequest());
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
                                                  Get.to(DetailInventoryRequest('${approvalRequestInventory[indexC]['request_id']}'));
                                                },
                                                child: Card(
                                                  child: ListTile(
                                                    title: Text(
                                                      indexC < approvalRequestInventory.length
                                                          ? '${approvalRequestInventory[indexC]['employee_name']} | ${approvalRequestInventory[indexC]['item_request']}'
                                                          : '-',
                                                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    subtitle: Text(
                                                      indexC < approvalRequestInventory.length
                                                          ? approvalRequestInventory[indexC]['status_name']
                                                          : '-',
                                                      style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10.sp,),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 30.sp,),
                        Row(
                          children: [
                            SizedBox(
                                width: (MediaQuery.of(context).size.width - 98.w) / 2,
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 15.sp, right: 10.sp, top: 10.sp, bottom: 10.sp),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                Text('Inventaris Saya', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700,)),
                                                SizedBox(height: 5.sp,),
                                                Text( 'Kelola inventaris saya', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300,)),
                                                ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                  Get.to(AllMyInventory());
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
                                                  Get.to(detailInventory(myInventory[indexD]['inventory_id']));
                                                  // Get.to(DetailInventoryRequest('${myRequestInventory[indexD]['inventory_name']}'));
                                                },
                                                child: Card(
                                                  child: ListTile(
                                                    title: Text(
                                                      indexD < myInventory.length
                                                          ? '${myInventory[indexD]['inventory_name']}'
                                                          : '-',
                                                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    trailing: Container(
                                                      alignment: Alignment.center,
                                                      constraints: BoxConstraints(
                                                        maxWidth: 30.w,
                                                      ),
                                                      decoration: const BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(12)),
                                                        color: Colors.green,
                                                      ),
                                                      child: Text(indexD < myInventory.length
                                                          ? myInventory[indexD]['status_name']
                                                          : '-', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 10.sp),),
                                                    ),
                                                    subtitle: Text(
                                                      indexD < myInventory.length
                                                          ? myInventory[indexD]['inventory_id']
                                                          : '-',
                                                      style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10.sp,),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            SizedBox(width: 10.w,),
                            if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008 ')
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 98.w) / 2,
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 15.sp, right: 10.sp, top: 10.sp, bottom: 10.sp),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                Text('Seluruh Inventaris', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700,)),
                                                SizedBox(height: 5.sp,),
                                                Text( 'Kelola seluruh inventaris perusahaan', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300,)),
                                                ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                  Get.to(AllInventory());
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

                                                },
                                                child: Card(
                                                  child: ListTile(
                                                    title: Text(
                                                      indexE < companyInventory.length
                                                          ? '${companyInventory[indexE]['inventory_name']}'
                                                          : '-',
                                                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    trailing: Container(
                                                      alignment: Alignment.center,
                                                      constraints: BoxConstraints(
                                                        maxWidth: 30.w,
                                                      ),
                                                      decoration: const BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(12)),
                                                        color: Colors.green,
                                                      ),
                                                      child: Text(indexE < companyInventory.length
                                                          ? companyInventory[indexE]['status_name']
                                                          : '-', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 10.sp),),
                                                    ),
                                                    onTap: () {
                                                      Get.to(detailInventory(companyInventory[indexE]['inventory_id']));
                                                    },
                                                    subtitle: Text(
                                                      indexE < companyInventory.length
                                                          ? companyInventory[indexE]['inventory_id']
                                                          : '-',
                                                      style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10.sp,),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                          ],
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
}