import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madhupurifinance/Controller/LoginController.dart';
import 'package:madhupurifinance/Controller/PayEmiController.dart';
import 'package:madhupurifinance/Controller/loansController.dart';
import 'package:madhupurifinance/HomeLoans.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

import '../Utils.dart';

class HomeLoanController extends GetxController {

  TextEditingController homeSearch = TextEditingController();
  final LoansController loansController = Get.put(LoansController());
  final PayEmiController payEmiController = Get.put(PayEmiController());
  final LoginController loginController = Get.put(LoginController());

  RxBool pendingEmi = true.obs;
  RxBool homeLoading = true.obs;
  List<Map<String, dynamic>> loans = [];
  List<Map<String, dynamic>> loansData = [];
  RxString errorMsg = "".obs;
  RxString idLoans = "".obs;
  String editKycStoreId = '';
  String? emiStartDate;
  String? emiEndDate;
  String? loanAmount;
  String? emiAmount;
  String? duration;
  String? serviceCharge;
  String? penlatyAmount;
  String? otherAmount;
  String? loanNumber;
  String? paymentDate;
  String? downPay;
  String? kycID;
  String? pdfLoanID;
  String? closeDate;
  RxString errorMessageLoan = "".obs;
  RxString loanDataNew = "".obs;
  RxString loanDataEnd = "".obs;
  ///radioButton
  String? selectValue;
  RxString errorMsgHome = "".obs;
  String? success;

  RxBool isExportingPdf = false.obs;
  RxBool isExportingExcel = false.obs;

