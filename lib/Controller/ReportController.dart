import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:madhupurifinance/Controller/LoginController.dart';
import 'package:madhupurifinance/Utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'dart:io' show File, Platform; // ✅ only import if not web
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

class ReportController extends GetxController {
  final LoginController loginController = Get.put(LoginController());

  TextEditingController transactionReport = TextEditingController();
  TextEditingController customerDue = TextEditingController();
  TextEditingController upcomingEmi = TextEditingController();
  TextEditingController completedEmi = TextEditingController();
  TextEditingController penaltyEmi = TextEditingController();
  TextEditingController balanceSheet = TextEditingController();

  RxBool payEmi = false.obs;
  String? hsLoanId;
  String? hsPaymentDate;
  String? hsEmiAmount;
  String? hsPenalty;
  String? hsOtherAmount;
  String? emiNewLoansID;
  bool? successAPi;
  String? success;
  String? payment_id;
  List<Map<String, dynamic>> loanTransactionHistory = [];
  RxBool customer = false.obs;
  RxString errorMessageLoan = "".obs;
  List<Map<String, dynamic>> loans = [];
  RxList<Map<String, dynamic>> loansData = <Map<String, dynamic>>[].obs;

  RxBool isExportingPdf = false.obs;
  RxBool isExportingExcel = false.obs;
  var selectedReport = 'Report'.obs;

  String formatDate(DateTime date) => DateFormat("dd/MM/yyyy").format(date);

  final List<String> dropDown = [
    'Transaction Report',
    'Customer Due',
    // 'Completed Emi',
    'Penalty Report',
    // 'Balance Sheet',
  ];

  void setSelected(String val) => selectedReport.value = val;

  Future<void> emiPaymentHistory() async {
    try {
      payEmi.value = true;

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString("userId");

      if (userId == null || userId.isEmpty) {
        payEmi.value = false;
        Get.snackbar("Error", "User ID missing.");
        return;
      }

      final Map<String, dynamic> getPayment = {
        "user_id": userId,
        "penalty_only" : true
      };

      final response = await http.post(
        Uri.parse(
          "${Utils().baseURL}get_payment_received",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(getPayment),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData["success"] == true) {
        print("user id");
        print(loginController.loginUserId);
        loanTransactionHistory =
        List<Map<String, dynamic>>.from(responseData['payments']);

        // 🔑 Add this line so UI has initial full list
        loansData.assignAll(loanTransactionHistory);

        if (loanTransactionHistory.isNotEmpty) {
          hsLoanId = loanTransactionHistory.first['loan_id'].toString();
          hsPaymentDate = loanTransactionHistory.first['paid_date'].toString();
          hsEmiAmount = loanTransactionHistory.first['emi_amount'].toString();
          hsOtherAmount = loanTransactionHistory.first['other_amount'].toString();
          hsPenalty = loanTransactionHistory.first['penalty'].toString();
        }
      }
      else {
        Get.snackbar("Error", responseData["errorMsg"].toString());
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      payEmi.value = false;
    }
  }

  Future<void> getLoans() async {
    try {
      customer.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString("userId");

      if (userId == null || userId.isEmpty) {
        customer.value = false;
        errorMessageLoan.value = "User ID missing";
        return;
      }

      Map<String, dynamic> loansMap = {
        "user_id": userId,
      };

      final response = await http.post(
        Uri.parse(
            "${Utils().baseURL}get_loans"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(loansMap),
      );

      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        errorMessageLoan.value = responseData['errorMsg'].toString();

        List<dynamic> loansJson = responseData["loans"];
        loans = loansJson.map<Map<String, dynamic>>((e) {
          int tenure = int.tryParse(e["tenure"].toString()) ?? 0;
          int emiPaidCount = int.tryParse(e["emi_paid_count"].toString()) ?? 0;

          DateTime startDate = DateTime.parse(e["loan_date"]);
          DateTime today = DateTime.now();

          DateTime dueDate =
          DateTime(startDate.year, startDate.month + tenure, startDate.day);

          DateTime nextEmiDate =
          DateTime(startDate.year, startDate.month + emiPaidCount + 1, startDate.day);

          while (nextEmiDate.isBefore(today)) {
            nextEmiDate =
                DateTime(nextEmiDate.year, nextEmiDate.month + 1, nextEmiDate.day);
          }

          return {
            "loanId": e["id"]?.toString() ?? "-",
            "name": e["name"]?.toString() ?? "-",
            "mobile_no" : e["mobile_no"]?.toString() ?? "-",
            "principalAmount": int.tryParse(e["principal_amount"].toString()) ?? 0,
            "type": e["type"]?.toString() ?? "-",
            "emi_amount": double.tryParse(e["emi_amount"].toString()) ?? 0.0,
            "tenure": int.tryParse(e["tenure"].toString()) ?? 0,
            "loanDate": e["loan_date"]?.toString() ?? "/",
            "emiPaid": int.tryParse(e["emi_paid"].toString()) ?? 0,
            "emiPending": int.tryParse(e["emi_pending"].toString()) ?? 0,
            "due_emi_amount": int.tryParse(e["due_emi_amount"].toString()) ?? 0,
            "emiPaidCount": int.tryParse(e["emi_paid_count"].toString()) ?? 0,
            "emiPendingCount": int.tryParse(e["emi_pending_count"].toString()) ?? 0,
            "dueDate": formatDate(dueDate),
            "nextEmiDate": formatDate(nextEmiDate),
          };
        }).toList();

        loansData.assignAll(loans);
      } else {
        customer.value = false;
        errorMessageLoan.value = responseData["errorMsg"].toString();
      }
    } catch (e) {
      customer.value = false;
      errorMessageLoan.value = e.toString();
    }
  }


  /// ✅ Ask for storage permission (Android only)
  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.request();
      if (status.isGranted) return true;
      Get.snackbar("Permission Denied", "Storage permission is required to save files.");
      return false;
    }
    return true; // iOS/web doesn’t need storage permission
  }


