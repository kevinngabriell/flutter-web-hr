import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Employee%20Detail/EmployeeDetailSeven.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/UpdateData/UpdateDataSix.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class EmployeeDetailSix extends StatefulWidget {
  final String employeeID;
  const EmployeeDetailSix({super.key, required this.employeeID});

  @override
  State<EmployeeDetailSix> createState() => _EmployeeDetailSixState();
}

class _EmployeeDetailSixState extends State<EmployeeDetailSix> {
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  bool isLoading = false;

  String familyTypeFifteen = '-';
  String familyNameFifteen = '-';
  String familyAddressFifteen = '-';
  String familyPobFifteen = '-';
  String familyDobFifteen = '-';
  String familyJobFifteen = '-';
  String educationNameFifteen = '-';

  String familyTypeSixteen = '-';
  String familyNameSixteen = '-';
  String familyAddressSixteen = '-';
  String familyPobSixteen = '-';
  String familyDobSixteen = '-';
  String familyJobSixteen = '-';
  String educationNameSixteen = '-';

  String familyTypeSeventeen = '-';
  String familyNameSeventeen = '-';
  String familyAddressSeventeen = '-';
  String familyPobSeventeen = '-';
  String familyDobSeventeen = '-';
  String familyJobSeventeen = '-';
  String educationNameSeventeen = '-';

  String familyTypeEighteen = '-';
  String familyNameEighteen = '-';
  String familyAddressEighteen = '-';
  String familyPobEighteen = '-';
  String familyDobEighteen = '-';
  String familyJobEighteen = '-';
  String educationNameEighteen = '-';

  String familyTypeNineteen = '-';
  String familyNameNineteen = '-';
  String familyAddressNineteen = '-';
  String familyPobNineteen = '-';
  String familyDobNineteen = '-';
  String familyJobNineteen = '-';
  String educationNameNineteen = '-';

  String familyTypeTwenty = '-';
  String familyNameTwenty = '-';
  String familyAddressTwenty = '-';
  String familyPobTwenty = '-';
  String familyDobTwenty = '-';
  String familyJobTwenty = '-';
  String educationNameTwenty = '-';



