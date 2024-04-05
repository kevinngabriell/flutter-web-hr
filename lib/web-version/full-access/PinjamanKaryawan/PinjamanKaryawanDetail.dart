// ignore_for_file: use_build_context_synchronously, avoid_print, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/services/pdf_downloader.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:hr_systems_web/web-version/full-access/PinjamanKaryawan/PinjamanKaryawanIndex.dart';
import 'package:hr_systems_web/web-version/full-access/Salary/currencyformatter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class PinjamanKaryawanDetail extends StatefulWidget {
  final String pinjamanKaryawanID;
  final String jumlahPinjaman;
  final String alasanPinjaman;
  final String caraBayarPinjaman;
  final String statusPinjaman;
  final String sudahLunasPinjaman;
  final String tanggalPengajuan;
  final String namaKaryawan;
  final String requestorID;
  final String jabatan;
  final String departemen;
  const PinjamanKaryawanDetail({super.key, required this.pinjamanKaryawanID, required this.jumlahPinjaman, required this.alasanPinjaman, required this.caraBayarPinjaman, required this.statusPinjaman, required this.sudahLunasPinjaman, required this.tanggalPengajuan, required this.namaKaryawan, required this.requestorID, required this.jabatan, required this.departemen});

  @override
  State<PinjamanKaryawanDetail> createState() => _PinjamanKaryawanDetailState();
}

class _PinjamanKaryawanDetailState extends State<PinjamanKaryawanDetail> {
  String? leaveoptions;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  bool isLoading = false;
  List<Map<String, dynamic>> noticationList = [];
  List<Map<String, dynamic>> historyList = [];
  TextEditingController txtAmountPembayaran = TextEditingController();
  List<Map<String, dynamic>> kasbonData = [];
  String employeeSPV = '';
  String namaSPV = '';
  String tanggalSPV = '';
  String namaHRD = '';
  String tanggalHRD = '';

