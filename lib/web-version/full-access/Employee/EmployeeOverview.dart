// ignore_for_file: avoid_print, file_names, unnecessary_string_interpolations, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, unnecessary_null_comparison, use_build_context_synchronously, non_constant_identifier_names, empty_catches

import 'dart:typed_data';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Employee%20Detail/EmployeeDetailOne.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/EmployeeList.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/detailInventory.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/detailInventoryRequest.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/ViewLPD.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/ViewPerjalananDinas.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../leave/ShowAllMyPermission.dart';
import '../leave/ViewOnly.dart';

class EmployeeOverviewPage extends StatefulWidget {
  final String employeeId;

  EmployeeOverviewPage(this.employeeId);

  @override
  State<EmployeeOverviewPage> createState() => _EmployeeOverviewPageState();
}

class _EmployeeOverviewPageState extends State<EmployeeOverviewPage> with TickerProviderStateMixin {
  TextEditingController txtSearchName = TextEditingController();
  late TabController tabController;
  late Future<Map<String, dynamic>> employeeData;
  late Future<List<Map<String, dynamic>>> absenceData;
  bool isLoading = false;
  bool isLoadingA = false;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  List<dynamic> profileData = [];
  List<Map<String, String>> spvs = [];
  List<Map<String, String>> spvName = [];
  String? selectedSPV;
  String? namaSPV;
  String spvID = '';
  String employeeID = '';
  String employeeNIK = '';
  String username = '';
  String gender = '';
  String dob = '';
  String pob = '';
  String status = '';
  String phone = '';

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  TextEditingController txtCuti = TextEditingController();
  DateTime? TanggalExp;
  DateTime? TanggalExpUpdate;
  List<Map<String, dynamic>> permissionDataLimit = [];
  Map<String, String> leaveCounts = {};
  List<Map<String, dynamic>> leaveCountsYears = [];

  List<Map<String, String>> jenisabsen = [];
  String selectedJenisAbsen = '';
  TextEditingController txtLokasiAbsen = TextEditingController();
  DateTime? TanggalAbsen;
  String? JamAbsen;
  List<Map<String, String>> listlokasiabsen = [];
  String selectedLokasiAbsen = '';
  DateTime? expDate;
  int? leaveCount;
  String expDateCuti = '';
  TextEditingController txtCutiUpdate = TextEditingController();
  String namaKaryawan = '';
  String selectedFile = '';
  Uint8List? image;
  String emailKaryawan = '';

  List<Map<String, dynamic>> myInventory = [];
  List<Map<String, dynamic>> myRequestInventory = [];
  List<Map<String, dynamic>> myBusinessTrip = [];
  List<Map<String, dynamic>> myLPD = [];