  Future<void> exportToExcel(List<Map<String, dynamic>> transactions) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Transactions'];

    sheetObject.appendRow([
      TextCellValue("ID"),
      TextCellValue("Loans ID"),
      TextCellValue("Name"),
      TextCellValue("EMI Amount"),
      TextCellValue("Penalty"),
      TextCellValue("Other Amount"),
      TextCellValue("Paid Date"),
    ]);

    for (var row in transactions) {
      sheetObject.appendRow([
        IntCellValue(int.tryParse(row['id'].toString()) ?? 0),
        IntCellValue(int.tryParse(row['loan_id'].toString()) ?? 0),
        TextCellValue(row['name'].toString()),
        DoubleCellValue(double.tryParse(row['emi_amount'].toString()) ?? 0.0),
        DoubleCellValue(double.tryParse(row['penalty'].toString()) ?? 0.0),
        DoubleCellValue(double.tryParse(row['other_amount'].toString()) ?? 0.0),
        TextCellValue(row['paid_date'].toString()),
      ]);
    }

    if (kIsWeb) {
      // ✅ Web: trigger download in browser
      final bytes = excel.encode()!;
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "transactions.xlsx")
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

      final file = File("${downloadsDir.path}/transactions.xlsx");
      await file.writeAsBytes(excel.encode()!);

