// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Overview/EmployeeOverview.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;

class AbsenTableCalendarOverview extends StatefulWidget {
  final String employeeId;
  final String namaKaryawan;

  const AbsenTableCalendarOverview({super.key, required this.employeeId, required this.namaKaryawan});

  @override
  State<AbsenTableCalendarOverview> createState() => _AbsenTableCalendarOverviewState();
}

class _AbsenTableCalendarOverviewState extends State<AbsenTableCalendarOverview> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  late Future<List<Map<String, dynamic>>> absenceData;
  DateTime? TanggalAbsen;
  String? JamAbsen;
  List<Map<String, String>> jenisabsen = [];
  String selectedJenisAbsen = '';
  TextEditingController txtLokasiAbsen = TextEditingController();

  @override
  void initState() {
    super.initState();
    absenceData = fetchAbsenceData(widget.employeeId);
    _selectedDay = _focusedDay;
    fetchJenisAbsen();
  }

  Future<void> fetchJenisAbsen() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/absent/getmasterjenisabsen.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        setState(() {
          jenisabsen = (data['Data'] as List)
              .map((jenis) => Map<String, String>.from(jenis))
              .toList();
          if (jenisabsen.isNotEmpty) {
            selectedJenisAbsen = jenisabsen[0]['id_absence_type']!;
          }
        });
      } else {
        print('Failed to fetch jenis absen data');
      }
    } else {
      print('Failed to fetch jenis absen data');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAbsenceData(String employeeId) async {
    String employeeID = widget.employeeId;
    try {
      final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/absent/getabsencebyid.php?employee_id=$employeeID'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        print('Failed to load data absence. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<void> insertAbsenManual() async {
    String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-systems-data-v.1/AbsenceProcess/InsertAbsen.php';
    String employeeID = widget.employeeId;
    String companyId = GetStorage().read('company_id');

    var data = {
      'employee_id': employeeID,
      'company_id': companyId,
      'date': TanggalAbsen,
      'time': JamAbsen,
      'location': txtLokasiAbsen.text,
      'absence_type': selectedJenisAbsen,
    };

    var dioClient = dio.Dio();
    dio.Response response = await dioClient.post(apiUrl, data: dio.FormData.fromMap(data));

    if (response.statusCode == 200) {
      Get.back();
      Get.to(EmployeeOverviewPage(employeeID));
      absenceData = fetchAbsenceData(widget.employeeId);
    } else {
      Get.snackbar("Error", "Error: ${response.statusCode}, ${response.data}");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: 10.h),
        SizedBox(
          width: (MediaQuery.of(context).size.width - 160.w) / 4,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(40.w, 55.h),
              foregroundColor: const Color(0xFFFFFFFF),
              backgroundColor: const Color(0xff4ec3fc),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Absen Manual',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 4.sp),
              ),
            ),
            onPressed: () async => {
              showDialog(
                context: context, 
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      'Input absen', 
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 7.sp,
                        fontWeight: FontWeight.w800
                      ),
                    ),
                    content: SizedBox(
                      width: (MediaQuery.of(context).size.width + 60) / 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Tipe Absen',
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 4,
                                    child: DropdownButtonFormField<String>(
                                      value: selectedJenisAbsen,
                                      hint: const Text('Pilih jenis absen'),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedJenisAbsen = newValue!;
                                        });
                                      },
                                      items: jenisabsen.map<DropdownMenuItem<String>>(
                                        (Map<String, String> jenis) {
                                          return DropdownMenuItem<String>(
                                            value: jenis['id_absence_type']!,
                                            child: Text(jenis['absence_type_name']!),
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text('Tanggal Absen',
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 4,
                                    child: DateTimePicker(
                                      firstDate: DateTime(2023),
                                      lastDate: DateTime(2100),
                                      initialDate: DateTime.now(),
                                      dateMask: 'd MMM yyyy',
                                      onChanged: (value) {
                                        setState(() {
                                          TanggalAbsen = DateFormat('yyyy-MM-dd').parse(value);
                                        });
                                      },
                                    )
                                  ),    
                                ],
                              ),
                              const SizedBox(width: 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Jam Absen',
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 4,
                                    child: DateTimePicker(
                                      type: DateTimePickerType.time,
                                      onChanged: (value) {
                                        setState(() {
                                          JamAbsen = value;
                                        });
                                      },
                                    )
                                  ),
                                  const SizedBox(height: 20),
                                  Text('Lokasi Absen',
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 4,
                                    child: TextFormField(
                                      controller: txtLokasiAbsen,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: (){
                          insertAbsenManual();
                        }, 
                        child: const Text('Kumpulkan')
                      ),
                      TextButton(
                        onPressed: (){
                          Get.back();
                        }, 
                        child: const Text('Batal')
                      )
                    ],
                  );
                }
              )
            },
          ),
        ),
        SizedBox(height: 10.h),
        TableCalendar(
          calendarFormat: _calendarFormat,
          focusedDay: _focusedDay,
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
              _focusedDay = focusedDay;
            });
          },
          calendarStyle: CalendarStyle(
            weekendTextStyle: const TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontFamily: 'RobotoMedium'
            ),
            defaultTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'RobotoMedium'
            ),
            todayTextStyle: const TextStyle(
              color: Color(0xFFFAFAFA),
              fontSize: 16.0,
              fontFamily: 'RobotoMedium'
            ),
            selectedTextStyle: const TextStyle(
              color: Colors.blue,
              fontSize: 16.0,
              fontFamily: 'RobotoMedium'
            ),
            isTodayHighlighted: true,
            todayDecoration: const BoxDecoration(
              color: Colors.blue
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.white.withOpacity(1),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blue,
                width: 3
              )
            ),
          ),
          headerStyle: HeaderStyle(
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontFamily: 'RobotoBold',
              fontSize: 7.sp,
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
          calendarBuilders: CalendarBuilders(
            todayBuilder: (context, date, _) {
              return Center(
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue
                  ),
                  child: Text(
                    '${date.day}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20.h),
        Expanded(
          child: FutureBuilder(
            future: absenceData,
            builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Tidak ada data absen pada hari tersebut'));
              } else {
                List<Map<String, dynamic>> data = snapshot.data!;
                return ListView.separated(
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> entry = data[index];
                    String entryDate = entry['date'];

                    if (entryDate == DateFormat('yyyy-MM-dd').format(_selectedDay)) {
                      return Card(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => buildAbsenceDetailsDialog(context, entry),
                            );
                          },
                          child: ListTile(
                            title: Text(
                              entry['absence_type_name'],
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Jam Absen: ${entry['time']}'),
                                Text('Lokasi: ${entry['location']}'),
                              ],
                            ),
                            trailing: SizedBox(
                              width: MediaQuery.of(context).size.width / 9,
                              height: MediaQuery.of(context).size.height / 9,
                              child: Card(
                                margin: const EdgeInsets.all(10),
                                elevation: 1,
                                color: entry['presence_type_name'] == 'tepat waktu' ? Colors.green : Colors.yellow,
                                child: Center(
                                  child: Text(
                                    entry['presence_type_name'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: entry['presence_type_name'] == 'tepat waktu' ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox(); // Or any other placeholder widget
                    }
                  },
                );
              }
            },
          )
        ),
      ],
    );
  }

  Widget buildAbsenceDetailsDialog(BuildContext context, Map<String, dynamic> entry) {
    return AlertDialog(
      title: Text(
        'Detail Absen', 
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 7.sp,
          fontWeight: FontWeight.w800
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.memory(base64Decode(entry['photo']), width: MediaQuery.of(context).size.width / 6),
                const SizedBox(width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildDetailField('Tipe Absen', entry['absence_type_name']),
                    buildDetailField('Tanggal Absen', entry['date']),
                    buildDetailField('Jam Absen', entry['time']),
                    buildDetailField('Lokasi', entry['location'], maxLines: 3),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => print(entry['absence_id']),
          child: const Text('Koreksi Absen')
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget buildDetailField(String label, String value, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 4.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          child: TextFormField(
            maxLines: maxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
            readOnly: true,
            initialValue: value,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
