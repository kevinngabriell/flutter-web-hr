import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hr_systems_web/mobile-version/on_construction.dart';
import 'package:hr_systems_web/web-version/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MyHomePage(),
        );
      },
      // child: GetMaterialApp(
      //   theme: ThemeData(
      //     primarySwatch: Colors.blue,
      //   ),
      //   home: const MyHomePage(),
      // ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      checkDevice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void checkDevice() {
    final isWebMobile = kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);
    const isWebDesktop = kIsWeb;

    isWebMobile == true
        ? Get.to(const OnConstructionMobile())
        : isWebDesktop == true
            ? Get.to(LoginPageDesktop())
            : Get.to(const OnConstructionMobile());
  }
}