  String ktp = '-';
  String simA = '-';
  String simC = '-';
  String npwp = '-';
  String bpjs = '-';

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 6, vsync: this);
    fetchEmployeeData(widget.employeeId);
    absenceData = fetchAbsenceData(widget.employeeId);
    fetchData();
    fetchSPVdata();
    _selectedDay = _focusedDay;
    fetchLeaveCounts();
    fetchLeaveCountsYears();
    fetchJenisAbsen();
    fetchMasterLokasiAbsen();
    fetchInventory();
    fetchMyRequest();
    fetchPerjalananDinas();
    getProfileImage();
  }

  Future<void> getProfileImage() async{

    try {
      setState(() {
        isLoading = true;
      });
      final storage = GetStorage();

      var employeeId = storage.read('employee_id');
      String imageUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployeedoc.php?action=1&employee_id=${widget.employeeId}';
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        // Decode base64 image
        Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          ktp = data['ktp'];
        });
        
      } else {
        setState(() {
          isLoading = false;
        });
        // Handle error
        print('Failed to load image. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle exception
      setState(() {
        isLoading = false;
      });
      print('Error: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchPerjalananDinas() async {
    String employeeId = storage.read('employee_id').toString();

    try{
      isLoading = true;

      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/getperjalanandinas.php?action=6&employee_id=${widget.employeeId}';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          myBusinessTrip = List<Map<String, dynamic>>.from(data['Data']);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }

      isLoading = true;

      String mylpdUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/getlpd.php?action=2&employee_id=${widget.employeeId}';
      var mylpdResponse = await http.get(Uri.parse(mylpdUrl));

      if (mylpdResponse.statusCode == 200) {
        var mylpdData = json.decode(mylpdResponse.body);

        setState(() {
          myLPD = List<Map<String, dynamic>>.from(mylpdData['Data']);
        });
      } else {
        print('Failed to load data: ${mylpdResponse.statusCode}');
      }
    } catch (e){
      print(e.toString());
    } finally {
      isLoading = false;
    }

  }

  Future<void> fetchMyRequest() async{
    String employeeId = storage.read('employee_id').toString();
   
    try{
      setState(() {
        isLoading = true;
      });

      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/mytoprequest.php?employee_id=${widget.employeeId}';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          myRequestInventory = List<Map<String, dynamic>>.from(data['Data']);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e){
      print(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }

  }

  Future<void> fetchInventory() async{
    String employeeId = storage.read('employee_id').toString();
    setState(() {
      isLoading = true;
    });

    try{  
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/getinventory.php?action=7&employee_id=${widget.employeeId}';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          myInventory = List<Map<String, dynamic>>.from(data['Data']);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }

    } catch (e){
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> insertAbsenManual() async {
    String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-systems-data-v.1/AbsenceProcess/InsertAbsen.php'; // Replace with your API endpoint
    String employeeID = widget.employeeId;
    String companyId = GetStorage().read('company_id');

    // Prepare data to be sent in the request
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
        // Handle API error
        print('Failed to fetch data');
      }
    } else {
      // Handle HTTP error
      print('Failed to fetch data');
    }
  }

  Future<void> fetchMasterLokasiAbsen() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/absent/getlistabsencelocation.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        setState(() {
          listlokasiabsen = (data['Data'] as List)
              .map((jenis) => Map<String, String>.from(jenis))
              .toList();
          if (listlokasiabsen.isNotEmpty) {
            selectedLokasiAbsen = listlokasiabsen[0]['location_name']!;
          }
        });
      } else {
        // Handle API error
        print('Failed to fetch data');
      }
    } else {
      // Handle HTTP error
      print('Failed to fetch data');
    }
  }

  Future<void> fetchLimitMyPermission() async{
    String employeeID = widget.employeeId;

    try{  
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/showmypermissionlimit.php?id=$employeeID';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          permissionDataLimit = List<Map<String, dynamic>>.from(data['Data']);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }

    } catch (e){
      print('Error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAbsenceData(String employeeId) async {
    String employeeID = widget.employeeId;
    try {
      final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/absent/getabsencebyid.php?employee_id=$employeeID'),
      );

      if (response.statusCode == 200) {
        // If the server returns an OK response, parse the JSON
        List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        // If the server did not return a 200 OK response, handle the error
        print('Failed to load data. Status code: ${response.statusCode}');
        return []; // You can return an empty list or throw an exception based on your use case
      }
    } catch (e) {
      // Handle other types of exceptions, such as network errors
      print('Error: $e');
      return []; // You can return an empty list or throw an exception based on your use case
    }
  }

  Future<void> fetchEmployeeData(String employeeId) async {
    try{
      isLoading = true;

      final response = await http.get(Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployeeoverview.php?employee_id=$employeeId'),);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        
        setState(() {
          employeeID = jsonData['Data'][0]['employee_id'];
          status = jsonData['Data'][0]['employee_status_name'];
          phone = jsonData['Data'][0]['employee_phone_number'];
          namaKaryawan = jsonData['Data'][0]['employee_name'];
          emailKaryawan = jsonData['Data'][0]['employee_email'];
          pob = jsonData['Data'][0]['employee_pob'];
          dob = jsonData['Data'][0]['employee_dob'];
          gender = jsonData['Data'][0]['gender_name'];
          username  = jsonData['Data'][0]['username'];
          employeeNIK = jsonData['Data'][0]['employee_identity'];
          spvID = jsonData['Data'][0]['employee_spv'];
        });

        final responseSPVName = await http.get(Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployee.php?action=3&spv_id=$spvID'));

        if(responseSPVName.statusCode == 200){
          final SPVNamedata = json.decode(responseSPVName.body);
          spvName= (SPVNamedata['Data'] as List).map((spv) => Map<String, String>.from(spv)).toList();

          setState(() {
            namaSPV = spvName[0]['employee_name'];
          });
        } else {
          setState(() {
            namaSPV = '-';
          });
        }
      } else {
        throw Exception('Failed to load employee data');
      }
    } catch (e){
      isLoading = false;
      print('error');
    } finally {
      isLoading = false;
    }
  }

  final storage = GetStorage();

  Future<void> fetchData() async {
    String employeeId = storage.read('employee_id').toString();

    try {
      isLoading = true;
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
    } finally {
      isLoading = false;
    }
  }

  Future<void> createAccount(String employeeId) async {
    const String apiUrl = "https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/account/createaccount.php";

    try{
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'id': employeeId
        }
      );

      if(response.statusCode == 200){
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Sukses"),
              content: const Text("User telah berhasil dibuat"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.back();
                  }, 
                  child: const Text("Kembali")
                ),
              ],
            );
          }
        );
      } else if (response.statusCode == 300){
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Gagal"),
              content: const Text("User telah terdaftar. Silahkan periksa kembali username dan password anda"),
              actions: <Widget>[
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
      } else {
        Get.snackbar("Error", "Gagal membuat akun");
      }

    } catch (e){
      Get.snackbar("Error", "Error message : $e");
    }

  }

  Future<void> resetAccount(String employeeId) async {
    const String apiUrl = "https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/account/resetaccount.php";

    try{
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'id': employeeId
        }
      );

      if(response.statusCode == 200){
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Sukses"),
              content: const Text("Password user telah berhasil direset"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.back();
                  }, 
                  child: const Text("Kembali")
                ),
              ],
            );
          }
        );
      } else if (response.statusCode == 300){
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Gagal"),
              content: const Text("User tidak terdaftar. Silahkan buat user terlebih dahulu"),
              actions: <Widget>[
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
      } else {
        Get.snackbar("Error", "Gagal reset akun");
      }


    } catch (e){
      Get.snackbar("Error", "Error message : $e");
    }
  }

  Future<void> deleteAccount(String employeeId) async {
    const String apiUrl = "https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/account/deleteaccount.php";

    try{
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'id': employeeId
        }
      );

      if(response.statusCode == 200){
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Sukses"),
              content: const Text("Akun telah berhasil dihapus"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.back();
                  }, 
                  child: const Text("Kembali")
                ),
              ],
            );
          }
        );
      } else if (response.statusCode == 300){
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Gagal"),
              content: const Text("User tidak terdaftar. Silahkan buat user terlebih dahulu"),
              actions: <Widget>[
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
      } else {
        Get.snackbar("Error", "Gagal hapus akun");
      }


    } catch (e){
      Get.snackbar("Error", "Error message : $e");
    }
  }

  Future<void> fetchSPVdata() async {
    final response = await http.get(Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/account/getspvlist.php'));

    if(response.statusCode == 200){
      final data = json.decode(response.body);
      try{
        setState(() {
          isLoadingA = true;
        });
        if (data['StatusCode'] == 200) {
          setState(() async {
            spvs= (data['Data'] as List)
                .map((spv) => Map<String, String>.from(spv))
                .toList();
            if (spvs.isNotEmpty) {
              selectedSPV = spvs[0]['id']!;
              
              
            } else {
              setState(() {
                namaSPV = '-';
              });
            }
          });
        } else {
          // Handle API error
          print('Failed to fetch data');
        }
      } catch (e){
        setState(() {
          isLoadingA = false;
          namaSPV = '-';
        });      
      } finally {
        setState(() {
          isLoadingA = false;
        });
      }
    }

  }

  Future<void> inputUpdateJatahCuti() async {
    const String apiUrl = "https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/insertjatahcuti.php";

    try{
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'employee_id': widget.employeeId,
          'jatah_cuti': txtCuti.text,
          'exp_date': TanggalExp.toString(),
        }
      );

      if(response.statusCode == 200){
        Get.back();
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Sukses"),
              content: const Text("Jatah cuti telah berhasil diupdate"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.to(const EmployeeListPage());
                  }, 
                  child: const Text("Kembali")
                ),
              ],
            );
          }
        );
      } else {
        Get.snackbar("Error", "Gagal update jatah cuti");
      }
    } catch(e){

    }

  }

  Future<void> inputUpdateAbsenceMapping() async {
    const String apiUrl = "https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/absent/insertabsencemapping.php";

    try{
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'employee_id': widget.employeeId,
          'absence_location': selectedLokasiAbsen,
        }
      );

      if(response.statusCode == 200){
        Get.back();
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Sukses"),
              content: const Text("Lokasi absen telah berhasil diupdate"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.to(const EmployeeListPage());
                  }, 
                  child: const Text("Kembali")
                ),
              ],
            );
          }
        );
      } else {
        Get.snackbar("Error", "Gagal update lokasi absen");
      }
    } catch(e){

    }

  }

  Future<void> updateSPVdata() async {
    const String apiUrl = "https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/updateemployeespv.php";

    try{
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'employee_id': widget.employeeId,
          'spv_id': selectedSPV
        }
      );

      if(response.statusCode == 200){
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Sukses"),
              content: const Text("SPV telah berhasil diupdate"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.to(const EmployeeListPage());
                  }, 
                  child: const Text("Kembali")
                ),
              ],
            );
          }
        );
      } else if (response.statusCode == 300){
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Gagal"),
              content: const Text("Update SPV gagal"),
              actions: <Widget>[
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
      } else {
        Get.snackbar("Error", "Gagal update SPV");
      }
    } catch(e){

    }

  }

  Future<void> fetchLeaveCounts() async {
    String employeeIDfectchLeaveCounts = widget.employeeId;
      final apiUrl =
          'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/getjatahcuti.php?employee_id=$employeeIDfectchLeaveCounts';

      try {
        isLoading = true;
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);

          if (jsonResponse['Status'] == 'Success') {
            final data = jsonResponse['Data'] as List<dynamic>;

            for (var entry in data) {
              final year = entry['year'];
              final leaveCount = entry['leave_count'];

              // Save leave_count in a string
              leaveCounts['StringCuti$year'] = leaveCount;
            }

          } else {
            throw Exception('Failed to fetch data: ${jsonResponse['Status']}');
          }
        } else {
          throw Exception('Failed to load data');
        }
      } catch (e) {
        throw Exception('Error: $e');
      } finally {
        isLoading = false;
      }
    }

  Future<void> fetchLeaveCountsYears() async {
    String employeeIDfectchLeaveCounts = widget.employeeId;

    try {
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/getangkacutibyid.php?employee_id=$employeeIDfectchLeaveCounts';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('Data') && responseData['Data'] is List && (responseData['Data'] as List).isNotEmpty) {

          Map<String, dynamic> data = (responseData['Data'] as List).first;
          if (data.containsKey('leave_count') && data['leave_count'] != null) {
            final formatter = DateFormat('d MMMM yyyy');
            expDate = DateTime.parse(data['expired_date'].toString());
            String formattedExpDate = formatter.format(expDate!);
            isLoading = false;
            setState(() {
              leaveCount = int.parse(data['leave_count'].toString());
              txtCutiUpdate.text = leaveCount.toString();
              expDateCuti = formattedExpDate;
            });
            
          } else {
            print('leave_count is null or not found in the response data.');
          }
        } else {
          isLoading = false;
          print('Data is null or not found in the response data.');
        }
      } else {
        isLoading = false;
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      isLoading = false;
      print('Error: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> updateCuti() async {
      String employeeIDfectchLeaveCounts = widget.employeeId;

      try {
        setState(() {
          isLoading = true;
        });
        String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/updatecuti.php';

        print(txtCutiUpdate.text);

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "leave_update": txtCutiUpdate.text,
            "leave_before": txtCutiUpdate.text,
            "exp_update" : TanggalExpUpdate.toString(),
            "exp_before" : expDateCuti.toString(),
            "employee_id": employeeIDfectchLeaveCounts
          }
        );

        if(response.statusCode == 200){
          Get.to(const EmployeeListPage());

        } else {
          Get.snackbar('Gagal', '${response.body}');
          print('Failed to insert employee. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }

      } catch (e){
        Get.snackbar('Gagal', '$e');
        print('Exception during API call: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
  }
  
  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
    );

    if (result != null) {
      String selectedFileName = result.files.first.name;
      List<int> imageBytes = result.files.first.bytes!;

      // Convert the image bytes to base64
      String base64Image = base64Encode(imageBytes);

      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/uploademployeephoto.php';

      var data = {
        'employee_id' : widget.employeeId,
        'photo': base64Image
      };

      // Send the request using dio for multipart/form-data
      var dioClient = dio.Dio();
      dio.Response response = await dioClient.post(apiUrl, data: dio.FormData.fromMap(data));
      print('Success: ${response.data}');
      if (response.statusCode == 200) {

        showDialog(
          context: context, // Make sure to have access to the context
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sukses'),
              content: const Text('Upload foto karyawan telah berhasil dilakukan'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Oke'),
                ),
              ],
            );
          },
        );
      } else {
        Get.snackbar("Error", "Error: ${response.statusCode}, ${response.data}");
      }

    } else {
      // User canceled the file picking
    }
  }
  
  Future<void> ktpFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
    );

    if (result != null) {
      String selectedFileName = result.files.first.name;
      List<int> imageBytes = result.files.first.bytes!;

      // Convert the image bytes to base64
      try{
        setState(() {
          isLoading = true;
        });
        String base64Image = base64Encode(imageBytes);

        String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/uploaddoc.php';

        var data = {
          'employee_id' : widget.employeeId,
          'doc': base64Image,
          'action_id' : '1'
        };

        // Send the request using dio for multipart/form-data
        var dioClient = dio.Dio();
        dio.Response response = await dioClient.post(apiUrl, data: dio.FormData.fromMap(data));
        
        if (response.statusCode == 200) {
          showDialog(
            context: context, // Make sure to have access to the context
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: Text('Upload ktp $namaKaryawan telah berhasil dilakukan'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const EmployeeListPage());
                    },
                    child: const Text('Oke'),
                  ),
                ],
              );
            },
          );
        } else {
          print(response.data);
          Get.snackbar("Error", "Error: ${response.statusCode}, ${response.data}");
        }
      } catch (e){

      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      // User canceled the file picking
    }
  }

  Future<void> simAFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
    );

    if (result != null) {
      String selectedFileName = result.files.first.name;
      List<int> imageBytes = result.files.first.bytes!;

      // Convert the image bytes to base64
      try{
        setState(() {
          isLoading = true;
        });
        String base64Image = base64Encode(imageBytes);

        String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/uploaddoc.php';

        var data = {
          'employee_id' : widget.employeeId,
          'doc': base64Image,
          'action_id' : '2'
        };

        // Send the request using dio for multipart/form-data
        var dioClient = dio.Dio();
        dio.Response response = await dioClient.post(apiUrl, data: dio.FormData.fromMap(data));
        
        if (response.statusCode == 200) {
          showDialog(
            context: context, // Make sure to have access to the context
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: Text('Upload sim A $namaKaryawan telah berhasil dilakukan'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const EmployeeListPage());
                    },
                    child: const Text('Oke'),
                  ),
                ],
              );
            },
          );
        } else {
          print(response.data);
          Get.snackbar("Error", "Error: ${response.statusCode}, ${response.data}");
        }
      } catch (e){

      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      // User canceled the file picking
    }
  }

  Future<void> simCFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
    );

    if (result != null) {
      String selectedFileName = result.files.first.name;
      List<int> imageBytes = result.files.first.bytes!;

      // Convert the image bytes to base64
      try{
        setState(() {
          isLoading = true;
        });
        String base64Image = base64Encode(imageBytes);

        String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/uploaddoc.php';

        var data = {
          'employee_id' : widget.employeeId,
          'doc': base64Image,
          'action_id' : '3'
        };

        // Send the request using dio for multipart/form-data
        var dioClient = dio.Dio();
        dio.Response response = await dioClient.post(apiUrl, data: dio.FormData.fromMap(data));
        
        if (response.statusCode == 200) {
          showDialog(
            context: context, // Make sure to have access to the context
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: Text('Upload sim C $namaKaryawan telah berhasil dilakukan'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const EmployeeListPage());
                    },
                    child: const Text('Oke'),
                  ),
                ],
              );
            },
          );
        } else {
          print(response.data);
          Get.snackbar("Error", "Error: ${response.statusCode}, ${response.data}");
        }
      } catch (e){

      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      // User canceled the file picking
    }
  }
  
  Widget buildLeaveCard() {
    return SizedBox(
      width: (MediaQuery.of(context).size.width) / 4,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context, 
            builder: (context) {
            return AlertDialog(
              title: Text(
                'Update cuti', 
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 6.sp,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 200.w) / 2,
                          child: Column(
                            children: [
                              const Text('Cuti tahunan'),
                              SizedBox(height: 10.h,),
                              TextFormField(
                                controller: txtCutiUpdate,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Color.fromRGBO(235, 235, 235, 1),
                                  hintText: 'Masukkan jumlah cuti'
                                ),
                                readOnly: false,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 200.w) / 2,
                          child: Column(
                            children: [
                              const Text('Masa akhir cuti'),
                              SizedBox(height: 10.h,),
                             DateTimePicker(
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2055),
                              initialDate: expDateCuti != null
                                  ? DateFormat('d MMMM yyyy').parse(expDateCuti)
                                  : DateTime.now(),
                              dateMask: 'd MMM yyyy',
                              onChanged: (value) {
                                setState(() {
                                  TanggalExpUpdate = DateFormat('yyyy-MM-dd').parse(value);
                                });
                                                            },
                              // Other properties...
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: (){
                  if (double.tryParse(txtCutiUpdate.text) != null ) {
                    updateCuti();
                  } else {
                  // At least one input is not a valid numeric value or is empty
                    if (double.tryParse(txtCutiUpdate.text) == null) {
                      Get.snackbar('Error', 'Cuti harus berisi angka saja dan tidak dapat kosong');
                    }
                  }
                }, 
                child: const Text('Update')
              ),
              TextButton(
                onPressed: (){
                  Get.back();
                }, 
                child: const Text('Batal')
              )
            ],
          );
        });
        },
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          color: Colors.white,
          shadowColor: Colors.black,
          child: Padding(
            padding: EdgeInsets.only(left: 5.sp, top: 5.sp, bottom: 5.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  leaveCount.toString(),
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
                ),
                Text(
                  'Masa berakhir cuti $expDateCuti ',
                  style: TextStyle(fontSize: 4.5.sp, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    var employeeId = storage.read('employee_id');
    var positionId = storage.read('position_id');
    var photo = storage.read('photo');
    int storedEmployeeIdNumber = int.parse(widget.employeeId);

    return MaterialApp(
      title: 'Employee Overview',
      home: Scaffold(
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
                      TabBar(
                        isScrollable: false,
                        controller: tabController,
                        labelColor: const Color.fromRGBO(78, 195, 252, 1),
                        unselectedLabelColor: Colors.black,
                        tabs: [
                          Tab( 
                            child: Text(
                              'Overview', 
                              style: TextStyle(
                                fontSize: 4.sp, 
                                fontWeight: FontWeight.w400,
                                //color: tabController.index == 0 ? Color.fromRGBO(78, 195, 252, 1) : Colors.black
                              ),
                            ),
                          ),
                          Tab( 
                            child: Text(
                              'Absen', 
                              style: TextStyle(
                                fontSize: 4.sp, 
                                fontWeight: FontWeight.w400,
                                //color: Colors.black
                              ),
                            ),
                          ),
                          Tab( 
                            child: Text(
                              'Cuti', 
                              style: TextStyle(
                                fontSize: 4.sp, 
                                fontWeight: FontWeight.w400,
                                //color: Colors.black
                              ),
                            ),
                          ),
                          Tab( 
                            child: Text(
                              'Inventaris', 
                              style: TextStyle(
                                fontSize: 4.sp, 
                                fontWeight: FontWeight.w400,
                                //color: Colors.black
                              ),
                            ),
                          ),
                          Tab( 
                            child: Text(
                              'Perjalanan Dinas', 
                              style: TextStyle(
                                fontSize: 4.sp, 
                                fontWeight: FontWeight.w400,
                                //color: Colors.black
                              ),
                            ),
                          ),
                          Tab( 
                            child: Text(
                              'Dokumen', 
                              style: TextStyle(
                                fontSize: 4.sp, 
                                fontWeight: FontWeight.w400,
                                //color: Colors.black
                              ),
                            ),
                          ),
                        ]
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height + 520.h,
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height,
                        ),
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 5.sp, right: 10.sp),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 2,
                                    child: Column(
                                      children: [
                                        Card(
                                          shape: const RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(12))),
                                          color: Colors.white,
                                          shadowColor: Colors.black,
                                          child: SizedBox(
                                            width: MediaQuery.of(context).size.width / 2,
                                            child: Padding(
                                              padding: EdgeInsets.all(4.sp),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Informasi Umum', style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,),),
                                                    SizedBox(height: 10.h,),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: (MediaQuery.of(context).size.width - 900) / 2,
                                                          child: Text('NIK', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700,))
                                                        ),
                                                        SizedBox(
                                                          width: (MediaQuery.of(context).size.width - 800) / 2,
                                                          child: Text(employeeID)
                                                        ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 20.h,),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 900) / 2,
                                                              child: Text('Nama lengkap', 
                                                                style: TextStyle(
                                                                  fontSize: 4.sp,
                                                                  fontWeight: FontWeight.w700,
                                                                )
                                                              )
                                                            ),
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 800) / 2,
                                                              child: Text(namaKaryawan)
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 20.h,),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 900) / 2,
                                                              child: Text('Tempat, tanggal lahir', 
                                                                style: TextStyle(
                                                                  fontSize: 4.sp,
                                                                  fontWeight: FontWeight.w700,
                                                                )
                                                              )
                                                            ),
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 800) / 2,
                                                              child: Text('$pob, $dob')
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 20.h,),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 900) / 2,
                                                              child: Text('Jenis kelamin', 
                                                                style: TextStyle(
                                                                  fontSize: 4.sp,
                                                                  fontWeight: FontWeight.w700,
                                                                )
                                                              )
                                                            ),
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 800) / 2,
                                                              child: Text(gender)
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 20.h,),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 900) / 2,
                                                              child: Text('Nomor KTP', 
                                                                style: TextStyle(
                                                                  fontSize: 4.sp,
                                                                  fontWeight: FontWeight.w700,
                                                                )
                                                              )
                                                            ),
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 800) / 2,
                                                              child: Text(employeeNIK)
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 20.h,),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 900) / 2,
                                                              child: Text('Username', 
                                                                style: TextStyle(
                                                                  fontSize: 4.sp,
                                                                  fontWeight: FontWeight.w700,
                                                                )
                                                              )
                                                            ),
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 800) / 2,
                                                              child: Text(username)
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 20.h,),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 900) / 2,
                                                              child: Text('Email', 
                                                                style: TextStyle(
                                                                  fontSize: 4.sp,
                                                                  fontWeight: FontWeight.w700,
                                                                )
                                                              )
                                                            ),
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 800) / 2,
                                                              child: Text(emailKaryawan)
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 20.h,),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 900) / 2,
                                                              child: Text('Nomor handphone', 
                                                                style: TextStyle(
                                                                  fontSize: 4.sp,
                                                                  fontWeight: FontWeight.w700,
                                                                )
                                                              )
                                                            ),
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 800) / 2,
                                                              child: Text(phone)
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 20.h,),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 900) / 2,
                                                              child: Text('Status', 
                                                                style: TextStyle(
                                                                  fontSize: 4.sp,
                                                                  fontWeight: FontWeight.w700,
                                                                )
                                                              )
                                                            ),
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 800) / 2,
                                                              child: Text(status)
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 20.h,),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 900) / 2,
                                                              child: Text('Supervisor', 
                                                                style: TextStyle(
                                                                  fontSize: 4.sp,
                                                                  fontWeight: FontWeight.w700,
                                                                )
                                                              )
                                                            ),
                                                            SizedBox(
                                                              width: (MediaQuery.of(context).size.width - 800) / 2,
                                                              child: Text(namaSPV!)
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 20.h,),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    )
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.sp),
                                    child: SizedBox(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008')
                                            ElevatedButton(
                                              onPressed: () {
                                                Get.to(EmployeeDetailOne(widget.employeeId));
                                              }, 
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size(80.w, 45.h),
                                                foregroundColor: const Color(0xFFFFFFFF),
                                                backgroundColor: const Color(0xff4ec3fc),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text('Detail karyawan')
                                            ),
                                          SizedBox(height: 15.h,),
                                          if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008')
                                            ElevatedButton(
                                              onPressed: () {
                                                _selectFile();
                                              }, 
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size(80.w, 45.h),
                                                foregroundColor: const Color(0xFFFFFFFF),
                                                backgroundColor: const Color(0xff4ec3fc),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text('Upload foto karyawan')
                                            ),
                                          SizedBox(height: 15.h,),
                                          if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008')
                                            ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context, 
                                                  builder: (_) {
                                                    return AlertDialog(
                                                      title: const Text('Pilih supervisor'),
                                                      content: DropdownButtonFormField<String>(
                                                        value: selectedSPV,
                                                        items: spvs.map<DropdownMenuItem<String>>(
                                                          (Map<String, String> spv) {
                                                            return DropdownMenuItem<String>(
                                                              value: spv['id']!,
                                                              child: Text(spv['employee_name']!),
                                                            );
                                                          },
                                                        ).toList(),
                                                        hint: const Text('Pilih SPV'),
                                                        onChanged: (String? newValue) {
                                                          setState(() {
                                                            selectedSPV = newValue!;
                                                            //fetchPositions(selectedCompany, selectedDepartment);
                                                          });
                                                        },
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            updateSPVdata();
                                                          }, 
                                                          child: const Text("Simpan")
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          }, 
                                                          child: const Text("Batal")
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                );
                                              }, 
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size(80.w, 45.h),
                                                foregroundColor: const Color(0xFFFFFFFF),
                                                backgroundColor: const Color(0xff4ec3fc),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text('Set supervisor')
                                            ),
                                          
                                          SizedBox(height: 15.h,),
                                          if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008')
                                            ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context, 
                                                  builder: (_) {
                                                    return AlertDialog(
                                                      title: const Text('Pilih lokasi absen'),
                                                      content: DropdownButtonFormField<String>(
                                                        value: selectedLokasiAbsen,
                                                        items: listlokasiabsen.map<DropdownMenuItem<String>>(
                                                          (Map<String, String> lokasiabsen) {
                                                            return DropdownMenuItem<String>(
                                                              value: lokasiabsen['location_name']!,
                                                              child: Text(lokasiabsen['location_name']!),
                                                            );
                                                          },
                                                        ).toList(),
                                                        hint: const Text('Pilih lokasi absen'),
                                                        onChanged: (String? newValue) {
                                                          setState(() {
                                                            selectedLokasiAbsen = newValue!;
                                                            //fetchPositions(selectedCompany, selectedDepartment);
                                                          });
                                                        },
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            inputUpdateAbsenceMapping();
                                                          }, 
                                                          child: const Text("Simpan")
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          }, 
                                                          child: const Text("Batal")
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                );
                                              }, 
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size(80.w, 45.h),
                                                foregroundColor: const Color(0xFFFFFFFF),
                                                backgroundColor: const Color(0xff4ec3fc),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text('Set lokasi absen')
                                            ),
                                          
                                          SizedBox(height: 15.h,),
                                          if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008')
                                            ElevatedButton(
                                              onPressed: () {
                                                createAccount(widget.employeeId);
                                              }, 
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size(80.w, 45.h),
                                                foregroundColor: const Color(0xFFFFFFFF),
                                                backgroundColor: const Color(0xff4ec3fc),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text('Buat akun')
                                            ),
                                          SizedBox(height: 15.h,),
                                          if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008')
                                            ElevatedButton(
                                              onPressed: () {
                                                resetAccount(widget.employeeId);
                                              }, 
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size(80.w, 45.h),
                                                foregroundColor: const Color(0xFFFFFFFF),
                                                backgroundColor: const Color(0xff4ec3fc),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text('Reset akun')
                                            ),
                                          SizedBox(height: 15.h,),
                                          if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008')
                                            ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context, 
                                                  builder: (_) {
                                                    return AlertDialog(
                                                      title: const Text('Under Construction'),
                                                      content: const Text("Fitur ini belum tersedia"),
                                                      actions: <Widget>[
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
                                              }, 
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size(80.w, 45.h),
                                                foregroundColor: const Color(0xFFFFFFFF),
                                                backgroundColor: const Color(0xff4ec3fc),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text('Request update data')
                                            ),
                                          SizedBox(height: 15.h,),
                                          if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008')
                                            ElevatedButton(
                                              onPressed: () {
                                                deleteAccount(widget.employeeId);
                                              }, 
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size(80.w, 45.h),
                                                foregroundColor: const Color(0xFFFFFFFF),
                                                backgroundColor: Colors.red,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text('Hapus akun')
                                            )
                                        ],
                                      )
                                    ),
                                  )
                                ],
                              ),
                            ),
                            if (storedEmployeeIdNumber == employeeId || positionId == 'POS-HR-002' || positionId == 'POS-HR-008')
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(height: 10.h,),
                                  if (positionId == 'POS-HR-002' || positionId == 'POS-HR-008')
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
                                                              Text( 'Tipe Absen',
                                                                style: TextStyle(
                                                                  fontSize: 4.sp,
                                                                  fontWeight: FontWeight.w700,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 10), // Add a space of 10 pixels
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
                                                              Text(
                                                                'Tanggal Absen',
                                                                style: TextStyle(
                                                                  fontSize: 4.sp,
                                                                  fontWeight: FontWeight.w700,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 10), // Add a space of 10 pixels
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
                                                                      //selectedDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(txtTanggal);
                                                                    });
                                                                  },
                                                                )
                                                              ),    
                                                            ],
                                                          ),
                                                          const SizedBox(width: 30), // Add a space of 10 pixels
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Text( 'Jam Absen',
                                                                style: TextStyle(
                                                                  fontSize: 4.sp,
                                                                  fontWeight: FontWeight.w700,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 10), // Add a space of 10 pixels
                                                              SizedBox(
                                                                width: MediaQuery.of(context).size.width / 4,
                                                                child: DateTimePicker(
                                                                  type: DateTimePickerType.time,
                                                                  onChanged: (value) {
                                                                    setState(() {
                                                                      JamAbsen = value.toString();
                                                                    });
                                                                  },
                                                                )
                                                              ),
                                                              const SizedBox(height: 20),
                                                              Text(
                                                                'Lokasi Absen',
                                                                style: TextStyle(
                                                                  fontSize: 4.sp,
                                                                  fontWeight: FontWeight.w700,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 10), // Add a space of 10 pixels
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
                                  SizedBox(height: 10.h,),
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
                                        color: Colors.blue,
                                        //shape: BoxShape.circle
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
                                            child: Text(
                                              '${date.day}',
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
                                  SizedBox(height: 20.h,),
                                  Expanded(
                                    child: FutureBuilder(
                                      future: absenceData,
                                      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                          return const Center(child: Text('Tidak ada data absen pada hari tersebut')); // Handle case where data is empty
                                        } else {
                                          List<Map<String, dynamic>> data = snapshot.data!;
                                          // Use the fetched data to build your UI
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
                                                            title: Text(
                                                              'Detail Absen', 
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                fontSize: 7.sp,
                                                                fontWeight: FontWeight.w800
                                                              ),
                                                            ),
                                                            content: SizedBox(
                                                              width: MediaQuery.of(context).size.width/2,
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
                                                                        children: [
                                                                          SizedBox(
                                                                            width: MediaQuery.of(context).size.width / 6,
                                                                            child: Image.memory(base64Decode('${entry['photo']}')),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(width: 30), // Add a space of 10 pixels
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            'Tipe Absen',
                                                                            style: TextStyle(
                                                                              fontSize: 4.sp,
                                                                              fontWeight: FontWeight.w700,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 10), // Add a space of 10 pixels
                                                                          SizedBox(
                                                                            width: MediaQuery.of(context).size.width / 4,
                                                                            child: TextFormField(
                                                                              decoration: InputDecoration(
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                ),
                                                                                // filled: true,
                                                                                // fillColor: Color(0xffe1e1e1),
                                                                                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                                              ),
                                                                              readOnly: true,
                                                                              initialValue: '${entry['absence_type_name']}',
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 20),
                                                                          Text(
                                                                            'Tanggal Absen',
                                                                            style: TextStyle(
                                                                              fontSize: 4.sp,
                                                                              fontWeight: FontWeight.w700,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 10), // Add a space of 10 pixels
                                                                          SizedBox(
                                                                            width: MediaQuery.of(context).size.width / 4,
                                                                            child: TextFormField(
                                                                              decoration: InputDecoration(
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                ),
                                                                                // filled: true,
                                                                                // fillColor: Color(0xffe1e1e1),
                                                                                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                                              ),
                                                                              readOnly: true,
                                                                              initialValue: '${entry['date']}',
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 20),
                                                                          Text(
                                                                            'Jam Absen',
                                                                            style: TextStyle(
                                                                              fontSize: 4.sp,
                                                                              fontWeight: FontWeight.w700,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 10), // Add a space of 10 pixels
                                                                          SizedBox(
                                                                            width: MediaQuery.of(context).size.width / 4,
                                                                            child: TextFormField(
                                                                              decoration: InputDecoration(
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                ),
                                                                                // filled: true,
                                                                                // fillColor: Color(0xffe1e1e1),
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
                                                                          Text(
                                                                            'Lokasi',
                                                                            style: TextStyle(
                                                                              fontSize: 4.sp,
                                                                              fontWeight: FontWeight.w700,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 10), // Add a space of 10 pixels
                                                                          SizedBox(
                                                                            width: MediaQuery.of(context).size.width / 2,
                                                                            child: TextFormField(
                                                                              maxLines: 3,
                                                                              decoration: InputDecoration(
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                ),
                                                                                // filled: true,
                                                                                // fillColor: Color(0xffe1e1e1),
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
                                                            actions: [
                                                              TextButton(
                                                                onPressed: (){
                                                                    if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008'){
                                                                      print('${entry['absence_id']}');
                                                                    } else {
                                                                      Get.snackbar('Error', 'Anda tidak memiliki akses');
                                                                      Get.back();
                                                                    }
                                                                }, 
                                                                child: const Text('Koreksi Absen')
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(context).pop(); // Close the dialog
                                                                },
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
                                                        title: Text(
                                                          '${entry['absence_type_name']}',
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.w700
                                                          ),
                                                        ),
                                                        //title: Text('Date: ${entry['date']}'),
                                                        subtitle: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(height: 10.h,),
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
                                                            color: '${entry['presence_type_name']}' == 'tepat waktu' ? Colors.green : Colors.yellow,
                                                            child: Center(
                                                              child: Text(
                                                                '${entry['presence_type_name']}',
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
                                                  ),
                                                );
                                              } else {
                                                return Container(
                                                  //child: Center(child: Text('Belum ada record absen anda pada hari yang dipilih !!'))
                                                );
                                              }
                                              
                                            },
                                          );
                                        }
                                      },
                                    )
                                  ),
                                ],
                              ),
                            if (storedEmployeeIdNumber == employeeId || positionId == 'POS-HR-002' || positionId == 'POS-HR-008')
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(height: 10.h,),
                                  if (positionId == 'POS-HR-002' || positionId == 'POS-HR-008')
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width - 160.w) / 4,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(40.w, 55.h),
                                          foregroundColor:const Color(0xFFFFFFFF),
                                          backgroundColor:const Color(0xff4ec3fc),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                BorderRadius.circular(8),
                                            ),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Text(
                                            'Input/Update Cuti',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        onPressed: () async => {
                                          showDialog(
                                            context: context, 
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'Input cuti', 
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 4.sp,
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
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            width: (MediaQuery.of(context).size.width - 200.w) / 2,
                                                            child: Column(
                                                              children: [
                                                                const Text('Cuti tahunan'),
                                                                SizedBox(height: 10.h,),
                                                                TextFormField(
                                                                  controller: txtCuti,
                                                                  decoration: const InputDecoration(
                                                                    border: OutlineInputBorder(),
                                                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                                                    hintText: 'Masukkan jumlah cuti'
                                                                  ),
                                                                  readOnly: false,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: (MediaQuery.of(context).size.width - 200.w) / 2,
                                                            child: Column(
                                                              children: [
                                                                const Text('Masa akhir cuti'),
                                                                SizedBox(height: 10.h,),
                                                                DateTimePicker(
                                                                  firstDate: DateTime.now(),
                                                                  lastDate: DateTime(2055),
                                                                  initialDate: DateTime.now(),
                                                                  dateMask: 'd MMM yyyy',
                                                                  onChanged: (value) {
                                                                    setState(() {
                                                                      TanggalExp = DateFormat('yyyy-MM-dd').parse(value);
                                                                    });
                                                                  },
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: (){
                                                      if (double.tryParse(txtCuti.text) != null ) {
                                                        inputUpdateJatahCuti();
                                                      } else {
                                                        // At least one input is not a valid numeric value or is empty
                                                        if (double.tryParse(txtCuti.text) == null) {
                                                          Get.snackbar('Error', 'Cuti harus berisi angka saja dan tidak dapat kosong');
                                                        }
                                                      }

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
                                  SizedBox(height: 15.h,),
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        buildLeaveCard()
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 25.h,),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Card(
                                      shape: const RoundedRectangleBorder( 
                                        borderRadius: BorderRadius.all(Radius.circular(12))
                                      ),
                                      color: Colors.white,
                                      shadowColor: Colors.black,
                                      child: SizedBox(
                                         width: (MediaQuery.of(context).size.width),
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 4.sp, top: 2.sp, bottom: 4.sp,right: 4.sp),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 4.sp,),
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.to(const ShowAllMyPermission());
                                                    },
                                                    child: Text('Izin $namaKaryawan',
                                                      style: TextStyle(
                                                        fontSize: 6.sp, fontWeight: FontWeight.w700,
                                                      )
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 3.sp,),
                                              Row(
                                                children: [
                                                  Text( 'Kelola dan tijau izin yang telah diajukan',
                                                    style: TextStyle(
                                                      fontSize: 3.sp, fontWeight: FontWeight.w300,
                                                    )
                                                  ),
                                                ],
                                              ),
                                              SizedBox( height: 4.sp,),
                                              for (int index = 0; index < 3; index++)
                                                Column(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Get.to(ViewOnlyPermission(permission_id : permissionDataLimit[index]['id_permission']));
                                                      },
                                                      child: Card(
                                                        child: ListTile(
                                                          title: Text(
                                                            index < permissionDataLimit.length
                                                                ? '${permissionDataLimit[index]['employee_name']} | ${permissionDataLimit[index]['permission_type_name']}'
                                                                : '-',
                                                            style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),
                                                          ),
                                                          subtitle: Text(
                                                            index < permissionDataLimit.length
                                                                ? permissionDataLimit[index]['permission_status_name']
                                                                : '-',
                                                            style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 5.sp,),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            Column(
                              children: [
                                SizedBox(height: 10.sp,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width - 100.w) / 2,
                                      child: Card(
                                        shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(12))),
                                        color: Colors.white,
                                        shadowColor: Colors.black,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 4.sp, top: 4.sp, bottom: 4.sp, right: 4.sp),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('List Permohonan',style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w700,)),
                                              SizedBox(height: 1.sp,),
                                              Text('List permohonan $namaKaryawan', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w300,)),
                                              SizedBox(height: 7.sp,),
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width,
                                                height: (MediaQuery.of(context).size.height - 50.sp),
                                                child: ListView.builder(
                                                  itemCount: myRequestInventory.length,
                                                  itemBuilder: (context, index){
                                                    var item = myRequestInventory[index];
                                                    return Padding(
                                                      padding: EdgeInsets.only(bottom: 3.sp),
                                                      child: Card(
                                                        child: ListTile(
                                                          title: Text(item['employee_name'] + ' | ' + item['item_request'], style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700)),
                                                          subtitle: Text(item['status_name'], style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400)),
                                                          onTap: () {
                                                            Get.to(DetailInventoryRequest((item['request_id'])));
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ),
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width - 100.w) / 2,
                                      child: Card(
                                        shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(12))),
                                        color: Colors.white,
                                        shadowColor: Colors.black,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 4.sp, top: 4.sp, bottom: 4.sp, right: 4.sp),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Inventaris',style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w700,)),
                                              SizedBox(height: 1.sp,),
                                              Text('List inventaris $namaKaryawan', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w300,)),
                                              SizedBox(height: 7.sp,),
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width,
                                                height: (MediaQuery.of(context).size.height - 50.sp),
                                                child: ListView.builder(
                                                  itemCount: myInventory.length,
                                                  itemBuilder: (context, index){
                                                    var item = myInventory[index];
                                                    return Padding(
                                                      padding: EdgeInsets.only(bottom: 3.sp),
                                                      child: Card(
                                                        child: ListTile(
                                                          title: Text(item['inventory_name'], style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700)),
                                                          subtitle: Text(item['inventory_id'], style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400)),
                                                          trailing: Container(
                                                            alignment: Alignment.center,
                                                            constraints: BoxConstraints(
                                                              maxWidth: 30.w,
                                                            ),
                                                            decoration: const BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                                              color: Colors.green,
                                                            ),
                                                            child: Text(item['status_name'], textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 3.sp),),
                                                          ),
                                                          onTap: () {
                                                            Get.to(detailInventory((item['inventory_id'])));
                                                          },
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
                                    )
                                  ],
                                )
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(height: 10.sp,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width - 100.w) / 2,
                                      child: Card(
                                        shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(12))),
                                        color: Colors.white,
                                        shadowColor: Colors.black,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 4.sp, top: 4.sp, bottom: 4.sp, right: 4.sp),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Perjalanan Dinas',style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w700,)),
                                              SizedBox(height: 1.sp,),
                                              Text('List perjalanan dinas $namaKaryawan', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w300,)),
                                              SizedBox(height: 7.sp,),
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width,
                                                height: (MediaQuery.of(context).size.height - 50.sp),
                                                child: ListView.builder(
                                                  itemCount: myBusinessTrip.length,
                                                  itemBuilder: (context, index){
                                                    return Padding(
                                                      padding: EdgeInsets.only(bottom: 3.sp),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Get.to(ViewPerjalananDinas(perjalananDinasID: myBusinessTrip[index]['businesstrip_id'], perjalananDinasStatus: myBusinessTrip[index]['status_name'],  tanggalPermohonan: myBusinessTrip[index]['insert_dt'], namaKota: myBusinessTrip[index]['nama_kota'], lamaDurasi: myBusinessTrip[index]['duration_name'], keterangan: myBusinessTrip[index]['reason'], tim: myBusinessTrip[index]['team'], pembayaran: myBusinessTrip[index]['payment_name'], tranportasi: myBusinessTrip[index]['transport_name'], namaKaryawan: myBusinessTrip[index]['employee_name'], namaDepartemen: myBusinessTrip[index]['department_name'], requestorID: myBusinessTrip[index]['insert_by'],));
                                                        },
                                                        child: Card(
                                                          child: ListTile(
                                                            title: Text(myBusinessTrip[index]['employee_name'], style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w700),),
                                                            subtitle: Text('${myBusinessTrip[index]['nama_kota']} (${myBusinessTrip[index]['duration_name']})', style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),),
                                                            trailing: Text(myBusinessTrip[index]['status_name'], style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),),
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
                                        shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(12))),
                                        color: Colors.white,
                                        shadowColor: Colors.black,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 4.sp, top: 4.sp, bottom: 4.sp, right: 4.sp),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Laporan Perjalanan Dinas',style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w700,)),
                                              SizedBox(height: 1.sp,),
                                              Text('List laporan perjalanan dinas $namaKaryawan', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w300,)),
                                              SizedBox(height: 7.sp,),
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width,
                                                height: (MediaQuery.of(context).size.height - 50.sp),
                                                child: ListView.builder(
                                                  itemCount: myLPD.length,
                                                  itemBuilder: (context, index){
                                                    return Padding(
                                                      padding: EdgeInsets.only(bottom: 3.sp),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Get.to(ViewLPD(businessTripID: myLPD[index]['businesstrip_id']));
                                                        },
                                                        child: Card(
                                                          child: ListTile(
                                                            title: Text(myLPD[index]['employee_name'], style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w700),),
                                                            subtitle: Text('${myLPD[index]['name']} (${myLPD[index]['project_name']})', style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),),
                                                            trailing: Text(myLPD[index]['status_name'], style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),),
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
                            ),
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 10.sp,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 100.w) / 2,
                                        child: Card(
                                          shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(12))),
                                          color: Colors.white,
                                          shadowColor: Colors.black,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 4.sp, top: 4.sp, bottom: 4.sp, right: 4.sp),
                                            child: Column(
                                              children: [
                                                Center(child: Text('File KTP', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700,),)),
                                                SizedBox(height: 5.sp,),
                                                if(ktp == '-')
                                                  const Center(child: Text('File KTP belum diupload ke dalam sistem')),
                                                if(ktp != '-')
                                                  Image.memory(base64Decode(ktp)),
                                                SizedBox(height: 5.sp,),
                                                ElevatedButton(
                                                  onPressed: (){
                                                    ktpFile();
                                                  }, 
                                                  style: ElevatedButton.styleFrom(
                                                    minimumSize: Size(50.w, 55.h),
                                                    foregroundColor: const Color(0xFFFFFFFF),
                                                    backgroundColor: const Color(0xff4ec3fc),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                  child: const Text('Upload KTP')
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 100.w) / 2,
                                        child: Card(
                                          shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(12))),
                                          color: Colors.white,
                                          shadowColor: Colors.black,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 4.sp, top: 4.sp, bottom: 4.sp, right: 4.sp),
                                            child: Column(
                                              children: [
                                                Center(child: Text('File SIM A', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700,),)),
                                                SizedBox(height: 5.sp,),
                                                if(simA == '-')
                                                  const Center(child: Text('File SIM A belum diupload ke dalam sistem')),
                                                if(simA != '-')
                                                  Image.memory(base64Decode(ktp)),
                                                SizedBox(height: 5.sp,),
                                                ElevatedButton(
                                                  onPressed: (){
                                                    simAFile();
                                                    // Get.to(EmployeeDetailTwo(widget.employeeID));
                                                  }, 
                                                  style: ElevatedButton.styleFrom(
                                                    minimumSize: Size(50.w, 55.h),
                                                    foregroundColor: const Color(0xFFFFFFFF),
                                                    backgroundColor: const Color(0xff4ec3fc),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                  child: const Text('Upload SIM A')
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 7.sp,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 100.w) / 2,
                                        child: Card(
                                          shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(12))),
                                          color: Colors.white,
                                          shadowColor: Colors.black,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 4.sp, top: 4.sp, bottom: 4.sp, right: 4.sp),
                                            child: Column(
                                              children: [
                                                Center(child: Text('File SIM C', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700,),)),
                                                SizedBox(height: 5.sp,),
                                                if(simC == '-')
                                                  const Center(child: Text('File SIM C belum diupload ke dalam sistem')),
                                                if(simC != '-')
                                                  Image.memory(base64Decode(simC)),
                                                SizedBox(height: 5.sp,),
                                                ElevatedButton(
                                                  onPressed: (){
                                                    simCFile();
                                                    // Get.to(EmployeeDetailTwo(widget.employeeID));
                                                  }, 
                                                  style: ElevatedButton.styleFrom(
                                                    minimumSize: Size(50.w, 55.h),
                                                    foregroundColor: const Color(0xFFFFFFFF),
                                                    backgroundColor: const Color(0xff4ec3fc),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                  child: const Text('Upload SIM C')
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 100.w) / 2,
                                        child: Card(
                                          shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(12))),
                                          color: Colors.white,
                                          shadowColor: Colors.black,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 4.sp, top: 4.sp, bottom: 4.sp, right: 4.sp),
                                            child: Column(
                                              children: [
                                                Center(child: Text('NPWP', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700,),)),
                                                SizedBox(height: 5.sp,),
                                                if(npwp == '-')
                                                  const Center(child: Text('File NPWP belum diupload ke dalam sistem')),
                                                if(npwp != '-')
                                                  Image.memory(base64Decode(npwp)),
                                                SizedBox(height: 5.sp,),
                                                ElevatedButton(
                                                  onPressed: (){
                                                    // Get.to(EmployeeDetailTwo(widget.employeeID));
                                                  }, 
                                                  style: ElevatedButton.styleFrom(
                                                    minimumSize: Size(50.w, 55.h),
                                                    foregroundColor: const Color(0xFFFFFFFF),
                                                    backgroundColor: const Color(0xff4ec3fc),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                  child: const Text('Upload NPWP')
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ]
                        ),
                      )
                    ],
                  ),
                )
              ),
            ],
          )
        ),
      ),
    );
  }
}