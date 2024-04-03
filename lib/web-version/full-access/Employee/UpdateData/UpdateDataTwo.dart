// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/EmployeeList.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/UpdateData/UpdateDataThree.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UpdateDataTwo extends StatefulWidget {
  final String employeeId;
  const UpdateDataTwo({super.key, required this.employeeId});

  @override
  State<UpdateDataTwo> createState() => _UpdateDataTwoState();
}

class _UpdateDataTwoState extends State<UpdateDataTwo> {
  bool KTPDomisili = true;

  TextEditingController alamatKTP = TextEditingController();
  TextEditingController rtKTP = TextEditingController();
  TextEditingController rwKTP = TextEditingController();
  TextEditingController alamatDomisili = TextEditingController();
  TextEditingController rtDomisili = TextEditingController();
  TextEditingController rwDomisili = TextEditingController();
  TextEditingController nomorHandphone = TextEditingController();
  TextEditingController alamatEmail = TextEditingController();

  String nomorHandphoneText = '';
  String alamatEmailText = '';
  String id = '';

  String? selectedDomicileProvince;
  String? selectedIdentityProvince;
  List<Map<String, String>> provinceList = [];

  String? selectedDomicileCity;
  String? selectedIdentityCity;
  List<Map<String, String>> domicileCityList = [];
  List<Map<String, String>> identityCityList = [];

  String? selectedDomicileRegency;
  String? selectedIdentityRegency;
  List<Map<String, String>> domicileRegencyList = [];
  List<Map<String, String>> identityRegencyList = [];

  String? selectedDomicileDistrict;
  String? selectedIdentityDistrict;
  List<Map<String, String>> domicileDistrictList = [];
  List<Map<String, String>> identityDistrictList = [];

