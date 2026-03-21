import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:madhupurifinance/Controller/ReportController.dart';
import 'HomeSacreen.dart';
import 'Utils.dart';

class CustomerDue extends StatefulWidget {
  const CustomerDue({super.key});

  @override
  State<CustomerDue> createState() => _CustomerDueState();
}

class _CustomerDueState extends State<CustomerDue> {

  final ReportController reportController = Get.put(ReportController());
  final ScrollController horizontalScroll = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();getData();
  }
  void getData()async{
    await  reportController.getLoans();
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
              Text("Customer Due",style: TextStyle(
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
                    controller: reportController.customerDue,
                    onChanged: (value) {
                      setState(() {
                        // loansController.runFilter(value);
                        reportController.customerDueSearch(value);
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
              SizedBox(width: MediaQuery.of(context).size.width*0.0300,),
              Obx(() {
                return GestureDetector(
                    onTap: () async {
                      if (!reportController.isExportingPdf.value) {
                        await reportController.pdfCustomerDue(reportController.loansData);
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
              SizedBox(width: 30,),
              Obx(() {
                return GestureDetector(
                  onTap: () async {
                    if (!reportController.isExportingExcel.value) {
                      await reportController.excelCustomerDue(reportController.loansData);
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
          reportController.loans.isEmpty ? Center(
            child: reportController.errorMessageLoan.value.isEmpty?CircularProgressIndicator():Text(reportController.errorMessageLoan.value,style: TextStyle(color: Colors.red),),
          )
              : reportController.loansData.isEmpty?Center(
            child: Center(
              child: Text("No found similar to your search."),
            ),
          ) : Expanded(
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
                                      child: Text('Sr No.',
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: isBigScreen()
                                        ? (MediaQuery.of(context).size.width - 75) * 0.0400
                                        : 55,
                                    child: Center(
                                      child: Text('Loans\nID',
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: isBigScreen()
                                        ? (MediaQuery.of(context).size.width - 75) * 0.180
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
                                        ? (MediaQuery.of(context).size.width - 75) * 0.0750
                                        : 55,
                                    child: Center(
                                      child: Text('Number',
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
                                      child: Text('Loan Date',
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: isBigScreen()
                                        ? (MediaQuery.of(context).size.width - 75) * 0.0700
                                        : 55,
                                    child: Center(
                                      child: Text('Loan Amount',
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: isBigScreen()
                                        ? (MediaQuery.of(context).size.width - 75) * 0.0750
                                        : 55,
                                    child: Center(
                                      child: Text('Loan Type',
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                ),
                                DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0600:95,child: Center(child: Text('Interest\nAMT',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)))),

                                DataColumn(
                                  label: SizedBox(
                                    width: isBigScreen()
                                        ? (MediaQuery.of(context).size.width - 75) * 0.0450
                                        : 55,
                                    child: Center(
                                      child: Text('Duration',
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: isBigScreen()
                                        ? (MediaQuery.of(context).size.width - 75) * 0.0680
                                        : 55,
                                    child: Center(
                                      child: Text('Paid Amount',
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: isBigScreen()
                                        ? (MediaQuery.of(context).size.width - 75) * 0.0650
                                        : 55,
                                    child: Center(
                                      child: Text('Due Amount',
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
                                      child: Text('Due Date',
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: isBigScreen()
                                        ? (MediaQuery.of(context).size.width - 75) * 0.0750
                                        : 80,
                                    child: Center(
                                      child: Text('Next Emi Date',
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
                                columns: List.generate(13,
                                      (_) => DataColumn(
                                    label: SizedBox(width: 0, height: 0),
                                  ),
                                ),
                                rows: [
                                  ...List.generate(
                                    reportController.loansData.length, // fixed 9 rows
                                        (index) {
                                      final loansData = reportController.loansData[index];
                                      final amount = loansData['principalAmount'];
                                      final loanAmount = NumberFormat.currency(
                                        locale: 'en_IN',   // Indian grouping: 12,34,56,789
                                        symbol: '₹',
                                        decimalDigits: 0,  // keep 2 if you need paise
                                      ).format(amount);

                                      final emiPaid = loansData['emiPaid'];
                                      final paidEmiAmt = NumberFormat.currency(
                                          locale: 'en_IN',
                                          symbol: '₹',
                                          decimalDigits: 0
                                      ).format(emiPaid);

                                      final pendingEmi = loansData['emiPending'];
                                      final pendingAmt = NumberFormat.currency(
                                          locale: 'en_IN',
                                          symbol: '₹',
                                          decimalDigits: 0
                                      ).format(pendingEmi);

                                      final loanAmounts = double.tryParse(loansData['principalAmount'].toString()) ?? 0.0;
                                      final amountEmi = double.tryParse(loansData['emi_amount'].round().toString()) ?? 0.0;
                                      final tenure = int.tryParse(loansData['tenure'].toString()) ?? 0;

                                      final regularLoan = (amountEmi * tenure) - loanAmounts;
                                      final interestLoan = (amountEmi * tenure);
                                      print("loanAmounts ${amountEmi.toString()}");

                                      return DataRow(
                                        cells: [
                                          DataCell(SizedBox(
                                              width: isBigScreen()
                                                  ? (MediaQuery.of(context).size.width - 75) * 0.0350
                                                  : 55,
                                              child: Center(child: Text('${index + 1}',style: TextStyle(fontSize: 14,color: Utils().text),)))),
                                          DataCell(SizedBox(
                                              width: isBigScreen()
                                                  ? (MediaQuery.of(context).size.width - 75) * 0.0400
                                                  : 55,
                                              child: Center(child: Text(loansData['loanId'].toString(),style: TextStyle(fontSize: 14,color: Utils().text),)))),
                                          DataCell(SizedBox(
                                              width: isBigScreen()
                                                  ? (MediaQuery.of(context).size.width - 75) * 0.180
                                                  : 85,
                                              child: Center(child: Text(loansData['name'].toString(),overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14,color: Utils().text),)))),
                                          DataCell(SizedBox(
                                              width: isBigScreen()
                                                  ? (MediaQuery.of(context).size.width - 75) * 0.0750
                                                  : 55,
                                              child: Center(child: Text(loansData['mobile_no'].toString(),style: TextStyle(fontSize: 14,color: Utils().text),)))),
                                          DataCell(SizedBox(
                                              width: isBigScreen()
                                                  ? (MediaQuery.of(context).size.width - 75) * 0.0645
                                                  : 80,
                                              child: Center(
                                                child: Text(
                                                  DateFormat("dd/MM/yyyy").format(
                                                    DateTime.parse(loansData['loanDate']),
                                                  ),
                                                  style: TextStyle(fontSize: 14, color: Utils().text,   // 🔵 Loan Date
                                                  ),textAlign: TextAlign.center,
                                                ),
                                              )
                                          )),
                                          DataCell(SizedBox(
                                              width: isBigScreen()
                                                  ? (MediaQuery.of(context).size.width - 75) * 0.0700
                                                  : 55,
                                              child: Center(child: Text(loanAmount,style: TextStyle(color: Utils().text,fontSize: 14),)))),
                                          DataCell(SizedBox(
                                              width: isBigScreen()
                                                  ? (MediaQuery.of(context).size.width - 75) * 0.0750
                                                  : 55,
                                              child: Center(child: Text(loansData['type'].toString(),style: TextStyle(fontSize: 14,color: Utils().text),)))),
                                          DataCell(
                                            SizedBox(
                                              width: isBigScreen()
                                                  ? (MediaQuery.of(context).size.width - 75) * 0.0600
                                                  : 95,
                                              child: Center(
                                                child: Text(
                                                  loansData['type'] == "regular"
                                                      ? NumberFormat.currency(
                                                    locale: "en_IN",
                                                    symbol: "₹",
                                                    decimalDigits: 0,
                                                  ).format(regularLoan)
                                                      : NumberFormat.currency(
                                                    locale: "en_IN",
                                                    symbol: "₹",
                                                    decimalDigits: 0,
                                                  ).format(interestLoan),
                                                  style: TextStyle(fontSize: 12, color: Utils().text),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(SizedBox(
                                              width: isBigScreen()
                                                  ? (MediaQuery.of(context).size.width - 75) * 0.0450
                                                  : 55,
                                              child: Center(child: Text(loansData['tenure'].toString(),style: TextStyle(fontSize: 14,color: Utils().text),)))),
                                          DataCell(SizedBox(
                                              width: isBigScreen()
                                                  ? (MediaQuery.of(context).size.width - 75) * 0.0680
                                                  : 55,
                                              child: Center(child: Text(paidEmiAmt,style: TextStyle(color: Colors.green,fontSize: 14),)))),
                                          DataCell(SizedBox(
                                              width: isBigScreen()
                                                  ? (MediaQuery.of(context).size.width - 75) * 0.0650
                                                  : 55,
                                              child: Center(child: Text(pendingAmt,style: TextStyle(color: Colors.red,fontSize: 14),)))),

                                          DataCell(SizedBox(
                                            width: isBigScreen()
                                                ? (MediaQuery.of(context).size.width - 75) * 0.0645
                                                : 80,
                                            child: Center(
                                              child: Text(loansData['dueDate'].toString(),style: TextStyle(fontSize: 14, color: Colors.redAccent,    // 🔴 Due Date
                                              ),textAlign: TextAlign.center,), // ✅ from API calculation
                                            ),
                                          )),
                                          DataCell(SizedBox(
                                            width: isBigScreen()
                                                ? (MediaQuery.of(context).size.width - 75) * 0.0750
                                                : 80,
                                            child: Center(
                                              child: Text(loansData['nextEmiDate'].toString(),style: TextStyle(fontSize: 14,color: Utils().text,),textAlign: TextAlign.center,), // ✅ from API calculation
                                            ),
                                          )),
                                        ],
                                      );
                                    },
                                  ),


                                  DataRow(
                                    color: MaterialStateProperty.all(Colors.white),
                                    cells: [
                                      const DataCell(Text("")),
                                      const DataCell(Text("")),
                                      const DataCell(Center(child: Text("Total", style: TextStyle(fontWeight: FontWeight.bold)))),
                                      const DataCell(Text("")),
                                      const DataCell(Text("")),
                                      DataCell(Center(child: Text(NumberFormat.currency(
                                        locale: "en_IN",
                                        symbol: '₹',
                                        decimalDigits: 0,
                                      ).format(_calculateTotalLoanAmount()),
                                        style: TextStyle(color: Utils().text, fontSize: 14, fontWeight: FontWeight.w600),
                                      ))),

                                      const DataCell(Text("")),

                                      /// ✅ ✅ ✅ Interest Total Column (7th Column)
                                      DataCell(Center(child: Text(NumberFormat.currency(
                                        locale: "en_IN",
                                        symbol: '₹',
                                        decimalDigits: 0,
                                      ).format(_calculateTotalInterestAmount()),
                                        style: TextStyle(color: Utils().text, fontSize: 14, fontWeight: FontWeight.w600),
                                      ))),

                                      const DataCell(Text("")),
                                      DataCell(Center(child: Text(NumberFormat.currency(
                                        locale: "en_IN",
                                        symbol: '₹',
                                        decimalDigits: 0,
                                      ).format(_calculateEmiAmount()),
                                        style: TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.w600),
                                      ))),
                                      DataCell(Center(child: Text(NumberFormat.currency(
                                        locale: "en_IN",
                                        symbol: '₹',
                                        decimalDigits: 0,
                                      ).format(_calculateEmiPending()),
                                        style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w600),
                                      ))),
                                      const DataCell(Text("")),
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
          )
        ],
      ),
    );
  }
  bool isBigScreen(){
    return (MediaQuery.of(context).size.width > 700);
  }
  double _calculateTotalLoanAmount() {
    double total = 0;
    for (var loan in  reportController.loansData) {
      total += double.tryParse(loan['principalAmount'].toString()) ?? 0;
    }
    return total;
  }
  double _calculateEmiAmount() {
    double emiPaid = 0;
    for (var loan in  reportController.loansData) {
      emiPaid += double.tryParse(loan['emiPaid'].toString()) ?? 0;
    }
    return emiPaid;
  }
  double _calculateEmiPending() {
    double pending = 0;
    for (var loan in  reportController.loansData) {
      pending += double.tryParse(loan['emiPending'].toString()) ?? 0;
    }
    return pending;
    // double emiPending = 0;
    // for (var loan in reportController.loansData) {
    //   emiPending += double.tryParse(loan['emiPending'].toString()) ?? 0;
    // }
    // return emiPending;
  }

  double _calculateTotalInterestAmount() {
    double totalInterest = 0;
    for (var loan in reportController.loansData) {
      final double loanAmounts = double.tryParse(loan['principalAmount'].toString()) ?? 0.0;
      final double amountEmi = double.tryParse(loan['emi_amount'].toString()) ?? 0.0;
      final int tenure = int.tryParse(loan['tenure'].toString()) ?? 0;

      final double regularLoan = (amountEmi * tenure) - loanAmounts;
      final double interestLoan = (amountEmi * tenure);

      totalInterest += loan['type'] == "regular" ? regularLoan : interestLoan;
    }
    return totalInterest;
  }

}
