// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/logout.dart';
import 'package:hr_systems_web/web-version/full-access/Event/event.dart';
import 'package:hr_systems_web/web-version/full-access/Performance/performance.dart';
import 'package:hr_systems_web/web-version/full-access/Report/report.dart';
import 'package:hr_systems_web/web-version/full-access/Salary/salary.dart';
import 'package:hr_systems_web/web-version/full-access/Settings/setting.dart';
import 'package:hr_systems_web/web-version/full-access/Structure/structure.dart';
import 'package:hr_systems_web/web-version/full-access/Training/traning.dart';
import 'package:hr_systems_web/web-version/full-access/employee.dart';
import 'package:hr_systems_web/web-version/full-access/index.dart';
import 'package:hr_systems_web/web-version/full-access/profile.dart';
import 'package:intl/intl.dart';

class NamaPerusahaanMenu extends StatefulWidget {
  final String companyName;
  final String companyAddress;
  const NamaPerusahaanMenu({super.key, required this.companyName, required this.companyAddress});

  @override
  State<NamaPerusahaanMenu> createState() => _NamaPerusahaanMenuState();
}

class _NamaPerusahaanMenuState extends State<NamaPerusahaanMenu> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 0, right: 0),
      dense: true,
      horizontalTitleGap: 0.0,
      leading: Container(
        margin: const EdgeInsets.only(right: 2.0), // Add margin to the right of the image
          child: Image.asset(
            'images/kinglab.png',width: MediaQuery.of(context).size.width * 0.08,
          ),
      ),
      title: Text(widget.companyName,style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w300),),
      subtitle: Text(widget.companyAddress, style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w300),),
    );
  }
}

class BerandaActive extends StatefulWidget {
  final String employeeId;
  const BerandaActive({super.key, required this.employeeId});

  @override
  State<BerandaActive> createState() => _BerandaActiveState();
}

class _BerandaActiveState extends State<BerandaActive> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: ElevatedButton(
        onPressed: () {Get.to(FullIndexWeb(widget.employeeId));},
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
              child: Image.asset('images/home-active.png')
            ),
            SizedBox(width: 2.w),
            Text('Beranda',style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w600,) )
          ],
        )
      ),
    );
  }
}

class HalamanUtamaMenu extends StatefulWidget {
  const HalamanUtamaMenu({super.key});

  @override
  State<HalamanUtamaMenu> createState() => _HalamanUtamaMenuState();
}

class _HalamanUtamaMenuState extends State<HalamanUtamaMenu> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w),
      child: Text("Halaman utama", style: TextStyle( fontSize: 6.sp, fontWeight: FontWeight.w600,)),
    );
  }
}

class KaryawanNonActive extends StatefulWidget {
  final String employeeId;
  const KaryawanNonActive({super.key, required this.employeeId});

  @override
  State<KaryawanNonActive> createState() => _KaryawanNonActiveState();
}

class _KaryawanNonActiveState extends State<KaryawanNonActive> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
        child: ElevatedButton(
          onPressed: () {Get.to(EmployeePage(employee_id: widget.employeeId));},
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
              Text('Karyawan',style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w600,))
            ],
          )
        ),
      );
  }
}

class GajiNonActive extends StatefulWidget {
  const GajiNonActive({super.key});

  @override
  State<GajiNonActive> createState() => _GajiNonActiveState();
}

class _GajiNonActiveState extends State<GajiNonActive> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: ElevatedButton(
        onPressed: () {Get.to(const SalaryIndex());},
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
            Text('Gaji',style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w600,))
          ],
        )
      ),
    );
  }
}

class PerformaNonActive extends StatefulWidget {
  const PerformaNonActive({super.key});

  @override
  State<PerformaNonActive> createState() => _PerformaNonActiveState();
}

class _PerformaNonActiveState extends State<PerformaNonActive> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: ElevatedButton(
        onPressed: () { Get.to(const PerformanceIndex());},
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
            Container( alignment: Alignment.centerLeft, child: Image.asset('images/performa-inactive.png')),
            SizedBox(width: 2.w),
            Text('Performa', style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w600,))
          ],
        )
      ),
    );
  }
}

class PelatihanNonActive extends StatefulWidget {
  const PelatihanNonActive({super.key});

  @override
  State<PelatihanNonActive> createState() => _PelatihanNonActiveState();
}

class _PelatihanNonActiveState extends State<PelatihanNonActive> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: ElevatedButton(
        onPressed: () {Get.to(const TrainingIndex());},
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
            Text('Pelatihan',style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w600,))
          ],
        )
      ),
    );
  }
}

