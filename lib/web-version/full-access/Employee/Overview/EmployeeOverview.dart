// ignore_for_file: avoid_print, file_names, unnecessary_string_interpolations, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, unnecessary_null_comparison, use_build_context_synchronously, non_constant_identifier_names, empty_catches

import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/EmployeeList.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Overview/AbsenTableCalendarOverview.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Overview/CutiOverview.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Overview/Document/BPJSDocument.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Overview/Document/KTPDocument.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Overview/Document/NPWPDocument.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Overview/Document/SimADocument.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Overview/Document/SimCDocument.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Overview/GeneralInformation.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Overview/InventoryEmployeeOverview.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Overview/PerjalananDinasOverview.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;


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
  String namaKaryawan = '';
  String selectedFile = '';
  Uint8List? image;
  String emailKaryawan = '';

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 6, vsync: this);
    fetchData();
    fetchSPVdata();
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
                        height: MediaQuery.of(context).size.height + 920.h,
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height,
                        ),
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            GeneralInformation(employeeId: widget.employeeId),
                            AbsenTableCalendarOverview(employeeId: widget.employeeId, namaKaryawan: namaKaryawan),
                            CutiOverview(employeeId: widget.employeeId, namaKaryawan: namaKaryawan),
                            InventoryEmployeeOverview(employeeId: widget.employeeId, namaKaryawan: namaKaryawan),
                            PerjalananDinasOverview(employeeId: widget.employeeId, namaKaryawan: namaKaryawan),
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 10.sp,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      KTPDocumentCard(employeeID: widget.employeeId, namaKaryawan: namaKaryawan,),
                                      SimADocument(employeeID: widget.employeeId, namaKaryawan: namaKaryawan)
                                    ],
                                  ),
                                  SizedBox(height: 7.sp,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SimCDocument(employeeID: widget.employeeId, namaKaryawan: namaKaryawan),
                                      NpwpDocument(employeeID: widget.employeeId, namaKaryawan: namaKaryawan),
                                    ],
                                  ),
                                  SizedBox(height: 7.sp,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      BPJSDocument(employeeID: widget.employeeId, namaKaryawan: namaKaryawan),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 100.w) / 2,
                                        child: Container()
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10.sp,),
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