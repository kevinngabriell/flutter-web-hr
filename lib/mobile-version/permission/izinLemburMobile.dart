import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/mobile-version/absen.dart';
import 'package:hr_systems_web/mobile-version/indexMobile.dart';
import 'package:hr_systems_web/mobile-version/permission/viewAllMyPermission.dart';
import 'package:hr_systems_web/mobile-version/profileMobile.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class izinLemburMobile extends StatefulWidget {
  const izinLemburMobile({super.key});

  @override
  State<izinLemburMobile> createState() => _izinLemburMobileState();
}

class _izinLemburMobileState extends State<izinLemburMobile> {
  String employeeId = GetStorage().read('employee_id').toString();
  bool isLoading = false;
  final storage = GetStorage();
  TextEditingController txtNamaLengkap = TextEditingController();
  String namaLengkapText = '';
  TextEditingController txtNIK = TextEditingController();
  String nikText = '';
  TextEditingController txtAlasan = TextEditingController();
  String alasanText = '';
  TextEditingController txtDepartemen = TextEditingController();
  String departemenText = '';
  TextEditingController txtJabatan = TextEditingController();
  String jabatanText = '';
  TextEditingController txtKeperluan = TextEditingController();
  DateTime? TanggalLembur;
  String? JamMulai;
  String? JamAkhir;

  final int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchDataforFilled();
  }

  Future<void> fetchDataforFilled() async {
    try {
      isLoading = true;
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
          txtNamaLengkap.text = data['Data']['employee_name'] as String;
          txtNIK.text = data['Data']['employee_id'] as String;
          txtDepartemen.text = data['Data']['department_name'] as String;
          txtJabatan.text = data['Data']['position_name'] as String;
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> insertLembur() async {
    try{
      isLoading = true;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/permission/insertpermission.php';
      String employeeId = storage.read('employee_id').toString(); // replace with your logic to get employee ID
      DateTime dateNow = DateTime.now();

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "action" : "4",
          "id": employeeId,
          "overtime_date": TanggalLembur.toString(),
          "overtime_start": JamMulai.toString(),
          "overtime_end": JamAkhir.toString(),
          "overtime_reason": txtKeperluan.text,
          "date_now": dateNow.toString()
        }
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: const Text("Sukses"),
              content: const Text("Permohonan izin anda telah berhasil diajukan"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.to(indexMobile(EmployeeID: employeeId,));
                  }, 
                  child: const Text("Kembali ke halaman utama")
                ),
                TextButton(
                  onPressed: () {
                    //Get.to(EmployeeListPage());
                  }, 
                  child: const Text("Lihat detail izin")
                )
              ],
            );
          }
        );
        // Add any additional logic or UI updates after successful insertion
      } else {
        isLoading = false;
        Get.snackbar('Gagal', response.body);
        // Handle the error or show an error message to the user
      }

    } catch (e){
      isLoading = false;
      Get.snackbar('Gagal', '$e');
      print('Exception during API call: $e');
      // Handle exceptions or show an error message to the user
    } finally {
      isLoading = false;
    }
  } 

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
    setState(() {
      if (index == 0) {
        Get.to(indexMobile(EmployeeID: employeeId,));
      }else if(index == 1){
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading ? const Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 10,
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.sp, right: 10.sp),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50.h,),
                      Center(child: Text('Pengajuan Izin Lembur', style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),)),
                      SizedBox(height: 15.h,),
                      Text("Nama Lengkap",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(116, 116, 116, 1)
                        ),
                      ),
                      SizedBox(height: 7.h,),
                      TextFormField(
                        controller: txtNamaLengkap,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          fillColor: Color.fromRGBO(235, 235, 235, 1),
                          hintText: 'Masukkan nama anda'
                        ),
                        readOnly: true,
                      ),
                      SizedBox(height: 15.h,),
                      Text("NIK",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(116, 116, 116, 1)
                        ),
                      ),
                      SizedBox(height: 7.h,),
                      TextFormField(
                        controller: txtNIK,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          fillColor: Color.fromRGBO(235, 235, 235, 1),
                          hintText: 'Masukkan NIK anda'
                        ),
                        readOnly: true,
                      ),
                      SizedBox(height: 15.h,),
                      Text("Departemen",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(116, 116, 116, 1)
                        ),
                      ),
                      SizedBox(height: 7.h,),
                      TextFormField(
                        controller: txtDepartemen,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          fillColor: Color.fromRGBO(235, 235, 235, 1),
                          hintText: 'Masukkan departemen anda'
                        ),
                        readOnly: true,
                      ),
                      SizedBox(height: 15.h,),
                      Text("Jabatan",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(116, 116, 116, 1)
                        ),
                      ),
                      SizedBox(height: 7.h,),
                      TextFormField(
                        controller: txtJabatan,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          fillColor: Color.fromRGBO(235, 235, 235, 1),
                          hintText: 'Masukkan jabatan anda'
                        ),
                        readOnly: true,
                      ),
                      SizedBox(height: 15.h,),
                      Text("Tanggal lembur",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(116, 116, 116, 1)
                        ),
                      ),
                      SizedBox(height: 7.h,),
                      DateTimePicker(
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now(),
                        initialDate: DateTime.now(),
                        dateMask: 'd MMM yyyy',
                        onChanged: (value) {
                          TanggalLembur = DateFormat('yyyy-MM-dd').parse(value);
                        },
                      ),
                      SizedBox(height: 15.h,),
                      Text("Jam mulai lembur",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(116, 116, 116, 1)
                        ),
                      ),
                      SizedBox(height: 7.h,),
                      DateTimePicker(
                        type: DateTimePickerType.time,
                        onChanged: (value) {
                          JamMulai = value.toString();
                        },
                      ),
                      SizedBox(height: 15.h,),
                      Text("Jam akhir lembur",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(116, 116, 116, 1)
                        ),
                      ),
                      SizedBox(height: 7.h,),
                      DateTimePicker(
                        type: DateTimePickerType.time,
                        onChanged: (value) {
                          JamAkhir = value.toString();
                        },
                      ),
                      SizedBox(height: 15.h,),
                      Text("Keperluan",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(116, 116, 116, 1)
                        ),
                      ),
                      SizedBox(height: 7.h,),
                      TextFormField(
                        controller: txtKeperluan,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          fillColor: Color.fromRGBO(235, 235, 235, 1),
                          hintText: 'Masukkan alasan keperluan anda'
                        ),
                      ),
                      SizedBox(height: 35.h,),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                namaLengkapText = txtNamaLengkap.text;
                                nikText = txtNIK.text;
                                departemenText = txtDepartemen.text;
                                jabatanText = txtDepartemen.text;
                                alasanText = txtAlasan.text;
                            
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                  return const AlertDialog(
                                    content: Row(
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(width: 20),
                                        Text('Loading ...'),
                                      ],
                                    ),
                                  );
                                  },
                                );
                            
                                try {
                                  await insertLembur(); 
                                } catch (e){
                                  print(e);
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
                    ],
                  ),
                ),
              )
            )
          ],
        ),
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