// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, file_names, camel_case_types, avoid_print

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/InventoryDashboard.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:hr_systems_web/web-version/full-access/Salary/currencyformatter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import '../index.dart';

class addNewInventory extends StatefulWidget {
  const addNewInventory({super.key});

  @override
  State<addNewInventory> createState() => _addNewInventoryState();
}

class _addNewInventoryState extends State<addNewInventory> {
  String? leaveoptions;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  bool isLoading = false;
  TextEditingController txtNamaInventaris = TextEditingController();
  TextEditingController txtLokasiInventaris = TextEditingController();
  TextEditingController txtJumlahCicilan = TextEditingController();
  TextEditingController txtHargaInventaris = TextEditingController();
  TextEditingController txtSupplier = TextEditingController();
  TextEditingController txtStatus = TextEditingController();
  TextEditingController txtCatatan = TextEditingController();
  TextEditingController txtNomorAssets = TextEditingController();

  DateTime? TanggalPembelian;
  DateTime? TanggalGaransi;
  DateTime? TanggalJatuhTempo;

  List<Map<String, String>> kondisiInventaris = [];
  String? selectedKondisiInventaris;

  List<Map<String, String>> kategoriInventaris = [];
  String? selectedKategoriInventaris;

  List<Map<String, String>> listKaryawan = [];
  String? selectedKaryawan;

  List<Map<String, String>> listMetodePembayaran = [];
  String? selectedMetodePembayaran;

  List<Map<String, String>> listCicilan = [];
  String? selectedCicilan;

  List<Map<String, String>> listStatus = [];
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchCondition();
    fetchCategory();
    fetchEmployee();
    fetchPaymentMethod();
    fetchListCicilan();
    fetchListStatus();
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

