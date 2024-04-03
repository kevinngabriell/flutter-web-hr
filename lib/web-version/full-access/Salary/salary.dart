// ignore_for_file: non_constant_identifier_names, avoid_print, avoid_web_libraries_in_flutter

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_systems_web/web-version/full-access/Menu/menu.dart';
import 'package:hr_systems_web/web-version/full-access/Salary/listemployeesalary.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'dart:typed_data' show Uint8List;
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'dart:convert';
import 'package:intl/intl.dart';

class SalaryIndex extends StatefulWidget {
  const SalaryIndex({super.key});

  @override
  State<SalaryIndex> createState() => _SalaryIndexState();
}

class _SalaryIndexState extends State<SalaryIndex> with TickerProviderStateMixin{
  String companyName = '';
  String companyAddress = '';
  String employeeName = '';
  String employeeEmail = '';
  String trimmedCompanyAddress = '';
  String positionName = '';
  String myDepartment = '';
  String myNIK = '';
  final storage = GetStorage();
  late TabController tabController;
  int? angkaAbsen;
  int gajiPokok = 0;
  int Jabatan = 0;
  int BPJSKetenag = 0;
  int BPJSKesehatan = 0;
  int Lembur = 0;
  int Transport = 0;
  int Lainnya = 0;
  int Pinjaman = 0;
  int Pajak = 0;
  int PotBPJSKet1 = 0;
  int PotBPJSKes1 = 0;
  int PotBPJSKet2 = 0;
  int PotBPJSKes2 = 0;
  int PPHBonus = 0;
  int penguranganLainnya = 0;
  int totalEarnings = 0;
  int totalDeductions = 0;
  int takeHomePay = 0;

  int mygajiPokok = 0;
  int myJabatan = 0;
  int myBPJSKetenag = 0;
  int myBPJSKesehatan = 0;
  int myLembur = 0;
  int myTransport = 0;
  int myLainnya = 0;
  int myPinjaman = 0;
  int myPajak = 0;
  int myPotBPJSKet1 = 0;
  int myPotBPJSKes1 = 0;
  int myPotBPJSKet2 = 0;
  int myPotBPJSKes2 = 0;
  int myPPHBonus = 0;
  int mypenguranganLainnya = 0;
  int mytotalEarnings = 0;
  int mytotalDeductions = 0;
  int mytakeHomePay = 0;


  List<Map<String, String>> employees = [];
  String? selectedEmployeeId;
  int month = 0;
  int year = 0;

