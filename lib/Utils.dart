import 'dart:convert';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {

  static  bool home = false;
  static bool kyc = false;
  static bool loans = false;
  static bool payEmi = false;

  static const int HOME = 0;
  static const int KYC = 1;
  static const int LOANS = 2;
  static const int PAY_EMI = 3;
  static const int REPORT = 4;

  static int activeIndex = HOME;

  final Color border_1 = Color(0xff4D6BF1);
  final Color border_2 = Color(0xff222744);
  final Color text = Color(0xff222744);
  final Color container = Color(0xffF8F8F8);
  final Color container_text = Color(0xff4D6BF1);
  final Color searchBar = Color(0xffFFFFFF);
  final Color background = Color(0xffFFFFFF);
  final Color addKyc = Color(0xffF2F4F8);
  final Color picture = Color(0xffE9E9E9);
  final Color hintText = Color(0xffA6A6A6);
  final Color button = Color(0xff8998EE);
  final Color pdfColor = Color(0xff332A60);
  final Color pdfBox = Color(0xffE9E9E9);
  // final Color pdfBox = Color(0xffE9E9E980);

  final baseURL = "https://www.madhupurifinance.com/v2/0ZRpmA5ZMBieG2cUEv27fSEcuACf0P.php?m=";
  // final baseURL = "https://www.madhupurifinance.com/v2/0ZRpmA5ZMBieG2cUEv27fSEcuACf0P-Test.php?m=";
  final loginURL = "login";
  final pinCodeDetails = "get_pincode_details";
  final kycCode = "initiate_kyc";
  final kycDetails = "insert_kyc_details";
  final getDocumentType = "get_document_type";
  final updateKycDetails = "update_kyc_details";
  final getKycDetails = "get_kyc_details";
  final sendForget = "send_forget_password_otp";
  final changePassword = "change_password";
  final formNumber = "get_dd_no";
  final createLoan = "create_loan";


}