  String? selectedAddressStatus;
  List<Map<String, String>> addressStatuses = [];
  String? selectedAddressStatus2;
  List<Map<String, String>> addressStatuses2 = [];

  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  List<dynamic> profileData = [];

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchProvinceList();
    fetchAddressStatuses();
    fetchAddressStatuses2();
    fetchData();
    fetchDetailData();
  }

  Future<void> fetchDetailData() async {
    try{
      isLoading = true;

      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployee.php?action=2&employee_id=${widget.employeeId}';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        Map<String, dynamic> data = (responseData['Data'] as List).first;

        setState(() {
          alamatKTP.text = data['employee_address_ktp'] ?? '-';
          rtKTP.text = data['employee_rt_ktp'] ?? '-';
          rwKTP.text = data['employee_rw_ktp'] ?? '-';
          alamatDomisili.text = data['employee_address_now'] ?? '-';
          rtDomisili.text = data['employee_rt_now'] ?? '-';
          rwDomisili.text = data['employee_rw_now'] ?? '-';
          alamatEmail.text = data['employee_email'] ?? '-';
          nomorHandphone.text = data['employee_phone_number'] ?? '-';
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

  final storage = GetStorage();

  Future<void> fetchData() async {
    String employeeId = storage.read('employee_id').toString();

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
            selectedDomicileProvince = provinceList[0]['id'];
            selectedIdentityProvince = provinceList[0]['id'];
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

  Future<void> fetchCityList(String? provinceId, bool isDomicile) async {
    if (provinceId != null) {
      final response = await http.get(
          Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getkotakab.php?provinsi=$provinceId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['StatusCode'] == 200) {
          final cities = (data['Data'] as List)
              .map((city) => Map<String, String>.from({
                    'id': city['id'],
                    'name': city['name'],
                  }))
              .toList();

          setState(() {
            if (isDomicile) {
              domicileCityList = cities;
              selectedDomicileCity = domicileCityList.isNotEmpty ? domicileCityList[0]['id'] : null;
            } else {
              identityCityList = cities;
              selectedIdentityCity = identityCityList.isNotEmpty ? identityCityList[0]['id'] : null;
            }
          });
        } else {
          print('Failed to fetch city list');
        }
      } else {
        print('Failed to fetch data');
      }
    }
  }
  
  Future<void> fetchRegencyList(String? cityId, bool isDomicile) async {
    if (cityId != null) {
      final response = await http.get(
          Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getkecamatan.php?kotakab=$cityId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['StatusCode'] == 200) {
          final regencies = (data['Data'] as List)
              .map((regency) => Map<String, String>.from({
                    'id': regency['id'],
                    'name': regency['name'],
                  }))
              .toList();

          setState(() {
            if (isDomicile) {
              domicileRegencyList = regencies;
              selectedDomicileRegency = domicileRegencyList.isNotEmpty ? domicileRegencyList[0]['id'] : null;
            } else {
              identityRegencyList = regencies;
              selectedIdentityRegency = identityRegencyList.isNotEmpty ? identityRegencyList[0]['id'] : null;
            }
          });
        } else {
          print('Failed to fetch regency list');
        }
      } else {
        print('Failed to fetch data');
      }
    }
  }
  
  Future<void> fetchDistrictList(String? regencyId, bool isDomicile) async {
    if (regencyId != null) {
      final response = await http.get(
          Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getkelurahan.php?kecamatan=$regencyId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['StatusCode'] == 200) {
          final districts = (data['Data'] as List)
              .map((district) => Map<String, String>.from({
                    'id': district['id'],
                    'name': district['name'],
                  }))
              .toList();

          setState(() {
            if (isDomicile) {
              domicileDistrictList = districts;
              selectedDomicileDistrict = domicileDistrictList.isNotEmpty ? domicileDistrictList[0]['id'] : null;
            } else {
              identityDistrictList = districts;
              selectedIdentityDistrict = identityDistrictList.isNotEmpty ? identityDistrictList[0]['id'] : null;
            }
          });
        } else {
          print('Failed to fetch district list');
        }
      } else {
        print('Failed to fetch data');
      }
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
            selectedAddressStatus = addressStatuses[0]['address_status_id'];
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

  Future<void> fetchAddressStatuses2() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/masterdata/getaddressstatus.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        final addressStatusList2 = (data['Data'] as List)
            .map((addressStatus2) => Map<String, String>.from({
                  'address_status_id': addressStatus2['address_status_id'],
                  'address_status_name': addressStatus2['address_status_name'],
                }))
            .toList();

        setState(() {
          addressStatuses2 = addressStatusList2;
          if (addressStatuses2.isNotEmpty) {
            selectedAddressStatus2 = addressStatuses2[0]['address_status_id'];
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

  Future<void> insertEmployee() async {
    try{
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/insertemployee/inserttwo.php';

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "employee_address_ktp": alamatKTP.text,
          "employee_address_status_ktp": selectedAddressStatus,
          "employee_rt_ktp": rtKTP.text,
          "employee_rw_ktp": rwKTP.text,
          "employee_provinsi_ktp": selectedIdentityProvince,
          "employee_kota_kab_ktp": selectedIdentityCity,
          "employee_kec_ktp": selectedIdentityRegency,
          "employee_kel_ktp": selectedIdentityDistrict,
          "employee_address_now": alamatDomisili.text,
          "employee_address_status_now": selectedAddressStatus2,
          "employee_rt_now": rtDomisili.text,
          "employee_rw_now": rwDomisili.text,
          "employee_provinsi_now": selectedDomicileProvince,
          "employee_kot_kab_now": selectedDomicileCity,
          "employee_kec_now": selectedDomicileRegency,
          "employee_kel_now": selectedDomicileDistrict,
          "employee_email": alamatEmailText,
          "employee_phone_number": nomorHandphoneText,
          "id": widget.employeeId,
        }
      );

      if (response.statusCode == 200) {
        Get.to(UpdateDataThree(employeeId: widget.employeeId,));
      } else {
        showDialog(
          context: context, 
          builder: (_){
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Error dengan response ${response.body}'),
              actions: [
                TextButton(
                  onPressed: (){
                    Get.to(const EmployeeListPage());
                  }, 
                  child: const Text('Kembali')
                )
              ],
            );
          }
        );
      }

    } catch (e){
      isLoading = false;
      showDialog(
          context: context, 
          builder: (_){
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Error dengan response $e'),
              actions: [
                TextButton(
                  onPressed: (){
                    Get.to(const EmployeeListPage());
                  }, 
                  child: const Text('Kembali')
                )
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
    // Access the GetStorage instance
    final storage = GetStorage();

    // Retrieve the stored employee_id
    var employeeId = storage.read('employee_id');
    var photo = storage.read('photo');
    var positionId = storage.read('position_id');
    
    return MaterialApp(
      title: "Tambah Karyawan - Data Alamat",
      home: Scaffold(
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
                      LaporanNonActive(positionId: positionId),
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
                      //statistik card
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Alamat sesuai KTP",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: alamatKTP,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alamat sesuai KTP'
                                  ),
                                  readOnly: false,
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
                            width: (MediaQuery.of(context).size.width- 100.w) / 8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("RT",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: rtKTP,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: '000'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("RW",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: rwKTP,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: '000'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 245.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Status",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DropdownButtonFormField<String>(
                                  value: selectedAddressStatus,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedAddressStatus = newValue;
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
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 210.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Provinsi",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DropdownButtonFormField<String>(
                                  hint: const Text("Pilih provinsi"),
                                  value: selectedIdentityProvince,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedIdentityProvince = newValue;
                                      fetchCityList(selectedIdentityProvince, false);
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
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Kota/Kab",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DropdownButtonFormField<String>(
                                  hint: const Text("Pilih kota/kabupaten KTP"),
                                  value: selectedIdentityCity,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedIdentityCity = newValue;
                                      fetchRegencyList(selectedIdentityCity, false);
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
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Kecamatan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DropdownButtonFormField<String>(
                                  hint: const Text("Pilih kecamatan"),
                                  value: selectedIdentityRegency,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedIdentityRegency = newValue;
                                      fetchDistrictList(selectedIdentityRegency, false);
                                    });
                                  },
                                  items: identityRegencyList.map<DropdownMenuItem<String>>(
                                    (Map<String, String> regency) {
                                      return DropdownMenuItem<String>(
                                        value: regency['id']!,
                                        child: Text(regency['name']!),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Kelurahan",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                DropdownButtonFormField<String>(
                                  hint: const Text('Pilih kelurahan'),
                                  value: selectedIdentityDistrict,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedIdentityDistrict = newValue;
                                    });
                                  },
                                  items: identityDistrictList.map<DropdownMenuItem<String>>(
                                    (Map<String, String> district) {
                                      return DropdownMenuItem<String>(
                                        value: district['id']!,
                                        child: Text(district['name']!),
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
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w),
                            child: CheckboxListTile(
                              title: const Text('Alamat domisili sama dengan alamat KTP'),
                              value: KTPDomisili,
                              onChanged:(value) { 
                                setState(() {
                                  KTPDomisili = !KTPDomisili;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 7.sp,),
                      if(KTPDomisili == false)
                        Row(
                          children: [
                            SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Alamat domisili",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  maxLines: 4,
                                  controller: alamatDomisili,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alamat domisili anda saat ini'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          ],
                        ),
                        SizedBox(height: 7.sp,),
                      if (KTPDomisili == false) 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width- 100.w) / 8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("RT",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  TextFormField(
                                    controller: rtDomisili,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: '000'
                                    ),
                                    readOnly: false,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width- 100.w) / 8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("RW",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  TextFormField(
                                    controller: rwDomisili,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: '000'
                                    ),
                                    readOnly: false,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width- 245.w) / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Status",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    hint: const Text('Pilih status domisili'),
                                    value: selectedAddressStatus2,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedAddressStatus2 = newValue;
                                      });
                                    },
                                    items: addressStatuses2.map<DropdownMenuItem<String>>(
                                      (Map<String, String> status2) {
                                        return DropdownMenuItem<String>(
                                          value: status2['address_status_id']!,
                                          child: Text(status2['address_status_name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width- 210.w) / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Provinsi",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    hint: const Text('Pilih provinsi'),
                                    value: selectedDomicileProvince,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedDomicileProvince = newValue;
                                        fetchCityList(selectedDomicileProvince, true);
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
                          ],
                        ),
                        SizedBox(height: 7.sp,),
                      if (KTPDomisili == false) 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width- 100.w) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Kota/Kab",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    hint: const Text('Pilih kota/kab domisili'),
                                    value: selectedDomicileCity,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedDomicileCity = newValue;
                                        fetchRegencyList(selectedDomicileCity, true);
                                      });
                                    },
                                    items: domicileCityList.map<DropdownMenuItem<String>>(
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
                              width: (MediaQuery.of(context).size.width- 100.w) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Kecamatan",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    hint: const Text('Pilih kecamatan domisili'),
                                    value: selectedDomicileRegency,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedDomicileRegency = newValue;
                                        fetchDistrictList(selectedDomicileRegency, true);
                                      });
                                    },
                                    items: domicileRegencyList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> regency) {
                                        return DropdownMenuItem<String>(
                                          value: regency['id']!,
                                          child: Text(regency['name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width- 100.w) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Kelurahan",
                                    style: TextStyle(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  ),
                                  SizedBox(height: 7.h,),
                                  DropdownButtonFormField<String>(
                                    hint: const Text('Pilih keluarahan domisili'),
                                    value: selectedDomicileDistrict,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedDomicileDistrict = newValue;
                                      });
                                    },
                                    items: domicileDistrictList.map<DropdownMenuItem<String>>(
                                      (Map<String, String> district) {
                                        return DropdownMenuItem<String>(
                                          value: district['id']!,
                                          child: Text(district['name']!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      if(KTPDomisili == false)                       
                        SizedBox(height: 7.sp,),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Alamat Email",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: alamatEmail,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan alamat email karyawan'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5.w,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width- 100.w) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nomor Handphone",
                                  style: TextStyle(
                                    fontSize: 4.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                                SizedBox(height: 7.h,),
                                TextFormField(
                                  controller: nomorHandphone,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                                    hintText: 'Masukkan nomor handphone karyawan'
                                  ),
                                  readOnly: false,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
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
                                    elevation: 0,
                                    alignment: Alignment.center,
                                    minimumSize: Size(60.w, 55.h),
                                    foregroundColor: const Color(0xFFFFFFFF),
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('Kembali')
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: (){
                                    insertEmployee();
                                  }, 
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    alignment: Alignment.center,
                                    minimumSize: Size(60.w, 55.h),
                                    foregroundColor: const Color(0xFFFFFFFF),
                                    backgroundColor: const Color(0xff4ec3fc),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('Update & Berikutnya')
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10.sp,),
                      SizedBox(height: 7.sp,)
                    ],
                  ),
                )
              ),
            ],
          )
        ),
      ),
    );
  }
}