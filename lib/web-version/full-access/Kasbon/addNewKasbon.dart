import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Kasbon/kasbonIndex.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:hr_systems_web/web-version/full-access/Salary/currencyformatter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class addNewKasbon extends StatefulWidget {
  const addNewKasbon({super.key});

  @override
  State<addNewKasbon> createState() => _addNewKasbonState();
}

class _addNewKasbonState extends State<addNewKasbon> {
  final storage = GetStorage();
  bool isLoading = false;
  String companyName = '';
  String companyAddress = '';
  String trimmedCompanyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  List<Map<String, String>> employees = [];
  String selectedEmployeeId = '';
  DateTime? tanggalKasbon;
  TextEditingController txtJumlahKasbon = TextEditingController();
  TextEditingController txtKeperluan = TextEditingController();


  @override
  void initState() {
    super.initState();
    fetchData();
    fetchEmployeeData();
  }

  Future<void> actionKasbon() async {
    try{
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/kasbon/kasbon.php';
      String employeeId = storage.read('employee_id').toString();

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "action" : "1",
          "employee_id" : selectedEmployeeId,
          "amount" : txtJumlahKasbon.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "kasbon_date" : tanggalKasbon.toString(),
          "keterangan" : txtKeperluan.text,
          "hrd" : employeeId
        }
      );

      if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil input data kasbon'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const kasbonIndex());
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
                      Get.to(const kasbonIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        }
    } catch (e){
      isLoading = false;
      showDialog(
        context: context, 
        builder: (_) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text('Error $e'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.to(const kasbonIndex());
              }, 
              child: const Text("Oke")
            ),
          ],
        );}
      );
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchEmployeeData() async {
    final response = await http.get(
      Uri.parse(
          'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployeelist.php'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final dataList = data['Data'] as List<dynamic>;
      employees = dataList
          .map((emp) => Map<String, String>.from(emp as Map<String, dynamic>))
          .toList();
      if (employees.isNotEmpty) {
        selectedEmployeeId = employees[0]['id']!;
      }
      setState(() {});
    } else {
      print('Failed to fetch data');
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

        // Ensure that the fields are of the correct type
        setState(() {
          companyName = data['company_name'] as String;
          companyAddress = data['company_address'] as String;
          trimmedCompanyAddress = companyAddress.substring(0, 15);
          employeeName = data['employee_name'] as String;
          employeeEmail = data['employee_email'] as String;
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

    return MaterialApp(
      home: Scaffold(
        body: isLoading ? const Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    ]
                  )
                )
              ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tanggal Kasbon',style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                SizedBox(height: 4.h,),
                                DateTimePicker(
                                  firstDate: DateTime(2024),
                                  initialDate: DateTime.now(),
                                  lastDate: DateTime(2500),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan tanggal kasbon' ,
                                  ),
                                  onChanged: (value) {
                                      tanggalKasbon = DateFormat('yyyy-MM-dd').parse(value);
                                    },
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 2.h,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nama Karyawan',style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                SizedBox(height: 4.h,),
                                DropdownButton<String>(
                                  value: selectedEmployeeId,
                                  items: employees.map((emp) {
                                    return DropdownMenuItem<String>(
                                      value: emp['id']!,
                                      child: Text(emp['employee_name']!),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedEmployeeId = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Keperluan',style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                SizedBox(height: 4.h,),
                                TextFormField(
                                  controller: txtKeperluan,
                                  maxLines: 2,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan keperluan kasbon' ,
                                  )
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Jumlah Kasbon',style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                SizedBox(height: 4.h,),
                                TextFormField(
                                  controller: txtJumlahKasbon,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyFormatter(),
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan jumlah kasbon' ,
                                  )
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 2.h,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: (){
                              actionKasbon();
                              // print('${tanggalKasbon.toString()}, $selectedEmployeeId, $txtKeperluan, ${txtJumlahKasbon.text.replaceAll(RegExp(r'[^0-9]'), '')}');
                            }, 
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              alignment: Alignment.center,
                              minimumSize: Size(40.w, 55.h),
                              foregroundColor: const Color(0xFFFFFFFF),
                              backgroundColor: const Color(0xff4ec3fc),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text('Kumpul')
                          )
                        ],
                      )
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