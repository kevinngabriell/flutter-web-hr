// ignore_for_file: unused_local_variable, avoid_print

import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AbsenSaya extends StatefulWidget {
  const AbsenSaya({super.key});

  @override
  State<AbsenSaya> createState() => _AbsenSayaState();
}

class _AbsenSayaState extends State<AbsenSaya> {
  final storage = GetStorage();
  bool isLoading = false;
  late Future<List<Map<String, dynamic>>> absenceData;
  int employeeID = GetStorage().read('employee_id');
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    absenceData = fetchAbsenceData(employeeID);
  }


  Future<List<Map<String, dynamic>>> fetchAbsenceData(int employeeId) async {
    int employeeID = GetStorage().read('employee_id');
    try {

      setState(() {
        isLoading = true;
      });

      final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/absent/getabsencebyid.php?employee_id=$employeeID'),
      );

      if (response.statusCode == 200) {
        // If the server returns an OK response, parse the JSON
        List<dynamic> data = json.decode(response.body);
        setState(() {
          isLoading = false;
        });
        return data.cast<Map<String, dynamic>>();
      } else {
        // If the server did not return a 200 OK response, handle the error
        print('Failed to load data. Status code: ${response.statusCode}');
        return []; // You can return an empty list or throw an exception based on your use case
      }
    } catch (e) {
      // Handle other types of exceptions, such as network errors
      setState(() {
        isLoading = false;
       });
      print('Error: $e');
      return []; // You can return an empty list or throw an exception based on your use case
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Absen'),
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TableCalendar(
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
                    color: Colors.blue,
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
                    fontSize: 18.sp,
                  ),
                  formatButtonDecoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)
                    )
                  ),
                  formatButtonTextStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'RobotoMedium',
                    fontSize: 10.sp
                  ),
                  leftChevronIcon: const Icon(
                    Icons.chevron_left, 
                    color: Colors.black,
                  ) ,
                  rightChevronIcon: const Icon(
                    Icons.chevron_right, 
                    color: Colors.black,
                  ),
                  formatButtonVisible: false,
                  formatButtonShowsNext: true,
                  titleCentered: true
                ),
                calendarBuilders: CalendarBuilders(
                  todayBuilder: (context, date, _) {
                    return Center(
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                          //borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text('${date.day}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20.h,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder(
                  future: absenceData,
                  builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No data available'); // Handle case where data is empty
                    } else {
                       List<Map<String, dynamic>> data = snapshot.data!;
                       return ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(width: 10, height: 10,);
                        },
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> entry = data[index];
                          final now = DateTime.now();
                          final DateTime selectFormat = _selectedDay;
                          final DateTime dateTomorrow = DateTime(now.year, now.month, now.day + 1);
                          final DateFormat formatter = DateFormat('yyyy-MM-dd');
                          final String formatted = formatter.format(selectFormat);
                          final String formattedDateToday = formatter.format(now);
                          final String formattedDateTomorrow = formatter.format(dateTomorrow);
                          String entryDate = entry['date'];
              
                          if(formatted == entryDate){
                            return Card(
                              child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Detail Absen', 
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w800
                                        ),
                                      ),
                                      content: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: SizedBox(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width - 120.w,
                                                        child: Image.memory(base64Decode('${entry['photo']}')),
                                                      ),
                                                      Text('Tipe Absen',
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 10),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width - 120.w,
                                                        child: TextFormField(
                                                          decoration: InputDecoration(
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                          ),
                                                          readOnly: true,
                                                          initialValue: '${entry['absence_type_name']}',
                                                        ),
                                                      ),
                                                      const SizedBox(height: 20),
                                                      Text('Tanggal Absen',
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 10), 
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width - 120.w,
                                                        child: TextFormField(
                                                          decoration: InputDecoration(
                                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                                                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                          ),
                                                          readOnly: true,
                                                          initialValue: '${entry['date']}',
                                                        ),
                                                      ),
                                                      const SizedBox(height: 20),
                                                      Text('Jam Absen',
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 10), 
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width - 120.w,
                                                        child: TextFormField(
                                                          decoration: InputDecoration(
                                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                                                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                          ),
                                                          readOnly: true,
                                                          initialValue: '${entry['time']}',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(height: 20.h,),
                                                      Text('Lokasi',
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 10), 
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width - 120.w,
                                                        child: TextFormField(
                                                          maxLines: 3,
                                                          decoration: InputDecoration(
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                          ),
                                                          readOnly: true,
                                                          initialValue: '${entry['location']}',
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: (){}, 
                                          child: const Text('Koreksi Absen')
                                        ),
                                        TextButton(
                                          onPressed: () {Navigator.of(context).pop(); },
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Padding(
                                padding:  const EdgeInsets.only(top: 10, bottom: 10),
                                child: ListTile(
                                  title: Text('${entry['absence_type_name']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10.h,),
                                      Text('Jam Absen: ${entry['time']}'),
                                      Text('Lokasi: ${entry['location']}'),
                                    ],
                                  ),
                                  trailing: SizedBox(
                                    width: MediaQuery.of(context).size.width / 3,
                                    height: MediaQuery.of(context).size.height / 9,
                                    child: Card(
                                      margin: const EdgeInsets.all(10),
                                      elevation: 1,
                                      color: '${entry['presence_type_name']}' == 'tepat waktu' ? Colors.green : Colors.yellow,
                                      child: Center(
                                        child: Text('${entry['presence_type_name']}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: '${entry['presence_type_name']}' == 'tepat waktu' ? Colors.white : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),);
                          } else {
                            return Container();
                          }
                        }
                       );
                    }
                  }
                )
              ),
            )
          ],
        ),
      )
    );
  }
}