  String formatCurrency2(String value) {
    // Parse the string to a number.
    double numberValue = double.tryParse(value) ?? 0;

    // Format the number as currency.
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0).format(numberValue);
  }

  @override
  void initState() {
    super.initState();
    fetchNotification();
    fetchData();
    fetchEmployeeSPV();
    fetchHistory();
    fetchKasbonData();
  }

  Future<void> fetchKasbonData() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/loan/getloan.php?action=7&id_pinjaman=${widget.pinjamanKaryawanID}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        kasbonData = List<Map<String, dynamic>>.from(data['Data']);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> actionKasbon() async {
    try{
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/loan/loan.php';
      String employeeId = storage.read('employee_id').toString();

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "action" : "7",
          "loan_id" : widget.pinjamanKaryawanID,
          "amount" : txtAmountPembayaran.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "insert_by" : employeeId,
        }
      );

      if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil update data pinjaman'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PinjamanKaryawanIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        } else {
          print(response.body + response.statusCode.toString());
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error ${response.statusCode}'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PinjamanKaryawanIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        }
    } catch (e){
      isLoading = false;
      showDialog(
        context: context, 
        builder: (_) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text('Error $e'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.to(const PinjamanKaryawanIndex());
              }, 
              child: const Text("Oke")
            ),
          ],
        );}
      );
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchHistory() async {
    try{  
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/loan/getloan.php?action=4&loan_id=${widget.pinjamanKaryawanID}';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          historyList = List<Map<String, dynamic>>.from(data['Data']);
        });
      } else if (response.statusCode == 404){
        print('404, No Data Found');
      }

    } catch (e){
      print('Error: $e');
    }
  }

  Future<void> fetchEmployeeSPV() async {
    String employeeId = storage.read('employee_id').toString();
    String url = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployee.php?action=2&employee_id=${widget.requestorID}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      setState(() {
        List<dynamic> employee = data['Data'];
        if (employee.isNotEmpty) {
          employeeSPV = employee.isNotEmpty ? employee[0]['employee_spv'] : '-';
        }
      });
    } else {
      // Handle the case where the server did not return a 200 OK response
      print("Failed to load members data");
    }

    String mengetahuiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/loan/getloan.php?action=6&loan_id=${widget.pinjamanKaryawanID}';
    final mengetahuiResponse = await http.get(Uri.parse(mengetahuiUrl));

    if (mengetahuiResponse.statusCode == 200) {
      var mengetahuiData = json.decode(mengetahuiResponse.body);

      setState(() {
        List<dynamic> mengetahuiHasil = mengetahuiData['Data'];
        if (mengetahuiHasil.isNotEmpty) {
          namaSPV = mengetahuiHasil.isNotEmpty ? mengetahuiHasil[0]['employee_name'] : '-';
          tanggalSPV = mengetahuiHasil.isNotEmpty ? _formatDate(mengetahuiHasil[0]['action_dt']) : '-';
        }
      });
    } else {
      // Handle the case where the server did not return a 200 OK response
      print("Failed to load members data");
    }

    String menyetujuiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/loan/getloan.php?action=5&loan_id=${widget.pinjamanKaryawanID}';
    final menyetujuiResponse = await http.get(Uri.parse(menyetujuiUrl));

    if (menyetujuiResponse.statusCode == 200) {
      var menyetujuiData = json.decode(menyetujuiResponse.body);

      setState(() {
        List<dynamic> menyetujuiHasil = menyetujuiData['Data'];
        if (menyetujuiHasil.isNotEmpty) {
          namaHRD = menyetujuiHasil.isNotEmpty ? menyetujuiHasil[0]['employee_name'] : '-';
          tanggalHRD = menyetujuiHasil.isNotEmpty ? _formatDate(menyetujuiHasil[0]['action_dt']) : '-';
        }
      });
    } else {
      // Handle the case where the server did not return a 200 OK response
      print("Failed to load members data");
    }
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
    isLoading = true;
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
      isLoading = false;
    }
  }
  
  Future<void> actionPinjamanKaryawan(actionId) async {
    String apiUrl = "https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/loan/loan.php";
    String employeeId = storage.read('employee_id').toString();

    if(actionId == '1'){
      try{
        isLoading = true;

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "action" : "3",
            "loan_id": widget.pinjamanKaryawanID,
            "employee_id": widget.requestorID,
            "spv_id" : employeeId,
          }
        );

        if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil mengubah status pinjaman karyawan'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PinjamanKaryawanIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        } else {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error ${response.body}'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PinjamanKaryawanIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        }

      } catch (e){
        showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error $e'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PinjamanKaryawanIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
      } finally {
        isLoading = false;
      }
    } else if (actionId == '2'){
      try{
        isLoading = true;

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "action" : "4",
            "loan_id": widget.pinjamanKaryawanID,
            "employee_id": widget.requestorID,
            "spv_id" : employeeId,
            "employee_name" : widget.namaKaryawan
          }
        );

        if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil mengubah status pinjaman karyawan'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PinjamanKaryawanIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        } else {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error ${response.body}'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PinjamanKaryawanIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        }

      } catch (e){
        showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error $e'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PinjamanKaryawanIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
      } finally {
        isLoading = false;
      }
    } else if (actionId == '3'){
      try{
        isLoading = true;

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "action" : "5",
            "loan_id": widget.pinjamanKaryawanID,
            "employee_id": widget.requestorID,
            "hrd_id" : employeeId
          }
        );

        if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil mengubah status pinjaman karyawan'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PinjamanKaryawanIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        } else {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error ${response.body}'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PinjamanKaryawanIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        }

      } catch (e){
        showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error $e'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PinjamanKaryawanIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
      } finally {
        isLoading = false;
      }
    } else if (actionId == '4'){
      try{
        isLoading = true;

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "action" : "6",
            "loan_id": widget.pinjamanKaryawanID,
            "employee_id": widget.requestorID,
            "hrd_id" : employeeId,
            "employee_name" : widget.namaKaryawan
          }
        );

        if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil mengubah status pinjaman karyawan'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PinjamanKaryawanIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        } else {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error ${response.body}'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PinjamanKaryawanIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        }

      } catch (e){
        showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error $e'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PinjamanKaryawanIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
      } finally {
        isLoading = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    var employeeId = storage.read('employee_id');
    var photo = storage.read('photo');
    var positionId = storage.read('position_id');
    String numberAsString = employeeId.toString().padLeft(10, '0');

    String lunas = widget.sudahLunasPinjaman == '0' ? 'Belum Lunas' : 'Sudah Lunas';
    return MaterialApp(
      title: 'Pinjaman Karyawan',
      home: SafeArea(
        child: Scaffold(
          body: isLoading ? const Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
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
                        SizedBox(height: 7.sp,),
                        Center(child: Text('Pengajuan Pinjaman Karyawan', style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w600,))),
                        SizedBox(height: 7.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showTransactionHistory();
                              },
                              child: Text('Riwayat Transaksi', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w400, color: const Color(0xFF2A85FF)))
                            )
                          ],
                        ),
                        SizedBox(height: 7.sp,),
                        Padding(
                          padding: EdgeInsets.only(right: 10.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Status Pinjaman', style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(lunas),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Status Permohonan', style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(widget.statusPinjaman),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Tanggal Permohonan', style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(_formatDate(widget.tanggalPengajuan)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 7.sp,),
                        Text('Detail Permohonan', style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w600,)),
                        SizedBox(height: 7.sp,),
                        Padding(
                          padding: EdgeInsets.only(right: 10.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Nama Karyawan', style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(widget.namaKaryawan),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Departemen', style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(widget.departemen),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Jabatan', style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(widget.jabatan),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 7.sp,),
                        Padding(
                          padding: EdgeInsets.only(right: 10.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Besar Pinjaman', style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(formatCurrency2(widget.jumlahPinjaman)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Keperluan Pinjaman', style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(widget.alasanPinjaman),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Cara Membayar', style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(widget.caraBayarPinjaman),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if(employeeSPV == numberAsString && widget.statusPinjaman == 'Draft')
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: (){
                                      actionPinjamanKaryawan('1');
                                    }, 
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      alignment: Alignment.center,
                                      minimumSize: Size(40.w, 55.h),
                                      foregroundColor: const Color(0xFFFFFFFF),
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Tolak')
                                  ),
                                  SizedBox(width: 5.w,),
                                  ElevatedButton(
                                    onPressed: (){
                                      actionPinjamanKaryawan('2');
                                    }, 
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      alignment: Alignment.center,
                                      minimumSize: Size(40.w, 55.h),
                                      foregroundColor: const Color(0xFFFFFFFF),
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Terima')
                                  )
                                ],
                              ),
                            if(positionId == 'POS-HR-002' && widget.statusPinjaman == 'Disetujui oleh manager')
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: (){
                                      actionPinjamanKaryawan('3');
                                    }, 
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      alignment: Alignment.center,
                                      minimumSize: Size(40.w, 55.h),
                                      foregroundColor: const Color(0xFFFFFFFF),
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Tolak')
                                  ),
                                  SizedBox(width: 5.w,),
                                  ElevatedButton(
                                    onPressed: (){
                                      actionPinjamanKaryawan('4');
                                    }, 
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      alignment: Alignment.center,
                                      minimumSize: Size(40.w, 55.h),
                                      foregroundColor: const Color(0xFFFFFFFF),
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Terima')
                                  )
                                ],
                              ),
                            if(widget.statusPinjaman == 'Disetujui oleh HRD')
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: (){
                                      showDialogpembayaran();
                                    }, 
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      alignment: Alignment.center,
                                      minimumSize: Size(40.w, 55.h),
                                      foregroundColor: const Color(0xFFFFFFFF),
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Pembayaran')
                                  ),
                                  SizedBox(width: 5.w,),
                                  ElevatedButton(
                                    onPressed: (){
                                      String a = widget.pinjamanKaryawanID;
                                      String b = widget.namaKaryawan;
                                      String c = widget.jabatan;
                                      String d = formatCurrency2(widget.jumlahPinjaman);
                                      String e = widget.alasanPinjaman;
                                      String f = widget.caraBayarPinjaman;
                                      String g = _formatDate(widget.tanggalPengajuan);
                                      // String h = _formatDate(tanggalSPV);
                                      // String i = _formatDate(tanggalHRD);
                                  
                                      generateAndDisplayPDFPinjamanKaryawan(companyName, companyAddress, a, b, c, d, e, f, namaSPV, tanggalSPV, namaHRD, tanggalHRD, g);
                                    }, 
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      alignment: Alignment.center,
                                      minimumSize: Size(40.w, 55.h),
                                      foregroundColor: const Color(0xFFFFFFFF),
                                      backgroundColor: const Color(0xff4ec3fc),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Download PDF')
                                  ),
                                ],
                              )
                          ]
                        ),
                        SizedBox(height: 10.sp,),
                        Text('Riwayat Permohonan', style: TextStyle(fontSize: 7.sp,fontWeight: FontWeight.w600,)),
                        SizedBox(height: 5.sp,),
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            itemCount: historyList.length,
                            itemBuilder: (context, index){
                              var item = historyList[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xff4ec3fc),
                                  child: Text('${index + 1}', style: const TextStyle(color: Colors.white),),
                                ),
                                title: Text(item['employee_name'], style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w600),),
                                subtitle: Text(item['action'], style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),),
                                trailing: Text(_formatDate(item['action_dt']), style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),),
                              );
                            }
                          ),
                        ),
                        SizedBox(height: 10.sp,),
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

  Future<void> showDialogpembayaran(){
    return showDialog(
      context: context, 
      builder: (_){
        return AlertDialog(
          title: Text('Pembayaran Pinjaman Karyawan'),
          content: TextFormField(
            controller: txtAmountPembayaran,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CurrencyFormatter(),
            ],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              fillColor: Color.fromRGBO(235, 235, 235, 1),
              hintText: 'Masukkan jumlah pembayaran'
            ),
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
                actionKasbon();
              }, 
              child: Text('Kumpulkan')
            )
          ],
        );
      }
    );
  }

  Future<void> showTransactionHistory(){
    return showDialog(
      context: context, 
      builder: (_){
        return AlertDialog(
          title: Center(child: Text('Riwayat Pembayaran')),
          content: 
          DataTable(
            columns: [
              DataColumn(label: Text('Jenis Pinjaman')),
              DataColumn(label: Text('Jumlah')),
              DataColumn(label: Text('Tanggal')),
            ],
            rows: kasbonData.map((data) {
              String paymentLabel =
                  data['transaction'] == 1 ? 'Pembayaran' : 'Pinjaman';
              return DataRow(cells: [
                DataCell(Text(paymentLabel)),
                DataCell(Text(formatCurrency2(data['amount'].toString()))),
                DataCell(Text(_formatDate(data['transaction_date']))),
              ]);
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: (){
                Get.back();
              }, 
              child: Text('Tutup')
            )
          ],
        );
      }
    );
  }

  String _formatDate(String date) {
    // Parse the date string
    DateTime parsedDate = DateFormat("yyyy-MM-dd HH:mm").parse(date);

    // Format the date as "dd MMMM yyyy"
    return DateFormat("d MMMM yyyy HH:mm", "id").format(parsedDate);
  }
}