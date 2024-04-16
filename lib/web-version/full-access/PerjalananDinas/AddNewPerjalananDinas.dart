// ignore_for_file: avoid_print, use_build_context_synchronously, file_names

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:hr_systems_web/web-version/full-access/PerjalananDinas/PerjalananDinasIndex.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddNewPerjalananDinas extends StatefulWidget {
  const AddNewPerjalananDinas({super.key});

  @override
  State<AddNewPerjalananDinas> createState() => _AddNewPerjalananDinasState();
}

class _AddNewPerjalananDinasState extends State<AddNewPerjalananDinas> {
  String? leaveoptions;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  bool isLoading = false;

  List<Map<String, dynamic>> noticationList = [];

  TextEditingController txtNamaKaryawan = TextEditingController();
  TextEditingController txtDeptKaryawan = TextEditingController();
  TextEditingController txtKeperluan = TextEditingController();
  TextEditingController txtAnggota1 = TextEditingController();
  TextEditingController txtAnggota2 = TextEditingController();
  TextEditingController txtAnggota3 = TextEditingController();
  TextEditingController txtAnggota4 = TextEditingController();
  
  String selectedKotaTujuan = '';

  List<Map<String, String>> listNamaPerjalanan = [];
  String? selectedLamaPerjalanan;

  List<Map<String, String>> listPembayaran = [];
  String? selectedPembayaran;

  List<Map<String, String>> listTransportasi = [];
  String? selectedTransportasi;

  String? selectedTim;

  @override
  void initState() {
    super.initState();
    fetchNotification();
    fetchData();
    fetchDinasKotaData();
    fetchDropdownData();
  }

