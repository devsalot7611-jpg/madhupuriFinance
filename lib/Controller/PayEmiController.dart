import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madhupurifinance/Controller/LoginController.dart';
import 'package:madhupurifinance/Controller/loansController.dart';
import 'package:madhupurifinance/HomeLoans.dart';
import 'package:madhupurifinance/HomeSacreen.dart';
import 'package:madhupurifinance/Utils.dart';
import 'package:madhupurifinance/loans.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PayEmiController extends GetxController{

  final LoginController loginController = Get.put(LoginController());
  final LoansController loansController = Get.put(LoansController());

  String? mobilName;
  String? mobilKycID;
  String? mobilLoanDate;
  String? mobilLoanId;
  String? mobilLoanAmount;
  String? mobilOldPendingEmi;
  GlobalKey<FormState> emiFormKye = GlobalKey();
  GlobalKey<FormState> updateEmiPayment = GlobalKey();
  TextEditingController emiAmount = TextEditingController();
  TextEditingController emiPreMonth = TextEditingController();
  TextEditingController penalty = TextEditingController();
  TextEditingController other_amount = TextEditingController();
  TextEditingController detection = TextEditingController();
  TextEditingController Paid_Date = TextEditingController();
  TextEditingController emi_duration = TextEditingController();
  TextEditingController old_paid_emi = TextEditingController();
  TextEditingController payEmiSearch = TextEditingController();
  TextEditingController paymentDate = TextEditingController();

  TextEditingController extendMonths = TextEditingController(text: "1");
  late DateTime selectedUpdatePaidDate = DateTime.now();


   DateTime devSelectedDate= DateTime.now();

  Map<String, TextEditingController> payEmiControllers = {
    "emiPreMonthPayEmi": TextEditingController(),
    "penaltyPayEmi": TextEditingController(),
    "other_amount_payEmi": TextEditingController(),
    "paid_date_payEmi": TextEditingController(),
  };

  /* ── state ───────────────────────────────────────── */
  final rows = <Map<String, TextEditingController>>[].obs;
  final idVisibilityList = <RxBool>[].obs;   // per‑row icon/date flag

  RxBool iconDelete = false.obs;             // optional globals
  RxBool todayDate  = false.obs;

  /* ── life‑cycle ──────────────────────────────────── */
  @override
  void onInit() {
    super.onInit();
    _addBlankRow();
    // today
    Paid_Date.text   = DateFormat('dd-MM-yyyy')                 // show nice
        .format(devSelectedDate);// start with one empty line
  }

  /* ── public helper so other files can add a blank row ── */
  void addBlankRow() => _addBlankRow();      // ← just calls the private one

  /* ── row factory (Paid‑Date starts blank) ───────────── */
  Map<String, TextEditingController> _newRow() => {
    "emiLoanId"       : TextEditingController(),
    "emiKycId"        : TextEditingController(),
    "emiName"         : TextEditingController(),
    "emiLoanDate"     : TextEditingController(),
    "emiLoanAmount"   : TextEditingController(),
    "emiOldPaidEmi"   : TextEditingController(),
    "emiOldPendingEmi": TextEditingController(),
    "emiPayEmiAmount" : TextEditingController(),
    "emiPenalty"      : TextEditingController(),
    "emiOtherAmount"  : TextEditingController(),
    "emiPaidDate"     : TextEditingController(), // blank
  };

  /* ── private: create row + listeners + flag ────────── */
  void _addBlankRow() {
    rows.add(_newRow());
    idVisibilityList.add(false.obs);         // hide icon & date

    final idx = rows.length - 1;
    for (final key in [
      'emiLoanId',
      'emiKycId',
      'emiName',
      'emiLoanDate',
      'emiLoanAmount',
      'emiOldPaidEmi',
      'emiOldPendingEmi',
    ]) {
      rows[idx][key]!.addListener(() => _updateVisibility(idx));
    }
  }

  /* ── visibility helpers ───────────────────────────── */
  bool _coreFilled(int i) {
    final r = rows[i];
    return r['emiLoanId']!       .text.trim().isNotEmpty &&
        r['emiKycId']!        .text.trim().isNotEmpty &&
        r['emiName']!         .text.trim().isNotEmpty &&
        r['emiLoanDate']!     .text.trim().isNotEmpty &&
        r['emiLoanAmount']!   .text.trim().isNotEmpty &&
        r['emiOldPaidEmi']!   .text.trim().isNotEmpty &&
        r['emiOldPendingEmi']!.text.trim().isNotEmpty;
  }

  void _updateVisibility(int i) {
    if (_coreFilled(i)) {
      if (rows[i]['emiPaidDate']!.text.trim().isEmpty) {
        rows[i]['emiPaidDate']!.text =
            DateFormat('dd-MM-yyyy').format(DateTime.now());
      }
      idVisibilityList[i].value = true;      // show delete icon & date
    }
  }

  /* ── row‑growth logic ────────────────────────────── */
  void _maybeGrow(int i) {
    if (_coreFilled(i) && i == rows.length - 1) {
      _addBlankRow();                        // keep one empty row
      iconDelete.value = false;
      todayDate.value  = false;
    }
  }

  void addRowIfComplete(int i) {
    _maybeGrow(i);
    update();
  }

  void clearRow(int i) => rows[i].values.forEach((c) => c.clear());

  /* ── fillRow: always profile; payment when EmiPaid typed ─ */
  Future<void> fillRow(int i) async {
    final m = rows[i];

    /* 1. always load profile */
    await getPaymentLoan(i);

    /* 2. call getPayment only if EmiPaid has value */
    final hasEmiPaid = m['emiPayEmiAmount']!.text.trim().isNotEmpty;
    if (hasEmiPaid) {
      if (m['emiPenalty']!    .text.trim().isEmpty) m['emiPenalty']!    .text = '0';
      if (m['emiOtherAmount']!.text.trim().isEmpty) m['emiOtherAmount']!.text = '0';
      await getPayment(i);
    }

    /* 3. copy readonly data */
    m['emiKycId']!        .text = kycID           ?? '';
    m['emiName']!         .text = fullName        ?? '';
    m['emiLoanDate']!     .text = loanDateEmi     ?? '';
    m['emiLoanAmount']!   .text = loanAmountEmi   ?? '';
    m['emiOldPaidEmi']!   .text = oldPaidEmi      ?? '';
    m['emiOldPendingEmi']!.text = oldPendingdEmi  ?? '';

    /* 4. visibility & grow */
    _updateVisibility(i);
    _maybeGrow(i);
    update();
  }

  /* ── reset table to single blank row ───────────── */
  void resetAll() {
    rows.clear();
    idVisibilityList.clear();
    _addBlankRow();
    iconDelete.value = false;
    todayDate.value  = false;
    update();
  }

  /* ── dispose controllers ───────────────────────── */
  @override
  void onClose() {
    Paid_Date.dispose();
    emiPreMonth.dispose();
    penalty.dispose();
    other_amount.dispose();
    for (final r in rows) {
      r.values.forEach((c) => c.dispose());
    }
    super.onClose();
  }


  // TextEditingController emiPadiDate = TextEditingController();
  DateTime? selectedEmiDate;
  DateTime? selectedEmiDateHome;
  RxBool payEmi = false.obs;
  // final LoansController loansController = Get.put(LoansController());
  // String? paymentID;
  List paymentReceived = [];
  List emiLoans = [];
  String? payEmiLoanId;
  String? loan_Id;
  String? penaltyEmi;
  String? otherAmount_Emi;
  String? paymentEmiDate;
  String? kycID;
  String? emiLoansID;
  String? fullName;
  String? loanDateEmi;
  String? loanAmountEmi;
  String? oldPaidEmi;
  String? oldPendingdEmi;
  List loanTransactionHistory = [];
  String? hsLoanId;
  String? hsPaymentDate;
  String? hsEmiAmount;
  String? hsPenalty;
  String? hsOtherAmount;
  String? emiNewLoansID;
  bool? successAPi;
  String? success;
  String? payment_id;
  bool delete = false;




  Future<void> PaymentReceived(context, id) async {
    try {
      payEmi.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      loginController.loginUserId = prefs.getString("userId");

      if (loginController.loginUserId == null ||
          loginController.loginUserId!.isEmpty) {
        payEmi.value = false;
        return;
      }

      if (paymentDate.text.trim().isEmpty) {
        Get.snackbar("Error", "Please select a payment date");
        payEmi.value = false;
        return;
      }

      // Convert "dd-MM-yyyy" → API Format "yyyy-MM-dd"
      final DateTime parsedDate =
      DateFormat("dd-MM-yyyy").parse(paymentDate.text.trim());

      final String apiPaidDate =
      DateFormat("yyyy-MM-dd").format(parsedDate);

      Map<String, dynamic> emiPayment = {
        "user_id": loginController.loginUserId,
        "loan_id": id,
        "emi_amount": emiPreMonth.text.trim().isEmpty ? "0" : emiPreMonth.text.trim(),
        "penalty": penalty.text.trim().isEmpty ? "0" : penalty.text.trim(),
        "other_amount": other_amount.text.trim().isEmpty ? "0" : other_amount.text.trim(),
        "paid_date": apiPaidDate, // ✔ Correct string format
        "extend_duration": extendMonths.text.trim().isEmpty ? "-" : extendMonths.text.trim(),
        "deduction": detection.text.trim().isEmpty ? "0" : detection.text.trim(),
      };

      print("object $emiPayment");

      final response = await http.post(
        Uri.parse("${Utils().baseURL}add_payment_received"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(emiPayment),
      );

      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        success = responseData['success'].toString();
        payment_id = responseData['payment_id'].toString();

        Get.snackbar(
          "Emi Amount",
          "Emi Amount added",
          backgroundColor: Colors.green.shade100,
          colorText: Colors.black,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
          snackPosition: SnackPosition.TOP,
          icon: Icon(Icons.check_circle, color: Colors.green),
          duration: Duration(seconds: 3),
          isDismissible: true,
          forwardAnimationCurve: Curves.easeOutBack,
        );



        // Clear controllers
        // emiPreMonth.clear();
        // other_amount.clear();
        // penalty.clear();

      } else {
        payEmi.value = false;
        print(responseData['errorMsg'].toString());
      }
    } catch (e) {
      payEmi.value = false;
      print(e.toString());
    }
  }


  Future<void> updatePayment(context) async {
    try {
      payEmi.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      loginController.loginUserId = prefs.getString("userId");

      if (selectedUpdatePaidDate == null) {
        try {
          selectedUpdatePaidDate =
              DateFormat('dd-MM-yyyy').parseStrict(Paid_Date.text);
        } catch (e) {
          selectedUpdatePaidDate = DateTime.now();
        }
      }

      final updateDateTime =
      DateFormat('yyyy-MM-dd').format(selectedUpdatePaidDate!);

      Map<String, dynamic> updateReceived = {
        "user_id": loginController.loginUserId,
        "payment_id": payment_id.toString(),
        "emi_amount": emiAmount.text.trim(),
        "penalty": penalty.text.trim(),
        "other_amount": other_amount.text.trim(),
        "paid_date": updateDateTime,
      };

      final response = await http.post(
        Uri.parse("${Utils().baseURL}update_payment_received"),
        // headers: {"Content-Type": "application/json","Authorization" : ""},
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updateReceived),
      );

      var responseData = jsonDecode(response.body);
      print("Response Data : $responseData");
      print("MAP $updateReceived");

      if (response.statusCode == 200 && responseData["success"] == true) {
        Get.snackbar(
          "Emi Payment Update",
          "Emi updated successfully",
          backgroundColor: Colors.green.shade100,
          colorText: Colors.black,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
          snackPosition: SnackPosition.TOP,
          icon: Icon(Icons.check_circle, color: Colors.green),
          duration: Duration(seconds: 3),
        );

        await loansController.getLoans();
        Navigator.pop(context);
      } else {
        payEmi.value = false;
      }
    } catch (e) {
      payEmi.value = false;
      print("Error in updatePayment: $e");
    }
  }


  String formatToApiDate(String rawDate) {
    try {
      DateTime? d = DateTime.tryParse(rawDate);

      if (d == null) {
        try {
          d = DateFormat('dd-MM-yyyy').parseStrict(rawDate);
        } catch (_) {
          d = DateFormat('dd-MM-yyyy').parseStrict(rawDate);
        }
      }

      return DateFormat('yyyy-MM-dd').format(d);
    } catch (e) {
      return rawDate; // fallback if unable to parse
    }
  }

  Future<void> deleteTransaction(id,context)  async {
    try{
      delete = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      loginController.loginUserId = prefs.getString("userId");

      if (loginController.loginUserId == null || loginController.
      loginUserId!.isEmpty) {
        delete = false;
        return;
      }

      Map<String,dynamic> deletePayment = {
        "user_id" : loginController.loginUserId,
        "payment_id" :id,
      };

      print("delete data ${deletePayment.toString()}");

      final response = await http.post(
        Uri.parse("${Utils().baseURL}delete_payment_received"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(deletePayment),
      );

      var responseData = jsonDecode(response.body);

      if(response.statusCode == 200 && responseData["success"] == true) {
        print("delete data success ${deletePayment.toString()}");
        Get.snackbar(
          "Emi Payment Delete",
          "Emi deleted",
          backgroundColor: Colors.green.shade50,
          colorText: Colors.black,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
          snackPosition: SnackPosition.TOP,
          icon: Icon(Icons.check_circle, color: Colors.green),
          duration: Duration(seconds: 3),
          isDismissible: true,
          forwardAnimationCurve: Curves.easeOutBack,
        );
        Navigator.pop(context);
        Navigator.pop(context);

        delete = false;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loans(loans: {}),));
        // Get.back();
        // Get.back();
      }
      else{
        delete = false;
        print("error api ${responseData["errorMsg"].toString()}");
      }

    }
    catch(error){
      delete = false;

      print("error catch ${error}");
    }

  }


  Future<bool> emiPayment(int rowIndex) async {
    try {
      payEmi.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      loginController.loginUserId = prefs.getString("userId");

      if (loginController.loginUserId == null || loginController.loginUserId!.isEmpty) {
        // Get.snackbar("Error", "User ID missing.");
        payEmi.value = true;
        return false;
      }

      final m = rows[rowIndex];


      final body = {
        "user_id"     : loginController.loginUserId,
        "loan_id"     : m['emiLoanId']!.text.trim(),
        "emi_amount"  : m['emiPayEmiAmount']!.text.trim(),
        "penalty"     : m['emiPenalty']!     .text.trim().isEmpty ? '0' : m['emiPenalty']!     .text.trim(),
        "other_amount": m['emiOtherAmount']!.text.trim().isEmpty ? '0' : m['emiOtherAmount']!.text.trim(),
        "paid_date"   : formatToApiDate(m['emiPaidDate']!.text.trim()),
        "deduction":  m['deduction']!.text.trim().isEmpty ? '0' : m['deduction']!.text.trim(),

      };

      final res = await http.post(
        Uri.parse("${Utils().baseURL}add_payment_received"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200 && data['success'] == true) {
        return true;
      }
    } catch (_) {

    }

    return false;
  }


  Future<void> getPayment(i) async {
    paymentEmiDate = null;
    payEmiLoanId = null;
    penaltyEmi = null;
    otherAmount_Emi = null;
    kycID = null;
    fullName = null;
    loanDateEmi = null;
    loanAmountEmi = null;
    oldPaidEmi = null;
    oldPendingdEmi = null;
    try{
      payEmi.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      loginController.loginUserId = prefs.getString("userId");

      if (loginController.loginUserId == null || loginController.loginUserId!.isEmpty) {
        // Get.snackbar("Error", "User ID missing.");
        payEmi.value = true;
        return;
      }

      Map<String,dynamic> getPayment = {
        "user_id" : loginController.loginUserId,
        "loan_id" : rows[i]["emiLoanId"]!.text.trim()
      };

      final response = await http.post(
        Uri.parse("${Utils().baseURL}get_payment_received"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(getPayment),
      );

      var responseData = jsonDecode(response.body);

      if(response.statusCode == 200 && responseData["success"] == true) {
        paymentReceived = responseData['payments'];

        loan_Id = paymentReceived.first['loan_id'].toString();
        payEmiLoanId = paymentReceived.first['emi_amount'].toString();
        penaltyEmi = paymentReceived.first['penalty'].toString();
        otherAmount_Emi = paymentReceived.first['other_amount'].toString();
        paymentEmiDate = paymentReceived.first['paid_date'].toString();
        final raw      = paymentReceived.first['paid_date']?.toString() ?? '';
        DateTime? date;

        date = DateTime.tryParse(raw);

        date ??= DateFormat('yyyy-MM-dd').tryParse(raw);

        paymentEmiDate = date != null
            ? DateFormat('dd-MM-yyyy').format(date)
            : raw; // fallback to the original string
      }
      else{
        payEmi.value = false;
        // Get.snackbar("error Message", responseData["errorMsg"].toString());
      }
    }
    catch(e){
      payEmi.value = false;
      // Get.snackbar("Error Message", e.toString());
    }
  }

  Future<void> getPaymentLoan(i) async {
    kycID = null;
    fullName = null;
    loanDateEmi = null;
    loanAmountEmi = null;
    oldPaidEmi = null;
    oldPendingdEmi = null;
    try{
      payEmi.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      loginController.loginUserId = prefs.getString("userId");

      if (loginController.loginUserId == null || loginController.loginUserId!.isEmpty) {
        // Get.snackbar("Error", "User ID missing.");
        payEmi.value = true;
        return;
      }

      Map<String,dynamic> getPayment = {
        "user_id" : loginController.loginUserId,
        "loan_id" : rows[i]["emiLoanId"]!.text.trim()
      };

      final response = await http.post(
        Uri.parse("${Utils().baseURL}get_loans"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(getPayment),
      );

      var responseData = jsonDecode(response.body);

      if(response.statusCode == 200 && responseData["success"] == true) {
        emiLoans = responseData['loans'];
        emiLoansID = emiLoans.first['loan_id'].toString();
        kycID = emiLoans.first['kyc_id'].toString();
        fullName = emiLoans.first['name'].toString();
        loanDateEmi = emiLoans.first['loan_date'].toString();
        loanAmountEmi = emiLoans.first['principal_amount'].toString();
        oldPaidEmi = emiLoans.first['partial_emi_pending_payment'].toString();
        oldPendingdEmi = emiLoans.first['emi_pending'].toString();

      }
      else{
        payEmi.value = false;
        // Get.snackbar("error Message", responseData["errorMsg"].toString());
      }
    }
    catch(e){
      payEmi.value = false;
      // Get.snackbar("Error Message", e.toString());

    }
  }

  Future<void> emiPaymentHistory(id) async {
    hsPaymentDate = null;
    hsEmiAmount = null;
    hsOtherAmount = null;
    hsPenalty = null;
    try{
      payEmi.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      loginController.loginUserId = prefs.getString("userId");

      if (loginController.loginUserId == null || loginController.loginUserId!.isEmpty) {
        // Get.snackbar("Error", "User ID missing.");
        payEmi.value = true;
        return;
      }

      Map<String,dynamic> getPayment = {
        "user_id" : loginController.loginUserId,
        "loan_id" : id,
      };

      final response = await http.post(
        Uri.parse("${Utils().baseURL}get_payment_received"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(getPayment),
      );

      var responseData = jsonDecode(response.body);

      if(response.statusCode == 200 && responseData["success"] == true) {
        loanTransactionHistory = responseData['payments'];
        hsLoanId = loanTransactionHistory.first['loan_id'].toString();
        hsPaymentDate = loanTransactionHistory.first['paid_date'].toString();
        hsEmiAmount = loanTransactionHistory.first['emi_amount'].toString();
        hsOtherAmount = loanTransactionHistory.first['other_amount'].toString();
        hsPenalty = loanTransactionHistory.first['penalty'].toString();
      }
      else{
        payEmi.value = false;
        // Get.snackbar("error Message", responseData["errorMsg"].toString());
      }
    }
    catch(e){
      payEmi.value = false;
      // Get.snackbar("Error Message", e.toString());
    }
  }

  // helper to create a fresh empty row
  Map<String, TextEditingController> createEmptyRow() {
    return {
      'emiLoanId': TextEditingController(),
      'emiKycId': TextEditingController(),
      'emiName': TextEditingController(),
      'emiLoanDate': TextEditingController(),
      'emiLoanAmount': TextEditingController(),
      'emiOldPaidEmi': TextEditingController(),
      'emiOldPendingEmi': TextEditingController(),
      'emiPayEmiAmount': TextEditingController(),
      'emiPenalty': TextEditingController(),
      'emiOtherAmount': TextEditingController(),
      'emiPaidDate': TextEditingController(),
    };
  }

  // reset rows + search
  void resetAllRows() {
    payEmiSearch.clear();
    rows.clear();
    rows.add(createEmptyRow()); // ✅ always keep 1 fresh row
  }
}