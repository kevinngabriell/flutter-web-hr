// ignore_for_file: non_constant_identifier_names, deprecated_member_use, prefer_const_constructors, use_build_context_synchronously, avoid_print, avoid_web_libraries_in_flutter
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Add%20New%20Employee/AddNewEmployeeOne.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Applicant/applicantdashboard.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:html' as html;
import 'dart:convert';

class DetailApplicant extends StatefulWidget {
  final String candidate_name;
  final String position_name;
  final String candidate_phone;
  final String candidate_email;
  final String candidate_surat_lamaran;
  final String candidate_ijazah;
  final String candidate_riwayat_hidup;
  final String job_ads;
  final String status_name;
  final String id_applicant;

  const DetailApplicant(this.candidate_name, this.position_name, this.candidate_phone, this.candidate_email, this.candidate_surat_lamaran, this.candidate_ijazah, this.candidate_riwayat_hidup, this.job_ads, this.status_name, this.id_applicant, {super.key});

  @override
  State<DetailApplicant> createState() => _DetailApplicantState();
}

class _DetailApplicantState extends State<DetailApplicant> {
  String? leaveoptions;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  bool isLoading = false;
  bool isInterview1 = false;
  bool isInterview2 = false;
  String positionName = '';
  String jobDesc = '';
  String criteria = '';
  String location = '';
  String genderName = '';
  String minUsia = '';
  String maksUsia = '';
  String tinggiBadan = '';
  String beratBadan= '';
  String fakultas = '';
  String jurusan = '';
  String ipk = '';
  String lamaPengalaman = '';
  String peran = '';
  String keahlianLain = '';
  String kualifikasiSerupa = '';
  String PIC = '';
  String rincianTugas = '';
  String catatnLain = '';
  String? selectedInterviewLocation;
  DateTime? TanggalInterview;
  String? JamInterview;
  int? selectedKejujuranValue;
  int? selectedKedisplinan;
  int? selectedKeaktifan;
  int? selectedKerjasama;
  int? selectedKomunikasi;
  int? selectedSosilisasi;
  int? selectedSemangatkerja;
  TextEditingController txtNotesInterview1 = TextEditingController();
  TextEditingController txtNotesInterview2 = TextEditingController();
  String? selectedInterviewLocationKedua;
  DateTime? TanggalInterviewKedua;
  String? JamInterviewKedua;


