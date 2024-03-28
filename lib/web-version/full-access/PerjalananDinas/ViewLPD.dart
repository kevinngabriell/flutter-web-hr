// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Event/event.dart';
import 'package:hr_systems_web/web-version/full-access/Performance/performance.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/PerjalananDinasIndex.dart';
import 'package:hr_systems_web/web-version/full-access/Report/report.dart';
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

class ViewLPD extends StatefulWidget {
  final String businessTripID;
  const ViewLPD({super.key, required this.businessTripID});

  @override
  State<ViewLPD> createState() => _ViewLPDState();
}

class _ViewLPDState extends State<ViewLPD> {
  String? leaveoptions;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  bool isLoading = false;

  List<Map<String, dynamic>> noticationList = [];

  String lpdID = '';
  String namaKota = '';
  String startDate = '';
  String endDate = '';
  String projectName = '';
  String advancedCash = '';
  String uraianLPD = '';
  String namaKaryawan = '';
  String tanggalPengajuan = '';
  String statusName = '';
  String departemen = '';
  String karyawanID = '';

  String memberOne = '-';
  String memberTwo = '-';
  String memberThree = '-';
  String memberFour = '-';
  String employeeSPV = '';

  String countDayTiket = '';
  String priceTiket = '';
  String totalTiket = '';

  String countDayPenginapan = '';
  String pricePenginapan = '';
  String totalPenginapan = '';

  String countDayTransport = '';
  String priceTransport = '';
  String totalTransport = '';

  String countDayLain = '';
  String priceLain = '';
  String totalLain = '';

  String countDayEntertain = '';
  String priceEntertain = '';
  String totalEntertain = '';

  String countDayUangSaku = '';
  String priceUangSaku = '';
  String totalUangSaku = '';

  String countDayUangSakuDua = '';
  String priceUangSakuDua = '';
  String totalUangSakuDua = '';

  String countDayUangSakuTiga = '';
  String priceUangSakuTiga = '';
  String totalUangSakuTiga = '';

  String countDayUangSakuEmpat = '';
  String priceUangSakuEmpat = '';
  String totalUangSakuEmpat = '';

  String countDayUangSakuLima = '';
  String priceUangSakuLima = '';
  String totalUangSakuLima = '';

  String countDayUangMakan = '';
  String priceUangMakan = '';
  String totalUangMakan = '';

  String countDayUangMakanDua = '';
  String priceUangMakanDua = '';
  String totalUangMakanDua = '';

  String countDayUangMakanTiga = '';
  String priceUangMakanTiga = '';
  String totalUangMakanTiga = '';

  String countDayUangMakanEmpat = '';
  String priceUangMakanEmpat = '';
  String totalUangMakanEmpat = '';

  String countDayUangMakanLima = '';
  String priceUangMakanLima = '';
  String totalUangMakanLima = '';

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
  double Kekurangan = 0;

  String spvName = '';
  String insertDt = '';

  List<Map<String, dynamic>> historyList = [];

  @override
  void initState() {
    super.initState();
    fetchNotification();
    fetchData();
    fetchDetailLPD();
    fetchMembersData();
  }

