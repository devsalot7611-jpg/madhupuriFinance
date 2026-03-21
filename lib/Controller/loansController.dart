import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:madhupurifinance/Controller/FormController.dart';
import 'package:madhupurifinance/Controller/LoginController.dart';
import 'package:madhupurifinance/Controller/PayEmiController.dart';
import 'package:madhupurifinance/HomeLoans.dart';
import 'package:madhupurifinance/Utils.dart';
import 'package:madhupurifinance/kycList.dart';
import 'package:madhupurifinance/loans.dart';
import 'package:madhupurifinance/payEmi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoansController extends GetxController {

  String? mobileLoanID;
  final FormController formController = Get.put(FormController());
  final LoginController loginController = Get.put(LoginController());
  final GlobalKey<FormState> loansKey = GlobalKey<FormState>();
  TextEditingController loansId = TextEditingController();
  TextEditingController loanName = TextEditingController();
  TextEditingController totalAmount = TextEditingController();
  TextEditingController durationEmi = TextEditingController();
  TextEditingController monthEmi = TextEditingController();
  TextEditingController downPayment = TextEditingController();
  TextEditingController loansSearch = TextEditingController();
  TextEditingController loansDate = TextEditingController();

  TextEditingController serviceFees = TextEditingController();
  TextEditingController interest  = TextEditingController();
  double emiResult = 0.0;

 late DateTime selectedLoanDate = DateTime.now();
  RxBool loan = false.obs;
  RxBool addLoans = false.obs;
  RxBool updateLoan = false.obs;
  List loansData = [];
  List loans = [];
  RxString errorMsg = "".obs;
  RxString idLoans = "".obs;
  String editKycStoreId = '';
  RxBool pendingEmi = true.obs;
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
  bool isChecked = false;
  bool closeLoan = false;
  bool extend = false;
  double totalPayAmount = 0.0;
  bool balance = false;
  List balanceData = [];



  double getUserTotalEmi(Map<String, dynamic> loan) {
    final emi = double.tryParse(loan['emi_amount'].toString()) ?? 0.0;
    final tenure = int.tryParse(loan['tenure'].toString()) ?? 0;
    return emi * tenure;
  }

  Map<String, int> calculateEmiStatus({
    required int duration,
    required double emiAmount,
    required DateTime loanDate,
    required List<Map<String, dynamic>> payments,
  }) {
    int paid = 0, due = 0, partial = 0;

    for (int i = 1; i <= duration; i++) {
      DateTime dueDate = DateTime(loanDate.year, loanDate.month + i, loanDate.day);

      // Total paid for this month
      double paidThisMonth = payments
          .where((p) {
        DateTime payDate = DateTime.parse(p['payment_date']);
        return payDate.month == dueDate.month && payDate.year == dueDate.year;
      })
          .fold(0.0, (sum, p) => sum + double.parse(p['emi_amount'].toString()));

      if (paidThisMonth >= emiAmount) {
        paid++;
      } else if (paidThisMonth > 0 && paidThisMonth < emiAmount) {
        partial++;
      } else if (DateTime.now().isAfter(dueDate)) {
        due++;
      }
    }

    return {"Paid": paid, "Partial": partial, "Due": due};
  }


  Future<void> CreateLoan(context) async {
    try{
      loan.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      loginController.loginUserId = prefs.getString("userId");

      if (loginController.loginUserId == null || loginController.loginUserId!.isEmpty) {
        // Get.snackbar("Error", "User ID missing.");
        loan.value = false;
        return;
      }

      final String apiDate = DateFormat('yyyy-MM-dd').format(selectedLoanDate);

      Map<String,dynamic> loanMap = {
        "user_id" : loginController.loginUserId,
        "kyc_id" : loansId.text.trim(),
        "principal_amount" : totalAmount.text.trim(),
        "tenure" : durationEmi.text.trim(),
        "emi_amount" : emiResult.toString(),
        "down_payment" : downPayment.text.trim(),
        "interest_per" : interest.text.trim(),
        "service_charge" : serviceFees.text.trim(),
        "loan_type" : selectValue.toString(),
        "loan_date" : apiDate,
      };


      print("loanMap ${loanMap.toString()}");
      final response = await http.post(
        Uri.parse("${Utils().baseURL}create_loan"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(loanMap),
      );
      var responseData = jsonDecode(response.body);

      if(response.statusCode == 200 && responseData['success'] == true) {
        print("loanMap");
        print(loanMap.toString());
        Get.snackbar(
          "Loan Added",
          "Loan successfully added",
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
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loans(loans: {}),));
      }
      else {
        loan.value = false;
        print("error else");
        print(responseData['errorMsg'].toString());
        // Get.snackbar("loan Error", responseData['errorMsg'].toString());
      }

    }
    catch(e) {
      loan.value = false;
      print("catch");
      print(e.toString());
      // Get.snackbar("loan Error", e.toString());
    }
  }

  Future<void> balanceSheet(loansId) async{
    try {

      balance = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      loginController.loginUserId = prefs.getString("userId");

      if (loginController.loginUserId == null || loginController.loginUserId!.isEmpty) {
        // Get.snackbar("Error", "User ID missing.");
        loan.value = false;
        return;
      }

      Map<String,dynamic> balanceMap = {
        "user_id" : loginController.loginUserId,
        "loan_id" : loansId,
      };


      final response = await http.post(
        Uri.parse("${Utils().baseURL}get_loan_statement"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(balanceMap),
      );

      var responseData = jsonDecode(response.body);


      if(response.statusCode == 200 && responseData['success'] == true) {
        errorMessageLoan.value = responseData['errorMsg'].toString();
       balanceData = responseData["statement"];
      }
      else {
        balance = false;
        errorMsg.value = "${responseData["errorMsg"].toString()}";
      }

    }
    catch(error){
      balance = false;
    }
  }

  Future<void> getLoans() async {

    try{
      loan.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      loginController.loginUserId = prefs.getString("userId");

      if (loginController.loginUserId == null || loginController.loginUserId!.isEmpty) {
        // Get.snackbar("Error", "User ID missing.");
        loan.value = true;
        return;
      }

      Map<String,dynamic> loansMap = {
        "user_id" : loginController.loginUserId,
      };


      final response = await http.post(
        Uri.parse("${Utils().baseURL}get_loans"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(loansMap),
      );

      var responseData = jsonDecode(response.body);


      if(response.statusCode == 200 && responseData['success'] == true) {
        errorMessageLoan.value = responseData['errorMsg'].toString();
        loansData = responseData["loans"];
        loans = responseData["loans"];
        pdfLoanID = loansData.first['id'].toString();
      }
      else {
        loan.value = false;
        errorMsg.value = "${responseData["errorMsg"].toString()}";
        // Get.snackbar("Error", "${errorMsg.toString()}");

      }
    }
    catch(e) {
      loan.value = false;
      // Get.snackbar("error", e.toString());
    }
  }

  Future<void> UpdateLoan(context, id) async {
    try {
      updateLoan.value = true;

      // ---------------- GET USER ID ----------------
      SharedPreferences prefs = await SharedPreferences.getInstance();
      loginController.loginUserId = prefs.getString("userId");

      if (loginController.loginUserId == null ||
          loginController.loginUserId!.isEmpty) {
        updateLoan.value = false;
        return;
      }

      if (loansDate.text.trim().isEmpty) {
        Get.snackbar("Error", "Please select a valid loan date");
        updateLoan.value = false;
        return;
      }

      // Convert "dd-MM-yyyy" from TextField → API format "yyyy-MM-dd"
      final DateTime parsedDate =
      DateFormat("dd-MM-yyyy").parse(loansDate.text.trim());

      final String apiDate = DateFormat("yyyy-MM-dd").format(parsedDate);

      // ---------------- CREATE PAYLOAD ----------------
      Map<String, dynamic> updateMap = {
        "user_id": loginController.loginUserId,
        "loan_id": id,
        "principal_amount": totalAmount.text.trim(),
        "tenure": durationEmi.text.trim(),
        "emi_amount": emiResult.toString(),
        "down_payment": downPayment.text.trim(),
        "loan_type": selectValue.toString(),
        "interest_per": interest.text.trim(),
        "loan_date": apiDate, // Correct formatted date
      };

      print("-----------------------------------------");
      print(updateMap);

      // ---------------- SEND API REQUEST ----------------
      final response = await http.post(
        Uri.parse("${Utils().baseURL}update_loan"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updateMap),
      );

      var responseData = jsonDecode(response.body);

      // ---------------- RESPONSE HANDLING ----------------
      if (response.statusCode == 200 && responseData['success'] == true) {
        Get.snackbar(
          "Loan Update",
          "Successfully Updated Loan",
          backgroundColor: Colors.green.shade100,
          colorText: Colors.black,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
          snackPosition: SnackPosition.TOP,
          icon: Icon(Icons.check_circle, color: Colors.green),
          duration: Duration(seconds: 3),
        );

        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Loans(loans: {})),
        );
      } else {
        updateLoan.value = false;
        errorMsg.value = responseData["errorMsg"].toString();
        Get.snackbar("Error", errorMsg.value);
      }
    } catch (e) {
      updateLoan.value = false;
      Get.snackbar("Error", e.toString());
    } finally {
      updateLoan.value = false;
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
  // final FormController formController = Get.put(FormController());
  List runFilterLoanName(String enterKeyword) {
    if (enterKeyword.isEmpty) {
      formController.data = List.from(formController.dataTwo);
    } else {
      formController.data = formController.dataTwo.where((item) {
        String id = item['id']?.toString() ?? "";
        String firstName = item['first_name']?.toString() ?? "";
        String middleName = item['middle_name']?.toString() ?? "";
        String lastName = item['last_name']?.toString() ?? "";

        return id.toLowerCase().contains(enterKeyword.toLowerCase()) ||
            firstName.toLowerCase().contains(enterKeyword.toLowerCase()) ||
            middleName.toLowerCase().contains(enterKeyword.toLowerCase()) ||
            lastName.toLowerCase().contains(enterKeyword.toLowerCase());
      }).toList();
    }
    return loansData;
  }
}


