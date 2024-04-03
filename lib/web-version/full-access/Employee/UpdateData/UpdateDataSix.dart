import 'dart:convert';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/EmployeeList.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class UpdateDataSix extends StatefulWidget {
  final String employeeID;
  const UpdateDataSix({super.key, required this.employeeID});

  @override
  State<UpdateDataSix> createState() => _UpdateDataSixState();
}

class _UpdateDataSixState extends State<UpdateDataSix> {
  bool isLoading = false;
  String? selectedFamily;
  String? selectedEducation;
  TextEditingController txtNamaKeluarga1 = TextEditingController();
  TextEditingController txtPekerjaanKeluarga1 = TextEditingController();
  TextEditingController txtAlamatKeluarga1 = TextEditingController();
  TextEditingController txtTempatLahir1 = TextEditingController();
  DateTime? dateTimeTanggalLahir1;

  String? selectedFamily2;
  String? selectedEducation2;
  TextEditingController txtNamaKeluarga2 = TextEditingController();
  TextEditingController txtPekerjaanKeluarga2 = TextEditingController();
  TextEditingController txtAlamatKeluarga2 = TextEditingController();
  TextEditingController txtTempatLahir2 = TextEditingController();
  DateTime? dateTimeTanggalLahir2;

  String? selectedFamily3;
  String? selectedEducation3;
  TextEditingController txtNamaKeluarga3 = TextEditingController();
  TextEditingController txtPekerjaanKeluarga3 = TextEditingController();
  TextEditingController txtAlamatKeluarga3 = TextEditingController();
  TextEditingController txtTempatLahir3 = TextEditingController();
  DateTime? dateTimeTanggalLahir3;

  String? selectedFamily4;
  String? selectedEducation4;
  TextEditingController txtNamaKeluarga4 = TextEditingController();
  TextEditingController txtPekerjaanKeluarga4 = TextEditingController();
  TextEditingController txtAlamatKeluarga4 = TextEditingController();
  TextEditingController txtTempatLahir4 = TextEditingController();
  DateTime? dateTimeTanggalLahir4;

  String? selectedFamily5;
  String? selectedEducation5;
  TextEditingController txtNamaKeluarga5 = TextEditingController();
  TextEditingController txtPekerjaanKeluarga5 = TextEditingController();
  TextEditingController txtAlamatKeluarga5 = TextEditingController();
  TextEditingController txtTempatLahir5 = TextEditingController();
  DateTime? dateTimeTanggalLahir5;

