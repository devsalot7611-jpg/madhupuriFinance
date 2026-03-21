import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:madhupurifinance/Controller/HomeLoanController.dart';
import 'package:madhupurifinance/Controller/PayEmiController.dart';
import 'package:madhupurifinance/Controller/loansController.dart';
import 'package:madhupurifinance/HomeSacreen.dart';
import 'package:madhupurifinance/Utils.dart';
import 'package:get/get.dart';

class PayEmi extends StatefulWidget {
  const PayEmi({super.key});

  @override
  State<PayEmi> createState() => _PayEmiState();
}

class _PayEmiState extends State<PayEmi> {
  final PayEmiController payEmiController = Get.put(PayEmiController());
  final LoansController loansController = Get.put(LoansController());
  final HomeLoanController homeLoanController = Get.put(HomeLoanController());
  // bool iconDelete = false;
  @override
  void initState() {
    loansController.getLoans();
    // TODO: implement initState
    super.initState();
    Utils.activeIndex = Utils.PAY_EMI;
    // paymentRecvidEmi();
  }

  // void paymentRecvidEmi() async {
  //  await payEmiController.getPayment();
  // }

  List<dynamic> getFilterList(String query) {
    // (Optional) filter each list by `query` first
    final payments = payEmiController.paymentReceived;
    final loans    = loansController.loansData;

    // return one combined list
    return [...payments, ...loans];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils().background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 70,
              child: appBar(),
            ),
            Row(
              children: [
                SizedBox(width: 20,),
                Text("EMIs",style: TextStyle(
                  fontSize: isBigScreen() ? 22 : 16,
                  fontWeight: FontWeight.bold,
                  color: Utils().text,
                ),),
              ],
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: GetBuilder<PayEmiController>(
                builder: (c) => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: DataTable(
                        columnSpacing: 11,
                        border: TableBorder.all(
                          color: Colors.black12,
                          width: 1.0,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        columns: [
                          DataColumn(
                            label: SizedBox(
                              width: 35,
                              child: Text(
                                "Action",
                                style: TextStyle(color: Utils().text, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataColumn(label: SizedBox(width: 50, child: Center(child: Text("Loan ID", style: TextStyle(color: Utils().text, fontSize: 12))))),
                          DataColumn(label: SizedBox(width: 50, child: Center(child: Text("KYC ID", style: TextStyle(color: Utils().text, fontSize: 12))))),
                          DataColumn(label: SizedBox(width: 200, child: Center(child: Text("Name", style: TextStyle(color: Utils().text, fontSize: 12))))),
                          DataColumn(label: SizedBox(width: 70, child: Center(child: Text("Loan Date", style: TextStyle(color: Utils().text, fontSize: 12))))),
                          DataColumn(label: SizedBox(width: 85, child: Center(child: Text("Loan Amount", style: TextStyle(color: Utils().text, fontSize: 12))))),
                          DataColumn(label: SizedBox(width: 80, child: Center(child: Text("Old Paid Emi", style: TextStyle(color: Utils().text, fontSize: 12))))),
                          DataColumn(label: SizedBox(width: 90, child: Center(child: Text("Old Pending Emi", style: TextStyle(color: Utils().text, fontSize: 12))))),
                          DataColumn(label: SizedBox(width: 70, child: Center(child: Text("Emi Paid", style: TextStyle(color: Utils().text, fontSize: 12))))),
                          DataColumn(label: SizedBox(width: 50, child: Center(child: Text("Penalty", style: TextStyle(color: Utils().text, fontSize: 12))))),
                          DataColumn(label: SizedBox(width: 90, child: Center(child: Text("Other Amount", style: TextStyle(color: Utils().text, fontSize: 12))))),
                          DataColumn(label: SizedBox(width: 110, child: Center(child: Text("Last Payment Date", style: TextStyle(color: Utils().text, fontSize: 12))))),
                        ],
                        rows: List.generate(
                          c.rows.length,
                              (index) {
                            final m = c.rows[index];
                            return DataRow(cells: [
                              DataCell(
                                Obx(() => Visibility(
                                  visible: c.idVisibilityList[index].value,
                                  child: SizedBox(
                                    width: 35,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.delete_outline_outlined,
                                          color: Colors.red),
                                      onPressed: () {
                                        c.rows.removeAt(index);
                                        c.idVisibilityList.removeAt(index);
                                        c.update();
                                      },
                                    ),
                                  ),
                                )),
                              ),
                              DataCell(
                                Obx(() => SizedBox(
                                  width: 45,
                                  child: TextFormField(
                                    controller: m['emiLoanId'],
                                    style: const TextStyle(fontSize: 12),
                                    textCapitalization: TextCapitalization.characters,
                                    textInputAction: TextInputAction.done,
                                    readOnly: c.idVisibilityList[index].value,
                                    onEditingComplete: () async {
                                      if (m['emiLoanId']!.text.trim().isEmpty) return;
                                      await c.fillRow(index);
                                      c.addRowIfComplete(index);
                                    },
                                    decoration: const InputDecoration(border: InputBorder.none),
                                  ),
                                )),
                              ),
                              DataCell(SizedBox(
                                width: 38,
                                child: TextField(
                                  controller: m['emiKycId'],
                                  readOnly: true,
                                  style: const TextStyle(fontSize: 12),
                                  decoration: const InputDecoration(border: InputBorder.none),
                                ),
                              )),
                              DataCell(
                                SizedBox(
                                  width: 200,
                                  child: TypeAheadField(
                                    controller: m['emiName'], // Name controller
                                    builder: (context, controller, focusNode) {
                                      return TextFormField(
                                        onChanged: (value) {
                                          setState(() {
                                            loansController.runFilter(value);
                                          });
                                        },
                                        controller: controller,
                                        focusNode: focusNode,
                                        style: const TextStyle(fontSize: 12),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      );
                                    },
                                    itemBuilder: (context, value) {
                                      return Container(
                                        color: Colors.white,
                                        child: ListTile(
                                          title: Text(
                                            "${value["name"]}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "Loan ID: ${value["id"]} | KYC: ${value["kyc_id"]}",
                                            style: const TextStyle(fontSize: 11),
                                          ),
                                        ),
                                      );
                                    },
                                    onSelected: (value) async {
                                      m['emiName']?.text          = value["name"].toString();
                                      m['emiLoanId']?.text        = value["id"].toString();
                                      m['emiKycId']?.text         = value["kyc_id"].toString();
                                      m['emiLoanDate']?.text      = value["loan_date"].toString();
                                      m['emiLoanAmount']?.text    = value["principal_amount"].toString();
                                      m['emiOldPaidEmi']?.text    = value["old_paid_emi"].toString();
                                      m['emiOldPendingEmi']?.text = value["old_pending_emi"].toString();
                                      m['emiLastPaymentDate']?.text = value["last_payment_date"].toString();

                                      final rowIndex = c.rows.indexOf(m);
                                      await c.fillRow(rowIndex);
                                      c.addRowIfComplete(rowIndex);
                                    },
                                    suggestionsCallback: (v) {
                                      if(v.length < 2) {
                                        return null;
                                      }
                                      else{
                                        return getFilterList(v);
                                      }
                                    },
                                  ),
                                ),
                              ),

                              DataCell(SizedBox(
                                width: 70,
                                child: TextField(
                                  controller: m['emiLoanDate'],
                                  readOnly: true,
                                  style: const TextStyle(fontSize: 12),
                                  decoration: const InputDecoration(border: InputBorder.none),
                                ),
                              )),
                              DataCell(SizedBox(
                                width: 75,
                                child: TextField(
                                  controller: m['emiLoanAmount'],
                                  readOnly: true,
                                  style: const TextStyle(fontSize: 12),
                                  decoration: const InputDecoration(border: InputBorder.none),
                                ),
                              )),
                              DataCell(SizedBox(
                                width: 70,
                                child: TextField(
                                  controller: m['emiOldPaidEmi'],
                                  readOnly: true,
                                  style: const TextStyle(fontSize: 12),
                                  decoration: const InputDecoration(border: InputBorder.none),
                                ),
                              )),
                              DataCell(SizedBox(
                                width: 88,
                                child: TextField(
                                  controller: m['emiOldPendingEmi'],
                                  readOnly: true,
                                  style: const TextStyle(fontSize: 12),
                                  decoration: const InputDecoration(border: InputBorder.none),
                                ),
                              )),
                              DataCell(SizedBox(
                                width: 68,
                                child: TextFormField(
                                  controller: m['emiPayEmiAmount'],
                                  style: const TextStyle(fontSize: 12),
                                  decoration: const InputDecoration(border: InputBorder.none),
                                ),
                              )),
                              DataCell(SizedBox(
                                width: 40,
                                child: TextFormField(
                                  controller: m['emiPenalty'],
                                  style: const TextStyle(fontSize: 12),
                                  decoration: const InputDecoration(border: InputBorder.none),
                                ),
                              )),
                              DataCell(SizedBox(
                                width: 90,
                                child: TextFormField(
                                  controller: m['emiOtherAmount'],
                                  style: const TextStyle(fontSize: 12),
                                  decoration: const InputDecoration(border: InputBorder.none),
                                ),
                              )),
                              /* Paid‑Date cell */
                              DataCell(
                                Obx(() => Visibility(
                                  visible: c.idVisibilityList[index].value,
                                  child: SizedBox(
                                    width: 110,
                                    child: TextFormField(
                                      controller: m['emiPaidDate'],
                                      style: const TextStyle(fontSize: 12),
                                      decoration: const InputDecoration(
                                        hintText: 'dd/MM/yyyy',
                                        border: InputBorder.none,
                                      ),
                                      keyboardType: TextInputType.datetime,
                                      onTap: () {
                                        // Show default date if field is empty when tapped
                                        if (m['emiPaidDate']!.text.trim().isEmpty) {
                                          final today = DateTime.now();
                                          m['emiPaidDate']!.text = DateFormat('dd/MM/yyyy').format(today);
                                        }
                                      },
                                      onChanged: (val) {
                                        if (val.trim().length == 10) {
                                          try {
                                            DateTime parsed;

                                            if (val.contains('/')) {
                                              parsed = DateFormat('dd/MM/yyyy').parseStrict(val);
                                            } else {
                                              parsed = DateFormat('dd-MM-yyyy').parseStrict(val);
                                            }

                                            final formatted = DateFormat('dd/MM/yyyy').format(parsed);

                                            if (m['emiPaidDate']!.text != formatted) {
                                              m['emiPaidDate']!.text = formatted;
                                              m['emiPaidDate']!.selection = TextSelection.fromPosition(
                                                TextPosition(offset: m['emiPaidDate']!.text.length),
                                              );
                                            }

                                          } catch (e) {
                                            // print("Invalid date input: $val");
                                          }
                                        }
                                      },
                                      onEditingComplete: () => c.addRowIfComplete(index),
                                    ),
                                  ),
                                )),
                              ),
                            ]);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          final rowsToRemove = <int>[]; // collect indices to delete
                          bool atLeastOneSent = false;
        
                          for (var i = 0; i < payEmiController.rows.length; i++) {
                            final row = payEmiController.rows[i];

                            if (row['emiLoanId']!.text.trim().isEmpty) continue;

                            if (row['emiPayEmiAmount']!.text.trim().isEmpty) continue;
        
                            atLeastOneSent = true;

                            if (row['emiPenalty']!    .text.trim().isEmpty) row['emiPenalty']!    .text = '0';
                            if (row['emiOtherAmount']!.text.trim().isEmpty) row['emiOtherAmount']!.text = '0';

                            final ok = await payEmiController.emiPayment(i);
                            if (ok) rowsToRemove.add(i);
                          }
                          for (final idx in rowsToRemove.reversed) {
                            payEmiController.rows.removeAt(idx);
                            payEmiController.idVisibilityList.removeAt(idx);
                          }
        
                          // 6️⃣ ensure there's always at least one blank row
                          if (rowsToRemove.isNotEmpty) {
                            if (payEmiController.rows.isEmpty ||
                                payEmiController.rows.last['emiLoanId']!.text.trim().isNotEmpty) {
                              payEmiController.addBlankRow(); // ✅ fixed
                            }
                            payEmiController.update(); // refresh table
                          }
        
                          // 7️⃣ toasts
                          if (!atLeastOneSent) {
                            // Get.snackbar("Nothing sent", "Enter Emi Paid before submitting.");
                          } else if (rowsToRemove.isEmpty) {
                            // Get.snackbar("Error", "API failed for every row.");
                          } else {
                            Get.snackbar("Success", "Submitted",
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
                          }
                        },
        
                        child: Container(
                          height: 40,
                          width: isBigScreen() ? 180 : 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                            gradient: LinearGradient(
                              colors: [Utils().border_1, Utils().button],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Add bulk payment entry",
                              style: TextStyle(
                                color: Utils().background,
                                fontWeight: FontWeight.bold,
                                fontSize: isBigScreen() ? 14 : 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5,),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          payEmiController.iconDelete = false.obs;
                        });
                        payEmiController.resetAll(); }, // 🔹 clear all values
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          gradient: LinearGradient(colors: [
                            Utils().border_1,
                            Utils().button,
                          ]),
                        ),
                        child: Icon(
                          Icons.refresh_rounded,
                          color: Utils().background,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
  bool isBigScreen(){
    return (MediaQuery.of(context).size.width > 700);
  }
}