  @override
  void initState() {
    super.initState();
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
          familyTypeFifteen = dataSix.first['type'] ?? '-';
          familyNameFifteen = dataSix.first['family_name'] ?? '-';
          familyAddressFifteen = dataSix.first['family_address'] ?? '-';
          familyPobFifteen = dataSix.first['family_pob'] ?? '-';
          familyDobFifteen = dataSix.first['family_dob'] != '0000-00-00' ? dataSix.first['family_dob'] : '-';
          familyJobFifteen = dataSix.first['family_job'] ?? '-';
          educationNameFifteen = dataSix.first['education_name'] ?? '-';
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
          familyTypeSixteen = dataSeven.first['type'] ?? '-';
          familyNameSixteen = dataSeven.first['family_name'] ?? '-';
          familyAddressSixteen = dataSeven.first['family_address'] ?? '-';
          familyPobSixteen = dataSeven.first['family_pob'] ?? '-';
          familyDobSixteen = dataSeven.first['family_dob'] != '0000-00-00' ? dataSeven.first['family_dob'] : '-';
          familyJobSixteen = dataSeven.first['family_job'] ?? '-';
          educationNameSixteen = dataSeven.first['education_name'] ?? '-';
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
          familyTypeSeventeen = dataEight.first['type'] ?? '-';
          familyNameSeventeen = dataEight.first['family_name'] ?? '-';
          familyAddressSeventeen = dataEight.first['family_address'] ?? '-';
          familyPobSeventeen = dataEight.first['family_pob'] ?? '-';
          familyDobSeventeen = dataEight.first['family_dob'] != '0000-00-00' ? dataEight.first['family_dob'] : '-';
          familyJobSeventeen = dataEight.first['family_job'] ?? '-';
          educationNameSeventeen = dataEight.first['education_name'] ?? '-';
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
          familyTypeEighteen = dataNine.first['type'] ?? '-';
          familyNameEighteen = dataNine.first['family_name'] ?? '-';
          familyAddressEighteen = dataNine.first['family_address'] ?? '-';
          familyPobEighteen = dataNine.first['family_pob'] ?? '-';
          familyDobEighteen = dataNine.first['family_dob'] != '0000-00-00' ? dataNine.first['family_dob'] : '-';
          familyJobEighteen = dataNine.first['family_job'] ?? '-';
          educationNameEighteen = dataNine.first['education_name'] ?? '-';
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
          familyTypeNineteen = dataTen.first['type'] ?? '-';
          familyNameNineteen = dataTen.first['family_name'] ?? '-';
          familyAddressNineteen = dataTen.first['family_address'] ?? '-';
          familyPobNineteen = dataTen.first['family_pob'] ?? '-';
          familyDobNineteen = dataTen.first['family_dob'] != '0000-00-00' ? dataTen.first['family_dob'] : '-';
          familyJobNineteen = dataTen.first['family_job'] ?? '-';
          educationNameNineteen = dataTen.first['education_name'] ?? '-';
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

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    var employeeId = storage.read('employee_id');
    var positionId = storage.read('position_id');
    var photo = storage.read('photo');
    int storedEmployeeIdNumber = int.parse(widget.employeeID);
    
    return MaterialApp(
      title: "Data Karyawan",
      home: Scaffold(
        body: isLoading ? const Center(child: CircularProgressIndicator())  : SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Side Menu
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
              //Content
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Hubungan Keluarga',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyTypeFifteen)
                              ],
                            ),
                          ),
                          SizedBox(
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nama Lengkap',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyNameFifteen)
                              ],
                            ),
                          ),
                          SizedBox(
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pekerjaan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyJobFifteen)
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
                            width: (MediaQuery.of(context).size.width - 88.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Alamat',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyAddressFifteen)
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
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tempat Lahir',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyPobFifteen)
                              ],
                            ),
                          ),
                          SizedBox(
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tanggal Lahir',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyDobFifteen)
                              ],
                            ),
                          ),
                          SizedBox(
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pendidikan Terakhir',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(educationNameFifteen)
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
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Hubungan Keluarga',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyTypeSixteen)
                              ],
                            ),
                          ),
                          SizedBox(
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nama Lengkap',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyNameSixteen)
                              ],
                            ),
                          ),
                          SizedBox(
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pekerjaan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyJobSixteen)
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
                            width: (MediaQuery.of(context).size.width - 88.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Alamat',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyAddressSixteen)
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
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tempat Lahir',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyPobSixteen)
                              ],
                            ),
                          ),
                          SizedBox(
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tanggal Lahir',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyDobSixteen)
                              ],
                            ),
                          ),
                          SizedBox(
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pendidikan Terakhir',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(educationNameSixteen)
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
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Hubungan Keluarga',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyTypeSeventeen)
                              ],
                            ),
                          ),
                          SizedBox(
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nama Lengkap',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyNameSeventeen)
                              ],
                            ),
                          ),
                          SizedBox(
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pekerjaan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyJobSeventeen)
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
                            width: (MediaQuery.of(context).size.width - 88.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Alamat',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyAddressSeventeen)
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
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tempat Lahir',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyPobSeventeen)
                              ],
                            ),
                          ),
                          SizedBox(
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tanggal Lahir',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyDobSeventeen)
                              ],
                            ),
                          ),
                          SizedBox(
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pendidikan Terakhir',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(educationNameSeventeen)
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
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Hubungan Keluarga',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyTypeEighteen)
                              ],
                            ),
                          ),
                          SizedBox(
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nama Lengkap',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyNameEighteen)
                              ],
                            ),
                          ),
                          SizedBox(
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pekerjaan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyJobEighteen)
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
                            width: (MediaQuery.of(context).size.width - 88.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Alamat',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyAddressEighteen)
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
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tempat Lahir',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyPobEighteen)
                              ],
                            ),
                          ),
                          SizedBox(
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tanggal Lahir',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyDobEighteen)
                              ],
                            ),
                          ),
                          SizedBox(
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pendidikan Terakhir',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(educationNameEighteen)
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
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Hubungan Keluarga',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyTypeNineteen)
                              ],
                            ),
                          ),
                          SizedBox(
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nama Lengkap',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyNameNineteen)
                              ],
                            ),
                          ),
                          SizedBox(
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pekerjaan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyJobNineteen)
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
                            width: (MediaQuery.of(context).size.width - 88.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Alamat',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyAddressNineteen)
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
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tempat Lahir',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyPobNineteen)
                              ],
                            ),
                          ),
                          SizedBox(
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tanggal Lahir',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(familyDobNineteen)
                              ],
                            ),
                          ),
                          SizedBox(
                           width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pendidikan Terakhir',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(educationNameNineteen)
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7.sp,),
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
                                  minimumSize: Size(50.w, 55.h),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Kembali')
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: (){
                                    Get.to(UpdateDataSix(employeeID: widget.employeeID));
                                }, 
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(50.w, 55.h),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Update')
                              ),
                              SizedBox(width: 10.w,),
                              ElevatedButton(
                                onPressed: (){
                                  Get.to(EmployeeDetailSeven(employeeID: widget.employeeID));
                                }, 
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(50.w, 55.h),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: const Color(0xff4ec3fc),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Berikutnya')
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                    ]
                  )
                )
              )
            ]
          )
        )
      )
    );
  }
}