  String NIK = '';
  String departmentName = '';
  String selectedEmployeeName = '';
  String dateTimeName = '';

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    fetchData();
    fetchAbsenValidasi();
    String employeeId = storage.read('employee_id').toString();
    getMyPayroll(1, 2024, employeeId);
    fetchEmployeeList();
  }

  String convertToText(int takehomepay) {
    if (takehomepay == 0) {
      return "Kosong";
    }

    String result = "";

    // Define arrays for various magnitudes
    List<String> units = ["", "Satu", "Dua", "Tiga", "Empat", "Lima", "Enam", "Tujuh", "Delapan", "Sembilan"];
    List<String> teens = ["", "Sebelas", "Dua Belas", "Tiga Belas", "Empat Belas", "Lima Belas", "Enam Belas", "Tujuh Belas", "Delapan Belas", "Sembilan Belas"];
    List<String> tens = ["", "Sepuluh", "Dua Puluh", "Tiga Puluh", "Empat Puluh", "Lima Puluh", "Enam Puluh", "Tujuh Puluh", "Delapan Puluh", "Sembilan Puluh"];
    List<String> thousands = ["", "Ribu", "Juta", "Miliar", "Triliun", "Kuadriliun", "Kuintiliun", "Sekstiliun", "Septiliun", "Oktiliun"];

    // Break the takehomepay into groups of three digits
    List<String> chunks = [];
    while (takehomepay > 0) {
      chunks.add((takehomepay % 1000).toString());
      takehomepay ~/= 1000;
    }

    // Process each chunk
    for (int i = 0; i < chunks.length; i++) {
      int chunk = int.parse(chunks[i].toString());
      if (chunk != 0) {
        result = "${convertChunkToText(chunk, units, teens, tens)} ${thousands[i]} $result";
      }
    }

    return result.trim();
  }

  String convertChunkToText(int chunk, List<String> units, List<String> teens, List<String> tens) {
    String result = "";

    int hundreds = chunk ~/ 100;
    int remainder = chunk % 100;

    if (hundreds > 0) {
      result += "${units[hundreds]} Ratus";
      if (remainder > 0) {
        result += " dan ";
      }
    }

    if (remainder > 0) {
      if (remainder < 10) {
        result += units[remainder];
      } else if (remainder < 20) {
        result += teens[remainder - 10];
      } else {
        result += tens[remainder ~/ 10];
        if (remainder % 10 > 0) {
          result += " ${units[remainder % 10]}";
        }
      }
    }

    return result;
  }

  Future<Uint8List> generatePDF(int i, String dateTimeName) async{
    final pdf = pw.Document();
    final completer = Completer<Uint8List>();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(10),
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          final image = pw.MemoryImage(
            base64Decode('iVBORw0KGgoAAAANSUhEUgAAAEYAAABGCAYAAABxLuKEAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAABJ4SURBVHgB3Vx5kBzVef+97p57dmb20r2rAQksIywJsEGUjVkOUUAIR8CJ4yJBcsUVOzYxSv4ITspRVHE5qVQqkFQupxwjh1AxJsjiSqBskEBgsBBoAd1IaHZXi7Q6dmdn5+yZ7pffez0rdrUraY+ZBeVTzc5MH6/7fe87ft/v65HADEoymVwBx1nhQiwXEElArhjeddqhKUikIURaQnYakO/ANDtTqVQnZkgE6ihURAKuu1pKcUdVCQlMT9K85S0C7lNU1BYqKoU6SV0UQ4V0SEeuozI6UFcRm6ikH6d6ejahxlJTxSTb2lZLiHUY6xr1lpSAXE8FbUCNpCaK8SzEfQQzr5DTpWYKmpZiqJAkXeaR+rvM5EQCGwzTWD+dGGRiipJsT35buu5P+HEJPmHC1V4BKVc3xmN96UxmSpls0hajMo3ruuuExAM4D4TW83B3T/daTFImpRjtOhX3ZzxrBc4nkegUlnHXZFxrworx4om7GR9/gJ2qpIRpXDdR5UxIMf8PlDIsE1aOca4DZkQpYuQ7/zCA1Un0XNScznXgORWjY0qdLYWgEFIIrRNpOEwoqKfoOKnLlbPIWRXT3t7+UP0DrTITCZ9pY9U1c+Giwi1Gfas4zsl13HVnO+SMilHwvp4pWeiLs24WrLXhYPmSOO65IwJDGqeOEKif6fD6DyTb2884v3EBno4rEsqFgqiX8M6CUReNERuxEPD5KyQWNPVi136BoM9GIGyiUBJAfd1qZWNT4+Npyuk7rPGOVmYmpk8RnF2kgE/Y+LUvDGHpohJM14V9XOIP7zGQLfnx5EsOTg6EMYEwOB1JeCUNrjt9xxiLUS7E5fwL1FmUK9lUwDsHTSQaQrjs4jwiEYGCDOOhxxI42ENjlT7U22QoSVrNyzSa1MiNY5ajShvUXdR0pVFmdDEQoy81Ns9BxdeEhQvCKBUdkndCx54ZuRePGRgloyymai2rMQOik47hwnQM/MaqIP7liQIeeyaIeCSAkBXAgcOSKhP1txdPEiw4u0YWnKOS4sK29kOYIXTrJWkXfr+JgFVGpmDxm2TQK6M1EcKxAad6zIxJqqun+4LhL6dcidZyJ2YQ8svq5W0bGMoLBMwKEqEywZ2BvoESMHPWMiwqGXcMfzE+ulHjPnxM0t7mw3MbP4fXNn8Of3x/El6ynGG1qCtqntoTrRivdpB3ouYiRvjqmaHsyisbsXihD1Fmpa98uYVpvIxzi6wDOJYdw6WCZzGO04EaC/tB8PtcMn1hWKYKpGe2gNfeGMTOAyVkcwH86NETqIgzE4uqpmpqEpjVymOImmsubPeoN60Y3vYdqLGYooK/+ssL8cwTl2DddxYxsJbHr5q57L0fVvCttbvwi639+OcfpGA4vnHHVMH60xcFsOnR5dj42Kdx1WejPL+2duP1wIYtRqADNRR1q6GQwIVzC+g/dhCfWcy0rIHLOJOQnlMsXGCiNTgIy7L4rXKGcU0sTIaY5fuAYh/a58s6hCKvO2rqtqkrp1ksjp2wXTGwd18OFmH/M/8zhL09clTEGXmuIRzc9HnggnknsfVNE9m8AnZjSwHlnod7CpjbOohfbLHw9Es5VEpnv48pSJBI+CkFHjowLVE3QwQi1MTp8zLA78QgrsA7uyUOHLLx5VvyEEZE+a9Ox6Nun+cZRgWzwwMY6svjogUtOHIiOMrrdAUuTY4hkZyXx+u/9OHn27I6ocuqAr1jhk9S7yambE7sr3NUN4npCNFrLOjg0wttWocBV1RhfHVmxaKLoFXE1ZcSsHByhhjtJkpJC1sl4mEbuZzEJckCb0mMWnxRPc/PbHXrtTZ6j5U8FxymKNSi8NXaaNN9i/rzdHzMlWKFIkSWYxqi9HD79Vn8we3HcfXlBZxmD3CED0Ms6m9f2Y+2ppyes+ZchAfhBOPOlUvT8BllvW3RvBxaYrQGqTIO3UzFJaEszcU912awoKGATC486hrKbkzY+Pqdg/jmb51EW7MzLa8yBJK8rpwGvcCpGQb2d5lInfCjxHSrMscocSXKVEQ8XMHX7s5gdrQE11DW42rzn92cxcrPlJnaGbB9AtGgJBWRg6ONgRZIN3M45i0r81i5ogjTkiiVTi8u1VV9OD4Uwt7uEE4OGdMKyjx1uZmIxR/ENLgXtVq9VMobu0L0fwG74CBnV5GrNnECuGVlXDC/hGjUwVVLDeSLnMTJCuY2u/jGPSXWRiX4qBgfT1Pv7fNAt7GQOlLGrEYLv70qhxtWDtElaRk+E1s7o7qMqJqdznhfvKyCl9828OrbUZQdC9MMxGnBwrFGCc+FxXjzldt8eLszi93dYZq/iVCghO9+fRDJ2YXheahDafgRAv8ijcIrFketcLV6LJObMaUN0/Dikiu81P7vG1ux+S1Lp++Qz8GXbpF4c6eLnR/4x441RbFQI1EENr0GL7ziYP1aA+/ttbH7fQufXVrBJRd85PPem0RY5jWsGa6gP0rlw4GT4U8Wqh0V7winev69t+URDEYQCJjouNzGtvcC2HOAIxiGdtGazKd2FjMsJlZdVcAfrRnQgVWlcKGyFW84k2lCIpapQvlhnCIZT/jdZZDOhElapXmOdUqBXvrhKCwTikVBC7Srewz9t7uvCfd/30XJ9leVXBuyovaEKtPUlm0m3j80hy2RBgZLMv9mCJYvhhMDIRTKceIWbjMCME2+jBD8CGnGbt+hANn3GGsrg/uCep+h34PYfbCFqJiuVX15nxN4dKNAqezXl5Yj/k5XlGJSqKmwM0Su9j+eK6Fc8cGo0GokY4RbwoJZJTz3sklrdz3vkMo5KhqPVKTFQrLIb4w7KiXJspeyVVarxLH/gxJC/iy/s++kfFaqmBLEqztV/Kl5XZCqWYw5JdLQyfOdPQKdbIUsu5BGVJb61v1GDt29ERw67MOCVm4QVAJdTzIU5+04uo/YXH1uqfjhmnmtUBcNePxFQbLcQLHkoSQF+FRj7olnqVQ3WPuWrhBpKkaQ55RJ1Fhs18ALr/nxqTlEoqysFdBTkH3ZxT78cKOL373dRCYdQ7Zoo1j28V3gg24Lm98II+CXtI4E3x2UTT+2bsvjlquJX1hDSRBEujF0HQ9j+z4PBI5bnE5HJNIW4XNXrXvF3qoa2LbTxvEbY+Rvg3jvfcaQHuDIcQd9gzZ27LNYkjA2MDDPm2shHrdgBA383WOGTstBP12xTJcyCowlfvzZPxlomxXHiovmsp4axPa9Ie4vo0aF4yiRUr4jqk9aPoIayXBjVejC0sD85gr6MzYSTSHWOMQct83HqhujOHQoh397pA9/vX4xbrxe4UuHFbnEs8/m8Cfrd+Ef/mYFliwhV9NbxjfX7kQ26/WYAqESAgR/wrSQzlaZ4RpbDPPAWks9cQ1n6rl/dHJUt+lotDtvjoErV85GkPD/wT+9iEDMh46bt+Laa6JYtaoJT/60gq/etwirbmIZQRPZ0VnEFSsacM/djE/vzUGYrdtFC6PsXNC1QuxOZpmqrRLe2Hor9u3txwsvHsO2Xw1g5+6CLi10HpHj39WkxTC2WOox9IXtC9O0nymVBQqruESvPsaUcMzGr9+cpGuUsebeNhQrDv7xX7sI7/NMJuRcrpnFDGOzbMjDdgpYuiTKz0C+UMH3vn8A//XjpTrdL17kR9kuEbeEUXHLVdAm0dwS4FjHsOwSxqpLEih8rQ1XX/cKll06i2MMYdeeMu3UwCm4ODXdpJVOLG9y6OQYHZiUeKui/lmkAy6+2MLffm8OPmDKzWRtpI91IV8Kopgni/fhca6qjZVXCPSdzOHk0QpygzmgpQEnjg7Czlmwy3ns2zkAVSxkTmbREAygv6/AusfUJYSywva2Bp7bp+OScJm5RAYtzQJtc12s/f1WvP52Hj96LIN9+10FKzEV4Vkvq3cvXQvxFC2mA5MRotVoSJJ5o7XQTSLMmsX+g3jldbZZaTFHezIolKLIEege7TmiFy8RstBfDuJoiii4X+JEpISY/yiKhWYM9Nv4vQd20/pcWgqw9qshHpehl8dpNR4JlYhm0dfVA4c4KVtgazdcxrymBPJD3N7Tg8WzgD//VoRlicB/PqkQklWNP5MxHWPTR4oxsIGh4aFJnE29cJV+J8fgmsGrb/nQ3ODD0d48C0j2oQM5HO/NoWAXUcwGcaw36/F8/BMPGzj+oUuOJoT+QAVR4hVFI9x1QxyXLu7X89ixM4Dc8QqPG4Lr5CArTXpqYaOfYw2xaxnBYKaCBbOp2KgPhZyDYx9yBQgSD/bYuOpi4qIbGvHTFwUmXQ6a2OKphEKfStMrt0zmfL0Q5SJXy9W1TyP5lvSAHz1HXMYNF3neZz7roGITy/Lz4KBEka8CtxWGiGaJSYrZst5XGqpgz0EeN8TMlCmjUiyTmiihkJF6fBVblVIjTOEFZqLDvcCJPo41BDQEsnDKrJXU9cjDPP9ykNclobI4zdav6zFpExRe4qnhBxeNETNdj0mIoanFir7h9tmKR7HRxUZ8icWg0F0kqbGMq2kZiYFBwVUOKg8ccSOiytMK7D7g8bdqXM3sqYR/Kkx4fHJT3ANz/QM2TjJLqXknIordkxr8qhIiEnYUk0Ec5KAh4t3DJGa14dSn4Q+pw6ktjDUpTFDU/BSxFOBrXlMFYdPF/JbqZMkckRFg4UjGxDI0+WSyaNzTYzDlCv3d4v6yIzVzp74nGsocywHrSmZLnmeofrY61kBLo8uqOo/ZLYLHSyy90MHSCyrw+QXmtBrw83oWxwiQm7mXxHvQ7/I4HotJRBfOPdWT2jRGMXrfZKyGSxQICoQDqoekgBcwZw7Z/pYC/Gob96nekqIig+ozX+99EIEvzAkzUFt+EzsPBjlhA9FYBfffW0KQeCUY4DmkN/18BcNSW8CDawbxndUmWqIVPc6sJhLozER+XrdtHpVNCjjI6wdCJksFi9cAtu9vIdVpQk5QNafPfZRiqLENE7cawQmbvHmuPAu5MINqmJP44uUmV8vQkwpQCYpCCPEzs68uHm2jmRgmQjRs4dV3LWz6VSsyQwEMMBj/8Jkm7DjQROuNo6cvhl7WQxmb1IQIYF5rgaCPBBcVsH1PA37+ejMVr1ypgsZYQG8Phv2steLc7sPln6JF+coTS9qetWwYuWlMyGY/aA0J8s04p1pY6FEZIbaLduy2cNkySwfCy5aUkB4MIBIlQ1fyYygbwC93GjjQHUORvv/dh33oz0WYBElJEBQ+/ZLDV0w/GaMIqjfe9cY3GHE3bm7UvJ3PqpD7DaBtjoMVSxy8/2EYRbuMaMSv7WH+XB+VxqKCVXeR8SYYsbAwksGi9lms0XBOfxrPU8Z0z9OZdKoxnujAuZ6V4Y1/6SYLMcaGfV2Nnis1F3mzMXQfDdFtEvjJM368uQcsJqN4v8fQbZO8IuCkXyvFI4HZSGOaVTFy5KOsrqg20hQtQXI7k2c2OmZh+y6S5OxqpvOSQDJK/BSHRdNZQE5ZxZVgoAEXtpd13HlrTxxdvTj7NIANqZ6uMYoZP8mbYg2j645zlQl+EeRqkkkz8nh3fwxHj0fx38+7OMQqumKUNW9Cz/e6jcNtZulRkrpzyQwjq9sNd2Q8qGYZYeiM4+rsNWLhOURmyMLPXgI2bS4hTJe58Qut+M1bbdx0RZGXUOMHqVxZLWjPpBWRpmmOG1fHfd5CPffaGG9U7b6bcQZR/ea7rzc06t1Cxv6J5y1s3V7RsUMz//JcOaE2FbHqFJQdgT0pif99pYRMMcEywUQ0HMbTmyWOnRRnOdf4Rqqb2XjcfWeR5IL2h7mo3x5/1ArW3OnHq9tc7DtCDbt1IBgnLMNkh2eJCirMZts31WdonDQeluHmv+8+3P3AmUc8i6ini6TLQCzlmN8TqBsweUGHPR/lEgqOA3V4kGeyotyH1mxI0+uKynGcQojOru6uy842zFlhoS4VDHHXeClc0w2qyHetaiz5BChFiYpNRN+64T8e6uVc9JzOIRP/IZdnOUmcz+IpZUI/5JrcT//OZ+VMQilKJlxhqQHVwMo/cb4J73kySlEyqd9dqzQ+ODj4g8ZYXEHSlTgPRGUfwzTWUCdHJ3PelMFEsi25mpnpoalyxXUXgjfhyPWp3u6HMQWZ8i/1WTp0NjY2Pk6c0Ah8sn6HrUg3YYpbCPWfxxSlJvCzaj3rPvbArAIsi2DNLU13KNRQPjYFKYWwQj6dOpjWkKiDUEF3MuzdJ+vy+4SPRPPUSiE1sJCxY9dR9I83HNWvkndI9fT5dAO1Cqjsgel2DzsbCpmjTlJXxZwu3lPoVJDrJjm55bx6QnrKSp52aAr65oiZpOxizdE50/951/8BTz7b6PFW7yAAAAAASUVORK5CYII='),
          );

          //Slip gaji saya
          if(i == 0){
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Image(image),
                        pw.SizedBox(width: 30.sp),
                        pw.Column(
                          children: [
                            pw.Text(companyName, style: 
                              pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 18.0,
                                color: PdfColor.fromHex('#333333'), // Replace with your desired color
                              ),
                            ),
                            pw.SizedBox(height: 5.sp),
                            pw.Text(companyAddress, style: pw.TextStyle(fontSize: 12.0,color: PdfColor.fromHex('#555555'),),),
                            pw.SizedBox(height: 8.sp),
                          ]
                        )
                      ]
                    )
                  ]
                ),
                pw.Divider(thickness: 1.0, color: PdfColor.fromHex('#333333')),
                pw.SizedBox(height: 8.sp),
                pw.Expanded(
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.only(),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Center(
                          child: pw.Text(
                            'SLIP GAJI',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 18.0,
                              color: PdfColor.fromHex('#333333'), // Replace with your desired color
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.SizedBox(
                              // width: (MediaQuery.of(context as BuildContext).size.width  - 100.w) / 2,
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(height: 20,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(
                                          child: pw.Text('Nama',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 28),
                                        pw.SizedBox(
                                          child: pw.Text(employeeName, style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(
                                          child: pw.Text('Divisi',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 30),
                                        pw.SizedBox(
                                          child: pw.Text(myDepartment, style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(
                                          child: pw.Text('NIK',style: const pw.TextStyle(fontSize: 12.0,)),
                                        ),
                                        pw.SizedBox(width: 39),
                                        pw.SizedBox(
                                          child: pw.Text(myNIK, style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                            ),
                            pw.SizedBox(width: 200),
                            pw.SizedBox(
                              // width: (MediaQuery.of(context as BuildContext).size.width  - 100.w) / 2,
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(height: 20,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(
                                          child: pw.Text('Jabatan',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 30),
                                        pw.SizedBox(
                                          child: pw.Text(positionName, style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(
                                          child: pw.Text('Periode',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 30),
                                        pw.SizedBox(
                                          child: pw.Text(dateTimeName, style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 8.h,),
                                  ],
                                )
                            )
                          ]
                        ),
                        pw.SizedBox(height: 20),
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.SizedBox(
                              // width: (MediaQuery.of(context as BuildContext).size.width  - 100.w) / 2,
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(height: 15,),
                                    pw.SizedBox(
                                      child: pw.Text('PENDAPATAN',
                                        style: const pw.TextStyle(
                                          fontSize: 12.0,
                                        )
                                      ),
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 10),
                                        pw.SizedBox(
                                          child: pw.Text('Gaji Pokok',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 105),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(mygajiPokok), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 20,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 10),
                                        pw.SizedBox(
                                          child: pw.Text('Tunjangan-tunjangan : ',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                              // fontWeight: FontWeight.w600,
                                            )
                                          ),
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('Jabatan',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 107),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(myJabatan), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('BPJS Ketenag + JP',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 43),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(myBPJSKetenag), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('BPJS Kesehatan',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 58),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(myBPJSKesehatan), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('Lembur',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 107),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(myLembur), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('Transport',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 97),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(myTransport), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('Lainnya',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 105),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(myLainnya), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                            ),
                            pw.SizedBox(width: 60),
                            pw.SizedBox(
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(height: 13,),
                                    pw.SizedBox(
                                      child: pw.Text('PINDAHAN',
                                        style: const pw.TextStyle(
                                          fontSize: 12.0,
                                        )
                                      ),
                                    ),
                                    pw.SizedBox(height: 45,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 10),
                                        pw.SizedBox(
                                          child: pw.Text('Potongan-potongan : ',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                              // fontWeight: FontWeight.w600,
                                            )
                                          ),
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('Pinjaman',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 85),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(myPinjaman), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('Pajak (PPH 21)',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 52),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(myPajak), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('BPJS Ketenag',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 56),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(myPotBPJSKet1), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('BPJS Kesehatan',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 44),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(myPotBPJSKes1), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('BPJS Ketenag',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 56),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(myPotBPJSKet2), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('BPJS Kesehatan',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 44),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(myPotBPJSKes2), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('PPH atas bonus/komisi',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 10),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(myPPHBonus), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('Lainnya',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 92),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(mypenguranganLainnya), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                            ),
                          ]
                        ),
                        pw.SizedBox(height: 20),
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.SizedBox(
                              // width: (MediaQuery.of(context as BuildContext).size.width  - 100.w) / 2,
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('Pendapatan Bruto',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 50),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(mytotalEarnings), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                            ),
                            pw.SizedBox(width: 75),
                            pw.SizedBox(
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 10),
                                        pw.SizedBox(
                                          child: pw.Text('Total potongan',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 55),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(mytotalDeductions), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                            ),
                          ]
                        ),
                        pw.SizedBox(height: 50,),
                        pw.Row(
                          children: [
                            pw.SizedBox(
                              child: pw.Text('JUMLAH YANG DITERIMA',
                                  style: const pw.TextStyle(
                                    fontSize: 12.0,
                                  )
                              ),
                            ),
                            pw.SizedBox(width: 22),
                            pw.SizedBox(
                              child: pw.Text(formatCurrency(mytakeHomePay), style: const pw.TextStyle(fontSize: 12.0,))
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 20,),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('Terbilang',style: const pw.TextStyle(fontSize: 12.0,)),
                            pw.SizedBox(height: 10,),
                            pw.Text('${convertToText(mytakeHomePay)} Rupiah',style: const pw.TextStyle(fontSize: 12.0,)),
                          ]
                        )
                      ]
                    )
                  )
                ),
                pw.Divider(thickness: 1.0, color: PdfColor.fromHex('#333333')),
                pw.Footer(
                  title: pw.Text('Dokumen ini dibuat secara otomatis oleh sistem dan tidak membutuhkan tanda tangan', style: pw.TextStyle(fontSize: 8.0,color: PdfColor.fromHex('#555555'),)),
                )
              ]
            );
          //Slip gaji karyawan A
          } else if (i == 1){
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Image(image),
                        pw.SizedBox(width: 30.sp),
                        pw.Column(
                          children: [
                            pw.Text(companyName, style: 
                              pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 18.0,
                                color: PdfColor.fromHex('#333333'), // Replace with your desired color
                              ),
                            ),
                            pw.SizedBox(height: 5.sp),
                            pw.Text(companyAddress, style: pw.TextStyle(fontSize: 12.0,color: PdfColor.fromHex('#555555'),),),
                            pw.SizedBox(height: 8.sp),
                          ]
                        )
                      ]
                    )
                  ]
                ),
                pw.Divider(thickness: 1.0, color: PdfColor.fromHex('#333333')),
                pw.SizedBox(height: 8.sp),
                pw.Expanded(
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.only(),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Center(
                          child: pw.Text(
                            'SLIP GAJI',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 18.0,
                              color: PdfColor.fromHex('#333333'), // Replace with your desired color
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.SizedBox(
                              // width: (MediaQuery.of(context as BuildContext).size.width  - 100.w) / 2,
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(height: 20,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(
                                          child: pw.Text('Nama',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 28),
                                        pw.SizedBox(
                                          child: pw.Text(selectedEmployeeName, style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(
                                          child: pw.Text('Divisi',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 30),
                                        pw.SizedBox(
                                          child: pw.Text(departmentName, style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(
                                          child: pw.Text('NIK',style: const pw.TextStyle(fontSize: 12.0,)),
                                        ),
                                        pw.SizedBox(width: 39),
                                        pw.SizedBox(
                                          child: pw.Text(NIK, style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                            ),
                            pw.SizedBox(width: 200),
                            pw.SizedBox(
                              // width: (MediaQuery.of(context as BuildContext).size.width  - 100.w) / 2,
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(height: 20,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(
                                          child: pw.Text('Jabatan',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 30),
                                        pw.SizedBox(
                                          child: pw.Text(positionName, style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(
                                          child: pw.Text('Periode',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 30),
                                        pw.SizedBox(
                                          child: pw.Text(dateTimeName, style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 8.h,),
                                  ],
                                )
                            )
                          ]
                        ),
                        pw.SizedBox(height: 20),
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.SizedBox(
                              // width: (MediaQuery.of(context as BuildContext).size.width  - 100.w) / 2,
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(height: 15,),
                                    pw.SizedBox(
                                      child: pw.Text('PENDAPATAN',
                                        style: const pw.TextStyle(
                                          fontSize: 12.0,
                                        )
                                      ),
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 10),
                                        pw.SizedBox(
                                          child: pw.Text('Gaji Pokok',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 105),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(gajiPokok), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 20,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 10),
                                        pw.SizedBox(
                                          child: pw.Text('Tunjangan-tunjangan : ',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                              // fontWeight: FontWeight.w600,
                                            )
                                          ),
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('Jabatan',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 107),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(Jabatan), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('BPJS Ketenag + JP',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 43),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(BPJSKetenag), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('BPJS Kesehatan',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 58),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(BPJSKesehatan), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('Lembur',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 107),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(Lembur), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('Transport',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 97),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(Transport), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('Lainnya',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 105),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(Lainnya), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                            ),
                            pw.SizedBox(width: 60),
                            pw.SizedBox(
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(height: 13,),
                                    pw.SizedBox(
                                      child: pw.Text('PINDAHAN',
                                        style: const pw.TextStyle(
                                          fontSize: 12.0,
                                        )
                                      ),
                                    ),
                                    pw.SizedBox(height: 45,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 10),
                                        pw.SizedBox(
                                          child: pw.Text('Potongan-potongan : ',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                              // fontWeight: FontWeight.w600,
                                            )
                                          ),
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('Pinjaman',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 85),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(Pinjaman), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('Pajak (PPH 21)',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 52),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(Pajak), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('BPJS Ketenag',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 56),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(PotBPJSKet1), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('BPJS Kesehatan',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 44),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(PotBPJSKes1), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('BPJS Ketenag',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 56),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(PotBPJSKet2), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('BPJS Kesehatan',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 44),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(PotBPJSKes2), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('PPH atas bonus/komisi',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 10),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(PPHBonus), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                    pw.SizedBox(height: 10,),
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('Lainnya',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 92),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(penguranganLainnya), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                            ),
                          ]
                        ),
                        pw.SizedBox(height: 20),
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.SizedBox(
                              // width: (MediaQuery.of(context as BuildContext).size.width  - 100.w) / 2,
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 22),
                                        pw.SizedBox(
                                          child: pw.Text('Pendapatan Bruto',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 50),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(totalEarnings), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                            ),
                            pw.SizedBox(width: 75),
                            pw.SizedBox(
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Row(
                                      children: [
                                        pw.SizedBox(width: 10),
                                        pw.SizedBox(
                                          child: pw.Text('Total potongan',
                                            style: const pw.TextStyle(
                                              fontSize: 12.0,
                                            )
                                          ),
                                        ),
                                        pw.SizedBox(width: 55),
                                        pw.SizedBox(
                                          child: pw.Text(formatCurrency(totalDeductions), style: const pw.TextStyle(fontSize: 12.0,))
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                            ),
                          ]
                        ),
                        pw.SizedBox(height: 50,),
                        pw.Row(
                          children: [
                            pw.SizedBox(
                              child: pw.Text('JUMLAH YANG DITERIMA',
                                  style: const pw.TextStyle(
                                    fontSize: 12.0,
                                  )
                              ),
                            ),
                            pw.SizedBox(width: 22),
                            pw.SizedBox(
                              child: pw.Text(formatCurrency(takeHomePay), style: const pw.TextStyle(fontSize: 12.0,))
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 20,),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('Terbilang',style: const pw.TextStyle(fontSize: 12.0,)),
                            pw.SizedBox(height: 10,),
                            pw.Text('${convertToText(takeHomePay)} Rupiah',style: const pw.TextStyle(fontSize: 12.0,)),
                          ]
                        )
                      ]
                    )
                  )
                ),
                pw.Divider(thickness: 1.0, color: PdfColor.fromHex('#333333')),
                pw.Footer(
                  title: pw.Text('Dokumen ini dibuat secara otomatis oleh sistem dan tidak membutuhkan tanda tangan', style: pw.TextStyle(fontSize: 8.0,color: PdfColor.fromHex('#555555'),)),
                )
              ]
            );
          } else {
            return pw.Column(

            );
          }
        }
      )
    );

    return Uint8List.fromList(await pdf.save());
  }

  Future<void> generateAndDisplayPDF(int i, String dateTimeName) async {
    // Generate PDF
    final Uint8List pdfBytes = await generatePDF(i, dateTimeName);

    // Convert Uint8List to Blob
    final html.Blob blob = html.Blob([pdfBytes]);

    // Create a data URL
    final String url = html.Url.createObjectUrlFromBlob(blob);

    // Create a download link with password protection
    final html.AnchorElement anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'SlipGaji-$dateTimeName.pdf'; // Set your desired password here
    anchor.click();

    // Clean up
    html.Url.revokeObjectUrl(url);
  }

  Future<void> fetchEmployeeList() async {
    String employeeId = storage.read('employee_id').toString();

    try {
      final response = await http.get(Uri.parse('https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getemployeelist.php'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Check if the response contains the expected key 'Data'
        if (responseData.containsKey('Data')) {
          final List<dynamic> employeeData = responseData['Data'] ?? [];

          setState(() {
            employees = employeeData
                .map<Map<String, String>>((dynamic employee) =>
                    Map<String, String>.from(employee))
                .toList();
          });
        } else {
          print('Expected key "Data" not found in the response data.');
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String formatCurrency(int value) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0).format(value);
  }

  Future<void> fetchAbsenValidasi() async {

    try {
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/absent/getvalidationabsence.php';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('Data') && responseData['Data'] is List && (responseData['Data'] as List).isNotEmpty) {

          Map<String, dynamic> data = (responseData['Data'] as List).first;
          if (data.containsKey('not_verified') && data['not_verified'] != null) {

            setState(() {
              angkaAbsen = int.parse(data['not_verified'].toString());
            });
            
          } else {
            print('not_verified is null or not found in the response data.');
          }
        } else {
          print('Data is null or not found in the response data.');
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchData() async {
    String employeeId = storage.read('employee_id').toString();

    try {
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/account/getprofileforallpage.php';
      Map<String, dynamic> requestBody = {'employee_id': employeeId};
      String requestBodyJson = json.encode(requestBody);

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'employee_id': employeeId,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        setState(() {
          companyName = data['company_name'] as String;
          companyAddress = data['company_address'] as String;
          employeeName = data['employee_name'] as String;
          employeeEmail = data['employee_email'] as String;
          myDepartment = data['department_name'] as String;
          myNIK = data['employee_id'] as String;
          positionName = data['position_name'] as String;
          trimmedCompanyAddress = companyAddress.substring(0, 15);
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    }
  }

  Future<void> getMyPayroll(month, year, employeeID) async {
    try {
      String apiURL = "https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/salary/getdetailsalaryemployee.php?month=$month&employeeId=$employeeID&year=$year";
      var response = await http.get(Uri.parse(apiURL));

      if (response.statusCode == 200) {
        Map<String, dynamic>? responseData = json.decode(response.body);

        if (responseData != null) {
          setState(() {
            mygajiPokok = int.parse(responseData['gajiTetap']?.toString() ?? '0');
            myJabatan = int.parse(responseData['Jabatan']?.toString() ?? '0');
            myBPJSKetenag = int.parse(responseData['BPJSKetenag']?.toString() ?? '0');
            myBPJSKesehatan = int.parse(responseData['BPJSKesehatan']?.toString() ?? '0');
            myLembur = int.parse(responseData['Lembur']?.toString() ?? '0');
            myTransport = int.parse(responseData['Transport']?.toString() ?? '0');
            myLainnya = int.parse(responseData['Lainnya']?.toString() ?? '0');
            myPinjaman = int.parse(responseData['Pinjaman']?.toString() ?? '0');
            myPajak = int.parse(responseData['Pajak']?.toString() ?? '0');
            myPotBPJSKet1 = int.parse(responseData['PotBPJSKet1']?.toString() ?? '0');
            myPotBPJSKes1 = int.parse(responseData['PotBPJSKes1']?.toString() ?? '0');
            myPotBPJSKet2 = int.parse(responseData['PotBPJSKet2']?.toString() ?? '0');
            myPotBPJSKes2 = int.parse(responseData['PotBPJSKes2']?.toString() ?? '0');
            myPPHBonus = int.parse(responseData['PPHBonus']?.toString() ?? '0');
            mypenguranganLainnya = int.parse(responseData['penguranganLainnya']?.toString() ?? '0');
            mytotalEarnings = int.parse(responseData['totalPendapatan']?.toString() ?? '0');
            mytotalDeductions = int.parse(responseData['totalPengurangan']?.toString() ?? '0');
            mytakeHomePay = int.parse(responseData['totalTakeHomePay']?.toString() ?? '0');
          });
        } else {
          // Handle the case when responseData is null
          setState(() {
            mygajiPokok = 0;
            myJabatan = 0;
            myBPJSKetenag = 0;
            myBPJSKesehatan = 0;
            myLembur = 0;
            myTransport = 0;
            myLainnya = 0;
            myPinjaman = 0;
            myPajak = 0;
            myPotBPJSKet1 = 0;
            myPotBPJSKes1 = 0;
            myPotBPJSKet2 = 0;
            myPotBPJSKes2 = 0;
            myPPHBonus = 0;
            mypenguranganLainnya = 0;
            mytotalEarnings = 0;
            mytotalDeductions = 0;
            mytakeHomePay = 0;
          });
        }
      } else {
        // Handle other HTTP status codes if needed
      }
    } catch (e) {
      print('Exception: $e');
      Get.snackbar('Error', 'An error occurred. Please try again later.');
    }
  }

  Future<void> getPayroll(month, year, employeeID) async {
    try {
      String apiURL = "https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/salary/getdetailsalaryemployee.php?month=$month&employeeId=$employeeID&year=$year";
      var response = await http.get(Uri.parse(apiURL));

      if (response.statusCode == 200) {
        Map<String, dynamic>? responseData = json.decode(response.body);

        if (responseData != null) {
          setState(() {
            gajiPokok = int.parse(responseData['gajiTetap']?.toString() ?? '0');
            Jabatan = int.parse(responseData['Jabatan']?.toString() ?? '0');
            BPJSKetenag = int.parse(responseData['BPJSKetenag']?.toString() ?? '0');
            BPJSKesehatan = int.parse(responseData['BPJSKesehatan']?.toString() ?? '0');
            Lembur = int.parse(responseData['Lembur']?.toString() ?? '0');
            Transport = int.parse(responseData['Transport']?.toString() ?? '0');
            Lainnya = int.parse(responseData['Lainnya']?.toString() ?? '0');
            Pinjaman = int.parse(responseData['Pinjaman']?.toString() ?? '0');
            Pajak = int.parse(responseData['Pajak']?.toString() ?? '0');
            PotBPJSKet1 = int.parse(responseData['PotBPJSKet1']?.toString() ?? '0');
            PotBPJSKes1 = int.parse(responseData['PotBPJSKes1']?.toString() ?? '0');
            PotBPJSKet2 = int.parse(responseData['PotBPJSKet2']?.toString() ?? '0');
            PotBPJSKes2 = int.parse(responseData['PotBPJSKes2']?.toString() ?? '0');
            PPHBonus = int.parse(responseData['PPHBonus']?.toString() ?? '0');
            penguranganLainnya = int.parse(responseData['penguranganLainnya']?.toString() ?? '0');
            totalEarnings = int.parse(responseData['totalPendapatan']?.toString() ?? '0');
            totalDeductions = int.parse(responseData['totalPengurangan']?.toString() ?? '0');
            takeHomePay = int.parse(responseData['totalTakeHomePay']?.toString() ?? '0');
          });
        } else {
          // Handle the case when responseData is null
          setState(() {
            gajiPokok = 0;
            Jabatan = 0;
            BPJSKetenag = 0;
            BPJSKesehatan = 0;
            Lembur = 0;
            Transport = 0;
            Lainnya = 0;
            Pinjaman = 0;
            Pajak = 0;
            PotBPJSKet1 = 0;
            PotBPJSKes1 = 0;
            PotBPJSKet2 = 0;
            PotBPJSKes2 = 0;
            PPHBonus = 0;
            penguranganLainnya = 0;
            totalEarnings = 0;
            totalDeductions = 0;
            takeHomePay = 0;
          });
        }
      } else {
        // Handle other HTTP status codes if needed
      }
    } catch (e) {
      print('Exception: $e');
      Get.snackbar('Error', 'An error occurred. Please try again later.');
    }
  }

  Future<void> fetchDetailData() async {
    try {
      String ID1 = selectedEmployeeId!;
      String apiUrl = 'https://kinglabindonesia.com/hr-systems-api/hr-system-data-v.1.2/employee/getdetailemployeesalary.php?employee_id=$ID1';
      
      final response = await http.get(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        Map<String, dynamic> data = responseData['Data'][0];

        // Ensure that the fields are of the correct type
        setState(() {
          NIK = data['employee_id'] as String;
          departmentName = data['department_name'] as String;
          selectedEmployeeName = data['employee_name'] as String;
          positionName = data['position_name'] as String;
          
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the GetStorage instance
    final storage = GetStorage();

    // Retrieve the stored employee_id
    var employeeId = storage.read('employee_id');
    var positionId = storage.read('position_id');
    var photo = storage.read('photo');
    
    DateTime now = DateTime.now();
    int year = now.year;
    int day = now.day;

    DateTime previousMonthDate = DateTime(now.year, now.month - 1, 21);
    DateTime nextMonthDate = DateTime(now.year, now.month, 21);

    String previousMonth = DateFormat('MMMM').format(previousMonthDate);
    String currentNextMonth = DateFormat('MMMM').format(nextMonthDate);
    
    return MaterialApp(
      title: 'Salary',
      home: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //side menu
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5.sp,),
                        NamaPerusahaanMenu(companyName: companyName, companyAddress: trimmedCompanyAddress),
                        SizedBox(height: 10.sp,),
                        const HalamanUtamaMenu(),
                        SizedBox(height: 5.sp,),
                        BerandaNonActive(employeeId: employeeId.toString()),
                        SizedBox(height: 5.sp,),
                        KaryawanNonActive(employeeId: employeeId.toString()),
                        SizedBox(height: 5.sp,),
                        const GajiActive(),
                        SizedBox(height: 5.sp,),
                        const PerformaNonActive(),
                        SizedBox(height: 5.sp,),
                        const PelatihanNonActive(),
                        SizedBox(height: 5.sp,),
                        const AcaraNonActive(),
                        SizedBox(height: 5.sp,),
                        LaporanNonActive(positionId: positionId.toString()),
                        SizedBox(height: 10.sp,),
                        const PengaturanMenu(),
                        SizedBox(height: 5.sp,),
                        const PengaturanNonActive(),
                        SizedBox(height: 5.sp,),
                        const StrukturNonActive(),
                        SizedBox(height: 5.sp,),
                        const Logout(),
                        SizedBox(height: 30.sp,),
                    ],
                  ),
                ),
              ),
              //Content
              Expanded(
                flex: 8,
                child: Padding(
                  padding: EdgeInsets.only(left: 7.w, right: 7.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5.sp,),
                      NotificationnProfile(employeeName: employeeName, employeeAddress: employeeEmail, photo: photo),
                      SizedBox(height: 7.sp,),
                      TabBar(
                        isScrollable: false,
                        controller: tabController,
                        labelColor: const Color.fromRGBO(78, 195, 252, 1),
                        unselectedLabelColor: Colors.black,
                        tabs: [
                          Tab( 
                            child: Text(
                              'Overview', 
                              style: TextStyle(
                                fontSize: 4.sp, 
                                fontWeight: FontWeight.w400,
                                //color: tabController.index == 0 ? Color.fromRGBO(78, 195, 252, 1) : Colors.black
                              ),
                            ),
                          ),
                          Tab( 
                            child: Text(
                              'Gaji Saya', 
                              style: TextStyle(
                                fontSize: 4.sp, 
                                fontWeight: FontWeight.w400,
                                //color: tabController.index == 0 ? Color.fromRGBO(78, 195, 252, 1) : Colors.black
                              ),
                            ),
                          ),
                          if(positionId == 'POS-HR-002')
                            Tab( 
                              child: Text(
                                'Gaji Karyawan', 
                                style: TextStyle(
                                  fontSize: 4.sp, 
                                  fontWeight: FontWeight.w400,
                                  //color: tabController.index == 0 ? Color.fromRGBO(78, 195, 252, 1) : Colors.black
                                ),
                              ),
                            ),
                        ]
                      ),
                       SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10.h,),
                                if(positionId == 'POS-HR-002' || positionId == 'POS-HR-008')
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width - 180.w,
                                            child: Card(
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 4.sp, top: 13.sp, right: 4.sp, bottom: 13.sp),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: MediaQuery.of(context).size.width - 225.w,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text('Pendataan Gaji $previousMonth - $currentNextMonth $year',
                                                            style: TextStyle(
                                                              fontSize: 7.sp, fontWeight: FontWeight.w700,
                                                            )
                                                          ),
                                                          SizedBox(height: 5.h,),
                                                          Text( 'Proses pendataan gaji karyawan untuk bulan $previousMonth - $currentNextMonth $year',
                                                            style: TextStyle(
                                                              fontSize: 4.sp, fontWeight: FontWeight.w300,
                                                            )
                                                          ),
                                                          SizedBox(height: 20.h,),
                                                          ElevatedButton(
                                                            onPressed: (){
                                                              Get.to(const ListEmployeeSalary());
                                                            }, 
                                                            style: ElevatedButton.styleFrom(
                                                              minimumSize: Size(50.w, 45.h),
                                                              foregroundColor: const Color(0xFFFFFFFF),
                                                              backgroundColor: const Color(0xff4ec3fc),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(8),
                                                              ),
                                                            ),
                                                            child: const Text('Data sekarang')
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      // child: Image.asset('images/salaryVector.jpg', width: 50.w,),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width - 270.w,
                                            child: Card(
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 4.sp, top: 13.sp, right: 4.sp, bottom: 13.sp),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('$angkaAbsen', style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700,)),
                                                    Text('Total absen yang belum diverifikasi',style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.w400))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10.h,),
                                SizedBox(
                                  width: (MediaQuery.of(context).size.width  - 240.w) / 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Periode',
                                        style: TextStyle(
                                          fontSize: 4.sp,
                                          fontWeight: FontWeight.w600,
                                        )
                                      ),
                                      SizedBox(height: 10.h,),
                                      DropdownButtonFormField(
                                        value: '01-2024',
                                        items: const [
                                          DropdownMenuItem(
                                            value: '01-2024',
                                            child: Text('Januari 2024')
                                          ),
                                          DropdownMenuItem(
                                            value: '02-2024',
                                            child: Text('Februari 2024')
                                          ),
                                          DropdownMenuItem(
                                            value: '03-2024',
                                            child: Text('Maret 2024')
                                          ),
                                          DropdownMenuItem(
                                            value: '04-2024',
                                            child: Text('April 2024')
                                          ),
                                          DropdownMenuItem(
                                            value: '05-2024',
                                            child: Text('Mei 2024')
                                          ),
                                          DropdownMenuItem(
                                            value: '06-2024',
                                            child: Text('Juni 2024')
                                          ),
                                          DropdownMenuItem(
                                            value: '07-2024',
                                            child: Text('Juli 2024')
                                          ),
                                          DropdownMenuItem(
                                            value: '08-2024',
                                            child: Text('Agustus 2024')
                                          ),
                                          DropdownMenuItem(
                                            value: '09-2024',
                                            child: Text('September 2024')
                                          ),
                                          DropdownMenuItem(
                                            value: '10-2024',
                                            child: Text('Oktober 2024')
                                          ),
                                          DropdownMenuItem(
                                            value: '11-2024',
                                            child: Text('November 2024')
                                          ),
                                          DropdownMenuItem(
                                            value: '12-2024',
                                            child: Text('Desember 2024')
                                          ),
                                          DropdownMenuItem(
                                            value: '01-2025',
                                            child: Text('Januari 2025')
                                          ),
                                          DropdownMenuItem(
                                            value: '02-2025',
                                            child: Text('Februari 2025')
                                          ),
                                          DropdownMenuItem(
                                            value: '03-2025',
                                            child: Text('Maret 2025')
                                          ),
                                          DropdownMenuItem(
                                            value: '04-2025',
                                            child: Text('April 2025')
                                          ),
                                          DropdownMenuItem(
                                            value: '05-2025',
                                            child: Text('Mei 2025')
                                          ),
                                          DropdownMenuItem(
                                            value: '06-2025',
                                            child: Text('Juni 2025')
                                          ),
                                          DropdownMenuItem(
                                            value: '07-2025',
                                            child: Text('Juli 2025')
                                          ),
                                          DropdownMenuItem(
                                            value: '08-2025',
                                            child: Text('Agustus 2025')
                                          ),
                                          DropdownMenuItem(
                                            value: '09-2025',
                                            child: Text('September 2025')
                                          ),
                                          DropdownMenuItem(
                                            value: '10-2025',
                                            child: Text('Oktober 2025')
                                          ),
                                          DropdownMenuItem(
                                            value: '11-2025',
                                            child: Text('November 2025')
                                          ),
                                          DropdownMenuItem(
                                            value: '12-2025',
                                            child: Text('Desember 2025')
                                          ),
                                          DropdownMenuItem(
                                            value: '01-2026',
                                            child: Text('Januari 2026')
                                          ),
                                          DropdownMenuItem(
                                            value: '02-2026',
                                            child: Text('Februari 2026')
                                          ),
                                          DropdownMenuItem(
                                            value: '03-2026',
                                            child: Text('Maret 2026')
                                          ),
                                          DropdownMenuItem(
                                            value: '04-2026',
                                            child: Text('April 2026')
                                          ),
                                          DropdownMenuItem(
                                            value: '05-2026',
                                            child: Text('Mei 2026')
                                          ),
                                          DropdownMenuItem(
                                            value: '06-2026',
                                            child: Text('Juni 2026')
                                          ),
                                          DropdownMenuItem(
                                            value: '07-2026',
                                            child: Text('Juli 2026')
                                          ),
                                          DropdownMenuItem(
                                            value: '08-2026',
                                            child: Text('Agustus 2026')
                                          ),
                                          DropdownMenuItem(
                                            value: '09-2026',
                                            child: Text('September 2026')
                                          ),
                                          DropdownMenuItem(
                                            value: '10-2026',
                                            child: Text('Oktober 2026')
                                          ),
                                          DropdownMenuItem(
                                            value: '11-2026',
                                            child: Text('November 2026')
                                          ),
                                          DropdownMenuItem(
                                            value: '12-2026',
                                            child: Text('Desember 2026')
                                          ),
                                          DropdownMenuItem(
                                            value: '01-2027',
                                            child: Text('Januari 2027')
                                          ),
                                          DropdownMenuItem(
                                            value: '02-2027',
                                            child: Text('Februari 2027')
                                          ),
                                          DropdownMenuItem(
                                            value: '03-2027',
                                            child: Text('Maret 2027')
                                          ),
                                          DropdownMenuItem(
                                            value: '04-2027',
                                            child: Text('April 2027')
                                          ),
                                          DropdownMenuItem(
                                            value: '05-2027',
                                            child: Text('Mei 2027')
                                          ),
                                          DropdownMenuItem(
                                            value: '06-2027',
                                            child: Text('Juni 2027')
                                          ),
                                          DropdownMenuItem(
                                            value: '07-2027',
                                            child: Text('Juli 2027')
                                          ),
                                          DropdownMenuItem(
                                            value: '08-2027',
                                            child: Text('Agustus 2027')
                                          ),
                                          DropdownMenuItem(
                                            value: '09-2027',
                                            child: Text('September 2027')
                                          ),
                                          DropdownMenuItem(
                                            value: '10-2027',
                                            child: Text('Oktober 2027')
                                          ),
                                          DropdownMenuItem(
                                            value: '11-2027',
                                            child: Text('November 2027')
                                          ),
                                          DropdownMenuItem(
                                            value: '12-2027',
                                            child: Text('Desember 2027')
                                          ),
                                          DropdownMenuItem(
                                            value: '01-2028',
                                            child: Text('Januari 2028')
                                          ),
                                          DropdownMenuItem(
                                            value: '02-2028',
                                            child: Text('Februari 2028')
                                          ),
                                          DropdownMenuItem(
                                            value: '03-2028',
                                            child: Text('Maret 2028')
                                          ),
                                          DropdownMenuItem(
                                            value: '04-2028',
                                            child: Text('April 2028')
                                          ),
                                          DropdownMenuItem(
                                            value: '05-2028',
                                            child: Text('Mei 2028')
                                          ),
                                          DropdownMenuItem(
                                            value: '06-2028',
                                            child: Text('Juni 2028')
                                          ),
                                          DropdownMenuItem(
                                            value: '07-2028',
                                            child: Text('Juli 2028')
                                          ),
                                          DropdownMenuItem(
                                            value: '08-2028',
                                            child: Text('Agustus 2028')
                                          ),
                                          DropdownMenuItem(
                                            value: '09-2028',
                                            child: Text('September 2028')
                                          ),
                                          DropdownMenuItem(
                                            value: '10-2028',
                                            child: Text('Oktober 2028')
                                          ),
                                          DropdownMenuItem(
                                            value: '11-2028',
                                            child: Text('November 2028')
                                          ),
                                          DropdownMenuItem(
                                            value: '12-2028',
                                            child: Text('Desember 2028')
                                          ),
                                          DropdownMenuItem(
                                            value: '01-2029',
                                            child: Text('Januari 2029')
                                          ),
                                          DropdownMenuItem(
                                            value: '02-2029',
                                            child: Text('Februari 2029')
                                          ),
                                          DropdownMenuItem(
                                            value: '03-2029',
                                            child: Text('Maret 2029')
                                          ),
                                          DropdownMenuItem(
                                            value: '04-2029',
                                            child: Text('April 2029')
                                          ),
                                          DropdownMenuItem(
                                            value: '05-2029',
                                            child: Text('Mei 2029')
                                          ),
                                          DropdownMenuItem(
                                            value: '06-2029',
                                            child: Text('Juni 2029')
                                          ),
                                          DropdownMenuItem(
                                            value: '07-2029',
                                            child: Text('Juli 2029')
                                          ),
                                          DropdownMenuItem(
                                            value: '08-2029',
                                            child: Text('Agustus 2029')
                                          ),
                                          DropdownMenuItem(
                                            value: '09-2029',
                                            child: Text('September 2029')
                                          ),
                                          DropdownMenuItem(
                                            value: '10-2029',
                                            child: Text('Oktober 2029')
                                          ),
                                          DropdownMenuItem(
                                            value: '11-2029',
                                            child: Text('November 2029')
                                          ),
                                          DropdownMenuItem(
                                            value: '12-2029',
                                            child: Text('Desember 2029')
                                          ),
                                          DropdownMenuItem(
                                            value: '01-2030',
                                            child: Text('Januari 2030')
                                          ),
                                          DropdownMenuItem(
                                            value: '02-2030',
                                            child: Text('Februari 2030')
                                          ),
                                          DropdownMenuItem(
                                            value: '03-2030',
                                            child: Text('Maret 2030')
                                          ),
                                          DropdownMenuItem(
                                            value: '04-2030',
                                            child: Text('April 2030')
                                          ),
                                          DropdownMenuItem(
                                            value: '05-2030',
                                            child: Text('Mei 2030')
                                          ),
                                          DropdownMenuItem(
                                            value: '06-2030',
                                            child: Text('Juni 2030')
                                          ),
                                          DropdownMenuItem(
                                            value: '07-2030',
                                            child: Text('Juli 2030')
                                          ),
                                          DropdownMenuItem(
                                            value: '08-2030',
                                            child: Text('Agustus 2030')
                                          ),
                                          DropdownMenuItem(
                                            value: '09-2030',
                                            child: Text('September 2030')
                                          ),
                                          DropdownMenuItem(
                                            value: '10-2030',
                                            child: Text('Oktober 2030')
                                          ),
                                          DropdownMenuItem(
                                            value: '11-2030',
                                            child: Text('November 2030')
                                          ),
                                          DropdownMenuItem(
                                            value: '12-2030',
                                            child: Text('Desember 2030')
                                          )
                                        ], 
                                        onChanged: (value){
                                          if(value == '01-2024'){
                                            dateTimeName = 'Januari 2024';
                                            getMyPayroll(1, 2024, employeeId);
                                          } else if (value == '02-2024'){
                                            dateTimeName = 'Februari 2024';
                                            getMyPayroll(2, 2024, employeeId);
                                          } else if (value == '03-2024'){
                                            dateTimeName = 'Maret 2024';
                                            getMyPayroll(3, 2024, employeeId);
                                          } else if (value == '04-2024'){
                                            dateTimeName = 'April 2024';
                                            getMyPayroll(4, 2024, employeeId);
                                          } else if (value == '05-2024'){
                                            dateTimeName = 'Mei 2024';
                                            getMyPayroll(5, 2024, employeeId);
                                          } else if (value == '06-2024'){
                                            dateTimeName = 'Juni 2024';
                                            getMyPayroll(6, 2024, employeeId);
                                          } else if (value == '07-2024'){
                                            dateTimeName = 'Juli 2024';
                                            getMyPayroll(7, 2024, employeeId);
                                          } else if (value == '08-2024'){
                                            dateTimeName = 'Agustus 2024';
                                            getMyPayroll(8, 2024, employeeId);
                                          } else if (value == '09-2024'){
                                            dateTimeName = 'September 2024';
                                            getMyPayroll(9, 2024, employeeId);
                                          } else if (value == '10-2024'){
                                            dateTimeName = 'Oktober 2024';
                                            getMyPayroll(10, 2024, employeeId);
                                          } else if (value == '11-2024'){
                                            dateTimeName = 'November 2024';
                                            getMyPayroll(11, 2024, employeeId);
                                          } else if (value == '12-2024'){
                                            dateTimeName = 'Desember 2024';
                                            getMyPayroll(12, 2024, employeeId);
                                          } else if(value == '01-2025'){
                                            dateTimeName = 'Januari 2025';
                                            getMyPayroll(1, 2025, employeeId);
                                          } else if (value == '02-2025'){
                                            dateTimeName = 'Februari 2025';
                                            getMyPayroll(2, 2025, employeeId);
                                          } else if (value == '03-2025'){
                                            dateTimeName = 'Maret 2025';
                                            getMyPayroll(3, 2025, employeeId);
                                          } else if (value == '04-2025'){
                                            dateTimeName = 'April 2025';
                                            getMyPayroll(4, 2025, employeeId);
                                          } else if (value == '05-2025'){
                                            dateTimeName = 'Mei 2025';
                                            getMyPayroll(5, 2025, employeeId);
                                          } else if (value == '06-2025'){
                                            dateTimeName = 'Juni 2025';
                                            getMyPayroll(6, 2025, employeeId);
                                          } else if (value == '07-2025'){
                                            dateTimeName = 'Juli 2025';
                                            getMyPayroll(7, 2025, employeeId);
                                          } else if (value == '08-2025'){
                                            dateTimeName = 'Agustus 2025';
                                            getMyPayroll(8, 2025, employeeId);
                                          } else if (value == '09-2025'){
                                            dateTimeName = 'September 2025';
                                            getMyPayroll(9, 2025, employeeId);
                                          } else if (value == '10-2025'){
                                            dateTimeName = 'Oktober 2025';
                                            getMyPayroll(10, 2025, employeeId);
                                          } else if (value == '11-2025'){
                                            dateTimeName = 'November 2025';
                                            getMyPayroll(11, 2025, employeeId);
                                          } else if (value == '12-2025'){
                                            dateTimeName = 'Desember 2025';
                                            getMyPayroll(12, 2025, employeeId);
                                          } else if(value == '01-2026'){
                                            dateTimeName = 'Januari 2026';
                                            getMyPayroll(1, 2026, employeeId);
                                          } else if (value == '02-2026'){
                                            dateTimeName = 'Februari 2026';
                                            getMyPayroll(2, 2026, employeeId);
                                          } else if (value == '03-2026'){
                                            dateTimeName = 'Maret 2026';
                                            getMyPayroll(3, 2026, employeeId);
                                          } else if (value == '04-2026'){
                                            dateTimeName = 'April 2026';
                                            getMyPayroll(4, 2026, employeeId);
                                          } else if (value == '05-2026'){
                                            dateTimeName = 'Mei 2026';
                                            getMyPayroll(5, 2026, employeeId);
                                          } else if (value == '06-2026'){
                                            dateTimeName = 'Juni 2026';
                                            getMyPayroll(6, 2026, employeeId);
                                          } else if (value == '07-2026'){
                                            dateTimeName = 'Juli 2026';
                                            getMyPayroll(7, 2026, employeeId);
                                          } else if (value == '08-2026'){
                                            dateTimeName = 'Agustus 2026';
                                            getMyPayroll(8, 2026, employeeId);
                                          } else if (value == '09-2026'){
                                            dateTimeName = 'September 2026';
                                            getMyPayroll(9, 2026, employeeId);
                                          } else if (value == '10-2026'){
                                            dateTimeName = 'Oktober 2026';
                                            getMyPayroll(10, 2026, employeeId);
                                          } else if (value == '11-2026'){
                                            dateTimeName = 'November 2026';
                                            getMyPayroll(11, 2026, employeeId);
                                          } else if (value == '12-2026'){
                                            dateTimeName = 'Desember 2026';
                                            getMyPayroll(12, 2026, employeeId);
                                          } else if(value == '01-2027'){
                                            dateTimeName = 'Januari 2027';
                                            getMyPayroll(1, 2027, employeeId);
                                          } else if (value == '02-2027'){
                                            dateTimeName = 'Februari 2027';
                                            getMyPayroll(2, 2027, employeeId);
                                          } else if (value == '03-2027'){
                                            dateTimeName = 'Maret 2027';
                                            getMyPayroll(3, 2027, employeeId);
                                          } else if (value == '04-2027'){
                                            dateTimeName = 'April 2027';
                                            getMyPayroll(4, 2027, employeeId);
                                          } else if (value == '05-2027'){
                                            dateTimeName = 'Mei 2027';
                                            getMyPayroll(5, 2027, employeeId);
                                          } else if (value == '06-2027'){
                                            dateTimeName = 'Juni 2027';
                                            getMyPayroll(6, 2027, employeeId);
                                          } else if (value == '07-2027'){
                                            dateTimeName = 'Juli 2027';
                                            getMyPayroll(7, 2027, employeeId);
                                          } else if (value == '08-2027'){
                                            dateTimeName = 'Agustus 2027';
                                            getMyPayroll(8, 2027, employeeId);
                                          } else if (value == '09-2027'){
                                            dateTimeName = 'September 2027';
                                            getMyPayroll(9, 2027, employeeId);
                                          } else if (value == '10-2027'){
                                            dateTimeName = 'Oktober 2027';
                                            getMyPayroll(10, 2027, employeeId);
                                          } else if (value == '11-2027'){
                                            dateTimeName = 'November 2027';
                                            getMyPayroll(11, 2027, employeeId);
                                          } else if (value == '12-2027'){
                                            dateTimeName = 'Desember 2027';
                                            getMyPayroll(12, 2027, employeeId);
                                          } else if(value == '01-2028'){
                                            dateTimeName = 'Januari 2028';
                                            getMyPayroll(1, 2028, employeeId);
                                          } else if (value == '02-2028'){
                                            dateTimeName = 'Februari 2028';
                                            getMyPayroll(2, 2028, employeeId);
                                          } else if (value == '03-2028'){
                                            dateTimeName = 'Maret 2028';
                                            getMyPayroll(3, 2028, employeeId);
                                          } else if (value == '04-2028'){
                                            dateTimeName = 'April 2028';
                                            getMyPayroll(4, 2028, employeeId);
                                          } else if (value == '05-2028'){
                                            dateTimeName = 'Mei 2028';
                                            getMyPayroll(5, 2028, employeeId);
                                          } else if (value == '06-2028'){
                                            dateTimeName = 'Juni 2028';
                                            getMyPayroll(6, 2028, employeeId);
                                          } else if (value == '07-2028'){
                                            dateTimeName = 'Juli 2028';
                                            getMyPayroll(7, 2028, employeeId);
                                          } else if (value == '08-2028'){
                                            dateTimeName = 'Agustus 2028';
                                            getMyPayroll(8, 2028, employeeId);
                                          } else if (value == '09-2028'){
                                            dateTimeName = 'September 2028';
                                            getMyPayroll(9, 2028, employeeId);
                                          } else if (value == '10-2028'){
                                            dateTimeName = 'Oktober 2028';
                                            getMyPayroll(10, 2028, employeeId);
                                          } else if (value == '11-2028'){
                                            dateTimeName = 'November 2028';
                                            getMyPayroll(11, 2028, employeeId);
                                          } else if (value == '12-2028'){
                                            dateTimeName = 'Desember 2028';
                                            getMyPayroll(12, 2028, employeeId);
                                          } else if(value == '01-2029'){
                                            dateTimeName = 'Januari 2029';
                                            getMyPayroll(1, 2029, employeeId);
                                          } else if (value == '02-2029'){
                                            dateTimeName = 'Februari 2029';
                                            getMyPayroll(2, 2029, employeeId);
                                          } else if (value == '03-2029'){
                                            dateTimeName = 'Maret 2029';
                                            getMyPayroll(3, 2029, employeeId);
                                          } else if (value == '04-2029'){
                                            dateTimeName = 'April 2029';
                                            getMyPayroll(4, 2029, employeeId);
                                          } else if (value == '05-2029'){
                                            dateTimeName = 'Mei 2029';
                                            getMyPayroll(5, 2029, employeeId);
                                          } else if (value == '06-2029'){
                                            dateTimeName = 'Juni 2029';
                                            getMyPayroll(6, 2029, employeeId);
                                          } else if (value == '07-2029'){
                                            dateTimeName = 'Juli 2029';
                                            getMyPayroll(7, 2029, employeeId);
                                          } else if (value == '08-2029'){
                                            dateTimeName = 'Agustus 2029';
                                            getMyPayroll(8, 2029, employeeId);
                                          } else if (value == '09-2029'){
                                            dateTimeName = 'September 2029';
                                            getMyPayroll(9, 2029, employeeId);
                                          } else if (value == '10-2029'){
                                            dateTimeName = 'Oktober 2029';
                                            getMyPayroll(10, 2029, employeeId);
                                          } else if (value == '11-2029'){
                                            dateTimeName = 'November 2029';
                                            getMyPayroll(11, 2029, employeeId);
                                          } else if (value == '12-2029'){
                                            dateTimeName = 'Desember 2029';
                                            getMyPayroll(12, 2029, employeeId);
                                          } else if(value == '01-2030'){
                                            dateTimeName = 'Januari 2030';
                                            getMyPayroll(1, 2030, employeeId);
                                          } else if (value == '02-2030'){
                                            dateTimeName = 'Februari 2030';
                                            getMyPayroll(2, 2030, employeeId);
                                          } else if (value == '03-2030'){
                                            dateTimeName = 'Maret 2030';
                                            getMyPayroll(3, 2030, employeeId);
                                          } else if (value == '04-2030'){
                                            dateTimeName = 'April 2030';
                                            getMyPayroll(4, 2030, employeeId);
                                          } else if (value == '05-2030'){
                                            dateTimeName = 'Mei 2030';
                                            getMyPayroll(5, 2030, employeeId);
                                          } else if (value == '06-2030'){
                                            dateTimeName = 'Juni 2030';
                                            getMyPayroll(6, 2030, employeeId);
                                          } else if (value == '07-2030'){
                                            dateTimeName = 'Juli 2030';
                                            getMyPayroll(7, 2030, employeeId);
                                          } else if (value == '08-2030'){
                                            dateTimeName = 'Agustus 2030';
                                            getMyPayroll(8, 2030, employeeId);
                                          } else if (value == '09-2030'){
                                            dateTimeName = 'September 2030';
                                            getMyPayroll(9, 2030, employeeId);
                                          } else if (value == '10-2030'){
                                            dateTimeName = 'Oktober 2030';
                                            getMyPayroll(10, 2030, employeeId);
                                          } else if (value == '11-2030'){
                                            dateTimeName = 'November 2030';
                                            getMyPayroll(11, 2030, employeeId);
                                          } else if (value == '12-2030'){
                                            dateTimeName = 'Desember 2030';
                                            getMyPayroll(12, 2030, employeeId);
                                          }
                                        }
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 30.h,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width  - 100.w) / 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Pendapatan',
                                            style: TextStyle(
                                              fontSize: 6.sp,
                                              fontWeight: FontWeight.w600,
                                            )
                                          ),
                                          SizedBox(height: 15.h,),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text('Gaji pokok',
                                                  style: TextStyle(
                                                    fontSize: 4.sp,
                                                    fontWeight: FontWeight.w600,
                                                  )
                                                ),
                                              ),
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text(formatCurrency(mygajiPokok))
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h,),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text('Tunjangan jabatan',
                                                  style: TextStyle(
                                                    fontSize: 4.sp,
                                                    fontWeight: FontWeight.w600,
                                                  )
                                                ),
                                              ),
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text(formatCurrency(myJabatan))
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h,),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text('BPJS Ketenagakerjaan + JP',
                                                  style: TextStyle(
                                                    fontSize: 4.sp,
                                                    fontWeight: FontWeight.w600,
                                                  )
                                                ),
                                              ),
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text(formatCurrency(myBPJSKetenag))
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h,),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text('BPJS Kesehatan',
                                                  style: TextStyle(
                                                    fontSize: 4.sp,
                                                    fontWeight: FontWeight.w600,
                                                  )
                                                ),
                                              ),
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text(formatCurrency(myBPJSKesehatan))
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h,),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text('Lembur',
                                                  style: TextStyle(
                                                    fontSize: 4.sp,
                                                    fontWeight: FontWeight.w600,
                                                  )
                                                ),
                                              ),
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text(formatCurrency(myLembur))
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h,),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text('Transport',
                                                  style: TextStyle(
                                                    fontSize: 4.sp,
                                                    fontWeight: FontWeight.w600,
                                                  )
                                                ),
                                              ),
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text(formatCurrency(myTransport))
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h,),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text('Lainnya',
                                                  style: TextStyle(
                                                    fontSize: 4.sp,
                                                    fontWeight: FontWeight.w600,
                                                  )
                                                ),
                                              ),
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text(formatCurrency(myLainnya))
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10.w,),
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width  - 100.w) / 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Pemotongan',
                                            style: TextStyle(
                                              fontSize: 6.sp,
                                              fontWeight: FontWeight.w600,
                                            )
                                          ),
                                          SizedBox(height: 15.h,),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text('Pinjaman',
                                                  style: TextStyle(
                                                    fontSize: 4.sp,
                                                    fontWeight: FontWeight.w600,
                                                  )
                                                ),
                                              ),
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text(formatCurrency(myPinjaman))
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h,),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text('Pajak (PPH 21)',
                                                  style: TextStyle(
                                                    fontSize: 4.sp,
                                                    fontWeight: FontWeight.w600,
                                                  )
                                                ),
                                              ),
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text(formatCurrency(myPajak))
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h,),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text('BPJS Ketenag',
                                                  style: TextStyle(
                                                    fontSize: 4.sp,
                                                    fontWeight: FontWeight.w600,
                                                  )
                                                ),
                                              ),
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text(formatCurrency(myPotBPJSKet1))
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h,),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text('BPJS Kesehatan',
                                                  style: TextStyle(
                                                    fontSize: 4.sp,
                                                    fontWeight: FontWeight.w600,
                                                  )
                                                ),
                                              ),
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text(formatCurrency(myPotBPJSKes1))
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h,),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text('BPJS Ketenag',
                                                  style: TextStyle(
                                                    fontSize: 4.sp,
                                                    fontWeight: FontWeight.w600,
                                                  )
                                                ),
                                              ),
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text(formatCurrency(myPotBPJSKet2))
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h,),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text('BPJS Kesehatan',
                                                  style: TextStyle(
                                                    fontSize: 4.sp,
                                                    fontWeight: FontWeight.w600,
                                                  )
                                                ),
                                              ),
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text(formatCurrency(myPotBPJSKes2))
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h,),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text('PPH atas bonus/komisi',
                                                  style: TextStyle(
                                                    fontSize: 4.sp,
                                                    fontWeight: FontWeight.w600,
                                                  )
                                                ),
                                              ),
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text(formatCurrency(myPPHBonus))
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h,),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text('Lainnya',
                                                  style: TextStyle(
                                                    fontSize: 4.sp,
                                                    fontWeight: FontWeight.w600,
                                                  )
                                                ),
                                              ),
                                              SizedBox(
                                                width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                child: Text(formatCurrency(mypenguranganLainnya))
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 35.h,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width  + 10.w) / 2,
                                      child: Text('Total Pendapatan', 
                                        style: TextStyle(
                                          fontSize: 4.sp,
                                          fontWeight: FontWeight.w600,
                                        )
                                      )
                                    ),
                                    SizedBox(width: 20.w,),
                                     SizedBox(
                                      width: (MediaQuery.of(context).size.width  - 250.w) / 2,
                                      child: Text(formatCurrency(mytotalEarnings),
                                              style: TextStyle(
                                                  fontSize: 4.sp,
                                              )
                                            )
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width  + 10.w) / 2,
                                      child: Text('Total Pemotongan', 
                                        style: TextStyle(
                                          fontSize: 4.sp,
                                          fontWeight: FontWeight.w600,
                                        )
                                      )
                                    ),
                                    SizedBox(width: 20.w,),
                                     SizedBox(
                                      width: (MediaQuery.of(context).size.width  - 250.w) / 2,
                                      child: Text(formatCurrency(mytotalDeductions),
                                              style: TextStyle(
                                                  fontSize: 4.sp,
                                              )
                                            )
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width  + 10.w) / 2,
                                      child: Text('Pendapatan Bersih', 
                                        style: TextStyle(
                                          fontSize: 4.sp,
                                          fontWeight: FontWeight.w600,
                                        )
                                      )
                                    ),
                                    SizedBox(width: 20.w,),
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width  - 250.w) / 2,
                                      child: Text(formatCurrency(mytakeHomePay),
                                              style: TextStyle(
                                                  fontSize: 4.sp,
                                              )
                                            )
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: (){
                                        generateAndDisplayPDF(0, dateTimeName);
                                      }, 
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(50.w, 45.h),
                                        foregroundColor: const Color(0xFFFFFFFF),
                                        backgroundColor: const Color(0xff4ec3fc),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text('Cetak slip gaji')
                                    )
                                  ],
                                )
                              ],
                            ),
                            if(positionId == 'POS-HR-002')
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10.h,),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width  - 240.w) / 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Karyawan',
                                              style: TextStyle(
                                                fontSize: 4.sp,
                                                fontWeight: FontWeight.w600,
                                              )
                                            ),
                                            SizedBox(height: 10.h,),
                                            DropdownButtonFormField<String>(
                                              value: selectedEmployeeId,
                                              hint: const Text('Pilih karyawan'),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedEmployeeId = newValue;
                                                });
                                              },
                                              items: employees.map((Map<String, String> employee) {
                                                final String? id = employee['id'];
                                                final String? employeeName = employee['employee_name'];

                                                String? trimmedText;
                                                if (employeeName != null && employeeName.length >= 15) {
                                                  trimmedText = '${employeeName.substring(0, 15)}...';
                                                } else {
                                                  trimmedText = employeeName;
                                                }

                                                return DropdownMenuItem<String>(
                                                  value: id,
                                                  child: Text(trimmedText ?? 'Unknown'),
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10.w,),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width  - 240.w) / 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Periode',
                                              style: TextStyle(
                                                fontSize: 4.sp,
                                                fontWeight: FontWeight.w600,
                                              )
                                            ),
                                            SizedBox(height: 10.h,),
                                            DropdownButtonFormField(
                                              value: '01-2024',
                                              items: const [
                                                DropdownMenuItem(
                                                  value: '01-2024',
                                                  child: Text('Januari 2024')
                                                ),
                                                DropdownMenuItem(
                                                  value: '02-2024',
                                                  child: Text('Februari 2024')
                                                ),
                                                DropdownMenuItem(
                                                  value: '03-2024',
                                                  child: Text('Maret 2024')
                                                ),
                                                DropdownMenuItem(
                                                  value: '04-2024',
                                                  child: Text('April 2024')
                                                ),
                                                DropdownMenuItem(
                                                  value: '05-2024',
                                                  child: Text('Mei 2024')
                                                ),
                                                DropdownMenuItem(
                                                  value: '06-2024',
                                                  child: Text('Juni 2024')
                                                ),
                                                DropdownMenuItem(
                                                  value: '07-2024',
                                                  child: Text('Juli 2024')
                                                ),
                                                DropdownMenuItem(
                                                  value: '08-2024',
                                                  child: Text('Agustus 2024')
                                                ),
                                                DropdownMenuItem(
                                                  value: '09-2024',
                                                  child: Text('September 2024')
                                                ),
                                                DropdownMenuItem(
                                                  value: '10-2024',
                                                  child: Text('Oktober 2024')
                                                ),
                                                DropdownMenuItem(
                                                  value: '11-2024',
                                                  child: Text('November 2024')
                                                ),
                                                DropdownMenuItem(
                                                  value: '12-2024',
                                                  child: Text('Desember 2024')
                                                ),
                                                DropdownMenuItem(
                                                  value: '01-2025',
                                                  child: Text('Januari 2025')
                                                ),
                                                DropdownMenuItem(
                                                  value: '02-2025',
                                                  child: Text('Februari 2025')
                                                ),
                                                DropdownMenuItem(
                                                  value: '03-2025',
                                                  child: Text('Maret 2025')
                                                ),
                                                DropdownMenuItem(
                                                  value: '04-2025',
                                                  child: Text('April 2025')
                                                ),
                                                DropdownMenuItem(
                                                  value: '05-2025',
                                                  child: Text('Mei 2025')
                                                ),
                                                DropdownMenuItem(
                                                  value: '06-2025',
                                                  child: Text('Juni 2025')
                                                ),
                                                DropdownMenuItem(
                                                  value: '07-2025',
                                                  child: Text('Juli 2025')
                                                ),
                                                DropdownMenuItem(
                                                  value: '08-2025',
                                                  child: Text('Agustus 2025')
                                                ),
                                                DropdownMenuItem(
                                                  value: '09-2025',
                                                  child: Text('September 2025')
                                                ),
                                                DropdownMenuItem(
                                                  value: '10-2025',
                                                  child: Text('Oktober 2025')
                                                ),
                                                DropdownMenuItem(
                                                  value: '11-2025',
                                                  child: Text('November 2025')
                                                ),
                                                DropdownMenuItem(
                                                  value: '12-2025',
                                                  child: Text('Desember 2025')
                                                ),
                                                DropdownMenuItem(
                                                  value: '01-2026',
                                                  child: Text('Januari 2026')
                                                ),
                                                DropdownMenuItem(
                                                  value: '02-2026',
                                                  child: Text('Februari 2026')
                                                ),
                                                DropdownMenuItem(
                                                  value: '03-2026',
                                                  child: Text('Maret 2026')
                                                ),
                                                DropdownMenuItem(
                                                  value: '04-2026',
                                                  child: Text('April 2026')
                                                ),
                                                DropdownMenuItem(
                                                  value: '05-2026',
                                                  child: Text('Mei 2026')
                                                ),
                                                DropdownMenuItem(
                                                  value: '06-2026',
                                                  child: Text('Juni 2026')
                                                ),
                                                DropdownMenuItem(
                                                  value: '07-2026',
                                                  child: Text('Juli 2026')
                                                ),
                                                DropdownMenuItem(
                                                  value: '08-2026',
                                                  child: Text('Agustus 2026')
                                                ),
                                                DropdownMenuItem(
                                                  value: '09-2026',
                                                  child: Text('September 2026')
                                                ),
                                                DropdownMenuItem(
                                                  value: '10-2026',
                                                  child: Text('Oktober 2026')
                                                ),
                                                DropdownMenuItem(
                                                  value: '11-2026',
                                                  child: Text('November 2026')
                                                ),
                                                DropdownMenuItem(
                                                  value: '12-2026',
                                                  child: Text('Desember 2026')
                                                ),
                                                DropdownMenuItem(
                                                  value: '01-2027',
                                                  child: Text('Januari 2027')
                                                ),
                                                DropdownMenuItem(
                                                  value: '02-2027',
                                                  child: Text('Februari 2027')
                                                ),
                                                DropdownMenuItem(
                                                  value: '03-2027',
                                                  child: Text('Maret 2027')
                                                ),
                                                DropdownMenuItem(
                                                  value: '04-2027',
                                                  child: Text('April 2027')
                                                ),
                                                DropdownMenuItem(
                                                  value: '05-2027',
                                                  child: Text('Mei 2027')
                                                ),
                                                DropdownMenuItem(
                                                  value: '06-2027',
                                                  child: Text('Juni 2027')
                                                ),
                                                DropdownMenuItem(
                                                  value: '07-2027',
                                                  child: Text('Juli 2027')
                                                ),
                                                DropdownMenuItem(
                                                  value: '08-2027',
                                                  child: Text('Agustus 2027')
                                                ),
                                                DropdownMenuItem(
                                                  value: '09-2027',
                                                  child: Text('September 2027')
                                                ),
                                                DropdownMenuItem(
                                                  value: '10-2027',
                                                  child: Text('Oktober 2027')
                                                ),
                                                DropdownMenuItem(
                                                  value: '11-2027',
                                                  child: Text('November 2027')
                                                ),
                                                DropdownMenuItem(
                                                  value: '12-2027',
                                                  child: Text('Desember 2027')
                                                ),
                                                DropdownMenuItem(
                                                  value: '01-2028',
                                                  child: Text('Januari 2028')
                                                ),
                                                DropdownMenuItem(
                                                  value: '02-2028',
                                                  child: Text('Februari 2028')
                                                ),
                                                DropdownMenuItem(
                                                  value: '03-2028',
                                                  child: Text('Maret 2028')
                                                ),
                                                DropdownMenuItem(
                                                  value: '04-2028',
                                                  child: Text('April 2028')
                                                ),
                                                DropdownMenuItem(
                                                  value: '05-2028',
                                                  child: Text('Mei 2028')
                                                ),
                                                DropdownMenuItem(
                                                  value: '06-2028',
                                                  child: Text('Juni 2028')
                                                ),
                                                DropdownMenuItem(
                                                  value: '07-2028',
                                                  child: Text('Juli 2028')
                                                ),
                                                DropdownMenuItem(
                                                  value: '08-2028',
                                                  child: Text('Agustus 2028')
                                                ),
                                                DropdownMenuItem(
                                                  value: '09-2028',
                                                  child: Text('September 2028')
                                                ),
                                                DropdownMenuItem(
                                                  value: '10-2028',
                                                  child: Text('Oktober 2028')
                                                ),
                                                DropdownMenuItem(
                                                  value: '11-2028',
                                                  child: Text('November 2028')
                                                ),
                                                DropdownMenuItem(
                                                  value: '12-2028',
                                                  child: Text('Desember 2028')
                                                ),
                                                DropdownMenuItem(
                                                  value: '01-2029',
                                                  child: Text('Januari 2029')
                                                ),
                                                DropdownMenuItem(
                                                  value: '02-2029',
                                                  child: Text('Februari 2029')
                                                ),
                                                DropdownMenuItem(
                                                  value: '03-2029',
                                                  child: Text('Maret 2029')
                                                ),
                                                DropdownMenuItem(
                                                  value: '04-2029',
                                                  child: Text('April 2029')
                                                ),
                                                DropdownMenuItem(
                                                  value: '05-2029',
                                                  child: Text('Mei 2029')
                                                ),
                                                DropdownMenuItem(
                                                  value: '06-2029',
                                                  child: Text('Juni 2029')
                                                ),
                                                DropdownMenuItem(
                                                  value: '07-2029',
                                                  child: Text('Juli 2029')
                                                ),
                                                DropdownMenuItem(
                                                  value: '08-2029',
                                                  child: Text('Agustus 2029')
                                                ),
                                                DropdownMenuItem(
                                                  value: '09-2029',
                                                  child: Text('September 2029')
                                                ),
                                                DropdownMenuItem(
                                                  value: '10-2029',
                                                  child: Text('Oktober 2029')
                                                ),
                                                DropdownMenuItem(
                                                  value: '11-2029',
                                                  child: Text('November 2029')
                                                ),
                                                DropdownMenuItem(
                                                  value: '12-2029',
                                                  child: Text('Desember 2029')
                                                ),
                                                DropdownMenuItem(
                                                  value: '01-2030',
                                                  child: Text('Januari 2030')
                                                ),
                                                DropdownMenuItem(
                                                  value: '02-2030',
                                                  child: Text('Februari 2030')
                                                ),
                                                DropdownMenuItem(
                                                  value: '03-2030',
                                                  child: Text('Maret 2030')
                                                ),
                                                DropdownMenuItem(
                                                  value: '04-2030',
                                                  child: Text('April 2030')
                                                ),
                                                DropdownMenuItem(
                                                  value: '05-2030',
                                                  child: Text('Mei 2030')
                                                ),
                                                DropdownMenuItem(
                                                  value: '06-2030',
                                                  child: Text('Juni 2030')
                                                ),
                                                DropdownMenuItem(
                                                  value: '07-2030',
                                                  child: Text('Juli 2030')
                                                ),
                                                DropdownMenuItem(
                                                  value: '08-2030',
                                                  child: Text('Agustus 2030')
                                                ),
                                                DropdownMenuItem(
                                                  value: '09-2030',
                                                  child: Text('September 2030')
                                                ),
                                                DropdownMenuItem(
                                                  value: '10-2030',
                                                  child: Text('Oktober 2030')
                                                ),
                                                DropdownMenuItem(
                                                  value: '11-2030',
                                                  child: Text('November 2030')
                                                ),
                                                DropdownMenuItem(
                                                  value: '12-2030',
                                                  child: Text('Desember 2030')
                                                )
                                              ], 
                                              onChanged: (value){
                                                if(value == '01-2024'){
                                                  month = 1; year = 2024; dateTimeName = 'Januari 2024';
                                                } else if (value == '02-2024'){
                                                  month = 2; year = 2024; dateTimeName = 'Februari 2024';
                                                } else if (value == '03-2024'){
                                                  month = 3; year = 2024; dateTimeName = 'Maret 2024';
                                                } else if (value == '04-2024'){
                                                  month = 4; year = 2024; dateTimeName = 'April 2024';
                                                } else if (value == '05-2024'){
                                                  month = 5; year = 2024; dateTimeName = 'Mei 2024';
                                                } else if (value == '06-2024'){
                                                  month = 6; year = 2024; dateTimeName = 'Juni 2024';
                                                } else if (value == '07-2024'){
                                                  month = 7; year = 2024; dateTimeName = 'Juli 2024';
                                                } else if (value == '08-2024'){
                                                  month = 8; year = 2024; dateTimeName = 'Agustus 2024';
                                                } else if (value == '09-2024'){
                                                  month = 9; year = 2024; dateTimeName = 'September 2024';
                                                } else if (value == '10-2024'){
                                                  month = 10; year = 2024; dateTimeName = 'Oktober 2024';
                                                } else if (value == '11-2024'){
                                                  month = 11; year = 2024; dateTimeName = 'November 2024';
                                                } else if (value == '12-2024'){
                                                  month = 12; year = 2024; dateTimeName = 'Desember 2024';
                                                } else if(value == '01-2025'){
                                                  month = 1; year = 2025; dateTimeName = 'Januari 2025';
                                                } else if (value == '02-2025'){
                                                  month = 2; year = 2025; dateTimeName = 'Februari 2025';
                                                } else if (value == '03-2025'){
                                                  month = 3; year = 2025; dateTimeName = 'Maret 2025';
                                                } else if (value == '04-2025'){
                                                  month = 4; year = 2025; dateTimeName = 'April 2025';
                                                } else if (value == '05-2025'){
                                                  month = 5; year = 2025; dateTimeName = 'Mei 2025';
                                                } else if (value == '06-2025'){
                                                  month = 6; year = 2025; dateTimeName = 'Juni 2025';
                                                } else if (value == '07-2025'){
                                                  month = 7; year = 2025; dateTimeName = 'Juli 2025';
                                                } else if (value == '08-2025'){
                                                  month = 8; year = 2025; dateTimeName = 'Agustus 2025';
                                                } else if (value == '09-2025'){
                                                  month = 9; year = 2025; dateTimeName = 'September 2025';
                                                } else if (value == '10-2025'){
                                                  month = 10; year = 2025; dateTimeName = 'Oktober 2025';
                                                } else if (value == '11-2025'){
                                                  month = 11; year = 2025; dateTimeName = 'November 2025';
                                                } else if (value == '12-2025'){
                                                  month = 12; year = 2025; dateTimeName = 'Desember 2025';
                                                } else if(value == '01-2026'){
                                                  month = 1; year = 2026; dateTimeName = 'Januari 2026';
                                                } else if (value == '02-2026'){
                                                  month = 2; year = 2026; dateTimeName = 'Februari 2026';
                                                } else if (value == '03-2026'){
                                                  month = 3; year = 2026; dateTimeName = 'Maret 2026';
                                                } else if (value == '04-2026'){
                                                  month = 4; year = 2026; dateTimeName = 'April 2026';
                                                } else if (value == '05-2026'){
                                                  month = 5; year = 2026; dateTimeName = 'Mei 2026';
                                                } else if (value == '06-2026'){
                                                  month = 6; year = 2026; dateTimeName = 'Juni 2026';
                                                } else if (value == '07-2026'){
                                                  month = 7; year = 2026; dateTimeName = 'Juli 2026';
                                                } else if (value == '08-2026'){
                                                  month = 8; year = 2026; dateTimeName = 'Agustus 2026';
                                                } else if (value == '09-2026'){
                                                  month = 9; year = 2026; dateTimeName = 'September 2026';
                                                } else if (value == '10-2026'){
                                                  month = 10; year = 2026; dateTimeName = 'Oktober 2026';
                                                } else if (value == '11-2026'){
                                                  month = 11; year = 2026; dateTimeName = 'November 2026';
                                                } else if (value == '12-2026'){
                                                  month = 12; year = 2026; dateTimeName = 'Desember 2026';
                                                } else if(value == '01-2027'){
                                                  month = 1; year = 2027; dateTimeName = 'Januari 2027';
                                                } else if (value == '02-2027'){
                                                  month = 2; year = 2027; dateTimeName = 'Februari 2027';
                                                } else if (value == '03-2027'){
                                                  month = 3; year = 2027; dateTimeName = 'Maret 2027';
                                                } else if (value == '04-2027'){
                                                  month = 4; year = 2027; dateTimeName = 'April 2027';
                                                } else if (value == '05-2027'){
                                                  month = 5; year = 2027; dateTimeName = 'Mei 2027';
                                                } else if (value == '06-2027'){
                                                  month = 6; year = 2027; dateTimeName = 'Juni 2027';
                                                } else if (value == '07-2027'){
                                                  month = 7; year = 2027; dateTimeName = 'Juli 2027';
                                                } else if (value == '08-2027'){
                                                  month = 8; year = 2027; dateTimeName = 'Agustus 2027';
                                                } else if (value == '09-2027'){
                                                  month = 9; year = 2027; dateTimeName = 'September 2027';
                                                } else if (value == '10-2027'){
                                                  month = 10; year = 2027; dateTimeName = 'Oktober 2027';
                                                } else if (value == '11-2027'){
                                                  month = 11; year = 2027; dateTimeName = 'November 2027';
                                                } else if (value == '12-2027'){
                                                  month = 12; year = 2027; dateTimeName = 'Desember 2027';
                                                } else if(value == '01-2028'){
                                                  month = 1; year = 2028; dateTimeName = 'Januari 2028';
                                                } else if (value == '02-2028'){
                                                  month = 2; year = 2028; dateTimeName = 'Februari 2028';
                                                } else if (value == '03-2028'){
                                                  month = 3; year = 2028; dateTimeName = 'Maret 2028';
                                                } else if (value == '04-2028'){
                                                  month = 4; year = 2028; dateTimeName = 'April 2028';
                                                } else if (value == '05-2028'){
                                                  month = 5; year = 2028; dateTimeName = 'Mei 2028';
                                                } else if (value == '06-2028'){
                                                  month = 6; year = 2028; dateTimeName = 'Juni 2028';
                                                } else if (value == '07-2028'){
                                                  month = 7; year = 2028; dateTimeName = 'Juli 2028';
                                                } else if (value == '08-2028'){
                                                  month = 8; year = 2028; dateTimeName = 'Agustus 2028';
                                                } else if (value == '09-2028'){
                                                  month = 9; year = 2028; dateTimeName = 'September 2028';
                                                } else if (value == '10-2028'){
                                                  month = 10; year = 2028; dateTimeName = 'Oktober 2028';
                                                } else if (value == '11-2028'){
                                                  month = 11; year = 2028; dateTimeName = 'November 2028';
                                                } else if (value == '12-2028'){
                                                  month = 12; year = 2028; dateTimeName = 'Desember 2028';
                                                } else if(value == '01-2029'){
                                                  month = 1; year = 2029; dateTimeName = 'Januari 2029';
                                                } else if (value == '02-2029'){
                                                  month = 2; year = 2029; dateTimeName = 'Februari 2029';
                                                } else if (value == '03-2029'){
                                                  month = 3; year = 2029; dateTimeName = 'Maret 2029';
                                                } else if (value == '04-2029'){
                                                  month = 4; year = 2029; dateTimeName = 'April 2029';
                                                } else if (value == '05-2029'){
                                                  month = 5; year = 2029; dateTimeName = 'Mei 2029';
                                                } else if (value == '06-2029'){
                                                  month = 6; year = 2029; dateTimeName = 'Juni 2029';
                                                } else if (value == '07-2029'){
                                                  month = 7; year = 2029; dateTimeName = 'Juli 2029';
                                                } else if (value == '08-2029'){
                                                  month = 8; year = 2029; dateTimeName = 'Agustus 2029';
                                                } else if (value == '09-2029'){
                                                  month = 9; year = 2029; dateTimeName = 'September 2029';
                                                } else if (value == '10-2029'){
                                                  month = 10; year = 2029; dateTimeName = 'Oktober 2029';
                                                } else if (value == '11-2029'){
                                                  month = 11; year = 2029; dateTimeName = 'November 2029';
                                                } else if (value == '12-2029'){
                                                  month = 12; year = 2029; dateTimeName = 'Desember 2029';
                                                } else if(value == '01-2030'){
                                                  month = 1; year = 2030; dateTimeName = 'Januari 2030';
                                                } else if (value == '02-2030'){
                                                  month = 2; year = 2030; dateTimeName = 'Februari 2030';
                                                } else if (value == '03-2030'){
                                                  month = 3; year = 2030; dateTimeName = 'Maret 2030';
                                                } else if (value == '04-2030'){
                                                  month = 4; year = 2030; dateTimeName = 'April 2030';
                                                } else if (value == '05-2030'){
                                                  month = 5; year = 2030; dateTimeName = 'Mei 2030';
                                                } else if (value == '06-2030'){
                                                  month = 6; year = 2030; dateTimeName = 'Juni 2030';
                                                } else if (value == '07-2030'){
                                                  month = 7; year = 2030; dateTimeName = 'Juli 2030';
                                                } else if (value == '08-2030'){
                                                  month = 8; year = 2030; dateTimeName = 'Agustus 2030';
                                                } else if (value == '09-2030'){
                                                  month = 9; year = 2030; dateTimeName = 'September 2030';
                                                } else if (value == '10-2030'){
                                                  month = 10; year = 2030; dateTimeName = 'Oktober 2030';
                                                } else if (value == '11-2030'){
                                                  month = 11; year = 2030; dateTimeName = 'November 2030';
                                                } else if (value == '12-2030'){
                                                  month = 12; year = 2030; dateTimeName = 'Desember 2030';
                                                }
                                              }
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10.w,),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width  - 240.w) / 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ElevatedButton(
                                              onPressed: (){
                                                if(month == 0 || year == 0 || selectedEmployeeId == ''){
                                                  Get.snackbar('Error', 'Silahkan pilih bulan atau karyawan terlebih dahulu');
                                                } else {
                                                  getPayroll(month, year, selectedEmployeeId);
                                                  fetchDetailData();
                                                }
                                              }, 
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size(50.w, 45.h),
                                                foregroundColor: const Color(0xFFFFFFFF),
                                                backgroundColor: const Color(0xff4ec3fc),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text('Cari')
                                            )
                                          ]
                                        )
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 20.h,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width  - 100.w) / 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text('Nama karyawan',
                                                    style: TextStyle(
                                                      fontSize: 4.sp,
                                                      fontWeight: FontWeight.w600,
                                                    )
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text(selectedEmployeeName)
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.h,),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text('Divisi',
                                                    style: TextStyle(
                                                      fontSize: 4.sp,
                                                      fontWeight: FontWeight.w600,
                                                    )
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text(departmentName)
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.h,),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text('NIK',
                                                    style: TextStyle(
                                                      fontSize: 4.sp,
                                                      fontWeight: FontWeight.w600,
                                                    )
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text(NIK)
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width  - 100.w) / 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text('Jabatan',
                                                    style: TextStyle(
                                                      fontSize: 4.sp,
                                                      fontWeight: FontWeight.w600,
                                                    )
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text(positionName)
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.h,),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text('Periode',
                                                    style: TextStyle(
                                                      fontSize: 4.sp,
                                                      fontWeight: FontWeight.w600,
                                                    )
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text(dateTimeName)
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      )
                                    ]
                                  ),
                                  SizedBox(height: 20.h,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width  - 100.w) / 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Pendapatan',
                                              style: TextStyle(
                                                fontSize: 6.sp,
                                                fontWeight: FontWeight.w600,
                                              )
                                            ),
                                            SizedBox(height: 25.h,),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text('Gaji pokok',
                                                    style: TextStyle(
                                                      fontSize: 4.sp,
                                                      fontWeight: FontWeight.w600,
                                                    )
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text(formatCurrency(gajiPokok))
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5.h,),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text('Tunjangan jabatan',
                                                    style: TextStyle(
                                                      fontSize: 4.sp,
                                                      fontWeight: FontWeight.w600,
                                                    )
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text(formatCurrency(Jabatan))
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5.h,),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text('BPJS Ketenagakerjaan + JP',
                                                    style: TextStyle(
                                                      fontSize: 4.sp,
                                                      fontWeight: FontWeight.w600,
                                                    )
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text(formatCurrency(BPJSKetenag))
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5.h,),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text('BPJS Kesehatan',
                                                    style: TextStyle(
                                                      fontSize: 4.sp,
                                                      fontWeight: FontWeight.w600,
                                                    )
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text(formatCurrency(BPJSKesehatan))
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5.h,),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text('Lembur',
                                                    style: TextStyle(
                                                      fontSize: 4.sp,
                                                      fontWeight: FontWeight.w600,
                                                    )
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text(formatCurrency(Lembur))
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5.h,),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text('Transport',
                                                    style: TextStyle(
                                                      fontSize: 4.sp,
                                                      fontWeight: FontWeight.w600,
                                                    )
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text(formatCurrency(Transport))
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5.h,),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text('Lainnya',
                                                    style: TextStyle(
                                                      fontSize: 4.sp,
                                                      fontWeight: FontWeight.w600,
                                                    )
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text(formatCurrency(Lainnya))
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10.w,),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width  - 100.w) / 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Pemotongan',
                                              style: TextStyle(
                                                fontSize: 6.sp,
                                                fontWeight: FontWeight.w600,
                                              )
                                            ),
                                            SizedBox(height: 25.h,),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text('Pinjaman',
                                                    style: TextStyle(
                                                      fontSize: 4.sp,  
                                                      fontWeight: FontWeight.w600,
                                                    )
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text(formatCurrency(Pinjaman))
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5.h,),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text('Pajak (PPH 21)',
                                                    style: TextStyle(
                                                      fontSize: 4.sp,
                                                      fontWeight: FontWeight.w600,
                                                    )
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text(formatCurrency(Pajak))
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5.h,),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text('BPJS Ketenag',
                                                    style: TextStyle(
                                                      fontSize: 4.sp,
                                                      fontWeight: FontWeight.w600,
                                                    )
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text(formatCurrency(PotBPJSKet1))
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5.h,),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text('BPJS Kesehatan',
                                                    style: TextStyle(
                                                      fontSize: 4.sp,
                                                      fontWeight: FontWeight.w600,
                                                    )
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text(formatCurrency(PotBPJSKes1))
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5.h,),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text('BPJS Ketenag',
                                                    style: TextStyle(
                                                      fontSize: 4.sp,
                                                      fontWeight: FontWeight.w600,
                                                    )
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text(formatCurrency(PotBPJSKet2))
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5.h,),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text('BPJS Kesehatan',
                                                    style: TextStyle(
                                                      fontSize: 4.sp,
                                                      fontWeight: FontWeight.w600,
                                                    )
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text(formatCurrency(PotBPJSKes2))
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5.h,),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text('PPH atas bonus/komisi',
                                                    style: TextStyle(
                                                      fontSize: 4.sp,
                                                      fontWeight: FontWeight.w600,
                                                    )
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text(formatCurrency(PPHBonus))
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5.h,),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text('Lainnya',
                                                    style: TextStyle(
                                                      fontSize: 4.sp,
                                                      fontWeight: FontWeight.w600,
                                                    )
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: ((MediaQuery.of(context).size.width  - 100.w) / 2) / 2,
                                                  child: Text(formatCurrency(penguranganLainnya))
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 35.h,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width  + 10.w) / 2,
                                        child: Text('Total Pendapatan', 
                                          style: TextStyle(
                                            fontSize: 6.sp,
                                            fontWeight: FontWeight.w600,
                                          )
                                        )
                                      ),
                                      SizedBox(width: 10.w,),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width  - 250.w) / 2,
                                        child: Text(formatCurrency(totalEarnings),
                                                style: TextStyle(
                                                    fontSize: 6.sp,
                                                )
                                              )
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width  + 10.w) / 2,
                                        child: Text('Total Pemotongan', 
                                          style: TextStyle(
                                            fontSize: 6.sp,
                                            fontWeight: FontWeight.w600,
                                          )
                                        )
                                      ),
                                      SizedBox(width: 10.w,),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width  - 250.w) / 2,
                                        child: Text(formatCurrency(totalDeductions),
                                                style: TextStyle(
                                                    fontSize: 6.sp,
                                                )
                                              )
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width  + 10.w) / 2,
                                        child: Text('Pendapatan Bersih', 
                                          style: TextStyle(
                                            fontSize: 6.sp,
                                            fontWeight: FontWeight.w600,
                                          )
                                        )
                                      ),
                                      SizedBox(width: 10.w,),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width  - 250.w) / 2,
                                        child: Text(formatCurrency(takeHomePay),
                                                style: TextStyle(
                                                    fontSize: 6.sp,
                                                )
                                              )
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: (){
                                          generateAndDisplayPDF(1, dateTimeName);
                                        }, 
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(50.w, 45.h),
                                          foregroundColor: const Color(0xFFFFFFFF),
                                          backgroundColor: const Color(0xff4ec3fc),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text('Cetak slip gaji')
                                      )
                                    ],
                                  )
                                ],
                              )
                          ]
                        )
                       )
                    ]
                  )
                )  
              )
            ],
          ),
        )
      ),
    );
  }
}