// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import '../../EmployeeList.dart';
import 'dart:html' as html;

class BPJSDocument extends StatefulWidget {
  final String employeeID;
  final String namaKaryawan;

  const BPJSDocument({super.key, required this.employeeID, required this.namaKaryawan});

  @override
  State<BPJSDocument> createState() => _BPJSDocumentState();
}

class _BPJSDocumentState extends State<BPJSDocument> {
  String bpjs = '-';
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
      String bpjsUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployeedoc.php?action=5&employee_id=${widget.employeeID}';
      final bpjsResponse = await http.get(Uri.parse(bpjsUrl));

      if (bpjsResponse.statusCode == 200) {
        Map<String, dynamic> bpjsData = json.decode(bpjsResponse.body);
        bpjs = bpjsData['bpjs'];
      } else {
        bpjs = '-';
      }
    } catch (error) {
      bpjs = '-';
      print('Error fetching BPJS document: $error');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> bpjsFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
    );

    if (result != null) {
      setState(() => isLoading = true);
      try {
        String base64Image = base64Encode(result.files.first.bytes!);
        String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/uploaddoc.php';

        var data = {
          'employee_id': widget.employeeID,
          'doc': base64Image,
          'action_id': '5'
        };

        var dioClient = dio.Dio();
        dio.Response response = await dioClient.post(apiUrl, data: dio.FormData.fromMap(data));

        if (response.statusCode == 200) {
          Get.dialog(
            AlertDialog(
              title: const Text('Sukses'),
              content: Text('Upload BPJS ${widget.namaKaryawan} telah berhasil dilakukan'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Get.to(const EmployeeListPage()),
                  child: const Text('Oke'),
                ),
              ],
            ),
          );
        } else {
          Get.snackbar("Error", "Error: ${response.statusCode}, ${response.data}");
        }
      } catch (e) {
        Get.snackbar("Error", "Exception occurred: $e");
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: (MediaQuery.of(context).size.width - 100.w) / 2,
        child: Card(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          color: Colors.white,
          shadowColor: Colors.black,
          child: Padding(
            padding: EdgeInsets.all(4.sp),
            child: Column(
              children: [
                Center(
                  child: Text('BPJS', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700)),
                ),
                SizedBox(height: 5.sp),
                bpjs == '-'
                    ? const Center(child: Text('File BPJS belum diupload ke dalam sistem'))
                    : Image.memory(base64Decode(bpjs)),
                SizedBox(height: 5.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        String base64Image = 'data:image/jpeg;base64,$bpjs';
                        downloadBase64Image(base64Image, 'BPJS-${widget.namaKaryawan}.jpg');
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(50.w, 55.h),
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xff4ec3fc),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Download BPJS')
                    ),
                    ElevatedButton(
                      onPressed: bpjsFile,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(50.w, 55.h),
                        foregroundColor: const Color(0xFFFFFFFF),
                        backgroundColor: const Color(0xff4ec3fc),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Upload BPJS'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
  }

}
