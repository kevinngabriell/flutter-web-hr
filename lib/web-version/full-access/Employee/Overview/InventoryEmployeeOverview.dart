import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/detailInventory.dart';
import 'package:hr_systems_web/web-version/full-access/Inventory/detailInventoryRequest.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class InventoryEmployeeOverview extends StatefulWidget {
  final String employeeId;
  final String namaKaryawan;

  const InventoryEmployeeOverview({super.key, required this.employeeId, required this.namaKaryawan});

  @override
  State<InventoryEmployeeOverview> createState() => _InventoryEmployeeOverviewState();
}

class _InventoryEmployeeOverviewState extends State<InventoryEmployeeOverview> {
  List<Map<String, dynamic>> myInventory = [];
  List<Map<String, dynamic>> myRequestInventory = [];
  bool isLoading = false;
  final GetStorage storage = GetStorage();

  @override
  void initState() {
    super.initState();
    fetchInventory();
    fetchMyRequest();
  }

  Future<void> fetchInventory() async {
    setState(() {
      isLoading = true;
    });

    try {
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/getinventory.php?action=7&employee_id=${widget.employeeId}';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          myInventory = List<Map<String, dynamic>>.from(data['Data']);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchMyRequest() async {
    setState(() {
      isLoading = true;
    });

    try {
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/inventory/mytoprequest.php?employee_id=${widget.employeeId}';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          myRequestInventory = List<Map<String, dynamic>>.from(data['Data']);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.sp),
        isLoading ? Center(child: CircularProgressIndicator()) : Row(
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
                      Text('List Permohonan', style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w700)),
                      SizedBox(height: 1.sp),
                      Text('List permohonan ${widget.namaKaryawan}', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w300)),
                      SizedBox(height: 7.sp),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: (MediaQuery.of(context).size.height - 50.sp),
                        child: ListView.builder(
                          itemCount: myRequestInventory.length,
                          itemBuilder: (context, index) {
                            var item = myRequestInventory[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 3.sp),
                              child: Card(
                                child: ListTile(
                                  title: Text('${item['employee_name']} | ${item['item_request']}', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700)),
                                  subtitle: Text(item['status_name'], style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400)),
                                  onTap: () {
                                    Get.to(DetailInventoryRequest(item['request_id']));
                                  },
                                ),
                              ),
                            );
                          }
                        ),
                      )
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
                      Text('Inventaris', style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w700)),
                      SizedBox(height: 1.sp),
                      Text('List inventaris ${widget.namaKaryawan}', style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w300)),
                      SizedBox(height: 7.sp),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: (MediaQuery.of(context).size.height - 50.sp),
                        child: ListView.builder(
                          itemCount: myInventory.length,
                          itemBuilder: (context, index) {
                            var item = myInventory[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 3.sp),
                              child: Card(
                                child: ListTile(
                                  title: Text(item['inventory_name'], style: TextStyle(fontSize: 4.sp, fontWeight: FontWeight.w700)),
                                  subtitle: Text(item['inventory_id'], style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400)),
                                  trailing: Container(
                                    alignment: Alignment.center,
                                    constraints: BoxConstraints(maxWidth: 30.w),
                                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12)), color: Colors.green),
                                    child: Text(item['status_name'], textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 3.sp)),
                                  ),
                                  onTap: () {
                                    Get.to(detailInventory(item['inventory_id']));
                                  },
                                ),
                              ),
                            );
                          }
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
