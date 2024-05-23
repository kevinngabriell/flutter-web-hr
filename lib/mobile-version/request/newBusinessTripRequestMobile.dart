import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/mobile-version/absen.dart';
import 'package:hr_systems_web/mobile-version/indexMobile.dart';
import 'package:hr_systems_web/mobile-version/permission/viewAllMyPermission.dart';
import 'package:hr_systems_web/mobile-version/profileMobile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewBusinessTripRequestMobile extends StatefulWidget {
  const NewBusinessTripRequestMobile({super.key});

  @override
  State<NewBusinessTripRequestMobile> createState() => _NewBusinessTripRequestMobileState();
}

class _NewBusinessTripRequestMobileState extends State<NewBusinessTripRequestMobile> {
  final storage = GetStorage();
  bool isLoading = false;
  String employeeId = GetStorage().read('employee_id').toString();
  final int _currentIndex = 0;
  String? leaveoptions;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
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


  Future<void> checkLocation() async {

  try {
    isLoading = true;
    String employeeId = storage.read('employee_id').toString();
    double targetLatitude;
    double targetLongitude;
    String locationName = '';

    final response = await http.get(
      Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/absent/checkabsencelocation.php?employee_id=$employeeId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        // Access the 'Data' key which contains a list of items
        List<dynamic> dataList = data['Data'];
        if (dataList.isNotEmpty) {
          // Assuming you want the first item in the list
          Map<String, dynamic> firstItem = dataList[0];

          setState(() async {
            locationName = firstItem['absence_location'] as String;
            targetLongitude = double.parse(firstItem['longitude']?.toString() ?? '0.0');
            targetLatitude = double.parse(firstItem['latitude']?.toString() ?? '0.0');

            if(locationName == "Free"){
              final cameras = await availableCameras();
              final firstCamera = cameras.last;
              setState(() {
                isLoading = false;
              });
              Get.to(TakePictureScreen(camera: firstCamera));
            } else {
              LocationPermission permission = await Geolocator.checkPermission();
              if (permission == LocationPermission.denied) {
                permission = await Geolocator.requestPermission();
              }

              if (permission == LocationPermission.deniedForever) {
                // Handle denied forever case
                print("Location permission denied forever");
                return;
              }

              if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
                Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best,);

                double tolerance = 500;

                double distance = Geolocator.distanceBetween(
                  position.latitude,
                  position.longitude,
                  targetLatitude,
                  targetLongitude,
                );

                print("User's Latitude: ${position.latitude}");
                print("User's Longitude: ${position.longitude}");
                print("Target Latitude: $targetLatitude");
                print("Target Longitude: $targetLongitude");
                print("Distance: $distance");

                if (distance <= tolerance) {
                  final cameras = await availableCameras();
                  final firstCamera = cameras.last;
                  setState(() {
                    isLoading = false;
                  });
                  Get.to(TakePictureScreen(camera: firstCamera));
                } else {
                  setState(() {
                    isLoading = false;
                  });
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Error"),
                      content: const Text("Anda berada diluar area kantor dan tidak dapat melakukan absen pada saat ini"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                }
              }
            }
          });
        } else {
          throw Exception('No data available in the response.');
        }
      } else {
        throw Exception('Failed to load data. StatusCode: ${data['StatusCode']}');
      }
    } else {
      throw Exception('Failed to load data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    // Handle the error as needed, e.g., show a user-friendly message
  } finally {
    isLoading = false;
  }
}

void _changeSelectedNavBar(int index) {
  String employeeId = storage.read('employee_id').toString();
    setState(() {
      if (index == 0) {
        Get.to(indexMobile(EmployeeID: employeeId,));
      }else if(index == 1){
        // _currentMenu = 'Order';
      }else if(index == 2){
        FutureBuilder<void>(
          future: checkLocation(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            switch (snapshot.connectionState) {
                case ConnectionState.none:
              return const Text('Press button to start.');
                case ConnectionState.active:
                case ConnectionState.waiting:
              return const CircularProgressIndicator();
                case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return const Text('Location checked successfully!');
            }
          },
        );
      }else if(index == 3){
        Get.to(viewAllMyPermissionMobile());
      } else if (index == 4){
        Get.to(MyProfileMobile(employeeId: employeeId,));
      }
    });
  }
  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDinasKotaData();
    fetchDropdownData();
  }

  Future<void> fetchData() async {
    try {
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

          txtNamaKaryawan.text = employeeName;
          txtDeptKaryawan.text = data['department_name'] as String;
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e');
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
                      Get.to(indexMobile(EmployeeID: employeeId.toString()));
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
                      Get.to(indexMobile(EmployeeID: employeeId.toString()));
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
                      Get.to(indexMobile(EmployeeID: employeeId.toString()));
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
    var photo = storage.read('photo');
    var employee_name = storage.read('employee_name');
    var position_name = storage.read('position_name');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.only(left: 7.sp, right: 7.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h,),
               Center(child: Text('Formulir Perjalanan Dinas', style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),)),
                      SizedBox(height: 15.h,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp,),
                  Text('Nama Lengkap',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromRGBO(116, 116, 116, 1)
                    ),
                  ),
                  SizedBox(height: 7.h,),
                  Text(txtNamaKaryawan.text)
                ]
              ),
              SizedBox(height: 10.h,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp,),
                  Text('Departemen',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromRGBO(116, 116, 116, 1)
                    ),
                  ),
                  SizedBox(height: 7.h,),
                  Text(txtDeptKaryawan.text)
                ]
              ),
              SizedBox(height: 10.h,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp,),
                  Text('Kota Tujuan',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromRGBO(116, 116, 116, 1)
                    ),
                  ),
                  SizedBox(height: 7.h,),
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
                ]
              ),
              SizedBox(height: 10.h,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp,),
                  Text('Lama Perjalanan', 
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                  SizedBox(height: 7.h,),
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
                ]
              ),
              SizedBox(height: 10.h,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp,),
                  Text('Keperluan', 
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                  SizedBox(height: 7.h,),
                  TextFormField(
                                    controller: txtKeperluan,
                                    maxLines: 3,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan keperluan'
                                    ),
                                  )
                ]
              ),
              SizedBox(height: 10.h,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp,),
                  Text('Tim Analis/Teknisi', 
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                  SizedBox(height: 7.h,),
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
                ]
              ),
              SizedBox(height: 10.h,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp,),
                  Text('Anggota 1', 
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                  SizedBox(height: 7.h,),
                  TextFormField(
                                    controller: txtAnggota1,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan nama anggota 1'
                                    ),
                                  )
                ]
              ),
              SizedBox(height: 10.h,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp,),
                  Text('Anggota 2', 
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                  SizedBox(height: 7.h,),
                  TextFormField(
                                    controller: txtAnggota2,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan nama anggota 2'
                                    ),
                                  )
                ]
              ),
              SizedBox(height: 10.h,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp,),
                  Text('Anggota 3', 
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                  SizedBox(height: 7.h,),
                  TextFormField(
                                    controller: txtAnggota3,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan nama anggota 3'
                                    ),
                                  )
                ]
              ),
              SizedBox(height: 10.h,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp,),
                  Text('Anggota 4', 
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                  SizedBox(height: 7.h,),
                  TextFormField(
                                    controller: txtAnggota4,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                                      hintText: 'Masukkan nama anggota 4'
                                    ),
                                  )
                ]
              ),
              SizedBox(height: 10.h,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp,),
                  Text('Biaya', 
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                  SizedBox(height: 7.h,),
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
                ]
              ),
              SizedBox(height: 10.h,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp,),
                  Text('Transportasi', 
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(116, 116, 116, 1)
                                    ),
                                  ),
                  SizedBox(height: 7.h,),
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
                ]
              ),
              SizedBox(height: 35.h,),
                        Center(
                          child: 
                          ElevatedButton(
                            onPressed: () {
                              if(selectedKotaTujuan == ''){
                                  dialogError('Kota tujuan tidak dapat kosong !!');
                                } else if (txtKeperluan.text == ''){
                                  dialogError('Keperluan tidak dapat kosong !!');
                                } else if (selectedTim == null){
                                  dialogError('Tim harus dipilih !!');
                                } else {
                                  perjalananDinas();
                                }
                            }, 
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(40.w, 55.h),
                              foregroundColor: const Color(0xFFFFFFFF),
                              backgroundColor: const Color(0xff4ec3fc),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Kumpulkan')
                          ),
                        ),
                        SizedBox(height: 35.h,),
            ]
          )
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _changeSelectedNavBar,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        unselectedItemColor: const Color.fromRGBO(221, 221, 221, 1),
        unselectedIconTheme: const IconThemeData(
          color: Color.fromRGBO(221, 221, 221, 1)
        ),
        unselectedLabelStyle: const TextStyle(
          color: Colors.black
        ),
        selectedItemColor: const Color.fromRGBO(78, 195, 252, 1),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schema),
            label: 'Training',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Absen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Izin',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profil',
          ),
        ],
      ),
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