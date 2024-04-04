// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Applicant/detailapplicant.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class ApplicantIndex extends StatefulWidget {
  const ApplicantIndex({super.key});

  @override
  State<ApplicantIndex> createState() => _ApplicantIndexState();
}

class _ApplicantIndexState extends State<ApplicantIndex> {
  String? leaveoptions;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  bool isLoading = false;
  Map<String, dynamic> statisticData = {};
  String angkaSemua = '';
  String angkaProses = '';
  String angkaDiterima = '';
  String angkaDitolak = '';

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchCandidates();
    fetchStatistics();
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

  Future<List<dynamic>> fetchCandidates() async {
    isLoading = true;
    const url = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/requestemployee/getlistapplicant.php';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      isLoading = false;
      return data['Data'];
    } else {
      isLoading = false;
      throw Exception('Failed to load candidates');
    }
  }

  Future<void> fetchStatistics() async {
    try{
      isLoading = true;
      final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/requestemployee/applicantstatistic.php'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['StatusCode'] == 200) {
          setState(() {
            statisticData = json.decode(response.body)['Data'];
            angkaSemua = statisticData['semuaPelamar'];
            angkaProses = statisticData['proses'];
            angkaDiterima = statisticData['diterima'];
            angkaDitolak = statisticData['ditolak'];
          });
        }
      } else {
         print('Failed to fetch data');
      }

    } catch (e){
       print('Failed to fetch data');
    } finally {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    var employeeId = storage.read('employee_id');
    var photo = storage.read('photo');
    var positionId = storage.read('position_id');

    return MaterialApp(
      title: "Pelamar Karyawan",
      home: SafeArea(
        child: Scaffold(
          body: isLoading ? const CircularProgressIndicator() : SingleChildScrollView(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                              shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12))),
                              color: Colors.white,
                              shadowColor: Colors.black,
                              child: SizedBox(
                                width: (MediaQuery.of(context).size.width - 125.w) / 4,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 7.sp, top: 5.sp, bottom: 5.sp, right: 7.sp),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Jumlah Pelamar',
                                            style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w400,)
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(angkaSemua.toString(),
                                            style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ),
                            Card(
                              shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12))),
                              color: Colors.white,
                              shadowColor: Colors.black,
                              child: SizedBox(
                                width: (MediaQuery.of(context).size.width - 125.w) / 4,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 7.sp, top: 5.sp, bottom: 5.sp, right: 7.sp),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Dalam Proses',
                                            style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w400,)
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(angkaProses.toString(),
                                            style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ),
                            Card(
                              shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12))),
                              color: Colors.white,
                              shadowColor: Colors.black,
                              child: SizedBox(
                                width: (MediaQuery.of(context).size.width - 125.w) / 4,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 7.sp, top: 5.sp, bottom: 5.sp, right: 7.sp),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Diterima',
                                            style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w400,)
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(angkaDiterima.toString(),
                                            style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ),
                            Card(
                              shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12))),
                              color: Colors.white,
                              shadowColor: Colors.black,
                              child: SizedBox(
                                width: (MediaQuery.of(context).size.width - 125.w) / 4,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 7.sp, top: 5.sp, bottom: 5.sp, right: 7.sp),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Ditolak',
                                            style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w400,)
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(angkaDitolak.toString(),
                                            style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ),
                          ],
                        ),
                        SizedBox(height: 10.sp,),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: FutureBuilder<List<dynamic>>(
                            future: fetchCandidates(),
                            builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text("Error: ${snapshot.error}"));
                              } else if (snapshot.hasData) {
                                return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    var candidate = snapshot.data![index];
                                    String statusname = candidate['status_name'];
                                    if(statusname == 'Surat lamaran telah diterima'){
                                      statusname = 'Lamaran Diterima';
                                    }
                                    return ListTile(
                                      title: Text(candidate['candidate_name']),
                                      subtitle: Text('${candidate['position_name']}'),
                                      trailing: GestureDetector(
                                        onTap: () {
                                          Get.to(DetailApplicant(candidate['candidate_name'], candidate['position_name'], candidate['candidate_phone'], candidate['candidate_email'], candidate['candidate_surat_lamaran'], candidate['candidate_ijazah'], candidate['candidate_riwayat_hidup'], candidate['job_ads'], candidate['status_name'], candidate['id_applicant']));
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.all(Radius.circular(8))
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(2.sp),
                                            child: Text(statusname, style: TextStyle(fontSize: 4.sp, color: Colors.white),),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        Get.to(DetailApplicant(candidate['candidate_name'], candidate['position_name'], candidate['candidate_phone'], candidate['candidate_email'], candidate['candidate_surat_lamaran'], candidate['candidate_ijazah'], candidate['candidate_riwayat_hidup'], candidate['job_ads'], candidate['status_name'], candidate['id_applicant']));
                                      },
                                    );
                                  },
                                );
                              } else {
                                return const Center(child: Text('No data available'));
                              }
                            }
                          ),
                        )
                      ]
                    )
                  )
                )
              ]
            )
          )
        )
      )
    );
  }
}