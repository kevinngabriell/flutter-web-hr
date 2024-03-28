// ignore_for_file: prefer_const_constructors_in_immutables, file_names, unnecessary_null_comparison, non_constant_identifier_names, avoid_print, use_build_context_synchronously
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../index.dart';

class PulangAwalPage extends StatefulWidget {
  PulangAwalPage({super.key});

  @override
  State<PulangAwalPage> createState() => _PulangAwalPageState();
}

class _PulangAwalPageState extends State<PulangAwalPage> {
  TextEditingController txtNamaLengkap = TextEditingController();
  String namaLengkapText = '';
  TextEditingController txtNIK = TextEditingController();
  String nikText = '';
  TextEditingController txtAlasan = TextEditingController();
  String alasanText = '';
  TextEditingController txtDepartemen = TextEditingController();
  String departemenText = '';
  TextEditingController txtJabatan = TextEditingController();
  String jabatanText = '';
  TextEditingController txtJamAbsen = TextEditingController();
  //TextEditingController txtTanggal = TextEditingController();
  String txtTanggal = '';
  String txtWaktu = '';
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> employeeBirthday = [];

  DateTime? TanggalPulangAwal;
  String? JamAbsen;

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

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDataforFilled();
    fetchBirthday();
  }

  Future<void> fetchData() async {
    try {
      isLoading = true;
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
    setState(() {
      isLoading = true;
    });

    try {
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
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> insertPermission() async {
    try{
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/insertpermission.php';

      String employeeId = storage.read('employee_id').toString(); // replace with your logic to get employee ID
      DateTime dateNow = DateTime.now();

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "action" : "1",
          "id": employeeId,
          "permission_date": TanggalPulangAwal.toString(),
          "permission_reason": txtAlasan.text,
          "permission_time": JamAbsen.toString(),
          "date_now": dateNow.toString()
        }
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Sukses"),
              content: const Text("Permohonan izin anda telah berhasil diajukan"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.to(FullIndexWeb(employeeId));
                  }, 
                  child: const Text("Kembali ke halaman utama")
                ),
                TextButton(
                  onPressed: () {
                    //Get.to(EmployeeListPage());
                  }, 
                  child: const Text("Lihat detail izin")
                )
              ],
            );
          }
        );
        // Add any additional logic or UI updates after successful insertion
      }  else if (response.statusCode == 403){
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Gagal"),
              content: const Text("Anda tidak dapat mengajukan permohonan pulang awal selain dari pukul 13:00 hingga 17:00"),
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
        Get.snackbar('Gagal', response.body);
        // Handle the error or show an error message to the user
      }

    } catch (e){
      Get.snackbar('Gagal', '$e');
      print('Exception during API call: $e');
      // Handle exceptions or show an error message to the user
    } finally {
      isLoading = false;
    }
  } 

  Future<void> fetchBirthday() async{
    try{  
      String employeeId = storage.read('employee_id').toString();
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/notification/getlimitnotif.php?employee_id=$employeeId';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          employeeBirthday = List<Map<String, dynamic>>.from(data['Data']);
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
    // Access the GetStorage instance
    final storage = GetStorage();
    var employeeId = storage.read('employee_id');
    var positionId = storage.read('position_id');
    var photo = storage.read('photo');

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
                      SizedBox(height: 5.sp,),
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
                  padding: EdgeInsets.only(left: 7.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5.sp,),
                      NotificationnProfile(employeeName: employeeName, employeeAddress: employeeEmail, photo: photo),
                      SizedBox(height: 7.sp,),
                      Center(
                        child: Text(
                          "Formulir Tidak Melakukan Rekam Kepulangan",
                          style: TextStyle(
                            fontSize: 7.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color.fromRGBO(116, 116, 116, 1)
                          ),
                        ),
                      ),
                      SizedBox(height: 10.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 15.sp),
                            child: SizedBox(
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
                                    TextFormField(
                                      controller: txtNamaLengkap,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                                        hintText: 'Masukkan nama anda'
                                      ),
                                      readOnly: true,
                                    )
                                ],
                              )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 15.sp),
                            child: SizedBox(
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
                                    TextFormField(
                                      controller: txtNIK,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                                        hintText: 'Masukkan NIK anda'
                                      ),
                                      readOnly: true,
                                    )
                                ],
                              )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 15.sp),
                            child: SizedBox(
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
                                  TextFormField(
                                    controller: txtDepartemen,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan departemen anda'
                                    ),
                                    readOnly: true,
                                  )
                                ],
                              )
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 15.sp),
                            child: SizedBox(
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
                                  TextFormField(
                                    controller: txtJabatan,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan jabatan anda'
                                    ),
                                    readOnly: true,
                                  )
                                ],
                              )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 15.sp),
                            child: SizedBox(
                              width: (MediaQuery.of(context).size.width - 210.w) / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hari dan tanggal",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ), 
                                  SizedBox(height: 7.h,),
                                  DateTimePicker(
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now(),
                                    initialDate: DateTime.now(),
                                    dateMask: 'd MMM yyyy',
                                    onChanged: (value) {
                                      setState(() {
                                        TanggalPulangAwal = DateFormat('yyyy-MM-dd').parse(value);
                                      });
                                    },
                                  )
                                ],
                              )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 15.sp),
                            child: SizedBox(
                              width: (MediaQuery.of(context).size.width - 210.w) / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                  "Alasan",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 7.h,),
                                  TextFormField(
                                    controller: txtAlasan,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan alasan anda'
                                    ),
                                  )
                                ],
                              )
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 15.sp),
                            child: SizedBox(
                              width: (MediaQuery.of(context).size.width - 210.w) / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                  "Jam absen",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(116, 116, 116, 1)
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                                DateTimePicker(
                                  type: DateTimePickerType.time,
                                  onChanged: (value) {
                                    setState(() {
                                      JamAbsen = value.toString();
                                    });
                                  },
                                )
                                ],
                              )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 15.sp),
                            child: SizedBox(
                              width: (MediaQuery.of(context).size.width - 210.w) / 2,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  
                                ],
                              )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 15.sp),
                            child: SizedBox(
                              width: (MediaQuery.of(context).size.width - 210.w) / 2,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  
                                ],
                              )
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.sp,),
                      Padding(
                        padding: EdgeInsets.only(right: 15.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                namaLengkapText = txtNamaLengkap.text;
                                nikText = txtNIK.text;
                                departemenText = txtDepartemen.text;
                                jabatanText = txtDepartemen.text;
                                alasanText = txtAlasan.text;
                                insertPermission();
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
                      )
                      
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

}