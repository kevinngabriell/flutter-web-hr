import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/mobile-version/login.dart';
import 'package:hr_systems_web/web-version/login.dart';

Future <void> logoutServicesWeb() async {
  GetStorage().remove('employee_id');
  GetStorage().remove('company_id');
  GetStorage().remove('username');
  GetStorage().remove('position_name');
  GetStorage().remove('employee_name');

  Get.to(const LoginPageDesktop());
}

Future <void> logoutServicesMobile() async {
  GetStorage().remove('employee_id');
  GetStorage().remove('company_id');
  GetStorage().remove('username');
  GetStorage().remove('position_name');
  GetStorage().remove('employee_name');

  Get.to(const MobileLogin());
}