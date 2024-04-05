import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Kasbon/addNewKasbon.dart';
import 'package:hr_systems_web/web-version/full-access/Kasbon/kasbonDetail.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class kasbonIndex extends StatefulWidget {
  const kasbonIndex({super.key});

  @override
  State<kasbonIndex> createState() => _kasbonIndexState();
}

class _kasbonIndexState extends State<kasbonIndex> {
  final storage = GetStorage();
  bool isLoading = false;
  String companyName = '';
  String companyAddress = '';
  String trimmedCompanyAddress = '';
  String employeeName = '';
  String employeeEmail = '';

  String totalKasbon = '';
  String amountKasbon = '';
  List<dynamic> kasbons = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchKasbons();
  }
  
  Future<void> fetchKasbons() async {
    try {
      final response = await http.get(Uri.parse(
          'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/kasbon/getkasbon.php?action=2'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          kasbons = data['Data'];
        });
      } else {
        print('Failed to fetch kasbons');
      }
    } catch (e) {
      print('Error occurred while fetching kasbons: $e');
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

      String url = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/kasbon/getkasbon.php?action=1';
      var statisticResponse = await http.get(Uri.parse(url));

      if (statisticResponse.statusCode == 200) {
        var statisticData = json.decode(statisticResponse.body);

        if (statisticData['StatusCode'] == 200) {
          setState(() {
            totalKasbon = statisticData['Data']['active_kasbon'];
            amountKasbon = statisticData['Data']['jumlah_kasbon'];
          });
        } else {
          print('Data fetch was successful but server returned an error: ${statisticData['Status']}');
        }
      } else {
        print('Failed to load data: ${statisticResponse.statusCode}');
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
                          ElevatedButton(
                            onPressed: (){
                              Get.to(addNewKasbon());
                            }, 
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(40.w, 55.h),
                              foregroundColor: const Color(0xFFFFFFFF),
                              backgroundColor: const Color(0xff4ec3fc),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text('Tambah Kasbon')
                          )
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 2,
                            child: Card(
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                              color: Colors.white,
                              shadowColor: Colors.black,
                              child: Padding(
                                padding: EdgeInsets.all(4.sp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Total Jumlah Kasbon', style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w400,)),
                                    SizedBox(height: 5.h,),
                                    Text(totalKasbon, style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 2,
                            child: Card(
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                              color: Colors.white,
                              shadowColor: Colors.black,
                              child: Padding(
                                padding: EdgeInsets.all(4.sp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Total Nilai Kasbon', style: TextStyle(fontSize: 5.sp, fontWeight: FontWeight.w400,)),
                                    SizedBox(height: 5.h,),
                                    Text(formatCurrency2(amountKasbon), style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10.sp,),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 90.w),
                        child: Card(
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                          color: Colors.white,
                          shadowColor: Colors.black,
                          child: Padding(
                            padding: EdgeInsets.all(4.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('List Kasbon', style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w700),),
                                Text('Pantau dan lihat kasbon yang sudah diajukan', style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w300),),
                                SizedBox(height: 4.h,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  child: ListView.builder(
                                    itemCount: kasbons.length,
                                    itemBuilder: (context, index) {
                                      var kasbon = kasbons[index];
                                      return Padding(
                                        padding: EdgeInsets.only(left: 4.sp, top: 4.sp, right: 4.sp),
                                        child: Card(
                                          child: ListTile(
                                            title: Text(kasbon['karyawan'], style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700),),
                                            subtitle: Text(formatCurrency2(kasbon['kasbon_amount']), style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w300),),
                                            trailing: ElevatedButton(
                                              onPressed: () {
                                                Get.to(kasbonDetail(kasbonDate: kasbon['kasbon_date'], kasbonAmount: kasbon['kasbon_amount'], kasbonKeterangan: kasbon['kasbon_exp'], namaKasbon: kasbon['karyawan'], namaHRD: kasbon['hrd'], tanggalPengajuan: kasbon['insert_dt'], isPaid: kasbon['is_paid'], kasbonID: kasbon['id_kasbon'],));
                                              },
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                alignment: Alignment.center,
                                                minimumSize: Size(40.w, 55.h),
                                                foregroundColor: const Color(0xFFFFFFFF),
                                                backgroundColor: const Color(0xff4ec3fc),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                              ),
                                              child: Text('Detail'),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
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
    );
  }
}