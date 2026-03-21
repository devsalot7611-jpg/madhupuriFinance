import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'Controller/ReportController.dart';
import 'HomeSacreen.dart';
import 'Utils.dart';


class PenaltyReport extends StatefulWidget {
  const PenaltyReport({super.key});

  @override
  State<PenaltyReport> createState() => _PenaltyReportState();
}

class _PenaltyReportState extends State<PenaltyReport> {
  final ReportController reportController = Get.put(ReportController());
  final ScrollController horizontalScroll = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data();
  }
  void data() async {
    await reportController.emiPaymentHistory();
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
              Text("Penalty",style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isBigScreen() ? 22 : 14,
                color: Utils().text,
              ),),
              SizedBox(width: MediaQuery.of(context).size.width*0.06,),
              Expanded(
                child: SizedBox(
                  height: isBigScreen() ? 35 : 30,
                  // width: MediaQuery.of(context).size.width * 0.300,
                  child: TextField(
                    controller: reportController.transactionReport,
                    onChanged: (value) {
                      reportController.transactionSearch(value);
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
              SizedBox(width: MediaQuery.of(context).size.width*0.0300,),
              Obx(() {
                return GestureDetector(
                    onTap: () async {
                      if (!reportController.isExportingPdf.value) {
                        await reportController.pdfPenalty(reportController.loanTransactionHistory);
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
                      await reportController.excelPenalty(reportController.loanTransactionHistory);
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
                child: Center(
                  child: Text("No payment history found",style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.red,
                  ),),
                ),
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
                                          ? (MediaQuery.of(context).size.width - 75) * 0.0500
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
                                          : 55,
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
                                          ? (MediaQuery.of(context).size.width - 75) * 0.0600
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
                                          ? (MediaQuery.of(context).size.width - 75) * 0.090
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
                                          ? (MediaQuery.of(context).size.width - 75) * 0.070
                                          : 80,
                                      child: Center(
                                        child: Text('Paid Date',
                                            style: TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: const [],
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
                                  columns: List.generate(6,
                                        (_) => DataColumn(
                                      label: SizedBox(width: 0, height: 0),
                                    ),
                                  ),
                                  rows: [
                                    ...List.generate(
                                      reportController.loansData.length,
                                          (index) {
                                        final payment = reportController.loanTransactionHistory[index];
                                        return DataRow(
                                          cells: [
                                            DataCell(SizedBox(
                                                width: isBigScreen()
                                                    ? (MediaQuery.of(context).size.width - 75) * 0.0350
                                                    : 55,
                                                child: Center(child: Text(payment['id'].toString())))),
                                            DataCell(SizedBox(width: isBigScreen()
                                                ? (MediaQuery.of(context).size.width - 75) * 0.0500
                                                : 55,
                                                child: Center(child: Text(payment['loan_id'].toString())))),
                                            DataCell(SizedBox(
                                                width: isBigScreen()
                                                    ? (MediaQuery.of(context).size.width - 75) * 0.200
                                                    : 85,
                                                child: Center(child: Text(payment['name'].toString(), overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14,color: Utils().text),)))),
                                            DataCell(SizedBox(
                                                width: isBigScreen()
                                                    ? (MediaQuery.of(context).size.width - 75) * 0.0600
                                                    : 55,
                                                child: Center(child: Text("₹${payment['penalty']}")))),
                                            DataCell(SizedBox(
                                                width: isBigScreen()
                                                    ? (MediaQuery.of(context).size.width - 75) * 0.090
                                                    : 80,
                                                child: Center(child: Text("₹${payment['other_amount']}")))),
                                            DataCell(SizedBox(
                                                width: isBigScreen()
                                                    ? (MediaQuery.of(context).size.width - 75) * 0.0700
                                                    : 80,
                                                child: Center(child: Text(DateFormat("dd/MM/yyyy").format(DateTime.parse(payment['paid_date'])))))),
                                          ],
                                        );
                                      },
                                    ),
                                  ],

                                ),
                              ),
                            ),
                            // Container(
                            //   height: 30,
                            //   width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.615:150,
                            //   decoration: BoxDecoration(
                            //     border: Border(
                            //       left: BorderSide(color: Colors.grey, width: 1),
                            //       right: BorderSide(color: Colors.grey, width: 1),
                            //       bottom: BorderSide(color: Colors.grey, width: 1),
                            //     ),
                            //   ),
                            //   child: Row(
                            //     children: [
                            //       SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.330:95,),
                            //       Text(
                            //         NumberFormat.currency(
                            //           locale: 'en_IN', // Indian style formatting
                            //           symbol: '₹',
                            //           decimalDigits: 0,
                            //         ).format(_calculateEmiAmount()),
                            //       ),
                            //       SizedBox(width: 50,),
                            //       Text(
                            //         NumberFormat.currency(
                            //           locale: 'en_IN', // Indian style formatting
                            //           symbol: '₹',
                            //           decimalDigits: 0,
                            //         ).format(_calculatePenalty()),
                            //       ),
                            //       SizedBox(width: 60,),
                            //       Text(
                            //         NumberFormat.currency(
                            //           locale: 'en_IN', // Indian style formatting
                            //           symbol: '₹',
                            //           decimalDigits: 0,
                            //         ).format(_calculateOtherAmount()),
                            //       ),
                            //     ],
                            //   ),
                            // )
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
}
