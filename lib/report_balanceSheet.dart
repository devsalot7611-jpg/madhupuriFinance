import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Controller/ReportController.dart';
import 'HomeSacreen.dart';
import 'Utils.dart';

class BalanceSheet extends StatefulWidget {
  const BalanceSheet({super.key});

  @override
  State<BalanceSheet> createState() => _BalanceSheetState();
}

class _BalanceSheetState extends State<BalanceSheet> {
  final ReportController reportController = Get.put(ReportController());
  final ScrollController horizontalScroll = ScrollController();

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
              Text("Balance Sheet",style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isBigScreen() ? 22 : 14,
                color: Utils().text,
              ),),
              SizedBox(width: MediaQuery.of(context).size.width*0.06,),
              // Expanded(
              //   child: SizedBox(
              //     height: isBigScreen() ? 35 : 30,
              //     // width: MediaQuery.of(context).size.width * 0.300,
              //     child: TextField(
              //       controller: reportController.balanceSheet,
              //       onChanged: (value) {
              //         setState(() {
              //           // loansController.runFilter(value);
              //         });
              //       },
              //       textAlign: TextAlign.left,
              //       style: TextStyle(
              //         // color: Utils().textColor,
              //       ),
              //       decoration: InputDecoration(
              //         contentPadding: EdgeInsets.all(4),
              //         hintText: "Search...",
              //         hintStyle: TextStyle(
              //           // color: Utils().searchbar_Text,
              //           fontSize: isBigScreen() ? 16 : 12,
              //           fontWeight: FontWeight.w400,
              //         ),
              //         border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(8),
              //           borderSide: BorderSide(color: Colors.grey, width: 1),
              //         ),
              //         enabledBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(8),
              //           borderSide: BorderSide(color: Colors.grey, width: 1),
              //         ),
              //         focusedBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(8),
              //           borderSide: BorderSide(color: Colors.blue, width: 2),
              //         ),
              //         fillColor: Utils().searchBar,
              //         filled: true,
              //       ),
              //     )
              //     ,),
              // ),
              SizedBox(width: MediaQuery.of(context).size.width*0.06,),
            ],
          ),
          SizedBox(height: 15,),
          Center(child: Text("Coming Soon...",style: TextStyle(color: Utils().text,fontWeight: FontWeight.w600,fontSize: 18),))
          // Expanded(
          //   child: LayoutBuilder(
          //     builder: (BuildContext context, BoxConstraints constraints) {
          //       return AdaptiveScrollbar(
          //         underSpacing: EdgeInsets.only(bottom: Get.width),
          //         controller: horizontalScroll,
          //         width: Get.width,
          //         position: ScrollbarPosition.bottom,
          //         sliderDecoration: BoxDecoration(
          //           color: Colors.grey,
          //           borderRadius: BorderRadius.all(Radius.circular(12.0)),
          //         ),
          //         sliderActiveDecoration: BoxDecoration(
          //           color: Color.fromRGBO(206, 206, 206, 1),
          //           borderRadius: BorderRadius.all(Radius.circular(12.0)),
          //         ),
          //         underColor: Colors.transparent,
          //         child: SingleChildScrollView(
          //           controller: horizontalScroll,
          //           scrollDirection: Axis.horizontal,
          //           child: ConstrainedBox(
          //             constraints: BoxConstraints(minWidth: constraints.maxWidth),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Container(
          //                   decoration: BoxDecoration(
          //                     gradient: LinearGradient(
          //                       colors: [
          //                         Utils().border_1,
          //                         Utils().button,
          //                       ],
          //                     ),
          //                   ),
          //                   child: DataTable(
          //                     dataRowMinHeight: 27,
          //                     dataRowMaxHeight: 27,
          //                     showCheckboxColumn: false,
          //                     columnSpacing: 5,
          //                     columns: [
          //                       DataColumn(
          //                         label: SizedBox(
          //                           width: isBigScreen()
          //                               ? (MediaQuery.of(context).size.width - 75) * 0.0350
          //                               : 55,
          //                           child: Center(
          //                             child: Text('ID',
          //                                 style: TextStyle(color: Colors.white),
          //                                 textAlign: TextAlign.center),
          //                           ),
          //                         ),
          //                       ),
          //                       DataColumn(
          //                         label: SizedBox(
          //                           width: isBigScreen()
          //                               ? (MediaQuery.of(context).size.width - 75) * 0.0400
          //                               : 55,
          //                           child: Center(
          //                             child: Text('Loans\nID',
          //                                 style: TextStyle(color: Colors.white),
          //                                 textAlign: TextAlign.center),
          //                           ),
          //                         ),
          //                       ),
          //                       DataColumn(
          //                         label: SizedBox(
          //                           width: isBigScreen()
          //                               ? (MediaQuery.of(context).size.width - 75) * 0.150
          //                               : 85,
          //                           child: Center(
          //                             child: Text('Name',
          //                                 style: TextStyle(color: Colors.white),
          //                                 textAlign: TextAlign.center),
          //                           ),
          //                         ),
          //                       ),
          //                       DataColumn(
          //                         label: SizedBox(
          //                           width: isBigScreen()
          //                               ? (MediaQuery.of(context).size.width - 75) * 0.0750
          //                               : 55,
          //                           child: Center(
          //                             child: Text('Debit Amount',
          //                                 style: TextStyle(color: Colors.white),
          //                                 textAlign: TextAlign.center),
          //                           ),
          //                         ),
          //                       ),
          //                       DataColumn(
          //                         label: SizedBox(
          //                           width: isBigScreen()
          //                               ? (MediaQuery.of(context).size.width - 75) * 0.0850
          //                               : 55,
          //                           child: Center(
          //                             child: Text('Interest Amount',
          //                                 style: TextStyle(color: Colors.white),
          //                                 textAlign: TextAlign.center),
          //                           ),
          //                         ),
          //                       ),
          //                       DataColumn(
          //                         label: SizedBox(
          //                           width: isBigScreen()
          //                               ? (MediaQuery.of(context).size.width - 75) * 0.0850
          //                               : 55,
          //                           child: Center(
          //                             child: Text('Credit Amount',
          //                                 style: TextStyle(color: Colors.white),
          //                                 textAlign: TextAlign.center),
          //                           ),
          //                         ),
          //                       ),
          //                       DataColumn(
          //                         label: SizedBox(
          //                           width: isBigScreen()
          //                               ? (MediaQuery.of(context).size.width - 75) * 0.0650
          //                               : 55,
          //                           child: Center(
          //                             child: Text('Date',
          //                                 style: TextStyle(color: Colors.white),
          //                                 textAlign: TextAlign.center),
          //                           ),
          //                         ),
          //                       ),
          //                     ],
          //                     rows: const [],
          //                   ),
          //                 ),
          //                 Flexible(
          //                   child: SingleChildScrollView(
          //                     child: DataTable(
          //                       border: TableBorder.all(
          //                         color: Colors.black12,
          //                         width: 1.0,
          //                       ),
          //                       dataRowMinHeight: 27,
          //                       dataRowMaxHeight: 27,
          //                       showCheckboxColumn: false,
          //                       columnSpacing: 5,
          //                       headingRowHeight: 0,
          //                       columns: List.generate(7,
          //                             (_) => DataColumn(
          //                           label: SizedBox(width: 0, height: 0),
          //                         ),
          //                       ),
          //                       rows: [
          //                         ...List.generate(
          //                           7, // fixed 9 rows
          //                               (index) {
          //                             // final payment = index < reportController.loanTransactionHistory.length
          //                             //     ? reportController.loanTransactionHistory[index]
          //                             //     : null;
          //                             // If you still want to fetch values safely from loanTransactionHistory
          //                             // make sure you check bounds
          //                             return DataRow(
          //                               cells: [
          //                                 DataCell(SizedBox(
          //                                     width: isBigScreen()
          //                                         ? (MediaQuery.of(context).size.width - 75) * 0.0350
          //                                         : 55,
          //                                     child: Center(child: Text('ID')))),
          //                                 DataCell(SizedBox(
          //                                     width: isBigScreen()
          //                                         ? (MediaQuery.of(context).size.width - 75) * 0.0400
          //                                         : 55,
          //                                     child: Center(child: Text('1234')))),
          //                                 DataCell(SizedBox(
          //                                     width: isBigScreen()
          //                                         ? (MediaQuery.of(context).size.width - 75) * 0.150
          //                                         : 85,
          //                                     child: Center(child: Text('Name')))),
          //                                 DataCell(SizedBox(
          //                                     width: isBigScreen()
          //                                         ? (MediaQuery.of(context).size.width - 75) * 0.0750
          //                                         : 55,
          //                                     child: Center(child: Text('1234567890')))),
          //                                 DataCell(SizedBox(
          //                                     width: isBigScreen()
          //                                         ? (MediaQuery.of(context).size.width - 75) * 0.0850
          //                                         : 55,
          //                                     child: Center(child: Text("₹1,00,0000")))),
          //                                 DataCell(SizedBox(
          //                                     width: isBigScreen()
          //                                         ? (MediaQuery.of(context).size.width - 75) * 0.0850
          //                                         : 55,
          //                                     child: Center(child: Text("₹1,00,0000")))),
          //                                 DataCell(SizedBox(
          //                                     width: isBigScreen()
          //                                         ? (MediaQuery.of(context).size.width - 75) * 0.0645
          //                                         : 80,
          //                                     child: Center(child: Text("11/01/2025")))),
          //                               ],
          //                             );
          //                           },
          //                         ),
          //                         // DataRow(
          //                         //   color: MaterialStateProperty.all(Colors.blue.shade50), // your custom color
          //                         //   cells: [
          //                         //     const DataCell(Text("")),
          //                         //     const DataCell(Text("")),
          //                         //     const DataCell(Center(child: Text("Total", style: TextStyle(fontWeight: FontWeight.bold)))),
          //                         //     DataCell(Center(child: Text("₹${_calculateEmiAmount()}"))),
          //                         //     DataCell(Center(child: Text("₹${_calculatePenalty()}"))),
          //                         //     DataCell(Center(child: Text("₹${_calculateOtherAmount()}"))),
          //                         //     const DataCell(Text("")),
          //                         //   ],
          //                         // ),
          //                       ],
          //
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
  bool isBigScreen(){
    return (MediaQuery.of(context).size.width > 700);
  }
}

