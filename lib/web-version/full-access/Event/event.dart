// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';

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
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();

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
                        NamaPerusahaanMenu(companyName: companyName, companyAddress: trimmedCompanyAddress),
                        SizedBox(height: 10.sp,),
                        const HalamanUtamaMenu(),
                        SizedBox(height: 5.sp,),
                        BerandaNonActive(employeeId: employeeId.toString()),
                        SizedBox(height: 5.sp,),
                        KaryawanNonActive(employeeId: employeeId.toString()),
                        SizedBox(height: 5.sp,),
                        const GajiNonActive(),
                        SizedBox(height: 5.sp,),
                        const PerformaNonActive(),
                        SizedBox(height: 5.sp,),
                        const PelatihanNonActive(),
                        SizedBox(height: 5.sp,),
                        const AcaraActive(),
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
                      SizedBox(height: 5.sp,),
                      NotificationnProfile(employeeName: employeeName, employeeAddress: employeeEmail, photo: photo),
                      SizedBox(height: 7.sp,),
                      if(positionId == 'POS-HR-002')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: (){
                                dialogCreateEvent();
                              }, 
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                alignment: Alignment.center,
                                minimumSize: Size(40.w, 55.h),
                                foregroundColor: const Color(0xFFFFFFFF),
                                backgroundColor: const Color(0xff4ec3fc),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Buat Acara')
                            )
                          ],
                        ),
                      SizedBox(height: 10.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 180.w),
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.only(top: 5.sp, bottom: 5.sp, left: 7.sp, right: 7.sp),
                                child: Text('Acara Kantor'),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 270.w),
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.only(top: 5.sp, bottom: 5.sp, left: 7.sp, right: 7.sp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TableCalendar(
                                      focusedDay: _selectedDay, 
                                      firstDay: DateTime(2023, 1, 1),
                                      lastDay: DateTime(2030, 12, 31),
                                      selectedDayPredicate: (day) {
                                        return isSameDay(_selectedDay, day);
                                      },
                                      onFormatChanged: (format) {
                                        if (_calendarFormat != format) {
                                          setState(() {
                                            _calendarFormat = format;
                                          });
                                        }
                                      },
                                      onDaySelected: (selectedDay, focusedDay) {
                                        setState(() {
                                          _selectedDay = selectedDay;
                                        });
                                      },
                                      headerStyle: HeaderStyle(
                                        titleTextStyle: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'RobotoBold',
                                          fontSize: 4.sp,
                                        ),
                                        formatButtonDecoration: const BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                        ),
                                        formatButtonTextStyle: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'RobotoMedium',
                                          fontSize: 10.sp
                                        ),
                                        leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.black),
                                        rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.black),
                                        formatButtonVisible: false,
                                        formatButtonShowsNext: true,
                                        titleCentered: true,
                                      ),
                                    ),
                                    Card(
                                      child: ListTile(
                                        title: Text('data'),
                                      )
                                    ),
                                  ],
                                ),
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

  Future dialogCreateEvent() {
    return showDialog(
      context: context, 
      builder: (_){
        return AlertDialog(
          title: Center(child: Text('Buat Acara',
                                  style: TextStyle(
                                    fontSize: 6.sp,
                                    fontWeight: FontWeight.w600,
                                  ),)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 200.w) / 2,
                    child: Padding(
                      padding: EdgeInsets.all(4.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nama Acara',
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  ),),
                          SizedBox(height: 2.sp,),
                          TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              fillColor: Color.fromRGBO(235, 235, 235, 1),
                              hintText: 'Masukkan nama acara'
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 200.w) / 2,
                    child: Padding(
                      padding: EdgeInsets.all(4.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tanggal',
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  ),),
                          SizedBox(height: 2.sp,),
                          DateTimePicker(
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(5000),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              fillColor: Color.fromRGBO(235, 235, 235, 1),
                              hintText: 'Pilih tanggal acara'
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 200.w) / 2,
                    child: Padding(
                      padding: EdgeInsets.all(4.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Lokasi',
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  ),),
                          SizedBox(height: 2.sp,),
                          TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              fillColor: Color.fromRGBO(235, 235, 235, 1),
                              hintText: 'Masukkan lokasi acara'
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 200.w) / 2,
                    child: Padding(
                      padding: EdgeInsets.all(4.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Jam',
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  ),),
                          SizedBox(height: 2.sp,),
                          DateTimePicker(
                            type: DateTimePickerType.time,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(5000),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              fillColor: Color.fromRGBO(235, 235, 235, 1),
                              hintText: 'Pilih jam acara'
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 200.w),
                    child: Padding(
                      padding: EdgeInsets.all(4.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Deskripsi',
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  ),),
                          SizedBox(height: 2.sp,),
                          TextFormField(
                            maxLines: 3,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              fillColor: Color.fromRGBO(235, 235, 235, 1),
                              hintText: 'Masukkan deskripsi acara'
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: (){
                Get.back();
              }, 
              child: Text('Kembali')
            ),
            TextButton(
              onPressed: (){
                
              }, 
              child: Text('Kumpulkan')
            )
          ],
        );
      }
    );
  }
}