class AcaraNonActive extends StatefulWidget {
  const AcaraNonActive({super.key});

  @override
  State<AcaraNonActive> createState() => _AcaraNonActiveState();
}

class _AcaraNonActiveState extends State<AcaraNonActive> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: ElevatedButton(
        onPressed: () {Get.to(const EventIndex());},
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
            Text('Acara',style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w600,))
          ],
        )
      ),
    );
  }
}

class LaporanNonActive extends StatefulWidget {
  final String positionId;
  const LaporanNonActive({super.key, required this.positionId});

  @override
  State<LaporanNonActive> createState() => _LaporanNonActiveState();
}

class _LaporanNonActiveState extends State<LaporanNonActive> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: ElevatedButton(
        onPressed: () {
          if(widget.positionId == 'POS-HR-002' || widget.positionId == 'POS-HR-008'){
            Get.to(const ReportIndex());
          } else {
            showDialog(
              context: context, 
              builder: (_) {
                return AlertDialog(
                  title: const Text("Error"),
                  content: const Text('Anda tidak memiliki akses ke menu ini'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {Get.back();},
                      child: const Text('OK',),
                    ),
                  ],
                );
              }
            );
          }
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
            Text('Laporan', style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w600,))
          ],
        )
      ),
    );
  }
}

class PengaturanMenu extends StatefulWidget {
  const PengaturanMenu({super.key});

  @override
  State<PengaturanMenu> createState() => _PengaturanMenuState();
}

class _PengaturanMenuState extends State<PengaturanMenu> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w),
      child: Text("Pengaturan", style: TextStyle( fontSize: 6.sp, fontWeight: FontWeight.w600,)),
    );
  }
}

class PengaturanNonActive extends StatefulWidget {
  const PengaturanNonActive({super.key});

  @override
  State<PengaturanNonActive> createState() => _PengaturanNonActiveState();
}

class _PengaturanNonActiveState extends State<PengaturanNonActive> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: ElevatedButton(
        onPressed: () {Get.to(const SettingIndex());},
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
            Text('Pengaturan',style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w600,) )
          ],
        )
      ),
    );
  }
}

class StrukturNonActive extends StatefulWidget {
  const StrukturNonActive({super.key});

  @override
  State<StrukturNonActive> createState() => _StrukturNonActiveState();
}

class _StrukturNonActiveState extends State<StrukturNonActive> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: ElevatedButton(
        onPressed: () {Get.to(const StructureIndex());},
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
            Text('Struktur',style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w600,) )
          ],
        )
      ),
    );
  }
}

class Logout extends StatefulWidget {
  const Logout({super.key});

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: ElevatedButton(
        onPressed: () async {
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
                    onPressed: () {logoutServicesWeb();},
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
            Text('Keluar', style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w600, color: Colors.red))
          ],
        )
      ),
    );
  }
}

class NotificationnProfile extends StatefulWidget {
  final String employeeName;
  final String employeeAddress;
  final String photo;
  const NotificationnProfile({super.key, required this.employeeName, required this.employeeAddress, required this.photo});

  @override
  State<NotificationnProfile> createState() => _NotificationnProfileState();
}

class _NotificationnProfileState extends State<NotificationnProfile> {
  List<Map<String, dynamic>> noticationList = [];
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    fetchNotification();
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 5.sp),
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
                        Text('Notifikasi', style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w700,)),
                        GestureDetector(
                          onTap: () {},
                          child: Text('Hapus semua', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w600,)),
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
                                    title: Center(child: Text("${noticationList[index]['title']} ", style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w700))),
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
                                        onPressed: () {Get.back();}, 
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
                                title: Text(index < noticationList.length ? '${noticationList[index]['title']} ' : '-',style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w600),),
                                subtitle: Text(index < noticationList.length ? 'From ${noticationList[index]['sender'] == 'Kevin Gabriel Florentino' ? 'System' : noticationList[index]['sender']} ' : '-', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w400),),
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
                Icon(Icons.notifications, size: 7.sp,),
                Positioned(top: 0, right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                    child: Text(noticationList.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 5.sp,),
          GestureDetector(
            onTap: () {Get.to(const ProfilePage());},
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 290.w,
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 0, right: 0),
                dense: true,
                horizontalTitleGap: 20.0,
                leading: Container(margin: const EdgeInsets.only(right: 2.0), child: Image.memory(base64Decode(widget.photo),),),
                title: Text(widget.employeeName, style: TextStyle( fontSize: 4.sp, fontWeight: FontWeight.w300,),),
                subtitle: Text(widget.employeeAddress, style: TextStyle( fontSize: 4.sp, fontWeight: FontWeight.w300,),),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    // Parse the date string
    DateTime parsedDate = DateFormat("yyyy-MM-dd HH:mm").parse(date);

    // Format the date as "dd MMMM yyyy"
    return DateFormat("d MMMM yyyy HH:mm", "id").format(parsedDate);
  }
}

