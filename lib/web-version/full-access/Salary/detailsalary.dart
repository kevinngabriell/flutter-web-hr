// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/web-version/full-access/Event/event.dart';
import 'package:hr_systems_web/web-version/full-access/Performance/performance.dart';
import 'package:hr_systems_web/web-version/full-access/Report/report.dart';
import 'package:hr_systems_web/web-version/full-access/Salary/currencyformatter.dart';
import 'package:hr_systems_web/web-version/full-access/Salary/salary.dart';
import 'package:hr_systems_web/web-version/full-access/Settings/setting.dart';
import 'package:hr_systems_web/web-version/full-access/Structure/structure.dart';
import 'package:hr_systems_web/web-version/full-access/Training/traning.dart';
import 'package:hr_systems_web/web-version/full-access/employee.dart';
import 'package:hr_systems_web/web-version/full-access/index.dart';
import 'package:hr_systems_web/web-version/full-access/profile.dart';
import 'package:hr_systems_web/web-version/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class DetailSalaryPage extends StatefulWidget {
  final DateTime TanggalMulai;
  final DateTime TanggalAkhir;
  final String employeeID;
  final String selectedEmployeeName;
  final String isComplete;
  DetailSalaryPage(this.TanggalMulai, this.TanggalAkhir, this.employeeID, this.selectedEmployeeName, this.isComplete);

  @override
  State<DetailSalaryPage> createState() => _DetailSalaryPageState();
}

class _DetailSalaryPageState extends State<DetailSalaryPage> {
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String employeeId = '';
  String departmentName = '';
  String positionName = '';
  String trimmedCompanyAddress = '';
  bool isLoading = false;
  final storage = GetStorage();
  String month = '';
  bool isCount = false;
  String department = '';
  String NIK = '';
  Map<String, String> enteredValues = {};
  int total = 0;
  int Minustotal = 0;

  String jumlahPulangAwal = '0';
  String jumlahDatangTelat = '0';
  String cutiTahunan = '0';
  String jumlahSakit = '0';
  int jumlahLembur = 0;
  int? terlambat;
  String jumlahAbsen = '0';

  int? selectedMethod = 1;

  int? totalEarnings;
  int? totalDeductions;
  int? takeHomePay;

  TextEditingController txtGajiPokok = TextEditingController();
  TextEditingController txtJabatan = TextEditingController();
  TextEditingController txtBPJSKetenag = TextEditingController();
  TextEditingController txtBPJSKesehatan = TextEditingController();
  TextEditingController txtLembur = TextEditingController();
  TextEditingController txtTransport = TextEditingController();
  TextEditingController txtPendapatanLainnya = TextEditingController();

  TextEditingController txtPinjaman = TextEditingController();
  TextEditingController txtPajak = TextEditingController();
  TextEditingController txtBPJSKetenagPot1 = TextEditingController();
  TextEditingController txtBPJSKesehatanPot1 = TextEditingController();
  TextEditingController txtBPJSKetenagPot2 = TextEditingController();
  TextEditingController txtBPJSKesehatanPot2 = TextEditingController();
  TextEditingController txtPPHBonus = TextEditingController();
  TextEditingController txtPotonganLainnya = TextEditingController();

  TextEditingController txtTotalEarnings = TextEditingController();