  List<Map<String, String>> familyList = [];
  List<Map<String, String>> educationList = [];

  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  List<dynamic> profileData = [];
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    fetchFamilyList();
    fetchEducationList();
    fetchData();
    fetchDetailData();
  }

  Future<void> fetchDetailData() async {
    try{
      isLoading = true;

      String apiUrlSix = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployee.php?action=15&employee_id=${widget.employeeID}';
      var responseSix = await http.get(Uri.parse(apiUrlSix));

      if (responseSix.statusCode == 200) {
        Map<String, dynamic> responseDataSix = json.decode(responseSix.body);
        List<dynamic> dataSix = responseDataSix['Data'];

        setState(() {
          txtNamaKeluarga1.text = dataSix.first['family_name'] ?? '-';
          txtAlamatKeluarga1.text = dataSix.first['family_address'] ?? '-';
          txtTempatLahir1.text = dataSix.first['family_pob'] ?? '-';
          txtPekerjaanKeluarga1.text = dataSix.first['family_job'] ?? '-';
        });
      } else {
        print('Failed to load data: ${responseSix.statusCode}');
      }

      String apiUrlSeven = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployee.php?action=16&employee_id=${widget.employeeID}';
      var responseSeven = await http.get(Uri.parse(apiUrlSeven));

      if (responseSeven.statusCode == 200) {
        Map<String, dynamic> responseDataSeven = json.decode(responseSeven.body);
        List<dynamic> dataSeven = responseDataSeven['Data'];

        setState(() {
          txtNamaKeluarga2.text = dataSeven.first['family_name'] ?? '-';
          txtAlamatKeluarga2.text = dataSeven.first['family_address'] ?? '-';
          txtTempatLahir2.text  = dataSeven.first['family_pob'] ?? '-';
          txtPekerjaanKeluarga2.text = dataSeven.first['family_job'] ?? '-';
        });
      } else {
        print('Failed to load data: ${responseSeven.statusCode}');
      }

      String apiUrlEight = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployee.php?action=17&employee_id=${widget.employeeID}';
      var responseEight = await http.get(Uri.parse(apiUrlEight));

      if (responseEight.statusCode == 200) {
        Map<String, dynamic> responseDataEight = json.decode(responseEight.body);
        List<dynamic> dataEight = responseDataEight['Data'];

        setState(() {
          txtNamaKeluarga3.text  = dataEight.first['family_name'] ?? '-';
          txtAlamatKeluarga3.text = dataEight.first['family_address'] ?? '-';
          txtTempatLahir3.text = dataEight.first['family_pob'] ?? '-';
          txtPekerjaanKeluarga3.text = dataEight.first['family_job'] ?? '-';
        });
      } else {
        print('Failed to load data: ${responseEight.statusCode}');
      }

      String apiUrlNine = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployee.php?action=18&employee_id=${widget.employeeID}';
      var responseNine = await http.get(Uri.parse(apiUrlNine));

      if (responseNine.statusCode == 200) {
        Map<String, dynamic> responseDataNine = json.decode(responseNine.body);
        List<dynamic> dataNine = responseDataNine['Data'];

        setState(() {
          txtNamaKeluarga4.text = dataNine.first['family_name'] ?? '-';
          txtAlamatKeluarga4.text = dataNine.first['family_address'] ?? '-';
          txtTempatLahir4.text = dataNine.first['family_pob'] ?? '-';
          txtPekerjaanKeluarga4.text = dataNine.first['family_job'] ?? '-';
        });
      } else {
        print('Failed to load data: ${responseNine.statusCode}');
      }

      String apiUrlTen = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployee.php?action=19&employee_id=${widget.employeeID}';
      var responseTen = await http.get(Uri.parse(apiUrlTen));

      if (responseTen.statusCode == 200) {
        Map<String, dynamic> responseDataTen = json.decode(responseTen.body);
        List<dynamic> dataTen = responseDataTen['Data'];

        setState(() {
          txtNamaKeluarga5.text = dataTen.first['family_name'] ?? '-';
          txtAlamatKeluarga5.text = dataTen.first['family_address'] ?? '-';
          txtTempatLahir5.text = dataTen.first['family_pob'] ?? '-';
          txtPekerjaanKeluarga5.text = dataTen.first['family_job'] ?? '-';
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

  Future<void> fetchData() async {
    String employeeId = storage.read('employee_id').toString();

    try {
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/account/getprofileforallpage.php';
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

  Future<void> fetchFamilyList() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getfamily.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        final families = (data['Data'] as List)
            .map((family) => Map<String, String>.from({
                  'id_family': family['id_family'],
                  'family_name': family['family_name'],
                }))
            .toList();

        setState(() {
          familyList = families;
          if (familyList.isNotEmpty) {
            selectedFamily = familyList[0]['id_family'];
            selectedFamily2 = familyList[0]['id_family'];
            selectedFamily3 = familyList[0]['id_family'];
            selectedFamily4 = familyList[0]['id_family'];
            selectedFamily5 = familyList[0]['id_family'];
          }
        });
      } else {
        // Handle API error
        print('Failed to fetch family list');
      }
    } else {
      // Handle HTTP error
      print('Failed to fetch data');
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

  Future<void> insertEmployee() async {
    try{
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/updateemployee/updatesix.php';

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "id" : widget.employeeID,
          "family_1" : selectedFamily,
          "family_name_1" : txtNamaKeluarga1.text,
          "family_address_1" : txtAlamatKeluarga1.text,
          "family_pob_1" : txtTempatLahir1.text,
          "family_dob_1" : dateTimeTanggalLahir1.toString(),
          "family_edu_1" : selectedEducation,
          "family_job_1" : txtPekerjaanKeluarga1.text,
          "family_2" : selectedFamily2,
          "family_name_2" : txtNamaKeluarga2.text,
          "family_address_2" : txtAlamatKeluarga2.text,
          "family_pob_2" : txtTempatLahir2.text,
          "family_dob_2" : dateTimeTanggalLahir2.toString(),
          "family_edu_2" : selectedEducation2,
          "family_job_2" : txtPekerjaanKeluarga2.text,
          "family_3" : selectedFamily3,
          "family_name_3" : txtNamaKeluarga3.text,
          "family_address_3" : txtAlamatKeluarga3.text,
          "family_pob_3" : txtTempatLahir3.text,
          "family_dob_3" : dateTimeTanggalLahir3.toString(),
          "family_edu_3" : selectedEducation3,
          "family_job_3" : txtPekerjaanKeluarga3.text,
          "family_4" : selectedFamily4,
          "family_name_4" : txtNamaKeluarga4.text,
          "family_address_4" : txtAlamatKeluarga4.text,
          "family_pob_4" : txtTempatLahir4.text,
          "family_dob_4" : dateTimeTanggalLahir4.toString(),
          "family_edu_4" : selectedEducation4,
          "family_job_4" : txtPekerjaanKeluarga4.text,
          "family_5" : selectedFamily5,
          "family_name_5" : txtNamaKeluarga5.text,
          "family_address_5" : txtAlamatKeluarga5.text,
          "family_pob_5" : txtTempatLahir5.text,
          "family_dob_5" : dateTimeTanggalLahir5.toString(),
          "family_edu_5" : selectedEducation5,
          "family_job_5" : txtPekerjaanKeluarga5.text,
        }
      );

      if (response.statusCode == 200) {
        Get.to(EmployeeListPage());
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
                      Text('Hubungan Keluarga Pertama',style: TextStyle(fontSize: 5.sp,fontWeight: FontWeight.w700,)),
                      SizedBox(height: 5.sp,),
                      //statistik card
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Hubungan Keluarga",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                DropdownButtonFormField<String>(
                                  value: selectedFamily,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedFamily = newValue;
                                    });
                                  },
                                  items: familyList.map<DropdownMenuItem<String>>(
                                    (Map<String, String> family) {
                                      return DropdownMenuItem<String>(
                                        value: family['id_family']!,
                                        child: Text(family['family_name']!),
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
                                Text("Nama Lengkap",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  controller: txtNamaKeluarga1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama lengkap'
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
                                Text("Pekerjaan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  controller: txtPekerjaanKeluarga1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan pekerjaan'
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
                                Text("Alamat",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtAlamatKeluarga1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alamat lengkap'
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
                                Text("Tempat Lahir",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  //maxLines: 4,
                                  controller: txtTempatLahir1,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan tempat lahir'
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
                                Text("Tanggal Lahir",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                DateTimePicker(
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    initialDate: DateTime.now(),
                                    dateMask: 'd MMM yyyy',
                                    onChanged: (value) {
                                      setState(() {
                                        dateTimeTanggalLahir1 = DateFormat('yyyy-MM-dd').parse(value);
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
                                Text("Pendidikan Terakhir",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                DropdownButtonFormField<String>(
                                  value: selectedEducation,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedEducation = newValue;
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
                        ],
                      ),
                       SizedBox(height: 7.sp,),
                      const Divider(),
                      SizedBox(height: 7.sp,),
                      Text('Hubungan Keluarga Kedua',style: TextStyle(fontSize: 5.sp,fontWeight: FontWeight.w700,)),
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
                                Text("Hubungan Keluarga",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                DropdownButtonFormField<String>(
                                  value: selectedFamily2,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedFamily2 = newValue;
                                    });
                                  },
                                  items: familyList.map<DropdownMenuItem<String>>(
                                    (Map<String, String> family) {
                                      return DropdownMenuItem<String>(
                                        value: family['id_family']!,
                                        child: Text(family['family_name']!),
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
                                Text("Nama Lengkap",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  controller: txtNamaKeluarga2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama lengkap'
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
                                Text("Pekerjaan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  controller: txtPekerjaanKeluarga2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan pekerjaan'
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
                                Text("Alamat",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtAlamatKeluarga2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alamat lengkap'
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
                                Text("Tempat Lahir",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  //maxLines: 4,
                                  controller: txtTempatLahir2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan tempat lahir'
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
                                Text("Tanggal Lahir",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                DateTimePicker(
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    initialDate: DateTime.now(),
                                    dateMask: 'd MMM yyyy',
                                    onChanged: (value) {
                                      setState(() {
                                        dateTimeTanggalLahir2 = DateFormat('yyyy-MM-dd').parse(value);
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
                                Text("Pendidikan Terakhir",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
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
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      const Divider(),
                      SizedBox(height: 7.sp,),
                      Text('Hubungan Keluarga Ketiga',style: TextStyle(fontSize: 5.sp,fontWeight: FontWeight.w700,)),
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
                                Text("Hubungan Keluarga",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                DropdownButtonFormField<String>(
                                  value: selectedFamily3,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedFamily3 = newValue;
                                    });
                                  },
                                  items: familyList.map<DropdownMenuItem<String>>(
                                    (Map<String, String> family) {
                                      return DropdownMenuItem<String>(
                                        value: family['id_family']!,
                                        child: Text(family['family_name']!),
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
                                Text("Nama Lengkap",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  controller: txtNamaKeluarga3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama lengkap'
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
                                Text("Pekerjaan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  controller: txtPekerjaanKeluarga3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan pekerjaan'
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
                                Text("Alamat",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtAlamatKeluarga3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alamat lengkap'
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
                                Text("Tempat Lahir",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  //maxLines: 4,
                                  controller: txtTempatLahir3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan tempat lahir'
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
                                Text("Tanggal Lahir",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                DateTimePicker(
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    initialDate: DateTime.now(),
                                    dateMask: 'd MMM yyyy',
                                    onChanged: (value) {
                                      setState(() {
                                        dateTimeTanggalLahir3 = DateFormat('yyyy-MM-dd').parse(value);
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
                                Text("Pendidikan Terakhir",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
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
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      const Divider(),
                      SizedBox(height: 7.sp,),
                      Text('Hubungan Keluarga Keempat',style: TextStyle(fontSize: 5.sp,fontWeight: FontWeight.w700,)),
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
                                Text("Hubungan Keluarga",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                DropdownButtonFormField<String>(
                                  value: selectedFamily4,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedFamily4 = newValue;
                                    });
                                  },
                                  items: familyList.map<DropdownMenuItem<String>>(
                                    (Map<String, String> family) {
                                      return DropdownMenuItem<String>(
                                        value: family['id_family']!,
                                        child: Text(family['family_name']!),
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
                                Text("Nama Lengkap",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  controller: txtNamaKeluarga4,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama lengkap'
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
                                Text("Pekerjaan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  controller: txtPekerjaanKeluarga4,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan pekerjaan'
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
                                Text("Alamat",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtAlamatKeluarga4,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alamat lengkap'
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
                                Text("Tempat Lahir",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  //maxLines: 4,
                                  controller: txtTempatLahir4,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan tempat lahir'
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
                                Text("Tanggal Lahir",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                DateTimePicker(
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    initialDate: DateTime.now(),
                                    dateMask: 'd MMM yyyy',
                                    onChanged: (value) {
                                      setState(() {
                                        dateTimeTanggalLahir4 = DateFormat('yyyy-MM-dd').parse(value);
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
                                Text("Pendidikan Terakhir",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
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
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      const Divider(),
                      SizedBox(height: 7.sp,),
                      Text('Hubungan Keluarga Kelima',style: TextStyle(fontSize: 5.sp,fontWeight: FontWeight.w700,)),
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
                                Text("Hubungan Keluarga",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                DropdownButtonFormField<String>(
                                  value: selectedFamily5,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedFamily5 = newValue;
                                    });
                                  },
                                  items: familyList.map<DropdownMenuItem<String>>(
                                    (Map<String, String> family) {
                                      return DropdownMenuItem<String>(
                                        value: family['id_family']!,
                                        child: Text(family['family_name']!),
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
                                Text("Nama Lengkap",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  controller: txtNamaKeluarga5,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nama lengkap'
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
                                Text("Pekerjaan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  controller: txtPekerjaanKeluarga5,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan pekerjaan'
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
                                Text("Alamat",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtAlamatKeluarga5,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alamat lengkap'
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
                                Text("Tempat Lahir",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  //maxLines: 4,
                                  controller: txtTempatLahir5,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan tempat lahir'
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
                                Text("Tanggal Lahir",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
                                DateTimePicker(
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    initialDate: DateTime.now(),
                                    dateMask: 'd MMM yyyy',
                                    onChanged: (value) {
                                      setState(() {
                                        dateTimeTanggalLahir5 = DateFormat('yyyy-MM-dd').parse(value);
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
                                Text("Pendidikan Terakhir",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 2.sp,),
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
                                  child: const Text('Update')
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