  Future<void> fetchCondition() async {
    try{
      isLoading = true;
      final response = await http.get(
          Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/getinventory.php?action=2'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['StatusCode'] == 200) {
          setState(() {
            kondisiInventaris = (data['Data'] as List)
                .map((kondisi) => Map<String, String>.from(kondisi))
                .toList();

            if (kondisiInventaris.isNotEmpty) {
              // Set the selectedCompany to the first item in the list by default
              selectedKondisiInventaris = kondisiInventaris[0]['condition_id'].toString();
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

  Future<void> fetchCategory() async {
    try {
      isLoading = true;

      final response = await http.get(
          Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/getinventory.php?action=1'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['StatusCode'] == 200) {
          setState(() {
            kategoriInventaris = (data['Data'] as List)
                .map((kategori) => Map<String, String>.from(kategori))
                .toList();

            if (kategoriInventaris.isNotEmpty) {
              // Set the selectedCompany to the first item in the list by default
              selectedKategoriInventaris = kategoriInventaris[0]['id_inventory_category'].toString();
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

  Future<void> fetchEmployee() async {
    try {
      isLoading = true;

      final response = await http.get(
          Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployeelist.php'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['StatusCode'] == 200) {
          setState(() {
            listKaryawan = (data['Data'] as List)
                .map((listkaryawan) => Map<String, String>.from(listkaryawan))
                .toList();

            if (listKaryawan.isNotEmpty) {
              // Set the selectedCompany to the first item in the list by default
              selectedKaryawan = listKaryawan[0]['id'].toString();
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

  Future<void> fetchPaymentMethod() async {
    try {
      isLoading = true;

      final response = await http.get(
          Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/getinventory.php?action=3'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['StatusCode'] == 200) {
          setState(() {
            listMetodePembayaran = (data['Data'] as List)
                .map((listpembayaran) => Map<String, String>.from(listpembayaran))
                .toList();

            if (listMetodePembayaran.isNotEmpty) {
              // Set the selectedCompany to the first item in the list by default
              selectedMetodePembayaran = listMetodePembayaran[0]['id_payment_method'].toString();
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

  Future<void> fetchListCicilan() async{
    try {
      isLoading = true;

      final response = await http.get(
          Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/getinventory.php?action=4'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['StatusCode'] == 200) {
          setState(() {
            listCicilan = (data['Data'] as List)
                .map((cicilan) => Map<String, String>.from(cicilan))
                .toList();

            if (listCicilan.isNotEmpty) {
              // Set the selectedCompany to the first item in the list by default
              selectedCicilan = listCicilan[0]['id_inventory_installment'].toString();
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

  Future<void> fetchListStatus() async{
    try {
      isLoading = true;

      final response = await http.get(
          Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/getinventory.php?action=5'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['StatusCode'] == 200) {
          setState(() {
            listStatus = (data['Data'] as List)
                .map((status) => Map<String, String>.from(status))
                .toList();

            if (listCicilan.isNotEmpty) {
              // Set the selectedCompany to the first item in the list by default
              selectedStatus = listStatus[0]['status_id'].toString();
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

  Future<void> inventory() async {
    String employeeId = storage.read('employee_id').toString();

    String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/inventory.php';

    try{
      isLoading = true;

      final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "action" : "8",
            "inventory_name": txtNamaInventaris.text,
            "inventory_category": selectedKategoriInventaris,
            "inventory_id": txtNomorAssets.text,
            "purchase_date": TanggalPembelian.toString(), 
            "warranty_date" : TanggalGaransi.toString(),
            "inventory_condition" : selectedKondisiInventaris,
            "assigned_to" : selectedKaryawan,
            "inventory_location" : txtLokasiInventaris.text,
            "purchase_method" : selectedMetodePembayaran,
            "installment_period" : selectedCicilan,
            "due_date" : TanggalJatuhTempo.toString(),
            "installment_price" : txtJumlahCicilan.text.replaceAll(RegExp(r'[^0-9]'), ''),
            "purchase_price" : txtHargaInventaris.text.replaceAll(RegExp(r'[^0-9]'), ''),
            "supplier_name" : txtSupplier.text,
            "inventory_status" : selectedStatus,
            "inventory_notes" : txtCatatan.text,
            "hrd_employee_id" : employeeId
          }
        );

         if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah mendata inventaris baru'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const InventoryIndex());
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
              );
            }
          );
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
      title: 'Tambah Inventaris',
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
                        NamaPerusahaanMenu(companyName: companyName, companyAddress: trimmedCompanyAddress),
                        SizedBox(height: 10.sp,),
                        const HalamanUtamaMenu(),
                        SizedBox(height: 5.sp,),
                        BerandaActive(employeeId: employeeId.toString()),
                        SizedBox(height: 5.sp,),
                        KaryawanNonActive(employeeId: employeeId.toString()),
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
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 120.w) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Nama Barang",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 7.h,),
                                  TextFormField(
                                    controller: txtNamaInventaris,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan nama barang'
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 120.w) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Kategori Inventaris",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedKategoriInventaris,
                                    hint: const Text('Pilih kategori inventaris'),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedKategoriInventaris = newValue.toString();
                                      });
                                    },
                                    items: kategoriInventaris.map<DropdownMenuItem<String>>((Map<String, String> kategori) {
                                      return DropdownMenuItem<String>(
                                        value: kategori['id_inventory_category']!,
                                        child: Text(kategori['inventory_category_name']!),
                                      );
                                    }).toList(),
                                  )
                                ],
                              ),
                            ),  
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 120.w) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Nomor Asset",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 7.h,),
                                  TextFormField(
                                    controller: txtNomorAssets,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan nomor asset'
                                    ),
                                  )
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
                              width: (MediaQuery.of(context).size.width - 120.w) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tanggal Pembelian",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 7.h,),
                                  DateTimePicker(
                                    dateHintText: 'Pilih tanggal pembelian',
                                    type: DateTimePickerType.date,
                                    firstDate: DateTime(2010),
                                    lastDate: DateTime(2050),
                                    initialDate: DateTime.now(),
                                    onChanged: (value) {
                                      TanggalPembelian = DateFormat('yyyy-MM-dd').parse(value);
                                    },
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 120.w) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tanggal Masa Berakhir Garansi",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 7.h,),
                                  DateTimePicker(
                                    dateHintText: 'Pilih tanggal masa akhir garansi',
                                    type: DateTimePickerType.date,
                                    firstDate: DateTime(2010),
                                    initialDate: DateTime.now(),
                                    lastDate: DateTime(2050),
                                    onChanged: (value) {
                                      TanggalGaransi = DateFormat('yyyy-MM-dd').parse(value);
                                    },
                                  )
                                ],
                              ),
                            ),  
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 120.w) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Kondisi Inventaris",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedKondisiInventaris,
                                    hint: const Text('Pilih kondisi inventaris'),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedKondisiInventaris = newValue.toString();
                                      });
                                    },
                                    items: kondisiInventaris.map<DropdownMenuItem<String>>((Map<String, String> kondisi) {
                                      return DropdownMenuItem<String>(
                                        value: kondisi['condition_id']!,
                                        child: Text(kondisi['condition_name']!),
                                      );
                                    }).toList(),
                                  )
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
                              width: (MediaQuery.of(context).size.width - 120.w) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Diserahkan kepada",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedKaryawan,
                                    hint: const Text('Pilih nama karyawan'),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedKaryawan = newValue.toString();
                                      });
                                    },
                                    items: listKaryawan.map<DropdownMenuItem<String>>((Map<String, String> listkaryawan) {
                                      return DropdownMenuItem<String>(
                                        value: listkaryawan['id']!,
                                        child: Text(listkaryawan['employee_name']!),
                                      );
                                    }).toList(),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 120.w) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Lokasi Asset",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 7.h,),
                                  TextFormField(
                                    controller: txtLokasiInventaris,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan lokasi inventaris'
                                    ),
                                  )
                                ],
                              ),
                            ),  
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 120.w) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Metode Pembelian Inventaris",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    value: selectedMetodePembayaran,
                                    hint: const Text('Pilih metode pembelian'),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedMetodePembayaran = newValue.toString();
                                      });
                                    },
                                    items: listMetodePembayaran.map<DropdownMenuItem<String>>((Map<String, String> metode) {
                                      return DropdownMenuItem<String>(
                                        value: metode['id_payment_method']!,
                                        child: Text(metode['payment_method']!),
                                      );
                                    }).toList(),
                                  )
                                ],
                              ),
                            ),  
                          ],
                        ),
                        SizedBox(height: 7.sp,),
                        if(selectedMetodePembayaran == '0cd8ee35-e297-11ee-9')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 120.w) / 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Jumlah periode cicilan",
                                      style: TextStyle(
                                        fontSize: 4.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                      ),
                                    ),
                                    SizedBox(height: 7.h,),
                                    DropdownButtonFormField<String>(
                                      value: selectedCicilan,
                                      hint: const Text('Pilih periode cicilan'),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedCicilan = newValue.toString();
                                        });
                                      },
                                      items: listCicilan.map<DropdownMenuItem<String>>((Map<String, String> cicilan) {
                                        return DropdownMenuItem<String>(
                                          value: cicilan['id_inventory_installment']!,
                                          child: Text(cicilan['inventory_installment_name']!),
                                        );
                                      }).toList(),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 120.w) / 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Tanggal Jatuh Tempo",
                                      style: TextStyle(
                                        fontSize: 4.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                      ),
                                    ),
                                    SizedBox(height: 7.h,),
                                    DateTimePicker(
                                      dateHintText: 'Pilih tanggal jatuh tempo',
                                      type: DateTimePickerType.date,
                                      firstDate: DateTime(2010),
                                      lastDate: DateTime(2050),
                                      initialDate: DateTime.now(),
                                      dateMask: 'dd',
                                      onChanged: (value) {
                                        TanggalJatuhTempo = DateFormat('yyyy-MM-dd').parse(value);
                                      },
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 120.w) / 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Cicilan per bulan",
                                      style: TextStyle(
                                        fontSize: 4.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                      ),
                                    ),
                                    SizedBox(height: 7.h,),
                                    TextFormField(
                                    controller: txtJumlahCicilan,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      CurrencyFormatter(),
                                    ],
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan jumlah cicilan per bulan'
                                    ),
                                  )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        if(selectedMetodePembayaran == '0cd8ee35-e297-11ee-9')
                          SizedBox(height: 7.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 120.w) / 3,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Harga Pembelian",
                                      style: TextStyle(
                                        fontSize: 4.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                      ),
                                    ),
                                    SizedBox(height: 7.h,),
                                    TextFormField(
                                      controller: txtHargaInventaris,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        CurrencyFormatter(),
                                      ],
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                                        hintText: 'Masukkan harga pembelian'
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 120.w) / 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Supplier/Manufaktur",
                                      style: TextStyle(
                                        fontSize: 4.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                      ),
                                    ),
                                    SizedBox(height: 7.h,),
                                    TextFormField(
                                      controller: txtSupplier,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                                        hintText: 'Masukkan nama merek/supplier/manufaktur'
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 120.w) / 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Status",
                                      style: TextStyle(
                                        fontSize: 4.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                      ),
                                    ),
                                    SizedBox(height: 7.h,),
                                    DropdownButtonFormField<String>(
                                      value: selectedStatus,
                                      hint: const Text('Pilih status inventaris'),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedStatus = newValue.toString();
                                        });
                                      },
                                      items: listStatus.map<DropdownMenuItem<String>>((Map<String, String> status) {
                                        return DropdownMenuItem<String>(
                                          value: status['status_id']!,
                                          child: Text(status['status_name']!),
                                        );
                                      }).toList(),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 7.sp,),
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Catatan",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                                  SizedBox(height: 7.h,),
                                  TextFormField(
                                      controller: txtCatatan,
                                      maxLines: 5,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Color.fromRGBO(235, 235, 235, 1),
                                        hintText: 'Masukkan detail dari inventaris tersebut'
                                      ),
                                    )
                                ],
                              ),
                            ),  
                          ],
                        ),
                        SizedBox(height: 15.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: (){
                                inventory();
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                alignment: Alignment.center,
                                minimumSize: Size(40.w, 55.h),
                                foregroundColor: const Color(0xFFFFFFFF),
                                backgroundColor: const Color(0xff4ec3fc),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ), 
                              child: const Text('Kumpulkan')
                            )
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