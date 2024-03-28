// ignore_for_file: avoid_print, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/addNewInventory.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/alIInventory.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/allApprovalInventoryRequest.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/allMyInventory.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/allMyInventoryRequest.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/detailInventory.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/detailInventoryRequest.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/newInventoryRequest.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
                        SizedBox(height: 10.sp,),
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
                                        style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w600,)
                                      ),
                                    ],
                                  )
                                ),
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
                                      Text('Permintaan\nsaya', style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w400,)),
                                      SizedBox(height: 5.h,),
                                      Text(angkaPermintaanSaya, style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)),
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
                                      Text('Inventaris\nsaya', style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w400,)),
                                      SizedBox(height: 5.h,),
                                      Text(inventarisSaya, style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)),
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
                                        Text(butuhPersetujuan, style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)),
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
                                        Text('Inventaris\nNon-Aktif', style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w400,)),
                                        SizedBox(height: 5.h,),
                                        Text(barangTidakTerpakai, style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)),
                                      ],
                                    ),
                                  )
                                ),
                              )
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
                                                Text('Permintaan Saya',style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w700,)),
                                                SizedBox(height: 1.sp,),
                                                Text( 'Kelola permintaan inventaris saya', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w300,)),
                                              ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(const allMyInventoryRequest());
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
                                                  Get.to(DetailInventoryRequest('${myRequestInventory[indexA]['request_id']}'));
                                                },
                                                child: Card(
                                                  child: ListTile(
                                                    title: Text(
                                                      indexA < myRequestInventory.length
                                                          ? '${myRequestInventory[indexA]['employee_name']} | ${myRequestInventory[indexA]['item_request']}'
                                                          : '-',
                                                      style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    subtitle: Text(
                                                      indexA < myRequestInventory.length
                                                          ? myRequestInventory[indexA]['status_name']
                                                          : '-',
                                                      style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),
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
                            if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008')
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
                                                Text('Persetujuan Inventaris', style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w700,)),
                                                SizedBox(height: 1.sp,),
                                                Text( 'Terima atau tolak permintaan inventaris', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w300,)),
                                                ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                  Get.to(const allApprovalInventoryRequest());
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
                                                  Get.to(DetailInventoryRequest('${approvalRequestInventory[indexC]['request_id']}'));
                                                },
                                                child: Card(
                                                  child: ListTile(
                                                    title: Text(
                                                      indexC < approvalRequestInventory.length
                                                          ? '${approvalRequestInventory[indexC]['employee_name']} | ${approvalRequestInventory[indexC]['item_request']}'
                                                          : '-',
                                                      style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    subtitle: Text(
                                                      indexC < approvalRequestInventory.length
                                                          ? approvalRequestInventory[indexC]['status_name']
                                                          : '-',
                                                      style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),
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
                                              Text('Inventaris Saya', style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w700,)),
                                              SizedBox(height: 1.sp,),
                                              Text( 'Kelola inventaris saya', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w300,)),
                                              ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                                Get.to(const AllMyInventory());
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
                                                Get.to(detailInventory(myInventory[indexD]['inventory_id']));
                                              },
                                              child: Card(
                                                child: ListTile(
                                                  title: Text(
                                                    indexD < myInventory.length
                                                        ? '${myInventory[indexD]['inventory_name']}'
                                                        : '-',
                                                    style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),
                                                  ),
                                                  trailing: Container(
                                                    alignment: Alignment.center,
                                                    constraints: BoxConstraints(
                                                      maxWidth: 20.w,
                                                    ),
                                                    decoration: const BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(12)),
                                                      color: Colors.green,
                                                    ),
                                                    child: Text(indexD < myInventory.length
                                                        ? myInventory[indexD]['status_name']
                                                        : '-', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 3.sp),),
                                                  ),
                                                  subtitle: Text(
                                                    indexD < myInventory.length
                                                        ? myInventory[indexD]['inventory_id']
                                                        : '-',
                                                    style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),
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
                            if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008 ')
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
                                                Text('Seluruh Inventaris', style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w700,)),
                                                SizedBox(height: 1.sp,),
                                                Text( 'Kelola seluruh inventaris perusahaan', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w300,)),
                                                ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                  Get.to(const AllInventory());
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
                                                                
                                                },
                                                child: Card(
                                                  child: ListTile(
                                                    title: Text(
                                                      indexE < companyInventory.length
                                                          ? '${companyInventory[indexE]['inventory_name']}'
                                                          : '-',
                                                      style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    trailing: Container(
                                                      alignment: Alignment.center,
                                                      constraints: BoxConstraints(
                                                        maxWidth: 20.w,
                                                      ),
                                                      decoration: const BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(12)),
                                                        color: Colors.green,
                                                      ),
                                                      child: Text(indexE < companyInventory.length
                                                          ? companyInventory[indexE]['status_name']
                                                          : '-', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 3.sp),),
                                                    ),
                                                    onTap: () {
                                                      Get.to(detailInventory(companyInventory[indexE]['inventory_id']));
                                                    },
                                                    subtitle: Text(
                                                      indexE < companyInventory.length
                                                          ? companyInventory[indexE]['inventory_id']
                                                          : '-',
                                                      style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),
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
                              )
                          ],
                        ),
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
}