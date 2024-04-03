import 'dart:convert';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/EmployeeList.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/UpdateData/UpdateDataFive.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class UpdateDataFour extends StatefulWidget {
  final String employeeId;
  const UpdateDataFour({super.key, required this.employeeId});

  @override
  State<UpdateDataFour> createState() => _UpdateDataFourState();
}

class _UpdateDataFourState extends State<UpdateDataFour> {
  String? selectedEducation;
  String? selectedEducation2;
  String? selectedEducation3;
  String? selectedEducation4;
  String? selectedEducation5;
  List<Map<String, String>> educationList = [];
  bool isLoading = false;
  DateTime? dateTimeDari1;
  DateTime? dateTimeDari2;
  DateTime? dateTimeDari3;
  DateTime? dateTimeDari4;
  DateTime? dateTimeDari5;
  DateTime? dateTimeSampai1;
  DateTime? dateTimeSampai2;
  DateTime? dateTimeSampai3;
  DateTime? dateTimeSampai4;
  DateTime? dateTimeSampai5;

  TextEditingController txtNamaSekolah1 = TextEditingController();
  TextEditingController txtJurusan1 = TextEditingController();
  TextEditingController txtNilai1 = TextEditingController();
  TextEditingController txtDeskripsi1 = TextEditingController();

  TextEditingController txtNamaSekolah2 = TextEditingController();
  TextEditingController txtJurusan2 = TextEditingController();
  TextEditingController txtNilai2 = TextEditingController();
  TextEditingController txtDeskripsi2 = TextEditingController();

  TextEditingController txtNamaSekolah3 = TextEditingController();
  TextEditingController txtJurusan3 = TextEditingController();
  TextEditingController txtNilai3 = TextEditingController();
  TextEditingController txtDeskripsi3 = TextEditingController();

  TextEditingController txtNamaSekolah4 = TextEditingController();
  TextEditingController txtJurusan4 = TextEditingController();
  TextEditingController txtNilai4 = TextEditingController();
  TextEditingController txtDeskripsi4 = TextEditingController();

  TextEditingController txtNamaSekolah5 = TextEditingController();
  TextEditingController txtJurusan5 = TextEditingController();
  TextEditingController txtNilai5 = TextEditingController();
  TextEditingController txtDeskripsi5 = TextEditingController();

  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  List<dynamic> profileData = [];

  @override
  void initState() {
    super.initState();
    fetchEducationList();
    fetchData();
    fetchDetailData();
  }

  Future<void> insertEmployee() async {
    try{
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/updateemployee/updatefour.php';

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "education_type_1" : selectedEducation,
          "education_name_1" : txtNamaSekolah1.text,
          "education_major_1" : txtJurusan1.text,
          "education_grade_1" : txtNilai1.text,
          "education_start_1" : dateTimeDari1.toString(),
          "education_end_1" : dateTimeSampai1.toString(),
          "education_desc_1" : txtDeskripsi1.text,

          "education_type_2" : selectedEducation2,
          "education_name_2" : txtNamaSekolah2.text,
          "education_major_2" : txtJurusan2.text,
          "education_grade_2" : txtNilai2.text,
          "education_start_2" : dateTimeDari2.toString(),
          "education_end_2" : dateTimeSampai2.toString(),
          "education_desc_2" : txtDeskripsi2.text,

          "education_type_3" : selectedEducation3,
          "education_name_3" : txtNamaSekolah3.text,
          "education_major_3" : txtJurusan3.text,
          "education_grade_3" : txtNilai3.text,
          "education_start_3" : dateTimeDari3.toString(),
          "education_end_3" : dateTimeSampai3.toString(),
          "education_desc_3" : txtDeskripsi3.text,

          "education_type_4" : selectedEducation4,
          "education_name_4" : txtNamaSekolah4.text,
          "education_major_4" : txtJurusan4.text,
          "education_grade_4" : txtNilai4.text,
          "education_start_4" : dateTimeDari4.toString(),
          "education_end_4" : dateTimeSampai4.toString(),
          "education_desc_4" : txtDeskripsi4.text,

          "education_type_5" : selectedEducation5,
          "education_name_5" : txtNamaSekolah5.text,
          "education_major_5" : txtJurusan5.text,
          "education_grade_5" : txtNilai5.text,
          "education_start_5" : dateTimeDari5.toString(),
          "education_end_5" : dateTimeSampai5.toString(),
          "education_desc_5" : txtDeskripsi5.text,

          "id" : widget.employeeId
        }
      );

