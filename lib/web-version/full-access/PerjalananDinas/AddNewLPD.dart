// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Event/event.dart';
import 'package:hr_systems_web/web-version/full-access/Performance/performance.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/PerjalananDinasIndex.dart';
import 'package:hr_systems_web/web-version/full-access/Report/report.dart';
import 'package:hr_systems_web/web-version/full-access/Salary/currencyformatter.dart';
import 'package:hr_systems_web/web-version/full-access/Salary/salary.dart';
import 'package:hr_systems_web/web-version/full-access/Settings/setting.dart';
import 'package:hr_systems_web/web-version/full-access/Structure/structure.dart';
import 'package:hr_systems_web/web-version/full-access/Training/traning.dart';
import 'package:hr_systems_web/web-version/full-access/profile.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import '../../login.dart';
import '../employee.dart';
import '../index.dart';

class AddNewLPD extends StatefulWidget {
  final String businesstrip_id;
  final String employeeName;
  final String departmentName;
  final String memberOne;
  final String memberTwo;
  final String memberThree;
  final String memberFour;
  final String spvId;
  const AddNewLPD({super.key, required this.businesstrip_id, required this.employeeName, required this.departmentName, required this.memberOne, required this.memberTwo, required this.memberThree, required this.memberFour, required this.spvId});

  @override
  State<AddNewLPD> createState() => _AddNewLPDState();
}

class _AddNewLPDState extends State<AddNewLPD> {
  String? leaveoptions;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  bool isLoading = false;

  List<Map<String, dynamic>> noticationList = [];

  TextEditingController txtNamaProject = TextEditingController();
  TextEditingController txtHariTiketPesawat = TextEditingController();
  TextEditingController txtHariHotel = TextEditingController();

  TextEditingController txtHariUangSaku = TextEditingController();
  TextEditingController txtHariUangSakuDua = TextEditingController();
  TextEditingController txtHariUangSakuTiga = TextEditingController();
  TextEditingController txtHariUangSakuEmpat = TextEditingController();
  TextEditingController txtHariUangSakuLima = TextEditingController();

  TextEditingController txtHariTransport = TextEditingController();

  TextEditingController txtHariUangMakan = TextEditingController();
  TextEditingController txtHariUangMakanDua = TextEditingController();
  TextEditingController txtHariUangMakanTiga = TextEditingController();
  TextEditingController txtHariUangMakanEmpat = TextEditingController();
  TextEditingController txtHariUangMakanLima = TextEditingController();

  TextEditingController txtHariByEntertain = TextEditingController();
  TextEditingController txtHariLain = TextEditingController();
  TextEditingController txtSatuanTiketPesawat = TextEditingController();
  TextEditingController txtSatuanHotel = TextEditingController();

  TextEditingController txtSatuanUangSaku = TextEditingController();
  TextEditingController txtSatuanUangSakuDua = TextEditingController();
  TextEditingController txtSatuanUangSakuTiga = TextEditingController();
  TextEditingController txtSatuanUangSakuEmpat = TextEditingController();
  TextEditingController txtSatuanUangSakuLima = TextEditingController();

  TextEditingController txtSatuanTransport = TextEditingController();

  TextEditingController txtSatuanUangMakan = TextEditingController();
  TextEditingController txtSatuanUangMakanDua = TextEditingController();
  TextEditingController txtSatuanUangMakanTiga = TextEditingController();
  TextEditingController txtSatuanUangMakanEmpat = TextEditingController();
  TextEditingController txtSatuanUangMakanLima = TextEditingController();

  TextEditingController txtSatuanByEntertain = TextEditingController();
  TextEditingController txtSatuanLain = TextEditingController();
  TextEditingController txtJumlahBiayaTiketPesawat = TextEditingController();
  TextEditingController txtJumlahBiayaHotel = TextEditingController();

  TextEditingController txtJumlahBiayaUangSaku = TextEditingController();
  TextEditingController txtJumlahBiayaUangSakuDua = TextEditingController();
  TextEditingController txtJumlahBiayaUangSakuTiga = TextEditingController();
  TextEditingController txtJumlahBiayaUangSakuEmpat = TextEditingController();
  TextEditingController txtJumlahBiayaUangSakuLima = TextEditingController();

  TextEditingController txtJumlahBiayaTransport = TextEditingController();

  TextEditingController txtJumlahBiayaUangMakan = TextEditingController();
  TextEditingController txtJumlahBiayaUangMakanDua = TextEditingController();
  TextEditingController txtJumlahBiayaUangMakanTiga = TextEditingController();
  TextEditingController txtJumlahBiayaUangMakanEmpat = TextEditingController();
  TextEditingController txtJumlahBiayaUangMakanLima = TextEditingController();

