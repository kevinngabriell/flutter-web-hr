import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/mobile-version/indexMobile.dart';
import 'package:hr_systems_web/mobile-version/login.dart';
import 'package:hr_systems_web/responsive.dart';
import 'package:hr_systems_web/web-version/full-access/index.dart';
import 'package:hr_systems_web/web-version/login.dart';
import 'package:intl/date_symbol_data_local.dart';


void main() {
  int? employeeID = GetStorage().read('employee_id');
  runApp(const GetMaterialApp( // Wrap your MainWeb widget with MaterialApp
    home: MainWeb(),
  ));
  initializeDateFormatting('id', null);
}

class MainWeb extends StatefulWidget {
  const MainWeb({super.key});

  @override
  State<MainWeb> createState() => _MainWebState();
}

class _MainWebState extends State<MainWeb> {
  int? employeeID = GetStorage().read('employee_id');
  
  @override
  Widget build(BuildContext context) {
  
  return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        //Check is mobile or not
        if(ResponsiveWidget.isSmallScreen(context)){
          //Is there any session or not
          if(employeeID != null){
            return const indexMobile(EmployeeName: 'EmployeeName', PositionName: 'PositionName');
          } else {
            return const MobileLogin();
          }
        } else {
          if(employeeID != null){
            return FullIndexWeb(employeeID);
          } else {
            return const LoginPageDesktop();
          }
        }
      },
    );
  }
}