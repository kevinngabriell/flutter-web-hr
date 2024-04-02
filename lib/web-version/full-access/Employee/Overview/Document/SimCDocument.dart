// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/EmployeeList.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'dart:html' as html;

class SimCDocument extends StatefulWidget {
  final String employeeID;
  final String namaKaryawan;

  const SimCDocument({
    super.key, 
    required this.employeeID, 
    required this.namaKaryawan
  });

  @override
  State<SimCDocument> createState() => _SimCDocumentState();
}

class _SimCDocumentState extends State<SimCDocument> {
  String simC = '-';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getProfileImage();
  }

  void downloadBase64Image(String base64String, String fileName) {
    // Remove the header from the base64 string
    String base64Data = base64String.split(',').last;

    // Convert the base64 string to a Uint8List
    Uint8List bytes = base64.decode(base64Data);

    // Create a Blob from the Uint8List
    final blob = html.Blob([bytes]);

    // Create a URL for the Blob
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Create an anchor element and trigger a download
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();

    // Revoke the URL after the download starts
    html.Url.revokeObjectUrl(url);
  }

  Future<void> getProfileImage() async {
    setState(() => isLoading = true);
    try {
      final storage = GetStorage();
      String simCUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployeedoc.php?action=3&employee_id=${widget.employeeID}';
      final simCresponse = await http.get(Uri.parse(simCUrl));

      if (simCresponse.statusCode == 200) {
        setState(() {
          Map<String, dynamic> simCdata = json.decode(simCresponse.body);
          simC = simCdata['simC'];
        });

      } else {
        setState(() {
          simC = '-';
        });
      }
    } catch (error) {
      simC = '-';
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> simCFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
    );

    if (result != null) {
      setState(() => isLoading = true);
      try {
        String base64Image = base64Encode(result.files.first.bytes!);
        String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/uploaddoc.php';
        var dioClient = dio.Dio();
        var data = {
          'employee_id': widget.employeeID,
          'doc': base64Image,
          'action_id': '3'
        };

        dio.Response response = await dioClient.post(apiUrl, data: dio.FormData.fromMap(data));

        if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Sukses'),
                content: Text('Upload sim C ${widget.namaKaryawan} telah berhasil dilakukan'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Get.to(const EmployeeListPage()),
                    child: const Text('Oke'),
                  ),
                ],
              );
            },
          );
        } else {
          print(response.data);
          Get.snackbar("Error", "Error: ${response.statusCode}, ${response.data}");
        }
      } catch (e) {
        print('Error during file upload: $e');
      } finally {
        if (mounted) {
          setState(() => isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if(simC != '-'){
      return SizedBox(
        width: (MediaQuery.of(context).size.width - 100.w) / 2,
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          color: Colors.white,
          shadowColor: Colors.black,
          child: Padding(
            padding: EdgeInsets.all(4.sp),
            child: Column(
              children: [
                Center(child: Text('File SIM C', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700))),
                SizedBox(height: 5.sp),
                Image.memory(base64Decode(simC)),
                SizedBox(height: 5.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        String base64Image = 'data:image/jpeg;base64,$simC';
                        downloadBase64Image(base64Image, 'SIM C-${widget.namaKaryawan}.jpg');
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(50.w, 55.h),
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xff4ec3fc),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Download SIM C')
                    ),
                    ElevatedButton(
                      onPressed: simCFile, 
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(50.w, 55.h),
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xff4ec3fc),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      child: const Text('Upload SIM C')
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        width: (MediaQuery.of(context).size.width - 200.w) / 2,
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          color: Colors.white,
          shadowColor: Colors.black,
          child: Padding(
            padding: EdgeInsets.all(4.sp),
            child: Column(
              children: [
                Center(child: Text('File SIM C', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700))),
                SizedBox(height: 5.sp),
                const Center(child: Text('File SIM C belum diupload ke dalam sistem')),
                SizedBox(height: 5.sp),
                ElevatedButton(
                  onPressed: simCFile, 
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(50.w, 55.h),
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xff4ec3fc),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    ),
                  ),
                  child: const Text('Upload SIM C')
                )
              ],
            ),
          ),
        ),
      );
    } 
    
  }
}
