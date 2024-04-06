import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Resign/ViewDetailResign.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class ViewListMyResign extends StatefulWidget {
  const ViewListMyResign({super.key});

  @override
  State<ViewListMyResign> createState() => _ViewListMyResignState();
}

class _ViewListMyResignState extends State<ViewListMyResign> {
  String? leaveoptions;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  bool isLoading = false;
  String employeeId = '';
  List<dynamic> kasbons = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchKasbons();
  }

  Future<void> fetchKasbons() async {
    try {
      employeeId = storage.read('employee_id').toString();
      final response = await http.get(Uri.parse(
          'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/resign/getresign.php?action=3&employee_id=$employeeId'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          kasbons = data['Data'];
        });
      } else {
        print('Failed to fetch kasbons');
      }
    } catch (e) {
      print('Error occurred while fetching kasbons: $e');
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

        // Ensure that the fields are of the correct type
        setState(() {
          companyName = data['company_name'] as String;
          companyAddress = data['company_address'] as String;
          trimmedCompanyAddress = companyAddress.substring(0, 15);
          employeeName = data['employee_name'] as String;
          employeeEmail = data['employee_email'] as String;
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
      home: Scaffold(
        body: isLoading ? const Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    ]
                  )
                )
              ),
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
                        width: (MediaQuery.of(context).size.width - 90.w),
                        child: Card(
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                          color: Colors.white,
                          shadowColor: Colors.black,
                          child: Padding(
                            padding: EdgeInsets.all(4.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('List pemunduran diri', style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w700),),
                                Text('Pantau dan menyetujui pemunduran diri yang sudah diajukan', style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w300),),
                                SizedBox(height: 4.h,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  child: ListView.builder(
                                    itemCount: kasbons.length,
                                    itemBuilder: (context, index) {
                                      var kasbon = kasbons[index];
                                      return Padding(
                                        padding: EdgeInsets.only(left: 4.sp, top: 4.sp, right: 4.sp),
                                        child: Card(
                                          child: ListTile(
                                            title: Text(kasbon['employee_name'], style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),),
                                            subtitle: Text(formatDate(kasbon['effective_date']), style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w300),),
                                            trailing: ElevatedButton(
                                              onPressed: () {
                                                Get.to(viewDetailResign(statusName: kasbon['status_name'], tanggalPengajuan: kasbon['insert_dt'], namaKaryawan: kasbon['employee_name'], tanggalEfektif: kasbon['effective_date'], alasanBerhenti: kasbon['resign_reason'], idResign: kasbon['resign_id'], idKaryawan: kasbon['id'],));
                                              },
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                alignment: Alignment.center,
                                                minimumSize: Size(40.w, 55.h),
                                                foregroundColor: const Color(0xFFFFFFFF),
                                                backgroundColor: const Color(0xff4ec3fc),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                              ),
                                              child: Text(kasbon['status_name']),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
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
    );
  }

  String formatDate(String date) {
    // Parse the date string
    DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(date);

    // Format the date as "dd MMMM yyyy"
    return DateFormat("d MMMM yyyy", 'id').format(parsedDate);
  }
}