// ignore_for_file: prefer_const_constructors_in_immutables, file_names, unnecessary_string_interpolations, non_constant_identifier_names, avoid_print, use_build_context_synchronously

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:hr_systems_web/web-version/full-access/leave/ShowAllMyPermission.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../index.dart';

class CutiPage extends StatefulWidget {
  const CutiPage({super.key});

  @override
  State<CutiPage> createState() => _CutiPageState();
}

class _CutiPageState extends State<CutiPage> {

  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String employeeId = '';
  String departmentName = '';
  String positionName = '';
  String trimmedCompanyAddress = '';
  TextEditingController txtNamaLengkap = TextEditingController();
  TextEditingController txtNIK = TextEditingController();
  TextEditingController txtDepartemen = TextEditingController();
  TextEditingController txtJabatan = TextEditingController();
  List<Map<String, String>> employees = [];
  String? selectedEmployeeId;
  DateTime? TanggalMulaiCuti;
  DateTime? TanggalAkhirCuti;
  TextEditingController cutiPhone = TextEditingController();
  TextEditingController txtAlasan = TextEditingController();
  int? sisaCuti;
  TextEditingController txtSisaCuti = TextEditingController();
  bool isLoading = false;
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDataforFilled();
    fetchEmployeeList();
    fetchAngkaCuti();
  }

  Future<void> fetchAngkaCuti() async {
    String employeeId = storage.read('employee_id').toString();

    try {
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/getangkacutibyid.php?employee_id=$employeeId';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('Data') && responseData['Data'] is List && (responseData['Data'] as List).isNotEmpty) {

          Map<String, dynamic> data = (responseData['Data'] as List).first;
          if (data.containsKey('leave_count') && data['leave_count'] != null) {

            setState(() {
              sisaCuti = int.parse(data['leave_count'].toString());
            });
            
          } else {
            print('leave_count is null or not found in the response data.');
          }
        } else {
          print('Data is null or not found in the response data.');
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchData() async {
    try {
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/account/getprofileforallpage.php';
      String employeeId = storage.read('employee_id').toString(); // replace with your logic to get employee ID

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
          txtNamaLengkap.text = employeeName;
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

  Future<void> fetchDataforFilled() async {
    try {
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/getdataforrequestor.php';

      // Replace 'employee_id' with the actual employee ID from storage
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

        setState(() {
          employeeName = data['Data']['employee_name'] as String;
          employeeId = data['Data']['employee_id'] as String;
          departmentName = data['Data']['department_name'] as String;
          positionName = data['Data']['position_name'] as String;

          txtNIK.text = employeeId;
          txtDepartemen.text = departmentName;
          txtJabatan.text = positionName;
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    } finally {
      isLoading = false;
    }
  }

Future<void> fetchEmployeeList() async {
  String employeeId = storage.read('employee_id').toString();

  try {
    isLoading = true;
    final response = await http.get(Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/getemployeeexceptme.php?employee_id=$employeeId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Check if the response contains the expected key 'Data'
      if (responseData.containsKey('Data')) {
        final List<dynamic> employeeData = responseData['Data'] ?? [];

        setState(() {
          employees = employeeData
              .map<Map<String, String>>((dynamic employee) =>
                  Map<String, String>.from(employee))
              .toList();
        });
      } else {
        print('Expected key "Data" not found in the response data.');
      }
    } else {
      print('Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    isLoading = false;
  }
}

  Future<void> insertCuti() async {
    try{
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/insertpermission.php';

      String employeeId = storage.read('employee_id').toString(); // replace with your logic to get employee ID
      DateTime dateNow = DateTime.now();

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "action" : "3",
          "date_now": dateNow.toString(),
          "employee_id": employeeId,
          "cuti_phone": cutiPhone.text,
          "start_cuti": TanggalMulaiCuti.toString(),
          "end_cuti": TanggalAkhirCuti.toString(),
          "pengganti_cuti": selectedEmployeeId,
          "created_by": employeeId,
          "created_dt": dateNow.toString(),
          "permission_reason": txtAlasan.text
        }
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Sukses"),
              content: const Text("Permohonan cuti tahunan anda telah berhasil diajukan"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.to(FullIndexWeb(employeeId));
                  }, 
                  child: const Text("Kembali ke halaman utama")
                ),
                TextButton(
                  onPressed: () {
                    Get.to(const ShowAllMyPermission());
                  }, 
                  child: const Text("Lihat detail izin")
                )
              ],
            );
          }
        );
        // Add any additional logic or UI updates after successful insertion
      } else if (response.statusCode == 206){
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Gagal"),
              content: const Text("Jatah cuti anda saat ini tidak mencukupi. Silahkan periksa kembali jatah cuti anda !!"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.to(FullIndexWeb(employeeId));
                  }, 
                  child: const Text("Kembali ke halaman utama")
                ),
              ],
            );
          }
        );
      } else {
        Get.snackbar('Gagal', '${response.statusCode}, ${response.body}');
        // Handle the error or show an error message to the user
      }



    } catch (e){
      Get.snackbar('Gagal', '$e');
      // Handle exceptions or show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    var employeeId = storage.read('employee_id');
    var photo = storage.read('photo');
    var positionId = storage.read('position_id');
    TextEditingController sisaCutiController = TextEditingController(text: sisaCuti?.toString() ?? '');

    return SafeArea(
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
                      NamaPerusahaanMenu(companyName: companyName, companyAddress: trimmedCompanyAddress),
                      SizedBox(height: 10.sp,),
                      const HalamanUtamaMenu(),
                      SizedBox(height: 5.sp,),
                      BerandaActive(employeeId: employeeId.toString()),
                      SizedBox(height: 5.sp,),
                      KaryawanNonActive(employeeId: employeeId.toString()),
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
              //content
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
                      Center(
                        child: Text(
                          "Formulir Pengajuan Cuti Karyawan",
                          style: TextStyle(
                            fontSize: 7.sp,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                      SizedBox(height: 10.sp,),
                      Text(
                        "Data Karyawan",
                        style: TextStyle(
                          fontSize: 6.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(0, 0, 0, 1)
                        ),
                      ),
                      SizedBox(height: 6.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 210.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nama Lengkap",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(116, 116, 116, 1)
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                                if(isLoading)
                                  const CircularProgressIndicator()
                                else
                                  Text(txtNamaLengkap.text)
                              ],
                            )
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 210.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "NIK",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(116, 116, 116, 1)
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                                if(isLoading)
                                  const CircularProgressIndicator()
                                else
                                  Text(txtNIK.text)
                              ],
                            )
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 210.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Departemen",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(116, 116, 116, 1)
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                                Text(txtDepartemen.text)
                              ],
                            )
                          ),
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 210.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Jabatan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(116, 116, 116, 1)
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                                Text(txtJabatan.text)
                              ],
                            )
                          ),
                        ],
                      ),
                      SizedBox(height: 10.sp,),
                      Text(
                        "Keterangan Cuti",
                        style: TextStyle(
                          fontSize: 6.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(0, 0, 0, 1)
                        ),
                      ),
                      SizedBox(height: 6.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 210.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tanggal mulai cuti",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(116, 116, 116, 1)
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                                //DateTime
                                DateTimePicker(
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                  initialDate: DateTime.now(),
                                  dateMask: 'd MMM yyyy',
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Pilih tanggal mulai cuti'
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      TanggalMulaiCuti = DateFormat('yyyy-MM-dd').parse(value);
                                      //selectedDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(txtTanggal);
                                    });
                                  },
                                )
                              ],
                            )
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 210.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tanggal akhir cuti",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(116, 116, 116, 1)
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                                DateTimePicker(
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                  initialDate: DateTime.now(),
                                  dateMask: 'd MMM yyyy',
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Pilih tanggal akhir cuti'
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      TanggalAkhirCuti = DateFormat('yyyy-MM-dd').parse(value);
                                      //selectedDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(txtTanggal);
                                    });
                                  },
                                )
                              ],
                            )
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 210.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sisa cuti berjalan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(116, 116, 116, 1)
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                                Text(sisaCutiController.text)
                              ],
                            )
                          ),
                        ],
                      ),
                      SizedBox(height: 6.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 210.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nomor yang bisa dihubungi",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(116, 116, 116, 1)
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: cutiPhone,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nomor yang bisa dihubungi'
                                  ),
                                )
                              ],
                            )
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 185.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Keterangan atau alasan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(116, 116, 116, 1)
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtAlasan,
                                  maxLines: 3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan keterangan atau alasan anda'
                                  ),
                                )
                              ],
                            )
                          ),
                        ],
                      ),
                      SizedBox(height: 10.sp,),
                      Text(
                        "Selama Cuti Tugas Digantikan Oleh",
                        style: TextStyle(
                          fontSize: 6.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(0, 0, 0, 1)
                        ),
                      ),
                      SizedBox(height: 6.sp,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                                  "Karyawan Pengganti",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(116, 116, 116, 1)
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 280.w),
                            child: DropdownButtonFormField<String>(
                              value: selectedEmployeeId,
                              hint: const Text('Pilih karyawan pengganti'),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedEmployeeId = newValue;
                                });
                              },
                              items: employees.map((Map<String, String> employee) {
                                final String? id = employee['id'];
                                final String? employeeName = employee['employee_name'];
                            
                                return DropdownMenuItem<String>(
                                  value: id,
                                  child: Text(employeeName ?? 'Unknown'),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              print(TanggalMulaiCuti.toString());
                              if(TanggalMulaiCuti == null){
                                dialogError('Tanggal mulai cuti tidak dapat kosong dan harus diisi !!');
                              } else if (TanggalAkhirCuti == null){
                                dialogError('Tanggal akhir cuti tidak dapat kosong dan harus diisi !!');
                              } else if (cutiPhone.text == ''){
                                dialogError('Nomor yang bisa dihubungi tidak dapat kosong dan harus diisi !!');
                              } else if (txtAlasan.text == ''){
                                dialogError('Keterangan atau alasan tidak dapat kosong dan harus diisi !!');
                              } else if (selectedEmployeeId == null){
                                dialogError('Karyawan pengganti harus diisi !!');
                              } else {
                                insertCuti();
                              }
                            }, 
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(40.w, 55.h),
                              foregroundColor: const Color(0xFFFFFFFF),
                              backgroundColor: const Color(0xff4ec3fc),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Kumpulkan')
                          ),
                        ],
                      ),
                      SizedBox(height: 10.sp,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future <void> dialogError (String message) async {
    return showDialog(
      context: context, 
      builder: (_){
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: (){
                Get.back();
              }, 
              child: Text('Kembali')
            )
          ],
        );
      }
    );
  }
}