import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Employee%20Detail/EmployeeDetailFive.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/UpdateData/UpdateDataFour.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class EmployeeDetailFour extends StatefulWidget {
  final String employeeID;
  const EmployeeDetailFour({super.key, required this.employeeID});

  @override
  State<EmployeeDetailFour> createState() => _EmployeeDetailFourState();
}

class _EmployeeDetailFourState extends State<EmployeeDetailFour> {
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  bool isLoading = false;

  String educationNameSix = '-';
  String empNameSix = '-';
  String empMajorSix = '-';
  String empGradeSix = '-';
  String empStartSix = '-';
  String empEndSix = '-';
  String empDescSix = '-';
  String educationNameSeven = '-';
  String empNameSeven = '-';
  String empMajorSeven = '-';
  String empGradeSeven = '-';
  String empStartSeven = '-';
  String empEndSeven = '-';
  String empDescSeven = '-';
  String educationNameEight = '-';
  String empNameEight = '-';
  String empMajorEight = '-';
  String empGradeEight = '-';
  String empStartEight = '-';
  String empEndEight = '-';
  String empDescEight = '-';
  String educationNameNine = '-';
  String empNameNine = '-';
  String empMajorNine = '-';
  String empGradeNine = '-';
  String empStartNine = '-';
  String empEndNine = '-';
  String empDescNine = '-';
  String educationNameTen = '-';
  String empNameTen = '-';
  String empMajorTen = '-';
  String empGradeTen = '-';
  String empStartTen = '-';
  String empEndTen = '-';
  String empDescTen = '-';

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDetailData();
  }

  Future<void> fetchDetailData() async {
    try{
      isLoading = true;

      String apiUrlSix = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployee.php?action=6&employee_id=${widget.employeeID}';
      var responseSix = await http.get(Uri.parse(apiUrlSix));

      if (responseSix.statusCode == 200) {
        Map<String, dynamic> responseDataSix = json.decode(responseSix.body);
        List<dynamic> dataSix = responseDataSix['Data'];

        setState(() {
          educationNameSix = dataSix.isNotEmpty ? dataSix.first['education_name'] ?? '-' : '-';
          empNameSix = dataSix.isNotEmpty ? dataSix.first['emp_name'] ?? '-' : '-';
          empMajorSix = dataSix.isNotEmpty ? dataSix.first['emp_major'] ?? '-' : '-';
          empGradeSix = dataSix.isNotEmpty ? dataSix.first['emp_grade'] ?? '-' : '-';
          empStartSix = dataSix.isNotEmpty && dataSix.first['emp_start'] != '0000-00-00' ? dataSix.first['emp_start'] ?? '-' : '-';
          empEndSix = dataSix.isNotEmpty && dataSix.first['emp_end'] != '0000-00-00' ? dataSix.first['emp_end'] ?? '-' : '-';
          empDescSix = dataSix.isNotEmpty ? dataSix.first['emp_desc'] ?? '-' : '-';
        });
      } else {
        print('Failed to load data: ${responseSix.statusCode}');
      }

      String apiUrlSeven = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployee.php?action=7&employee_id=${widget.employeeID}';
      var responseSeven = await http.get(Uri.parse(apiUrlSeven));

      if (responseSeven.statusCode == 200) {
        Map<String, dynamic> responseDataSeven = json.decode(responseSeven.body);
        List<dynamic> dataSeven = responseDataSeven['Data'];

        setState(() {
          educationNameSeven = dataSeven.isNotEmpty ? dataSeven.first['education_name'] ?? '-' : '-';
          empNameSeven = dataSeven.isNotEmpty ? dataSeven.first['emp_name'] ?? '-' : '-';
          empMajorSeven = dataSeven.isNotEmpty ? dataSeven.first['emp_major'] ?? '-' : '-';
          empGradeSeven = dataSeven.isNotEmpty ? dataSeven.first['emp_grade'] ?? '-' : '-';
          empStartSeven = dataSeven.isNotEmpty && dataSeven.first['emp_start'] != '0000-00-00' ? dataSeven.first['emp_start'] ?? '-' : '-';
          empEndSeven = dataSeven.isNotEmpty && dataSeven.first['emp_end'] != '0000-00-00' ? dataSeven.first['emp_end'] ?? '-' : '-';
          empDescSeven = dataSeven.isNotEmpty ? dataSeven.first['emp_desc'] ?? '-' : '-';
        });
      } else {
        print('Failed to load data: ${responseSeven.statusCode}');
      }

      String apiUrlEight = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployee.php?action=8&employee_id=${widget.employeeID}';
      var responseEight = await http.get(Uri.parse(apiUrlEight));

      if (responseEight.statusCode == 200) {
        Map<String, dynamic> responseDataEight = json.decode(responseEight.body);
        List<dynamic> dataEight = responseDataEight['Data'];

        setState(() {
          educationNameEight = dataEight.isNotEmpty ? dataEight.first['education_name'] ?? '-' : '-';
          empNameEight = dataEight.isNotEmpty ? dataEight.first['emp_name'] ?? '-' : '-';
          empMajorEight = dataEight.isNotEmpty ? dataEight.first['emp_major'] ?? '-' : '-';
          empGradeEight = dataEight.isNotEmpty ? dataEight.first['emp_grade'] ?? '-' : '-';
          empStartEight = dataEight.isNotEmpty && dataEight.first['emp_start'] != '0000-00-00' ? dataEight.first['emp_start'] ?? '-' : '-';
          empEndEight = dataEight.isNotEmpty && dataEight.first['emp_end'] != '0000-00-00' ? dataEight.first['emp_end'] ?? '-' : '-';
          empDescEight = dataEight.isNotEmpty ? dataEight.first['emp_desc'] ?? '-' : '-';
        });
      } else {
        print('Failed to load data: ${responseEight.statusCode}');
      }

      String apiUrlNine = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployee.php?action=9&employee_id=${widget.employeeID}';
      var responseNine = await http.get(Uri.parse(apiUrlNine));

      if (responseNine.statusCode == 200) {
        Map<String, dynamic> responseDataNine = json.decode(responseNine.body);
        List<dynamic> dataNine = responseDataNine['Data'];

        setState(() {
          educationNameNine = dataNine.isNotEmpty ? dataNine.first['education_name'] ?? '-' : '-';
          empNameNine = dataNine.isNotEmpty ? dataNine.first['emp_name'] ?? '-' : '-';
          empMajorNine = dataNine.isNotEmpty ? dataNine.first['emp_major'] ?? '-' : '-';
          empGradeNine = dataNine.isNotEmpty ? dataNine.first['emp_grade'] ?? '-' : '-';
          empStartNine = dataNine.isNotEmpty && dataNine.first['emp_start'] != '0000-00-00' ? dataNine.first['emp_start'] ?? '-' : '-';
          empEndNine = dataNine.isNotEmpty && dataNine.first['emp_end'] != '0000-00-00' ? dataNine.first['emp_end'] ?? '-' : '-';
          empDescNine = dataNine.isNotEmpty ? dataNine.first['emp_desc'] ?? '-' : '-';
        });
      } else {
        print('Failed to load data: ${responseNine.statusCode}');
      }

      String apiUrlTen = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployee.php?action=10&employee_id=${widget.employeeID}';
      var responseTen = await http.get(Uri.parse(apiUrlTen));

      if (responseTen.statusCode == 200) {
        Map<String, dynamic> responseDataTen = json.decode(responseTen.body);
        List<dynamic> dataTen = responseDataTen['Data'];

        setState(() {
          educationNameTen = dataTen.isNotEmpty ? dataTen.first['education_name'] ?? '-' : '-';
          empNameTen = dataTen.isNotEmpty ? dataTen.first['emp_name'] ?? '-' : '-';
          empMajorTen = dataTen.isNotEmpty ? dataTen.first['emp_major'] ?? '-' : '-';
          empGradeTen = dataTen.isNotEmpty ? dataTen.first['emp_grade'] ?? '-' : '-';
          empStartTen = dataTen.isNotEmpty && dataTen.first['emp_start'] != '0000-00-00' ? dataTen.first['emp_start'] ?? '-' : '-';
          empEndTen = dataTen.isNotEmpty && dataTen.first['emp_end'] != '0000-00-00' ? dataTen.first['emp_end'] ?? '-' : '-';
          empDescTen = dataTen.isNotEmpty ? dataTen.first['emp_desc'] ?? '-' : '-';
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
        body: isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
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
                        LaporanNonActive(positionId: widget.employeeID,),
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
                      Text('Pendidikan Pertama',style: TextStyle(fontSize: 5.sp,fontWeight: FontWeight.w700,)),
                      SizedBox(height: 5.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tingkat Pendidikan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(educationNameSix)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nama Sekolah',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empNameSix)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Jurusan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empMajorSix)
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
                                Text('Tahun Masuk',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empStartSix)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tahun Selesai',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empEndSix)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nilai',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empGradeSix)
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
                                Text('Deskripsi Pendidikan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empDescSix)
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
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tingkat Pendidikan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(educationNameSeven)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nama Sekolah',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empNameSeven)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Jurusan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empMajorSeven)
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
                                Text('Tahun Masuk',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empStartSeven)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tahun Selesai',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empEndSeven)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nilai',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empGradeSeven)
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
                                Text('Deskripsi Pendidikan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empDescSeven)
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
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tingkat Pendidikan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(educationNameEight)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nama Sekolah',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empNameEight)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Jurusan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empMajorEight)
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
                                Text('Tahun Masuk',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empStartEight)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tahun Selesai',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empEndEight)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nilai',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empGradeEight)
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
                                Text('Deskripsi Pendidikan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empDescEight)
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
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tingkat Pendidikan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(educationNameNine)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nama Sekolah',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empNameNine)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Jurusan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empMajorNine)
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
                                Text('Tahun Masuk',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empStartNine)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tahun Selesai',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empEndNine)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nilai',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empGradeNine)
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
                                Text('Deskripsi Pendidikan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empDescNine)
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
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tingkat Pendidikan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(educationNameTen)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nama Sekolah',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empNameTen)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Jurusan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empMajorTen)
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
                                Text('Tahun Masuk',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empStartTen)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tahun Selesai',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empEndTen)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nilai',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empGradeTen)
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
                                Text('Deskripsi Pendidikan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(empDescTen)
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
                                  Get.to(UpdateDataFour(employeeId: widget.employeeID));
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
                                  Get.to(EmployeeDetailFive(employeeID: widget.employeeID));
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