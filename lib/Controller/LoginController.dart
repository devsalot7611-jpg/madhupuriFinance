import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:madhupurifinance/Controller/FormController.dart';
import 'package:madhupurifinance/Controller/HomeLoanController.dart';
import 'package:madhupurifinance/Controller/KycListController.dart';
import 'package:madhupurifinance/Controller/PayEmiController.dart';
import 'package:madhupurifinance/Controller/loansController.dart';
import 'package:madhupurifinance/HomeSacreen.dart';
import 'package:madhupurifinance/Login.dart';
import 'package:madhupurifinance/Utils.dart';
import 'package:madhupurifinance/kycList.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../emailOTP.dart';
import '../resetPassword.dart';


class LoginController extends GetxController {

  // final FormController formController = Get.put(FormController());
  // final KycListController kycListController = Get.put(KycListController());
  // final LoansController loansController = Get.put(LoansController());
  // final PayEmiController payEmiController = Get.put(PayEmiController());
  // final HomeLoanController homeLoanController = Get.put(HomeLoanController());

  final GlobalKey repaintBoundaryKey = GlobalKey();
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController OTPController = TextEditingController();
  TextEditingController newPasssword = TextEditingController();
  TextEditingController confPasssword = TextEditingController();


  var loginTable;
  var user;
  String?loginUserId;

  RxBool verifyEmailLoader = false.obs;
  RxBool loading = false.obs;
  static const isLoggedIn = "isLoggedIn";
  static const username = "username";
  static const userId = "userId";
  static const token = "token";
  

  Future<void> resetPassword(context) async {
    loading.value = true;
    try {

      Map<String , dynamic> otp = {
        'email' : emailController.text.trim(),
        'otp' : OTPController.text.trim(),
        'new_password' : newPasssword.text.trim(),
      };


      final response = await http.post(
        Uri.parse("${Utils().baseURL}${Utils().changePassword}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(otp),
      );

      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true){
        Get.snackbar("$emailController", "check your email");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
      }
      else {
        loading.value = false;
        log("fjsdkfkfdskdfhkjsdf${responseData["error"]}");
      }
    }
    catch(e){
      loading.value = false;
      log("Error: ${e.toString()}");
    }
  }
  Future<void> email(context) async {
    loading.value = true;
    try {

      Map<String , dynamic> forgetEmail = {
        'email' : emailController.text.trim(),
      };

      final response = await http.post(
        Uri.parse("${Utils().baseURL}${Utils().sendForget}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(forgetEmail),
      );

      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true){
        Get.snackbar("${emailController.text.toString()}", "check your email");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EmailOtp()),
        );
      }
      else {
        loading.value = false;
        log("fjsdkfkfdskdfhkjsdf${responseData["error"]}");
      }
    }
    catch(e){
      loading.value = false;
      log("Error: ${e.toString()}");
    }
  }

  Future<void> loginApi(context) async {
    loading.value = true;
    try {

      Map<String, dynamic> loginData = {
        "username": userName.text.trim(),
        "password": password.text.trim(),
      };


      final response = await http.post(
        Uri.parse("${Utils().baseURL}${Utils().loginURL}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(loginData),
      );

      var responseData = jsonDecode(response.body);
      user = responseData['user_details'];


      if (response.statusCode == 200 && responseData['success'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool("isLoggedIn", true);
        await prefs.setString("username", user['username'].toString());
        await prefs.setString("userId", user['id'].toString());
        loginUserId = user['id'].toString();
        print("adbflkj");
        print(loginUserId);
        await prefs.setString("userId", loginUserId!);
        await prefs.setString("email", user['email'].toString());
        await prefs.setString("name", user['name'].toString());
        await prefs.setString("role", user['role'].toString());
        await prefs.setString("role_type", user['role_type'].toString());
        Get.snackbar(
          "Success",
          "Login successfully",
          backgroundColor: Colors.green.shade100,
          colorText: Colors.black,
          borderRadius: 10,
          margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          snackPosition: SnackPosition.TOP,
          snackStyle: SnackStyle.FLOATING,
          icon: const Icon(Icons.check_circle, color: Colors.green),
          duration: const Duration(seconds: 3),
          isDismissible: true,
          forwardAnimationCurve: Curves.easeOutBack,
        );

        // Get.replace(Homesacreen());
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Kyclist(data: {},),));
      } else {
        print("error");
        print(responseData["errorMsg"].toString());
        loading.value = false;
      }
    } catch (e) {
      loading.value = false;
      log("Error: ${e.toString()}");
    }
  }



  void logout(context) async {
    loading.value = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all saved data
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
  }


}

// class PrefKeys {
//   static const isLoggedIn = "isLoggedIn";
//   static const username = "username";
//   static const userId = "userId";
//   static const token = "token";
// }