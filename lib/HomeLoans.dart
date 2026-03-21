import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:madhupurifinance/Controller/FormController.dart';
import 'package:madhupurifinance/Controller/HomeLoanController.dart';
import 'package:madhupurifinance/Controller/KycListController.dart';
import 'package:madhupurifinance/Controller/PayEmiController.dart';
import 'package:madhupurifinance/Controller/loansController.dart';
import 'package:madhupurifinance/HomeSacreen.dart';
import 'package:madhupurifinance/Utils.dart';
import 'package:madhupurifinance/MobilPayEmi.dart';

import 'homeLoansPdf.dart';
import 'loansPdf.dart';

class HomeLoans extends StatefulWidget {
  const HomeLoans({super.key});

  @override
  State<HomeLoans> createState() => _HomeLoansState();
}

class _HomeLoansState extends State<HomeLoans> {

  final HomeLoanController homeLoanController = Get.put(HomeLoanController());
  final PayEmiController payEmiController = Get.put(PayEmiController());
  final LoansController loansController = Get.put(LoansController());
  final FormController formController = Get.put(FormController());
  final KycListController kycListController = Get.put(KycListController());
  final double width = 10;
  final ScrollController horizontalScroll = ScrollController();
  bool loanPdf = false;
  bool loanPdfEmpty = false;
  var selectIndex;
  var payIndex;
  var pdfIndex;
  DateTime addMonthSafe(DateTime date) {
    int year = date.year;
    int month = date.month + 1;

    if (month > 12) {
      month = 1;
      year += 1;
    }

    int day = date.day;
    int lastDayOfMonth = DateTime(year, month + 1, 0).day;
    if (day > lastDayOfMonth) day = lastDayOfMonth;

    return DateTime(year, month, day);
  }
  List<List<String>> emiScheduleRows = [];

  int getEmiScheduleRows() {
    emiScheduleRows.clear();

    // ✅ Safely parse start & end dates
    final startDateStr = loansController.emiStartDate?.toString() ?? "";
    final endDateStr = loansController.emiEndDate?.toString() ?? "";

    if (startDateStr.isEmpty || endDateStr.isEmpty) {
      print("⚠️ EMI Start or End date is missing!");
      return 0;
    }

    DateTime? start = DateTime.tryParse(startDateStr);
    DateTime? end = DateTime.tryParse(endDateStr);

    if (start == null || end == null) {
      print("⚠️ Invalid EMI start or end date format!");
      return 0;
    }

    // ✅ Parse duration and EMI amount safely
    final int duration = int.tryParse(loansController.duration.toString()) ?? 0;
    final emiAmt = double.tryParse(loansController.emiAmount.toString()) ?? 0.0;

    if (duration <= 0) {
      print("⚠️ Duration is invalid (<= 0)");
      return 0;
    }

    // ✅ Start from next month safely
    DateTime currentDate = addMonthSafe(start);

    // ✅ Generate EMI schedule rows
    for (int i = 0;
    i < duration && (currentDate.isBefore(end) || currentDate.isAtSameMomentAs(end));
    i++) {
      final date = DateFormat('dd/MM/yyyy').format(currentDate);

      emiScheduleRows.add([
        date,                        // EMI date
        emiAmt.toStringAsFixed(2),   // EMI amount
        '',                          // Empty column for payment status or ID
        '',                          // Empty column for remarks or transaction reference
      ]);

      currentDate = addMonthSafe(currentDate);
    }

    print("✅ EMI Schedule generated with ${emiScheduleRows.length} rows.");
    return emiScheduleRows.length;
  }


