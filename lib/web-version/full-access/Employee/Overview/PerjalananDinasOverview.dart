// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/ViewLPD.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/ViewPerjalananDinas.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PerjalananDinasOverview extends StatefulWidget {
  final String employeeId;
  final String namaKaryawan;

  const PerjalananDinasOverview({super.key, required this.employeeId, required this.namaKaryawan});

  @override
  State<PerjalananDinasOverview> createState() => _PerjalananDinasOverviewState();
}

class _PerjalananDinasOverviewState extends State<PerjalananDinasOverview> {
  bool isLoading = false;
  List<Map<String, dynamic>> myBusinessTrip = [];
  List<Map<String, dynamic>> myLPD = [];
  final GetStorage storage = GetStorage();

  @override
  void initState() {
    super.initState();
    fetchPerjalananDinas();
  }

  Future<void> fetchPerjalananDinas() async {
    setState(() {
      isLoading = true;
    });

    try {
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/getperjalanandinas.php?action=6&employee_id=${widget.employeeId}';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          myBusinessTrip = List<Map<String, dynamic>>.from(data['Data']);
        });
      } else {
        print('Failed to load perjalanan bisnis data: ${response.statusCode}');
      }

      String mylpdUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/getlpd.php?action=2&employee_id=${widget.employeeId}';
      var mylpdResponse = await http.get(Uri.parse(mylpdUrl));

      if (mylpdResponse.statusCode == 200) {
        var mylpdData = json.decode(mylpdResponse.body);
        setState(() {
          myLPD = List<Map<String, dynamic>>.from(mylpdData['Data']);
        });
      } else {
        print('Failed to load LPD data: ${mylpdResponse.statusCode}');
      }
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? const Center(child: CircularProgressIndicator()) : Column(
      children: [
        SizedBox(height: 10.sp),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: (MediaQuery.of(context).size.width - 100.w) / 2,
              child: Card(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                color: Colors.white,
                shadowColor: Colors.black,
                child: Padding(
                  padding: EdgeInsets.all(4.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Perjalanan Dinas', style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w700)),
                      SizedBox(height: 1.sp),
                      Text('List perjalanan dinas ${widget.namaKaryawan}', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w300)),
                      SizedBox(height: 7.sp),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: (MediaQuery.of(context).size.height - 50.sp),
                        child: ListView.builder(
                          itemCount: myBusinessTrip.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 3.sp),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(ViewPerjalananDinas(
                                    perjalananDinasID: myBusinessTrip[index]['businesstrip_id'],
                                    perjalananDinasStatus: myBusinessTrip[index]['status_name'],
                                    tanggalPermohonan: myBusinessTrip[index]['insert_dt'],
                                    namaKota: myBusinessTrip[index]['nama_kota'],
                                    lamaDurasi: myBusinessTrip[index]['duration_name'],
                                    keterangan: myBusinessTrip[index]['reason'],
                                    tim: myBusinessTrip[index]['team'],
                                    pembayaran: myBusinessTrip[index]['payment_name'],
                                    tranportasi: myBusinessTrip[index]['transport_name'],
                                    namaKaryawan: myBusinessTrip[index]['employee_name'],
                                    namaDepartemen: myBusinessTrip[index]['department_name'],
                                    requestorID: myBusinessTrip[index]['insert_by'],
                                  ));
                                },
                                child: Card(
                                  child: ListTile(
                                    title: Text(myBusinessTrip[index]['employee_name'], style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w700)),
                                    subtitle: Text('${myBusinessTrip[index]['nama_kota']} (${myBusinessTrip[index]['duration_name']})', style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400)),
                                    trailing: Text(myBusinessTrip[index]['status_name'], style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700)),
                                  ),
                                ),
                              ),
                            );
                          }
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: (MediaQuery.of(context).size.width - 100.w) / 2,
              child: Card(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                color: Colors.white,
                shadowColor: Colors.black,
                child: Padding(
                  padding: EdgeInsets.all(4.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Laporan Perjalanan Dinas', style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w700)),
                      SizedBox(height: 1.sp),
                      Text('List laporan perjalanan dinas ${widget.namaKaryawan}', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w300)),
                      SizedBox(height: 7.sp),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: (MediaQuery.of(context).size.height - 50.sp),
                        child: ListView.builder(
                          itemCount: myLPD.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 3.sp),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(ViewLPD(businessTripID: myLPD[index]['businesstrip_id']));
                                },
                                child: Card(
                                  child: ListTile(
                                    title: Text(myLPD[index]['employee_name'], style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w700)),
                                    subtitle: Text('${myLPD[index]['name']} (${myLPD[index]['project_name']})', style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400)),
                                    trailing: Text(myLPD[index]['status_name'], style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700)),
                                  ),
                                ),
                              ),
                            );
                          }
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
