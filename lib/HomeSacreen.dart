import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:madhupurifinance/Controller/FormController.dart';
import 'package:madhupurifinance/Controller/HomeLoanController.dart';
import 'package:madhupurifinance/Controller/KycListController.dart';
import 'package:madhupurifinance/Controller/LoginController.dart';
import 'package:madhupurifinance/Controller/PayEmiController.dart';
import 'package:madhupurifinance/Controller/ReportController.dart';
import 'package:madhupurifinance/Controller/loansController.dart';
import 'package:madhupurifinance/Utils.dart';
import 'package:madhupurifinance/kycList.dart';
import 'package:get/get.dart';
import 'package:madhupurifinance/loans.dart';
import 'package:madhupurifinance/payEmi.dart';
import 'package:madhupurifinance/report.dart';
import 'package:madhupurifinance/report_CompletedEmi.dart';
import 'package:madhupurifinance/report_CustomerDue.dart';
import 'package:madhupurifinance/report_PenaltyReport.dart';
import 'package:madhupurifinance/report_UpcomingEmi.dart';
import 'package:madhupurifinance/report_balanceSheet.dart';
import 'package:madhupurifinance/tempPayEmi.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeLoans.dart';

class Homesacreen extends StatefulWidget {
  const Homesacreen({super.key});

  @override
  State<Homesacreen> createState() => _HomesacreenState();
}

class _HomesacreenState extends State<Homesacreen> {

  final KycListController kycListController = Get.put(KycListController());


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getKycCode();
  }

  getKycCode()async {
    await kycListController.kycID();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils().background,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appBar(),
            Padding(
              padding: const EdgeInsets.only(left: 50,top: 40),
              child: GestureDetector(
                onTap: () async{
                  // await formController.showKycDetails();

                  Navigator.push(context, MaterialPageRoute(builder: (context) => Kyclist(data: {},),));
                },
                child: Container(
                  padding: EdgeInsets.all(3),
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Utils().border_1, Utils().border_2],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // your actual background color
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'KYC (${kycListController.kycNo})',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Utils().container_text,

                          ),
                        ),
                        Icon(Icons.person_add_alt_sharp,size: 80,color: Utils().container_text,)
                      ],
                    ),
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
class appBar extends StatefulWidget {
  @override
  State<appBar> createState() => _appBarState();
}

class _appBarState extends State<appBar> {