  Future<void> fetchNotification() async{
    try{  
      String employeeId = storage.read('employee_id').toString();
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/notification/getlimitnotif.php?employee_id=$employeeId';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          noticationList = List<Map<String, dynamic>>.from(data['Data']);
        });
      } else if (response.statusCode == 404){
        print('404, No Data Found');
      }

    } catch (e){
      print('Error: $e');
    }
  }

  Future<void> fetchData() async {
    String employeeId = storage.read('employee_id').toString();
    isLoading = true;
    try {
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

          txtNamaKaryawan.text = employeeName;
          txtDeptKaryawan.text = data['department_name'] as String;
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

  Future<List<dynamic>> fetchDinasKotaData() async {
    const url = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/getperjalanandinas.php?action=1';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['Data'];
    } else {
      throw Exception('Failed to load data');
    }
  }
  
  Future<void> fetchDropdownData() async {
    try{
      isLoading = true;

       final responseTransport = await http.get(
          Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/getperjalanandinas.php?action=5'));
      
      if (responseTransport.statusCode == 200) {
        final transportdata = json.decode(responseTransport.body);
        if (transportdata['StatusCode'] == 200) {
          setState(() {
            listTransportasi = (transportdata['Data'] as List)
                .map((transport) => Map<String, String>.from(transport))
                .toList();

            if (listTransportasi.isNotEmpty) {
              // Set the selectedCompany to the first item in the list by default
              selectedTransportasi = listTransportasi[0]['transport_id'].toString();
            }
          });
        } else {
          // Handle API error
          print('Failed to fetch data');
        }
      } else {
        // Handle HTTP error
        print('Failed to fetch data');
      }

      final responsePembayaran = await http.get(
          Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/getperjalanandinas.php?action=4'));
      
      if (responsePembayaran.statusCode == 200) {
        final pembayarandata = json.decode(responsePembayaran.body);
        if (pembayarandata['StatusCode'] == 200) {
          setState(() {
            listPembayaran = (pembayarandata['Data'] as List)
                .map((pembayaran) => Map<String, String>.from(pembayaran))
                .toList();

            if (listPembayaran.isNotEmpty) {
              // Set the selectedCompany to the first item in the list by default
              selectedPembayaran = listPembayaran[0]['payment_id'].toString();
            }
          });
        } else {
          // Handle API error
          print('Failed to fetch data');
        }
      } else {
        // Handle HTTP error
        print('Failed to fetch data');
      }

      final response = await http.get(
          Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/getperjalanandinas.php?action=2'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['StatusCode'] == 200) {
          setState(() {
            listNamaPerjalanan = (data['Data'] as List)
                .map((dinas) => Map<String, String>.from(dinas))
                .toList();

            if (listNamaPerjalanan.isNotEmpty) {
              // Set the selectedCompany to the first item in the list by default
              selectedLamaPerjalanan = listNamaPerjalanan[0]['duration_id'].toString();
            }
          });
        } else {
          // Handle API error
          print('Failed to fetch data');
        }
      } else {
        // Handle HTTP error
        print('Failed to fetch data');
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> perjalananDinas() async {
    String employeeId = storage.read('employee_id').toString();

    String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/perjalanandinas/perjalanandinas.php';

    try{
      isLoading = true;

      final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "action" : "4",
            "employee_id": employeeId,
            "city": selectedKotaTujuan,
            "duration": selectedLamaPerjalanan,
            "reason": txtKeperluan.text,
            "team": selectedTim,
            "payment": selectedPembayaran,
            "transport": selectedTransportasi,
            "team_one": txtAnggota1.text,
            "team_two": txtAnggota2.text,
            "team_three": txtAnggota3.text,
            "team_four": txtAnggota4.text,
          }
        );

        if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil memasukkan permohonan perjalanan dinas'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PerjalananDinasIndex());
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
                      Get.to(const PerjalananDinasIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        }
    } catch (e){
      showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error $e'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const PerjalananDinasIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
    } finally{
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
      title: 'Tambah Perjalanan Dinas',
      home: SafeArea(
        child: Scaffold(
          body: isLoading ? const Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
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
                        Center(
                          child: Text('Formulir Perjalanan Dinas', style: TextStyle(
                              fontSize: 7.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color.fromRGBO(116, 116, 116, 1)
                            ),),
                        ),
                        SizedBox(height: 10.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nama Karyawan',
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 10.h,),
                                  Text(txtNamaKaryawan.text)
                                ],
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Departemen',
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 10.h,),
                                  Text(txtDeptKaryawan.text)
                                ],
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Kota Tujuan', 
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 10.h,),
                                  FutureBuilder<List<dynamic>>(
                                    future: fetchDinasKotaData(),
                                    builder: (context, snapshot){
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text("Error: ${snapshot.error}");
                                      } else {
                                        List<dynamic> items = snapshot.data!;
                                        return DropdownSearch<dynamic>(
                                          popupProps: const PopupProps.menu(showSearchBox: true, searchFieldProps: TextFieldProps(decoration: InputDecoration(hintText: 'Cari Nama Kota'))),
                                          items: items,
                                          itemAsString: (item) => item['name'],
                                          // label: "Select a location",
                                          onChanged: (value){
                                            selectedKotaTujuan = value['id'];
                                          },
                                          selectedItem: items.isNotEmpty ? items[0] : null,
                                        );
                                      }
                                    }
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 7.sp,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Lama Perjalanan', 
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 10.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedLamaPerjalanan,
                                    hint: const Text('Pilih lama perjalanan'),
                                    onChanged: (String? newValue) {
                                      selectedLamaPerjalanan = newValue.toString();
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1)
                                    ),
                                    items: listNamaPerjalanan.map<DropdownMenuItem<String>>((Map<String, String> perjalanan) {
                                      return DropdownMenuItem<String>(
                                        value: perjalanan['duration_id']!,
                                        child: Text(perjalanan['duration_name']!),
                                      );
                                    }).toList(),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Keperluan', 
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 10.h,),
                                  TextFormField(
                                    controller: txtKeperluan,
                                    maxLines: 3,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan keperluan'
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tim Analis/Teknisi', 
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 10.h,),
                                  DropdownButtonFormField(
                                    value: 'Tim Analis',
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'Tim Analis',
                                        child: Text('Tim Analis')
                                      ),
                                      DropdownMenuItem(
                                        value: 'Tim Teknisi',
                                        child: Text('Tim Teknisi')
                                      )
                                    ], 
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    ),
                                    onChanged: (value){
                                      selectedTim = value.toString();
                                    }
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 7.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Anggota 1', 
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 10.h,),
                                  TextFormField(
                                    controller: txtAnggota1,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan nama anggota 1'
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Anggota 2', 
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 10.h,),
                                  TextFormField(
                                    controller: txtAnggota2,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan nama anggota 2'
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Anggota 3', 
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 10.h,),
                                  TextFormField(
                                    controller: txtAnggota3,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan nama anggota 3'
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 7.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Anggota 4', 
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 10.h,),
                                  TextFormField(
                                    controller: txtAnggota4,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan nama anggota 4'
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Biaya', 
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 10.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedPembayaran,
                                    hint: const Text('Pilih jenis metode biaya'),
                                    onChanged: (String? newValue) {
                                      selectedPembayaran = newValue.toString();
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1)
                                    ),
                                    items: listPembayaran.map<DropdownMenuItem<String>>((Map<String, String> biaya) {
                                      return DropdownMenuItem<String>(
                                        value: biaya['payment_id']!,
                                        child: Text(biaya['payment_name']!),
                                      );
                                    }).toList(),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Transportasi', 
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 10.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedTransportasi,
                                    hint: const Text('Pilih jenis transportasi'),
                                    onChanged: (String? newValue) {
                                      selectedTransportasi = newValue.toString();
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1)
                                    ),
                                    items: listTransportasi.map<DropdownMenuItem<String>>((Map<String, String> transport) {
                                      return DropdownMenuItem<String>(
                                        value: transport['transport_id']!,
                                        child: Text(transport['transport_name']!),
                                      );
                                    }).toList(),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: (){
                                if(selectedKotaTujuan == ''){
                                  dialogError('Kota tujuan tidak dapat kosong !!');
                                } else if (txtKeperluan.text == ''){
                                  dialogError('Keperluan tidak dapat kosong !!');
                                } else {
                                  perjalananDinas();
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
                              child: const Text('Kumpul')
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
      )
    );
  }

  Future <void> dialogError (String message) async {
    return showDialog(
      context: context, 
      builder: (_){
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: (){
                Get.back();
              }, 
              child: Text('Kembali')
            )
          ],
        );
      }
    );
  }
}