  @override
  void initState() {
    fetchInterviewSchedule();
    super.initState();
    fetchData();
    fetchDetailRequest();
    fetchHasilInterview();
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
  
  Future<void> fetchDetailRequest() async {
    try{
      setState(() {
        isLoading = true;
      });

      String apiUrl = "https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/requestemployee/getdetailneededemployee.php?request_id=${widget.job_ads}";

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        Map<String, dynamic> data = (responseData['Data'] as List).first;

        positionName = data['position_name'];
        jobDesc = data['job_desc'];
        criteria = data['criteria'];
        location = data['location'];
        genderName = data['gender_name'];
        minUsia = data['minimal_usia'];
        maksUsia = data['maksimal_usia'];
        tinggiBadan = data['tinggi_badan'];
        beratBadan = data['berat_badan'];
        fakultas = data['fakultas'];
        jurusan = data['jurusan'];
        ipk = data['ipk'];
        lamaPengalaman = data['lama_pengalaman'];
        peran = data['peran'];
        keahlianLain = data['keahlian_lain'];
        kualifikasiSerupa = data['kualifikasi_serupa'];
        PIC = data['PIC'];
        rincianTugas = data['rincian_tugas'];
        catatnLain = data['catatan_lain'];

      } else {

      }
    } catch (e){
      print('Exception during API call: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> interview(apllicantID, statusName, action) async {
    try{
      setState(() {
        isLoading = true;
      });

      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/requestemployee/interview.php';
      String employeeId = storage.read('employee_id').toString();
      if(action == 1){
        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            'applicant_id': apllicantID,
            'action' : action.toString(),
            'interview_date' : TanggalInterview.toString(),
            'interview_time' : JamInterview.toString(),
            'interview_location' : selectedInterviewLocation,
            'employee_id': employeeId
          }
        );

        if(response.statusCode == 200){
          showDialog(
            context: context, 
            builder: (context){
              return AlertDialog(
                title: Text('Sukses'),
                content: Text('Interview telah berhasil dijadwalkan'),
                actions: [
                  TextButton(
                    onPressed: (){
                      Get.to(ApplicantIndex());
                    }, 
                    child: Text('Oke')
                  )
                ],
              );
            }
          );
        } else {
          showDialog(
            context: context, 
            builder: (context){
              return AlertDialog(
                title: Text('Error'),
                content: Text(response.body),
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
      } else if (action == 2){
        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            'applicant_id': apllicantID,
            'action' : action.toString(),
            'result_one' : selectedKejujuranValue.toString(),
            'result_two' : selectedKedisplinan.toString(),
            'result_three' : selectedKeaktifan.toString(),
            'result_four': selectedKerjasama.toString(),
            'result_five' : selectedKomunikasi.toString(),
            'result_six' : selectedSosilisasi.toString(),
            'result_seven' : selectedSemangatkerja.toString(),
            'notes' : txtNotesInterview1.text,
          }
        );

        if(response.statusCode == 200){
          showDialog(
            context: context, 
            builder: (context){
              return AlertDialog(
                title: Text('Sukses'),
                content: Text('Hasil interview telah berhasil dimasukkan'),
                actions: [
                  TextButton(
                    onPressed: (){
                      setState(() {
                        Get.back();
                      });
                    }, 
                    child: Text('Oke')
                  )
                ],
              );
            }
          );
        } else {
          showDialog(
            context: context, 
            builder: (context){
              return AlertDialog(
                title: Text('Error'),
                content: Text(response.body),
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
      } else if (action == 4){
        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            'applicant_id': apllicantID,
            'action' : action.toString(),
            'interview_date' : TanggalInterviewKedua.toString(),
            'interview_time' : JamInterviewKedua.toString(),
            'interview_location' : selectedInterviewLocationKedua,
            'employee_id': employeeId
          }
        );

        if(response.statusCode == 200){
          showDialog(
            context: context, 
            builder: (context){
              return AlertDialog(
                title: Text('Sukses'),
                content: Text('Interview telah berhasil dijadwalkan'),
                actions: [
                  TextButton(
                    onPressed: (){
                      Get.to(ApplicantIndex());
                    }, 
                    child: Text('Oke')
                  )
                ],
              );
            }
          );
        } else {
          showDialog(
            context: context, 
            builder: (context){
              return AlertDialog(
                title: Text('Error'),
                content: Text(response.body),
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
      } else if (action == 3){
        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            'applicant_id': apllicantID,
            'action' : action.toString(),
            'sec_notes' : txtNotesInterview2.text,
          }
        );

        if(response.statusCode == 200){
          showDialog(
            context: context, 
            builder: (context){
              return AlertDialog(
                title: Text('Sukses'),
                content: Text('Hasil interview telah berhasil dimasukkan'),
                actions: [
                  TextButton(
                    onPressed: (){
                      setState(() {
                        Get.back();
                      });
                    }, 
                    child: Text('Oke')
                  )
                ],
              );
            }
          );
        } else {
          showDialog(
            context: context, 
            builder: (context){
              return AlertDialog(
                title: Text('Error'),
                content: Text(response.body),
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
      } else if (action == 5){
        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            'applicant_id': apllicantID,
            'action' : action.toString(),
            'employee_id': employeeId
          }
        );

        if(response.statusCode == 200){
          showDialog(
            context: context, 
            builder: (context){
              return AlertDialog(
                title: Text('Sukses'),
                content: Text('Status pelamar telah diperbaharui'),
                actions: [
                  TextButton(
                    onPressed: (){
                      Get.to(ApplicantIndex());
                    }, 
                    child: Text('Oke')
                  )
                ],
              );
            }
          );
        } else {
          showDialog(
            context: context, 
            builder: (context){
              return AlertDialog(
                title: Text('Error'),
                content: Text(response.body),
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
      } else if (action == 6){
        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            'applicant_id': apllicantID,
            'action' : action.toString(),
            'employee_id': employeeId
          }
        );

        if(response.statusCode == 200){
          showDialog(
            context: context, 
            builder: (context){
              return AlertDialog(
                title: Text('Sukses'),
                content: Text('Pelamar telah berhasil masuk ke perusahaan'),
                actions: [
                  TextButton(
                    onPressed: (){
                      Get.to(ApplicantIndex());
                    }, 
                    child: Text('Oke')
                  )
                ],
              );
            }
          );
        } else {
          showDialog(
            context: context, 
            builder: (context){
              return AlertDialog(
                title: Text('Error'),
                content: Text(response.body),
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
      }


    } catch (e){
      showDialog(
          context: context, 
          builder: (context){
            return AlertDialog(
              title: Text('Error'),
              content: Text(e.toString()),
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
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateLulusAdministrasi(apllicantID, statusName, action) async {
    try{
      setState(() {
        isLoading = true;
      });

      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/requestemployee/updateapplicantstatus.php';
      String employeeId = storage.read('employee_id').toString();

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'applicant_id': apllicantID,
          'status_name': statusName,
          'action' : action.toString(),
          'employee_id': employeeId
        }
      );

      if(response.statusCode == 200){
        showDialog(
          context: context, 
          builder: (context){
            return AlertDialog(
              title: Text('Sukses'),
              content: Text('Status pelamar telah berhasil diperbaharui'),
              actions: [
                TextButton(
                  onPressed: (){
                    Get.to(ApplicantIndex());
                  }, 
                  child: Text('Oke')
                )
              ],
            );
          }
        );
      } else {
        showDialog(
          context: context, 
          builder: (context){
            return AlertDialog(
              title: Text('Error'),
              content: Text(response.body),
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

    } catch (e){
      showDialog(
          context: context, 
          builder: (context){
            return AlertDialog(
              title: Text('Error'),
              content: Text(e.toString()),
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
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchInterviewSchedule() async {
    try{
      setState(() {
        isLoading = true;
      });

      String apiUrl = "https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/requestemployee/getinterviewschedule.php?id_applicant=${widget.id_applicant}";
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        Map<String, dynamic> data = (responseData['Data'] as List).first;

        setState(() {
          TanggalInterview = DateTime.parse(data['interview_date']);
          JamInterview = data['interview_time'];
          selectedInterviewLocation = data['interview_location'];
          TanggalInterviewKedua = DateTime.parse(data['interview_date_2']);
          JamInterviewKedua = data['interview_time_2'];
          selectedInterviewLocationKedua = data['interview_location_2'];
        });

      } else {
        selectedInterviewLocation = '-';
      }
    } catch (e){
      print('Exception during API call: $e');
      selectedInterviewLocation = 'The Smith, Alam Sutera';
      selectedInterviewLocationKedua = 'The Smith, Alam Sutera';
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchHasilInterview() async {
    try{
      isLoading = true;

      String apiURL = "https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/requestemployee/getinterviewanswerone.php?id_applicant=${widget.id_applicant}";
      final response = await http.get(Uri.parse(apiURL));
      // print(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        Map<String, dynamic> data = responseData['Data'];

        selectedKejujuranValue = int.tryParse(data['hasilPertama'].toString()) ?? 0;
        selectedKedisplinan  = int.tryParse(data['hasilKedua'].toString()) ?? 0;
        selectedKeaktifan  = int.tryParse(data['hasilKetiga'].toString()) ?? 0;
        selectedKerjasama = int.tryParse(data['hasilKeempat'].toString()) ?? 0;
        selectedKomunikasi  = int.tryParse(data['hasilKelima'].toString()) ?? 0;
        selectedSosilisasi  = int.tryParse(data['hasilKeenam'].toString()) ?? 0;
        selectedSemangatkerja  = int.tryParse(data['hasilKetujuh'].toString()) ?? 0;
        txtNotesInterview1.text = data['hasilKedelapan'];
        txtNotesInterview2.text = data['hasilKesembilan'];
        isInterview1 = true;
        if(txtNotesInterview2.text != ''){
          isInterview2 = true;
        }
      } else {

      }
    } finally {
      if(selectedKejujuranValue == 0){
          selectedKejujuranValue = 11;
          selectedKedisplinan = 21;
          selectedKeaktifan = 31;
          selectedKerjasama = 41;
          selectedKomunikasi = 51;
          selectedSosilisasi = 61;
          selectedSemangatkerja = 71;
        }
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
          body: isLoading ? CircularProgressIndicator() : SingleChildScrollView(
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 90.w),
                              child: Card(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 7.sp,),
                                    Center(
                                      child: Text('Identitas Pelamar', style: TextStyle(
                                        fontSize: 5.sp,
                                        fontWeight: FontWeight.w600,
                                      )),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 13.sp, right: 13.sp, top: 8.sp),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Nama', style: TextStyle(
                                                  fontSize: 4.sp,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                              SizedBox(height: 5.h,),
                                              Text(widget.candidate_name)
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Nomor Telepon', style: TextStyle(
                                                  fontSize: 4.sp,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                              SizedBox(height: 5.h,),
                                              Text(widget.candidate_phone)
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Email', style: TextStyle(
                                                  fontSize: 4.sp,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                              SizedBox(height: 5.h,),
                                              Text(widget.candidate_email)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.sp, right: 13.sp, top: 10.sp, bottom: 8.sp),
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height / 5,
                                        child: ListView.builder(
                                          itemCount: 3,
                                          itemBuilder: (context, index) {
                                            // Define the document names and URLs
                                            List<String> documentNames = ['Surat Lamaran', 'Ijazah', 'Riwayat Hidup'];
                                            List<String> documentUrls = [
                                              widget.candidate_surat_lamaran,
                                              widget.candidate_ijazah,
                                              widget.candidate_riwayat_hidup
                                            ];
                                      
                                            // Check to ensure the index is within bounds for documentUrls and documentNames
                                            assert(index < documentNames.length && index < documentUrls.length);
                                      
                                            return ListTile(
                                              title: Text(documentNames[index]),
                                              trailing: GestureDetector(
                                                onTap: () {
                                                  final url = 'https://kinglabindonesia.com/KinglabJobPortal/Document/${documentUrls[index]}';
                                                  // Open the URL in a new tab
                                                  html.window.open(url, '_blank');
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius: BorderRadius.all(Radius.circular(8))
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(2.sp),
                                                    child: Text('Download', style: TextStyle(fontSize: 4.sp, color: Colors.white)),
                                                  )
                                                )
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  ]
                                ),
                              )
                            )
                          ]
                        ),
                        SizedBox(height: 9.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                              child: SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 2,
                                child: Padding(
                                  padding: EdgeInsets.all(7.sp),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text('Kualifikasi', style: TextStyle(
                                          fontSize: 5.sp,
                                          fontWeight: FontWeight.w600,
                                        )),
                                      ),
                                      SizedBox(height: 10.sp,),
                                      Text('Posisi', style: TextStyle(
                                        fontSize: 4.sp,
                                        fontWeight: FontWeight.w600,
                                      )),
                                      Text(positionName),
                                      SizedBox(height: 10.sp,),
                                      Text('Deskripsi Pekerjaan', style: TextStyle(
                                        fontSize: 4.sp,
                                        fontWeight: FontWeight.w600,
                                      )),
                                      Text(jobDesc),
                                      SizedBox(height: 10.sp,),
                                      Text('Kriteria', style: TextStyle(
                                        fontSize: 4.sp,
                                        fontWeight: FontWeight.w600,
                                      )),
                                      Text(criteria),
                                      SizedBox(height: 10.sp,),
                                      Text('Lokasi', style: TextStyle(
                                        fontSize: 4.sp,
                                        fontWeight: FontWeight.w600,
                                      )),
                                      Text(location),
                                      SizedBox(height: 10.sp,),
                                      Row( 
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: (MediaQuery.of(context).size.width / 4) / 2,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Jenis Kelamin', style: TextStyle(
                                                  fontSize: 4.sp,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                                Text(genderName),
                                                SizedBox(height: 10.sp,),
                                                Text('Minimal Usia', style: TextStyle(
                                                  fontSize: 4.sp,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                                Text(minUsia),
                                                SizedBox(height: 10.sp,),
                                                Text('Maksimal Usia', style: TextStyle(
                                                  fontSize: 4.sp,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                                Text(maksUsia),
                                                SizedBox(height: 10.sp,),
                                                Text('Tinggi Badan', style: TextStyle(
                                                  fontSize: 4.sp,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                                Text(tinggiBadan),
                                                SizedBox(height: 10.sp,),
                                                Text('Berat Badan', style: TextStyle(
                                                  fontSize: 4.sp,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                                Text(beratBadan)
                                              ],
                                            )
                                          ),
                                          SizedBox(
                                            width: (MediaQuery.of(context).size.width / 3) / 2,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Fakultas', style: TextStyle(
                                                  fontSize: 4.sp,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                                Text(fakultas),
                                                SizedBox(height: 10.sp,),
                                                Text('Jurusan', style: TextStyle(
                                                  fontSize: 4.sp,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                                Text(jurusan),
                                                SizedBox(height: 10.sp,),
                                                Text('IPK', style: TextStyle(
                                                  fontSize: 4.sp,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                                Text(ipk),
                                                SizedBox(height: 10.sp,),
                                                Text('Lama Pengalaman', style: TextStyle(
                                                  fontSize: 4.sp,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                                Text(lamaPengalaman),
                                                SizedBox(height: 10.sp,),
                                                Text('Peran', style: TextStyle(
                                                  fontSize: 4.sp,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                                Text(peran)
                                              ],
                                            )
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ),
                            ),
                            Card(
                              child: SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 2,
                                child: Padding(
                                  padding: EdgeInsets.all(7.sp),
                                  child: SizedBox(
                                    height: (MediaQuery.of(context).size.height - 10.h),
                                    child: Column(
                                      children: [
                                        Text('Cek Kriteria', style: TextStyle(
                                          fontSize: 5.sp,
                                          fontWeight: FontWeight.w600,
                                        )),
                                        SizedBox(height: 10.sp,),
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height,
                                          child: ListView.builder(
                                            itemCount: 3,
                                            itemBuilder: (context, index) {
                                              List<String> items = ['Usia', 'Pendidikan', 'Pengalaman'];
                                              List<bool> checked = [false, false, false];
                                              return CheckboxListTile(
                                                title: Text(items[index]),
                                                value: checked[index],
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    checked[index] = value!;
                                                  });
                                                }
                                              );
                                            }
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.sp,),
                        if(widget.status_name != 'Surat lamaran telah diterima')
                          Card(
                            child: Padding(
                              padding: EdgeInsets.all(7.sp),
                              child: Column(
                                children: [
                                  Text('Wawancara Pertama', style: TextStyle(
                                    fontSize: 5.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                  SizedBox(height: 7.sp,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Tanggal wawancara', style: TextStyle(
                                            fontSize: 4.sp,
                                            fontWeight: FontWeight.w600,
                                          )),
                                          SizedBox(height: 5.sp,),
                                          if(widget.status_name == 'Lulus tahap administrasi')
                                            SizedBox(
                                              width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                              height: (MediaQuery.of(context).size.height - 630.h),
                                              child: DateTimePicker(
                                                initialDate: TanggalInterview,
                                                type: DateTimePickerType.date,
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(2100),
                                                dateHintText: 'Masukkan tanggal wawancara',
                                                dateMask: 'd MMM yyyy',
                                                onChanged: (value) {
                                                  setState(() {
                                                    TanggalInterview = DateFormat('yyyy-MM-dd').parse(value);
                                                  });
                                                },
                                              ),
                                            ),
                                          if(widget.status_name == 'Interview pertama telah dijadwalkan' || widget.status_name == 'Lulus tahap wawancara pertama' || widget.status_name == 'Interview kedua telah dijadwalkan' || widget.status_name == 'Lulus tahap wawancara kedua' || widget.status_name == 'Diterima' )
                                            Text(DateFormat('dd MMM yyyy').format(TanggalInterview!))
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Jam wawancara', style: TextStyle(
                                            fontSize: 4.sp,
                                            fontWeight: FontWeight.w600,
                                          )),
                                          SizedBox(height: 5.sp,),
                                          if(widget.status_name == 'Lulus tahap administrasi')
                                            SizedBox(
                                              width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                              height: (MediaQuery.of(context).size.height - 630.h),
                                              child: DateTimePicker(
                                                type: DateTimePickerType.time,
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(2100),
                                                timeHintText: 'Masukkan jam wawancara',
                                                onChanged: (value) {
                                                  setState(() {
                                                    JamInterview = value.toString();
                                                  });
                                                },
                                              ),
                                            ),
                                          if(widget.status_name == 'Interview pertama telah dijadwalkan' || widget.status_name == 'Lulus tahap wawancara pertama' || widget.status_name == 'Interview kedua telah dijadwalkan' || widget.status_name == 'Lulus tahap wawancara kedua' || widget.status_name == 'Diterima' )
                                            Text(JamInterview!)
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Lokasi wawancara', style: TextStyle(
                                            fontSize: 4.sp,
                                            fontWeight: FontWeight.w600,
                                          )),
                                          SizedBox(height: 5.sp,),
                                          if(widget.status_name == 'Lulus tahap administrasi')
                                            SizedBox(
                                              width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                              height: (MediaQuery.of(context).size.height - 630.h),
                                              child: DropdownButtonFormField(
                                                value: selectedInterviewLocation,
                                                items: const [
                                                  DropdownMenuItem(
                                                    value: 'The Smith, Alam Sutera',
                                                    child: Text('The Smith, Alam Sutera')
                                                  ),
                                                  DropdownMenuItem(
                                                    value: 'Karawaci Office Park, Karawaci',
                                                    child: Text('Karawaci Office Park, Karawaci')
                                                  ),
                                                  DropdownMenuItem(
                                                    value: 'Online by Zoom',
                                                    child: Text('Online by Zoom')
                                                  )
                                                ], 
                                                onChanged: (value){
                                                  selectedInterviewLocation = value.toString();
                                                }
                                              )
                                            ),
                                          if(widget.status_name == 'Interview pertama telah dijadwalkan' || widget.status_name == 'Lulus tahap wawancara pertama' || widget.status_name == 'Interview kedua telah dijadwalkan' || widget.status_name == 'Lulus tahap wawancara kedua' || widget.status_name == 'Diterima' )
                                            Text(selectedInterviewLocation!)
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 15.sp,),
                                  Text('Wawancara Kedua', style: TextStyle(
                                    fontSize: 5.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                                  SizedBox(height: 7.sp,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Tanggal wawancara', style: TextStyle(
                                            fontSize: 4.sp,
                                            fontWeight: FontWeight.w600,
                                          )),
                                          SizedBox(height: 5.sp,),
                                          if(widget.status_name == 'Lulus tahap wawancara pertama' || widget.status_name == 'Interview pertama telah dijadwalkan' || widget.status_name == 'Lulus tahap administrasi')
                                            SizedBox(
                                              width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                              height: (MediaQuery.of(context).size.height - 630.h),
                                              child: DateTimePicker(
                                                initialDate: TanggalInterviewKedua,
                                                type: DateTimePickerType.date,
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(2100),
                                                dateHintText: 'Masukkan tanggal wawancara',
                                                dateMask: 'd MMM yyyy',
                                                onChanged: (value) {
                                                  setState(() {
                                                    TanggalInterviewKedua = DateFormat('yyyy-MM-dd').parse(value);
                                                  });
                                                },
                                              ),
                                            ),
                                          if(widget.status_name == 'Interview kedua telah dijadwalkan' || widget.status_name == 'Lulus tahap wawancara kedua' || widget.status_name == 'Diterima' )
                                            Text(DateFormat('dd MMM yyyy').format(TanggalInterviewKedua!))
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Jam wawancara', style: TextStyle(
                                            fontSize: 4.sp,
                                            fontWeight: FontWeight.w600,
                                          )),
                                          SizedBox(height: 5.sp,),
                                          if(widget.status_name == 'Lulus tahap wawancara pertama' || widget.status_name == 'Interview pertama telah dijadwalkan' || widget.status_name == 'Lulus tahap administrasi')
                                            SizedBox(
                                              width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                              height: (MediaQuery.of(context).size.height - 630.h),
                                              child: DateTimePicker(
                                                type: DateTimePickerType.time,
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(2100),
                                                timeHintText: 'Masukkan jam wawancara',
                                                onChanged: (value) {
                                                  setState(() {
                                                    JamInterviewKedua = value.toString();
                                                  });
                                                },
                                              ),
                                            ),
                                          if(widget.status_name == 'Interview kedua telah dijadwalkan' || widget.status_name == 'Lulus tahap wawancara kedua'|| widget.status_name == 'Diterima' )
                                            Text(JamInterviewKedua!)
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Lokasi wawancara', style: TextStyle(
                                            fontSize: 4.sp,
                                            fontWeight: FontWeight.w600,
                                          )),
                                          SizedBox(height: 5.sp,),
                                          if(widget.status_name == 'Lulus tahap wawancara pertama' || widget.status_name == 'Interview pertama telah dijadwalkan' || widget.status_name == 'Lulus tahap administrasi')
                                            SizedBox(
                                              width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                              height: (MediaQuery.of(context).size.height - 630.h),
                                              child: DropdownButtonFormField(
                                                value: selectedInterviewLocationKedua,
                                                items: const [
                                                  DropdownMenuItem(
                                                    value: 'The Smith, Alam Sutera',
                                                    child: Text('The Smith, Alam Sutera')
                                                  ),
                                                  DropdownMenuItem(
                                                    value: 'Karawaci Office Park, Karawaci',
                                                    child: Text('Karawaci Office Park, Karawaci')
                                                  ),
                                                  DropdownMenuItem(
                                                    value: 'Online by Zoom',
                                                    child: Text('Online by Zoom')
                                                  )
                                                ], 
                                                onChanged: (value){
                                                  selectedInterviewLocationKedua = value.toString();
                                                }
                                              )
                                            ),
                                          if(widget.status_name == 'Interview kedua telah dijadwalkan' || widget.status_name == 'Lulus tahap wawancara kedua'|| widget.status_name == 'Diterima'  )
                                            Text(selectedInterviewLocationKedua!)
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        if(widget.status_name != 'Surat lamaran telah diterima')
                          SizedBox(height: 10.sp,),
                        if(widget.status_name == 'Interview pertama telah dijadwalkan' || widget.status_name == 'Lulus tahap wawancara pertama' || widget.status_name == 'Interview kedua telah dijadwalkan' || widget.status_name == 'Lulus tahap wawancara kedua'|| widget.status_name == 'Diterima'  )
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Card(
                                child: SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 2,
                                child: Padding(
                                  padding: EdgeInsets.all(7.sp),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text('Hasil Wawancara Pertama', style: TextStyle(
                                          fontSize: 5.sp,
                                          fontWeight: FontWeight.w600,
                                        )),
                                      ),
                                      SizedBox(height: 15.h,),
                                      Text('Kejujuran', style: TextStyle(
                                        fontSize: 4.sp,
                                        fontWeight: FontWeight.w600,
                                      )),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 100.w) / 2,
                                        child: DropdownButtonFormField(
                                          value: selectedKejujuranValue,
                                          items: const [
                                            DropdownMenuItem(
                                              value: 11,
                                              child: Text('1')
                                            ),
                                            DropdownMenuItem(
                                              value: 12,
                                              child: Text('2')
                                            ),
                                            DropdownMenuItem(
                                              value: 13,
                                              child: Text('3')
                                            ),
                                            DropdownMenuItem(
                                              value: 14,
                                              child: Text('4')
                                            ),
                                            DropdownMenuItem(
                                              value: 15,
                                              child: Text('5')
                                            ),
                                            DropdownMenuItem(
                                              value: 16,
                                              child: Text('6')
                                            ),
                                            DropdownMenuItem(
                                              value: 17,
                                              child: Text('7')
                                            ),
                                            DropdownMenuItem(
                                              value: 18,
                                              child: Text('8')
                                            ),
                                            DropdownMenuItem(
                                              value: 19,
                                              child: Text('9')
                                            ),
                                            DropdownMenuItem(
                                              value: 10,
                                              child: Text('10')
                                            )
                                          ], 
                                          onChanged: (value){
                                            selectedKejujuranValue = value!;
                                          }
                                        ),
                                      ),
                                      SizedBox(height: 20.h,),
                                      Text('Kedisplinan', style: TextStyle(
                                        fontSize: 4.sp,
                                        fontWeight: FontWeight.w600,
                                      )),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 100.w) / 2,
                                        child: DropdownButtonFormField(
                                          value: selectedKedisplinan,
                                          items: const [
                                            DropdownMenuItem(
                                              value: 21,
                                              child: Text('1')
                                            ),
                                            DropdownMenuItem(
                                              value: 22,
                                              child: Text('2')
                                            ),
                                            DropdownMenuItem(
                                              value: 23,
                                              child: Text('3')
                                            ),
                                            DropdownMenuItem(
                                              value: 24,
                                              child: Text('4')
                                            ),
                                            DropdownMenuItem(
                                              value: 25,
                                              child: Text('5')
                                            ),
                                            DropdownMenuItem(
                                              value: 26,
                                              child: Text('6')
                                            ),
                                            DropdownMenuItem(
                                              value: 27,
                                              child: Text('7')
                                            ),
                                            DropdownMenuItem(
                                              value: 28,
                                              child: Text('8')
                                            ),
                                            DropdownMenuItem(
                                              value: 29,
                                              child: Text('9')
                                            ),
                                            DropdownMenuItem(
                                              value: 20,
                                              child: Text('10')
                                            )
                                          ], 
                                          onChanged: (value){
                                            selectedKedisplinan = value!;
                                          }
                                        ),
                                      ),
                                      SizedBox(height: 20.h,),
                                      Text('Keaktifan', style: TextStyle(
                                        fontSize: 4.sp,
                                        fontWeight: FontWeight.w600,
                                      )),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 100.w) / 2,
                                        child: DropdownButtonFormField(
                                          value: selectedKeaktifan,
                                          items: const [
                                            DropdownMenuItem(
                                              value: 31,
                                              child: Text('1')
                                            ),
                                            DropdownMenuItem(
                                              value: 32,
                                              child: Text('2')
                                            ),
                                            DropdownMenuItem(
                                              value: 33,
                                              child: Text('3')
                                            ),
                                            DropdownMenuItem(
                                              value: 34,
                                              child: Text('4')
                                            ),
                                            DropdownMenuItem(
                                              value: 35,
                                              child: Text('5')
                                            ),
                                            DropdownMenuItem(
                                              value: 36,
                                              child: Text('6')
                                            ),
                                            DropdownMenuItem(
                                              value: 37,
                                              child: Text('7')
                                            ),
                                            DropdownMenuItem(
                                              value: 38,
                                              child: Text('8')
                                            ),
                                            DropdownMenuItem(
                                              value: 39,
                                              child: Text('9')
                                            ),
                                            DropdownMenuItem(
                                              value: 30,
                                              child: Text('10')
                                            )
                                          ], 
                                          onChanged: (value){
                                            selectedKeaktifan = value!;
                                          }
                                        ),
                                      ),
                                      SizedBox(height: 20.h,),
                                      Text('Kerjasama', style: TextStyle(
                                        fontSize: 4.sp,
                                        fontWeight: FontWeight.w600,
                                      )),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 100.w) / 2,
                                        child: DropdownButtonFormField(
                                          value: selectedKerjasama,
                                          items: const [
                                            DropdownMenuItem(
                                              value: 41,
                                              child: Text('1')
                                            ),
                                            DropdownMenuItem(
                                              value: 42,
                                              child: Text('2')
                                            ),
                                            DropdownMenuItem(
                                              value: 43,
                                              child: Text('3')
                                            ),
                                            DropdownMenuItem(
                                              value: 44,
                                              child: Text('4')
                                            ),
                                            DropdownMenuItem(
                                              value: 45,
                                              child: Text('5')
                                            ),
                                            DropdownMenuItem(
                                              value: 46,
                                              child: Text('6')
                                            ),
                                            DropdownMenuItem(
                                              value: 47,
                                              child: Text('7')
                                            ),
                                            DropdownMenuItem(
                                              value: 48,
                                              child: Text('8')
                                            ),
                                            DropdownMenuItem(
                                              value: 49,
                                              child: Text('9')
                                            ),
                                            DropdownMenuItem(
                                              value: 40,
                                              child: Text('10')
                                            )
                                          ], 
                                          onChanged: (value){
                                            selectedKerjasama = value!;
                                          }
                                        ),
                                      ),
                                      SizedBox(height: 20.h,),
                                      Text('Komunikasi', style: TextStyle(
                                        fontSize: 4.sp,
                                        fontWeight: FontWeight.w600,
                                      )),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 100.w) / 2,
                                        child: DropdownButtonFormField(
                                          value: selectedKomunikasi,
                                          items: const [
                                            DropdownMenuItem(
                                              value: 51,
                                              child: Text('1')
                                            ),
                                            DropdownMenuItem(
                                              value: 52,
                                              child: Text('2')
                                            ),
                                            DropdownMenuItem(
                                              value: 53,
                                              child: Text('3')
                                            ),
                                            DropdownMenuItem(
                                              value: 54,
                                              child: Text('4')
                                            ),
                                            DropdownMenuItem(
                                              value: 55,
                                              child: Text('5')
                                            ),
                                            DropdownMenuItem(
                                              value: 56,
                                              child: Text('6')
                                            ),
                                            DropdownMenuItem(
                                              value: 57,
                                              child: Text('7')
                                            ),
                                            DropdownMenuItem(
                                              value: 58,
                                              child: Text('8')
                                            ),
                                            DropdownMenuItem(
                                              value: 59,
                                              child: Text('9')
                                            ),
                                            DropdownMenuItem(
                                              value: 50,
                                              child: Text('10')
                                            )
                                          ], 
                                          onChanged: (value){
                                            selectedKomunikasi = value!;
                                          }
                                        ),
                                      ),
                                      SizedBox(height: 20.h,),
                                      Text('Sosialisasi', style: TextStyle(
                                        fontSize: 4.sp,
                                        fontWeight: FontWeight.w600,
                                      )),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 100.w) / 2,
                                        child: DropdownButtonFormField(
                                          value: selectedSosilisasi,
                                          items: const [
                                            DropdownMenuItem(
                                              value: 61,
                                              child: Text('1')
                                            ),
                                            DropdownMenuItem(
                                              value: 62,
                                              child: Text('2')
                                            ),
                                            DropdownMenuItem(
                                              value: 63,
                                              child: Text('3')
                                            ),
                                            DropdownMenuItem(
                                              value: 64,
                                              child: Text('4')
                                            ),
                                            DropdownMenuItem(
                                              value: 65,
                                              child: Text('5')
                                            ),
                                            DropdownMenuItem(
                                              value: 66,
                                              child: Text('6')
                                            ),
                                            DropdownMenuItem(
                                              value: 67,
                                              child: Text('7')
                                            ),
                                            DropdownMenuItem(
                                              value: 68,
                                              child: Text('8')
                                            ),
                                            DropdownMenuItem(
                                              value: 69,
                                              child: Text('9')
                                            ),
                                            DropdownMenuItem(
                                              value: 60,
                                              child: Text('10')
                                            )
                                          ], 
                                          onChanged: (value){
                                            selectedSosilisasi = value!;
                                          }
                                        ),
                                      ),
                                      SizedBox(height: 20.h,),
                                      Text('Semangat Kerja', style: TextStyle(
                                        fontSize: 4.sp,
                                        fontWeight: FontWeight.w600,
                                      )),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 100.w) / 2,
                                        child: DropdownButtonFormField(
                                          value: selectedSemangatkerja,
                                          items: const [
                                            DropdownMenuItem(
                                              value: 71,
                                              child: Text('1')
                                            ),
                                            DropdownMenuItem(
                                              value: 72,
                                              child: Text('2')
                                            ),
                                            DropdownMenuItem(
                                              value: 73,
                                              child: Text('3')
                                            ),
                                            DropdownMenuItem(
                                              value: 74,
                                              child: Text('4')
                                            ),
                                            DropdownMenuItem(
                                              value: 75,
                                              child: Text('5')
                                            ),
                                            DropdownMenuItem(
                                              value: 76,
                                              child: Text('6')
                                            ),
                                            DropdownMenuItem(
                                              value: 77,
                                              child: Text('7')
                                            ),
                                            DropdownMenuItem(
                                              value: 78,
                                              child: Text('8')
                                            ),
                                            DropdownMenuItem(
                                              value: 79,
                                              child: Text('9')
                                            ),
                                            DropdownMenuItem(
                                              value: 70,
                                              child: Text('10')
                                            )
                                          ], 
                                          onChanged: (value){
                                            selectedSemangatkerja = value!;
                                          }
                                        ),
                                      ),
                                      SizedBox(height: 20.h,),
                                      Text('Catatan', style: TextStyle(
                                        fontSize: 4.sp,
                                        fontWeight: FontWeight.w600,
                                      )),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 100.w) / 2,
                                        child: TextFormField(
                                          controller: txtNotesInterview1,
                                          decoration: InputDecoration(
                                            hintText: 'Catatan wawancara'
                                          ),
                                          maxLines: 4,
                                        ),
                                      ),
                                      SizedBox(height: 20.sp,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          if(isInterview1 == false)
                                            ElevatedButton(
                                              onPressed: (){
                                                interview(widget.id_applicant, widget.status_name, 2);
                                              }, 
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                alignment: Alignment.center,
                                                minimumSize: Size(30.w, 55.h),
                                                foregroundColor: const Color(0xFFFFFFFF),
                                                backgroundColor: Colors.green,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                              ),
                                              child: Text('Simpan')
                                            ),
                                        ],
                                      )
                                    ]
                                  )
                                ))
                              ),
                              Card(
                                child: SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 2,
                                child: Padding(
                                  padding: EdgeInsets.all(15.sp),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text('Hasil Wawancara Kedua', style: TextStyle(
                                          fontSize: 5.sp,
                                          fontWeight: FontWeight.w600,
                                        )),
                                      ),
                                      SizedBox(height: 15.h,),
                                      Text('Catatan', style: TextStyle(
                                        fontSize: 4.sp,
                                        fontWeight: FontWeight.w600,
                                      )),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 100.w) / 2,
                                        child: TextFormField(
                                          controller: txtNotesInterview2,
                                          decoration: InputDecoration(
                                            hintText: 'Catatan wawancara'
                                          ),
                                          maxLines: 4,
                                        ),
                                      ),
                                      SizedBox(height: 20.sp,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          if(isInterview2 == false)
                                            ElevatedButton(
                                              onPressed: (){
                                                interview(widget.id_applicant, widget.status_name, 3);
                                              }, 
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                alignment: Alignment.center,
                                                minimumSize: Size(30.w, 55.h),
                                                foregroundColor: const Color(0xFFFFFFFF),
                                                backgroundColor: Colors.green,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                              ),
                                              child: Text('Simpan')
                                            ),
                                        ],
                                      )
                                    ]
                                  )
                                ))
                              ),
                            ]
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if(widget.status_name == 'Diterima')
                              ElevatedButton(
                                onPressed: (){
                                  Get.to(AddNewEmployeeFirst());
                                }, 
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  alignment: Alignment.center,
                                  minimumSize: Size(30.w, 55.h),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Text('Pendataan karyawan baru')
                              ),
                            if(widget.status_name != 'Diterima')
                              ElevatedButton(
                                onPressed: (){
                                  updateLulusAdministrasi(widget.id_applicant, widget.status_name, 0);
                                }, 
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  alignment: Alignment.center,
                                  minimumSize: Size(30.w, 55.h),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Text('Gugur')
                              ),
                            SizedBox(width: 4.w,),
                            if(widget.status_name == 'Surat lamaran telah diterima')
                              ElevatedButton(
                                onPressed: (){
                                  updateLulusAdministrasi(widget.id_applicant, widget.status_name, 1);
                                }, 
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  alignment: Alignment.center,
                                  minimumSize: Size(30.w, 55.h),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Text('Lulus administrasi')
                              ),
                            if(widget.status_name == 'Interview pertama telah dijadwalkan')
                              ElevatedButton(
                                onPressed: (){
                                  updateLulusAdministrasi(widget.id_applicant, widget.status_name, 2);
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  alignment: Alignment.center,
                                  minimumSize: Size(30.w, 55.h),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ), 
                                child: Text('Lulus interview pertama')
                              ),
                            if(widget.status_name == 'Lulus tahap administrasi')
                              ElevatedButton(
                                onPressed: (){
                                  interview(widget.id_applicant, widget.status_name, 1);
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  alignment: Alignment.center,
                                  minimumSize: Size(30.w, 55.h),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ), 
                                child: Text('Jadwalkan wawancara')
                              ),
                            if(widget.status_name == 'Lulus tahap wawancara pertama')
                              ElevatedButton(
                                onPressed: (){
                                  interview(widget.id_applicant, widget.status_name, 4);
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  alignment: Alignment.center,
                                  minimumSize: Size(30.w, 55.h),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ), 
                                child: Text('Jadwalkan wawancara kedua')
                              ),
                            if(widget.status_name == 'Interview kedua telah dijadwalkan')
                              ElevatedButton(
                                onPressed: (){
                                  interview(widget.id_applicant, widget.status_name, 5);
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  alignment: Alignment.center,
                                  minimumSize: Size(30.w, 55.h),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ), 
                                child: Text('Lulus interview kedua')
                              ),
                            if(widget.status_name == 'Lulus tahap wawancara kedua')
                              ElevatedButton(
                                onPressed: (){
                                  interview(widget.id_applicant, widget.status_name, 6);
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  alignment: Alignment.center,
                                  minimumSize: Size(30.w, 55.h),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ), 
                                child: Text('Diterima')
                              ),
                          ],
                        ),
                        SizedBox(height: 50.sp,),
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