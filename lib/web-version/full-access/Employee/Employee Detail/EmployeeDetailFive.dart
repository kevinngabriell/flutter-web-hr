import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Employee%20Detail/EmployeeDetailSix.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/UpdateData/UpdateDataFive.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class EmployeeDetailFive extends StatefulWidget {
  final String employeeID;
  const EmployeeDetailFive({super.key, required this.employeeID});

  @override
  State<EmployeeDetailFive> createState() => _EmployeeDetailFiveState();
}

class _EmployeeDetailFiveState extends State<EmployeeDetailFive> {
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  bool isLoading = false;

  String languageNameEleven = '-';
  String mendengarSatuEleven = '-';
  String berbicaraSatuEleven = '-';
  String membacaSatuEleven = '-';
  String menulisSatuEleven = '-';
  String languageNameTwelve = '-';
  String mendengarDuaTwelve = '-';
  String berbicaraDuaTwelve = '-';
  String membacaDuaTwelve = '-';
  String menulisDuaTwelve = '-';
  String languageNameThirteen = '-';
  String mendengarTigaThirteen = '-';
  String berbicaraTigaThirteen = '-';
  String membacaTigaThirteen = '-';
  String menulisTigaThirteen = '-';
  String languageNameFourteen = '-';
  String mendengarEmpatFourteen = '-';
  String berbicaraEmpatFourteen = '-';
  String membacaEmpatFourteen = '-';
  String menulisEmpatFourteen = '-';


  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDetailData();  
  }

  Future<void> fetchDetailData() async {
    try{
      isLoading = true;

      String apiUrlEleven = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployee.php?action=11&employee_id=${widget.employeeID}';
      var responseEleven = await http.get(Uri.parse(apiUrlEleven));

      if (responseEleven.statusCode == 200) {
          var responseDataEleven = json.decode(responseEleven.body);
          var dataEleven = responseDataEleven['Data'][0];

          setState(() {
              languageNameEleven = dataEleven['language_name'] ?? '-';
              mendengarSatuEleven = dataEleven['mendengar_satu'] ?? '-';
              berbicaraSatuEleven = dataEleven['berbicara_satu'] ?? '-';
              membacaSatuEleven = dataEleven['membaca_satu'] ?? '-';
              menulisSatuEleven = dataEleven['menulis_satu'] ?? '-';
          });
      } else {
          print('Failed to load data for action 11: ${responseEleven.statusCode}');
      }

      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployee.php?action=12&employee_id=${widget.employeeID}';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          var data = responseData['Data'][0]; // Assuming Data is an array and you want the first object

          setState(() {
              languageNameTwelve = data['language_name'] ?? '-';
              mendengarDuaTwelve = data['mendengar_dua'] ?? '-';
              berbicaraDuaTwelve = data['berbicara_dua'] ?? '-';
              membacaDuaTwelve = data['membaca_dua'] ?? '-';
              menulisDuaTwelve = data['menulis_dua'] ?? '-';
          });
      } else {
          print('Failed to load data: ${response.statusCode}');
      }

      String apiUrlThirteen = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployee.php?action=13&employee_id=${widget.employeeID}';
      var responseThirteen = await http.get(Uri.parse(apiUrlThirteen));

      if (responseThirteen.statusCode == 200) {
          var responseDataThirteen = json.decode(responseThirteen.body);
          var dataThirteen = responseDataThirteen['Data'][0];

          setState(() {
              languageNameThirteen = dataThirteen['language_name'] ?? '-';
              mendengarTigaThirteen = dataThirteen['mendengar_tiga'] ?? '-';
              berbicaraTigaThirteen = dataThirteen['berbicara_tiga'] ?? '-';
              membacaTigaThirteen = dataThirteen['membaca_tiga'] ?? '-';
              menulisTigaThirteen = dataThirteen['menulis_tiga'] ?? '-';
          });
      } else {
          print('Failed to load data for action 13: ${responseThirteen.statusCode}');
      }

      String apiUrlFourteen = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployee.php?action=14&employee_id=${widget.employeeID}';
      var responseFourteen = await http.get(Uri.parse(apiUrlFourteen));

      if (responseFourteen.statusCode == 200) {
          var responseDataFourteen = json.decode(responseFourteen.body);
          var dataFourteen = responseDataFourteen['Data'][0];

          setState(() {
              languageNameFourteen = dataFourteen['language_name'] ?? '-';
              mendengarEmpatFourteen = dataFourteen['mendengar_empat'] ?? '-';
              berbicaraEmpatFourteen = dataFourteen['berbicara_empat'] ?? '-';
              membacaEmpatFourteen = dataFourteen['membaca_empat'] ?? '-';
              menulisEmpatFourteen = dataFourteen['menulis_empat'] ?? '-';
          });
      } else {
          print('Failed to load data for action 14: ${responseFourteen.statusCode}');
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
                      Text('Kemampuan Bahasa Pertama',style: TextStyle(fontSize: 5.sp,fontWeight: FontWeight.w700,)),
                      SizedBox(height: 5.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 130.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Bahasa',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(languageNameEleven)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Mendengar',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(mendengarSatuEleven)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Berbicara',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(berbicaraSatuEleven)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Membaca',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(membacaSatuEleven)
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
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Menulis',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(menulisSatuEleven)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 130.w) / 3,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      const Divider(),
                      SizedBox(height: 7.sp,),
                      Text('Kemampuan Bahasa Kedua',style: TextStyle(fontSize: 5.sp,fontWeight: FontWeight.w700,)),
                      SizedBox(height: 5.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 130.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Bahasa',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(languageNameTwelve)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Mendengar',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(mendengarDuaTwelve)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Berbicara',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(berbicaraDuaTwelve)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Membaca',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(membacaDuaTwelve)
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
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Menulis',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(menulisDuaTwelve)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 130.w) / 3,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      const Divider(),
                      SizedBox(height: 7.sp,),
                      Text('Kemampuan Bahasa Ketiga',style: TextStyle(fontSize: 5.sp,fontWeight: FontWeight.w700,)),
                      SizedBox(height: 5.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 130.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Bahasa',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(languageNameThirteen)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Mendengar',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(mendengarTigaThirteen)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Berbicara',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(berbicaraTigaThirteen)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Membaca',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(membacaTigaThirteen)
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
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Menulis',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(menulisTigaThirteen)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 130.w) / 3,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      const Divider(),
                      SizedBox(height: 7.sp,),
                      Text('Kemampuan Bahasa Keempat',style: TextStyle(fontSize: 5.sp,fontWeight: FontWeight.w700,)),
                      SizedBox(height: 5.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 130.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Bahasa',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(languageNameFourteen)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Mendengar',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(mendengarEmpatFourteen)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Berbicara',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(berbicaraEmpatFourteen)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Membaca',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(membacaEmpatFourteen)
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
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Menulis',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                Text(menulisEmpatFourteen)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 130.w) / 3,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                  Get.to(UpdateDataFive(employeeId: widget.employeeID));
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
                                  Get.to(EmployeeDetailSix(employeeID: widget.employeeID));
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