  TextEditingController txtJumlahBiayaByEntertain = TextEditingController();
  TextEditingController txtJumlahBiayaLain = TextEditingController();
  TextEditingController txtIDLPD = TextEditingController();
  TextEditingController txtUraianLPD = TextEditingController();
  DateTime? TanggalMulai;
  DateTime? TanggalAkhir;
  double JumlahBiayaTiket = 0;
  double JumlahTiket = 0;
  double JumlahHotel = 0;
  double JumlahUangSaku = 0;
  double JumlahUangSakuDua = 0;
  double JumlahUangSakuTiga = 0;
  double JumlahUangSakuEmpat = 0;
  double JumlahUangSakuLima = 0;
  double JumlahTransport = 0;
  double JumlahUangMakan = 0;
  double JumlahUangMakanDua = 0;
  double JumlahUangMakanTiga = 0;
  double JumlahUangMakanEmpat = 0;
  double JumlahUangMakanLima = 0;
  double JumlahEntertain = 0;
  double JumlahLain = 0;
  double GrandTotal = 0;

  TextEditingController txtAdvanced = TextEditingController();
  double Kekurangan = 0;

  String spvName = '';
  String lastIDPLD = '';

  String formatCurrency(double value) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0).format(value);
  }

  @override
  void initState() {
    super.initState();
    fetchNotification();
    fetchData();
    fetchFilledData();
  }

  Future<void> fetchFilledData() async {
    try{
      isLoading = true;

      String spvNameAPI = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployee.php?action=3&spv_id=${widget.spvId}';
      final spvNameResponse = await http.get(Uri.parse(spvNameAPI));

      if (spvNameResponse.statusCode == 200) {
        var spvNamedata = json.decode(spvNameResponse.body);

        setState(() {
          List<dynamic> spv = spvNamedata['Data'];
          if (spv.isNotEmpty) {
            spvName = spv.isNotEmpty ? spv[0]['employee_name'] : '-';
          }
        });
      } else {
        // Handle the case where the server did not return a 200 OK response
        print("Failed to load members data");
      }

      String idLPDAPI = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/getlpd.php?action=1';
      final idLPDResponse = await http.get(Uri.parse(idLPDAPI));

      if (idLPDResponse.statusCode == 200) {
        var idLPDdata = json.decode(idLPDResponse.body);

        setState(() {
          List<dynamic> idLPD = idLPDdata['Data'];
          if (idLPD.isNotEmpty) {
            lastIDPLD = idLPD.isNotEmpty ? idLPD[0]['lpd_id'] : '-';
          }
        });
      } else if(idLPDResponse.statusCode == 400){
        setState(() {
          lastIDPLD = 'Belum ada nomor SPPD';
        });
      } else {
        // Handle the case where the server did not return a 200 OK response
        print("Failed to load members data");
      }
    } catch (e){

    } finally {
      isLoading = false;
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

  Future<void> actionLPD() async {
    try{
      isLoading = true;

      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/lpd.php';
      String employeeId = storage.read('employee_id').toString();

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "action" : "1",
          "employee_id": employeeId,
          "lpd_id": txtIDLPD.text,
          "businesstrip_id" : widget.businesstrip_id,
          "start_date" : TanggalMulai.toString(),
          "end_date" : TanggalAkhir.toString(),
          "project_name" : txtNamaProject.text,
          "cash_advanced" : txtAdvanced.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "lpd_desc" : txtUraianLPD.text,
          "employee_name" : widget.employeeName,

          "tiket_days" : txtHariTiketPesawat.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "hotel_days" : txtHariHotel.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "saku_days" : txtHariUangSaku.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "saku_days_two" : txtHariUangSakuDua.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "saku_days_three" : txtHariUangSakuTiga.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "saku_days_four" : txtHariUangSakuEmpat.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "saku_days_five" : txtHariUangSakuLima.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "transport_days" : txtHariTransport.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "makan_days" : txtHariUangMakan.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "makan_days_two" : txtHariUangMakanDua.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "makan_days_three" : txtHariUangMakanTiga.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "makan_days_four" : txtHariUangMakanEmpat.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "makan_days_five" : txtHariUangMakanLima.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "entertain_days" : txtHariByEntertain.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "lain_days" : txtHariLain.text.replaceAll(RegExp(r'[^0-9]'), ''),

          "tiket_price" : txtSatuanTiketPesawat.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "hotel_price" : txtSatuanHotel.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "saku_price" : txtSatuanUangSaku.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "saku_price_two" : txtSatuanUangSakuDua.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "saku_price_three" : txtSatuanUangSakuTiga.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "saku_price_four" : txtSatuanUangSakuEmpat.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "saku_price_five" : txtSatuanUangSakuLima.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "transport_price" : txtSatuanTransport.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "makan_price" : txtSatuanUangMakan.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "makan_price_two" : txtSatuanUangMakanDua.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "makan_price_three" : txtSatuanUangMakanTiga.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "makan_price_four" : txtSatuanUangMakanEmpat.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "makan_price_five" : txtSatuanUangMakanLima.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "entertain_price" : txtSatuanByEntertain.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "lain_price" : txtSatuanLain.text.replaceAll(RegExp(r'[^0-9]'), ''),

          "tiket_total" : txtJumlahBiayaTiketPesawat.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "hotel_total" : txtJumlahBiayaHotel.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "saku_total" : txtJumlahBiayaUangSaku.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "saku_total_two" : txtJumlahBiayaUangSakuDua.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "saku_total_three" : txtJumlahBiayaUangSakuTiga.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "saku_total_four" : txtJumlahBiayaUangSakuEmpat.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "saku_total_five" : txtJumlahBiayaUangSakuLima.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "transport_total" : txtJumlahBiayaTransport.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "makan_total" : txtJumlahBiayaUangMakan.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "makan_total_two" : txtJumlahBiayaUangMakanDua.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "makan_total_three" : txtJumlahBiayaUangMakanTiga.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "makan_total_four" : txtJumlahBiayaUangMakanEmpat.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "makan_total_five" : txtJumlahBiayaUangMakanLima.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "entertain_total" : txtJumlahBiayaByEntertain.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "lain_total" : txtJumlahBiayaLain.text.replaceAll(RegExp(r'[^0-9]'), ''),
        }
      );

      if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil melaporkan LPD'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PerjalananDinasIndex());
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
                      Get.to(const PerjalananDinasIndex());
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
                Get.to(const PerjalananDinasIndex());
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

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    var employeeId = storage.read('employee_id');
    var photo = storage.read('photo');
    var positionId = storage.read('position_id');

    return MaterialApp(
      title: 'LPD Baru',
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
                        SizedBox(height: 15.sp,),
                        //company logo and name
                        ListTile(
                        contentPadding: const EdgeInsets.only(left: 0, right: 0),
                        dense: true,
                        horizontalTitleGap: 0.0, // Adjust this value as needed
                        leading: Container(
                          margin: const EdgeInsets.only(right: 2.0), // Add margin to the right of the image
                          child: Image.asset(
                            'images/kinglab.png',
                            width: MediaQuery.of(context).size.width * 0.08,
                          ),
                        ),
                        title: Text(
                          companyName,
                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w300),
                        ),
                        subtitle: Text(
                          trimmedCompanyAddress,
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
                                onPressed: () {Get.to(EmployeePage(employee_id: employeeId,));},
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
                //content menu
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: EdgeInsets.only(left: 7.w, right: 7.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 35.sp,),
                        Padding(
                          padding: EdgeInsets.only(right: 20.sp),
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
                                            Text('Notifikasi', style: TextStyle(
                                              fontSize: 20.sp, fontWeight: FontWeight.w700,
                                            )),
                                            GestureDetector(
                                              onTap: () {
                                                
                                              },
                                              child: Text('Hapus semua', style: TextStyle(
                                                fontSize: 12.sp, fontWeight: FontWeight.w600,
                                              )),
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
                                                          title: Center(child: Text("${noticationList[index]['title']} ", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700))),
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
                                                              onPressed: () {
                                                                Get.back();
                                                              }, 
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
                                                    title: Text(index < noticationList.length ? '${noticationList[index]['title']} ' : '-',
                                                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                                                    ),
                                                    subtitle: Text(
                                                        index < noticationList.length
                                                        ? 'From ${noticationList[index]['sender'] == 'Kevin Gabriel Florentino' ? 'System' : noticationList[index]['sender']} '
                                                        : '-',
                                                        style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400),
                                                      ),
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
                                    const Icon(Icons.notifications),
                                    // if (noti.isNotEmpty)
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(1),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            noticationList.length.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 40.sp,),
                              GestureDetector(
                                onTap: () {
                                  Get.to(const ProfilePage());
                                },
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 290.w,
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
                        ),
                        SizedBox(height: 30.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nomor Permohonan Perjalanan Dinas', style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )),
                                  SizedBox(height: 10.h,),
                                  Text(widget.businesstrip_id),
                                ],
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nama', style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )),
                                  SizedBox(height: 10.h,),
                                  Text(widget.employeeName),
                                ],
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Departemen', style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )),
                                  SizedBox(height: 10.h,),
                                  Text(widget.departmentName),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.sp,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Perjalanan disetujui oleh', style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )),
                                  SizedBox(height: 10.h,),
                                  Text(spvName),
                                ],
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nomor SPPD', style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )),
                                  SizedBox(height: 10.h,),
                                  TextFormField(
                                    controller: txtIDLPD,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: '001(nomor)/LPD/IV(bulan)/2024(tahun)'
                                    ),
                                  ),
                                  SizedBox(height: 10.h,),
                                  Text('Nomor SPPD Terakhir : $lastIDPLD', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: const Color(0xFF2A85FF)))
                                ],
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nama-nama yang ikut serta', style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )),
                                  SizedBox(height: 10.h,),
                                  Text('${widget.memberOne}\n${widget.memberTwo}\n${widget.memberThree}\n${widget.memberFour}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.sp,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tanggal Mulai Dinas', style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )),
                                  SizedBox(height: 10.h,),
                                  DateTimePicker(
                                    firstDate: DateTime(2000),
                                    initialDate: DateTime.now(),
                                    lastDate: DateTime(2300),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan tanggal mulai dinas'
                                    ),
                                    dateMask: 'd MMM yyyy',
                                    onChanged: (value) {
                                      setState(() {
                                        TanggalMulai = DateFormat('yyyy-MM-dd').parse(value);
                                        //selectedDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(txtTanggal);
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tanggal Akhir Dinas', style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )),
                                  SizedBox(height: 10.h,),
                                  DateTimePicker(
                                    firstDate: DateTime(2000),
                                    initialDate: DateTime.now(),
                                    lastDate: DateTime(2300),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan tanggal akhir dinas'
                                    ),
                                    dateMask: 'd MMM yyyy',
                                    onChanged: (value) {
                                      setState(() {
                                        TanggalAkhir = DateFormat('yyyy-MM-dd').parse(value);
                                        //selectedDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(txtTanggal);
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Proyek', style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )),
                                  SizedBox(height: 10.h,),
                                  TextFormField(
                                    controller: txtNamaProject,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan nama proyek'
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 4,
                              child: Text('Uraian Pembiayaan', style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ), textAlign: TextAlign.center,),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text('Jumlah Hari', style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ), textAlign: TextAlign.center),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text('Satuan', style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ), textAlign: TextAlign.center),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 5,
                              child: Text('Jumlah Biaya', style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ), textAlign: TextAlign.center),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 5,
                              child: Text('Jumlah (IDR)', style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ), textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 4,
                              child: Text('Tiket Pesawat'),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: TextFormField(
                                controller: txtHariTiketPesawat,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                                  hintText: 'Jumlah hari'
                                ),
                                onChanged: (value){
                                  setState(() {
                                    JumlahTiket = int.parse(txtHariTiketPesawat.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanTiketPesawat.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                    GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                  });
                                }
                              )
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: TextFormField(
                                controller: txtSatuanTiketPesawat,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CurrencyFormatter(),
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                                  hintText: 'Jumlah satuan'
                                ),
                                onChanged: (value){
                                  setState(() {
                                    JumlahTiket = double.parse(txtHariTiketPesawat.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanTiketPesawat.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                    GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                  });
                                }
                              )
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 5,
                              child: TextFormField(
                                controller: txtJumlahBiayaTiketPesawat,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CurrencyFormatter(),
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                                  hintText: 'Jumlah biaya'
                                ),
                                onChanged: (value){
                                  setState(() {
                                    JumlahTiket = double.parse(txtJumlahBiayaTiketPesawat.text.replaceAll(RegExp(r'[^0-9]'), '')) + 0;
                                    GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                  });
                                }
                              )
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text(formatCurrency(JumlahTiket), textAlign: TextAlign.end,),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 4,
                              child: Text('Hotel / Penginapan'),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: TextFormField(
                                controller: txtHariHotel,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                                  hintText: 'Jumlah hari'
                                ),
                                onChanged: (value){
                                  setState(() {
                                    JumlahHotel = int.parse(txtHariHotel.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanHotel.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                    GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                  });
                                }
                              )
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: TextFormField(
                                controller: txtSatuanHotel,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CurrencyFormatter(),
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                                  hintText: 'Jumlah satuan'
                                ),
                                onChanged: (value){
                                  setState(() {
                                    JumlahHotel = double.parse(txtHariHotel.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanHotel.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                    GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                  });
                                }
                              )
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 5,
                              child: TextFormField(
                                controller: txtJumlahBiayaHotel,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CurrencyFormatter(),
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                                  hintText: 'Jumlah biaya'
                                ),
                                onChanged: (value){
                                  setState(() {
                                    JumlahHotel = double.parse(txtJumlahBiayaHotel.text.replaceAll(RegExp(r'[^0-9]'), '')) + 0;
                                    GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                  });
                                }
                              )
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text(formatCurrency(JumlahHotel), textAlign: TextAlign.end,),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 4,
                              child: Text('Uang Saku ${widget.employeeName}'),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: TextFormField(
                                controller: txtHariUangSaku,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                                  hintText: 'Jumlah hari'
                                ),
                                onChanged: (value){
                                  setState(() {
                                    JumlahUangSaku = int.parse(txtHariUangSaku.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanUangSaku.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                    GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                  });
                                }
                              )
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: TextFormField(
                                controller: txtSatuanUangSaku,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CurrencyFormatter(),
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                                  hintText: 'Jumlah satuan'
                                ),
                                onChanged: (value){
                                  setState(() {
                                    JumlahUangSaku = int.parse(txtHariUangSaku.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanUangSaku.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                    GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                  });
                                }
                              )
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 5,
                              child: TextFormField(
                                controller: txtJumlahBiayaUangSaku,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CurrencyFormatter(),
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                                  hintText: 'Jumlah biaya'
                                ),
                                onChanged: (value){
                                  setState(() {
                                    JumlahUangSaku = double.parse(txtJumlahBiayaUangSaku.text.replaceAll(RegExp(r'[^0-9]'), '')) + 0;
                                    GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                  });
                                }
                              )
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text(formatCurrency(JumlahUangSaku), textAlign: TextAlign.end,),
                            ),
                          ],
                        ),
                        if(widget.memberOne != '-')
                          SizedBox(height: 10.sp,),
                        if(widget.memberOne != '-')
                          Row(
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 4,
                                child: Text('Uang Saku ${widget.memberOne}'),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: TextFormField(
                                  controller: txtHariUangSakuDua,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Jumlah hari'
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      JumlahUangSakuDua = int.parse(txtHariUangSakuDua.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanUangSakuDua.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                      GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                    });
                                  }
                                )
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: TextFormField(
                                  controller: txtSatuanUangSakuDua,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyFormatter(),
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Jumlah satuan'
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      JumlahUangSakuDua = int.parse(txtHariUangSakuDua.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanUangSakuDua.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                      GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                    });
                                  }
                                )
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 5,
                                child: TextFormField(
                                  controller: txtJumlahBiayaUangSakuDua,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyFormatter(),
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Jumlah biaya'
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      JumlahUangSakuDua = double.parse(txtJumlahBiayaUangSakuDua.text.replaceAll(RegExp(r'[^0-9]'), '')) + 0;
                                      GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                    });
                                  }
                                )
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text(formatCurrency(JumlahUangSakuDua), textAlign: TextAlign.end,),
                              ),
                            ],
                          ),
                        if(widget.memberTwo != '-')
                          SizedBox(height: 10.sp,),
                        if(widget.memberTwo != '-')
                          Row(
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 4,
                                child: Text('Uang Saku ${widget.memberTwo}'),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: TextFormField(
                                  controller: txtHariUangSakuTiga,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Jumlah hari'
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      JumlahUangSakuTiga = int.parse(txtHariUangSakuTiga.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanUangSakuTiga.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                      GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                    });
                                  }
                                )
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: TextFormField(
                                  controller: txtSatuanUangSakuTiga,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyFormatter(),
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Jumlah satuan'
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      JumlahUangSakuTiga = int.parse(txtHariUangSakuTiga.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanUangSakuTiga.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                      GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                    });
                                  }
                                )
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 5,
                                child: TextFormField(
                                  controller: txtJumlahBiayaUangSakuTiga,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyFormatter(),
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Jumlah biaya'
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      JumlahUangSakuTiga = double.parse(txtJumlahBiayaUangSakuTiga.text.replaceAll(RegExp(r'[^0-9]'), '')) + 0;
                                      GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                    });
                                  }
                                )
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text(formatCurrency(JumlahUangSakuTiga), textAlign: TextAlign.end,),
                              ),
                            ],
                          ),
                        if(widget.memberThree != '-')
                          SizedBox(height: 10.sp,),
                        if(widget.memberThree != '-')
                          Row(
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 4,
                                child: Text('Uang Saku ${widget.memberThree}'),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: TextFormField(
                                  controller: txtHariUangSakuEmpat,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Jumlah hari'
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      JumlahUangSakuEmpat = int.parse(txtHariUangSakuEmpat.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanUangSakuEmpat.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                      GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                    });
                                  }
                                )
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: TextFormField(
                                  controller: txtSatuanUangSakuEmpat,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyFormatter(),
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Jumlah satuan'
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      JumlahUangSakuEmpat = int.parse(txtHariUangSakuEmpat.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanUangSakuEmpat.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                      GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                    });
                                  }
                                )
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 5,
                                child: TextFormField(
                                  controller: txtJumlahBiayaUangSakuEmpat,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyFormatter(),
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Jumlah biaya'
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      JumlahUangSakuEmpat = double.parse(txtJumlahBiayaUangSakuEmpat.text.replaceAll(RegExp(r'[^0-9]'), '')) + 0;
                                      GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                    });
                                  }
                                )
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text(formatCurrency(JumlahUangSakuEmpat), textAlign: TextAlign.end,),
                              ),
                            ],
                          ),
                        if(widget.memberFour != '-')
                          SizedBox(height: 10.sp,),
                        if(widget.memberFour != '-')
                          Row(
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 4,
                                child: Text('Uang Saku ${widget.memberFour}'),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: TextFormField(
                                  controller: txtHariUangSakuLima,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Jumlah hari'
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      JumlahUangSakuLima = int.parse(txtHariUangSakuLima.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanUangSakuLima.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                      GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                    });
                                  }
                                )
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: TextFormField(
                                  controller: txtSatuanUangSakuLima,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyFormatter(),
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Jumlah satuan'
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      JumlahUangSakuLima = int.parse(txtHariUangSakuLima.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanUangSakuLima.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                      GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                    });
                                  }
                                )
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 5,
                                child: TextFormField(
                                  controller: txtJumlahBiayaUangSakuLima,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyFormatter(),
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Jumlah biaya'
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      JumlahUangSakuLima = double.parse(txtJumlahBiayaUangSakuLima.text.replaceAll(RegExp(r'[^0-9]'), '')) + 0;
                                      GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                    });
                                  }
                                )
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text(formatCurrency(JumlahUangSakuLima), textAlign: TextAlign.end,),
                              ),
                            ],
                          ),
                        SizedBox(height: 10.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 4,
                              child: Text('Transport(Taxi) Lokal/Sewa mobil harian'),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: TextFormField(
                                controller: txtHariTransport,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                                  hintText: 'Jumlah hari'
                                ),
                                onChanged: (value){
                                  setState(() {
                                    JumlahTransport = int.parse(txtHariTransport.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanTransport.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                    GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                  });
                                }
                              )
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: TextFormField(
                                controller: txtSatuanTransport,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CurrencyFormatter(),
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                                  hintText: 'Jumlah satuan'
                                ),
                                onChanged: (value){
                                  setState(() {
                                    JumlahTransport = int.parse(txtHariTransport.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanTransport.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                    GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                  });
                                }
                              )
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 5,
                              child: TextFormField(
                                controller: txtJumlahBiayaTransport,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CurrencyFormatter(),
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                                  hintText: 'Jumlah biaya'
                                ),
                                onChanged: (value){
                                  setState(() {
                                    JumlahTransport = double.parse(txtJumlahBiayaTransport.text.replaceAll(RegExp(r'[^0-9]'), '')) + 0;
                                    GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                  });
                                }
                              )
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text(formatCurrency(JumlahTransport), textAlign: TextAlign.end,),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 4,
                              child: Text('Uang makan ${widget.employeeName}'),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: TextFormField(
                                controller: txtHariUangMakan,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                                  hintText: 'Jumlah hari'
                                ),
                                onChanged: (value){
                                  setState(() {
                                    JumlahUangMakan = int.parse(txtHariUangMakan.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanUangMakan.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                    GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                  });
                                }
                              )
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: TextFormField(
                                controller: txtSatuanUangMakan,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CurrencyFormatter(),
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                                  hintText: 'Jumlah satuan'
                                ),
                                onChanged: (value){
                                  setState(() {
                                    JumlahUangMakan = int.parse(txtHariUangMakan.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanUangMakan.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                    GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                  });
                                }
                              )
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 5,
                              child: TextFormField(
                                controller: txtJumlahBiayaUangMakan,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CurrencyFormatter(),
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                                  hintText: 'Jumlah biaya'
                                ),
                                onChanged: (value){
                                  setState(() {
                                    JumlahUangMakan = double.parse(txtJumlahBiayaUangMakan.text.replaceAll(RegExp(r'[^0-9]'), '')) + 0;
                                    GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                  });
                                }
                              )
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text(formatCurrency(JumlahUangMakan), textAlign: TextAlign.end,),
                            ),
                          ],
                        ),
                        if(widget.memberOne != '-')
                          SizedBox(height: 10.sp,),
                        if(widget.memberOne != '-')
                          Row(
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 4,
                                child: Text('Uang Makan ${widget.memberOne}'),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: TextFormField(
                                  controller: txtHariUangMakanDua,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Jumlah hari'
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      JumlahUangMakanDua = int.parse(txtHariUangMakanDua.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanUangMakanDua.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                      GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                    });
                                  }
                                )
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: TextFormField(
                                  controller: txtSatuanUangMakanDua,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyFormatter(),
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Jumlah satuan'
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      JumlahUangMakanDua = int.parse(txtHariUangMakanDua.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanUangMakanDua.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                      GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                    });
                                  }
                                )
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 5,
                                child: TextFormField(
                                  controller: txtJumlahBiayaUangMakanDua,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyFormatter(),
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Jumlah biaya'
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      JumlahUangMakanDua = double.parse(txtJumlahBiayaUangMakanDua.text.replaceAll(RegExp(r'[^0-9]'), '')) + 0;
                                      GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                    });
                                  }
                                )
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text(formatCurrency(JumlahUangMakanDua), textAlign: TextAlign.end,),
                              ),
                            ],
                          ),
                        if(widget.memberTwo != '-')
                          SizedBox(height: 10.sp,),
                        if(widget.memberTwo != '-')
                          Row(
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 4,
                                child: Text('Uang Makan ${widget.memberTwo}'),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: TextFormField(
                                  controller: txtHariUangMakanTiga,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Jumlah hari'
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      JumlahUangMakanTiga = int.parse(txtHariUangMakanTiga.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanUangMakanTiga.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                      GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                    });
                                  }
                                )
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: TextFormField(
                                  controller: txtSatuanUangMakanTiga,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyFormatter(),
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Jumlah satuan'
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      JumlahUangMakanTiga = int.parse(txtHariUangMakanTiga.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanUangMakanTiga.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                      GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                    });
                                  }
                                )
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 5,
                                child: TextFormField(
                                  controller: txtJumlahBiayaUangMakanTiga,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyFormatter(),
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Jumlah biaya'
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      JumlahUangMakanTiga = double.parse(txtJumlahBiayaUangMakanTiga.text.replaceAll(RegExp(r'[^0-9]'), '')) + 0;
                                      GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                    });
                                  }
                                )
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text(formatCurrency(JumlahUangMakanTiga), textAlign: TextAlign.end,),
                              ),
                            ],
                          ),
                        if(widget.memberThree != '-')
                          SizedBox(height: 10.sp,),
                        if(widget.memberThree != '-')
                          Row(
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 4,
                                child: Text('Uang Makan ${widget.memberThree}'),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: TextFormField(
                                  controller: txtHariUangMakanEmpat,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Jumlah hari'
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      JumlahUangMakanEmpat = int.parse(txtHariUangMakanEmpat.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanUangMakanEmpat.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                      GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                    });
                                  }
                                )
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: TextFormField(
                                  controller: txtSatuanUangMakanEmpat,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyFormatter(),
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Jumlah satuan'
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      JumlahUangMakanEmpat = int.parse(txtHariUangMakanEmpat.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanUangMakanEmpat.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                      GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                    });
                                  }
                                )
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 5,
                                child: TextFormField(
                                  controller: txtJumlahBiayaUangMakanEmpat,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyFormatter(),
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Jumlah biaya'
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      JumlahUangMakanEmpat = double.parse(txtJumlahBiayaUangMakanEmpat.text.replaceAll(RegExp(r'[^0-9]'), '')) + 0;
                                      GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                    });
                                  }
                                )
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text(formatCurrency(JumlahUangMakanEmpat), textAlign: TextAlign.end,),
                              ),
                            ],
                          ),
                        if(widget.memberFour != '-')
                          SizedBox(height: 10.sp,),
                        if(widget.memberFour != '-')
                          Row(
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 4,
                                child: Text('Uang Makan ${widget.memberFour}'),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: TextFormField(
                                  controller: txtHariUangMakanLima,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Jumlah hari'
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      JumlahUangMakanLima = int.parse(txtHariUangMakanLima.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanUangMakanLima.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                      GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                    });
                                  }
                                )
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: TextFormField(
                                  controller: txtSatuanUangMakanLima,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyFormatter(),
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Jumlah satuan'
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      JumlahUangMakanLima = int.parse(txtHariUangMakanLima.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanUangMakanLima.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                      GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                    });
                                  }
                                )
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 5,
                                child: TextFormField(
                                  controller: txtJumlahBiayaUangMakanLima,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyFormatter(),
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Jumlah biaya'
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      JumlahUangMakanLima = double.parse(txtJumlahBiayaUangMakanLima.text.replaceAll(RegExp(r'[^0-9]'), '')) + 0;
                                      GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                    });
                                  }
                                )
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text(formatCurrency(JumlahUangMakanLima), textAlign: TextAlign.end,),
                              ),
                            ],
                          ),
                        SizedBox(height: 10.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 4,
                              child: Text('By entertain'),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: TextFormField(
                                controller: txtHariByEntertain,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                                  hintText: 'Jumlah hari'
                                ),
                                onChanged: (value){
                                  setState(() {
                                    JumlahEntertain = int.parse(txtHariByEntertain.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanByEntertain.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                    GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                  });
                                }
                              )
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: TextFormField(
                                controller: txtSatuanByEntertain,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CurrencyFormatter(),
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                                  hintText: 'Jumlah satuan'
                                ),
                                onChanged: (value){
                                  setState(() {
                                    JumlahEntertain = int.parse(txtHariByEntertain.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanByEntertain.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                    GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                  });
                                }
                              )
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 5,
                              child: TextFormField(
                                controller: txtJumlahBiayaByEntertain,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CurrencyFormatter(),
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                                  hintText: 'Jumlah biaya'
                                ),
                                onChanged: (value){
                                  setState(() {
                                    JumlahEntertain = double.parse(txtJumlahBiayaByEntertain.text.replaceAll(RegExp(r'[^0-9]'), '')) + 0;
                                    GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                  });
                                }
                              )
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text(formatCurrency(JumlahEntertain), textAlign: TextAlign.end,),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 4,
                              child: Text('Lain-lain'),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: TextFormField(
                                controller: txtHariLain,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                                  hintText: 'Jumlah hari'
                                ),
                                onChanged: (value){
                                  setState(() {
                                    JumlahLain = int.parse(txtHariLain.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanLain.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                    GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                  });
                                }
                              )
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: TextFormField(
                                controller: txtSatuanLain,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CurrencyFormatter(),
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                                  hintText: 'Jumlah satuan'
                                ),
                                onChanged: (value){
                                  setState(() {
                                    JumlahLain = int.parse(txtHariLain.text.replaceAll(RegExp(r'[^0-9]'), '')) * double.parse(txtSatuanLain.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                    GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                  });
                                }
                              )
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 5,
                              child: TextFormField(
                                controller: txtJumlahBiayaLain,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CurrencyFormatter(),
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                                  hintText: 'Jumlah biaya'
                                ),
                                onChanged: (value){
                                  setState(() {
                                    GrandTotal = JumlahTiket + JumlahHotel + JumlahUangSaku + JumlahTransport + JumlahUangMakan + JumlahEntertain + JumlahLain + JumlahUangMakanDua + JumlahUangMakanEmpat + JumlahUangMakanLima + JumlahUangMakanTiga + JumlahUangSakuDua + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangSakuTiga;
                                    JumlahLain = double.parse(txtJumlahBiayaLain.text.replaceAll(RegExp(r'[^0-9]'), '')) + 0;
                                  });
                                }
                              )
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text(formatCurrency(JumlahLain), textAlign: TextAlign.end,),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 145.w),
                              child: Text('Grand Total', textAlign: TextAlign.end, style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 317.w),
                              child: Text(formatCurrency(GrandTotal), textAlign: TextAlign.end, ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 145.w),
                              child: Text('Uang Muka (Advance)', textAlign: TextAlign.end, style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 317.w),
                              child: TextFormField(
                                controller: txtAdvanced,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CurrencyFormatter(),
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                                  hintText: 'Jumlah uang muka'
                                ),
                                onChanged: (value){
                                  setState(() {
                                    Kekurangan = GrandTotal - double.parse(txtAdvanced.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                  });
                                }
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 145.w),
                              child: Text('Kekurangan/Kelebihan', textAlign: TextAlign.end, style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 317.w),
                              child: Text(formatCurrency(Kekurangan), textAlign: TextAlign.end,),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.sp,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Uraikan', style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )),
                            SizedBox(height: 10.h,),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 95.w,
                              child: TextFormField(
                                controller: txtUraianLPD,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                                  hintText: 'Masukkan uraian perjalanan dinas anda'
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 30.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: (){
                                actionLPD();
                              }, 
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  alignment: Alignment.center,
                                  minimumSize: Size(40.w, 55.h),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: const Color(0xff4ec3fc),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              child: Text('Kumpulkan')
                            )
                          ],
                        ),
                        SizedBox(height: 50.sp,),
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

  String _formatDate(String date) {
    // Parse the date string
    DateTime parsedDate = DateFormat("yyyy-MM-dd HH:mm").parse(date);

    // Format the date as "dd MMMM yyyy"
    return DateFormat("d MMMM yyyy HH:mm").format(parsedDate);
  }
}