import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:madhupurifinance/Controller/ReportController.dart';
import 'package:madhupurifinance/Controller/loansController.dart';
import 'package:madhupurifinance/Utils.dart';
import 'HomeSacreen.dart';
import 'package:flutter_svg/svg.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  
  final ReportController reportController = Get.put(ReportController());
  final LoansController loansController = Get.put(LoansController());
  final ScrollController horizontalScroll = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataFatching();
  }
  void dataFatching() async {
   await loansController.getLoans();
   setState(() {

   });
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
              Text("Transaction",style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isBigScreen() ? 22 : 14,
                color: Utils().text,
              ),),
              SizedBox(width: MediaQuery.of(context).size.width*0.06,),
              Expanded(
                child: SizedBox(
                  height: isBigScreen() ? 35 : 30,
                  // width: MediaQuery.of(context).size.width * 0.300,
                  child: TextFormField(
                    controller: reportController.transactionReport,
                    onChanged: (value) {
                      reportController.transactionSearch(value);
                    },
                    textAlign: TextAlign.left,
                    style: const TextStyle(),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(4),
                      hintText: "Search...",
                      hintStyle: TextStyle(
                        fontSize: isBigScreen() ? 16 : 12,
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                      fillColor: Utils().searchBar,
                      filled: true,
                    ),
                  )
                  ,),
              ),
              SizedBox(width: MediaQuery.of(context).size.width*0.0300,),
              Obx(() {
                return GestureDetector(
                  onTap: () async {
                    if (!reportController.isExportingPdf.value) {
                      await reportController.exportToPdf(reportController.loanTransactionHistory);
                    }
                  },
                  child: reportController.isExportingPdf.value
                      ? SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : SizedBox(
                      height: 50,
                      width: 50,
                      child: SvgPicture.asset("assets/images/pdf.svg"))
                );
              }),
              SizedBox(width: 20),
              Obx(() {
                return GestureDetector(
                  onTap: () async {
                    if (!reportController.isExportingExcel.value) {
                      await reportController.exportToExcel(reportController.loanTransactionHistory);
                    }
                  },
                  child: reportController.isExportingExcel.value
                      ? SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : SizedBox(
                      height: 50,
                      width: 50,
                      child: SvgPicture.asset("assets/images/excel.svg")),
                );
              }),
              SizedBox(width: 10,),
            ],
          ),
          SizedBox(height: 10,),
          Obx(() {
            if (reportController.payEmi.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (reportController.loansData.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("No payment history found",style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.red,
                ),),
              );
            }

            return Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return AdaptiveScrollbar(
                    underSpacing: EdgeInsets.only(bottom: Get.width),
                    controller: horizontalScroll,
                    width: Get.width,
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
                        constraints: BoxConstraints(minWidth: constraints.maxWidth),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                columnSpacing: 5,
                                columns: [
                                  DataColumn(
                                    label: SizedBox(
                                      width: isBigScreen()
                                          ? (MediaQuery.of(context).size.width - 75) * 0.0350
                                          : 55,
                                      child: Center(
                                        child: Text('ID',
                                            style: TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: isBigScreen()
                                          ? (MediaQuery.of(context).size.width - 75) * 0.0470
                                          : 55,
                                      child: Center(
                                        child: Text('Loans ID',
                                            style: TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: isBigScreen()
                                          ? (MediaQuery.of(context).size.width - 75) * 0.200
                                          : 85,
                                      child: Center(
                                        child: Text('Name',
                                            style: TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: isBigScreen()
                                          ? (MediaQuery.of(context).size.width - 75) * 0.080
                                          : 95,
                                      child: Center(
                                        child: Text('EMI Amount',
                                            style: TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: isBigScreen()
                                          ? (MediaQuery.of(context).size.width - 75) * 0.0440
                                          : 55,
                                      child: Center(
                                        child: Text('Penalty',
                                            style: TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: isBigScreen()
                                          ? (MediaQuery.of(context).size.width - 75) * 0.080
                                          : 80,
                                      child: Center(
                                        child: Text('Other Amount',
                                            style: TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: isBigScreen()
                                          ? (MediaQuery.of(context).size.width - 75) * 0.0645
                                          : 80,
                                      child: Center(
                                        child: Text('Paid Date',
                                            style: TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: [],
                              ),
                            ),
                            Flexible(
                              child: SingleChildScrollView(
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
                                  columns: List.generate(7,
                                        (_) => DataColumn(
                                      label: SizedBox(width: 0, height: 0),
                                    ),
                                  ),
                                  rows: [
                                    ...List.generate(
                                      reportController.loansData.length,
                                          (index) {
                                        final payment = reportController.loansData[index];
                                        return DataRow(
                                          cells: [
                                            DataCell(SizedBox(
                                                width: isBigScreen()
                                                    ? (MediaQuery.of(context).size.width - 75) * 0.0350
                                                    : 55,
                                                child: Center(child: Text(payment['id'].toString(),style: TextStyle(fontSize: 14,color: Utils().text),)))),
                                            DataCell(SizedBox(width: isBigScreen()
                                                ? (MediaQuery.of(context).size.width - 75) * 0.0470
                                                : 55,
                                                child: Center(child: Text(payment['loan_id'].toString(),style: TextStyle(fontSize: 14,color: Utils().text),)))),
                                            DataCell(SizedBox(
                                                width: isBigScreen()
                                                    ? (MediaQuery.of(context).size.width - 75) * 0.200
                                                    : 85,
                                                child: Center(child: Text(payment['name'].toString(), overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14,color: Utils().text),)))),
                                            DataCell(SizedBox(
                                                width: isBigScreen()
                                                    ? (MediaQuery.of(context).size.width - 75) * 0.080
                                                    : 95,
                                                child: Center(child: Text("₹${payment['emi_amount']}",style: TextStyle(fontSize: 14,color: Colors.green),)))),
                                            DataCell(SizedBox(
                                                width: isBigScreen()
                                                    ? (MediaQuery.of(context).size.width - 75) * 0.0440
                                                    : 55,
                                                child: Center(child: Text("₹${payment['penalty']}",style: TextStyle(fontSize: 14,color: Colors.green),)))),
                                            DataCell(SizedBox(
                                                width: isBigScreen()
                                                    ? (MediaQuery.of(context).size.width - 75) * 0.080
                                                    : 80,
                                                child: Center(child: Text("₹${payment['other_amount']}",style: TextStyle(fontSize: 14,color: Colors.green),)))),
                                            DataCell(SizedBox(
                                                width: isBigScreen()
                                                    ? (MediaQuery.of(context).size.width - 75) * 0.0645
                                                    : 80,
                                                child: Center(child: Text(DateFormat("dd/MM/yyyy").format(DateTime.parse(payment['paid_date'])),style: TextStyle(fontSize: 14,color: Utils().text),)))),
                                          ],
                                        );
                                      },
                                    ),

                                    DataRow(
                                      color: MaterialStateProperty.all(Colors.white), // your custom color
                                      cells: [
                                        const DataCell(Text("")),
                                        const DataCell(Text("")),
                                        const DataCell(Center(child: Text("Total", style: TextStyle(fontWeight: FontWeight.bold)))),
                                        DataCell(Center(child: Text(NumberFormat.currency(
                                          locale: "en_IN",
                                          symbol: '₹',
                                          decimalDigits: 0,
                                        ).format(_calculateEmiAmount()),style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600,fontSize: 14),))),
                                        DataCell(Center(child: Text(NumberFormat.currency(
                                          locale: "en_IN",
                                          symbol: '₹',
                                          decimalDigits: 0,
                                        ).format(_calculatePenalty()),style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600,fontSize: 14),))),
                                        DataCell(Center(child: Text(NumberFormat.currency(
                                          locale: "en_IN",
                                          symbol: '₹',
                                          decimalDigits: 0,
                                        ).format(_calculateOtherAmount()),style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600,fontSize: 14),))),
                                        const DataCell(Text("")),
                                      ],
                                    ),
                                  ],

                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
  bool isBigScreen(){
    return (MediaQuery.of(context).size.width > 700);
  }
  double _calculateEmiAmount() {
    double emiAmount = 0;
    for (var loan in  reportController.loanTransactionHistory) {
      emiAmount += double.tryParse(loan['emi_amount'].toString()) ?? 0;
    }
    return emiAmount;
  }
  double _calculatePenalty() {
    double penalty = 0;
    for (var loan in  reportController.loanTransactionHistory) {
      penalty += double.tryParse(loan['penalty'].toString()) ?? 0;
    }
    return penalty;
  }
  double _calculateOtherAmount() {
    double otherAmount = 0;
    for (var loan in  reportController.loanTransactionHistory) {
      otherAmount += double.tryParse(loan['other_amount'].toString()) ?? 0;
    }
    return otherAmount;
  }
}