  final LoansController loansController = Get.put(LoansController());
  final HomeLoanController homeLoanController = Get.put(HomeLoanController());
  final FormController formController = Get.put(FormController());
  final PayEmiController payEmiController = Get.put(PayEmiController());
  final ReportController reportController = Get.put(ReportController());
  String? userName = "";
  String selectedReport = "Report";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserName();
  }

  void loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("name") ?? "Guest";
    });
  }
  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    // TODO: implement build
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: isBigScreen() ? 545: 330,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Image.asset("assets/images/mflogo.png",height: 40,width: 40,fit: BoxFit.fill,),
                  ),
                  Row(
                    children: [
                      buildTabButton(
                        index: Utils.HOME,
                        icon: Icon(Icons.home_outlined),
                        label: "Home",
                        onTap: () {
                          Utils.activeIndex = Utils.HOME;
                          homeLoanController.homeSearch.clear();
                          Get.to(HomeLoans(), transition: Transition.noTransition);
                        },
                      ),
                      buildTabButton(
                        index: Utils.KYC,
                        icon: Image.asset("assets/images/verify.png", height: isBigScreen() ? 18 : 12),
                        label: "KYC",
                        onTap: () {
                          Utils.activeIndex = Utils.KYC;
                          formController.searchController.clear();
                          Get.to(Kyclist(data: {}), transition: Transition.noTransition);
                        },
                      ),
                      buildTabButton(
                        index: Utils.LOANS,
                        icon: Image.asset("assets/images/loan.png", height: isBigScreen() ? 18 : 12),
                        label: "Loans",
                        onTap: () {
                          Utils.activeIndex = Utils.LOANS;
                          loansController.loansSearch.clear();
                          Get.to(Loans(loans: {},), transition: Transition.noTransition);
                        },
                      ),
                      buildTabButton(
                        index: Utils.PAY_EMI,
                        icon: Image.asset("assets/images/emi.png", height: isBigScreen() ? 18 : 12),
                        label: "PayEmi",
                        onTap: () {
                          Utils.activeIndex = Utils.PAY_EMI;
                          payEmiController.resetAllRows();
                          // Get.to(TempPayEmi());
                          Get.to(PayEmi(), transition: Transition.noTransition);
                        },
                      ),
                     buildTabButton(
                        index: Utils.REPORT,
                        icon: Image.asset("assets/images/report.png", height: isBigScreen() ? 18 : 12),
                        label: reportController.selectedReport.value, // reactive label
                        onTap: () async {
                          final String? result = await showMenu<String>(
                            context: Get.context!,
                            position: const RelativeRect.fromLTRB(450, 50, 450, 450),
                            items: reportController.dropDown.asMap().entries.map((entry) {
                              final idx = entry.key;
                              final value = entry.value;
                              return PopupMenuItem<String>(
                                padding: EdgeInsets.zero,
                                value: value,
                                child: Column(
                                  children: [
                                    Center(child: Text(value, style: TextStyle(color: Utils().text))),
                                    if (idx != reportController.dropDown.length - 1)
                                      Divider(color: Utils().border_1, thickness: 1),
                                  ],
                                ),
                              );
                            }).toList(),
                            color: Utils().background,
                          );

                          if (result != null) {
                            switch (result) {
                              case "Transaction Report":
                                Utils.activeIndex = Utils.REPORT;
                                reportController.emiPaymentHistory();
                                Get.to(Report(), transition: Transition.noTransition);
                                break;

                              case "Customer Due":
                                Utils.activeIndex = Utils.REPORT;
                                loansController.getLoans();
                                Get.to(CustomerDue(), transition: Transition.noTransition);
                                break;

                              // case "Upcoming Emi" :
                              //   Utils.activeIndex = Utils.REPORT;
                              //   Get.to(UpcomingEmi(), transition: Transition.noTransition);
                              //   break;

                              // case "Completed Emi" :
                              //   Utils.activeIndex = Utils.REPORT;
                              //   Get.to(CompletedEmi(), transition: Transition.noTransition);
                              //   break;

                              case "Penalty Report" :
                                Utils.activeIndex = Utils.REPORT;
                                Get.to(PenaltyReport(), transition: Transition.noTransition);
                                break;

                              // case "Balance Sheet" :
                              //   Utils.activeIndex = Utils.REPORT;
                              //   Get.to(BalanceSheet(), transition: Transition.noTransition);
                              //   break;

                            }
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                Text(userName ?? "",style: TextStyle(
                    fontSize: isBigScreen() ? 16 : 10,
                    color: Utils().text,
                  ),),
                  SizedBox(width: isBigScreen() ? 14 : 5,),
                  GestureDetector(
                    onTap: ()  {
                      loginController.userName.clear();
                      loginController.password.clear();
                      loginController.logout(context);
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [
                            Utils().border_1,
                            Utils().button,
                          ])
                      ),
                      child: Icon(Icons.logout,color: Colors.white,size: isBigScreen() ? 15 : 15,),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Container(height: 10,color: Color(0xffF0F1F2),),
      ],
    );
  }
  bool isBigScreen(){
    return (MediaQuery.of(context).size.width > 700);
  }
  Widget buildTabButton({
    required int index,
    required Widget icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final bool isActive = Utils.activeIndex == index;
    final color = isActive ? Utils().border_1 : Utils().border_2;

    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 35,
        // width: isBigScreen() ? 100 : 60,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Color(0xFFE9E9E9),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1, color: color),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon is Icon
                    ? Icon(
                  (icon as Icon).icon,
                  size: isBigScreen() ? 18 : 12,
                  color: color,
                )
                    : ColorFiltered(
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  child: icon,
                ),
                SizedBox(width: isBigScreen() ? 5 : 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isBigScreen() ? 14 : 12,
                    fontWeight: FontWeight.w400,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