      if (response.statusCode == 200) {
        Get.to(UpdateDataFive(employeeId: widget.employeeId,));
      } else {
        isLoading = false;
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

    } catch (e){
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

  Future<void> fetchDetailData() async {
    try{
      isLoading = true;

      String apiUrlSix = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployee.php?action=6&employee_id=${widget.employeeId}';
      var responseSix = await http.get(Uri.parse(apiUrlSix));

      if (responseSix.statusCode == 200) {
        Map<String, dynamic> responseDataSix = json.decode(responseSix.body);
        List<dynamic> dataSix = responseDataSix['Data'];

        setState(() {
          txtNamaSekolah1.text = dataSix.isNotEmpty ? dataSix.first['emp_name'] ?? '-' : '-';
          txtJurusan1.text = dataSix.isNotEmpty ? dataSix.first['emp_major'] ?? '-' : '-';
          txtNilai1.text = dataSix.isNotEmpty ? dataSix.first['emp_grade'] ?? '-' : '-';
          txtDeskripsi1.text = dataSix.isNotEmpty ? dataSix.first['emp_desc'] ?? '-' : '-';
        });
      } else {
        print('Failed to load data: ${responseSix.statusCode}');
      }

      String apiUrlSeven = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployee.php?action=7&employee_id=${widget.employeeId}';
      var responseSeven = await http.get(Uri.parse(apiUrlSeven));

      if (responseSeven.statusCode == 200) {
        Map<String, dynamic> responseDataSeven = json.decode(responseSeven.body);
        List<dynamic> dataSeven = responseDataSeven['Data'];

        setState(() {
          txtNamaSekolah2.text = dataSeven.isNotEmpty ? dataSeven.first['emp_name'] ?? '-' : '-';
          txtJurusan2.text = dataSeven.isNotEmpty ? dataSeven.first['emp_major'] ?? '-' : '-';
          txtNilai2.text = dataSeven.isNotEmpty ? dataSeven.first['emp_grade'] ?? '-' : '-';
          txtDeskripsi2.text = dataSeven.isNotEmpty ? dataSeven.first['emp_desc'] ?? '-' : '-';
        });
      } else {
        print('Failed to load data: ${responseSeven.statusCode}');
      }

      String apiUrlEight = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployee.php?action=8&employee_id=${widget.employeeId}';
      var responseEight = await http.get(Uri.parse(apiUrlEight));

      if (responseEight.statusCode == 200) {
        Map<String, dynamic> responseDataEight = json.decode(responseEight.body);
        List<dynamic> dataEight = responseDataEight['Data'];

        setState(() {
          txtNamaSekolah3.text = dataEight.isNotEmpty ? dataEight.first['emp_name'] ?? '-' : '-';
          txtJurusan3.text = dataEight.isNotEmpty ? dataEight.first['emp_major'] ?? '-' : '-';
          txtNilai3.text = dataEight.isNotEmpty ? dataEight.first['emp_grade'] ?? '-' : '-';
          txtDeskripsi3.text = dataEight.isNotEmpty ? dataEight.first['emp_desc'] ?? '-' : '-';
        });
      } else {
        print('Failed to load data: ${responseEight.statusCode}');
      }

      String apiUrlNine = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployee.php?action=9&employee_id=${widget.employeeId}';
      var responseNine = await http.get(Uri.parse(apiUrlNine));

      if (responseNine.statusCode == 200) {
        Map<String, dynamic> responseDataNine = json.decode(responseNine.body);
        List<dynamic> dataNine = responseDataNine['Data'];

        setState(() {
          txtNamaSekolah4.text = dataNine.isNotEmpty ? dataNine.first['emp_name'] ?? '-' : '-';
          txtJurusan4.text = dataNine.isNotEmpty ? dataNine.first['emp_major'] ?? '-' : '-';
          txtNilai4.text = dataNine.isNotEmpty ? dataNine.first['emp_grade'] ?? '-' : '-';
          txtDeskripsi4.text = dataNine.isNotEmpty ? dataNine.first['emp_desc'] ?? '-' : '-';
        });
      } else {
        print('Failed to load data: ${responseNine.statusCode}');
      }

      String apiUrlTen = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployee.php?action=10&employee_id=${widget.employeeId}';
      var responseTen = await http.get(Uri.parse(apiUrlTen));

      if (responseTen.statusCode == 200) {
        Map<String, dynamic> responseDataTen = json.decode(responseTen.body);
        List<dynamic> dataTen = responseDataTen['Data'];

        setState(() {
          txtNamaSekolah5.text = dataTen.isNotEmpty ? dataTen.first['emp_name'] ?? '-' : '-';
          txtJurusan5.text = dataTen.isNotEmpty ? dataTen.first['emp_major'] ?? '-' : '-';
          txtNilai5.text = dataTen.isNotEmpty ? dataTen.first['emp_grade'] ?? '-' : '-';
          txtDeskripsi5.text = dataTen.isNotEmpty ? dataTen.first['emp_desc'] ?? '-' : '-';
        });
      } else {
        print('Failed to load data: ${responseTen.statusCode}');
      }

    } catch (e){
      print('Error at fetching detail one data : $e');
      
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

      //String employeeId = storage.read('employee_id'); // replace with your logic to get employee ID

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
      isLoading = false;
      print('Exception during API call: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchEducationList() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/geteducationlist.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        final educationData = (data['Data'] as List)
            .map((education) => Map<String, String>.from({
                  'education_id': education['education_id'],
                  'education_name': education['education_name'],
                }))
            .toList();

        setState(() {
          educationList = educationData;
          if (educationList.isNotEmpty) {
            selectedEducation = educationList[0]['education_id'];
            selectedEducation2 = educationList[0]['education_id'];
            selectedEducation3 = educationList[0]['education_id'];
            selectedEducation4 = educationList[0]['education_id'];
            selectedEducation5 = educationList[0]['education_id'];
          }
        });
      } else {
        // Handle API error
        print('Failed to fetch education list');
      }
    } else {
      // Handle HTTP error
      print('Failed to fetch data');
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
                      Text('Pendidikan Pertama',style: TextStyle(fontSize: 5.sp,fontWeight: FontWeight.w700,)),
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
                                Text("Tingkat Pendidikan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DropdownButtonFormField<String>(
                                  value: selectedEducation,
                                  onChanged: (String? newValue) {
                                    selectedEducation = newValue;
                                  },
                                  items: educationList.map<DropdownMenuItem<String>>(
                                    (Map<String, String> education) {
                                      return DropdownMenuItem<String>(
                                        value: education['education_id']!,
                                        child: Text(education['education_name']!),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nama Sekolah",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtNamaSekolah1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama sekolah anda'
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
                                Text("Jurusan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtJurusan1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan jurusan anda'
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
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Tahun Masuk",
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
                                      });
                                    },
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
                                Text("Tahun Selesai",
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
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nilai",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtNilai1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nilai anda'
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
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Deskripsi Pendidikan",
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
                                    hintText: 'Masukkan deskripsi pendidikan anda'
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
                      Text('Pendidikan Kedua',style: TextStyle(fontSize: 5.sp,fontWeight: FontWeight.w700,)),
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
                                Text("Tingkat Pendidikan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DropdownButtonFormField<String>(
                                  value: selectedEducation2,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedEducation2 = newValue;
                                    });
                                  },
                                  items: educationList.map<DropdownMenuItem<String>>(
                                    (Map<String, String> education) {
                                      return DropdownMenuItem<String>(
                                        value: education['education_id']!,
                                        child: Text(education['education_name']!),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nama Sekolah",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtNamaSekolah2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama sekolah anda'
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
                                Text("Jurusan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtJurusan2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan jurusan anda'
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
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Tahun Masuk",
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
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Tahun Selesai",
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
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nilai",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtNilai2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nilai anda'
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
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Deskripsi Pendidikan",
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
                                    hintText: 'Masukkan deskripsi pendidikan anda'
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
                      Text('Pendidikan Ketiga',style: TextStyle(fontSize: 5.sp,fontWeight: FontWeight.w700,)),
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
                                Text("Tingkat Pendidikan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DropdownButtonFormField<String>(
                                  value: selectedEducation3,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedEducation3 = newValue;
                                    });
                                  },
                                  items: educationList.map<DropdownMenuItem<String>>(
                                    (Map<String, String> education) {
                                      return DropdownMenuItem<String>(
                                        value: education['education_id']!,
                                        child: Text(education['education_name']!),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nama Sekolah",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtNamaSekolah3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama sekolah anda'
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
                                Text("Jurusan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtJurusan3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan jurusan anda'
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
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Tahun Masuk",
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
                                      });
                                    },
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
                                Text("Tahun Selesai",
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
                                      });
                                    },
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
                                Text("Nilai",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtNilai3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nilai anda'
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
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Deskripsi Pendidikan",
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
                                    hintText: 'Masukkan deksripsi pendidikan anda'
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
                      Text('Pendidikan Keempat',style: TextStyle(fontSize: 5.sp,fontWeight: FontWeight.w700,)),
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
                                Text("Tingkat Pendidikan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DropdownButtonFormField<String>(
                                  value: selectedEducation4,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedEducation4 = newValue;
                                    });
                                  },
                                  items: educationList.map<DropdownMenuItem<String>>(
                                    (Map<String, String> education) {
                                      return DropdownMenuItem<String>(
                                        value: education['education_id']!,
                                        child: Text(education['education_name']!),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nama Sekolah",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtNamaSekolah4,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama sekolah anda'
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
                                Text("Jurusan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtJurusan4,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan jurusan anda'
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
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Tahun Masuk",
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
                                        dateTimeDari4 = DateFormat('yyyy-MM-dd').parse(value);
                                      });
                                    },
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
                                Text("Tahun Selesai",
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
                                        dateTimeSampai4 = DateFormat('yyyy-MM-dd').parse(value);
                                      });
                                    },
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
                                Text("Nilai",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtNilai4,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nilai anda'
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
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Deskripsi Pendidikan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtDeskripsi4,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan deskripsi pendidikan anda'
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
                      Text('Pendidikan Kelima',style: TextStyle(fontSize: 5.sp,fontWeight: FontWeight.w700,)),
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
                                Text("Tingkat Pendidikan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DropdownButtonFormField<String>(
                                  value: selectedEducation5,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedEducation5 = newValue;
                                    });
                                  },
                                  items: educationList.map<DropdownMenuItem<String>>(
                                    (Map<String, String> education) {
                                      return DropdownMenuItem<String>(
                                        value: education['education_id']!,
                                        child: Text(education['education_name']!),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nama Sekolah",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtNamaSekolah5,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama sekolah anda'
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
                                Text("Jurusan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtJurusan5,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan jurusan anda'
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
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Tahun Masuk",
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
                                        dateTimeDari5 = DateFormat('yyyy-MM-dd').parse(value);
                                      });
                                    },
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
                                Text("Tahun Selesai",
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
                                        dateTimeSampai5 = DateFormat('yyyy-MM-dd').parse(value);
                                      });
                                    },
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
                                Text("Nilai",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: txtNilai5,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nilai anda'
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
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Deskripsi Pendidikan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtDeskripsi5,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan deskripsi pendidikan anda'
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                  onPressed: (){
                                    Get.back();
                                  }, 
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    alignment: Alignment.center,
                                    minimumSize: Size(60.w, 55.h),
                                    foregroundColor: const Color(0xFFFFFFFF),
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('Kembali')
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: (){
                                    insertEmployee();
                                  }, 
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    alignment: Alignment.center,
                                    minimumSize: Size(60.w, 55.h),
                                    foregroundColor: const Color(0xFFFFFFFF),
                                    backgroundColor: const Color(0xff4ec3fc),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('Update & Berikutnya')
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10.sp,),
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