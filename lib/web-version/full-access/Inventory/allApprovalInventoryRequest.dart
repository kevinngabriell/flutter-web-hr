// ignore_for_file: avoid_print, file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/detailInventoryRequest.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class allApprovalInventoryRequest extends StatefulWidget {
  const allApprovalInventoryRequest({super.key});

  @override
  State<allApprovalInventoryRequest> createState() => _allApprovalInventoryRequestState();
}

class _allApprovalInventoryRequestState extends State<allApprovalInventoryRequest> {
  String? leaveoptions;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  bool isLaoding = false;
  List<Map<String, dynamic>> noticationList = [];
  List<Map<String, dynamic>> approvalRequestInventory = [];
  bool isSearch = false;
  List<Map<String, dynamic>> statusList = [];
  String selectedStatus = '';
  List<Map<String, dynamic>> approvalRequestInventorySearch = [];
  TextEditingController txtNamaItem = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchNotification();
    fetchApprovalRequest();
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

      String url = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/getinventory.php?action=13';
      var statusResponse = await http.get(Uri.parse(url));

      if (statusResponse.statusCode == 200) {
        var statusData = json.decode(statusResponse.body);

        setState(() {
          statusList = List<Map<String, dynamic>>.from(statusData['Data']);
          selectedStatus = statusList[0]['status_id'];
        });
      } else {
        print('Failed to load data: ${statusResponse.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    } finally {
      isLaoding = false;
    }
  }

  Future<void> fetchApprovalRequest() async{
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

      String cariApa = txtNamaItem.text;
      String tanngal = '';

      String searchUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/getinventory.php?action=15&item_request=$cariApa&last_status=$selectedStatus&insert_dt=$tanngal';
      var searchResponse = await http.get(Uri.parse(searchUrl));

      if (searchResponse.statusCode == 200) {
        var searchData = json.decode(searchResponse.body);

        setState(() {
          approvalRequestInventorySearch = List<Map<String, dynamic>>.from(searchData['Data']);
        });
      } else {
        print('Failed to load data: ${searchResponse.statusCode}');
      }

    } catch (e){
      print('Error: $e');
    } finally {
      setState(() {
        isLaoding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    var employeeId = storage.read('employee_id');
    var photo = storage.read('photo');
    var positionId = storage.read('position_id');

    return MaterialApp(
      title: 'Permohonan Saya - Inventaris',
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
                        SizedBox(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nama Item Request', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700)),
                                  SizedBox(height: 10.h,),
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                    child: TextFormField(
                                      controller: txtNamaItem,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                                        hintText: 'Masukkan nama item'
                                      ),
                                    )
                                  ),
                                ],
                              ),
                              SizedBox(width: 5.w,),
                              ElevatedButton(
                                onPressed: (){
                                  setState(() {
                                    isSearch = true;
                                    fetchApprovalRequest();
                                  });
                                }, 
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  alignment: Alignment.centerLeft,
                                  minimumSize: Size(20.w, 55.h),
                                  foregroundColor: Colors.white,
                                  backgroundColor: const Color(0xFF2A85FF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)
                                  ),
                                ),
                                child: Text('Search', style: TextStyle(fontSize: 4.sp))
                              ),
                              SizedBox(width: 5.w,),
                              ElevatedButton(
                                onPressed: (){
                                  setState(() {
                                    isSearch = false;
                                  });
                                }, 
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  alignment: Alignment.centerLeft,
                                  minimumSize: Size(20.w, 55.h),
                                  foregroundColor: Colors.white,
                                  backgroundColor: const Color(0xFF2A85FF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)
                                  ),
                                ),
                                child: Text('Reset', style: TextStyle(fontSize: 4.sp))
                              )
                            ],
                          )
                        ),
                        SizedBox(height: 10.sp,),
                        if(isSearch == true)
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: ListView.builder(
                              itemCount: approvalRequestInventorySearch.length,
                              itemBuilder: (context, index){
                                var itemSearch = approvalRequestInventorySearch[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 3.sp),
                                  child: Card(
                                    child: ListTile(
                                      title: Text(itemSearch['employee_name'] + ' | ' + itemSearch['item_request'], style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700)),
                                      subtitle: Text(itemSearch['status_name'], style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400)),
                                      onTap: () {
                                        Get.to(DetailInventoryRequest((itemSearch['request_id'])));
                                      },
                                    ),
                                  ),
                                );
                              }
                            ),
                          ),
                        if(isSearch == false)
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: ListView.builder(
                              itemCount: approvalRequestInventory.length,
                              itemBuilder: (context, index){
                                var item = approvalRequestInventory[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 3.sp),
                                  child: Card(
                                    child: ListTile(
                                      title: Text(item['employee_name'] + ' | ' + item['item_request'], style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700)),
                                      subtitle: Text(item['status_name'], style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400)),
                                      onTap: () {
                                        Get.to(DetailInventoryRequest((item['request_id'])));
                                      },
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