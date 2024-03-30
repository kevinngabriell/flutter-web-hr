// ignore_for_file: use_build_context_synchronously, avoid_print, non_constant_identifier_names, file_names

import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/InventoryDashboard.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class DetailInventoryRequest extends StatefulWidget {
  final String request_id;
  const DetailInventoryRequest(this.request_id, {super.key});

  @override
  State<DetailInventoryRequest> createState() => _DetailInventoryRequestState();
}

class _DetailInventoryRequestState extends State<DetailInventoryRequest> {
  final storage = GetStorage();
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String employeeId = '';
  String departmentName = '';
  String positionName = '';
  String trimmedCompanyAddress = '';
  bool isLoading = false;
  TextEditingController txtNamaLengkap = TextEditingController();
  TextEditingController txtNIK = TextEditingController();
  TextEditingController txtJabatan = TextEditingController();
  TextEditingController txtDepartemen = TextEditingController();
  String statusName = '';
  List<Map<String, String>> reasons = [];
  String selectedReason = '';
  String inventoryId = '';
  String insertDt = '';

  TextEditingController txtDescInventory = TextEditingController();
  TextEditingController txtAlasanPengajuan = TextEditingController();
  TextEditingController txtKeterangan = TextEditingController();
  TextEditingController txtRejectReason = TextEditingController();

