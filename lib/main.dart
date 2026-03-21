import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madhupurifinance/Controller/LoginController.dart';
import 'package:madhupurifinance/DownloadForm.dart';
import 'package:madhupurifinance/HomeLoans.dart';
import 'package:madhupurifinance/kycList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:madhupurifinance/Login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
  print("dfata ${isLoggedIn}");
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final LoginController loginController = Get.put(LoginController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Madhupuri Finance",
      debugShowCheckedModeBanner: false,
      // home: widget.isLoggedIn ? Kyclist(data: {},) : Login(),
      home: widget.isLoggedIn ? HomeLoans() : Login(),
      // home: DownloadForm(),
    );
  }
}

