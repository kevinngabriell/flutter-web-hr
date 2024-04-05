import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Kasbon/kasbonIndex.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:hr_systems_web/web-version/full-access/Salary/currencyformatter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class kasbonDetail extends StatefulWidget {
  final String kasbonID;
  final String kasbonDate;
  final String kasbonAmount;
  final String kasbonKeterangan;
  final String namaKasbon;
  final String namaHRD;
  final String tanggalPengajuan;
  final String isPaid;
  const kasbonDetail({super.key, required this.kasbonDate, required this.kasbonAmount, required this.kasbonKeterangan, required this.namaKasbon, required this.namaHRD, required this.tanggalPengajuan, required this.isPaid, required this.kasbonID});

  @override
  State<kasbonDetail> createState() => _kasbonDetailState();
}

class _kasbonDetailState extends State<kasbonDetail> {
  final storage = GetStorage();
  bool isLoading = false;
  String companyName = '';
  String companyAddress = '';
  String trimmedCompanyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  List<Map<String, dynamic>> kasbonData = [];
  TextEditingController txtAmountPembayaran = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchKasbonData();
  }

  Future<void> fetchKasbonData() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/kasbon/getkasbon.php?action=3&id_kasbon=${widget.kasbonID}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        kasbonData = List<Map<String, dynamic>>.from(data['Data']);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> actionKasbon() async {
    try{
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/kasbon/kasbon.php';
      String employeeId = storage.read('employee_id').toString();

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "action" : "2",
          "id_kasbon" : widget.kasbonID,
          "amount" : txtAmountPembayaran.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "insert_by" : employeeId,
        }
      );

      if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: const Text('Anda telah berhasil update data kasbon'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const kasbonIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        } else {
          print(response.body + response.statusCode.toString());
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error ${response.statusCode}'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(const kasbonIndex());
                    }, 
                    child: const Text("Oke")
                  ),
                ],
              );
            }
          );
        }
    } catch (e){
      isLoading = false;
      showDialog(
        context: context, 
        builder: (_) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text('Error $e'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.to(const kasbonIndex());
              }, 
              child: const Text("Oke")
            ),
          ],
        );}
      );
    } finally {
      isLoading = false;
    }
  }
  
  String formatCurrency2(String value) {
    // Parse the string to a number.
    double numberValue = double.tryParse(value) ?? 0;

    // Format the number as currency.
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0).format(numberValue);
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

        // Ensure that the fields are of the correct type
        setState(() {
          companyName = data['company_name'] as String;
          companyAddress = data['company_address'] as String;
          trimmedCompanyAddress = companyAddress.substring(0, 15);
          employeeName = data['employee_name'] as String;
          employeeEmail = data['employee_email'] as String;
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

    String lunas = widget.isPaid == '0' ? 'Belum Lunas' : 'Sudah Lunas';

    return MaterialApp(
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
                    ]
                  )
                )
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showTransactionHistory();
                            },
                            child: Text('Riwayat Transaksi', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w400, color: const Color(0xFF2A85FF)))
                          )
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tanggal Pengajuan',style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                SizedBox(height: 4.h,),
                                Text(_formatDate(widget.tanggalPengajuan))
                              ],
                            ),
                          ),
                          SizedBox(height: 2.h,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Diinput oleh',style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                SizedBox(height: 4.h,),
                                Text(widget.namaHRD)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Status lunas',style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                SizedBox(height: 4.h,),
                                Text(lunas)
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      Text('Detail Kasbon', style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w600,)),
                      SizedBox(height: 7.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tanggal Kasbon',style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                SizedBox(height: 4.h,),
                                Text(formatDate(widget.kasbonDate))
                              ],
                            ),
                          ),
                          SizedBox(height: 2.h,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nama Karyawan',style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                SizedBox(height: 4.h,),
                                Text(widget.namaKasbon)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Keperluan',style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                SizedBox(height: 4.h,),
                                Text(widget.kasbonKeterangan)
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Jumlah Kasbon',style: TextStyle(
                                  fontSize: 4.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                                SizedBox(height: 4.h,),
                                Text(formatCurrency2(widget.kasbonAmount))
                              ],
                            ),
                          ),
                          SizedBox(height: 2.h,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: (){
                              showDialogpembayaran();
                            }, 
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              alignment: Alignment.center,
                              minimumSize: Size(40.w, 55.h),
                              foregroundColor: const Color(0xFFFFFFFF),
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text('Pembayaran')
                          )
                        ],
                      ),
                      SizedBox(height: 15.sp,),
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

  Future<void> showDialogpembayaran(){
    return showDialog(
      context: context, 
      builder: (_){
        return AlertDialog(
          title: Text('Pembayaran Kasbon'),
          content: TextFormField(
            controller: txtAmountPembayaran,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CurrencyFormatter(),
            ],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              fillColor: Color.fromRGBO(235, 235, 235, 1),
              hintText: 'Masukkan jumlah pembayaran'
            ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                Get.back();
              }, 
              child: Text('Kembali')
            ),
            TextButton(
              onPressed: (){
                actionKasbon();
              }, 
              child: Text('Kumpulkan')
            )
          ],
        );
      }
    );
  }

  Future<void> showTransactionHistory(){
    return showDialog(
      context: context, 
      builder: (_){
        return AlertDialog(
          title: Center(child: Text('Riwayat Pembayaran')),
          content: 
          DataTable(
            columns: [
              DataColumn(label: Text('Jenis Kasbon')),
              DataColumn(label: Text('Jumlah')),
              DataColumn(label: Text('Tanggal')),
            ],
            rows: kasbonData.map((data) {
              String paymentLabel =
                  data['transaction_type'] == 1 ? 'Pembayaran' : 'Pinjaman';
              return DataRow(cells: [
                DataCell(Text(paymentLabel)),
                DataCell(Text(formatCurrency2(data['amount'].toString()))),
                DataCell(Text(_formatDate(data['insert_dt']))),
              ]);
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: (){
                Get.back();
              }, 
              child: Text('Tutup')
            )
          ],
        );
      }
    );
  }

  String _formatDate(String date) {
    // Parse the date string
    DateTime parsedDate = DateFormat("yyyy-MM-dd HH:mm").parse(date);

    // Format the date as "dd MMMM yyyy"
    return DateFormat("d MMMM yyyy HH:mm", "id").format(parsedDate);
  }

  String formatDate(String date) {
    // Parse the date string
    DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(date);

    // Format the date as "dd MMMM yyyy"
    return DateFormat("d MMMM yyyy", 'id').format(parsedDate);
  }

}