      print("✅ Excel exported: ${file.path}");
    }
  }
  Future<void> exportToPdf(List<Map<String, dynamic>> transactions) async {
    if (!kIsWeb && !await _requestPermission()) return;

    try {
      isExportingPdf.value = true;

      final pdf = pw.Document();

      // ✅ Load Logo (from assets)
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
                  pw.Text("Madhupuri Finance Report",
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
                2: const pw.FixedColumnWidth(110), // Number column width = 100
                3: const pw.FixedColumnWidth(80), // Number column width = 100
                4: const pw.FixedColumnWidth(80), // Number column width = 100
                5: const pw.FixedColumnWidth(80), // Number column width = 100
                6: const pw.FixedColumnWidth(120), // Number column width = 100
              },
              border: pw.TableBorder.all(width: 0.5),
              children: [
                // Header Row
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("ID", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
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
                      child: pw.Text("Emi\nAMT", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Penalty", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Other\nAMT", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Paid Date", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                ),

                // Data Rows
                ...transactions.map((row) {
                  return pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['id'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['loan_id'].toString(),)),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['name'].toString(),)),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['emi_amount'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['penalty'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['other_amount'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['paid_date'].toString())),
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
    Sheet sheetObject = excel['Customer_Due_Report'];

    sheetObject.appendRow([
      TextCellValue("Loans ID"),
      TextCellValue("Name"),
      TextCellValue("Number"),
      TextCellValue("Loan Amount"),
      TextCellValue("Duration"),
      TextCellValue("Paid Amount"),
      TextCellValue("Due Amount"),
      TextCellValue("Loan Date"),
      TextCellValue("Due Date"),
      TextCellValue("Next Emi Date"),
    ]);

    for (var row in transactions) {
      sheetObject.appendRow([
        IntCellValue(int.tryParse(row['loanId'].toString()) ?? 0),
        TextCellValue(row['name'].toString()),
        TextCellValue(row['mobile_no'].toString()),
        TextCellValue(row['principalAmount'].toString()),
        TextCellValue(row['tenure'].toString()),
        TextCellValue(row['emiPaid'].toString()),
        TextCellValue(row['emiPending'].toString()),
        TextCellValue(row['loanDate'].toString()),
        TextCellValue(row['dueDate'].toString()),
        TextCellValue(row['nextEmiDate'].toString()),
      ]);
    }

    if (kIsWeb) {
      // ✅ Web: trigger download in browser
      final bytes = excel.encode()!;
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "Customer_Due_Report.xlsx")
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

      final file = File("${downloadsDir.path}/Customer_Due_Report.xlsx");
      await file.writeAsBytes(excel.encode()!);

      print("✅ Excel exported: ${file.path}");
    }
  }
  Future<void> pdfCustomerDue(List<Map<String, dynamic>> transactions) async {
    if (!kIsWeb && !await _requestPermission()) return;

    try {
      isExportingPdf.value = true;

      final pdf = pw.Document();

      // ✅ Load Logo (from assets)
      final logo = pw.MemoryImage(
        (await rootBundle.load("assets/images/mflogo.png")).buffer.asUint8List(),
      );

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a3,
          margin: const pw.EdgeInsets.all(12),
          header: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(logo, width: 50, height: 50),
                  pw.Text("Madhupuri Finance Report",
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

            // ✅ Simple Table
            pw.Table(
              columnWidths: {
                0: const pw.FixedColumnWidth(35),  // Loan ID column width = 80
                1: const pw.FixedColumnWidth(150), // Name column width = 120
                2: const pw.FixedColumnWidth(120), // Number column width = 100
                3: const pw.FixedColumnWidth(80), // Number column width = 100
                4: const pw.FixedColumnWidth(95), // Number column width = 100
                5: const pw.FixedColumnWidth(80), // Number column width = 100
                6: const pw.FixedColumnWidth(80), // Number column width = 100
                7: const pw.FixedColumnWidth(115), // Number column width = 100
                8: const pw.FixedColumnWidth(115), // Number column width = 100
                9: const pw.FixedColumnWidth(115), // Number column width = 100// Number column width = 100
                // others will auto size if not set
              },
              border: pw.TableBorder.all(width: 0.5),
              children: [
                // Header Row
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("ID", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Name", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Number", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Loan\nAMT", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Duration", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Paid\nAMT", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Due\nAMT", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Loan\nDate", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Due\nDate", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Next\nEMI", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                ),

                // Data Rows
                ...transactions.map((row) {
                  return pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['loanId'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['name'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['mobile_no'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['principalAmount'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['tenure'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['emiPaid'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['due_emi_amount'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['loanDate'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['dueDate'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['nextEmiDate'].toString())),
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
          ..setAttribute("download", "pendingEmi.pdf")
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

        final file = File("${downloadsDir.path}/pendingEmi.pdf");
        await file.writeAsBytes(await pdf.save());

        Get.snackbar("✅ Success", "PDF exported: ${file.path}");
      }
    } finally {
      isExportingPdf.value = false;
    }
  }


  Future<void> pdfCompletedEmi(List<Map<String, dynamic>> transactions) async {
    if (!kIsWeb && !await _requestPermission()) return;

    try {
      isExportingPdf.value = true;

      final pdf = pw.Document();

      // ✅ Load Logo (from assets)
      final logo = pw.MemoryImage(
        (await rootBundle.load("assets/images/mflogo.png")).buffer.asUint8List(),
      );

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(12),
          header: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(logo, width: 50, height: 50),
                  pw.Text("Madhupuri Finance Report",
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

            // ✅ Simple Table
            pw.Table(
              columnWidths: {
                0: const pw.FixedColumnWidth(35),  // Loan ID column width = 80
                1: const pw.FixedColumnWidth(150), // Name column width = 120
                2: const pw.FixedColumnWidth(80), // Number column width = 100
                3: const pw.FixedColumnWidth(80), // Number column width = 100
                4: const pw.FixedColumnWidth(95), // Number column width = 100
                5: const pw.FixedColumnWidth(120), // Number column width = 100
              },
              border: pw.TableBorder.all(width: 0.5),
              children: [
                // Header Row
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("ID", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Name", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Emi\nAMT", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Penalty", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Other\nAMT", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Paid\nDate", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                ),

                // Data Rows
                ...transactions.map((row) {
                  return pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['loan_id'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['name'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['emi_amount'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['penalty'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['other_amount'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['paid_date'].toString())),
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
          ..setAttribute("download", "Customer_Due_Report.pdf")
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

        final file = File("${downloadsDir.path}/Completed_Emi_Report.pdf");
        await file.writeAsBytes(await pdf.save());

        Get.snackbar("✅ Success", "PDF exported: ${file.path}");
      }
    } finally {
      isExportingPdf.value = false;
    }
  }
  Future<void> excelCompletedEMi(List<Map<String, dynamic>> transactions) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Completed_Emi_Report'];

    sheetObject.appendRow([
      TextCellValue("ID"),
      TextCellValue("Loans ID"),
      TextCellValue("Name"),
      TextCellValue("EMI Amount"),
      TextCellValue("Penalty"),
      TextCellValue("Other Amount"),
      TextCellValue("Paid Date"),
    ]);

    for (var row in transactions) {
      sheetObject.appendRow([
        IntCellValue(int.tryParse(row['id'].toString()) ?? 0),
        IntCellValue(int.tryParse(row['loan_id'].toString()) ?? 0),
        TextCellValue(row['name'].toString()),
        DoubleCellValue(double.tryParse(row['emi_amount'].toString()) ?? 0.0),
        DoubleCellValue(double.tryParse(row['penalty'].toString()) ?? 0.0),
        DoubleCellValue(double.tryParse(row['other_amount'].toString()) ?? 0.0),
        TextCellValue(row['paid_date'].toString()),
      ]);
    }

    if (kIsWeb) {
      // ✅ Web: trigger download in browser
      final bytes = excel.encode()!;
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "Completed_Emi_Report.xlsx")
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

      final file = File("${downloadsDir.path}/Completed_Emi_Report.xlsx");
      await file.writeAsBytes(excel.encode()!);

      print("✅ Excel exported: ${file.path}");
    }
  }

  Future<void> pdfPenalty(List<Map<String, dynamic>> transactions) async {
    if (!kIsWeb && !await _requestPermission()) return;

    try {
      isExportingPdf.value = true;

      final pdf = pw.Document();

      // ✅ Load Logo (from assets)
      final logo = pw.MemoryImage(
        (await rootBundle.load("assets/images/mflogo.png")).buffer.asUint8List(),
      );

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(12),
          header: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(logo, width: 50, height: 50),
                  pw.Text("Madhupuri Finance Report",
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

            // ✅ Simple Table
            pw.Table(
              columnWidths: {
                0: const pw.FixedColumnWidth(35),  // Loan ID column width = 80
                1: const pw.FixedColumnWidth(150), // Name column width = 120
                2: const pw.FixedColumnWidth(80), // Number column width = 100
                3: const pw.FixedColumnWidth(80), // Number column width = 100
                4: const pw.FixedColumnWidth(120), // Number column width = 100
              },
              border: pw.TableBorder.all(width: 0.5),
              children: [
                // Header Row
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("ID", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Name", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Penalty", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Other\nAMT", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Paid\nDate", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                ),

                // Data Rows
                ...transactions.map((row) {
                  return pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['loan_id'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['name'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['penalty'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['other_amount'].toString())),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['paid_date'].toString())),
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
          ..setAttribute("download", "Customer_Penalty_Report.pdf")
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

        final file = File("${downloadsDir.path}/Customer_Penalty_Report.pdf");
        await file.writeAsBytes(await pdf.save());

        Get.snackbar("✅ Success", "PDF exported: ${file.path}");
      }
    } finally {
      isExportingPdf.value = false;
    }
  }
  Future<void> excelPenalty(List<Map<String, dynamic>> transactions) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Customer_Penalty_Report'];

    sheetObject.appendRow([
      TextCellValue("ID"),
      TextCellValue("Loans ID"),
      TextCellValue("Name"),
      TextCellValue("Penalty"),
      TextCellValue("Other Amount"),
      TextCellValue("Paid Date"),
    ]);

    for (var row in transactions) {
      sheetObject.appendRow([
        IntCellValue(int.tryParse(row['id'].toString()) ?? 0),
        IntCellValue(int.tryParse(row['loan_id'].toString()) ?? 0),
        TextCellValue(row['name'].toString()),
        DoubleCellValue(double.tryParse(row['penalty'].toString()) ?? 0.0),
        DoubleCellValue(double.tryParse(row['other_amount'].toString()) ?? 0.0),
        TextCellValue(row['paid_date'].toString()),
      ]);
    }

    if (kIsWeb) {
      // ✅ Web: trigger download in browser
      final bytes = excel.encode()!;
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "Customer_Penalty_Report.xlsx")
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

      final file = File("${downloadsDir.path}/Customer_Penalty_Report.xlsx");
      await file.writeAsBytes(excel.encode()!);

      print("✅ Excel exported: ${file.path}");
    }
  }

  ///Search Bar
  void transactionSearch(String enterKeyword) {
    if (enterKeyword.isEmpty) {
      loansData.assignAll(loanTransactionHistory);
    } else {
      final keyword = enterKeyword.toLowerCase();
      final filtered = loanTransactionHistory.where((item) {
        return item.values.any((value) =>
            value.toString().toLowerCase().contains(keyword));
      }).toList();

      loansData.assignAll(filtered);
    }
  }

  void customerDueSearch(String enterKeyword) {
    if (enterKeyword.isEmpty) {
      loansData.assignAll(loans);   // use loans you fetched
    } else {
      final keyword = enterKeyword.toLowerCase();
      final filtered = loans.where((item) {
        return item.values.any((value) =>
            value.toString().toLowerCase().contains(keyword));
      }).toList();

      loansData.assignAll(filtered);
    }
  }




}

