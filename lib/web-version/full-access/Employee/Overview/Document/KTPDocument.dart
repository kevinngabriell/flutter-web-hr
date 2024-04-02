// ignore_for_file: file_names, avoid_web_libraries_in_flutter, avoid_print

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

class KTPDocumentCard extends StatefulWidget {
  final String employeeID;
  final String namaKaryawan;

  const KTPDocumentCard({super.key, required this.employeeID, required this.namaKaryawan});

  @override
  State<KTPDocumentCard> createState() => _KTPDocumentCardState();
}

class _KTPDocumentCardState extends State<KTPDocumentCard> {
  String ktp = '-';
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
    if (mounted) {
      setState(() => isLoading = true);
    }
    try {
      final storage = GetStorage();
      String imageUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployeedoc.php?action=1&employee_id=${widget.employeeID}';
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (mounted) {
          setState(() {
            ktp = data['ktp'];
            isLoading = false;
          });
        }
      } else {
        ktp = '-';
      }
    } catch (error) {
      ktp = '-';
      print('Error KTP Document: $error');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> ktpFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
    );

    if (result != null) {
      if (mounted) {
        setState(() => isLoading = true);
      }
      try {
        String base64Image = base64Encode(result.files.first.bytes!);
        String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/uploaddoc.php';
        var dioClient = dio.Dio();
        var data = {
          'employee_id': widget.employeeID,
          'doc': base64Image,
          'action_id': '1'
        };

        dio.Response response = await dioClient.post(apiUrl, data: dio.FormData.fromMap(data));
        if (response.statusCode == 200) {
          if (mounted) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Sukses'),
                  content: Text('Upload ktp ${widget.namaKaryawan} telah berhasil dilakukan'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Get.to(const EmployeeListPage());
                      },
                      child: const Text('Oke'),
                    ),
                  ],
                );
              },
            );
          }
        } else {
          print('Error: ${response.statusCode}, ${response.data}');
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
    if(ktp != '-'){
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
                Center(child: Text('File KTP', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700))),
                SizedBox(height: 5.sp),
                Image.memory(base64Decode(ktp)),
                SizedBox(height: 5.sp),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      String base64Image = 'data:image/jpeg;base64,$ktp';
                      downloadBase64Image(base64Image, 'KTP-${widget.namaKaryawan}.jpg');
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(50.w, 55.h),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xff4ec3fc),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Download KTP')
                  ),
                  ElevatedButton(
                    onPressed: ktpFile,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(50.w, 55.h),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xff4ec3fc),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Upload KTP')
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
              Center(child: Text('File KTP', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700))),
              SizedBox(height: 5.sp),
              const Center(child: Text('File KTP belum diupload ke dalam sistem')),
              SizedBox(height: 5.sp),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: ktpFile,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(50.w, 55.h),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xff4ec3fc),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Upload KTP')
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
    }
    
  }
}