  Future<void> getPendingEmi() async {
    try {
      homeLoading.value = true;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        loginController.loginUserId = prefs.getString("userId");

      if (loginController.loginUserId == null || loginController.loginUserId!.isEmpty) {
        // Get.snackbar("Error", "User ID missing.");
        homeLoading.value = false;
        return;
      }

      Map<String, dynamic> loansMap = {
        "user_id": loginController.loginUserId,
        "pending_emi": pendingEmi.value,
      };

      final response = await http.post(
        Uri.parse("${Utils().baseURL}get_loans"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(loansMap),
      );

      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        errorMsgHome.value = responseData["errorMsg"].toString();
        success = responseData['success'].toString();
        loansData =  List<Map<String, dynamic>>.from(responseData['loans']);
        loans = List<Map<String, dynamic>>.from(responseData['loans']);
      } else {
        homeLoading.value = false;
        errorMsgHome.value = responseData["errorMsg"].toString();
        // Get.snackbar("Error", errorMsgHome.value);
      }
    } catch (e) {
      homeLoading.value = false;
      // Get.snackbar("Error", e.toString());
    }
  }

  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.request();
      if (status.isGranted) return true;
      Get.snackbar("Permission Denied", "Storage permission is required to save files.");
      return false;
    }
    return true; // iOS/web doesn’t need storage permission
  }

  Future<void> exportToPdf(List<Map<String, dynamic>> transactions) async {
    if (!kIsWeb && !await _requestPermission()) return;

    try {
      isExportingPdf.value = true;

      final pdf = pw.Document();

      final logo = pw.MemoryImage(
        (await rootBundle.load("assets/images/mflogo.png")).buffer.asUint8List(),
      );

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          header: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(logo, width: 50, height: 50),
                  pw.Text("Pending Emi's Report",
                      style: pw.TextStyle(fontSize: 16)),
                  pw.Text(DateFormat("dd/MM/yyyy").format(DateTime.now()),
                      style: pw.TextStyle(fontSize: 12)),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Divider(),
            ],
          ),
          footer: (context) => pw.Center(
            child: pw.Text("Generated by Madhupuri Finance",
                style: pw.TextStyle(fontSize: 10)),
          ),
          build: (pw.Context context) => [
            pw.SizedBox(height: 20),

            pw.Table(
              columnWidths: {
                0: const pw.FixedColumnWidth(50),  // Loan ID column width = 80
                1: const pw.FixedColumnWidth(50), // Name column width = 120
                2: const pw.FixedColumnWidth(150), // Number column width = 100
                3: const pw.FixedColumnWidth(100), // Number column width = 100
                4: const pw.FixedColumnWidth(80), // Number column width = 100
                5: const pw.FixedColumnWidth(80), // Number column width = 100
                6: const pw.FixedColumnWidth(80), // Number column width = 100
                7: const pw.FixedColumnWidth(110), // Number column width = 100
              },
              border: pw.TableBorder.all(width: 0.5),
              children: [
                // Header Row
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Sr No.", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Loan\nID", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Name", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Mob. No.", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Loan\nAMT", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Emi\nAMT", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Pending\nEmi AMT", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Last Payment\nDate", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                ),

                // Data Rows
                ...List.generate(transactions.length, (index) {
                  final row = transactions[index];
                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text((index + 1).toString()), // ✅ Sr No.
                      ),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['id'].toString(),)),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['name'].toString(),)),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['mobile_no'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['principal_amount'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['emi_amount'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['due_emi_amount'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: row['last_payment_date'] == null ? pw.Text("NA") : pw.Text(row['last_payment_date'].toString())),
                    ],
                  );
                }),
              ],
            ),
          ],
        ),
      );

      if (kIsWeb) {
        // ✅ Web: trigger file download
        final bytes = await pdf.save();
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", "transactions.pdf")
          ..click();
        html.Url.revokeObjectUrl(url);

        Get.snackbar("✅ Success", "PDF downloaded in browser");
      } else {
        // ✅ Android / iOS / Desktop
        Directory? downloadsDir;
        if (Platform.isAndroid) {
          downloadsDir = Directory("/storage/emulated/0/Download");
        } else {
          downloadsDir = await getApplicationDocumentsDirectory();
        }

        final file = File("${downloadsDir.path}/transactions.pdf");
        await file.writeAsBytes(await pdf.save());

        Get.snackbar("✅ Success", "PDF exported: ${file.path}");
      }
    } finally {
      isExportingPdf.value = false;
    }
  }
  Future<void> excelCustomerDue(List<Map<String, dynamic>> transactions) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Pending Emi'];

    sheetObject.appendRow([
      TextCellValue("Loans ID"),
      TextCellValue("Name"),
      TextCellValue("Number"),
      TextCellValue("Loan Amount"),
      TextCellValue("Emi Amount"),
      TextCellValue("Emi pending"),
    ]);

    for (var row in transactions) {
      sheetObject.appendRow([
        IntCellValue(int.tryParse(row['id'].toString()) ?? 0),
        TextCellValue(row['name'].toString()),
        TextCellValue(row['mobile_no'].toString()),
        TextCellValue(row['principal_amount'].toString()),
        TextCellValue(row['emi_amount'].toString()),
        TextCellValue(row['due_emi_amount'].toString()),
      ]);
    }

    if (kIsWeb) {
      // ✅ Web: trigger download in browser
      final bytes = excel.encode()!;
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "Pending Emi.xlsx")
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      // ✅ Mobile/Desktop
      Directory? downloadsDir;
      if (Platform.isAndroid) {
        downloadsDir = Directory("/storage/emulated/0/Download");
      } else {
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      final file = File("${downloadsDir.path}/pending Emi.xlsx");
      await file.writeAsBytes(excel.encode()!);

      print("✅ Excel exported: ${file.path}");
    }
  }

  List runFilter(String enterKeyword) {
    if (enterKeyword.isEmpty) {
      loansData = List.from(loans);
    } else {
      loansData = loans.where((item) {
        String name = item['name']?.toString() ?? "";
        String loanDate = item['loan_date']?.toString() ?? "";
        String loanId = item['id']?.toString() ?? "";
        String date = item['emi_due_date']?.toString() ?? "";

        return name.toLowerCase().contains(enterKeyword.toLowerCase()) ||
            loanDate.toLowerCase().contains(enterKeyword.toLowerCase()) ||
            loanId.toLowerCase().contains(enterKeyword.toLowerCase()) ||
            date.toLowerCase().contains(enterKeyword.toLowerCase());
      }).toList();
    }
    return loansData;
  }


}