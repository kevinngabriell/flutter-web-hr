// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/web-version/full-access/Employee/EmployeeList.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'dart:html' as html;

class NpwpDocument extends StatefulWidget {
  final String employeeID;
  final String namaKaryawan;

  const NpwpDocument({super.key, required this.employeeID, required this.namaKaryawan});

  @override
  State<NpwpDocument> createState() => _NpwpDocumentState();
}

class _NpwpDocumentState extends State<NpwpDocument> {
  String npwp = '-';
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
    try {
      setState(() => isLoading = true);
      String npwpUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployeedoc.php?action=4&employee_id=${widget.employeeID}';
      final npwpResponse = await http.get(Uri.parse(npwpUrl));

      if (npwpResponse.statusCode == 200) {
        setState(() {
          Map<String, dynamic> npwpData = json.decode(npwpResponse.body);
          npwp = npwpData['npwp'];
        });
      } else {
        setState(() {
          npwp = '-';
        });
      }
    } catch (error) {
      debugPrint('Error fetching NPWP document: $error');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> npwpFile() async {
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
          'action_id': '4'
        };

        var dioClient = dio.Dio();
        dio.Response response = await dioClient.post(apiUrl, data: dio.FormData.fromMap(data));

        if (response.statusCode == 200) {
          showDialog(
            context: context, 
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Sukses'),
              content: Text('Upload NPWP ${widget.namaKaryawan} telah berhasil dilakukan'),
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return buildNpwpDocumentWidget(context);
    }
  }

  Widget buildNpwpDocumentWidget(BuildContext context) {
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
                child: Text('NPWP', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700)),
              ),
              SizedBox(height: 5.sp),
              npwp != '-'
                  ? Image.memory(base64Decode(npwp))
                  : const Center(child: Text('File NPWP belum diupload ke dalam sistem')),
              SizedBox(height: 5.sp),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: (){
                        String base64Image = 'data:image/jpeg;base64,$npwp';
                        downloadBase64Image(base64Image, 'NPWP-${widget.namaKaryawan}.jpg');
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(50.w, 55.h),
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xff4ec3fc),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Download NPWP')
                    ),
                  ElevatedButton(
                    onPressed: npwpFile,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(50.w, 55.h),
                      foregroundColor: const Color(0xFFFFFFFF),
                      backgroundColor: const Color(0xff4ec3fc),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Upload NPWP')
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