class KaryawanActive extends StatefulWidget {
  final String employeeId;
  const KaryawanActive({super.key, required this.employeeId});

  @override
  State<KaryawanActive> createState() => _KaryawanActiveState();
}

class _KaryawanActiveState extends State<KaryawanActive> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: ElevatedButton(
        onPressed: () {Get.to(EmployeePage(employee_id: widget.employeeId));},
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
            Text('Karyawan',style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w600,))
          ],
        )
      ),
    );
  }
}

class BerandaNonActive extends StatefulWidget {
  final String employeeId;
  const BerandaNonActive({super.key, required this.employeeId});

  @override
  State<BerandaNonActive> createState() => _BerandaNonActiveState();
}

class _BerandaNonActiveState extends State<BerandaNonActive> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: ElevatedButton(
        onPressed: () {Get.to(FullIndexWeb(widget.employeeId));},
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
              Text('Beranda', style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w600,))
            ],
          )
        ),
      );
  }
}

class GajiActive extends StatefulWidget {
  const GajiActive({super.key});

  @override
  State<GajiActive> createState() => _GajiActiveState();
}

class _GajiActiveState extends State<GajiActive> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: ElevatedButton(
        onPressed: () {Get.to(const SalaryIndex());},
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
              child: Image.asset('images/gaji-active.png')
            ),
            SizedBox(width: 2.w),
            Text('Gaji',style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w600,))
          ],
        )
      ),
    );
  }
}

class PerformaActive extends StatefulWidget {
  const PerformaActive({super.key});

  @override
  State<PerformaActive> createState() => _PerformaActiveState();
}

class _PerformaActiveState extends State<PerformaActive> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: ElevatedButton(
        onPressed: () { Get.to(const PerformanceIndex());},
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
              child: Image.asset('images/performa-active.png')
            ),
            SizedBox(width: 2.w),
            Text('Performa', style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w600,))
          ],
        )
      ),
    );
  }
}

class PelatihanActive extends StatefulWidget {
  const PelatihanActive({super.key});

  @override
  State<PelatihanActive> createState() => _PelatihanActiveState();
}

class _PelatihanActiveState extends State<PelatihanActive> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: ElevatedButton(
        onPressed: () {Get.to(const TrainingIndex());},
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
              child: Image.asset('images/pelatihan-active.png')
            ),
            SizedBox(width: 2.w),
            Text('Pelatihan',style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w600,))
          ],
        )
      ),
    );
  }
}

class AcaraActive extends StatefulWidget {
  const AcaraActive({super.key});

  @override
  State<AcaraActive> createState() => _AcaraActiveState();
}

class _AcaraActiveState extends State<AcaraActive> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: ElevatedButton(
        onPressed: () {Get.to(const EventIndex());},
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
            Text('Acara',style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w600,))
          ],
        )
      ),
    );
  }
}

class LaporanActive extends StatefulWidget {
  const LaporanActive({super.key});

  @override
  State<LaporanActive> createState() => _LaporanActiveState();
}

class _LaporanActiveState extends State<LaporanActive> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: ElevatedButton(
        onPressed: () {},
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
              child: Image.asset('images/laporan-active.png')
            ),
            SizedBox(width: 2.w),
            Text('Laporan',style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,))
          ],
        )
      ),
    );
  }
}

class PengaturanActive extends StatefulWidget {
  const PengaturanActive({super.key});

  @override
  State<PengaturanActive> createState() => _PengaturanActiveState();
}

class _PengaturanActiveState extends State<PengaturanActive> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: ElevatedButton(
        onPressed: () {},
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
              child: Image.asset('images/pengaturan-active.png')
            ),
            SizedBox(width: 2.w),
            Text('Pengaturan',style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,))
          ],
        )
      ),
    );
  }
}

class StrukturActive extends StatefulWidget {
  const StrukturActive({super.key});

  @override
  State<StrukturActive> createState() => _StrukturActiveState();
}

class _StrukturActiveState extends State<StrukturActive> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: ElevatedButton(
        onPressed: () {
          Get.to(const StructureIndex());
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
              child: Image.asset('images/struktur-active.png')
            ),
            SizedBox(width: 2.w),
            Text('Struktur',style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,))
          ],
        )
      ),
    );
  }
}