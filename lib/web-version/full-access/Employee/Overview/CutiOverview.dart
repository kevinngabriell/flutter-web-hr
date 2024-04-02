// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/EmployeeList.dart';
import 'package:hr_systems_web/web-version/full-access/leave/ViewOnly.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CutiOverview extends StatefulWidget {
  final String employeeId;
  final String namaKaryawan;

  const CutiOverview({super.key, required this.employeeId, required this.namaKaryawan});

  @override
  State<CutiOverview> createState() => _CutiOverviewState();
}

class _CutiOverviewState extends State<CutiOverview> {
  List<Map<String, dynamic>> permissionDataLimit = [];
  int? leaveCount;
  String expDateCuti = '';
  TextEditingController txtCutiUpdate = TextEditingController();
  bool isLoading = false;
  DateTime? expDate;
  TextEditingController txtCuti = TextEditingController();
  DateTime? TanggalExp;
  DateTime? TanggalExpUpdate;

  @override
  void initState() {
    super.initState();
    fetchLimitMyPermission();
    fetchLeaveCountsYears();
  }

  Future<void> inputUpdateJatahCuti() async {
    const String apiUrl = "https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/insertjatahcuti.php";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'employee_id': widget.employeeId,
          'jatah_cuti': txtCuti.text,
          'exp_date': TanggalExp.toString(),
        }
      );

      if (response.statusCode == 200) {
        Get.back();
        showDialog(
          context: context, 
          builder: (_) => AlertDialog(
            title: const Text("Sukses"),
            content: const Text("Jatah cuti telah berhasil diupdate"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Get.to(const EmployeeListPage()), 
                child: const Text("Kembali")
              ),
            ],
          )
        );
      } else {
        Get.snackbar("Error", "Gagal update jatah cuti");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal update jatah cuti: $e");
    }
  }

  Future<void> updateCuti() async {
    try {
      setState(() => isLoading = true);
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/updatecuti.php';
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "leave_update": txtCutiUpdate.text,
          "leave_before": txtCutiUpdate.text,
          "exp_update": TanggalExpUpdate.toString(),
          "exp_before": expDateCuti.toString(),
          "employee_id": widget.employeeId
        }
      );

      if (response.statusCode == 200) {
        Get.to(const EmployeeListPage());
      } else {
        Get.snackbar('Error', 'Gagal memperbarui cuti: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui cuti: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchLimitMyPermission() async {
    try {  
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/showmypermissionlimit.php?id=${widget.employeeId}';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          permissionDataLimit = List<Map<String, dynamic>>.from(data['Data']);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  
  Future<void> fetchLeaveCountsYears() async {
    try {
      setState(() => isLoading = true);
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/getangkacutibyid.php?employee_id=${widget.employeeId}';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        Map<String, dynamic> data = (responseData['Data'] as List).first;
        final formatter = DateFormat('d MMMM yyyy');
        expDate = DateTime.parse(data['expired_date'].toString());
        String formattedExpDate = formatter.format(expDate!);

        setState(() {
          leaveCount = int.parse(data['leave_count'].toString());
          txtCutiUpdate.text = leaveCount.toString();
          expDateCuti = formattedExpDate;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Widget buildLeaveCard() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: GestureDetector(
        onTap: () => showDialog(
          context: context, 
          builder: (context) => buildUpdateDialog(context)
        ),
        child: Card(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          color: Colors.white,
          shadowColor: Colors.black,
          child: Padding(
            padding: EdgeInsets.all(5.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  leaveCount.toString(),
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
                ),
                Text(
                  'Masa berakhir cuti $expDateCuti',
                  style: TextStyle(fontSize: 4.5.sp, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AlertDialog buildUpdateDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Update Cuti',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w800),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Cuti tahunan'),
            SizedBox(height: 10.h),
            TextFormField(
              controller: txtCutiUpdate,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan jumlah cuti'
              ),
            ),
            SizedBox(height: 20.h),
            const Text('Masa akhir cuti'),
            SizedBox(height: 10.h),
            DateTimePicker(
              firstDate: DateTime.now(),
              lastDate: DateTime(2055),
              initialDate: expDate ?? DateTime.now(),
              dateMask: 'd MMM yyyy',
              onChanged: (value) => setState(() {
                TanggalExpUpdate = DateFormat('yyyy-MM-dd').parse(value);
              }),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (double.tryParse(txtCutiUpdate.text) != null) {
              updateCuti();
            } else {
              Get.snackbar('Error', 'Cuti harus berisi angka saja dan tidak dapat kosong');
            }
          },
          child: const Text('Update')
        ),
        TextButton(
          onPressed: () => Get.back(), 
          child: const Text('Batal')
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: 10.h),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(40.w, 55.h),
            foregroundColor: const Color(0xFFFFFFFF),
            backgroundColor: const Color(0xff4ec3fc),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Input/Update Cuti', textAlign: TextAlign.center),
          onPressed: () => showDialog(
            context: context, 
            builder: (context) => buildInputDialog(context)
          ),
        ),
        SizedBox(height: 15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildLeaveCard()
          ],
        ),
        SizedBox(height: 25.h),
        SizedBox(
          width: (MediaQuery.of(context).size.width - 100.w),
          child: Card(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            color: Colors.white,
            shadowColor: Colors.black,
            child: Padding(
              padding: EdgeInsets.all(4.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Izin ${widget.namaKaryawan}',
                    style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Kelola dan tijau izin yang telah diajukan',
                    style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w300),
                  ),
                  SizedBox(height: 4.sp),
                  for (var permission in permissionDataLimit.take(500))
                    GestureDetector(
                      onTap: () => Get.to(ViewOnlyPermission(permission_id: permission['id_permission'])),
                      child: ListTile(
                        title: Text(
                          '${permission['employee_name']} | ${permission['permission_type_name']}',
                          style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          permission['permission_status_name'],
                          style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  AlertDialog buildInputDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Input Cuti',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w800),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Cuti tahunan'),
            SizedBox(height: 10.h),
            TextFormField(
              controller: txtCuti,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan jumlah cuti'
              ),
            ),
            SizedBox(height: 20.h),
            const Text('Masa akhir cuti'),
            SizedBox(height: 10.h),
            DateTimePicker(
              firstDate: DateTime.now(),
              lastDate: DateTime(2055),
              initialDate: DateTime.now(),
              dateMask: 'd MMM yyyy',
              onChanged: (value) => setState(() {
                TanggalExp = DateFormat('yyyy-MM-dd').parse(value);
              }),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (double.tryParse(txtCuti.text) != null) {
              inputUpdateJatahCuti();
            } else {
              Get.snackbar('Error', 'Cuti harus berisi angka saja dan tidak dapat kosong');
            }
          },
          child: const Text('Submit')
        ),
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel')
        ),
      ],
    );
  }
}