  void initMethodCalling() async{
    setState(() {
      homeLoanController.loansData.clear();
      homeLoanController.loans.clear();
    });
    await homeLoanController.getPendingEmi();
    setState(() {
      Utils.home = true;
    });
  }
  void dateToady() {
    _dateCtrl = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(DateTime.now()),
    );

  }
  late final TextEditingController _dateCtrl;

  @override
  void initState() {
    super.initState();
    Utils.activeIndex = Utils.HOME;
    initMethodCalling();
    dateToady();// choose any pattern
  }
  @override
  void dispose() {
    _dateCtrl.dispose();
    super.dispose();
  }
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: payEmiController.devSelectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      payEmiController.devSelectedDate = picked;
      _dateCtrl.text =
          DateFormat('dd-MM-yyyy').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils().background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 70,
            child: appBar(),
          ),
          Row(
            children: [
              SizedBox(width: 20,),
              Text("Pending EMIs",style: TextStyle(
                fontSize: isBigScreen() ? 22 : 14,
                fontWeight: FontWeight.bold,
                color: Utils().text,
              ),),
              SizedBox(width: MediaQuery.of(context).size.width*0.06,),
              Expanded(
                child: SizedBox(
                  height: isBigScreen() ? 35 : 30,
                  // width: MediaQuery.of(context).size.width * 0.300,
                  child: TextField(
                    controller: homeLoanController.homeSearch,
                    onChanged: (value) {
                      setState(() {
                        homeLoanController.runFilter(value);
                      });
                    },
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      // color: Utils().textColor,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(4),
                      hintText: "Search...",
                      hintStyle: TextStyle(
                        // color: Utils().searchbar_Text,
                        fontSize: isBigScreen() ? 16 : 12,
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                      fillColor: Utils().searchBar,
                      filled: true,
                    ),
                  )
                  ,),
              ),
              SizedBox(width: MediaQuery.of(context).size.width*0.06,),
              Obx(() {
                final isExporting = homeLoanController.isExportingPdf.value;

                return GestureDetector(
                  onTap: () async {
                    if (!isExporting) {
                      await homeLoanController.exportToPdf(homeLoanController.loansData);
                    }
                  },
                  child: isExporting
                      ? const SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.red, // optional color match
                    ),
                  )
                      : SizedBox(
                      height: 50,
                      width: 50,
                      child: SvgPicture.asset("assets/images/pdf.svg")),
                );
              }),
              SizedBox(width: 20),
              // Obx(() {
              //   return GestureDetector(
              //     onTap: () async {
              //       if (!homeLoanController.isExportingExcel.value) {
              //         await homeLoanController.excelCustomerDue(homeLoanController.loansData);
              //       }
              //     },
              //     child: homeLoanController.isExportingExcel.value
              //         ? SizedBox(
              //       height: 40,
              //       width: 40,
              //       child: CircularProgressIndicator(strokeWidth: 2),
              //     )
              //         : SizedBox(
              //         height: 50,
              //         width: 50,
              //         child: SvgPicture.asset("assets/images/excel.svg")),
              //   );
              // }),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Obx(() {
            if (homeLoanController.loans.isEmpty) {
              return homeLoanController.errorMsgHome.value.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Center(child: Text(homeLoanController.errorMsgHome.value,style: TextStyle(color: Colors.red),));
            }
            if (homeLoanController.loansData.isEmpty) {
              return const Center(
                child: Text(
                  "NO Pending EMIs Data",
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

            if (homeLoanController.loansData.isEmpty) {
              return const Center(
                child: Text("No Pending EMIs found similar to your search."),
              );
            }

            return Expanded(child:
            LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SizedBox(
                    width: Get.width,
                    height: Get.height,
                    child: AdaptiveScrollbar(
                      underSpacing: EdgeInsets.only(bottom: width),
                      controller: horizontalScroll,
                      width: width,
                      position: ScrollbarPosition.bottom,
                      sliderDecoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      sliderActiveDecoration: BoxDecoration(
                        color: Color.fromRGBO(206, 206, 206, 1),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      underColor: Colors.transparent,
                      child: SingleChildScrollView(
                        controller: horizontalScroll,
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: constraints.maxWidth), // or MediaQuery.of(context).size.width
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Utils().border_1,
                                      Utils().button,
                                    ],
                                  ),
                                ),
                                child: DataTable(
                                  dataRowMinHeight: 27,
                                  dataRowMaxHeight: 27,
                                  showCheckboxColumn: false,
                                  // headingRowColor: MaterialStateProperty.all(Utils().button),
                                  columnSpacing: 5,
                                  columns: [
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0280:20,child: Center(child: Text('Sr\nNo.',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0390:55,child: Center(child: Text('Loan\nID',style: TextStyle(color: Colors.white),textAlign: TextAlign.center)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0350:55,child: Center(child: Text('KYC\nID',style: TextStyle(color: Colors.white),textAlign: TextAlign.center)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.150:150,child: Center(child: Text('Name',style: TextStyle(color: Colors.white),textAlign: TextAlign.center)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0700:90,child: Center(child: Text('Mobile No.',style: TextStyle(color: Colors.white),textAlign: TextAlign.center)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0690:90,child: Center(child: Text('Loan AMT',style: TextStyle(color: Colors.white),textAlign: TextAlign.center)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.073:90,child: Center(child: Text('Down AMT',style: TextStyle(color: Colors.white),textAlign: TextAlign.center)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0440:60,child: Center(child: Text('Duration\nMonth',style: TextStyle(color: Colors.white),textAlign: TextAlign.center)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.070:80,child: Center(child: Text('Emi AMT',style: TextStyle(color: Colors.white),textAlign: TextAlign.center)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.060:80,child: Center(child: Text('Loan\nType',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0640:80,child: Center(child: Text('Emi pending',style: TextStyle(color: Colors.white),textAlign: TextAlign.center)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0675:85,child: Center(child: Text('Paid AMT',style: TextStyle(color: Colors.white),textAlign: TextAlign.center)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0740:90,child: Center(child: Text('Last\nPayment Date',style: TextStyle(color: Colors.white),textAlign: TextAlign.center)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0600:90,child: Center(child: Text('loan date',style: TextStyle(color: Colors.white),textAlign: TextAlign.center)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0600:90,child: Center(child: Text('Close/Due\nDate',style: TextStyle(color: Colors.white),textAlign: TextAlign.center)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0350:50,child: Center(child: Text('Action',style: TextStyle(color: Colors.white),textAlign: TextAlign.center)))),
                                  ],
                                  rows: [],
                                ),
                              ),

                              Flexible(child: SingleChildScrollView(
                                child: DataTable(
                                    border: TableBorder.all(
                                      color: Colors.black12,
                                      width: 1.0,
                                    ),
                                    dataRowMinHeight: 27,
                                    dataRowMaxHeight: 27,
                                    showCheckboxColumn: false,
                                    columnSpacing: 5,
                                    headingRowHeight: 0,
                                    columns: List.generate(16,
                                          (_) => DataColumn(
                                        label: SizedBox(width: 0, height: 0),
                                      ),
                                    ), rows: [
                                  ...List.generate(
                                      homeLoanController.loansData.length, (index) {
                                    final loansdata = homeLoanController.loansData[index];
                                    final num amount = loansdata['principal_amount'];   // int or double
                                    final emiAmount = loansdata['emi_amount'];
                                    final emiPending = loansdata['due_emi_amount'];
                                    final emiPen = NumberFormat.currency(
                                      locale: 'en_IN',   // Indian grouping: 12,34,56,789
                                      symbol: '₹',
                                      decimalDigits: 0,  // keep 2 if you need paise
                                    ).format(emiPending);
                                    final emiAMT = NumberFormat.currency(
                                      locale: 'en_IN',   // Indian grouping: 12,34,56,789
                                      symbol: '₹',
                                      decimalDigits: 0,  // keep 2 if you need paise
                                    ).format(emiAmount);
                                    final formatted = NumberFormat.currency(
                                      locale: 'en_IN',   // Indian grouping: 12,34,56,789
                                      symbol: '₹',
                                      decimalDigits: 0,  // keep 2 if you need paise
                                    ).format(amount);

                                    final loanAmount = double.tryParse(loansdata['principal_amount'].toString()) ?? 0.0;
                                    final amountEmi = double.tryParse(loansdata['emi_amount'].toString()) ?? 0.0;
                                    final tenure = int.tryParse(loansdata['tenure'].toString()) ?? 0;

                                    final regularLoans = (amountEmi * tenure) - loanAmount;
                                    final interestLoan = (amountEmi * tenure);
                                    final interestOnly = amount + emiPending;
                                    return DataRow(
                                      cells: [
                                        DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0280:20,child: Center(child: Text("${index + 1}",style: TextStyle(fontSize: 12,color: Utils().text),textAlign: TextAlign.center)))),
                                        DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0390:55,child: Center(child: Text(loansdata['id'].toString(),style: TextStyle(fontSize: 12,color: Utils().text),textAlign: TextAlign.center)))),
                                        DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0350:55,child: Center(child: Text(loansdata['kyc_id'].toString(),style: TextStyle(fontSize: 12,color: Utils().text),textAlign: TextAlign.center)))),
                                        DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.150:150, child: Center(child: Text(loansdata['name'].toString(),style: TextStyle(fontSize: 12,color: Utils().text,),maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center)))),
                                        DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0700:150, child: Center(child: Text(loansdata['mobile_no'].toString(),style: TextStyle(fontSize: 12,color: Utils().text,),maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center)))),
                                        DataCell(
                                          SizedBox(
                                            width: isBigScreen()
                                                ? (MediaQuery.of(context).size.width - 75) * 0.0690
                                                : 90,
                                            child: Center(
                                              child: Text(
                                                formatted,
                                                style: TextStyle(fontSize: 12, color: Utils().text),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.073:90,child: Center(child: Text('₹${loansdata['down_payment'].toString()}',style: TextStyle(fontSize: 12,color: Utils().text),textAlign: TextAlign.center)))),
                                        DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0440:60,child: Center(child: Text(loansdata['tenure'].toString(),style: TextStyle(fontSize: 12,color: Utils().text),textAlign: TextAlign.center)))),
                                        DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.070:80,child: Center(child: Text(emiAMT,style: TextStyle(fontSize: 12,color: Colors.green),textAlign: TextAlign.center,)))),
                                        DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.060:80,child: Center(child: Text(loansdata['type'].toString(),style: TextStyle(fontSize: 12,color: Utils().text),textAlign: TextAlign.center,)))),
                                        DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0640:80,child: Center(child: Text(emiPen,style: TextStyle(fontSize: 12,color: Colors.red),textAlign: TextAlign.center,)))),
                                        DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0675:85,child: Center(child: Text(loansdata['emi_paid'] == null ? "₹0" : "₹${loansdata['emi_paid'].toString()}",style: TextStyle(fontSize: 12,color: Utils().text),textAlign: TextAlign.center)))),
                                        DataCell(
                                          SizedBox(
                                            width: isBigScreen() ? (MediaQuery.of(context).size.width-75) * 0.0740 : 90,
                                            child: Center(
                                              child: Text(
                                                  loansdata["last_payment_date"] == null ? "-" :
                                                  DateFormat("dd/MM/yyyy").format(
                                                    DateTime.parse(loansdata["last_payment_date"].toString()),
                                                  ),
                                                  style: TextStyle(fontSize: 12,color: Utils().text),textAlign: TextAlign.center
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          SizedBox(
                                            width: isBigScreen() ? (MediaQuery.of(context).size.width-75) *0.0600:90,
                                            height: 20,
                                            child: Center(
                                              child: Text(
                                                  DateFormat("dd/MM/yyyy").format(
                                                    DateTime.parse(loansdata['loan_date']),
                                                  ),
                                                  style: TextStyle(fontSize: 12),textAlign: TextAlign.center
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          SizedBox(
                                            width: isBigScreen() ? (MediaQuery.of(context).size.width-75) * 0.0600 : 90,
                                            child: Center(
                                              child: Text(
                                                  DateFormat("dd/MM/yyyy").format(
                                                    DateTime.parse(loansdata['emi_due_date']),
                                                  ),
                                                  style: TextStyle(fontSize: 12), textAlign: TextAlign.center
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Row(
                                            children: [
                                              loansdata['closing_date'] == null ? SizedBox(
                                                width: isBigScreen() ? (MediaQuery.of(context).size.width-75) * 0.0350 : 50,
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    payEmiController.emiPreMonth.clear();
                                                    payEmiController.other_amount.clear();
                                                    payEmiController.penalty.clear();
                                                    payEmiController.Paid_Date.clear();
                                                    loansController.extend = false;
                                                    loansController.closeLoan = true;
                                                    loansController.isChecked = false;
                                                    loansController.totalPayAmount = 0.0;

                                                    if (loansdata["type"] == "interest-only") {
                                                      DateTime today = DateTime.now();
                                                      DateTime emiDueDate = DateTime.tryParse(loansdata["emi_due_date"].toString()) ?? DateTime(2000);

                                                      bool isDueToday =
                                                          emiDueDate.year == today.year &&
                                                              emiDueDate.month == today.month &&
                                                              emiDueDate.day == today.day;

                                                      if (isDueToday) {
                                                        double principal = double.tryParse(loansdata["principal_amount"].toString()) ?? 0;
                                                        double pending = double.tryParse(loansdata["emi_pending"].toString()) ?? 0;

                                                        double total = principal + pending;

                                                        setState(() {
                                                          payEmiController.emiPreMonth.text = total.toStringAsFixed(0);
                                                          loansController.totalPayAmount = total;

                                                          /// 🔒 LOCK CHECKBOX TRUE (never becomes false)
                                                          loansController.isChecked = true;
                                                        });
                                                      }
                                                    }

                                                    int emiAmount = int.tryParse(loansdata['emi_amount'].toString()) ?? 0;
                                                    int emiPending = int.tryParse(loansdata['emi_pending'].toString()) ?? 0;

                                                    // Loan start date
                                                    String loanStartDateStr = loansdata['loan_date'] ?? "";
                                                    DateTime loanStartDate = DateTime.tryParse(loanStartDateStr) ?? DateTime(2000);



                                                    loansController.emiAmount = loansdata['emi_amount'].toString();
                                                    loansController.duration = loansdata['tenure'].toString();

                                                    await payEmiController.emiPaymentHistory(loansdata['id'].toString());
                                                    await getEmiScheduleRows();

                                                    final emiStatus = (loansdata['closing_date'] == null)
                                                        ? loansController.calculateEmiStatus(
                                                      duration: loansdata['tenure'] is int
                                                          ? loansdata['tenure']
                                                          : int.parse(loansdata['tenure'].toString()),

                                                      emiAmount: loansdata['emi_amount'] is num
                                                          ? loansdata['emi_amount'].toDouble()
                                                          : double.parse(loansdata['emi_amount'].toString()),

                                                      loanDate: DateTime.parse(loansdata['loan_date'].toString()),
                                                      payments: payEmiController.loanTransactionHistory.cast<Map<String, dynamic>>(),
                                                    )
                                                        : {
                                                      "status": "PAID",
                                                      "tenure": loansdata['tenure'] is int ? loansdata['tenure'] : int.tryParse(loansdata['tenure'].toString()) ?? 0,
                                                      "due": 0,
                                                      "partial": 0,
                                                    };
                                                    print("due months");
                                                    print(emiStatus["Due"] ?? 0);

                                                    double penaltyAmountCalculation = 0.0; // Declare it outside

                                                    int due = (emiStatus["Due"] ?? 0);
                                                    if (due < 1) due = 0;

                                                    if (loansdata['due_emi_amount'] != 0) {

                                                      double penalty = 0.01 * loansdata['emi_amount'];
                                                      penaltyAmountCalculation = penalty * ((due * (due + 1) / 2) - 1);

                                                      print("penaltyAmountCalculation $penaltyAmountCalculation :- ${penalty * ((due * (due + 1) / 2) - 1)}");

                                                      payEmiController.penalty.text = penaltyAmountCalculation.toString();
                                                    }

                                                    if (Get.width > 700) {
                                                      // Desktop / Web Dialog
                                                      Get.dialog(
                                                          StatefulBuilder(builder: (context, setState) {
                                                            return Dialog(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                              child: Container(
                                                                width: 670,
                                                                padding: EdgeInsets.all(16),
                                                                decoration: BoxDecoration(
                                                                  color: Utils().background,
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          "Pay Emi",
                                                                          style: TextStyle(
                                                                            color: Utils().text,
                                                                            fontSize: 18,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap: () {
                                                                            payEmiController.emiPreMonth.clear();
                                                                            payEmiController.other_amount.clear();
                                                                            payEmiController.penalty.clear();
                                                                            payEmiController.detection.clear();
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: Container(
                                                                            height: 30,
                                                                            width: 30,
                                                                            decoration: BoxDecoration(
                                                                              color: Colors.red,
                                                                              shape: BoxShape.circle,
                                                                              border: Border.all(width: 1, color: Utils().button),
                                                                            ),
                                                                            child: Icon(Icons.close, color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Divider(),

                                                                    // User Info
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text("Name: ${loansdata['name']}",
                                                                                style: TextStyle(fontSize: 14, color: Utils().text)),
                                                                            SizedBox(height: 5),
                                                                            Text("KYC ID: ${loansdata['kyc_id']}",
                                                                                style: TextStyle(fontSize: 14, color: Utils().text)),
                                                                            SizedBox(height: 5),
                                                                            Text("Penalty Amount: ₹${penaltyAmountCalculation.toString()}",
                                                                                style: TextStyle(
                                                                                    fontSize: 14,
                                                                                    color: Colors.red,
                                                                                    fontWeight: FontWeight.bold)),
                                                                            SizedBox(height: 5),
                                                                            Text(
                                                                              "Loan Date: ${DateFormat('dd-MM-yyyy').format(loanStartDate)}",
                                                                              style: TextStyle(fontSize: 14, color: Utils().text),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text("Loan ID: ${loansdata['id']}",
                                                                                style: TextStyle(fontSize: 14, color: Utils().text)),
                                                                            SizedBox(height: 5),
                                                                            Text("Loan Amount: ${loansdata['principal_amount']}",
                                                                                style: TextStyle(fontSize: 14, color: Utils().text)),
                                                                            SizedBox(height: 5),
                                                                            /// emi_pending
                                                                            Text("Old Pending EMI: ${loansdata['due_emi_amount']}",
                                                                                style: TextStyle(
                                                                                    fontSize: 14,
                                                                                    color: Colors.red,
                                                                                    fontWeight: FontWeight.bold)),
                                                                            SizedBox(height: 5),
                                                                            Text("EMI Amount: ${loansdata['emi_amount']}",
                                                                                style: TextStyle(
                                                                                    fontSize: 14,
                                                                                    color: Colors.green,
                                                                                    fontWeight: FontWeight.bold)),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),

                                                                    SizedBox(height: 20),
                                                                    Form(
                                                                      key: payEmiController.emiFormKye,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          SizedBox(
                                                                            width: MediaQuery.of(context).size.width * 0.0900,
                                                                            child: TextFormField(
                                                                              readOnly: loansController.isChecked,
                                                                              autofocus: true,
                                                                              keyboardType: TextInputType.number,
                                                                              inputFormatters: [
                                                                                FilteringTextInputFormatter.digitsOnly,
                                                                                LengthLimitingTextInputFormatter(10),
                                                                              ],
                                                                              validator: (value) {
                                                                                if (value == null || value.trim().isEmpty) {
                                                                                  return 'Required this field';
                                                                                }

                                                                                // Allow 20000.00 / 20000.50 / 20000 etc.
                                                                                final double? enteredEmi = double.tryParse(value.trim());

                                                                                if (enteredEmi == null) {
                                                                                  return 'Enter a valid number';
                                                                                }

                                                                                if (enteredEmi <= 0) {
                                                                                  return 'Amount must be greater than 0';
                                                                                }

                                                                                final double pendingEmiRegular =
                                                                                    double.tryParse(loansdata['emi_pending'].toString()) ?? 0.0;

                                                                                final double pendingEmiInterest =
                                                                                    (double.tryParse(loansdata['emi_pending'].toString()) ?? 0.0) +
                                                                                        (double.tryParse(loansdata['principal_amount'].toString()) ?? 0.0);

                                                                                if (loansdata["type"] != "interest-only" && enteredEmi > pendingEmiRegular) {
                                                                                  return 'Invalid amount';
                                                                                }

                                                                                if (loansdata["type"] == "interest-only" &&
                                                                                    enteredEmi > pendingEmiInterest) {
                                                                                  return 'Invalid amount';
                                                                                }

                                                                                return null;
                                                                              },


                                                                              onChanged: (value) {
                                                                                double emi = double.tryParse(payEmiController.emiPreMonth.text) ?? 0;
                                                                                double penalty = double.tryParse(payEmiController.penalty.text) ?? 0;
                                                                                double other = double.tryParse(payEmiController.other_amount.text) ?? 0;

                                                                                bool isInterest = loansdata['type'] == "interest-only";
                                                                                bool isRegular = loansdata['type'] == "regular";

                                                                                double principalAmount = double.tryParse(loansdata['principal_amount'].toString()) ?? 0;

                                                                                setState(() {
                                                                                  if (isInterest && loansdata["emi_due_date"] == DateTime.now) {
                                                                                    loansController.totalPayAmount = principalAmount + emi + penalty + other;
                                                                                  }
                                                                                  else if (isRegular) {
                                                                                    loansController.totalPayAmount = emi + penalty + other;
                                                                                  }
                                                                                  else{
                                                                                    loansController.totalPayAmount = emi + penalty + other;
                                                                                  }
                                                                                });

                                                                                int? enteredValue = int.tryParse(value);
                                                                                int pendingEmi = int.parse(loansdata['emi_pending'].toString());

                                                                                // Interest-only → Auto-check only when EMI matches pending EMI
                                                                                if (isInterest && enteredValue != null && enteredValue == pendingEmi) {
                                                                                  setState(() {
                                                                                    loansController.isChecked = true;
                                                                                    loansController.closeLoan = true;
                                                                                  });
                                                                                }

                                                                                else if (isRegular && enteredValue != null && enteredValue == pendingEmi) {
                                                                                  setState(() {
                                                                                    loansController.isChecked = true;
                                                                                  });
                                                                                }

                                                                                else {
                                                                                  setState(() {
                                                                                    loansController.closeLoan = false;
                                                                                    loansController.isChecked = false;
                                                                                  });
                                                                                }
                                                                              },

                                                                              controller: payEmiController.emiPreMonth,
                                                                              decoration: InputDecoration(
                                                                                labelText: "Emi Amount",
                                                                                labelStyle: TextStyle(fontSize: 12, color: Utils().border_1),
                                                                                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                                border: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    borderSide: BorderSide(color: Utils().border_1, width: 1.5)),
                                                                                enabledBorder: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    borderSide: BorderSide(color: Utils().border_1, width: 1.5)),
                                                                                focusedBorder: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    borderSide: BorderSide(color: Utils().button, width: 2)),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width: MediaQuery.of(context).size.width * 0.0650,
                                                                            child: TextFormField(
                                                                              readOnly: loansController.isChecked, //
                                                                              keyboardType: TextInputType.number,
                                                                              inputFormatters: [
                                                                                FilteringTextInputFormatter.digitsOnly,
                                                                                LengthLimitingTextInputFormatter(10),
                                                                              ],
                                                                              onChanged: (value){
                                                                                double emi = double.tryParse(payEmiController.emiPreMonth.text) ?? 0;
                                                                                double penalty = double.tryParse(payEmiController.penalty.text) ?? 0;
                                                                                double other = double.tryParse(payEmiController.other_amount.text) ?? 0;

                                                                                setState(() {
                                                                                  loansController.totalPayAmount = emi + penalty + other;
                                                                                });
                                                                              },
                                                                              controller: payEmiController.penalty,
                                                                              decoration: InputDecoration(
                                                                                labelText: "Penalty",
                                                                                labelStyle: TextStyle(
                                                                                    fontSize: 12, color: Utils().border_1),
                                                                                contentPadding: EdgeInsets.symmetric(
                                                                                    vertical: 12, horizontal: 16),
                                                                                border: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    borderSide: BorderSide(
                                                                                        color: Utils().border_1, width: 1.5)),
                                                                                enabledBorder: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    borderSide: BorderSide(
                                                                                        color: Utils().border_1, width: 1.5)),
                                                                                focusedBorder: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    borderSide: BorderSide(
                                                                                        color: Utils().button, width: 2)),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width: MediaQuery.of(context).size.width * 0.0900,
                                                                            child: TextFormField(
                                                                              keyboardType: TextInputType.number,
                                                                              inputFormatters: [
                                                                                FilteringTextInputFormatter.digitsOnly,
                                                                                LengthLimitingTextInputFormatter(10),
                                                                              ],
                                                                              onChanged: (value){
                                                                                double emi = double.tryParse(payEmiController.emiPreMonth.text) ?? 0;
                                                                                double penalty = double.tryParse(payEmiController.penalty.text) ?? 0;
                                                                                double other = double.tryParse(payEmiController.other_amount.text) ?? 0;

                                                                                setState(() {
                                                                                  loansController.totalPayAmount = emi + penalty + other;
                                                                                });
                                                                              },
                                                                              controller: payEmiController.other_amount,
                                                                              decoration: InputDecoration(
                                                                                labelText: "Other Amount",
                                                                                labelStyle: TextStyle(
                                                                                    fontSize: 12, color: Utils().border_1),
                                                                                contentPadding: EdgeInsets.symmetric(
                                                                                    vertical: 12, horizontal: 16),
                                                                                border: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    borderSide: BorderSide(
                                                                                        color: Utils().border_1, width: 1.5)),
                                                                                enabledBorder: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    borderSide: BorderSide(
                                                                                        color: Utils().border_1, width: 1.5)),
                                                                                focusedBorder: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    borderSide: BorderSide(
                                                                                        color: Utils().button, width: 2)),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width: MediaQuery.of(context).size.width * 0.0900,
                                                                            child: TextFormField(
                                                                              readOnly: loansController.isChecked, // <-- turns read-only dynamically,
                                                                              keyboardType: TextInputType.number,
                                                                              inputFormatters: [
                                                                                FilteringTextInputFormatter.digitsOnly,
                                                                                LengthLimitingTextInputFormatter(10),
                                                                              ],
                                                                              onChanged: (value){
                                                                                double emi = double.tryParse(payEmiController.emiPreMonth.text) ?? 0;
                                                                                double penalty = double.tryParse(payEmiController.penalty.text) ?? 0;
                                                                                double other = double.tryParse(payEmiController.other_amount.text) ?? 0;
                                                                                double detection = double.tryParse(payEmiController.detection.text) ?? 0;

                                                                                setState(() {
                                                                                  loansController.totalPayAmount = emi + penalty + other + detection;
                                                                                });
                                                                              },
                                                                              controller: payEmiController.detection,
                                                                              decoration: InputDecoration(
                                                                                labelText: "Detection",
                                                                                labelStyle: TextStyle(
                                                                                    fontSize: 12, color: Utils().border_1),
                                                                                contentPadding: EdgeInsets.symmetric(
                                                                                    vertical: 12, horizontal: 16),
                                                                                border: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    borderSide: BorderSide(
                                                                                        color: Utils().border_1, width: 1.5)),
                                                                                enabledBorder: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    borderSide: BorderSide(
                                                                                        color: Utils().border_1, width: 1.5)),
                                                                                focusedBorder: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    borderSide: BorderSide(
                                                                                        color: Utils().button, width: 2)),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width: MediaQuery.of(context).size.width * 0.120,
                                                                            child: TextFormField(
                                                                              onChanged: (value) {
                                                                                if (value.isEmpty) return;

                                                                                try {

                                                                                  DateTime userSelectedDate = DateFormat("dd-MM-yyyy").parse(value);


                                                                                  DateTime dueDate = DateFormat("yyyy-MM-dd")
                                                                                      .parse(loansdata["emi_due_date"].toString());


                                                                                  if (userSelectedDate.isBefore(dueDate) ||
                                                                                      userSelectedDate.isAtSameMomentAs(dueDate))
                                                                                  {
                                                                                    print("Due date is not passed — $dueDate");
                                                                                  }
                                                                                  else
                                                                                  {
                                                                                    print("Due date is passed — $dueDate");
                                                                                  }
                                                                                }
                                                                                catch (e) {
                                                                                  print("Invalid date format: $e");
                                                                                }
                                                                              },
                                                                              controller: payEmiController.paymentDate,
                                                                              validator: (value) =>
                                                                              (value == null || value.isEmpty) ? 'Required this field' : null,
                                                                              decoration: InputDecoration(
                                                                                labelText: 'Emi Date',
                                                                                labelStyle: TextStyle(fontSize: 12, color: Utils().border_1),
                                                                                suffixIcon: IconButton(
                                                                                  icon: Icon(Icons.calendar_month_outlined, color: Utils().border_1),
                                                                                  onPressed: () => _pickDate(),
                                                                                ),
                                                                                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                  borderSide: BorderSide(color: Utils().border_1, width: 1.5),
                                                                                ),
                                                                                enabledBorder: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                  borderSide: BorderSide(color: Utils().border_1, width: 1.5),
                                                                                ),
                                                                                focusedBorder: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                  borderSide: BorderSide(color: Utils().button, width: 2),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 20),
                                                                    Row(
                                                                      spacing: 10,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(
                                                                              width: 20,
                                                                              height: 20,
                                                                              child: Checkbox(
                                                                                value: loansController.isChecked,
                                                                                onChanged: (bool? value) async {
                                                                                  DateTime today = DateTime.now();
                                                                                  DateTime emiDueDates = DateTime.tryParse(loansdata["emi_due_date"].toString()) ?? DateTime(2000);
                                                                                  bool isDueToday = emiDueDates.year == today.year &&
                                                                                      emiDueDates.month == today.month &&
                                                                                      emiDueDates.day == today.day;

                                                                                  if (loansController.isChecked == true && loansdata["type"] == "interest-only" && isDueToday) {
                                                                                    return; // 🔒 Prevent unchecking
                                                                                  }
                                                                                  setState(() {
                                                                                    payEmiController.emiPreMonth.text =
                                                                                        loansdata["due_emi_amount"].toString();
                                                                                  });

                                                                                  loansController.emiAmount = loansdata['emi_amount'].toString();
                                                                                  loansController.duration = loansdata['tenure'].toString();

                                                                                  await payEmiController.emiPaymentHistory(loansdata['id'].toString());
                                                                                  await getEmiScheduleRows();

                                                                                  final emiStatus = (loansdata['closing_date'] == null) ? loansController.calculateEmiStatus(
                                                                                    duration: loansdata['tenure'] is int
                                                                                        ? loansdata['tenure']
                                                                                        : int.parse(loansdata['tenure'].toString()),
                                                                                    emiAmount: loansdata['emi_amount'] is num
                                                                                        ? loansdata['emi_amount'].toDouble()
                                                                                        : double.parse(loansdata['emi_amount'].toString()),
                                                                                    loanDate: DateTime.parse(
                                                                                        loansdata['loan_date'].toString()),
                                                                                    payments: payEmiController.loanTransactionHistory
                                                                                        .cast<Map<String, dynamic>>(),
                                                                                  )
                                                                                      : {
                                                                                    "status": "PAID",
                                                                                    "tenure": loansdata['tenure'] is int
                                                                                        ? loansdata['tenure']
                                                                                        : int.tryParse(
                                                                                        loansdata['tenure'].toString()) ??
                                                                                        0,
                                                                                    "due": 0,
                                                                                    "partial": 0,
                                                                                  };

                                                                                  double tenure =
                                                                                      double.tryParse(loansdata['tenure'].toString()) ?? 0;
                                                                                  double emiAmount =
                                                                                      double.tryParse(loansdata['emi_amount'].toString()) ??
                                                                                          0;
                                                                                  double principalAmount = double.tryParse(
                                                                                      loansdata['principal_amount'].toString()) ??
                                                                                      0;

                                                                                  double durationCalculation = tenure -
                                                                                      (emiStatus["Paid"] ?? 0) -
                                                                                      (emiStatus["Due"] ?? 0);

                                                                                  double interestCalculation = ((emiAmount * tenure - principalAmount) / tenure);
                                                                                  print("interestCalculation ${interestCalculation}");
                                                                                  double regularLoan = ((emiAmount - interestCalculation) * durationCalculation);
                                                                                  print("regularLoan ${regularLoan}");

                                                                                  double emi = double.tryParse(payEmiController.emiPreMonth.text) ?? 0;
                                                                                  double penalty = double.tryParse(payEmiController.penalty.text) ?? 0;
                                                                                  double other = double.tryParse(payEmiController.other_amount.text) ?? 0;
                                                                                  double detection = double.tryParse(payEmiController.detection.text) ?? 0;

                                                                                  bool isRegular = loansdata['type'] == "regular";
                                                                                  bool isInterestOnly = loansdata['type'] == "interest-only";

                                                                                  DateTime emiDueDate = DateTime.parse(loansdata['emi_due_date'].toString());
                                                                                  bool todayDue = DateTime.now().toLocal().toString().substring(0, 10) == emiDueDate.toString().substring(0, 10);
                                                                                  setState(() {
                                                                                    loansController.isChecked = value ?? false;

                                                                                    if (loansController.isChecked) {
                                                                                      if (isRegular) {
                                                                                        loansController.totalPayAmount =
                                                                                            regularLoan + emi + penalty + other + detection;
                                                                                      }
                                                                                      else if (isInterestOnly) {

                                                                                        double currentInterestEmi =
                                                                                            double.tryParse(payEmiController.emiPreMonth.text) ?? 0.0;

                                                                                        loansController.totalPayAmount = principalAmount +
                                                                                            currentInterestEmi +
                                                                                            penalty +
                                                                                            other +
                                                                                            detection;

                                                                                        double finalEmi =
                                                                                            loansController.totalPayAmount - penalty;

                                                                                        payEmiController.emiPreMonth.text =
                                                                                            finalEmi.toStringAsFixed(0);
                                                                                      }

                                                                                      double penaltyAmount =
                                                                                          double.tryParse(payEmiController.penalty.text) ?? 0;
                                                                                      double finalEmi =
                                                                                          loansController.totalPayAmount - penaltyAmount;

                                                                                      payEmiController.emiPreMonth.text =
                                                                                          finalEmi.toStringAsFixed(0);

                                                                                      if (isRegular) {
                                                                                        double dueAmt = double.tryParse(loansdata['emi_pending'].toString()) ?? 0.0;
                                                                                        double dueTillDate = double.tryParse(loansdata['due_emi_amount'].toString()) ?? 0.0;
                                                                                        double emiPerMonth = double.tryParse(loansdata['emi_amount'].toString()) ?? 0.0;
                                                                                        double tenureValue = double.tryParse(loansdata['tenure'].toString()) ?? 0.0;

                                                                                        final String todayText = payEmiController.paymentDate.text;

                                                                                        DateTime today = DateFormat("dd-MM-yyyy").parse(todayText);


                                                                                        DateTime dueDate = DateFormat("yyyy-MM-dd").parse(loansdata["emi_due_date"].toString());

                                                                                        // if () {
                                                                                        //   print("Due date is not passed — $dueDate");
                                                                                        // } else {
                                                                                        //   print("Due date is passed — $dueDate");
                                                                                        // }

                                                                                        if (tenureValue == 0 || emiPerMonth == 0) {
                                                                                          print("Error: Tenure or EMI per month cannot be zero.");
                                                                                          payEmiController.emiPreMonth.text = "0";
                                                                                          payEmiController.detection.text = "0";
                                                                                          return;
                                                                                        }
                                                                                        double intPerMonth = regularLoans / tenureValue;
                                                                                        print("intPerMonth $intPerMonth");
                                                                                        double difference = (dueAmt - dueTillDate);
                                                                                        print("difference $intPerMonth");
                                                                                        double deduction = (today.isAfter(dueDate) || today.isAtSameMomentAs(dueDate))?0:(difference * intPerMonth) / emiPerMonth;
                                                                                        print("deduction $deduction");

                                                                                        double finalEmiPayableAmt = dueAmt - deduction;

                                                                                        print("dueAmt: $dueAmt");
                                                                                        print("dueTillDate: $dueTillDate");
                                                                                        print("emiPerMonth: $emiPerMonth");
                                                                                        print("tenureValue: $tenureValue");
                                                                                        print("intPerMonth: $intPerMonth");
                                                                                        print("difference: $difference");
                                                                                        print("deduction: $deduction");
                                                                                        print("finalEmiPayableAmt: $finalEmiPayableAmt");

                                                                                        payEmiController.emiPreMonth.text = finalEmiPayableAmt.toStringAsFixed(2);
                                                                                        payEmiController.detection.text = deduction.toStringAsFixed(0);

                                                                                      }
                                                                                    }
                                                                                    else {
                                                                                      loansController.totalPayAmount =
                                                                                          emi + penalty + other + detection;

                                                                                      payEmiController.emiPreMonth.text =
                                                                                          loansdata["due_emi_amount"].toString();

                                                                                      payEmiController.detection.text = "0";
                                                                                    }
                                                                                  });
                                                                                },
                                                                                activeColor: Utils().button,
                                                                                checkColor: Colors.white,
                                                                              ),
                                                                            ),

                                                                            SizedBox(width: 8),
                                                                            Text(
                                                                              "Close Loan",
                                                                              style: TextStyle(
                                                                                fontSize: 14,
                                                                                color: Utils().text,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),

                                                                        /// ✅ Show "Extend Months" only when 3 conditions true
                                                                        // Visibility(
                                                                        //   visible: loansController.extend,
                                                                        //   child: SizedBox(
                                                                        //     width: MediaQuery.of(context).size.width * 0.0950,
                                                                        //     child:  SizedBox(
                                                                        //       width: MediaQuery.of(context).size.width * 0.120,
                                                                        //       child: TextFormField(
                                                                        //         inputFormatters: [
                                                                        //           FilteringTextInputFormatter.digitsOnly,
                                                                        //           LengthLimitingTextInputFormatter(10),
                                                                        //         ],
                                                                        //         controller: payEmiController.extendMonths,
                                                                        //         validator: (value) =>
                                                                        //         (value == null || value.isEmpty) ? 'Required this field' : null,
                                                                        //         decoration: InputDecoration(
                                                                        //           labelText: 'Extend Month',
                                                                        //           labelStyle: TextStyle(fontSize: 12, color: Utils().border_1),
                                                                        //           contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                        //           border: OutlineInputBorder(
                                                                        //             borderRadius: BorderRadius.circular(10),
                                                                        //             borderSide: BorderSide(color: Utils().border_1, width: 1.5),
                                                                        //           ),
                                                                        //           enabledBorder: OutlineInputBorder(
                                                                        //             borderRadius: BorderRadius.circular(10),
                                                                        //             borderSide: BorderSide(color: Utils().border_1, width: 1.5),
                                                                        //           ),
                                                                        //           focusedBorder: OutlineInputBorder(
                                                                        //             borderRadius: BorderRadius.circular(10),
                                                                        //             borderSide: BorderSide(color: Utils().button, width: 2),
                                                                        //           ),
                                                                        //         ),
                                                                        //       ),
                                                                        //     ),
                                                                        //   ),
                                                                        // ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(height: 10,),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      spacing: 5,
                                                                      children: [
                                                                        Container(
                                                                          height: 35,
                                                                          width: 150,
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(12),
                                                                            border: Border.all(
                                                                                width: 2,
                                                                                color: Utils().button
                                                                            ),
                                                                          ),
                                                                          child: Center(child: Text("₹${loansController.totalPayAmount.round()}",style: TextStyle(
                                                                              color: Utils().button,
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w600
                                                                          ),),),
                                                                        ),
                                                                        Center(
                                                                          child: GestureDetector(
                                                                            onTap: () async {
                                                                              if (payEmiController.emiFormKye.currentState!.validate()) {
                                                                                await payEmiController.PaymentReceived(
                                                                                    context, loansdata['id']);
                                                                                if (payEmiController.success != null &&
                                                                                    payEmiController.success == "true") {
                                                                                  initMethodCalling();
                                                                                }
                                                                              }
                                                                            },
                                                                            child:  Container(
                                                                              height: 35,
                                                                              width: 150,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(12),
                                                                                gradient: LinearGradient(
                                                                                  colors: [Utils().border_1, Utils().button],
                                                                                ),
                                                                              ),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "Pay Emi",
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color: Utils().background,
                                                                                      fontSize: 16),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },)
                                                      );
                                                    }
                                                    else {
                                                      // Mobile version
                                                      payEmiController.emiPreMonth.clear();
                                                      payEmiController.other_amount.clear();
                                                      payEmiController.penalty.clear();
                                                      payEmiController.mobilName = loansdata['name'].toString();
                                                      payEmiController.mobilKycID = loansdata['kyc_id'].toString();
                                                      payEmiController.mobilLoanDate = loansdata['loan_date'].toString();
                                                      payEmiController.mobilLoanId = loansdata['id'].toString();
                                                      payEmiController.mobilLoanAmount = loansdata['principal_amount'].toString();
                                                      payEmiController.mobilOldPendingEmi = loansdata['emi_pending'].toString();
                                                      Get.to(MobilPayEmi(), transition: Transition.noTransition);
                                                    }
                                                  },
                                                  child: Image.asset("assets/images/rupee.png",
                                                      color: Utils().button, height: 22),
                                                ),
                                              ) : SizedBox(
                                                  width: isBigScreen() ? (MediaQuery.of(context).size.width-75) * 0.0350 : 50,
                                                  child: Image.asset("assets/images/rupee.png",color: Colors.grey,height: 22,)),
                                            ],
                                          )

                                        ),
                                      ],
                                    );
                                  }),
                                  DataRow(
                                    color: MaterialStateProperty.all(Colors.white), // your custom color
                                    cells: [
                                      const DataCell(Text("")),
                                      const DataCell(Text("")),
                                      const DataCell(Text("")),
                                      const DataCell(Text("")),
                                      const DataCell(Center(child: Text("Total", style: TextStyle(fontWeight: FontWeight.bold)))),
                                      DataCell(Center(child: Text(NumberFormat.currency(
                                        locale: "en_IN",
                                        symbol: '₹',
                                        decimalDigits: 0,
                                      ).format(_calculateTotalLoanAmount()),style: TextStyle(color: Utils().text,fontWeight: FontWeight.w600,fontSize: 14),))),
                                      DataCell(Center(child: Text(NumberFormat.currency(
                                        locale: "en_IN",
                                        symbol: '₹',
                                        decimalDigits: 0,
                                      ).format(_calculateDownPayment()),style: TextStyle(color: Utils().text,fontWeight: FontWeight.w600,fontSize: 14),))),
                                      const DataCell(Text("")),
                                      DataCell(Center(child: Text(NumberFormat.currency(
                                        locale: "en_IN",
                                        symbol: '₹',
                                        decimalDigits: 0,
                                      ).format(_calculateEmiAmount()),style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600,fontSize: 14),))),
                                      const DataCell(Text("")),
                                      DataCell(Center(child: Text(NumberFormat.currency(
                                        locale: "en_IN",
                                        symbol: '₹',
                                        decimalDigits: 0,
                                      ).format(_calculateEmiPending()),style: TextStyle(color: Colors.red,fontWeight: FontWeight.w600,fontSize: 14),))),
                                      DataCell(Center(child: Text(NumberFormat.currency(
                                        locale: "en_IN",
                                        symbol: '₹',
                                        decimalDigits: 0,
                                      ).format(_calculateEmiPaid()),style: TextStyle(color: Utils().text,fontWeight: FontWeight.w600,fontSize: 14),))),
                                      const DataCell(Text("")),
                                      const DataCell(Text("")),
                                      const DataCell(Text("")),
                                      const DataCell(Text("")),
                                    ],
                                  ),
                                ]),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
            ));
          }),
        ],
      ),
    );
  }
  bool isBigScreen(){
    return (MediaQuery.of(context).size.width > 700);
  }
  double _calculateTotalLoanAmount() {
    double total = 0;
    for (var loan in homeLoanController.loansData) {
      total += double.tryParse(loan['principal_amount'].toString()) ?? 0;
    }
    return total;
  }
  double _calculateDownPayment() {
    double downPayment = 0;
    for (var loan in homeLoanController.loansData) {
      downPayment += double.tryParse(loan['down_payment'].toString()) ?? 0;
    }
    return downPayment;
  }
  double _calculateEmiAmount() {
    double emiAmount = 0;
    for (var loan in homeLoanController.loansData) {
      emiAmount += double.tryParse(loan['emi_amount'].toString()) ?? 0;
    }
    return emiAmount;
  }
  double _calculateEmiPending() {
    double emiPending = 0;
    for (var loan in homeLoanController.loansData) {
      emiPending += double.tryParse(loan['emi_pending'].toString()) ?? 0;
    }
    return emiPending;
  }
  double _calculateEmiPaid() {
    double emiPaid = 0;
    for (var loan in homeLoanController.loansData) {
      emiPaid += double.tryParse(loan['emi_paid'].toString()) ?? 0;
    }
    return emiPaid;
  }
}
