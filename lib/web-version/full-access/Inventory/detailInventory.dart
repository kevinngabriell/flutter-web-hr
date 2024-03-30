// ignore_for_file: use_build_context_synchronously, camel_case_types, non_constant_identifier_names, prefer_const_constructors_in_immutables, avoid_print, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/InventoryDashboard.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class detailInventory extends StatefulWidget {
  final String inventory_id;
  detailInventory(this.inventory_id, {super.key});

  @override
  State<detailInventory> createState() => _detailInventoryState();
}

class _detailInventoryState extends State<detailInventory> {
  String? leaveoptions;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  bool isLaoding = false;

  String inventoryName = '';
  String inventoryCategory = '';
  String purchaseDate = '';
  String warrantyDate = '';
  String conditionName = '';
  String assignedTo = '';
  String inventoryLocation = '';
  String paymentMethod = '';
  String installmentPeriod = '';
  String dueDate = '';
  String installmentPrice = '';
  String purchasePrice = '';
  String supplierName = '';
  String statusName = '';
  String inventoryNotes = '';

  String selectedEmployee = '';
  String selectedEmployeeName = '';
  List<Map<String, dynamic>> noticationList = [];
  List<Map<String, dynamic>> inventoryHistory = [];
  List<Map<String, dynamic>> employeeList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchNotification();
    fetchDetailInventory();
    fetchInventoryHistory();
    fetchemployeeList();
  }

  String formatCurrency2(String value) {
    // Parse the string to a number.
    double numberValue = double.tryParse(value) ?? 0;

    // Format the number as currency.
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0).format(numberValue);
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
    isLaoding = true;
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
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    } finally {
      isLaoding = false;
    }
  }

  Future<void> fetchDetailInventory() async {
    try{
      isLaoding = true;

      String inventory_id = widget.inventory_id;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/getinventory.php?action=9&inventory_id=$inventory_id';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        Map<String, dynamic> data = (responseData['Data'] as List).first;

        setState(() {
          inventoryName = data['inventory_name'];
          inventoryCategory = data['inventory_category_name'];
          purchaseDate = data['purchase_date'];
          warrantyDate = data['warranty_date'];
          conditionName = data['condition_name'];
          assignedTo = data['employee_name'];
          inventoryLocation = data['inventory_location'];
          paymentMethod = data['payment_method'];
          installmentPeriod = data['inventory_installment_name'];
          dueDate = data['due_date'];
          installmentPrice = data['installment_price'];
          purchasePrice = data['purchase_price'];
          supplierName = data['supplier_name'];
          statusName = data['status_name'];
          inventoryNotes = data['inventory_notes'];

          if(paymentMethod == 'Cash'){
            installmentPeriod = '-';
            installmentPrice = '-';
          }

        });

      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error at catching inevntory detail : $e');
    } finally {
      isLaoding = false;
    }
  }  

  Future<void> fetchInventoryHistory() async {
    try{  
      isLaoding = true;
      String inventory_id = widget.inventory_id;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/getinventory.php?action=10&inventory_id=$inventory_id';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          inventoryHistory = List<Map<String, dynamic>>.from(data['Data']);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }

    } catch (e){
      print('Error: $e');
    } finally {
      setState(() {
        isLaoding = false;
      });
    }
  }

  Future<void> actionInventory(action_id) async {
    try{
      isLaoding = true;

      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/inventory.php';
      String employeeId = storage.read('employee_id').toString();

      if(action_id == '1'){
        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "action" : "10",
            "requestor_id": employeeId,
            "inventory_id": widget.inventory_id
          }
        );

        if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil mengubah status inventaris'),
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
                      Get.to(const InventoryIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        }
      } else if (action_id == '2'){
        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "action" : "11",
            "requestor_id": employeeId,
            "inventory_id": widget.inventory_id
          }
        );

        if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil mengubah status inventaris'),
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
                      Get.to(const InventoryIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        }
      } else if (action_id == '3'){
        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "action" : "12",
            "requestor_id": employeeId,
            "inventory_id": widget.inventory_id
          }
        );

        if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil mengubah status inventaris'),
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
                      Get.to(const InventoryIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        }
      } else if (action_id == '4'){
        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "action" : "13",
            "requestor_id": employeeId,
            "inventory_id": widget.inventory_id
          }
        );

        if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil mengubah status inventaris'),
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
                      Get.to(const InventoryIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        }
      } else if (action_id == '5'){
        try{
          isLaoding = true;

          String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/inventory.php';
          String employeeId = storage.read('employee_id').toString();

          final response = await http.post(
            Uri.parse(apiUrl),
            body: {
              "action" : "14",
              "inventory_id": widget.inventory_id,
              "employee_id": employeeId,
              "assigned_to" : selectedEmployee,
              "assigned_to_name" : selectedEmployeeName
            }
          );

          if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil mengubah status permintaan'),
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
                      Get.to(const InventoryIndex());
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
                      Get.to(const InventoryIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        } finally {
          isLaoding = false;
        }
      }
      
    } finally {
      isLaoding = false;
    }
  }

  Future<void> fetchemployeeList() async {
    try{
      isLaoding = true;

      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployee.php?action=1';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          employeeList = List<Map<String, dynamic>>.from(data['Data']);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }

    } catch (e){
      print('Error while get employee list $e');
    } finally {
      isLaoding = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    var employeeId = storage.read('employee_id');
    var photo = storage.read('photo');
    var positionId = storage.read('position_id');



    return MaterialApp(
      title: 'Detail Inventaris',
      home: SafeArea(
        child: Scaffold(
          body: isLaoding ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
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
                        SizedBox(height: 10.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context, 
                                  builder: (_){
                                    return AlertDialog(
                                      title: Text('Riwayat $inventoryName'),
                                      content: SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height,
                                        child: ListView.builder(
                                          itemCount: inventoryHistory.length,
                                          itemBuilder: (context, index) {
                                            var item = inventoryHistory[index];
                                            return ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor: const Color(0xff4ec3fc),
                                                child: Text('${index + 1}', style: const TextStyle(color: Colors.white),),
                                              ),
                                              title: Text(item['employee_name'], style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w600),),
                                              subtitle: Text(item['action'], style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),),
                                              trailing: Text(_formatDate(item['action_dt']), style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),),
                                            );
                                          }
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: (){
                                            Get.back();
                                          }, 
                                          child: const Text('Tutup')
                                        )
                                      ],
                                    );
                                  }
                                );
                              },
                              child: Text('Lihat riwayat inventaris', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w400, color: const Color(0xFF2A85FF)))
                            )
                          ],
                        ),
                        SizedBox(height: 10.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nomor Inventaris', style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                  Text(widget.inventory_id),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nama Inventaris', style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                  Text(inventoryName),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Kategori Inventaris', style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                  Text(inventoryCategory),
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
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tanggal Pembelian', style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                  Text(_formatDate2(purchaseDate)),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tanggal Masa Akhir Garansi', style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                  Text(_formatDate2(warrantyDate)),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Kondisi Inventaris', style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                  Text(conditionName),
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
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Diserahkan kepada', style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                  Text(assignedTo),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Lokasi Inventaris', style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                  Text(inventoryLocation),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Metode Pembelian', style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                  Text(paymentMethod),
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
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Periode Cicilan', style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                  Text(installmentPeriod),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tanggal Jatuh Tempo', style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                  Text(jatuhTempoFormatDate(dueDate)),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Jumlah Cicilan', style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                  Text(formatCurrency2(installmentPrice)),
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
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Harga Inventaris', style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                  Text(formatCurrency2(purchasePrice)),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nama Manufaktur/Supplier', style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                  Text(supplierName),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Status Inventaris', style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                  Text(statusName),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 7.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 100.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Catatan Inventaris', style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                  Text(inventoryNotes),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if(positionId == 'POS-HR-002')
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: ElevatedButton(
                                  onPressed: () {
                                    actionInventory('1');
                                  }, 
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    alignment: Alignment.center,
                                    minimumSize: Size(60.w, 55.h),
                                    foregroundColor: const Color(0xFFFFFFFF),
                                    backgroundColor: Colors.deepOrange,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('Pemeliharaan')
                                )
                              ),
                            if(positionId == 'POS-HR-002')
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: ElevatedButton(
                                  onPressed: () {
                                    actionInventory('2');
                                  }, 
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    alignment: Alignment.center,
                                    minimumSize: Size(60.w, 55.h),
                                    foregroundColor: const Color(0xFFFFFFFF),
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('Tidak Aktif')
                                )
                              ),
                            if(positionId == 'POS-HR-002')
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: ElevatedButton(
                                  onPressed: () {
                                    actionInventory('3');
                                  }, 
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    alignment: Alignment.center,
                                    minimumSize: Size(60.w, 55.h),
                                    foregroundColor: const Color(0xFFFFFFFF),
                                    backgroundColor: const Color(0xff4ec3fc),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('Dikembalikan ke perusahaan')
                                )
                              ),
                          ],
                        ),
                        SizedBox(height: 7.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if(positionId == 'POS-HR-002')
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: ElevatedButton(
                                  onPressed: () {
                                    actionInventory('4');
                                  }, 
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    alignment: Alignment.center,
                                    minimumSize: Size(60.w, 55.h),
                                    foregroundColor: const Color(0xFFFFFFFF),
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('Rusak')
                                )
                              ),
                            if(positionId == 'POS-HR-002')
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context, 
                                      builder: (_){
                                        return AlertDialog(
                                          title: const Text('List Nama Karyawan'),
                                          content: SizedBox(
                                            width: MediaQuery.of(context).size.width,
                                            height: MediaQuery.of(context).size.height,
                                            child: ListView.builder(
                                              itemCount: employeeList.length,
                                              itemBuilder: (context, index){
                                                var item = employeeList[index];
                                                return ListTile(
                                                  title: Text(item['employee_name']),
                                                  subtitle: Text(item['department_name']),
                                                  trailing: ElevatedButton(
                                                    onPressed: (){
                                                      selectedEmployee = item['id'];
                                                      selectedEmployeeName = item['employee_name'];
                                                      actionInventory('5');
                                                    }, 
                                                    style: ElevatedButton.styleFrom(
                                                      elevation: 0,
                                                      alignment: Alignment.center,
                                                      minimumSize: Size(40.w, 55.h),
                                                      foregroundColor: const Color(0xFFFFFFFF),
                                                      backgroundColor: const Color(0xff4ec3fc),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                    ),
                                                    child: const Text('Pilih')
                                                  ),
                                                );
                                              }
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: (){
                                                Get.back();
                                              }, 
                                              child: const Text('Kembali')
                                            )
                                          ],
                                        );
                                      }
                                    );
                                  }, 
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    alignment: Alignment.center,
                                    minimumSize: Size(60.w, 55.h),
                                    foregroundColor: const Color(0xFFFFFFFF),
                                    backgroundColor: const Color(0xff4ec3fc),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('Diberikan kepada')
                                )
                              ),
                            if(positionId == 'POS-HR-002')
                              SizedBox(
                                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                                child: (Container())
                              ),
                          ],
                        ),
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

  String _formatDate(String date) {
    // Parse the date string
    DateTime parsedDate = DateFormat("yyyy-MM-dd HH:mm").parse(date);

    // Format the date as "dd MMMM yyyy"
    return DateFormat("d MMMM yyyy HH:mm", 'id').format(parsedDate);
  }

  String _formatDate2(String date) {
    // Parse the date string
    DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(date);

    // Format the date as "d MMMM yyyy"
    return DateFormat("d MMMM yyyy", 'id').format(parsedDate);
  }

  String jatuhTempoFormatDate(String dateString) {
    // Parse the input string into a DateTime object
    DateTime dateTime = DateTime.parse(dateString);

    // Define the desired output format
    final DateFormat formatter = DateFormat('dd');

    // Format the DateTime object into a string
    return formatter.format(dateTime);
  }
}