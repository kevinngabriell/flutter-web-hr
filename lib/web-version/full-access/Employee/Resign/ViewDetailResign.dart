
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:hr_systems_web/web-version/full-access/index.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class viewDetailResign extends StatefulWidget {
  final String statusName;
  final String tanggalPengajuan;
  final String namaKaryawan;
  final String tanggalEfektif;
  final String alasanBerhenti;
  final String idResign;
  final String idKaryawan;
  const viewDetailResign({super.key, required this.statusName, required this.tanggalPengajuan, required this.namaKaryawan, required this.tanggalEfektif, required this.alasanBerhenti, required this.idResign, required this.idKaryawan});

  @override
  State<viewDetailResign> createState() => _viewDetailResignState();
}

class _viewDetailResignState extends State<viewDetailResign> {
  String? leaveoptions;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  bool isLoading = false;
  String employeeId = '';

  String departemenKaryawan = '';
  String jabatankaryawan = '';

  String inventory = '';
  String totalloan = '';
  String totalkasbon = '';

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDataforFilled();
    fetchResignData();
  }

  Future<void> fetchResignData() async {
    employeeId = storage.read('employee_id').toString();
   String url = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/resign/getresign.php?action=1&employee_id=${widget.idKaryawan}';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final data = jsonResponse['Data'] as Map<String, dynamic>;

      inventory = data['inventory'] ?? '0';
      totalloan = data['totalloan'] ?? '0';
      totalkasbon = data['totalkasbon'] ?? '0';

      // Ensuring the values are stored as strings, even if null
      inventory = inventory.isNotEmpty ? inventory : '0';
      totalloan = totalloan.isNotEmpty ? totalloan : '0';
      totalkasbon = totalkasbon.isNotEmpty ? totalkasbon : '0';

    } else {
      print('Failed to load data');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> actionKasbon() async {
    try{
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/resign/resign.php';
      employeeId = storage.read('employee_id').toString();

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "action" : "3",
          "employee_id" : employeeId,
          "resign_id" : widget.idResign,
        }
      );

      if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil update data pemunduran diri'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(FullIndexWeb(employeeId));
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        } else {
          print(response.body + response.statusCode.toString());
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error ${response.statusCode}'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(FullIndexWeb(employeeId));
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
                Get.to(FullIndexWeb(employeeId));
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

  Future<void> fetchDataforFilled() async {
    try {
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/getdataforrequestor.php';

      // Replace 'employee_id' with the actual employee ID from storage
      String employeeId = storage.read('employee_id').toString(); // replace with your logic to get employee ID

      // Create a Map for the request body
      Map<String, dynamic> requestBody = {'employee_id': widget.idKaryawan};

      // Convert the Map to a JSON string
      String requestBodyJson = json.encode(requestBody);

      // Make the API call with a POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'employee_id': widget.idKaryawan,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        setState(() {
          departemenKaryawan = data['Data']['department_name'] as String;
          jabatankaryawan = data['Data']['position_name'] as String;

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
                      Padding(
                          padding: EdgeInsets.only(right: 10.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Status Pemunduran Diri', style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(widget.statusName),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Tanggal Permohonan', style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(_formatDate(widget.tanggalPengajuan)),
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
                      ),
                      SizedBox(height: 7.sp,),
                      Text('Detail Pemunduran Diri', style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w600,)),
                      SizedBox(height: 7.sp,),
                      Padding(
                          padding: EdgeInsets.only(right: 10.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Nama Karyawan', style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(widget.namaKaryawan),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Departemen', style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(departemenKaryawan),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Jabatan', style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(jabatankaryawan),
                                  ],
                                ),
                              )
                            ],
                          ),
                      ),
                      SizedBox(height: 7.sp,),
                      Padding(
                          padding: EdgeInsets.only(right: 10.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Tanggal Efektif', style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(formatDate(widget.tanggalEfektif)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Alasan', style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                    Text(widget.alasanBerhenti),
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
                      ),
                      SizedBox(height: 7.sp,),
                      Text('Checklist Asset & Pinjaman Karyawan', style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w600,)),
                        SizedBox(height: 7.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Inventaris',style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                  SizedBox(height: 4.h,),
                                  Text(inventory)
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Jumlah Sisa Pinjaman',style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                  SizedBox(height: 4.h,),
                                  Text(formatCurrency2(totalloan))
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Jumlah Sisa Kasbon',style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                  SizedBox(height: 4.h,),
                                  Text(formatCurrency2(totalkasbon))
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 7.sp,),
                      if(positionId == 'POS-HR-002' && widget.statusName == 'Draft')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: (){
                                if(inventory == '0' && totalkasbon == '0' && totalloan == '0'){
                                  actionKasbon();
                                } else {
                                  showDialog(
                                    context: context, 
                                    builder: (_){
                                      return AlertDialog(
                                        title: Text('Error'),
                                        content: Text('${widget.namaKaryawan} masih memiliki hutang atau asset perusahaan yang belum dikembalikan. Silahkan coba kembali setelah asset inventaris dan hutang telah lunas'),
                                        actions: [
                                          TextButton(
                                            onPressed: (){
                                              Get.back();
                                            }, 
                                            child: Text('Oke')
                                          )
                                        ],
                                      );
                                    }
                                  );
                                }
                              }, 
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                alignment: Alignment.center,
                                minimumSize: Size(40.w, 55.h),
                                foregroundColor: const Color(0xFFFFFFFF),
                                backgroundColor: const Color(0xff4ec3fc),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text('Setuju')
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

  String formatDate(String date) {
    // Parse the date string
    DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(date);

    // Format the date as "dd MMMM yyyy"
    return DateFormat("d MMMM yyyy", 'id').format(parsedDate);
  }

  String _formatDate(String date) {
    // Parse the date string
    DateTime parsedDate = DateFormat("yyyy-MM-dd HH:mm").parse(date);

    // Format the date as "dd MMMM yyyy"
    return DateFormat("d MMMM yyyy HH:mm", "id").format(parsedDate);
  }

  String formatCurrency2(String value) {
    // Parse the string to a number.
    double numberValue = double.tryParse(value) ?? 0;

    // Format the number as currency.
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0).format(numberValue);
  }
}