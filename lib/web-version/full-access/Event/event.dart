import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Performance/performance.dart';
import 'package:hr_systems_web/web-version/full-access/Report/report.dart';
import 'package:hr_systems_web/web-version/full-access/Salary/salary.dart';
import 'package:hr_systems_web/web-version/full-access/Settings/setting.dart';
import 'package:hr_systems_web/web-version/full-access/Structure/structure.dart';
import 'package:hr_systems_web/web-version/full-access/Training/traning.dart';
import 'package:hr_systems_web/web-version/full-access/employee.dart';
import 'package:hr_systems_web/web-version/full-access/index.dart';
import 'package:hr_systems_web/web-version/full-access/profile.dart';
import 'package:hr_systems_web/web-version/login.dart';
import 'package:http/http.dart' as http;

class EventIndex extends StatefulWidget {
  const EventIndex({super.key});

  @override
  State<EventIndex> createState() => _EventIndexState();
}

class _EventIndexState extends State<EventIndex> {
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  Future<void> fetchData() async {
    String employeeId = storage.read('employee_id').toString();

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
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    var employeeId = storage.read('employee_id');
    var positionId = storage.read('position_id');
    var photo = storage.read('photo');

    return MaterialApp(
      title: "Acara",
      home: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Side Menu
              Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15.sp,),
                        ListTile(
                        contentPadding: const EdgeInsets.only(left: 0, right: 0),
                                dense: true,
                                horizontalTitleGap: 20.0,
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
                                onPressed: () {Get.to(EmployeePage(employee_id: employeeId));},
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
                                      child: Image.asset('images/employee-inactive.png')
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
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: const Color(0xff4ec3fc),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Image.asset('images/acara-active.png')
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
              //Content
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
                            width: MediaQuery.of(context).size.width / 4.5,
                            child: GestureDetector(
                              onTap: () {
                                Get.to(const ProfilePage());
                              },
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
                      SizedBox(height: 30.sp,),
                      if(positionId == 'POS-HR-002')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: (){

                              }, 
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                alignment: Alignment.center,
                                minimumSize: Size(40.w, 55.h),
                                foregroundColor: const Color(0xFFFFFFFF),
                                backgroundColor: const Color(0xff4ec3fc),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text('Buat Acara')
                            )
                          ],
                        ),
                      SizedBox(height: 30.sp,),
                      CarouselSlider(
                        options: CarouselOptions(),
                        items: imgList.map((item) => Card(
                          child: Image.network(
                            item, fit: BoxFit.fill)
                          ))
                        .toList(),
                      ),
                      SizedBox(height: 30.sp,),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 192.w),
                            child: Card(
                              child: Column(
                                children: [
                                  Text('data')
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 170.w) / 2,
                            child: Card(
                              child: Column(
                                children: [
                                  Text('data')
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                )
              )
            ],
          ),
        )
      )
    );
  }
}