  String formatCurrency(double value) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0).format(value);
  }

  String formatCurrency2(String value) {
    // Parse the string to a number.
    double numberValue = double.tryParse(value) ?? 0;

    // Format the number as currency.
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0).format(numberValue);
  }

  Future<void> fetchMembersData() async {
    String url = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/getperjalanandinas.php?action=8&businesstrip_id=${widget.businessTripID}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      setState(() {
        List<dynamic> members = data['Data'];
        if (members.isNotEmpty) {
          memberOne = members.isNotEmpty ? members[0]['member_name'] : '-';
          memberTwo = members.length > 1 ? members[1]['member_name'] : '-';
          memberThree = members.length > 2 ? members[2]['member_name'] : '-';
          memberFour = members.length > 3 ? members[3]['member_name'] : '-';
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

  Future<void> fetchDetailLPD() async {
    try{
      isLoading = true;

      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/getlpd.php?action=4&businesstrip_id=${widget.businessTripID}';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        Map<String, dynamic> data = (responseData['Data'] as List).first;

        setState(() {
          lpdID = data['lpd_id'];
          namaKota = data['name'];
          startDate = data['businesstrip_startdate'];
          endDate = data['businesstrip_enddate'];
          projectName = data['project_name'];
          advancedCash = data['cash_advanced'];
          uraianLPD = data['lpd_desc'];
          namaKaryawan = data['employee_name'];
          tanggalPengajuan = data['insert_dt'];
          statusName = data['status_name'];
          departemen = data['department_name'];
          karyawanID = data['id'];
          insertDt = _formatDate(data['insert_dt']);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }

      String url = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployee.php?action=2&employee_id=$karyawanID';
      final SPVresponse = await http.get(Uri.parse(url));

      if (SPVresponse.statusCode == 200) {
        var SPVdata = json.decode(SPVresponse.body);

        setState(() {
          List<dynamic> employee = SPVdata['Data'];
          if (employee.isNotEmpty) {
            employeeSPV = employee.isNotEmpty ? employee[0]['employee_spv'] : '-';
          }
        });
      } else {
        // Handle the case where the server did not return a 200 OK response
        print("Failed to load members data");
      }

      String spvNameAPI = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployee.php?action=3&spv_id=$employeeSPV';
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

      String transactionURL = "https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/getlpd.php?action=5&lpd_id=$lpdID";
      var transactionResponse = await http.get(Uri.parse(transactionURL));

      if (transactionResponse.statusCode == 200) {
        Map<String, dynamic> transactionResponseData = json.decode(transactionResponse.body);
        
        var tiketPesawatData = transactionResponseData['Data']['TiketPesawat'];
        var penginapanData = transactionResponseData['Data']['Penginapan'];
        var transportData = transactionResponseData['Data']['Transport'];
        var byEntertainData = transactionResponseData['Data']['ByEntertain'];
        var lainLainData = transactionResponseData['Data']['LainLain'];
        var UangSakuData = transactionResponseData['Data']['Uang Saku'];
        var UangSakuDuaData = transactionResponseData['Data']['Uang Saku 2'];
        var UangSakuTigaData = transactionResponseData['Data']['Uang Saku 3'];
        var UangSakuEmpatData = transactionResponseData['Data']['Uang Saku 4'];
        var UangSakuLimaData = transactionResponseData['Data']['Uang Saku 5'];
        var UangMakanData = transactionResponseData['Data']['Uang Makan'];
        var UangMakanDuaData = transactionResponseData['Data']['Uang Makan 2'];
        var UangMakanTigaData = transactionResponseData['Data']['Uang Makan 3'];
        var UangMakanEmpatData = transactionResponseData['Data']['Uang Makan 4'];
        var UangMakanLimaData = transactionResponseData['Data']['Uang Makan 5'];

        setState(() {
          countDayTiket = tiketPesawatData['count_days'];
          priceTiket = tiketPesawatData['price'];
          totalTiket = tiketPesawatData['total'];

          countDayPenginapan = penginapanData['count_days'];
          pricePenginapan = penginapanData['price'];
          totalPenginapan = penginapanData['total'];

          countDayTransport = transportData['count_days'];
          priceTransport = transportData['price'];
          totalTransport = transportData['total'];

          countDayLain = lainLainData['count_days'];
          priceLain = lainLainData['price'];
          totalLain = lainLainData['total'];

          countDayUangSaku = UangSakuData['count_days'];
          priceUangSaku = UangSakuData['price'];
          totalUangSaku = UangSakuData['total'];

          countDayUangSakuDua = UangSakuDuaData['count_days'];
          priceUangSakuDua = UangSakuDuaData['price'];
          totalUangSakuDua = UangSakuDuaData['total'];

          countDayUangSakuTiga = UangSakuTigaData['count_days'];
          priceUangSakuTiga = UangSakuTigaData['price'];
          totalUangSakuTiga = UangSakuTigaData['total'];

          countDayUangSakuEmpat = UangSakuEmpatData['count_days'];
          priceUangSakuEmpat = UangSakuEmpatData['price'];
          totalUangSakuEmpat = UangSakuEmpatData['total'];

          countDayUangSakuLima= UangSakuLimaData['count_days'];
          priceUangSakuLima = UangSakuLimaData['price'];
          totalUangSakuLima = UangSakuLimaData['total'];

          countDayUangMakan = UangMakanData['count_days'];
          priceUangMakan = UangMakanData['price'];
          totalUangMakan = UangMakanData['total'];

          countDayUangMakanDua = UangMakanDuaData['count_days'];
          priceUangMakanDua = UangMakanDuaData['price'];
          totalUangMakanDua = UangMakanDuaData['total'];

          countDayUangMakanTiga = UangMakanTigaData['count_days'];
          priceUangMakanTiga = UangMakanTigaData['price'];
          totalUangMakanTiga = UangMakanTigaData['total'];

          countDayUangMakanEmpat = UangMakanEmpatData['count_days'];
          priceUangMakanEmpat = UangMakanEmpatData['price'];
          totalUangMakanEmpat = UangMakanEmpatData['total'];

          countDayUangMakanLima = UangMakanLimaData['count_days'];
          priceUangMakanLima = UangMakanLimaData['price'];
          totalUangMakanLima = UangMakanLimaData['total'];

          countDayEntertain = byEntertainData['count_days'];
          priceEntertain = byEntertainData['price'];
          totalEntertain = byEntertainData['total'];

          if(countDayEntertain == '0'){
            JumlahEntertain = double.parse(totalEntertain);
          } else {
            JumlahEntertain = double.parse(countDayEntertain) * double.parse(priceEntertain);
          }

          if(countDayUangMakan == '0'){
            JumlahUangMakan = double.parse(totalUangMakan);
          } else {
            JumlahUangMakan = double.parse(countDayUangMakan) * double.parse(priceUangMakan);
          }

          if(countDayUangMakanDua == '0'){
            JumlahUangMakanDua = double.parse(totalUangMakanDua);
          } else {
            JumlahUangMakanDua = double.parse(countDayUangMakanDua) * double.parse(priceUangMakanDua);
          }

          if(countDayUangMakanTiga == '0'){
            JumlahUangMakanTiga = double.parse(totalUangMakanTiga);
          } else {
            JumlahUangMakanTiga = double.parse(countDayUangMakanTiga) * double.parse(priceUangMakanTiga);
          }

          if(countDayUangMakanEmpat == '0'){
            JumlahUangMakanEmpat = double.parse(totalUangMakanEmpat);
          } else {
            JumlahUangMakanEmpat = double.parse(countDayUangMakanEmpat) * double.parse(priceUangMakanEmpat);
          }

          if(countDayUangMakanLima == '0'){
            JumlahUangMakanLima = double.parse(totalUangMakanLima);
          } else {
            JumlahUangMakanLima = double.parse(countDayUangMakanLima) * double.parse(priceUangMakanLima);
          }

          if(countDayUangSaku == '0'){
            JumlahUangSaku = double.parse(totalUangSaku);
          } else {
            JumlahUangSaku = double.parse(countDayUangSaku) * double.parse(priceUangSaku);
            
          }

          if(countDayUangSakuDua == '0'){
            JumlahUangSakuDua = double.parse(totalUangSakuDua);
          } else {
            JumlahUangSakuDua = double.parse(countDayUangSakuDua) * double.parse(priceUangSakuDua);
          }

          if(countDayUangSakuTiga == '0'){
            JumlahUangSakuTiga = double.parse(totalUangSakuTiga);
          } else {
            JumlahUangSakuTiga = double.parse(countDayUangSakuTiga) * double.parse(priceUangSakuTiga);
          }

          if(countDayUangSakuEmpat == '0'){
            JumlahUangSakuEmpat = double.parse(totalUangSakuEmpat);
          } else {
            JumlahUangSakuEmpat = double.parse(countDayUangSakuEmpat) * double.parse(priceUangSakuEmpat);
          }

          if(countDayUangSakuLima == '0'){
            JumlahUangSakuLima = double.parse(totalUangSakuLima);
          } else {
            JumlahUangSakuLima = double.parse(countDayUangSakuLima) * double.parse(priceUangSakuLima);
          }

          if(countDayTiket == '0'){
            JumlahTiket = double.parse(totalTiket);
          } else {
            JumlahTiket = double.parse(countDayTiket) * double.parse(totalTiket);
          }

          if(countDayPenginapan == '0'){
            JumlahHotel = double.parse(totalPenginapan);
          } else {
            JumlahHotel = double.parse(countDayPenginapan) * double.parse(pricePenginapan);
          }

          if(countDayTransport == '0'){
            JumlahTransport = double.parse(totalTransport);
          } else {
            JumlahTransport = double.parse(countDayTransport) * double.parse(priceTransport);
          }

          if(countDayLain == '0'){
            JumlahLain = double.parse(totalLain);
          } else {
            JumlahLain = double.parse(countDayLain) * double.parse(priceLain);
          }

          GrandTotal = JumlahTiket + JumlahHotel + JumlahTransport + JumlahLain + JumlahEntertain + JumlahUangSaku + JumlahUangSakuDua + JumlahUangSakuTiga + JumlahUangSakuEmpat + JumlahUangSakuLima + JumlahUangMakan + JumlahUangMakanDua + JumlahUangMakanTiga + JumlahUangMakanEmpat + JumlahUangMakanLima;

          Kekurangan = double.parse(advancedCash) - GrandTotal;

        });

      } else {
        print('Failed to load data: ${response.statusCode}');
      }

      String historyUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/getlpd.php?action=6&lpd_id=$lpdID';

      var historyResponse = await http.get(Uri.parse(historyUrl));

      if (historyResponse.statusCode == 200) {
        var historyData = json.decode(historyResponse.body);

        setState(() {
          historyList = List<Map<String, dynamic>>.from(historyData['Data']);
        });
      } else if (response.statusCode == 404){
        print('404, No Data Found');
      }

    } catch (e){
      print('Error at catching inevntory detail : $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> actionLPD (action_id) async {
    String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/lpd.php';
    String employeeId = storage.read('employee_id').toString();

    if(action_id == '1'){
      try{
        isLoading = true;

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "action" : "2",
            "businesstrip_id": widget.businessTripID,
            "lpd_id": lpdID,
            "employee_id" : employeeId,
            "requestor_id" : karyawanID
          }
        );

        if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil mengubah status LPD'),
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
              );
            }
          );
      } finally {
        isLoading = false;
      }
    } else if (action_id == '2'){
      try{
        isLoading = true;

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "action" : "3",
            "businesstrip_id": widget.businessTripID,
            "lpd_id": lpdID,
            "employee_id" : employeeId,
            "requestor_id" : karyawanID
          }
        );

        if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil mengubah status LPD'),
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
              );
            }
          );
      } finally {
        isLoading = false;
      }
    } else if (action_id == '3'){
      try{
        isLoading = true;

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "action" : "4",
            "businesstrip_id": widget.businessTripID,
            "lpd_id": lpdID,
            "employee_id" : employeeId,
            "requestor_id" : karyawanID
          }
        );

        if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil mengubah status LPD'),
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
              );
            }
          );
      } finally {
        isLoading = false;
      }
    } else if (action_id == '4'){
      try{
        isLoading = true;

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "action" : "5",
            "businesstrip_id": widget.businessTripID,
            "lpd_id": lpdID,
            "employee_id" : employeeId,
            "requestor_id" : karyawanID
          }
        );

        if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil mengubah status LPD'),
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

    return MaterialApp(
      title: 'Detail LPD',
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
                                    title: Text(employeeName,
                                      style: TextStyle( fontSize: 15.sp, fontWeight: FontWeight.w300,),
                                    ),
                                    subtitle: Text(employeeEmail,
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
                                  Text('Nomor SPPD', style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )),
                                  SizedBox(height: 10.h,),
                                  Text(lpdID),
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
                                  Text(namaKaryawan),
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
                                  Text(departemen),
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
                                  Text('Nama-nama yang ikut serta', style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )),
                                  SizedBox(height: 10.h,),
                                  Text('$memberOne\n$memberTwo\n$memberThree\n$memberFour'),
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
                                  Text(projectName),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.sp,),
                        Row(
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
                                  Text(_formatDate2(startDate)),
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
                                  Text(_formatDate2(endDate)),
                                ],
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Status', style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )),
                                  SizedBox(height: 10.h,),
                                  Text(statusName),
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
                        SizedBox(height: 20.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 4,
                              child: const Text('Tiket Pesawat'),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text('$countDayTiket hari', textAlign: TextAlign.center,)
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text(formatCurrency2(priceTiket), textAlign: TextAlign.end,)
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 5,
                              child: Text(formatCurrency2(totalTiket), textAlign: TextAlign.end,)
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text(formatCurrency(JumlahTiket), textAlign: TextAlign.end,)
                            ),
                          ],
                        ),
                        SizedBox(height: 20.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 4,
                              child: const Text('Hotel / Penginapan'),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text('$countDayPenginapan hari', textAlign: TextAlign.center,)
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text(formatCurrency2(pricePenginapan), textAlign: TextAlign.end,)
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 5,
                              child: Text(formatCurrency2(totalPenginapan), textAlign: TextAlign.end,)
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text(formatCurrency(JumlahHotel), textAlign: TextAlign.end,)
                            ),
                          ],
                        ),
                        SizedBox(height: 20.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 4,
                              child: Text('Uang Saku $namaKaryawan'),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text('$countDayUangSaku hari', textAlign: TextAlign.center,)
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text(formatCurrency2(priceUangSaku), textAlign: TextAlign.end,)
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 5,
                              child: Text(formatCurrency2(totalUangSaku), textAlign: TextAlign.end,)
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text(formatCurrency(JumlahUangSaku), textAlign: TextAlign.end,)
                            ),
                          ],
                        ),
                        SizedBox(height: 20.sp,),
                        if(memberOne != '-')
                          Row(
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 4,
                                child: Text('Uang Saku $memberOne'),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text('$countDayUangSakuDua hari', textAlign: TextAlign.center,)
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text(formatCurrency2(priceUangSakuDua), textAlign: TextAlign.end,)
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 5,
                                child: Text(formatCurrency2(totalUangSakuDua), textAlign: TextAlign.end,)
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text(formatCurrency(JumlahUangSakuDua), textAlign: TextAlign.end,)
                              ),
                            ],
                          ),
                        if(memberOne != '-')
                          SizedBox(height: 20.sp,),
                        if(memberTwo != '-')
                          Row(
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 4,
                                child: Text('Uang Saku $memberTwo'),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text('$countDayUangSakuTiga hari', textAlign: TextAlign.center,)
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text(formatCurrency2(priceUangSakuTiga), textAlign: TextAlign.end,)
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 5,
                                child: Text(formatCurrency2(totalUangSakuTiga), textAlign: TextAlign.end,)
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text(formatCurrency(JumlahUangSakuTiga), textAlign: TextAlign.end,)
                              ),
                            ],
                          ),
                        if(memberTwo != '-')
                          SizedBox(height: 20.sp,),
                        if(memberThree != '-')
                          Row(
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 4,
                                child: Text('Uang Saku $memberThree'),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text('$countDayUangSakuEmpat hari', textAlign: TextAlign.center,)
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text(formatCurrency2(priceUangSakuEmpat), textAlign: TextAlign.end,)
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 5,
                                child: Text(formatCurrency2(totalUangSakuEmpat), textAlign: TextAlign.end,)
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text(formatCurrency(JumlahUangSakuEmpat), textAlign: TextAlign.end,)
                              ),
                            ],
                          ),
                        if(memberThree != '-')
                          SizedBox(height: 20.sp,),
                        if(memberFour != '-')
                          Row(
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 4,
                                child: Text('Uang Saku $memberFour'),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text('$countDayUangSakuLima hari', textAlign: TextAlign.center,)
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text(formatCurrency2(priceUangSakuLima), textAlign: TextAlign.end,)
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 5,
                                child: Text(formatCurrency2(totalUangSakuLima), textAlign: TextAlign.end,)
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text(formatCurrency(JumlahUangSakuLima), textAlign: TextAlign.end,)
                              ),
                            ],
                          ),
                        if(memberFour != '-')
                          SizedBox(height: 20.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 4,
                              child: const Text('Transport (Taxi) Lokal/sewa mobil harian'),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text('$countDayTransport hari', textAlign: TextAlign.center,)
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text(formatCurrency2(priceTransport), textAlign: TextAlign.end,)
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 5,
                              child: Text(formatCurrency2(totalTransport), textAlign: TextAlign.end,)
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text(formatCurrency(JumlahTransport), textAlign: TextAlign.end,)
                            ),
                          ],
                        ),
                        SizedBox(height: 20.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 4,
                              child: Text('Uang Makan $namaKaryawan'),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text('$countDayUangMakan hari', textAlign: TextAlign.center,)
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text(formatCurrency2(priceUangMakan), textAlign: TextAlign.end,)
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 5,
                              child: Text(formatCurrency2(totalUangMakan), textAlign: TextAlign.end,)
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text(formatCurrency(JumlahUangMakan), textAlign: TextAlign.end,)
                            ),
                          ],
                        ),
                        SizedBox(height: 20.sp,),
                        if(memberOne != '-')
                          Row(
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 4,
                                child: Text('Uang Makan $memberOne'),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text('$countDayUangMakanDua hari', textAlign: TextAlign.center,)
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text(formatCurrency2(priceUangMakanDua), textAlign: TextAlign.end,)
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 5,
                                child: Text(formatCurrency2(totalUangMakanDua), textAlign: TextAlign.end,)
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text(formatCurrency(JumlahUangMakanDua), textAlign: TextAlign.end,)
                              ),
                            ],
                          ),
                        if(memberOne != '-')
                          SizedBox(height: 20.sp,),
                        if(memberTwo != '-')
                          Row(
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 4,
                                child: Text('Uang Makan $memberTwo'),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text('$countDayUangMakanTiga hari', textAlign: TextAlign.center,)
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text(formatCurrency2(priceUangMakanTiga), textAlign: TextAlign.end,)
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 5,
                                child: Text(formatCurrency2(totalUangMakanTiga), textAlign: TextAlign.end,)
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text(formatCurrency(JumlahUangMakanTiga), textAlign: TextAlign.end,)
                              ),
                            ],
                          ),
                        if(memberTwo != '-')
                          SizedBox(height: 20.sp,),
                        if(memberThree != '-')
                          Row(
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 4,
                                child: Text('Uang Makan $memberThree'),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text('$countDayUangMakanEmpat hari', textAlign: TextAlign.center,)
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text(formatCurrency2(priceUangMakanEmpat), textAlign: TextAlign.end,)
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 5,
                                child: Text(formatCurrency2(totalUangMakanEmpat), textAlign: TextAlign.end,)
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text(formatCurrency(JumlahUangMakanEmpat), textAlign: TextAlign.end,)
                              ),
                            ],
                          ),
                        if(memberThree != '-')
                          SizedBox(height: 20.sp,),
                        if(memberFour != '-')
                          Row(
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 4,
                                child: Text('Uang Makan $memberFour'),
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text('$countDayUangMakanLima hari', textAlign: TextAlign.center,)
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text(formatCurrency2(priceUangMakanLima), textAlign: TextAlign.end,)
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 5,
                                child: Text(formatCurrency2(totalUangMakanLima), textAlign: TextAlign.end,)
                              ),
                              SizedBox(width: 5.w,),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 150.w) / 5,
                                child: Text(formatCurrency(JumlahUangMakanLima), textAlign: TextAlign.end,)
                              ),
                            ],
                          ),
                        if(memberFour != '-')
                          SizedBox(height: 20.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 4,
                              child: const Text('By entertain'),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text('$countDayEntertain hari', textAlign: TextAlign.center,)
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text(formatCurrency2(priceEntertain), textAlign: TextAlign.end,)
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 5,
                              child: Text(formatCurrency2(totalEntertain), textAlign: TextAlign.end,)
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text(formatCurrency(JumlahEntertain), textAlign: TextAlign.end,)
                            ),
                          ],
                        ),
                        SizedBox(height: 20.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 4,
                              child: const Text('Lain-lain'),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text('$countDayLain hari', textAlign: TextAlign.center,)
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text(formatCurrency2(priceLain), textAlign: TextAlign.end,)
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 5,
                              child: Text(formatCurrency2(totalLain), textAlign: TextAlign.end,)
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 150.w) / 5,
                              child: Text(formatCurrency(JumlahLain), textAlign: TextAlign.end,)
                            ),
                          ],
                        ),
                        SizedBox(height: 20.sp,),
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
                        SizedBox(height: 20.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 145.w),
                              child: Text('UANG MUKA (Advance)', textAlign: TextAlign.end, style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 317.w),
                              child: Text(formatCurrency2(advancedCash), textAlign: TextAlign.end, ),
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
                              child: Text(formatCurrency(Kekurangan), textAlign: TextAlign.end, ),
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
                              child: Text(uraianLPD)
                            )
                          ],
                        ),
                        SizedBox(height: 30.sp,),
                        // ElevatedButton(
                        //   onPressed: (){
                        //     String strtDate = _formatDate2(startDate);
                        //     String endedDate = _formatDate2(endDate);
                        //     generateAndDisplayPDFLPD(companyName, companyAddress, namaKaryawan, departemen, spvName, memberOne, memberTwo, memberThree, memberFour, 
                        //     lpdID, projectName, strtDate, endedDate, countDayTiket, formatCurrency2(priceTiket), countDayPenginapan, countDayTransport, countDayEntertain, 
                        //     countDayLain, formatCurrency2(pricePenginapan), formatCurrency2(priceTransport), formatCurrency2(priceEntertain), formatCurrency2(priceLain),
                        //     formatCurrency2(totalTiket), formatCurrency2(totalPenginapan), formatCurrency2(totalTransport), formatCurrency2(totalEntertain), 
                        //     formatCurrency2(totalLain), formatCurrency(JumlahTiket), formatCurrency(JumlahHotel), formatCurrency(JumlahTransport), formatCurrency(JumlahEntertain),
                        //     formatCurrency(JumlahLain), formatCurrency(GrandTotal), uraianLPD, formatCurrency2(advancedCash), formatCurrency(Kekurangan), insertDt);
                        //   }, 
                        //   style: ElevatedButton.styleFrom(
                        //     elevation: 0,
                        //     alignment: Alignment.center,
                        //     minimumSize: Size(40.w, 55.h),
                        //     foregroundColor: const Color(0xFFFFFFFF),
                        //     backgroundColor: const Color(0xff4ec3fc),
                        //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        //   ),
                        //   child: Text('Download LPD')
                        // ),
                        // SizedBox(height: 30.sp,),
                        if(statusName == 'Draft LPD' && positionId == 'POS-HR-002')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: (){
                                  actionLPD('1');
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
                              ),
                              SizedBox(width: 10.w,),
                              ElevatedButton(
                                onPressed: (){
                                  actionLPD('2');
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
                            ],
                          ),
                        if(statusName == 'Laporan disetujui HRD' && positionId == 'POS-HR-001')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: (){
                                  actionLPD('3');
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
                              ),
                              SizedBox(width: 10.w,),
                              ElevatedButton(
                                onPressed: (){
                                  actionLPD('4');
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
                            ],
                          ),
                        SizedBox(height: 30.sp,),
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
                                title: Text(item['employee_name'], style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),),
                                subtitle: Text(item['action'], style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400),),
                                trailing: Text(_formatDate(item['action_dt']), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400),),
                              );
                            }
                          ),
                        ),
                        SizedBox(height: 50.sp,)
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
    return DateFormat("d MMMM yyyy HH:mm", 'id').format(parsedDate);
  }

  String _formatDate2(String date) {
    // Parse the date string
    DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(date);

    // Format the date as "d MMMM yyyy"
    return DateFormat("d MMMM yyyy", 'id').format(parsedDate);
  }
}