  List<Map<String, dynamic>> requestInventoryHistory = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    getDetailInventory();
    historyRequest();
  }

  Future<void> fetchData() async {
    try {
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/account/getprofileforallpage.php';

      String employeeId = storage.read('employee_id').toString(); // replace with your logic to get employee ID

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
    } finally {
      isLoading = false;
    }
  }

  Future<void> getDetailInventory() async {
      try{
        isLoading = true;

        String apiUrl = "https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/getdetailinventoryrequest.php?request_id=${widget.request_id}";

        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = json.decode(response.body);
          Map<String, dynamic> data = (responseData['Data'] as List).first;

          txtNamaLengkap.text = data['employee_name'];
          txtNIK.text = data['employee_id'];
          txtDepartemen.text = data['department_name'];
          txtJabatan.text = data['position_name'];
          txtDescInventory.text = data['item_request'];
          txtAlasanPengajuan.text = data['request_reason'];
          txtKeterangan.text = data['detail_request'];
          statusName = data['status_name'];
          insertDt = data['insert_dt'];

        } else { 

        }
      } finally {
        isLoading = false;
      }
  }

  Future<void> actionRequestInventory(actionId) async {
    if(actionId == '1'){
      try{
        isLoading = true;

        String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/inventory.php';
        String employeeId = storage.read('employee_id').toString();

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "action" : "4",
            "request_id": widget.request_id,
            "employee_id": employeeId
          }
        );

        if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil menyetujui permintaan inventaris'),
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
        isLoading = false;
      }
    } else if (actionId == '2'){
      try{
        isLoading = true;

        String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/inventory.php';
        String employeeId = storage.read('employee_id').toString();

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "action" : "5",
            "request_id": widget.request_id,
            "employee_id": employeeId,
            "reject_reason" : txtRejectReason.text
          }
        );

        if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil menolak permintaan inventaris'),
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
        isLoading = false;
      }
    } else if (actionId == '3'){
      try{
        isLoading = true;

        String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/inventory.php';
        String employeeId = storage.read('employee_id').toString();

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "action" : "6",
            "request_id": widget.request_id,
            "employee_id": employeeId
          }
        );

        if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil menyetujui permintaan inventaris'),
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
        isLoading = false;
      }
    } else if (actionId == '4'){
      try{
        isLoading = true;

        String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/inventory.php';
        String employeeId = storage.read('employee_id').toString();

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "action" : "7",
            "request_id": widget.request_id,
            "employee_id": employeeId,
            "reject_reason" : txtRejectReason.text
          }
        );

        if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil menolak permintaan inventaris'),
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
        isLoading = false;
      }
    } else if (actionId == '5'){
      try{
        isLoading = true;

        String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/inventory.php';
        String employeeId = storage.read('employee_id').toString();

        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "action" : "9",
            "request_id": widget.request_id,
            "employee_id": employeeId,
            "assigned_to" : txtNIK.text,
            "inventory_id" : inventoryId,
            "assigned_to_name" : txtNamaLengkap.text
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
        isLoading = false;
      }
    }
  }

  Future<List<dynamic>> fetchInventory() async {
    final response = await http.get(Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/getinventory.php?action=6'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['Data'];
    } else {
      throw Exception('Failed to load inventory');
    }
  }

  Future<void> historyRequest() async {
    try{  
      isLoading = true;
      String requestId = widget.request_id;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/getinventory.php?action=11&request_id=$requestId';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          requestInventoryHistory = List<Map<String, dynamic>>.from(data['Data']);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }

    } catch (e){
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

    @override
    Widget build(BuildContext context) {
      final storage = GetStorage();
      var employeeId = storage.read('employee_id');
      var photo = storage.read('photo');
      var positionId = storage.read('position_id');

      return MaterialApp(
        title: 'Pengajuan Inventaris',
        home: Scaffold(
          body: isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
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
                //content
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
                        //Title
                        Center(
                          child: Text(
                            "Detail Pengajuan Inventaris Baru",
                            style: TextStyle(
                              fontSize: 7.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color.fromRGBO(116, 116, 116, 1)
                            ),
                          ),
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
                                  Text('Status', style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                  Text(statusName),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Diajukan oleh', style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                  Text(txtNamaLengkap.text),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Diajukan pada', style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                  Text(_formatDate(insertDt)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 7.sp,),
                        Text('Detail Permintaan', style: TextStyle(
                                    fontSize: 6.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                        SizedBox(height: 7.sp,),
                        Row(
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
                                  Text(txtNamaLengkap.text),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('NIK', style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                  Text(txtNIK.text),
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
                                  Text(txtDepartemen.text),
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
                                  Text('Jabatan', style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                  Text(txtJabatan.text),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Inventaris yang diajukan', style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                  Text(txtDescInventory.text),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 100.w) / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Alasan Pengajuan Inventaris', style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                  Text(txtAlasanPengajuan.text),
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
                              width: (MediaQuery.of(context).size.width - 100.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Keterangan', style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                  Text(txtKeterangan.text),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 7.sp,),
                        Text('Riwayat Permintaan', style: TextStyle(
                                    fontSize: 6.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                        SizedBox(height: 7.sp,),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 250.h,
                          child: ListView.builder(
                            itemCount: requestInventoryHistory.length,
                            itemBuilder: (context, index){
                              var item = requestInventoryHistory[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xff4ec3fc),
                                  child: Text('${index + 1}', style: const TextStyle(color: Colors.white),),
                                ),
                                title: Text(item['employee_name'], style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w600),),
                                subtitle: Text(item['action'], style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),),
                                trailing: Text(_formatDate(item['action_dt']), style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400),),
                              );
                            }
                          ),
                        ),
                        SizedBox(height: 10.sp,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if(positionId == 'POS-HR-002' && statusName == 'Menunggu persetujuan HRD ')
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: (){
                                      actionRequestInventory('1');
                                    }, 
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      alignment: Alignment.center,
                                      minimumSize: Size(40.w, 55.h),
                                      foregroundColor: const Color(0xFFFFFFFF),
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Setuju')
                                  ),
                                  SizedBox(width: 5.w,),
                                  ElevatedButton(
                                    onPressed: (){
                                      showDialog(
                                        context: context, 
                                        builder: (_){
                                          return AlertDialog(
                                            title: const Text('Penolakan Permintaan Inventaris'),
                                            content: TextFormField(
                                              maxLines: 3,
                                              controller: txtRejectReason,
                                              decoration: const InputDecoration(
                                                hintText: 'Masukkan alasan penolakan anda'
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: (){
                                                  actionRequestInventory('2');
                                                }, 
                                                child: const Text('Kumpulkan')
                                              )
                                            ],
                                          );
                                        }
                                      );
                                    }, 
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      alignment: Alignment.center,
                                      minimumSize: Size(40.w, 55.h),
                                      foregroundColor: const Color(0xFFFFFFFF),
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Tolak')
                                  ),
                                ],
                              ),
                             if(positionId == 'POS-HR-008' && statusName == 'Menunggu persetujuan general manager ')
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: (){
                                      actionRequestInventory('3');
                                    }, 
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      alignment: Alignment.center,
                                      minimumSize: Size(40.w, 55.h),
                                      foregroundColor: const Color(0xFFFFFFFF),
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Setuju')
                                  ),
                                  SizedBox(width: 5.w,),
                                  ElevatedButton(
                                    onPressed: (){
                                      showDialog(
                                        context: context, 
                                        builder: (_){
                                          return AlertDialog(
                                            title: const Text('Penolakan Permintaan Inventaris'),
                                            content: TextFormField(
                                              maxLines: 3,
                                              controller: txtRejectReason,
                                              decoration: const InputDecoration(
                                                hintText: 'Masukkan alasan penolakan anda'
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: (){
                                                  actionRequestInventory('4');
                                                }, 
                                                child: const Text('Kumpulkan')
                                              )
                                            ],
                                          );
                                        }
                                      );
                                    }, 
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      alignment: Alignment.center,
                                      minimumSize: Size(40.w, 55.h),
                                      foregroundColor: const Color(0xFFFFFFFF),
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Tolak')
                                  ),
                                ],
                              ),
                            if(positionId == 'POS-HR-002' && statusName == 'Disetujui dan dalam proses tindak lanjut')
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: (){
                                      showDialog(
                                        context: context, 
                                        builder: (_){
                                          return AlertDialog(
                                            title: const Center(child: Text('List Asset Kantor')),
                                            content: Column(
                                              children: [
                                                FutureBuilder<List<dynamic>>(
                                                  future: fetchInventory(), 
                                                  builder: (context, snapshot){
                                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                                      return const Center(child: CircularProgressIndicator());
                                                    } else if (snapshot.hasError) {
                                                      return Text("Error: ${snapshot.error}");
                                                    } else {
                                                      return SizedBox(
                                                        width: MediaQuery.of(context).size.width,
                                                        height: MediaQuery.of(context).size.height - 200.h,
                                                        child: ListView.builder(
                                                          itemCount: snapshot.data?.length ?? 0,
                                                          itemBuilder: (context, index) {
                                                            var inventory = snapshot.data![index];
                                                            return ListTile(
                                                              titleAlignment: ListTileTitleAlignment.center,
                                                              title: Text('${inventory['inventory_name']} | ${inventory['status_name']}'),
                                                              subtitle: Text('${inventory['inventory_id']}'),
                                                              onTap: () {
                                                                showDialog(
                                                                  context: context, 
                                                                  builder: (_){
                                                                    return AlertDialog(
                                                                      title: Text('Detail Assets ${inventory['inventory_name']}', style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700),),
                                                                      content: Column(
                                                                        children: [
                                                                          SizedBox(height: 10.h,),
                                                                          SizedBox(
                                                                            width: MediaQuery.of(context).size.width - 150.w,
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Nama Inventaris', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      Text(inventory['inventory_name'])
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Kategori Inventaris', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      Text(inventory['inventory_category_name'])
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Nomor Inventaris', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      Text(inventory['inventory_id'])
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(height: 7.sp,),
                                                                          SizedBox(
                                                                            width: MediaQuery.of(context).size.width - 150.w,
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Tanggal Pembelian', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      Text(formatDate(inventory['purchase_date']))
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Tanggal Akhir Garansi', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      Text(formatDate(inventory['warranty_date']))
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Kondisi Inventaris', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      Text(inventory['condition_name'])
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(height: 7.sp,),
                                                                          SizedBox(
                                                                            width: MediaQuery.of(context).size.width - 150.w,
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Karyawan yang bertanggung jawab', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      Text(inventory['employee_name'])
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Lokasi Inventaris', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      Text(inventory['inventory_location'])
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Metode Pembelian', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      Text(inventory['payment_method'])
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(height: 7.sp,),
                                                                          SizedBox(
                                                                            width: MediaQuery.of(context).size.width - 150.w,
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Periode Cicilan', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      if(inventory['payment_method'] == 'Cash')
                                                                                        const Text('-'),
                                                                                      if(inventory['payment_method'] == 'Kredit dengan cicilan')
                                                                                        Text(inventory['inventory_installment_name'])
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Tanggal Jatuh Tempo', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      if(inventory['payment_method'] == 'Cash')
                                                                                        const Text('-'),
                                                                                      if(inventory['payment_method'] == 'Kredit dengan cicilan')
                                                                                        Text(jatuhTempoFormatDate(inventory['due_date']))
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Jumlah Cicilan', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      if(inventory['payment_method'] == 'Cash')
                                                                                        const Text('-'),
                                                                                      if(inventory['payment_method'] == 'Kredit dengan cicilan')
                                                                                        Text(formatCurrency(inventory['installment_price']))
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(height: 7.sp,),
                                                                          SizedBox(
                                                                            width: MediaQuery.of(context).size.width - 150.w,
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Harga pembelian', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      Text(formatCurrency(inventory['purchase_price']))
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Nama Manufaktur/Supplier', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      Text(inventory['supplier_name'])
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: const Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(height: 7.sp,),
                                                                          SizedBox(
                                                                            width: MediaQuery.of(context).size.width - 150.w,
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w),
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Catatan', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      Text(inventory['inventory_notes'])
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
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
                                                              trailing: ElevatedButton(
                                                                onPressed: (){
                                                                  inventoryId = inventory['inventory_id'];
                                                                  actionRequestInventory('5');
                                                                }, 
                                                                style: ElevatedButton.styleFrom(
                                                                  elevation: 0,
                                                                  alignment: Alignment.center,
                                                                  minimumSize: Size(40.w, 55.h),
                                                                  foregroundColor: const Color(0xFFFFFFFF),
                                                                  backgroundColor: const Color(0xff4ec3fc),
                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                                ),
                                                                child: const Text('Berikan ke karyawan')
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    }
                                                  }
                                                )
                                              ],
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
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      alignment: Alignment.center,
                                      minimumSize: Size(40.w, 55.h),
                                      foregroundColor: const Color(0xFFFFFFFF),
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Cek Asset')
                                  ),
                                  // SizedBox(width: 5.w,),
                                  // ElevatedButton(
                                  //   onPressed: (){
                                      
                                  //   }, 
                                  //   style: ElevatedButton.styleFrom(
                                  //     elevation: 0,
                                  //     alignment: Alignment.center,
                                  //     minimumSize: Size(40.w, 55.h),
                                  //     foregroundColor: const Color(0xFFFFFFFF),
                                  //     backgroundColor: Colors.red,
                                  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  //   ),
                                  //   child: const Text('Beli Asset Baru')
                                  // ),
                                ],
                              ),
                            if(positionId == 'POS-HR-002' && statusName == 'Dalam proses pemeriksaan asset inventaris')
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: (){
                                      showDialog(
                                        context: context, 
                                        builder: (_){
                                          return AlertDialog(
                                            title: const Center(child: Text('List Asset Kantor')),
                                            content: Column(
                                              children: [
                                                FutureBuilder<List<dynamic>>(
                                                  future: fetchInventory(), 
                                                  builder: (context, snapshot){
                                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                                      return const Center(child: CircularProgressIndicator());
                                                    } else if (snapshot.hasError) {
                                                      return Text("Error: ${snapshot.error}");
                                                    } else {
                                                      return SizedBox(
                                                        width: MediaQuery.of(context).size.width,
                                                        height: MediaQuery.of(context).size.height - 325.h,
                                                        child: ListView.builder(
                                                          itemCount: snapshot.data?.length ?? 0,
                                                          itemBuilder: (context, index) {
                                                            var inventory = snapshot.data![index];
                                                            return ListTile(
                                                              titleAlignment: ListTileTitleAlignment.center,
                                                              title: Text('${inventory['inventory_name']} | ${inventory['status_name']}'),
                                                              subtitle: Text('${inventory['inventory_id']}'),
                                                              onTap: () {
                                                                showDialog(
                                                                  context: context, 
                                                                  builder: (_){
                                                                    return AlertDialog(
                                                                      title: Text('Detail Assets ${inventory['inventory_name']}', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),),
                                                                      content: Column(
                                                                        children: [
                                                                          SizedBox(height: 20.h,),
                                                                          SizedBox(
                                                                            width: MediaQuery.of(context).size.width - 150.w,
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Nama Inventaris', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      Text(inventory['inventory_name'])
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Kategori Inventaris', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      Text(inventory['inventory_category_name'])
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Nomor Inventaris', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      Text(inventory['inventory_id'])
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(height: 20.sp,),
                                                                          SizedBox(
                                                                            width: MediaQuery.of(context).size.width - 150.w,
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Tanggal Pembelian', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      Text(formatDate(inventory['purchase_date']))
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Tanggal Akhir Garansi', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      Text(formatDate(inventory['warranty_date']))
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Kondisi Inventaris', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      Text(inventory['condition_name'])
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(height: 20.sp,),
                                                                          SizedBox(
                                                                            width: MediaQuery.of(context).size.width - 150.w,
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Karyawan yang bertanggung jawab', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      Text(inventory['employee_name'])
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Lokasi Inventaris', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      Text(inventory['inventory_location'])
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Metode Pembelian', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      Text(inventory['payment_method'])
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(height: 20.sp,),
                                                                          SizedBox(
                                                                            width: MediaQuery.of(context).size.width - 150.w,
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Periode Cicilan', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      if(inventory['payment_method'] == 'Cash')
                                                                                        const Text('-'),
                                                                                      if(inventory['payment_method'] == 'Kredit dengan cicilan')
                                                                                        Text(inventory['inventory_installment_name'])
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Tanggal Jatuh Tempo', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      if(inventory['payment_method'] == 'Cash')
                                                                                        const Text('-'),
                                                                                      if(inventory['payment_method'] == 'Kredit dengan cicilan')
                                                                                        Text(jatuhTempoFormatDate(inventory['due_date']))
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Jumlah Cicilan', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      if(inventory['payment_method'] == 'Cash')
                                                                                        const Text('-'),
                                                                                      if(inventory['payment_method'] == 'Kredit dengan cicilan')
                                                                                        Text(formatCurrency(inventory['installment_price']))
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(height: 20.sp,),
                                                                          SizedBox(
                                                                            width: MediaQuery.of(context).size.width - 150.w,
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Harga pembelian', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      Text(formatCurrency(inventory['purchase_price']))
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Nama Manufaktur/Supplier', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      Text(inventory['supplier_name'])
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w) / 3,
                                                                                  child: const Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(height: 20.sp,),
                                                                          SizedBox(
                                                                            width: MediaQuery.of(context).size.width - 150.w,
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: (MediaQuery.of(context).size.width - 150.w),
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text('Catatan', style: TextStyle(
                                                                                        fontSize: 4.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color.fromRGBO(116, 116, 116, 1)
                                                                                      ),),
                                                                                      SizedBox(height: 10.h,),
                                                                                      Text(inventory['inventory_notes'])
                                                                                    ],
                                                                                  )
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
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
                                                              trailing: ElevatedButton(
                                                                onPressed: (){
                                                                  inventoryId = inventory['inventory_id'];
                                                                  actionRequestInventory('5');
                                                                }, 
                                                                style: ElevatedButton.styleFrom(
                                                                  elevation: 0,
                                                                  alignment: Alignment.center,
                                                                  minimumSize: Size(40.w, 55.h),
                                                                  foregroundColor: const Color(0xFFFFFFFF),
                                                                  backgroundColor: const Color(0xff4ec3fc),
                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                                ),
                                                                child: const Text('Berikan ke karyawan')
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    }
                                                  }
                                                )
                                              ],
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
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      alignment: Alignment.center,
                                      minimumSize: Size(40.w, 55.h),
                                      foregroundColor: const Color(0xFFFFFFFF),
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Serahkan Asset Lain')
                                  ),
                                  SizedBox(width: 5.w,),
                                  ElevatedButton(
                                    onPressed: (){
                                      
                                    }, 
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      alignment: Alignment.center,
                                      minimumSize: Size(40.w, 55.h),
                                      foregroundColor: const Color(0xFFFFFFFF),
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Serahkan Asset ke Karyawan')
                                  ),
                                ],
                              ),
                          ],
                        ),
                        SizedBox(height: 10.sp,),
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
    
  String formatCurrency(String value) {
    // Parse the string into a number
    double numberValue = double.parse(value);

    // Create a currency formatter
    NumberFormat formatter = NumberFormat.currency(locale: 'id_ID', decimalDigits: 0, symbol: 'Rp ');

    // Format the number as currency
    return formatter.format(numberValue);
  }       

  String _formatDate(String date) {
    // Parse the date string
    DateTime parsedDate = DateFormat("yyyy-MM-dd HH:mm").parse(date);

    // Format the date as "dd MMMM yyyy"
    return DateFormat("d MMMM yyyy HH:mm", 'id').format(parsedDate);
  }

  String formatDate(String dateString) {
    // Parse the input string into a DateTime object
    DateTime dateTime = DateTime.parse(dateString);

    // Define the desired output format
    final DateFormat formatter = DateFormat('dd MMMM yyyy', 'id');

    // Format the DateTime object into a string
    return formatter.format(dateTime);
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