import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/EmployeeList.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class EmployeeDetailSeven extends StatefulWidget {
  final String employeeID;
  const EmployeeDetailSeven({super.key, required this.employeeID});

  @override
  State<EmployeeDetailSeven> createState() => _EmployeeDetailSevenState();
}

class _EmployeeDetailSevenState extends State<EmployeeDetailSeven> {
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  bool isLoading = false;

  String jobSourceName = '-';
  String jobSourceAnswerExp = '-';
  String contactLastComp = '-';
  String positionApplied = '-';
  String positionAlternate = '-';
  String expectedSalary = '-';
  String hubunganKerjaName = '-';
  String isEverAward = '-';
  String isEverAwardExp = '-';
  String hobbyAnswer = '-';
  String isEverOrg = '-';
  String isEverOrgExp = '-';
  String isDayUnv = '-';
  String isDayUnvExp = '-';
  String isAnySim = '-';
  String simAEnd = '-';
  String simCEnd = '-';
  String isFired = '-';
  String isFiredExp = '-';
  String isJailed = '-';
  String isJailedExp = '-';
  String isSick = '-';
  String isSickExp = '-';
  String isSmoke = '-';

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDetailData();
  }

  Future<void> fetchDetailData() async {
    try{
      isLoading = true;

      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployee.php?action=20&employee_id=${widget.employeeID}';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        var data = responseData['Data'][0];

        setState(() {
          jobSourceName = data['job_source_name'] ?? '-';
          jobSourceAnswerExp = data['job_source_answer_exp'] ?? '-';
          contactLastComp = data['contact_last_comp'] == '1' ? 'Ya' : 'Tidak';
          positionApplied = data['position_applied'] ?? '-';
          positionAlternate = data['position_alternate'] ?? '-';
          expectedSalary = data['expected_salary'] ?? '-';
          hubunganKerjaName = data['hubungan_kerja_name'] ?? '-';
          isEverAward = data['is_ever_award'] == '1' ? 'Ya' : 'Tidak';
          isEverAwardExp = data['is_ever_award_exp'] ?? '-';
          hobbyAnswer = data['hobby_answer'] ?? '-';
          isEverOrg = data['is_ever_org'] == '1' ? 'Ya' : 'Tidak';
          isEverOrgExp = data['is_ever_org_exp'] ?? '-';
          isDayUnv = data['is_day_unv'] == '1' ? 'Ya' : 'Tidak';
          isDayUnvExp = data['is_day_unv_exp'] ?? '-';
          isAnySim = data['is_any_sim'] == '1' ? 'Ya' : 'Tidak';
          simAEnd = data['sim_a_end'] ?? '-';
          simCEnd = data['sim_c_end'] ?? '-';
          isFired = data['is_fired'] == '1' ? 'Ya' : 'Tidak';
          isFiredExp = data['is_fired_exp'] ?? '-';
          isJailed = data['is_jailed'] == '1' ? 'Ya' : 'Tidak';
          isJailedExp = data['is_jailed_exp'] ?? '-';
          isSick = data['is_sick'] == '1' ? 'Ya' : 'Tidak';
          isSickExp = data['is_sick_exp'] ?? '-';
          isSmoke = data['is_smoke'] == '1' ? 'Ya' : 'Tidak';
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
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
                        LaporanNonActive(positionId: positionId.toString(),),
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
                      Text('Dari mana anda mengetahui tentang lowongan ini ?',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                      SizedBox(height: 2.sp,),
                      Text('$jobSourceName, $jobSourceAnswerExp'),
                      SizedBox(height: 7.sp,),
                      Text("Bolehkah kami menghubungi perusahaan sebelumnya tempat Anda bekerja?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 2.sp,),
                      Text(contactLastComp),
                      SizedBox(height: 7.sp,),
                      Text("Posisi apa yang anda lamar?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 2.sp,),
                      Text(positionApplied),
                      SizedBox(height: 7.sp,),
                      Text("Apa posisi alternatif yang anda inginkan?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 2.sp,),
                      Text(positionAlternate),
                      SizedBox(height: 7.sp,),
                      Text("Berapa gaji yang anda harapkan?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 2.sp,),
                      Text(expectedSalary),
                      SizedBox(height: 7.sp,),
                      Text("Apa hubungan kerja yang anda inginkan?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                       SizedBox(height: 2.sp,),
                      Text(hubunganKerjaName),
                      SizedBox(height: 7.sp,),
                      Text("Apakah anda pernah mendapatkan prestasi?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 2.sp,),
                      Text('$isEverAward, $isEverAwardExp'),
                      SizedBox(height: 7.sp,),
                      Text("Apa hobby, olahraga atau minat anda?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 2.sp,),
                      Text(hobbyAnswer),
                      SizedBox(height: 7.sp,),
                      Text("Apakah anda pernah menjadi bagian dari sebuah organisasi?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 2.sp,),
                      Text('$isEverOrg, $isEverOrgExp'),
                      SizedBox(height: 7.sp,),
                       Text("Apakah ada hari tertentu anda tidak dapat bekerja?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 2.sp,),
                      Text('$isDayUnv, $isDayUnvExp'),
                      SizedBox(height: 7.sp,),
                       Text("Apakah anda memiliki SIM?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 2.sp,),
                      Text('$isAnySim, masa berakhir sim A : $simAEnd, masa berakhir sim C : $simCEnd'),
                      SizedBox(height: 7.sp,),
                       Text("Apakah anda diberhentikan dari perusahaan sebelumnya?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 2.sp,),
                      Text('$isFired, $isFiredExp'),
                      SizedBox(height: 7.sp,),
                       Text("Apakah anda pernah dihukum?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 2.sp,),
                      Text('$isJailed, $isJailedExp'),
                      SizedBox(height: 7.sp,),
                       Text("Apakah anda mempunyai penyakit/cacat yang dapat menganggu aktivitas?",
                        style: TextStyle(
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      SizedBox(height: 2.sp,),
                      Text('$isSick, $isSickExp'),
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
                                  Get.to(const EmployeeListPage());
                                }, 
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(50.w, 55.h),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: const Color(0xff4ec3fc),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Kembali ke list karyawan')
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