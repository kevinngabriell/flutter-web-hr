// ignore_for_file: file_names, avoid_print, unnecessary_string_interpolations, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Add%20New%20Employee/AddNewEmployeeOne.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/EmployeeList.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddNewEmployeeEight extends StatefulWidget {
  const AddNewEmployeeEight({super.key});

  @override
  State<AddNewEmployeeEight> createState() => _AddNewEmployeeEightState();
}

class _AddNewEmployeeEightState extends State<AddNewEmployeeEight> {
  String id = '';
  String? agree;
String trimmedCompanyAddress = '';
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';

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
      print('Exception during API call: $e');
    }
  }

  Future<void> fetchLastID() async {
  const apiUrl =
      'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getlastidforinput.php';

  try {
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
    print('Error: $e');
  }
}

  Future<void> insertEmployee() async {
    try {
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/insertemployee/inserteight.php';

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "id": id,
          "agree": agree
        }
      );

      if (response.statusCode == 200) {
        print('Employee inserted successfully');
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Sukses"),
              content: const Text("Data karyawan telah berhasil diinput"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.to(const AddNewEmployeeFirst());
                  }, 
                  child: const Text("Tambah karyawan")
                ),
                TextButton(
                  onPressed: () {
                    Get.to(const EmployeeListPage());
                  }, 
                  child: const Text("Kembali ke list karyawan")
                )
              ],
            );
          }
        );
        // Add any additional logic or UI updates after successful insertion
      } else {
        Get.snackbar('Gagal', '${response.body}');
        print('Failed to insert employee. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Handle the error or show an error message to the user
      }

    } catch (e) {
      Get.snackbar('Gagal', '$e');
      print('Exception during API call: $e');
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
                      //statistik card
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Text("Pernyataan",
                                  style: TextStyle(
                                    fontSize: 6.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h,),
                      Text("1. Saya menyatakan bahwa keterangan di atas saya buat dengan benar, dan mengerti apabila keterangan tersebut tidak benar maka saya bersedia mempertanggung jawabkannya sesuai dengan ketentuan perusahaan dan atau hukum yang berlaku.",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 7.h,),
                      Text("2. Saya menyetujui untuk mengikuti peraturan perusahaan/kebijaksanaan yang ditujukan kepada saya atau yang tercantum dalam KKB/peraturan perusahaan yang berlaku.",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 7.h,),
                      Text("3. Saya mengerti bahwa penerimaan menjadi karyawan bisa batal apabila hasil pemeriksaan yang diselenggarakan oleh perusahaan membuktikan bahwa saya memberikan keterangan palsu atau yang dipalsukan baik sebelum atau pada saat saya bekerja dengan perusahaan.",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 10.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                        onPressed: () {
                          agree = 'Yes';
                          insertEmployee();
                        }, 
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(50.w, 55.h),
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
                      SizedBox(height: 10.h,),
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