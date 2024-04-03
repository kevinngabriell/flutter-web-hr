// ignore_for_file: file_names, avoid_print, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Add%20New%20Employee/AddNewEmployeeFour.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/EmployeeList.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:intl/intl.dart'; 
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddNewEmployeeThree extends StatefulWidget {
  const AddNewEmployeeThree({super.key});

  @override
  State<AddNewEmployeeThree> createState() => _AddNewEmployeeThreeState();
}

class _AddNewEmployeeThreeState extends State<AddNewEmployeeThree> {
  DateTime? dateTimeDari1;
  DateTime? dateTimeDari2;
  DateTime? dateTimeDari3;
  DateTime? dateTimeSampai1;
  DateTime? dateTimeSampai2;
  DateTime? dateTimeSampai3;
  bool isLoading = false;
  TextEditingController txtNamaPerusahaan1 = TextEditingController();
  TextEditingController txtJenisUsaha1 = TextEditingController();
  TextEditingController txtPosisi1 = TextEditingController();
  TextEditingController txtAlamat1 = TextEditingController();
  TextEditingController txtAtasan1 = TextEditingController();
  TextEditingController txtGaji1 = TextEditingController();
  TextEditingController txtDeskripsi1 = TextEditingController();
  TextEditingController txtAlasan1 = TextEditingController();
  TextEditingController txtNamaPerusahaan2 = TextEditingController();
  TextEditingController txtJenisUsaha2 = TextEditingController();
  TextEditingController txtPosisi2 = TextEditingController();
  TextEditingController txtAlamat2 = TextEditingController();
  TextEditingController txtAtasan2 = TextEditingController();
  TextEditingController txtGaji2 = TextEditingController();
  TextEditingController txtDeskripsi2 = TextEditingController();
  TextEditingController txtAlasan2 = TextEditingController();
  TextEditingController txtNamaPerusahaan3 = TextEditingController();
  TextEditingController txtJenisUsaha3 = TextEditingController();
  TextEditingController txtPosisi3 = TextEditingController();
  TextEditingController txtAlamat3 = TextEditingController();
  TextEditingController txtAtasan3 = TextEditingController();
  TextEditingController txtGaji3 = TextEditingController();
  TextEditingController txtDeskripsi3 = TextEditingController();
  TextEditingController txtAlasan3 = TextEditingController();
  String id = '';

  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  List<dynamic> profileData = [];
  @override
  void initState() {
    super.initState();
    fetchLastID();
    fetchData();
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
      isLoading = false;
      print('Exception during API call: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchLastID() async {
  const apiUrl =
      'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getlastidforinput.php';

  try {
    isLoading = true;
    // Making GET request
    final response = await http.get(Uri.parse(apiUrl));

    // Checking if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parsing the response body
      final Map<String, dynamic> responseBody = json.decode(response.body);

      // Extracting the 'Data' array from the response
      final List<dynamic> data = responseBody['Data'];

      // Accessing the first object in the 'Data' array
      final Map<String, dynamic> firstDataObject = data.isNotEmpty ? data[0] : {};

      // Extracting the 'id' value from the first object
      id = firstDataObject['id'];

      // Now you can use the 'id' variable as needed
      print('Last ID: $id');
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    isLoading = false;
    print('Error: $e');
  } finally {
    isLoading = false;
  }
}
  
  Future<void> insertEmployee() async {
    try{
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/insertemployee/insertthree.php';

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "id": id,
          "company_name_1" : txtNamaPerusahaan1.text,
          "company_position_1" : txtPosisi1.text,
          "company_address_1" : txtAlamat1.text,
          "company_type_1" : txtJenisUsaha1.text,
          "company_start_1" : dateTimeDari1.toString(),
          "company_end_1" : dateTimeSampai1.toString(),
          "company_leader_1" : txtAtasan1.text,
          "company_salary_1" : txtGaji1.text,
          "company_jobdesc_1" : txtDeskripsi1.text,
          "company_leave_1" : txtAlasan1.text,

          "company_name_2" : txtNamaPerusahaan2.text,
          "company_position_2" : txtPosisi2.text,
          "company_address_2" : txtAlamat2.text,
          "company_type_2" : txtJenisUsaha2.text,
          "company_start_2" : dateTimeDari2.toString(),
          "company_end_2" : dateTimeSampai2.toString(),
          "company_leader_2" : txtAtasan2.text,
          "company_salary_2" : txtGaji2.text,
          "company_jobdesc_2" : txtDeskripsi2.text,
          "company_leave_2" : txtAlasan2.text,

          "company_name_3" : txtNamaPerusahaan3.text,
          "company_position_3" : txtPosisi3.text,
          "company_address_3" : txtAlamat3.text,
          "company_type_3" : txtJenisUsaha3.text,
          "company_start_3" : dateTimeDari3.toString(),
          "company_end_3" : dateTimeSampai3.toString(),
          "company_leader_3" : txtAtasan3.text,
          "company_salary_3" : txtGaji3.text,
          "company_jobdesc_3" : txtDeskripsi3.text,
          "company_leave_3" : txtAlasan3.text,
        }
      );

      if (response.statusCode == 200) {
        Get.to(const AddNewEmployeeFour());
        // Add any additional logic or UI updates after successful insertion
      } else {
        showDialog(
          context: context, 
          builder: (_){
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Error dengan response ${response.body}'),
              actions: [
                TextButton(
                  onPressed: (){
                    Get.to(const EmployeeListPage());
                  }, 
                  child: const Text('Kembali')
                )
              ],
            );
          }
        );
        // Handle the error or show an error message to the user
      }

    } catch (e) {
      isLoading = false;
      showDialog(
          context: context, 
          builder: (_){
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Error dengan response $e'),
              actions: [
                TextButton(
                  onPressed: (){
                    Get.to(const EmployeeListPage());
                  }, 
                  child: const Text('Kembali')
                )
              ],
            );
          }
        );
    } finally {
      isLoading = false;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Access the GetStorage instance
    final storage = GetStorage();

    // Retrieve the stored employee_id
    var employeeId = storage.read('employee_id');
    var photo = storage.read('photo');
    var positionId = storage.read('position_id');

    return MaterialApp(
      title: "Tambah Karyawan - Informasi Pribadi",
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
                      LaporanNonActive(positionId: positionId),
                      SizedBox(height: 10.sp,),
                      const PengaturanMenu(),
                      SizedBox(height: 5.sp,),
                      const PengaturanNonActive(),
                      SizedBox(height: 5.sp,),
                      const StrukturNonActive(),
                      SizedBox(height: 5.sp,),
                      const Logout(),
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
                      Text('Perusahaan Pertama',style: TextStyle(fontSize: 5.sp,fontWeight: FontWeight.w700,)),
                      SizedBox(height: 5.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nama Perusahaan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtNamaPerusahaan1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama perusahaan'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Jenis Usaha",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtJenisUsaha1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan jenis usaha perusahaan sebelumnya'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Posisi",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtPosisi1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan posisi anda'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      //alamat
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Alamat",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtAlamat1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alamat perusahaan anda sebelumnya'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      //dari, sampai, atasan, gaji
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Dari",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DateTimePicker(
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    initialDate: DateTime.now(),
                                    dateMask: 'd MMM yyyy',
                                    onChanged: (value) {
                                      setState(() {
                                        dateTimeDari1 = DateFormat('yyyy-MM-dd').parse(value);
                                        //txtTanggal = value;
                                        //selectedDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(txtTanggal);
                                      });
                                    },
                                  )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Sampai",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DateTimePicker(
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    initialDate: DateTime.now(),
                                    dateMask: 'd MMM yyyy',
                                    onChanged: (value) {
                                      setState(() {
                                        dateTimeSampai1 = DateFormat('yyyy-MM-dd').parse(value);
                                        //txtTanggal = value;
                                        //selectedDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(txtTanggal);
                                      });
                                    },
                                  )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 245.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Atasan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtAtasan1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama atasan anda'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 210.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Gaji",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtGaji1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan gaji anda'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Dekripsi Pekerjaan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtDeskripsi1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan deskripsi pekerjaan anda sebelumnya'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Alasan Keluar",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtAlasan1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alasan keluar anda sebelumnya'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      const Divider(),
                      SizedBox(height: 7.sp,),
                      Text('Perusahaan Kedua',style: TextStyle(fontSize: 5.sp,fontWeight: FontWeight.w700,)),
                      SizedBox(height: 7.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nama Perusahaan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtNamaPerusahaan2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama perusahaan'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Jenis Usaha",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtJenisUsaha2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan jenis usaha perusahaan sebelumnya'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Posisi",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtPosisi2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan posisi anda'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      //alamat
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Alamat",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtAlamat2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alamat perusahaan anda sebelumnya'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      //dari, sampai, atasan, gaji
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Dari",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DateTimePicker(
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    initialDate: DateTime.now(),
                                    dateMask: 'd MMM yyyy',
                                    onChanged: (value) {
                                      setState(() {
                                        dateTimeDari2 = DateFormat('yyyy-MM-dd').parse(value);
                                      });
                                    },
                                  )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Sampai",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DateTimePicker(
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    initialDate: DateTime.now(),
                                    dateMask: 'd MMM yyyy',
                                    onChanged: (value) {
                                      setState(() {
                                        dateTimeSampai2 = DateFormat('yyyy-MM-dd').parse(value);
                                      });
                                    },
                                  )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 245.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Atasan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtAtasan2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama atasan anda'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 210.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Gaji",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtGaji2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan gaji anda'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Dekripsi Pekerjaan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtDeskripsi2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan deskripsi pekerjaan anda sebelumnya'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Alasan Keluar",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtAlasan2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alasan anda keluar'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      const Divider(),
                      SizedBox(height: 7.sp,),
                      Text('Perusahaan Ketiga',style: TextStyle(fontSize: 5.sp,fontWeight: FontWeight.w700,)),
                      SizedBox(height: 7.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nama Perusahaan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtNamaPerusahaan3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama perusahaan'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Jenis Usaha",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtJenisUsaha3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan jenis usaha perusahaan sebelumnya'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Posisi",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtPosisi3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan posisi anda'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      //alamat
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Alamat",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtAlamat3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alamat perusahaan anda sebelumnya'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      //dari, sampai, atasan, gaji
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Dari",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DateTimePicker(
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    initialDate: DateTime.now(),
                                    dateMask: 'd MMM yyyy',
                                    onChanged: (value) {
                                      setState(() {
                                        dateTimeDari3 = DateFormat('yyyy-MM-dd').parse(value);
                                        //txtTanggal = value;
                                        //selectedDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(txtTanggal);
                                      });
                                    },
                                  )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Sampai",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DateTimePicker(
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    initialDate: DateTime.now(),
                                    dateMask: 'd MMM yyyy',
                                    onChanged: (value) {
                                      setState(() {
                                        dateTimeSampai3 = DateFormat('yyyy-MM-dd').parse(value);
                                        //txtTanggal = value;
                                        //selectedDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(txtTanggal);
                                      });
                                    },
                                  )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 245.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Atasan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtAtasan3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama atasan anda'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 210.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Gaji",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtGaji3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan gaji anda sebelumnya'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Dekripsi Pekerjaan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtDeskripsi3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan deskripsi pekerjaan anda sebelumnya'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Alasan Keluar",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtAlasan3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alasan anda keluar'
                                  ),
                                  readOnly: false,
                                )
                              ],
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
                          insertEmployee();
                          // Get.to(const AddNewEmployeeFour());
                        }, 
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(60.w, 55.h),
                          foregroundColor: const Color(0xFFFFFFFF),
                          backgroundColor: const Color(0xff4ec3fc),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Berikutnya')
                      ),
                        ],
                      ),
                      SizedBox(height: 40.sp,),
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