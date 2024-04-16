import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/mobile-version/absen.dart';
import 'package:hr_systems_web/mobile-version/indexMobile.dart';
import 'package:hr_systems_web/mobile-version/permission/viewAllMyPermission.dart';
import 'package:hr_systems_web/mobile-version/profileMobile.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class newInventoryMobileRequest extends StatefulWidget {
  const newInventoryMobileRequest({super.key});

  @override
  State<newInventoryMobileRequest> createState() => _newInventoryMobileRequestState();
}

class _newInventoryMobileRequestState extends State<newInventoryMobileRequest> {
  final storage = GetStorage();
  bool isLoading = false;
  String employeeId = GetStorage().read('employee_id').toString();
  final int _currentIndex = 0;
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String departmentName = '';
  String positionName = '';
  String trimmedCompanyAddress = '';
  TextEditingController txtNamaLengkap = TextEditingController();
  String namaLengkapText = '';
  TextEditingController txtNIK = TextEditingController();
  String nikText = '';
  TextEditingController txtDepartemen = TextEditingController();
  String departemenText = '';
  TextEditingController txtJabatan = TextEditingController();
  String jabatanText = '';

  List<Map<String, String>> reasons = [];
  String selectedReason = '';

  TextEditingController txtDescInventory = TextEditingController();
  TextEditingController txtKeterangan = TextEditingController();


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
    fetchDataforFilled();
    fetchReason();
  }

  Future<void> fetchReason() async {
    final response = await http.get(
        Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/newinventoryreason.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 200) {
        setState(() {
          reasons = (data['Data'] as List)
              .map((reason) => Map<String, String>.from(reason))
              .toList();

          if (reasons.isNotEmpty) {
            // Set the selectedCompany to the first item in the list by default
            selectedReason = reasons[0]['id_reason'].toString();
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
          txtNamaLengkap.text = employeeName;
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    }
  }

  Future<void> fetchDataforFilled() async {
    setState(() {
      isLoading = true;
    });

    try {
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/getdataforrequestor.php';

      // Replace 'employee_id' with the actual employee ID from storage
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

        setState(() {
          employeeName = data['Data']['employee_name'] as String;
          employeeId = data['Data']['employee_id'] as String;
          departmentName = data['Data']['department_name'] as String;
          positionName = data['Data']['position_name'] as String;

          txtNIK.text = employeeId;
          txtDepartemen.text = departmentName;
          txtJabatan.text = positionName;
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  
  Future<void> sendRequest() async{

    try{
      setState(() {
        isLoading = true;
      });

       String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/newinventoryrequest.php';
       String employeeId = storage.read('employee_id').toString();

       final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "employee_id": employeeId,
            "inventaris": txtDescInventory.text,
            "reason": selectedReason,
            "keterangan": txtKeterangan.text
          }
        );

        if(response.statusCode == 200){
          showDialog(
            context: context, 
            builder: (_) {
              return AlertDialog(
                title: const Text("Sukses"),
                content: const Text("Permintaan inventaris anda telah berhasil diajukan"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(indexMobile(EmployeeID: employeeId,));
                    }, 
                    child: const Text("Oke")
                  ),
                 
                ],
              );
            }
          );
        } else {
          setState(() {
            isLoading = false;
          });
          Get.snackbar('Gagal', response.body);
        }

    } catch (e){
      setState(() {
        isLoading = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
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
               Center(child: Text('Formulir Permohonan Inventaris', style: TextStyle(
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
                  TextFormField(
                    controller: txtNamaLengkap,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                      hintText: 'Masukkan nama karyawan'
                    ),
                  )
                ]
              ),
              SizedBox(height: 10.h,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp,),
                  Text('NIK',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromRGBO(116, 116, 116, 1)
                    ),
                  ),
                  SizedBox(height: 7.h,),
                  TextFormField(
                    controller: txtNIK,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                      hintText: 'Masukkan NIK anda'
                    ),
                  )
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
                  TextFormField(
                    controller: txtDepartemen,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                      hintText: 'Masukkan departemen anda'
                    ),
                  )
                ]
              ),
              SizedBox(height: 10.h,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp,),
                  Text('Jabatan',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromRGBO(116, 116, 116, 1)
                    ),
                  ),
                  SizedBox(height: 7.h,),
                  TextFormField(
                    controller: txtJabatan,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                      hintText: 'Masukkan jabatan anda'
                    ),
                  )
                ]
              ),
              SizedBox(height: 10.h,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp,),
                  Text('Inventaris yang Diajukan',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromRGBO(116, 116, 116, 1)
                    ),
                  ),
                  SizedBox(height: 7.h,),
                  TextFormField(
                    controller: txtDescInventory,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                      hintText: 'Masukkan inventaris yang anda ajukan'
                    ),
                  )
                ]
              ),
              SizedBox(height: 10.h,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp,),
                  Text("Alasan Pengajuan Inventaris",
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromRGBO(116, 116, 116, 1)
                    ),
                  ),
                  SizedBox(height: 7.h,),
                  DropdownButtonFormField<String>(
                                  value: selectedReason,
                                  hint: const Text('Select Reason'),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedReason = newValue.toString();
                                    });
                                  },
                                  items: reasons.map<DropdownMenuItem<String>>((Map<String, String> reason) {
                                    return DropdownMenuItem<String>(
                                      value: reason['id_reason']!,
                                      child: Text(reason['request_reason']!),
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
                  Text("Keterangan",
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromRGBO(116, 116, 116, 1)
                    ),
                  ),
                  SizedBox(height: 7.h,),
                  TextFormField(
                    controller: txtKeterangan,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Color.fromRGBO(235, 235, 235, 1),
                      hintText: 'Masukkan detail dari permintaan anda atau alasan lainnya'
                    ),
                  )
                ]
              ),
              SizedBox(height: 35.h,),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              sendRequest();
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
}