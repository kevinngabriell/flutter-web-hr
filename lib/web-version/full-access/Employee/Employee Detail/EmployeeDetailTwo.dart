import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/Employee%20Detail/EmployeeDetailThree.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class EmployeeDetailTwo extends StatefulWidget {
  final String employeeID;
  EmployeeDetailTwo(this.employeeID, {super.key});

  @override
  State<EmployeeDetailTwo> createState() => _EmployeeDetailTwoState();
}

class _EmployeeDetailTwoState extends State<EmployeeDetailTwo> {
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  final storage = GetStorage();
  bool isLoading = false;

  TextEditingController txtAlamatBefore = TextEditingController();
  TextEditingController txtRtBefore = TextEditingController();
  TextEditingController txtRwBefore = TextEditingController();
  String selectedStatusBefore = '';

  TextEditingController txtAlamatAfter = TextEditingController();
  TextEditingController txtRtAfter = TextEditingController();
  TextEditingController txtRwAfter = TextEditingController();
  String selectedStatusAfter = '';

  List<Map<String, String>> addressStatuses = [];

  String selectedProvinceBefore = '';
  String selectedProvinceAfter = '';
  List<Map<String, String>> provinceList = [];

  String selectedCityBefore = '';
  String selectedCityAfter = '';
  List<Map<String, String>> cityList = [];