  Map<String, TextEditingController> controllers = {};
  Map<String, TextEditingController> minusControllers = {};

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDetailData();
    fetchJumlahAbsen();
    fetchEarningType();
    fetchDeducationsType();
    getSavedPayroll();
    fetchJumlahLembur();
    fetchJumlahSakit();
    fetchJumlahCuti();
    fetchJumlahPulangAwal();
    fetchDatangTelat();
    txtGajiPokok.text = formatCurrency(0);
    txtJabatan.text = formatCurrency(0);
    txtTransport.text = formatCurrency(0);
    txtBPJSKetenag.text = formatCurrency(0);
    txtBPJSKesehatan.text = formatCurrency(0);
    txtLembur.text = formatCurrency(0);
    txtPendapatanLainnya.text = formatCurrency(0);
    txtPinjaman.text = formatCurrency(0);
    txtPajak.text = formatCurrency(0);
    txtBPJSKetenagPot1.text = formatCurrency(0);
    txtBPJSKesehatanPot1.text = formatCurrency(0);
    txtBPJSKetenagPot2.text = formatCurrency(0);
    txtBPJSKesehatanPot2.text =formatCurrency(0);
    txtPPHBonus.text = formatCurrency(0);
    txtPotonganLainnya.text = formatCurrency(0);
    totalEarnings = 0;
    totalDeductions = 0;
    takeHomePay = 0;
  }

  Future<void> fetchJumlahCuti() async {
    try {
      String ID1 = widget.employeeID;
      DateTime TanggalMulai = widget.TanggalMulai;
      DateTime TanggalAkhir = widget.TanggalAkhir;

      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/salary/getjumlahcuti.php?startDate=$TanggalMulai&employee_id=$ID1&endDate=$TanggalAkhir';
      print(apiUrl);
      final response = await http.get(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        Map<String, dynamic> data = responseData['Data'][0];

        // Ensure that the fields are of the correct type
        setState(() {
          cutiTahunan = data['jumlah_cuti'];
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    }
  }

  Future<void> fetchJumlahSakit() async {
    try {
      String ID1 = widget.employeeID;
      DateTime TanggalMulai = widget.TanggalMulai;
      DateTime TanggalAkhir = widget.TanggalAkhir;

      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/salary/getjumlahsakit.php?startDate=$TanggalMulai&employee_id=$ID1&endDate=$TanggalAkhir';

      final response = await http.get(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        Map<String, dynamic> data = responseData['Data'][0];

        // Ensure that the fields are of the correct type
        setState(() {
          jumlahSakit = data['sakit'];
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    }
  }

  Future<void> fetchJumlahLembur() async {
    try {
      String ID1 = widget.employeeID;
      DateTime TanggalMulai = widget.TanggalMulai;
      DateTime TanggalAkhir = widget.TanggalAkhir;

      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/salary/getjumlahlembur.php?startDate=$TanggalMulai&employee_id=$ID1&endDate=$TanggalAkhir';

      final response = await http.get(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        Map<String, dynamic> data = responseData['Data'][0];

        // Ensure that the fields are of the correct type
        setState(() {
          jumlahLembur = int.tryParse(data['lembur']) ?? 0;
        });

      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    }
  }

  Future<void> fetchData() async {
    try {
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/account/getprofileforallpage.php';

      String employeeId = storage.read('employee_id').toString(); // replace with your logic to get employee ID

      // Create a Map for the request body
      Map<String, dynamic> requestBody = {'employee_id': employeeId};

      // Convert the Map to a JSON string
      String requestBodyJson = json.encode(requestBody);

      // Make the API call with a POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'employee_id': employeeId,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        // Ensure that the fields are of the correct type
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

  Future<void> fetchDetailData() async {
    try {
      String ID1 = widget.employeeID;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployeesalary.php?employee_id=$ID1';
      
      final response = await http.get(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        Map<String, dynamic> data = responseData['Data'][0];

        // Ensure that the fields are of the correct type
        setState(() {
          NIK = data['employee_id'] as String;
          departmentName = data['department_name'] as String;
          positionName = data['position_name'] as String;
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    }
  }

  Future<void> fetchJumlahAbsen() async {
    try {
      String ID1 = widget.employeeID;
      DateTime TanggalMulai = widget.TanggalMulai;
      DateTime TanggalAkhir = widget.TanggalAkhir;

      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/salary/getjumlahabsendata.php?startDate=$TanggalMulai&employee_id=$ID1&endDate=$TanggalAkhir';

      final response = await http.get(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        Map<String, dynamic> data = responseData['Data'][0];

        // Ensure that the fields are of the correct type
        setState(() {
          jumlahAbsen = data['total_absence'];
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    }
  }

  Future<void> fetchJumlahPulangAwal() async {
    try {
      String ID1 = widget.employeeID;
      DateTime TanggalMulai = widget.TanggalMulai;
      DateTime TanggalAkhir = widget.TanggalAkhir;

      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/salary/getpulangawaldata.php?startDate=$TanggalMulai&employee_id=$ID1&endDate=$TanggalAkhir';

      final response = await http.get(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        Map<String, dynamic> data = responseData['Data'][0];

        // Ensure that the fields are of the correct type
        setState(() {
          jumlahPulangAwal = data['jumlah_pulang_awal'] as String;
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    }
  }

  Future<void> fetchDatangTelat() async {
    try {
      String ID1 = widget.employeeID;
      DateTime TanggalMulai = widget.TanggalMulai;
      DateTime TanggalAkhir = widget.TanggalAkhir;

      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/salary/getdatangtelat.php?startDate=$TanggalMulai&employee_id=$ID1&endDate=$TanggalAkhir';

      final response = await http.get(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        Map<String, dynamic> data = responseData['Data'][0];

        // Ensure that the fields are of the correct type
        setState(() {
          jumlahDatangTelat = data['datang_telat'];
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    }
  }

  Future<List<String>> fetchEarningType() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/salary/getearningstype.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['Data'];
      return List<String>.from(data.map((item) => item['salary_category_name']));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<String>> fetchDeducationsType() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/salary/getdeducationstype.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['Data'];
      return List<String>.from(data.map((item) => item['salary_category_name']));
    } else {
      throw Exception('Failed to load data');
    }
  }

  int calculateTotal() {
    total = 0;
    controllers.forEach((category, controller) {
      if (controller.text.isNotEmpty) {
        total += int.parse(controller.text.replaceAll(RegExp(r'[^0-9]'), ''));
      }
    });
    // print('Plus Total: $total');
    return total;
  }

  String formatCurrency(int value) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0).format(value);
  }

  int calculateMinusTotal() {
    Minustotal = 0;
    minusControllers.forEach((category, controller) {
      if (controller.text.isNotEmpty) {
        Minustotal += int.parse(controller.text.replaceAll(RegExp(r'[^0-9]'), ''));
      }
    });
    // print('Minus Total: $Minustotal');
    return Minustotal;
  }

  int? calculateTakeHomePay(){
    takeHomePay = 0;
    takeHomePay = (totalEarnings! - totalDeductions!);

    return takeHomePay;
  }

  Future<void> savePayroll() async {
    try{
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/salary/savesalary.php';
      String employeeId = storage.read('employee_id').toString();

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'employeeId': widget.employeeID.toString(),
          'month': widget.TanggalMulai.month.toString(),
          'year': widget.TanggalMulai.year.toString(),
          'gajiTetap': txtGajiPokok.text.replaceAll(RegExp(r'[^0-9]'), ''),
          'Jabatan': txtJabatan.text.replaceAll(RegExp(r'[^0-9]'), ''),
          'BPJSKetenag': txtBPJSKetenag.text.replaceAll(RegExp(r'[^0-9]'), ''),
          'BPJSKesehatan': txtBPJSKesehatan.text.replaceAll(RegExp(r'[^0-9]'), ''),
          'Lembur': txtLembur.text.replaceAll(RegExp(r'[^0-9]'), ''),
          'Transport': txtTransport.text.replaceAll(RegExp(r'[^0-9]'), ''),
          'Lainnya': txtPendapatanLainnya.text.replaceAll(RegExp(r'[^0-9]'), ''),
          'Pinjaman': txtPinjaman.text.replaceAll(RegExp(r'[^0-9]'), ''),
          'Pajak': txtPajak.text.replaceAll(RegExp(r'[^0-9]'), ''),
          'PotBPJSKet1': txtBPJSKetenagPot1.text.replaceAll(RegExp(r'[^0-9]'), ''),
          'PotBPJSKes1': txtBPJSKesehatanPot1.text.replaceAll(RegExp(r'[^0-9]'), ''),
          'PotBPJSKet2': txtBPJSKetenagPot2.text.replaceAll(RegExp(r'[^0-9]'), ''),
          'PotBPJSKes2': txtBPJSKesehatanPot2.text.replaceAll(RegExp(r'[^0-9]'), ''),
          'PPHBonus': txtPPHBonus.text.replaceAll(RegExp(r'[^0-9]'), ''),
          'PotLainnya': txtPotonganLainnya.text.replaceAll(RegExp(r'[^0-9]'), ''),
          'totalEarnings': totalEarnings.toString(),
          'totalDeducations': totalDeductions.toString(),
          'totalTakeHomePay': takeHomePay.toString(),
          'requestorEmployeeId': employeeId,
        }
      );

      if(response.statusCode == 200){
        Get.back();
      } else {
        Get.snackbar('Error : ', '${response.body}');
        print('Response body: ${response.body}');
      }

    } catch (e){
      print('Exception: $e');
      Get.snackbar('Error', 'An error occurred. Please try again later.');
    }

  }

  Future<void> getSavedPayroll() async {
    String month = widget.TanggalMulai.month.toString();
    String getID = widget.employeeID;
    String year = widget.TanggalMulai.year.toString();

    try{
      String apiURL = "https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/salary/getdetailsalaryemployee.php?month=$month&employeeId=$getID&year=$year";
      var response = await http.get(Uri.parse(apiURL));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        // print(int.parse(responseData['totalPendapatan'].toString()));

        setState(() {
          txtGajiPokok.text = formatCurrency(int.parse(responseData['gajiTetap'].toString()));
          txtJabatan.text = formatCurrency(int.parse(responseData['Jabatan'].toString()));
          txtTransport.text = formatCurrency(int.parse(responseData['Transport'].toString()));
          txtBPJSKetenag.text = formatCurrency(int.parse(responseData['BPJSKetenag'].toString()));
          txtBPJSKesehatan.text = formatCurrency(int.parse(responseData['BPJSKesehatan'].toString()));
          txtLembur.text = formatCurrency(int.parse(responseData['Lembur'].toString()));
          txtPendapatanLainnya.text = formatCurrency(int.parse(responseData['Lainnya'].toString()));
          txtPinjaman.text = formatCurrency(int.parse(responseData['Pinjaman'].toString()));
          txtPajak.text = formatCurrency(int.parse(responseData['Pajak'].toString()));
          txtBPJSKetenagPot1.text = formatCurrency(int.parse(responseData['PotBPJSKet1'].toString()));
          txtBPJSKesehatanPot1.text = formatCurrency(int.parse(responseData['PotBPJSKes1'].toString()));
          txtBPJSKetenagPot2.text = formatCurrency(int.parse(responseData['PotBPJSKet2'].toString()));
          txtBPJSKesehatanPot2.text = formatCurrency(int.parse(responseData['PotBPJSKes2'].toString()));
          txtPPHBonus.text = formatCurrency(int.parse(responseData['PPHBonus'].toString()));
          txtPotonganLainnya.text = formatCurrency(int.parse(responseData['penguranganLainnya'].toString()));
          totalEarnings = int.parse(responseData['totalPendapatan'].toString());
          totalDeductions = int.parse(responseData['totalPengurangan'].toString());
          takeHomePay = int.parse(responseData['totalTakeHomePay'].toString());
        });
      }

    } catch(e){

    }

  }

  Future<void> getLastSalary() async {
    String getID = widget.employeeID;

    try{
      String apiURL = "https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/salary/getlastsalary.php?employeeId=$getID";
      var response = await http.get(Uri.parse(apiURL));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        // print(int.parse(responseData['totalPendapatan'].toString()));

        setState(() {
          txtGajiPokok.text = formatCurrency(int.parse(responseData['gajiTetap'].toString()));
          txtPinjaman.text = formatCurrency(int.parse(responseData['Pinjaman'].toString()));

          double one = (6.24/100) * int.parse(txtGajiPokok.text.replaceAll(RegExp(r'[^0-9]'), '')) ;
          int result = one.toInt();

          //Check if the result one more than 191.192
          if(result > 191192){
            int temp3 = 191192;
            txtBPJSKetenag.text = formatCurrency(temp3).toString();
            txtBPJSKetenagPot1.text = txtBPJSKetenag.text;
          } else {
            txtBPJSKetenag.text = formatCurrency(result).toString();
            txtBPJSKetenagPot1.text = txtBPJSKetenag.text;
          }

          double two = (4/100) * int.parse(txtGajiPokok.text.replaceAll(RegExp(r'[^0-9]'), '')) ;
          int resulttwo = two.toInt();

          //Check if result two more than 480k
          if(resulttwo > 480000){
            int temp1 = 480000;
            txtBPJSKesehatan.text = formatCurrency(temp1).toString();
            txtBPJSKesehatanPot1.text = formatCurrency(temp1).toString();
          } else {
            txtBPJSKesehatan.text = formatCurrency(resulttwo).toString();
            txtBPJSKesehatanPot1.text = formatCurrency(resulttwo).toString();
          }

          double three = (3/100) * int.parse(txtGajiPokok.text.replaceAll(RegExp(r'[^0-9]'), '')) ;
          int resultthree = three.toInt();

          //Check if result three more than 95.596
          if(resultthree > 95596){
            int temp4 = 95596;
            txtBPJSKetenagPot2.text = formatCurrency(temp4).toString();
          } else {
            txtBPJSKetenagPot2.text = formatCurrency(resultthree).toString();
          }

          double four = (1/100) * int.parse(txtGajiPokok.text.replaceAll(RegExp(r'[^0-9]'), '')) ;
          int resultfour = four.toInt();

          //check if four > 120.000
          if(resultfour > 120000){
            int temp2 = 120000;
            txtBPJSKesehatanPot2.text = formatCurrency(temp2).toString();
          } else {
            txtBPJSKesehatanPot2.text = formatCurrency(resultfour).toString();
          }
                                            
          int resultfive = 0;
                                            
          if(jumlahLembur > 0){
            double totalUangLembur = hitungUangLembur(jumlahLembur, double.parse(txtGajiPokok.text.replaceAll(RegExp(r'[^0-9]'), '')));
            resultfive = totalUangLembur.toInt();
            txtLembur.text = formatCurrency(resultfive).toString();
          }

          int a = int.parse(jumlahPulangAwal);
          int b = int.parse(jumlahDatangTelat);
          int c = int.parse(cutiTahunan);
          int d = int.parse(jumlahSakit);
          int e  = a + b + c + d;
          int Transport = 0;
          int Potongan = 0;

          if(selectedMethod == 2){
            //Jika izin lebih dari 3 hangus 
              if(e > 3){
                Transport = 0;
                txtTransport.text = formatCurrency(Transport).toString();
              } else {
                Transport = int.parse(jumlahAbsen) * 50000;
                txtTransport.text = formatCurrency(Transport).toString();
              }
          } else if (selectedMethod == 1){
              if(e > 3){
                Potongan = 1100000;
                txtPotonganLainnya.text = formatCurrency(Potongan).toString();
              } else if (e > 0){
                Potongan = 50000 * e;
                txtPotonganLainnya.text = formatCurrency(Potongan).toString();
              }
          }

          totalEarnings = int.parse(txtGajiPokok.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKetenag.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKesehatan.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtLembur.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtTransport.text.replaceAll(RegExp(r'[^0-9]'), ''));
          totalDeductions = int.parse(txtBPJSKetenagPot1.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKesehatanPot1.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKetenagPot2.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKesehatanPot2.text.replaceAll(RegExp(r'[^0-9]'), ''));
          takeHomePay = (totalEarnings! - totalDeductions!);
        });
      }

    } catch(e){

    }

  }

  double hitungUangLembur(int jamLembur, double upahBulanan) {
    double upahSatuJamPertama = 1.5 * (1 / 173) * upahBulanan;
    double upahJamBerikutnya = 2 * (1 / 173) * upahBulanan;

    double uangLembur = 0.0;

    if (jamLembur > 0) {
      uangLembur += upahSatuJamPertama; // Upah untuk satu jam pertama

      if (jamLembur > 1) {
        // Hitung upah untuk jam-jam berikutnya
        uangLembur += (jamLembur - 1) * upahJamBerikutnya;
      }
    }

    return uangLembur;
  }

  @override
  Widget build(BuildContext context) {
    if(widget.TanggalMulai.month == 1){
      month = 'Januari';
    } else if (widget.TanggalMulai.month == 2){
      month = 'Februari';
    } else if (widget.TanggalMulai.month == 3){
      month = 'Maret';
    } else if (widget.TanggalMulai.month == 4){
      month = 'April';
    } else if (widget.TanggalMulai.month == 5){
      month = 'Mei';
    } else if (widget.TanggalMulai.month == 6){
      month = 'Juni';
    } else if (widget.TanggalMulai.month == 7){
      month = 'Juli';
    } else if (widget.TanggalMulai.month == 8){
      month = 'Agustus';
    } else if (widget.TanggalMulai.month == 9){
      month = 'September';
    } else if (widget.TanggalMulai.month == 10){
      month = 'Oktober';
    } else if (widget.TanggalMulai.month == 11){
      month = 'November';
    } else if (widget.TanggalMulai.month == 12){
      month = 'Desember';
    }
    var photo = storage.read('photo');
    return MaterialApp(
      title: "Detail gaji karyawan",
      home: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
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
                              Get.to(PerformanceIndex());
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
                              Get.to(TrainingIndex());
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
                              Get.to(EventIndex());
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
                                  Get.to(ReportIndex());
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
                              Get.to(SettingIndex());
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
                              Get.to(StructureIndex());
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
                //content
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
                        SizedBox(height: 30.sp,),
                        //Employee Name & Period
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width  - 100.w) / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nama karyawan'
                                    ,style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 10.h,),
                                  Text(widget.selectedEmployeeName)
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width  - 100.w) / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Jabatan'
                                    ,style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 10.h,),
                                  Text(positionName)
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 15.sp,),
                        //Division 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width  - 100.w) / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Divisi'
                                    ,style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 10.h,),
                                  Text(departmentName)
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width  - 100.w) / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Periode'
                                    ,style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 10.h,),
                                   Text("$month ${widget.TanggalMulai.year}")
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 15.sp,),
                        //Status 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width  - 100.w) / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('NIK'
                                    ,style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 10.h,),
                                  Text(NIK)
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width  - 100.w) / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Metode Perhitungan'
                                    ,style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 10.h,),
                                  DropdownButtonFormField(
                                    value: 01,
                                    items: [
                                      DropdownMenuItem(
                                        value: 01,
                                        child: Text('Metode 1')
                                      ),
                                      DropdownMenuItem(
                                        value: 02,
                                        child: Text('Metode 2')
                                      )
                                    ], 
                                    onChanged: (value){
                                      selectedMethod = value;

                                      int a = int.parse(jumlahPulangAwal);
                                      int b = int.parse(jumlahDatangTelat);
                                      int c = int.parse(cutiTahunan);
                                      int d = int.parse(jumlahSakit);
                                      int e  = a + b + c + d;
                                      int Transport = 0;
                                      int Potongan = 0;

                                      if(selectedMethod == 2){
                                      //Jika izin lebih dari 3 hangus 
                                        txtPotonganLainnya.text = formatCurrency(Potongan).toString();
                                        if(e > 3){
                                          Transport = 0;
                                          txtTransport.text = formatCurrency(Transport).toString();
                                        } else {
                                          Transport = int.parse(jumlahAbsen) * 50000;
                                          txtTransport.text = formatCurrency(Transport).toString();
                                        }
                                      } else if (selectedMethod == 1){
                                        if(e > 3){
                                          Potongan = 1100000;
                                          txtPotonganLainnya.text = formatCurrency(Potongan).toString();
                                        } else if (e > 0){
                                          Potongan = 50000 * e;
                                          txtPotonganLainnya.text = formatCurrency(Potongan).toString();
                                        }
                                      }

                                      setState(() {
                                        totalEarnings = int.parse(txtGajiPokok.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtJabatan.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKetenag.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKesehatan.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtLembur.text.replaceAll(RegExp(r'[^0-9]'), '')) + Transport + int.parse(txtPendapatanLainnya.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                        totalDeductions = Potongan + int.parse(txtPinjaman.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtPajak.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKetenagPot1.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKesehatanPot1.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKetenagPot2.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKesehatanPot2.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtPPHBonus.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                        takeHomePay = (totalEarnings! - totalDeductions!);
                                      });
                                      
                                    }
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25.sp,),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            color: Colors.transparent, // Make the Card background transparent
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red, // Set the desired background color
                                borderRadius: BorderRadius.circular(8.0), // Add border radius if needed
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 15.sp, top: 15.sp, bottom: 15.sp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Perhatian', style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold)), // Set text color
                                    SizedBox(height: 7.sp,),
                                    Text(
                                      'Jika angka total perhitungan gaji tidak berubah, silahkan coba hapus salah satu 0 dan tambahkan kembali pada pendapatan dan potongan',
                                      style: TextStyle(color: Colors.white), // Set text color
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 25.sp,),
                        //Data Absen
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 5.w) / 2,
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15.sp, right: 15.sp, top: 18.sp, bottom: 18.sp),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      //Gaji pokok
                                      Text('Gaji pokok'
                                        ,style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        )
                                      ),
                                      SizedBox(height: 10.h),
                                      TextFormField(
                                        controller: txtGajiPokok,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          CurrencyFormatter(),
                                        ],
                                        readOnly: widget.isComplete == '1' ? true : false,
                                        onChanged: (value){
                                          setState(() {
                                            double one = (6.24/100) * int.parse(txtGajiPokok.text.replaceAll(RegExp(r'[^0-9]'), '')) ;
                                            int result = one.toInt();

                                            //Check if the result one more than 191.192
                                            if(result > 191192){
                                              int temp3 = 191192;
                                              txtBPJSKetenag.text = formatCurrency(temp3).toString();
                                              txtBPJSKetenagPot1.text = txtBPJSKetenag.text;
                                            } else {
                                              txtBPJSKetenag.text = formatCurrency(result).toString();
                                              txtBPJSKetenagPot1.text = txtBPJSKetenag.text;
                                            }

                                            double two = (4/100) * int.parse(txtGajiPokok.text.replaceAll(RegExp(r'[^0-9]'), '')) ;
                                            int resulttwo = two.toInt();

                                            //Check if result two more than 480k
                                            if(resulttwo > 480000){
                                              int temp1 = 480000;
                                              txtBPJSKesehatan.text = formatCurrency(temp1).toString();
                                              txtBPJSKesehatanPot1.text = formatCurrency(temp1).toString();
                                            } else {
                                              txtBPJSKesehatan.text = formatCurrency(resulttwo).toString();
                                              txtBPJSKesehatanPot1.text = formatCurrency(resulttwo).toString();
                                            }

                                            double three = (3/100) * int.parse(txtGajiPokok.text.replaceAll(RegExp(r'[^0-9]'), '')) ;
                                            int resultthree = three.toInt();

                                            //Check if result three more than 95.596
                                            if(resultthree > 95596){
                                              int temp4 = 95596;
                                              txtBPJSKetenagPot2.text = formatCurrency(temp4).toString();
                                            } else {
                                              txtBPJSKetenagPot2.text = formatCurrency(resultthree).toString();
                                            }

                                            double four = (1/100) * int.parse(txtGajiPokok.text.replaceAll(RegExp(r'[^0-9]'), '')) ;
                                            int resultfour = four.toInt();

                                            //check if four > 120.000
                                            if(resultfour > 120000){
                                              int temp2 = 120000;
                                              txtBPJSKesehatanPot2.text = formatCurrency(temp2).toString();
                                            } else {
                                              txtBPJSKesehatanPot2.text = formatCurrency(resultfour).toString();
                                            }
                                            
                                            int resultfive = 0;
                                            
                                            if(jumlahLembur > 0){
                                              double totalUangLembur = hitungUangLembur(jumlahLembur, double.parse(txtGajiPokok.text.replaceAll(RegExp(r'[^0-9]'), '')));
                                              resultfive = totalUangLembur.toInt();
                                              txtLembur.text = formatCurrency(resultfive).toString();
                                            }

                                            int a = int.parse(jumlahPulangAwal);
                                            int b = int.parse(jumlahDatangTelat);
                                            int c = int.parse(cutiTahunan);
                                            int d = int.parse(jumlahSakit);
                                            int e  = a + b + c + d;
                                            int Transport = 0;
                                            int Potongan = 0;

                                            if(selectedMethod == 2){
                                              //Jika izin lebih dari 3 hangus 
                                              if(e > 3){
                                                Transport = 0;
                                                txtTransport.text = formatCurrency(Transport).toString();
                                              } else {
                                                Transport = int.parse(jumlahAbsen) * 50000;
                                                txtTransport.text = formatCurrency(Transport).toString();
                                              }
                                            } else if (selectedMethod == 1){
                                              if(e > 3){
                                                Potongan = 1100000;
                                                txtPotonganLainnya.text = formatCurrency(Potongan).toString();
                                              } else if (e > 0){
                                                Potongan = 50000 * e;
                                                txtPotonganLainnya.text = formatCurrency(Potongan).toString();
                                              }
                                            }

                                            totalEarnings = int.parse(txtGajiPokok.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKetenag.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKesehatan.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtLembur.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtTransport.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                            totalDeductions = int.parse(txtBPJSKetenagPot1.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKesehatanPot1.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKetenagPot2.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKesehatanPot2.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                            takeHomePay = (totalEarnings! - totalDeductions!);
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          fillColor: Color.fromRGBO(235, 235, 235, 1),
                                          hintText: 'Masukkan gaji pokok' ,
                                        )
                                      ),
                                      SizedBox(height: 20.h),
                                      //Tunjangan Jabatan
                                      Text('Tunjangan jabatan'
                                        ,style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        )
                                      ),
                                      SizedBox(height: 10.h),
                                      TextFormField(
                                        controller: txtJabatan,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          CurrencyFormatter(),
                                        ],
                                        readOnly: widget.isComplete == '1' ? true : false,
                                        onChanged: (value){
                                          setState(() {
                                            totalEarnings = int.parse(txtGajiPokok.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtJabatan.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                            takeHomePay = (totalEarnings! - totalDeductions!);
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          fillColor: Color.fromRGBO(235, 235, 235, 1),
                                          hintText: 'Masukkan tunjangan jabatan' ,
                                        )
                                      ),
                                      SizedBox(height: 20.h),
                                      //BPJS Ketenagakerjaan + JP
                                      Text('BPJS Ketenagakerjaan + JP'
                                        ,style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        )
                                      ),
                                      SizedBox(height: 10.h),
                                      TextFormField(
                                        controller: txtBPJSKetenag,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          CurrencyFormatter(),
                                        ],
                                        readOnly: widget.isComplete == '1' ? true : false,
                                        onChanged: (value){
                                          setState(() {
                                            totalEarnings = int.parse(txtGajiPokok.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtJabatan.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKetenag.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                            takeHomePay = (totalEarnings! - totalDeductions!);
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          fillColor: Color.fromRGBO(235, 235, 235, 1),
                                          hintText: 'Masukkan BPJS Ketenagakerjaan + JP' ,
                                        )
                                      ),
                                      SizedBox(height: 20.h),
                                      //BPJS Kesehatan
                                      Text('BPJS Kesehatan'
                                        ,style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        )
                                      ),
                                      SizedBox(height: 10.h),
                                      TextFormField(
                                        controller: txtBPJSKesehatan,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          CurrencyFormatter(),
                                        ],
                                        readOnly: widget.isComplete == '1' ? true : false,
                                        onChanged: (value){
                                          setState(() {
                                            totalEarnings = int.parse(txtGajiPokok.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtJabatan.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKetenag.text.replaceAll(RegExp(r'[^0-9]'), ''))  + int.parse(txtBPJSKesehatan.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                            takeHomePay = (totalEarnings! - totalDeductions!);
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          fillColor: Color.fromRGBO(235, 235, 235, 1),
                                          hintText: 'Masukkan BPJS Kesehatan' ,
                                        )
                                      ),
                                      SizedBox(height: 20.h),
                                      //Lembur
                                      Text('Lembur'
                                        ,style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        )
                                      ),
                                      SizedBox(height: 10.h),
                                      TextFormField(
                                        controller: txtLembur,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          CurrencyFormatter(),
                                        ],
                                        readOnly: widget.isComplete == '1' ? true : false,
                                        onChanged: (value){
                                          setState(() {
                                            totalEarnings = int.parse(txtGajiPokok.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtJabatan.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKetenag.text.replaceAll(RegExp(r'[^0-9]'), ''))  + int.parse(txtBPJSKesehatan.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtLembur.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                            takeHomePay = (totalEarnings! - totalDeductions!);
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          fillColor: Color.fromRGBO(235, 235, 235, 1),
                                          hintText: 'Masukkan lembur' ,
                                        )
                                      ),
                                      SizedBox(height: 20.h),
                                      //Transport
                                      Text('Transport'
                                        ,style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        )
                                      ),
                                      SizedBox(height: 10.h),
                                      TextFormField(
                                        controller: txtTransport,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          CurrencyFormatter(),
                                        ],
                                        readOnly: widget.isComplete == '1' ? true : false,
                                        onChanged: (value){
                                          setState(() {
                                            totalEarnings = int.parse(txtGajiPokok.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtJabatan.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKetenag.text.replaceAll(RegExp(r'[^0-9]'), ''))  + int.parse(txtBPJSKesehatan.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtLembur.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtTransport.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                            takeHomePay = (totalEarnings! - totalDeductions!);
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          fillColor: Color.fromRGBO(235, 235, 235, 1),
                                          hintText: 'Masukkan transport' ,
                                        )
                                      ),
                                      SizedBox(height: 20.h),
                                      //Lainnya
                                      Text('Lainnya'
                                        ,style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        )
                                      ),
                                      SizedBox(height: 10.h),
                                      TextFormField(
                                        controller: txtPendapatanLainnya,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          CurrencyFormatter(),
                                        ],
                                        readOnly: widget.isComplete == '1' ? true : false,
                                        onChanged: (value){
                                          setState(() {
                                            totalEarnings = int.parse(txtGajiPokok.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtJabatan.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKetenag.text.replaceAll(RegExp(r'[^0-9]'), ''))  + int.parse(txtBPJSKesehatan.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtLembur.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtTransport.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtPendapatanLainnya.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                            takeHomePay = (totalEarnings! - totalDeductions!);
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          fillColor: Color.fromRGBO(235, 235, 235, 1),
                                          hintText: 'Masukkan lainnya' ,
                                        )
                                      ),
                                      SizedBox(height: 20.h),
                                    ],
                                  )
                                  
                                ),
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 170.w) / 2,
                              child: Column(
                                children: [
                                  Card(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 15.sp, right: 15.sp, top: 18.sp, bottom: 18.sp),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('Jumlah presensi kehadiran'
                                            ,style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                            )
                                          ),
                                          SizedBox(height: 10.h,),
                                          Text(jumlahAbsen.toString()),
                                          SizedBox(height: 20.h,),
                                          Text('Jumlah izin pulang awal'
                                            ,style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                            )
                                          ),
                                          SizedBox(height: 10.h,),
                                          Text(jumlahPulangAwal),
                                          SizedBox(height: 20.h,),
                                          Text('Jumlah izin datang terlambat'
                                            ,style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                            )
                                          ),
                                          SizedBox(height: 10.h,),
                                          Text(jumlahDatangTelat),
                                          SizedBox(height: 20.h,),
                                          Text('Jumlah izin cuti tahunan'
                                            ,style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                            )
                                          ),
                                          SizedBox(height: 10.h,),
                                          Text('$cutiTahunan hari'),
                                          SizedBox(height: 20.h,),
                                          Text('Jumlah izin sakit'
                                            ,style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                            )
                                          ),
                                          SizedBox(height: 10.h,),
                                          Text('$jumlahSakit hari'),
                                          SizedBox(height: 20.h,),
                                          GestureDetector(
                                            onTap: () {
                                              
                                            },
                                            child: Text('Jumlah lembur'
                                              ,style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                              )
                                            ),
                                          ),
                                          SizedBox(height: 10.h,),
                                          GestureDetector(
                                            onTap: () {

                                            },
                                            child: Text('$jumlahLembur jam')
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  ElevatedButton(
                                    onPressed: (){
                                      getLastSalary();
                                    }, 
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      alignment: Alignment.center,
                                      minimumSize: Size(40.w, 50.h),
                                      foregroundColor: const Color(0xFFFFFFFF),
                                      backgroundColor: const Color(0xff4ec3fc),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: Text('Ambil data dari bulan lalu')
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 25.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 5.w) / 2,
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15.sp, right: 15.sp, top: 18.sp, bottom: 18.sp),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      //Pinjaman
                                      Text('Pinjaman'
                                        ,style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        )
                                      ),
                                      SizedBox(height: 10.h),
                                      TextFormField(
                                        controller: txtPinjaman,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          CurrencyFormatter(),
                                        ],
                                        onChanged: (value){
                                          setState(() {
                                            totalDeductions = int.parse(txtPinjaman.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                            takeHomePay = (totalEarnings! - totalDeductions!);
                                          });
                                        },
                                        readOnly: widget.isComplete == '1' ? true : false,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          fillColor: Color.fromRGBO(235, 235, 235, 1),
                                          hintText: 'Masukkan pinjaman' ,
                                        )
                                      ),
                                      SizedBox(height: 20.h),
                                      //Pajak (PPH 21)
                                      Text('Pajak (PPH 21)'
                                        ,style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        )
                                      ),
                                      SizedBox(height: 10.h),
                                      TextFormField(
                                        controller: txtPajak,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          CurrencyFormatter(),
                                        ],
                                        onChanged: (value){
                                          setState(() {
                                            totalDeductions = int.parse(txtPajak.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtPajak.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                            takeHomePay = (totalEarnings! - totalDeductions!);
                                          });
                                        },
                                        readOnly: widget.isComplete == '1' ? true : false,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          fillColor: Color.fromRGBO(235, 235, 235, 1),
                                          hintText: 'Masukkan pajak (PPH 21)' ,
                                        )
                                      ),
                                      SizedBox(height: 20.h),
                                      //BPJS Ketenag
                                      Text('BPJS Ketenag'
                                        ,style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        )
                                      ),
                                      SizedBox(height: 10.h),
                                      TextFormField(
                                        controller: txtBPJSKetenagPot1,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          CurrencyFormatter(),
                                        ],
                                        readOnly: widget.isComplete == '1' ? true : false,
                                        onChanged: (value){
                                          setState(() {
                                            totalDeductions = int.parse(txtPajak.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtPajak.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKetenagPot1.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                            takeHomePay = (totalEarnings! - totalDeductions!);
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          fillColor: Color.fromRGBO(235, 235, 235, 1),
                                          hintText: 'Masukkan BPJS Ketenag' ,
                                        )
                                      ),
                                      SizedBox(height: 20.h),
                                      //BPJS Kesehatan
                                      Text('BPJS Kesehatan',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        )
                                      ),
                                      SizedBox(height: 10.h),
                                      TextFormField(
                                        controller: txtBPJSKesehatanPot1,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          CurrencyFormatter(),
                                        ],
                                        readOnly: widget.isComplete == '1' ? true : false,
                                        onChanged: (value){
                                          setState(() {
                                            totalDeductions = int.parse(txtPajak.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtPajak.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKetenagPot1.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKesehatanPot1.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                            takeHomePay = (totalEarnings! - totalDeductions!);
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          fillColor: Color.fromRGBO(235, 235, 235, 1),
                                          hintText: 'Masukkan BPJS Kesehatan' ,
                                        )
                                      ),
                                      SizedBox(height: 20.h),
                                      //BPJS Ketenag
                                      Text('BPJS Ketenag',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        )
                                      ),
                                      SizedBox(height: 10.h),
                                      TextFormField(
                                        controller: txtBPJSKetenagPot2,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          CurrencyFormatter(),
                                        ],
                                        readOnly: widget.isComplete == '1' ? true : false,
                                        onChanged: (value){
                                          setState(() {
                                            totalDeductions = int.parse(txtPajak.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtPajak.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKetenagPot1.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKesehatanPot1.text.replaceAll(RegExp(r'[^0-9]'), ''))+ int.parse(txtBPJSKetenagPot2.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                            takeHomePay = (totalEarnings! - totalDeductions!);
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          fillColor: Color.fromRGBO(235, 235, 235, 1),
                                          hintText: 'Masukkan BPJS Ketenag' ,
                                        )
                                      ),
                                      SizedBox(height: 20.h),
                                      //BPJS Kesehatan
                                      Text('BPJS Kesehatan',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        )
                                      ),
                                      SizedBox(height: 10.h),
                                      TextFormField(
                                        controller: txtBPJSKesehatanPot2,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          CurrencyFormatter(),
                                        ],
                                        readOnly: widget.isComplete == '1' ? true : false,
                                        onChanged: (value){
                                          setState(() {
                                            totalDeductions = int.parse(txtPajak.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtPajak.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKetenagPot1.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKesehatanPot1.text.replaceAll(RegExp(r'[^0-9]'), ''))+ int.parse(txtBPJSKetenagPot2.text.replaceAll(RegExp(r'[^0-9]'), ''))+ int.parse(txtBPJSKesehatanPot2.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                            takeHomePay = (totalEarnings! - totalDeductions!);
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          fillColor: Color.fromRGBO(235, 235, 235, 1),
                                          hintText: 'Masukkan BPJS Kesehatan' ,
                                        )
                                      ),
                                      SizedBox(height: 20.h),
                                      //PPH atas bonus/komisi
                                      Text('PPH atas bonus/komisi',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        )
                                      ),
                                      SizedBox(height: 10.h),
                                      TextFormField(
                                        controller: txtPPHBonus,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          CurrencyFormatter(),
                                        ],
                                        readOnly: widget.isComplete == '1' ? true : false,
                                        onChanged: (value){
                                          setState(() {
                                            totalDeductions = int.parse(txtPajak.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtPajak.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKetenagPot1.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKesehatanPot1.text.replaceAll(RegExp(r'[^0-9]'), ''))+ int.parse(txtBPJSKetenagPot2.text.replaceAll(RegExp(r'[^0-9]'), ''))+ int.parse(txtBPJSKesehatanPot2.text.replaceAll(RegExp(r'[^0-9]'), ''))+ int.parse(txtPPHBonus.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                            takeHomePay = (totalEarnings! - totalDeductions!);
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          fillColor: Color.fromRGBO(235, 235, 235, 1),
                                          hintText: 'Masukkan PPH atas bonus/komisi' ,
                                        )
                                      ),
                                      SizedBox(height: 20.h),
                                      //Lainnya
                                      Text('Lainnya',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        )
                                      ),
                                      SizedBox(height: 10.h),
                                      TextFormField(
                                        controller: txtPotonganLainnya,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          CurrencyFormatter(),
                                        ],
                                        readOnly: widget.isComplete == '1' ? true : false,
                                        onChanged: (value){
                                          setState(() {
                                            totalDeductions = int.parse(txtPajak.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtPajak.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKetenagPot1.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtBPJSKesehatanPot1.text.replaceAll(RegExp(r'[^0-9]'), ''))+ int.parse(txtBPJSKetenagPot2.text.replaceAll(RegExp(r'[^0-9]'), ''))+ int.parse(txtBPJSKesehatanPot2.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtPPHBonus.text.replaceAll(RegExp(r'[^0-9]'), '')) + int.parse(txtPotonganLainnya.text.replaceAll(RegExp(r'[^0-9]'), ''));
                                            takeHomePay = (totalEarnings! - totalDeductions!);
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          fillColor: Color.fromRGBO(235, 235, 235, 1),
                                          hintText: 'Masukkan lainnya' ,
                                        )
                                      ),
                                      SizedBox(height: 20.h),
                                    ],
                                  )
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 25.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 5.w) / 2,
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15.sp, right: 15.sp, top: 18.sp, bottom: 18.sp),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Pendapatan kotor'),
                                          Text(formatCurrency(totalEarnings ?? 0),
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                            )
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Total pengurangan'),
                                          Text(formatCurrency(totalDeductions ?? 0),
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                            )
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Take Home Pay'),
                                          Text(formatCurrency(takeHomePay ?? 0),
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                            )
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 25.sp,),
                        Padding(
                          padding: EdgeInsets.only(right: 25.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: (){
                                  showDialog(
                                    context: context, 
                                    builder: (_){
                                      return AlertDialog(
                                        title: Text('Konfirmasi'),
                                        content: Text('Apakah anda yakin ingin mengumpulkan data ? Data yang sudah dikumpulkan tidak dapat diubah'),
                                        actions: [
                                          TextButton(
                                            onPressed: (){
                                              Get.back();
                                            }, 
                                            child: Text('Batal')
                                          ),
                                          TextButton(
                                            onPressed: (){
                                              Get.back();
                                              savePayroll();
                                            }, 
                                            child: Text('Kumpul')
                                          )
                                        ],
                                      );
                                    }
                                  );
                                }, 
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  alignment: Alignment.center,
                                  minimumSize: Size(40.w, 50.h),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: const Color(0xff4ec3fc),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Simpan dan Verifikasi')
                              ),
                              SizedBox(width: 5.w,),
                              // ElevatedButton(
                              //   onPressed: (){
                              //     submitPayroll();
                              //   }, 
                              //   style: ElevatedButton.styleFrom(
                              //     elevation: 0,
                              //     alignment: Alignment.center,
                              //     minimumSize: Size(40.w, 50.h),
                              //     foregroundColor: const Color(0xFFFFFFFF),
                              //     backgroundColor: const Color(0xff4ec3fc),
                              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              //   ),
                              //   child: const Text('Verifikasi')
                              // )
                            ],
                          ),
                        ),
                        SizedBox(height: 25.sp,),
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

  


}