  List<Map<String, String>> identityCityList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDetailData();
    fetchAddressStatuses();
    fetchProvinceList();
  }

  Future<void> fetchCityList(String? provinceId) async {
    if (provinceId != null) {
      final response = await http.get(
          Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getkotakab.php?provinsi=$provinceId'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['StatusCode'] == 200) {
          final cities = (data['Data'] as List).map((city) => Map<String, String>.from({'id': city['id'],'name': city['name'],})).toList();
          selectedCityBefore = cities[0]['id']!;
          // setState(() {
          //   if (isDomicile) {
          //     domicileCityList = cities;
          //     selectedDomicileCity = domicileCityList.isNotEmpty ? domicileCityList[0]['id'] : null;
          //   } else {
          //     identityCityList = cities;
          //     selectedIdentityCity = identityCityList.isNotEmpty ? identityCityList[0]['id'] : null;
          //   }
          // });
        } else {
          print('Failed to fetch city list');
        }
      } else {
        print('Failed to fetch data');
      }
    }
  }

  Future<void> fetchProvinceList() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getprovince.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        final provinces = (data['Data'] as List)
            .map((province) => Map<String, String>.from({
                  'id': province['id'],
                  'name': province['name'],
                }))
            .toList();

        setState(() {
          provinceList = provinces;
          if (provinceList.isNotEmpty) {
            selectedProvinceAfter = provinceList[0]['id']!;
          }
        });
      } else {
        // Handle API error
        print('Failed to fetch province list');
      }
    } else {
      // Handle HTTP error
      print('Failed to fetch data');
    }
  }

  Future<void> fetchAddressStatuses() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getaddressstatus.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        final addressStatusList = (data['Data'] as List)
            .map((addressStatus) => Map<String, String>.from({
                  'address_status_id': addressStatus['address_status_id'],
                  'address_status_name': addressStatus['address_status_name'],
                }))
            .toList();

        setState(() {
          addressStatuses = addressStatusList;
          if (addressStatuses.isNotEmpty) {
            selectedStatusAfter = addressStatuses[0]['address_status_id']!;
          }
        });
      } else {
        // Handle API error
        print('Failed to fetch address statuses');
      }
    } else {
      // Handle HTTP error
      print('Failed to fetch data');
    }
  }

  Future<void> fetchDetailData() async {
    try{
      isLoading = true;

      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployee.php?action=2&employee_id=${widget.employeeID}';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        Map<String, dynamic> data = (responseData['Data'] as List).first;

        setState(() {
          txtAlamatBefore.text = data['employee_address_ktp'];
          txtRtBefore.text = data['employee_rt_ktp'];
          txtRwBefore.text = data['employee_rw_ktp'];
          selectedStatusBefore = data['employee_address_status_ktp'];
          selectedProvinceBefore = data['employee_provinsi_ktp'];
          fetchCityList(selectedProvinceBefore);
          selectedCityBefore = data['employee_kota_kab_ktp'];
          
          if(selectedStatusBefore == ''){
            selectedStatusBefore = 'AS-HR-001';
          }

          if(selectedProvinceBefore == ''){
            selectedProvinceBefore = '31';
          }

          if(selectedCityBefore == ''){
            selectedCityBefore = '3173';
          }
        });

      } else {
        txtAlamatBefore.text = '';
        txtRtBefore.text = '';
        txtRwBefore.text = '';
        if(selectedStatusBefore == ''){
            selectedStatusBefore = 'AS-HR-001';
          }

          if(selectedProvinceBefore == ''){
            selectedProvinceBefore = '31';
          }

          if(selectedCityBefore == ''){
            selectedCityBefore = '3173';
          }
        print('Failed to load data: ${response.statusCode}');
      }

    } catch (e){
      print('Error at fetching detail one data : $e');
      txtAlamatBefore.text = '';
      txtRtBefore.text = '';
      txtRwBefore.text = '';
      if(selectedStatusBefore == ''){
        selectedStatusBefore = 'AS-HR-001';
      }

      if(selectedProvinceBefore == ''){
        selectedProvinceBefore = '31';
      }

      if(selectedCityBefore == ''){
        selectedCityBefore = '3173';
      }
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
        body: isLoading ? const CircularProgressIndicator() : SingleChildScrollView(
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
                      Center(child: Text('Data Saat Ini',style: TextStyle(fontSize: 5.sp,fontWeight: FontWeight.w700,))),
                      SizedBox(height: 7.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 88.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Alamat sesuai KTP',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: txtAlamatBefore,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alamat sesuai KTP'
                                  ),
                                  readOnly: true,
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
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('RT',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  controller: txtRtBefore,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alamat sesuai KTP'
                                  ),
                                  readOnly: true,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('RW',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  controller: txtRwBefore,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alamat sesuai KTP'
                                  ),
                                  readOnly: true,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 50.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Status',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                DropdownButtonFormField<String>(
                                  value: selectedStatusBefore,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedStatusBefore = newValue!;
                                    });
                                  },
                                  items: addressStatuses.map<DropdownMenuItem<String>>(
                                    (Map<String, String> status) {
                                      return DropdownMenuItem<String>(
                                        value: status['address_status_id']!,
                                        child: Text(status['address_status_name']!),
                                      );
                                    },
                                  ).toList(),
                                ),
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
                                Text('Provinsi',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                DropdownButtonFormField<String>(
                                  hint: const Text("Pilih provinsi"),
                                  value: selectedProvinceBefore,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedProvinceBefore = newValue!;
                                      // fetchCityList(selectedIdentityProvince, false);
                                    });
                                  },
                                  items: provinceList.map<DropdownMenuItem<String>>(
                                    (Map<String, String> province) {
                                      return DropdownMenuItem<String>(
                                        value: province['id']!,
                                        child: Text(province['name']!),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Kota/Kab',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                DropdownButtonFormField<String>(
                                  hint: const Text("Pilih kota/kabupaten KTP"),
                                  value: selectedCityBefore,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedCityBefore = newValue!;
                                      // fetchRegencyList(selectedIdentityCity, false);
                                    });
                                  },
                                  items: identityCityList.map<DropdownMenuItem<String>>(
                                    (Map<String, String> city) {
                                      return DropdownMenuItem<String>(
                                        value: city['id']!,
                                        child: Text(city['name']!),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Kecamatan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                              ],
                            ),
                          )
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
                                Text('Kelurahan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
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
                      Center(child: Text('Data Saat Baru',style: TextStyle(fontSize: 5.sp,fontWeight: FontWeight.w700,))),
                      SizedBox(height: 7.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 88.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Alamat sesuai KTP',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  maxLines: 4,
                                  // controller: alamatKTP,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alamat sesuai KTP'
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
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('RT',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  // controller: alamatKTP,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alamat sesuai KTP'
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('RW',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                TextFormField(
                                  // controller: alamatKTP,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alamat sesuai KTP'
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 50.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Status',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                DropdownButtonFormField<String>(
                                  value: selectedStatusAfter,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedStatusAfter = newValue!;
                                    });
                                  },
                                  items: addressStatuses.map<DropdownMenuItem<String>>(
                                    (Map<String, String> status) {
                                      return DropdownMenuItem<String>(
                                        value: status['address_status_id']!,
                                        child: Text(status['address_status_name']!),
                                      );
                                    },
                                  ).toList(),
                                ),
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
                                Text('Provinsi',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                                DropdownButtonFormField<String>(
                                  hint: const Text("Pilih provinsi"),
                                  value: selectedProvinceAfter,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedProvinceAfter = newValue!;
                                      // fetchCityList(selectedIdentityProvince, false);
                                    });
                                  },
                                  items: provinceList.map<DropdownMenuItem<String>>(
                                    (Map<String, String> province) {
                                      return DropdownMenuItem<String>(
                                        value: province['id']!,
                                        child: Text(province['name']!),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Kota/Kab',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 100.w) / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Kecamatan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
                              ],
                            ),
                          )
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
                                Text('Kelurahan',style: TextStyle(fontSize: 4.sp,fontWeight: FontWeight.w600,)),
                                SizedBox(height: 2.sp,),
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
                                  Get.to(EmployeeDetailThree(employeeID: widget.employeeID));
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
                      SizedBox(height: 17.sp,)
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