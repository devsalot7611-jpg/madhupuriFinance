import 'dart:math';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:madhupurifinance/Controller/FormController.dart';
import 'package:madhupurifinance/Controller/KycListController.dart';
import 'package:madhupurifinance/Controller/PayEmiController.dart';
import 'package:madhupurifinance/Controller/loansController.dart';
import 'package:madhupurifinance/HomeSacreen.dart';
import 'package:madhupurifinance/MobilPayEmi.dart';
import 'package:madhupurifinance/PayEmiReceipt.dart';
import 'package:madhupurifinance/Utils.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:madhupurifinance/loansPdf.dart';
import 'package:madhupurifinance/mobileAddLoan.dart';
import 'PdfRawData.dart';
import 'mobilEditLoan.dart';

class Loans extends StatefulWidget {
  final Map<String, dynamic> loans;
  const Loans({super.key, required this.loans});

  @override
  State<Loans> createState() => _LoansState();
}

class _LoansState extends State<Loans> {
  List<List<String>> emiScheduleRows = [];
  int getEmiScheduleRows() {
    emiScheduleRows.clear();

    final start = DateTime.parse(loansController.emiStartDate!);
    final end = DateTime.parse(loansController.emiEndDate!);
    final int duration = int.tryParse(loansController.duration.toString()) ?? 0;
    final emiAmt = loansController.emiAmount.toString();
    DateTime currentDate = addMonthSafe(start); // next month start

    for (int i = 0; i < duration && (currentDate.isBefore(end) || currentDate.isAtSameMomentAs(end)); i++) {
      final date = DateFormat('dd-MM-yyyy').format(currentDate);
      emiScheduleRows.add([
        date,
        emiAmt,
        '', '',
      ]);
      currentDate = addMonthSafe(currentDate);
    }

    return emiScheduleRows.length;
  }

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

  final LoansController loansController = Get.put(LoansController());
  final FormController formController = Get.put(FormController());
  final PayEmiController payEmiController = Get.put(PayEmiController());
  final PayEmiReceipt payEmiReceipt = Get.put(PayEmiReceipt());
  final double width = 10;
  final ScrollController horizontalScroll = ScrollController();
  bool downloadIndicators = false;
  final KycListController kycListController = Get.put(KycListController());
  bool loanPdf = false;
  bool loanPdfEmpty = false;
  var selectIndex;
  var payIndex;
  var pdfIndex;
  // double emiResult = 0.0;

  double calculateEmi(double principal, double annualRate, int months) {
    if (principal <= 0 || annualRate <= 0 || months <= 0) return 0;

    if (annualRate < 3) {
      annualRate *= 12;
    }

    double monthlyRate = annualRate / 12 / 100;
    double emi = monthlyRate*principal;
    emi+=principal/months;
    // double emi = (principal * monthlyRate * (pow(1 + monthlyRate, months))) /
    (pow(1 + monthlyRate, months) - 1);
    return emi;
  }

  void updateEmi() {
    double principleAmount = double.tryParse(loansController.totalAmount.text) ?? 0;
    double interest = double.tryParse(loansController.interest.text) ?? 0;
    int months = int.tryParse(loansController.durationEmi.text) ?? 0;

    if (principleAmount > 0 && interest > 0 && months > 0) {
      setState(() {
        loansController.emiResult = calculateEmi(principleAmount, interest, months);
      });
    } else {
      setState(() {
        loansController.emiResult = 0;
      });
    }
  }


  double calculateInterest(double principal, double interest) {
    if (principal <= 0 || interest <= 0) return 0;
    return principal * (interest / 100);
  }

  void updateInterest() {
    double principleAmount = double.tryParse(loansController.totalAmount.text) ?? 0;
    double interest = double.tryParse(loansController.interest.text) ?? 0;

    if (principleAmount > 0 && interest > 0) {
      setState(() {
        loansController.emiResult = calculateInterest(principleAmount, interest);
      });
    } else {
      setState(() {
        loansController.emiResult = 0;
      });
    }
  }

  // double calculateInterest({
  //   required double principal,
  //   required double annualRate,
  //   required int month,
  // }) {
  //   double monthlyRate = annualRate / 12 / 100;
  //   return principal * monthlyRate * month;
  // }
  //
  // void updateInterest() {
  //   double principle = double.tryParse(loansController.totalAmount.text) ?? 0;
  //   double annualRate = double.tryParse(loansController.interest.text) ?? 0;
  //   int months = int.tryParse(loansController.durationEmi.text) ?? 0;
  //
  //   if (principle > 0 && annualRate > 0 && months > 0) {
  //     setState(() {
  //       loansController.emiResult = calculateInterest(
  //         principal: principle,
  //         annualRate: annualRate,
  //         month: months,
  //       );
  //     });
  //   } else {
  //     setState(() {
  //       loansController.emiResult = 0;
  //     });
  //   }
  // }

  void initMethodCalling() async{
    setState(() {
      loansController.loansData.clear();
      loansController.loans.clear();
    });
    await loansController.getLoans();
    setState(() {
      // Utils.loans = true;
      loansController.editKycStoreId = widget.loans['id'].toString();
      loansController.loansId.text = widget.loans['kyc_id'].toString();
      loansController.totalAmount.text = widget.loans['principal_amount'].toString();
      loansController.durationEmi.text = widget.loans['tenure'].toString();
      loansController.monthEmi.text = widget.loans['emi_amount'].toString();
      loansController.loansDate.text = widget.loans['loan_date'].toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loansController.totalAmount.addListener(updateEmi);
    loansController.interest.addListener(updateEmi);
    loansController.durationEmi.addListener(updateEmi);
    Utils.activeIndex = Utils.LOANS;
    initMethodCalling();

    payEmiController.paymentDate = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(DateTime.now()),

    );
  }
  // void dispose() {
  //   loansController.totalAmount.addListener(updateEmi);
  //   loansController.interest.addListener(updateEmi);
  //   loansController.durationEmi.addListener(updateEmi);
  //   payEmiController.paymentDate.dispose();
  //   super.dispose();
  // }
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: payEmiController.devSelectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      payEmiController.devSelectedDate = picked;                   // store raw date
      payEmiController.paymentDate.text =
          DateFormat('dd-MM-yyyy').format(picked);            // update field
    }
  }


  Future<void> pickLoanDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      loansController.selectedLoanDate = picked;
      loansController.loansDate.text = DateFormat('dd-MM-yyyy').format(picked);
    }
  }
  List getFilterList(String query) {
    return formController.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils().background,
      body: Column(
        children: [
          SizedBox(
            height: 70,
            child: appBar(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("LOANs",style: TextStyle(
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
                    controller: formController.searchController,
                    onChanged: (value) {
                      setState(() {
                        loansController.runFilter(value);
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
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      // loansController.selectValue = null;
                      loansController.loansId.clear();
                      loansController.loanName.clear();
                      loansController.totalAmount.clear();
                      loansController.durationEmi.clear();
                      loansController.monthEmi.clear();
                      loansController.downPayment.clear();
                      loansController.loansDate.clear();
                      loansController.serviceFees.clear();
                      loansController.interest.clear();
                      String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
                      loansController.loansDate.text = formattedDate;
                      loansController.selectValue ??= "regular";

                      if(Get.width > 700) {
                        Get.dialog(
                            StatefulBuilder(builder: (context, setState) {
                              // loansController.selectValue = "regular";
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  // height: 270,
                                  width: 800,
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Utils().background,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Center(
                                              child: Text(
                                                "Loans Information",
                                                style: TextStyle(color: Utils().text,fontSize: 18,fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                loansController.loansId.clear();
                                                loansController.loanName.clear();
                                                loansController.totalAmount.clear();
                                                loansController.durationEmi.clear();
                                                loansController.monthEmi.clear();
                                                loansController.loansDate.clear();
                                                loansController.serviceFees.clear();
                                                loansController.interest.clear();
                                                Navigator.pop(context);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: 20,top: 5),
                                                child: Container(
                                                    height: 30,
                                                    width: 30,
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          width: 1,
                                                          color: Utils().button,
                                                        )
                                                    ),
                                                    child: Icon(Icons.close,color: Colors.white,)
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(),
                                        Form(
                                            key: loansController.loansKey,
                                            child:  Padding(
                                              padding: const EdgeInsets.only(left: 14),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    spacing: 10,
                                                    children: [
                                                      SizedBox(
                                                        width: 170,
                                                        child: RadioListTile(
                                                            contentPadding: EdgeInsets.zero,
                                                            title: Text("Regular Loan",style: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 12,
                                                                color: Utils().border_1
                                                            ),),
                                                            value: "regular",
                                                            groupValue: loansController.selectValue,
                                                            onChanged: (value){
                                                              updateEmi();
                                                              setState((){
                                                                loansController.selectValue = value;
                                                              });
                                                            }),
                                                      ),
                                                      SizedBox(
                                                        width : 120,
                                                        child: RadioListTile(
                                                          title: Text("Interest Only",style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 12,
                                                              color: Utils().border_1
                                                          ),),
                                                          value: "interest-only",
                                                          groupValue: loansController.selectValue,
                                                          onChanged: (value){
                                                            updateInterest();
                                                            setState((){
                                                              loansController.selectValue = value;
                                                            });
                                                          },
                                                          contentPadding: EdgeInsets.zero,
                                                        ),
                                                      ),

                                                      SizedBox(
                                                        width: 330,
                                                        child: TypeAheadField(
                                                          controller: loansController.loanName,
                                                          builder: (context, controller, focusNode) {
                                                            return TextFormField(
                                                              focusNode: focusNode,
                                                              textCapitalization: TextCapitalization.characters,
                                                              onChanged: (value)  {
                                                                setState(() {
                                                                  loansController.runFilterLoanName(value);
                                                                });
                                                              },
                                                              validator: (value) {
                                                                if (value == null || value.isEmpty) {
                                                                  return 'Requried this field';
                                                                }
                                                                return null; // validation passed
                                                              },
                                                              controller: controller,
                                                              decoration: InputDecoration(
                                                                labelText: "Full Name",
                                                                labelStyle: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Utils().border_1,
                                                                ),
                                                                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  borderSide: BorderSide(
                                                                    color: Utils().border_1,
                                                                    width: 1.5,
                                                                  ),
                                                                ),
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  borderSide: BorderSide(
                                                                    color: Utils().border_1,
                                                                    width: 1.5,
                                                                  ),
                                                                ),
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  borderSide: BorderSide(
                                                                    color: Utils().button,
                                                                    width: 2,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          itemBuilder: (context, value) {
                                                            return Container(
                                                              color: Colors.white,
                                                              height: 40,
                                                              width: 250,
                                                              child: ListTile(
                                                                title: Row(
                                                                  children: [
                                                                    Text(value["id"].toString(),style: TextStyle(fontSize: 12,color: Utils().text,fontWeight: FontWeight.bold),),
                                                                    SizedBox(width: 5,),
                                                                    Expanded(child: Text("${value["first_name"].toString()} ${value["middle_name"].toString()} ${value["last_name"].toString()}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Utils().text),)),
                                                                  ],
                                                                ),
                                                                // subtitle: Text(value["id"].toString(),style: TextStyle(fontSize: 12),),
                                                              ),
                                                            );
                                                          },
                                                          onSelected: (value) {
                                                            final fullName = "${value["first_name"].toString()} ${value["middle_name"].toString()} ${value["last_name"].toString()}";
                                                            loansController.loanName.text = fullName.toString();
                                                            loansController.loansId.text = value["id"].toString().toString();
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
                                                      SizedBox(
                                                        width: 80,
                                                        child: TextFormField(
                                                          readOnly: true,
                                                          keyboardType: TextInputType.number,
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter.digitsOnly, // Allows only digits
                                                            LengthLimitingTextInputFormatter(10),   // Optional: Limit to 10 digits
                                                          ],
                                                          validator: (value) {
                                                            if (value == null || value.isEmpty) {
                                                              return 'Requried this field';
                                                            }
                                                            return null; // validation passed
                                                          },
                                                          controller: loansController.loansId,
                                                          decoration: InputDecoration(
                                                            labelText: "KYC ID",
                                                            labelStyle: TextStyle(
                                                              fontSize: 12,
                                                              color: Utils().border_1,
                                                            ),
                                                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                              borderSide: BorderSide(
                                                                color: Utils().border_1,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                              borderSide: BorderSide(
                                                                color: Utils().border_1,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                              borderSide: BorderSide(
                                                                color: Utils().button,
                                                                width: 2,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 20,),
                                                  Row(
                                                    spacing: 10,
                                                    children: [
                                                      SizedBox(
                                                        width:  150,
                                                        child: TextFormField(
                                                          onChanged: (value) {
                                                            try {
                                                              loansController.selectedLoanDate = DateFormat('dd-MM-yyyy').parseStrict(value);
                                                            } catch (e) {
                                                              loansController.selectedLoanDate = DateTime.now(); // fallback
                                                              // print("Invalid date format entered: $e");
                                                            }
                                                          },
                                                          validator: (value) {
                                                            if (value == null || value.isEmpty) {
                                                              return 'Requried this field';
                                                            }
                                                            return null; // validation passed
                                                          },
                                                          controller: loansController.loansDate,
                                                          decoration: InputDecoration(
                                                            labelText: "loan date",
                                                            labelStyle: TextStyle(
                                                              fontSize: 12,
                                                              color: Utils().border_1,
                                                            ),
                                                            suffixIcon: IconButton(onPressed: (){
                                                              pickLoanDate(context);
                                                            }, icon: Icon(Icons.calendar_month_outlined,color: Utils().border_1,)),
                                                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                              borderSide: BorderSide(
                                                                color: Utils().border_1,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                              borderSide: BorderSide(
                                                                color: Utils().border_1,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                              borderSide: BorderSide(
                                                                color: Utils().button,
                                                                width: 2,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 135,
                                                        child: TextFormField(
                                                          controller: loansController.totalAmount,
                                                          keyboardType: TextInputType.number,
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter.digitsOnly,
                                                            LengthLimitingTextInputFormatter(10),
                                                          ],
                                                          validator: (value) {
                                                            if (value == null || value.isEmpty) {
                                                              return 'Required this field';
                                                            }
                                                            return null;
                                                          },
                                                          onChanged: (val) {
                                                            setState(() {
                                                              if (loansController.selectValue == "interest-only") {
                                                                updateInterest();
                                                              } else if (loansController.selectValue == "regular") {
                                                                updateEmi();
                                                              }
                                                            });
                                                          },

                                                          decoration: InputDecoration(
                                                            labelText: "Principal amount",
                                                            labelStyle: TextStyle(fontSize: 12, color: Utils().border_1),
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
                                                      SizedBox(
                                                        width: 120,
                                                        child: TextFormField(
                                                          controller: loansController.interest,
                                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                          inputFormatters: [
                                                            // Allow only digits and one decimal point
                                                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                                                          ],
                                                          validator: (value) {
                                                            if (value == null || value.isEmpty) {
                                                              return 'Required this field';
                                                            }
                                                            return null;
                                                          },
                                                          onChanged: (val) {
                                                            setState(() {
                                                              if (loansController.selectValue == "interest-only") {
                                                                updateInterest();
                                                              } else if (loansController.selectValue == "regular") {
                                                                updateEmi();
                                                              }
                                                            });
                                                          },

                                                          decoration: InputDecoration(
                                                            labelText: "Interest/Month",
                                                            labelStyle: TextStyle(fontSize: 12, color: Utils().border_1),
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
                                                      SizedBox(
                                                        width: 85,
                                                        child: TextFormField(
                                                          controller: loansController.durationEmi,
                                                          keyboardType: TextInputType.number,
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter.digitsOnly,
                                                            LengthLimitingTextInputFormatter(10),
                                                          ],
                                                          validator: (value) {
                                                            if (value == null || value.isEmpty) {
                                                              return 'Required this field';
                                                            }
                                                            return null;
                                                          },
                                                          onChanged: (val) {
                                                            setState(() {
                                                              if (loansController.selectValue == "interest-only") {
                                                                updateInterest();
                                                              } else if (loansController.selectValue == "regular") {
                                                                updateEmi();
                                                              }
                                                            });
                                                          },
                                                          decoration: InputDecoration(
                                                            labelText: "Duration",
                                                            labelStyle: TextStyle(fontSize: 12, color: Utils().border_1),
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
                                                      SizedBox(
                                                        width: 105,
                                                        child: TextFormField(
                                                          keyboardType: TextInputType.number,
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter.digitsOnly, // Allows only digits
                                                            LengthLimitingTextInputFormatter(10),   // Optional: Limit to 10 digits
                                                          ],
                                                          validator: (value) {
                                                            if (value == null || value.isEmpty) {
                                                              return 'Requried this field';
                                                            }
                                                            return null; // validation passed
                                                          },
                                                          controller: loansController.serviceFees,
                                                          decoration: InputDecoration(
                                                            labelText: "service fees",
                                                            labelStyle: TextStyle(
                                                              fontSize: 12,
                                                              color: Utils().border_1,
                                                            ),
                                                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                              borderSide: BorderSide(
                                                                color: Utils().border_1,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                              borderSide: BorderSide(
                                                                color: Utils().border_1,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                              borderSide: BorderSide(
                                                                color: Utils().button,
                                                                width: 2,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:  80,
                                                        child: TextFormField(
                                                          keyboardType: TextInputType.number,
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter.digitsOnly, // Allows only digits
                                                            LengthLimitingTextInputFormatter(10),   // Optional: Limit to 10 digits
                                                          ],
                                                          validator: (value) {
                                                            if (value == null || value.isEmpty) {
                                                              return 'Requried this field';
                                                            }
                                                            return null; // validation passed
                                                          },
                                                          controller: loansController.downPayment,
                                                          decoration: InputDecoration(
                                                            labelText: "Down Payment",
                                                            labelStyle: TextStyle(
                                                              fontSize: 12,
                                                              color: Utils().border_1,
                                                            ),
                                                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                              borderSide: BorderSide(
                                                                color: Utils().border_1,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                              borderSide: BorderSide(
                                                                color: Utils().border_1,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                              borderSide: BorderSide(
                                                                color: Utils().button,
                                                                width: 2,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 15,),
                                                  Row(
                                                    spacing: 45,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text("EMI Amount",style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.orange,
                                                      ),),
                                                      loansController.selectValue == "interest-only" ? Text("Loan Amount",style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.green,
                                                      ),) : SizedBox()
                                                    ],
                                                  ),
                                                  SizedBox(height: 8,),
                                                  Row(
                                                    spacing: 10,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        height: 45,
                                                        width: 120,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(10),
                                                          border: Border.all(
                                                            color: Utils().border_1,
                                                            width: 1.5,
                                                          ),
                                                        ),
                                                        child:  Center(
                                                          child: Text(
                                                            "₹${loansController.emiResult.round()}",
                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.orange),
                                                          ),
                                                        ),
                                                      ),
                                                      loansController.selectValue == "interest-only" ?  Text("+",style: TextStyle(
                                                          fontSize: 14, fontWeight: FontWeight.bold,color: Utils().text
                                                      ),) : SizedBox(),
                                                      loansController.selectValue == "interest-only" ?  Center(
                                                        child: Container(
                                                          height: 45,
                                                          width: 120,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            border: Border.all(
                                                              color: Utils().border_1,
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                          child:  Center(
                                                            child: Text(
                                                              "₹${loansController.totalAmount.text.toString()}",
                                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.green),
                                                            ),
                                                          ),
                                                        ),
                                                      ) : SizedBox(),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )),
                                        SizedBox(height: 10,),
                                        Center(
                                          child: GestureDetector(
                                            onTap: () async {
                                              if(loansController.loansKey.currentState!.validate()){
                                                setState(() {
                                                  loansController.addLoans.value = true;
                                                });

                                                await loansController.CreateLoan(context);
                                                await loansController.getLoans();

                                                setState(() {
                                                  loansController.addLoans.value = false;
                                                });
                                              }
                                            },
                                            child: Obx(
                                                  () => Container(
                                                height: 35,
                                                width:  MediaQuery.of(context).size.width * 0.105,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Utils().border_1,
                                                      Utils().button,
                                                    ],
                                                  ),
                                                ),
                                                child: Center(
                                                  child: loansController.addLoans.value
                                                      ? SizedBox(
                                                    height: 18,
                                                    width: 18,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Utils().background,
                                                    ),
                                                  )
                                                      : Text(
                                                    "Save",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Utils().background,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },)
                        );
                      }
                      else{
                        loansController.loansId.clear();
                        loansController.loanName.clear();
                        loansController.totalAmount.clear();
                        loansController.durationEmi.clear();
                        loansController.monthEmi.clear();
                        loansController.loansDate.clear();
                        loansController.downPayment.clear();
                        Get.to(MobileAddLoan(),transition: Transition.noTransition);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          colors: [Utils().border_1, Utils().button],
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.add, color: Utils().addKyc, size: isBigScreen() ? 14 : 12),
                            Text(
                              "Add Loan",
                              style: TextStyle(
                                fontSize: isBigScreen() ? 14 : 12,
                                fontWeight: FontWeight.w500,
                                color: Utils().addKyc,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  GestureDetector(
                    onTap: () async {

                      await kycListController.FomrNumber();
                      setState(() {
                        loanPdfEmpty = true;});
                      await LoansPdf().generateLoansPDF(null);
                      setState(() {
                        loanPdfEmpty = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          colors: [Utils().border_1, Utils().button],
                        ),
                      ),
                      child: loanPdfEmpty ? CircularProgressIndicator(
                        strokeWidth: 1,
                        color: Utils().background,
                      ) : Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.download, color: Utils().addKyc, size: isBigScreen() ? 14 : 12),
                            Text(
                              "Loan Form",
                              style: TextStyle(
                                fontSize: isBigScreen() ? 14 : 12,
                                fontWeight: FontWeight.w500,
                                color: Utils().addKyc,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 5,),

          loansController.loans.isEmpty ? Center(
            child: loansController.errorMessageLoan.value.isEmpty?CircularProgressIndicator():Text(loansController.errorMessageLoan.value,style: TextStyle(color: Colors.red),),
          )
              : loansController.loansData.isEmpty?Center(
            child: Center(
              child: Text("No KYC found similar to your search."),
            ),
          ) : Expanded(
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return AdaptiveScrollbar(
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
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0300:55,child: Center(child: Text('ID',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.150:150,child: Center(child: Text('Name',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.060:85,child: Center(child: Text('Loan\nAmount',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.030:95,child: Center(child: Text('INT',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0600:95,child: Center(child: Text('Interest\nAMT',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.050:95,child: Center(child: Text('Down\nPayment',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.050:95,child: Center(child: Text('Service\nFees',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0440:55,child: Center(child: Text('Duration',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.060:80,child: Center(child: Text('Emi\nAmount',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.060:80,child: Center(child: Text('Loan\nType',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0600:80,child: Center(child: Text('Emi\nPending',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0600:85,child: Center(child: Text('Paid\nAmount',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0740:90,child: Center(child: Text('Last\nPayment Date',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0600:80,child: Center(child: Text('Loan Date',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0740:80,child: Center(child: Text('Close/Due\nDate',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0500:80,child: Center(child: Text('Status',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)))),
                                    DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0800:84,child: Center(child: Text('Action',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)))),
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
                                    columns: List.generate(17,
                                          (_) => DataColumn(
                                        label: SizedBox(width: 0, height: 0),
                                      ),
                                    ), rows: [
                                  ...List.generate(loansController.loansData.length, (index) {
                                    final loansdata = loansController.loansData[index];
                                    final amount = loansdata['principal_amount'];   // int or double
                                    final emiAmount = loansdata['emi_amount'];
                                    final emiPending = loansdata['emi_pending'];
                                    final emi_paid = loansdata['emi_paid'];
                                    final emiPaid = NumberFormat.currency(
                                      locale: 'en_IN',   // Indian grouping: 12,34,56,789
                                      symbol: '₹',
                                      decimalDigits: 0,  // keep 2 if you need paise
                                    ).format(emi_paid);
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
                                    loansController.loansData[index]["last_payment_date"];
                                    loansController.editKycStoreId = loansController.loansData[index]['id'];
                                    payEmiController.emiNewLoansID = loansController.loansData[index]['id'];
                                    loansController.emiStartDate = loansController.loansData[index]['loan_date'];
                                    loansController.emiEndDate = loansController.loansData[index]['emi_due_date'];
                                    loansController.paymentDate = loansController.loansData[index]['last_payment_date'];
                                    loansController.closeDate = loansController.loansData[index]['closing_date'];
                                    final loanAmount = double.tryParse(loansdata['principal_amount'].toString()) ?? 0.0;
                                    final amountEmi = double.tryParse(loansdata['emi_amount'].toString()) ?? 0.0;
                                    final tenure = int.tryParse(loansdata['tenure'].toString()) ?? 0;

                                    final regularLoans = (amountEmi * tenure) - loanAmount;
                                    final interestLoan = (amountEmi * tenure);
                                    final interestOnly = amount + emiPending;
                                    // print(" loansController.closeDate = loansController.loansData[index]['closing_date'];");
                                    // print(loansController.loansData[index]['closing_date'].toString());
                                    // print("loansController.last_payment ${loansController.loansData[index]}");
                                    // print("Date view${loansController.loansData[index]['loan_date']}");
                                    // print("end Date view${loansController.loansData[index]['emi_due_date']}");
                                    // print("last_payment_date Date view${loansController.loansData[index]['last_payment_date']}");
                                    return DataRow(cells: [
                                      DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0300:55,child: Center(child: Text(loansdata['id'].toString(),style: TextStyle(fontSize: 12,color: Utils().text),textAlign: TextAlign.center,)))),
                                      DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.150:150, child: Center(child: Text(loansdata['name'].toString(),style: TextStyle(fontSize: 12,color: Utils().text),maxLines: 1, overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,)))),
                                      DataCell(
                                        SizedBox(
                                          width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.060:85,
                                          child: Center(
                                            child: Text(
                                              formatted,
                                              style: TextStyle(fontSize: 12, color: Utils().text),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(SizedBox(width: isBigScreen() ? (MediaQuery.of(context).size.width - 75) * 0.030 : 95, child: Center(child: Text((loansdata['interest_per'] == null || loansdata['interest_per'] == 0) ? "-" : "${loansdata['interest_per']}%", style: TextStyle(fontSize: 12, color: Utils().text), textAlign: TextAlign.center,),),),),
                                      DataCell(
                                        SizedBox(
                                          width: isBigScreen()
                                              ? (MediaQuery.of(context).size.width - 75) * 0.0600
                                              : 95,
                                          child: Center(
                                            child: Text(
                                              loansdata['type'] == "regular"
                                                  ? NumberFormat.currency(
                                                locale: "en_IN",
                                                symbol: "₹",
                                                decimalDigits: 0,
                                              ).format(regularLoans)
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
                                      DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.050:95,child: Center(child: Text('₹${loansdata['down_payment'].toString()}',style: TextStyle(fontSize: 12,color: Utils().text),textAlign: TextAlign.center,)))),
                                      DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.050:95,child: Center(child: Text('₹${loansdata['service_charge'].toString()}',style: TextStyle(fontSize: 12,color: Utils().text),textAlign: TextAlign.center,)))),
                                      DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0440:55,child: Center(child: Text('${loansdata['tenure'].toString()}',style: TextStyle(fontSize: 12,color: Utils().text),textAlign: TextAlign.center,)))),
                                      DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.060:80,child: Center(child: Text(emiAMT,style: TextStyle(fontSize: 12,color: Utils().text),textAlign: TextAlign.center,)))),
                                      DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.060:80,child: Center(child: Text(loansdata['type'].toString(),style: TextStyle(fontSize: 12,color: Utils().text),textAlign: TextAlign.center,)))),
                                      DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0600:80,child: Center(
                                          child: Text(
                                            loansdata['type'] == "interest-only" && loansdata["closing_date"] == null
                                                ? NumberFormat.currency(locale: "en_IN", symbol: "₹", decimalDigits: 0,).format(num.tryParse(interestOnly.toString()))
                                                :emiPen,style: TextStyle(fontSize: 12,color: Colors.red),textAlign: TextAlign.center,)))),

                                      DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0600:85,child: Center(child: Text(emiPaid == null ? "0" : emiPaid,style: TextStyle(fontSize: 12,color: Colors.green),textAlign: TextAlign.center,)))),
                                      DataCell(
                                        SizedBox(
                                          width: isBigScreen() ? (MediaQuery.of(context).size.width-75) * 0.0740 : 90,
                                          child: Center(
                                            child: Text(
                                              loansdata['last_payment_date'] == null ? "-" :
                                              DateFormat("dd-MM-yyyy").format(
                                                DateTime.parse( loansdata['last_payment_date'].toString()),
                                              ),
                                              style: TextStyle(fontSize: 14,color: Utils().text),textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: isBigScreen() ? (MediaQuery.of(context).size.width-75) *0.0650:80,
                                          child: Center(
                                            child: Text(
                                              DateFormat("dd-MM-yyyy").format(
                                                DateTime.parse(loansdata['loan_date']),
                                              ),
                                              style: TextStyle(fontSize: 14,color: Utils().text),textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: isBigScreen() ? (MediaQuery.of(context).size.width-75) * 0.0740 : 80,
                                          child: Center(
                                            child: Text(
                                              DateFormat("dd-MM-yyyy").format(
                                                DateTime.parse(loansdata['closing_date'] ?? loansdata['emi_due_date']),
                                              ),
                                              style: TextStyle(fontSize: 14,color: Utils().text),textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: isBigScreen()
                                              ? (MediaQuery.of(context).size.width - 75) * 0.0500
                                              : 80,
                                          child: Center(
                                            child: Text(
                                              loansdata['closing_date'] == null ? "Open" : "Close",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: loansdata['closing_date'] == null
                                                    ? Colors.orange // 🟠 Highlight "Open"
                                                    : Colors.green, // 🟢 Highlight "Close"
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                          SizedBox(
                                            width: 90,
                                            child: Row(
                                              children: [
                                                loansdata['closing_date'] == null ?
                                                GestureDetector(
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
                                                                                    return;
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
                                                                                await payEmiController.PaymentReceived(context, loansdata['id']);
                                                                                if (payEmiController.success != null && payEmiController.success == "true") {
                                                                                  initMethodCalling();
                                                                                  payEmiReceipt.generatePdfReceipt(
                                                                                    loanAmount: "${loansdata['principal_amount'].toString()}",
                                                                                    loanID: "${loansdata['id'].toString()}",
                                                                                    KYCID: "${loansdata['kyc_id'].toString()}",
                                                                                    name: "${loansdata['name'].toString()}",
                                                                                    loanType: "${loansdata['type'].toString()}",
                                                                                    // oldPendingAmt: "${loansdata['due_emi_amount'].toString()}",
                                                                                    emiAmount: payEmiController.emiPreMonth.text.toString(),
                                                                                    penaltyAmount: payEmiController.penalty.text.toString(),
                                                                                    otherAmount: payEmiController.other_amount.text.toString(),
                                                                                    detection: payEmiController.detection.text.toString(),
                                                                                    date:  payEmiController.paymentDate.text.toString(),
                                                                                    totalAmount: loansController.totalPayAmount.round().toString(),
                                                                                  );
                                                                                  Navigator.pop(context);
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
                                                ) :  Image.asset("assets/images/rupee.png", color: Colors.grey, height: 22),
                                                // edit loan
                                                loansdata['closing_date'] == null ? SizedBox(
                                                  height: 24,
                                                  width: 24,
                                                  child: IconButton(
                                                    onPressed : (){
                                                      loansController.interest.clear();
                                                      loansController.loansId.text = loansdata['kyc_id'].toString();
                                                      loansController.loanName.text = loansdata['name'].toString();
                                                      loansController.totalAmount.text = loansdata['principal_amount'].toString();
                                                      loansController.durationEmi.text = loansdata['tenure'].toString();
                                                      loansController.serviceFees.text = loansdata['service_charge'].toString();
                                                      // loansController.interest.text = loansdata['interest_per'] ? "-" : loansdata['interest_per'].toString();
                                                      loansdata['interest_per'] == null ? "-" : loansController.interest.text = loansdata['interest_per'].toString();
                                                      // loansController.loansDate.text = loansdata['loan_date'].toString();
                                                      loansController.downPayment.text = loansdata['down_payment'].toString();
                                                      //payEmiController.Paid_Date.text = DateFormat("dd-MM-yyyy").format(DateTime.tryParse(emiloansdata['payment_date']) ?? DateTime.now());
                                                      loansController.loansDate.text = DateFormat("dd-MM-yyyy").format(DateTime.tryParse(loansdata['loan_date']) ?? loansdata['loan_date']);
                                                      loansController.selectValue = loansdata['type'].toString();
                                                      if(Get.width > 700) {
                                                        setState(() {
                                                          loansController.emiResult = loansdata['emi_amount'];
                                                        });
                                                        Get.dialog(
                                                          StatefulBuilder(
                                                            builder:(context, setState) =>
                                                                Dialog(
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(12),
                                                                  ),
                                                                  child: Container(
                                                                    width: 800,
                                                                    padding: EdgeInsets.all(11),
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
                                                                            Center(
                                                                              child: Text(
                                                                                "Loans ${loansdata['id'].toString()}",
                                                                                style: TextStyle(color: Utils().text,fontSize: 18,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ),
                                                                            GestureDetector(
                                                                              onTap: (){
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(right: 20,top: 5),
                                                                                child: Container(
                                                                                    height: 30,
                                                                                    width: 30,
                                                                                    decoration: BoxDecoration(
                                                                                        color: Colors.red,
                                                                                        shape: BoxShape.circle,
                                                                                        border: Border.all(
                                                                                          width: 1,
                                                                                          color: Utils().button,
                                                                                        )
                                                                                    ),
                                                                                    child: Icon(Icons.close,color: Colors.white,)
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Divider(),
                                                                        Form(
                                                                            key: loansController.loansKey,
                                                                            child:  Padding(
                                                                              padding: const EdgeInsets.only(left: 14),
                                                                              child: Column(
                                                                                children: [
                                                                                  Row(
                                                                                    spacing: 10,
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        width: 170,
                                                                                        child: RadioListTile(
                                                                                            contentPadding: EdgeInsets.zero,
                                                                                            title: Text("Regular Loan",style: TextStyle(
                                                                                                fontWeight: FontWeight.w500,
                                                                                                fontSize: 12,
                                                                                                color: Utils().border_1
                                                                                            ),),
                                                                                            value: "regular",
                                                                                            groupValue: loansController.selectValue,
                                                                                            onChanged: (value){
                                                                                              updateEmi();
                                                                                              setState((){
                                                                                                loansController.selectValue = value;
                                                                                              });
                                                                                            }),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width : 120,
                                                                                        child: RadioListTile(
                                                                                          title: Text("Interest Only",style: TextStyle(
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: 12,
                                                                                              color: Utils().border_1
                                                                                          ),),
                                                                                          value: "interest-only",
                                                                                          groupValue: loansController.selectValue,
                                                                                          onChanged: (value){
                                                                                            updateInterest();
                                                                                            setState((){
                                                                                              loansController.selectValue = value;
                                                                                            });
                                                                                          },
                                                                                          contentPadding: EdgeInsets.zero,
                                                                                        ),
                                                                                      ),
                                                                                      TypeAheadField(
                                                                                        controller: loansController.loanName,
                                                                                        builder: (context, controller, focusNode) {
                                                                                          return SizedBox(
                                                                                            width:  330,
                                                                                            child: TextFormField(
                                                                                              focusNode: focusNode,
                                                                                              textCapitalization: TextCapitalization.characters,
                                                                                              onChanged: (value) {
                                                                                              },
                                                                                              validator: (value) {
                                                                                                if (value == null || value.isEmpty) {
                                                                                                  return 'Requried this field';
                                                                                                }
                                                                                                return null; // validation passed
                                                                                              },
                                                                                              controller: controller,
                                                                                              decoration: InputDecoration(
                                                                                                labelText: "Full Name",
                                                                                                labelStyle: TextStyle(
                                                                                                  fontSize: 12,
                                                                                                  color: Utils().border_1,
                                                                                                ),
                                                                                                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                                                border: OutlineInputBorder(
                                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                                  borderSide: BorderSide(
                                                                                                    color: Utils().border_1,
                                                                                                    width: 1.5,
                                                                                                  ),
                                                                                                ),
                                                                                                enabledBorder: OutlineInputBorder(
                                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                                  borderSide: BorderSide(
                                                                                                    color: Utils().border_1,
                                                                                                    width: 1.5,
                                                                                                  ),
                                                                                                ),
                                                                                                focusedBorder: OutlineInputBorder(
                                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                                  borderSide: BorderSide(
                                                                                                    color: Utils().button,
                                                                                                    width: 2,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                        itemBuilder: (context, value) {
                                                                                          return Expanded(
                                                                                            child: Container(
                                                                                              color: Colors.white,
                                                                                              height: 40,
                                                                                              width: 330,
                                                                                              child: ListTile(
                                                                                                title: Row(
                                                                                                  children: [
                                                                                                    Text(value["id"].toString(),style: TextStyle(fontSize: 12,color: Utils().text,fontWeight: FontWeight.bold),),
                                                                                                    SizedBox(width: 5,),
                                                                                                    Expanded(child: Text("${value["first_name"].toString()} ${value["middle_name"].toString()} ${value["last_name"].toString()}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Utils().text),)),
                                                                                                  ],
                                                                                                ),
                                                                                                // subtitle: Text(value["id"].toString(),style: TextStyle(fontSize: 12),),
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                        onSelected: (value) {
                                                                                          final fullName = "${value["first_name"].toString()} ${value["middle_name"].toString()} ${value["last_name"].toString()}";
                                                                                          loansController.loanName.text = fullName.toString();
                                                                                          loansController.loansId.text = value["id"].toString().toString();
                                                                                        },
                                                                                        suggestionsCallback: (value) {
                                                                                          // print("akjsfskdfjhsdkh ${getFilterList(value).toString()}");
                                                                                          return getFilterList(value);
                                                                                        },
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width:  80,
                                                                                        child: TextFormField(
                                                                                          readOnly: true,
                                                                                          keyboardType: TextInputType.number,
                                                                                          inputFormatters: [
                                                                                            FilteringTextInputFormatter.digitsOnly, // Allows only digits
                                                                                            LengthLimitingTextInputFormatter(10),   // Optional: Limit to 10 digits
                                                                                          ],
                                                                                          validator: (value) {
                                                                                            if (value == null || value.isEmpty) {
                                                                                              return 'Requried this field';
                                                                                            }
                                                                                            return null; // validation passed
                                                                                          },
                                                                                          controller: loansController.loansId,
                                                                                          decoration: InputDecoration(
                                                                                            labelText: "KYC ID",
                                                                                            labelStyle: TextStyle(
                                                                                              fontSize: 12,
                                                                                              color: Utils().border_1,
                                                                                            ),
                                                                                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                                            border: OutlineInputBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                              borderSide: BorderSide(
                                                                                                color: Utils().border_1,
                                                                                                width: 1.5,
                                                                                              ),
                                                                                            ),
                                                                                            enabledBorder: OutlineInputBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                              borderSide: BorderSide(
                                                                                                color: Utils().border_1,
                                                                                                width: 1.5,
                                                                                              ),
                                                                                            ),
                                                                                            focusedBorder: OutlineInputBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                              borderSide: BorderSide(
                                                                                                color: Utils().button,
                                                                                                width: 2,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(height: 20,),
                                                                                  Row(
                                                                                    spacing: 10,
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        width:  150,
                                                                                        child: TextFormField(
                                                                                          validator: (value) {
                                                                                            if (value == null || value.isEmpty) {
                                                                                              return 'Requried this field';
                                                                                            }
                                                                                            return null; // validation passed
                                                                                          },
                                                                                          onChanged: (value) {
                                                                                            try {
                                                                                              loansController.selectedLoanDate = DateFormat('dd-MM-yyyy').parseStrict(value);
                                                                                            } catch (e) {
                                                                                              loansController.selectedLoanDate = DateTime.now(); // fallback
                                                                                              // print("Invalid date format entered: $e");
                                                                                            }
                                                                                          },
                                                                                          controller: loansController.loansDate,
                                                                                          decoration: InputDecoration(
                                                                                            labelText: "Select Date",
                                                                                            labelStyle: TextStyle(
                                                                                              fontSize: 12,
                                                                                              color: Utils().border_1,
                                                                                            ),
                                                                                            suffixIcon: IconButton(onPressed: (){
                                                                                              pickLoanDate(context);
                                                                                            }, icon: Icon(Icons.calendar_month_outlined,color: Utils().border_1,)),
                                                                                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                                            border: OutlineInputBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                              borderSide: BorderSide(
                                                                                                color: Utils().border_1,
                                                                                                width: 1.5,
                                                                                              ),
                                                                                            ),
                                                                                            enabledBorder: OutlineInputBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                              borderSide: BorderSide(
                                                                                                color: Utils().border_1,
                                                                                                width: 1.5,
                                                                                              ),
                                                                                            ),
                                                                                            focusedBorder: OutlineInputBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                              borderSide: BorderSide(
                                                                                                color: Utils().button,
                                                                                                width: 2,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width:130,
                                                                                        child: TextFormField(
                                                                                          controller: loansController.totalAmount,
                                                                                          keyboardType: TextInputType.number,
                                                                                          inputFormatters: [
                                                                                            FilteringTextInputFormatter.digitsOnly,
                                                                                            LengthLimitingTextInputFormatter(10),
                                                                                          ],
                                                                                          validator: (value) {
                                                                                            if (value == null || value.isEmpty) {
                                                                                              return 'Required this field';
                                                                                            }
                                                                                            return null;
                                                                                          },
                                                                                          onChanged: (val) {
                                                                                            setState(() {
                                                                                              if(loansController.selectValue == "interest-only") {
                                                                                                updateInterest();
                                                                                              }
                                                                                              else if(loansController.selectValue == "regular"){
                                                                                                updateEmi();
                                                                                              }
                                                                                            });
                                                                                          },
                                                                                          decoration: InputDecoration(
                                                                                            labelText: "Principal amount",
                                                                                            labelStyle: TextStyle(fontSize: 12, color: Utils().border_1),
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
                                                                                      SizedBox(
                                                                                        width: 120,
                                                                                        child: TextFormField(
                                                                                          controller: loansController.interest,
                                                                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                                                          inputFormatters: [
                                                                                            // Allow only digits and one decimal point
                                                                                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                                                                                          ],
                                                                                          validator: (value) {
                                                                                            if (value == null || value.isEmpty) {
                                                                                              return 'Required this field';
                                                                                            }
                                                                                            return null;
                                                                                          },
                                                                                          onChanged: (val) {
                                                                                            setState(() {
                                                                                              if(loansController.selectValue == "interest-only") {
                                                                                                updateInterest();
                                                                                              }
                                                                                              else if(loansController.selectValue == "regular"){
                                                                                                updateEmi();
                                                                                              }
                                                                                            });
                                                                                          },
                                                                                          decoration: InputDecoration(
                                                                                            labelText: "Interest",
                                                                                            labelStyle: TextStyle(fontSize: 12, color: Utils().border_1),
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
                                                                                      SizedBox(
                                                                                        width: 85,
                                                                                        child: TextFormField(
                                                                                          controller: loansController.durationEmi,
                                                                                          keyboardType: TextInputType.number,
                                                                                          inputFormatters: [
                                                                                            FilteringTextInputFormatter.digitsOnly,
                                                                                            LengthLimitingTextInputFormatter(10),
                                                                                          ],
                                                                                          validator: (value) {
                                                                                            if (value == null || value.isEmpty) {
                                                                                              return 'Required this field';
                                                                                            }
                                                                                            return null;
                                                                                          },
                                                                                          onChanged: (val) {
                                                                                            setState(() {
                                                                                              if(loansController.selectValue == "interest-only") {
                                                                                                updateInterest();
                                                                                              }
                                                                                              else if(loansController.selectValue == "regular"){
                                                                                                updateEmi();
                                                                                              }
                                                                                            });
                                                                                          },
                                                                                          decoration: InputDecoration(
                                                                                            labelText: "Duration",
                                                                                            labelStyle: TextStyle(fontSize: 12, color: Utils().border_1),
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
                                                                                      SizedBox(
                                                                                        width:  105,
                                                                                        child: TextFormField(
                                                                                          keyboardType: TextInputType.number,
                                                                                          inputFormatters: [
                                                                                            FilteringTextInputFormatter.digitsOnly, // Allows only digits
                                                                                            LengthLimitingTextInputFormatter(10),   // Optional: Limit to 10 digits
                                                                                          ],
                                                                                          validator: (value) {
                                                                                            if (value == null || value.isEmpty) {
                                                                                              return 'Requried this field';
                                                                                            }
                                                                                            return null; // validation passed
                                                                                          },
                                                                                          controller: loansController.serviceFees,
                                                                                          decoration: InputDecoration(
                                                                                            labelText: "service fees",
                                                                                            labelStyle: TextStyle(
                                                                                              fontSize: 12,
                                                                                              color: Utils().border_1,
                                                                                            ),
                                                                                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                                            border: OutlineInputBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                              borderSide: BorderSide(
                                                                                                color: Utils().border_1,
                                                                                                width: 1.5,
                                                                                              ),
                                                                                            ),
                                                                                            enabledBorder: OutlineInputBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                              borderSide: BorderSide(
                                                                                                color: Utils().border_1,
                                                                                                width: 1.5,
                                                                                              ),
                                                                                            ),
                                                                                            focusedBorder: OutlineInputBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                              borderSide: BorderSide(
                                                                                                color: Utils().button,
                                                                                                width: 2,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width:  80,
                                                                                        child: TextFormField(
                                                                                          keyboardType: TextInputType.number,
                                                                                          inputFormatters: [
                                                                                            FilteringTextInputFormatter.digitsOnly, // Allows only digits
                                                                                            LengthLimitingTextInputFormatter(10),   // Optional: Limit to 10 digits
                                                                                          ],
                                                                                          validator: (value) {
                                                                                            if (value == null || value.isEmpty) {
                                                                                              return 'Requried this field';
                                                                                            }
                                                                                            return null; // validation passed
                                                                                          },
                                                                                          controller: loansController.downPayment,
                                                                                          decoration: InputDecoration(
                                                                                            labelText: "Down Payment",
                                                                                            labelStyle: TextStyle(
                                                                                              fontSize: 12,
                                                                                              color: Utils().border_1,
                                                                                            ),
                                                                                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                                            border: OutlineInputBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                              borderSide: BorderSide(
                                                                                                color: Utils().border_1,
                                                                                                width: 1.5,
                                                                                              ),
                                                                                            ),
                                                                                            enabledBorder: OutlineInputBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                              borderSide: BorderSide(
                                                                                                color: Utils().border_1,
                                                                                                width: 1.5,
                                                                                              ),
                                                                                            ),
                                                                                            focusedBorder: OutlineInputBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                              borderSide: BorderSide(
                                                                                                color: Utils().button,
                                                                                                width: 2,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(height: 15,),
                                                                                  Row(
                                                                                    spacing: 45,
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Text("EMI Amount",style: TextStyle(
                                                                                        fontSize: 12,
                                                                                        color: Colors.orange,
                                                                                      ),),
                                                                                      loansController.selectValue == "interest-only" ? Text("Loan Amount",style: TextStyle(
                                                                                        fontSize: 12,
                                                                                        color: Colors.green,
                                                                                      ),) : SizedBox()
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(height: 8,),
                                                                                  Row(
                                                                                    spacing: 10,
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Container(
                                                                                        height: 45,
                                                                                        width: 120,
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                          border: Border.all(
                                                                                            color: Utils().border_1,
                                                                                            width: 1.5,
                                                                                          ),
                                                                                        ),
                                                                                        child:  Center(
                                                                                          child: Text(
                                                                                            "₹${loansController.emiResult.round()}",
                                                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.orange),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      loansController.selectValue == "interest-only" ?  Text("+",style: TextStyle(
                                                                                          fontSize: 14, fontWeight: FontWeight.bold,color: Utils().text
                                                                                      ),) : SizedBox(),
                                                                                      loansController.selectValue == "interest-only" ?  Center(
                                                                                        child: Container(
                                                                                          height: 45,
                                                                                          width: 120,
                                                                                          decoration: BoxDecoration(
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                            border: Border.all(
                                                                                              color: Utils().border_1,
                                                                                              width: 1.5,
                                                                                            ),
                                                                                          ),
                                                                                          child:  Center(
                                                                                            child: Text(
                                                                                              "₹${loansController.totalAmount.text.toString()}",
                                                                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.green),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ) : SizedBox(),
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            )),
                                                                        SizedBox(height: 20,),
                                                                        Center(
                                                                          child: GestureDetector(
                                                                            onTap: () async {
                                                                              if(loansController.loansKey.currentState!.validate()){
                                                                                setState(() {
                                                                                  loansController.addLoans.value = true;
                                                                                });
                                                                                await loansController.UpdateLoan(context,loansdata['id']);


                                                                                setState(() {
                                                                                  loansController.addLoans.value = false;
                                                                                });
                                                                              }
                                                                            },
                                                                            child: Obx(
                                                                                  () => Container(
                                                                                height: 35,
                                                                                width: 150,
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(12),
                                                                                  gradient: LinearGradient(
                                                                                    colors: [
                                                                                      Utils().border_1,
                                                                                      Utils().button,
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                child: Center(
                                                                                  child: loansController.updateLoan.value
                                                                                      ? SizedBox(
                                                                                    height: 18,
                                                                                    width: 18,
                                                                                    child: CircularProgressIndicator(
                                                                                      strokeWidth: 2,
                                                                                      color: Utils().background,
                                                                                    ),
                                                                                  )
                                                                                      : Text(
                                                                                    "Update",
                                                                                    style: TextStyle(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color: Utils().background,
                                                                                      fontSize: 16,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                          ),

                                                        );
                                                      }
                                                      else {
                                                        loansController.mobileLoanID = loansdata['id'].toString();
                                                        Get.to(MobilEditLoan(loans: {},),transition: Transition.noTransition);
                                                      }
                                                    },
                                                    icon: Icon(Icons.edit, color: Utils().button, size: 18),
                                                    padding: EdgeInsets.all(0),
                                                    iconSize: 18,
                                                  ),
                                                ) :
                                                Icon(Icons.edit,color: Colors.grey,size: 18,),
                                                SizedBox(
                                                  height: 24,
                                                  width: 24,
                                                  child: selectIndex == index && loanPdf
                                                      ? CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor: AlwaysStoppedAnimation<Color>(Utils().button),
                                                  )
                                                      :IconButton(
                                                    onPressed: () async {
                                                      await formController.showKycDetails();
                                                      loansController.loanDataNew.value = '';
                                                      selectIndex = index;

                                                      loansController.loanAmount = loansdata['principal_amount'].toString();
                                                      loansController.emiAmount = loansdata['emi_amount'].toString();
                                                      loansController.selectValue = loansdata['type'].toString();

                                                      // Format loan_date to dd/MM/yyyy
                                                      String rawLoanDate = loansdata['loan_date'] ?? "";
                                                      DateTime parsedLoanDate = DateTime.tryParse(rawLoanDate) ?? DateTime.now();
                                                      loansController.loanDataNew.value = DateFormat('dd-MM-yyyy').format(parsedLoanDate);

                                                      // Similarly, format closing_date or emi_due_date
                                                      String rawEndDate = loansdata['closing_date'] ?? loansdata['emi_due_date'] ?? "";
                                                      DateTime parsedEndDate = DateTime.tryParse(rawEndDate) ?? DateTime.now();
                                                      loansController.loanDataEnd.value = DateFormat('dd-MM-yyyy').format(parsedEndDate);

                                                      print("Formatted Loan Date: ${loansController.loanDataNew.value}");
                                                      print("Formatted End Date: ${loansController.loanDataEnd.value}");

                                                      loansController.duration = loansdata['tenure'].toString();
                                                      loansController.penlatyAmount = loansdata['emi_pending_count'].toString();
                                                      loansController.otherAmount = loansdata['partial_emi_pending_payment'].toString();
                                                      loansController.loanNumber = loansdata['id'].toString();
                                                      loansController.downPay = loansdata['down_payment'].toString();
                                                      loansController.pdfLoanID = loansdata['id'].toString();
                                                      loansController.serviceCharge = loansdata['service_charge'].toString();

                                                      var data;
                                                      for (int i = 0; i < formController.data.length; i++) {
                                                        if (loansController.loansData[index]['kyc_id'] == formController.data[i]['id']) {
                                                          data = formController.data[i];
                                                        }
                                                      }

                                                      await kycListController.FomrNumber();

                                                      setState(() {
                                                        loanPdf = true;
                                                      });


                                                      await LoansPdf().generateLoansPDF(data);

                                                      setState(() {
                                                        loanPdf = false;
                                                      });
                                                    },
                                                    icon: Icon(Icons.picture_as_pdf_rounded,size: 18,color: Utils().button,),
                                                    padding: EdgeInsets.all(0),
                                                    iconSize: 18,
                                                  ),

                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                        onSelectChanged: (select)async{

                                          print("object ${loansdata['id'].toString()}");

                                          await loansController.balanceSheet(loansdata['id'].toString());

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

                                          double totalInterest = 0;

                                          if (loansdata['type'] == "regular") {
                                            totalInterest = (loansdata['emi_amount'] * loansdata['tenure']) - loansdata['principal_amount'];
                                          } else if (loansdata['type'] == "interest-only") {
                                            totalInterest = loansdata['emi_amount'] * loansdata['tenure'];
                                          } else {
                                            totalInterest = 0;
                                          }
                                          double _calculatePenalty() {
                                            double penalty = 0;
                                            for (var loan in payEmiController.loanTransactionHistory) {
                                              penalty += double.tryParse(loan['penalty'].toString()) ?? 0;
                                            }
                                            return penalty;
                                          }
                                          double _calculateOtherAmount() {
                                            double penalty = 0;
                                            for (var loan in payEmiController.loanTransactionHistory) {
                                              penalty += double.tryParse(loan['other_amount'].toString()) ?? 0;
                                            }
                                            return penalty;
                                          }
                                          print("Total Penalty => ${_calculatePenalty()}");
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Utils().background,
                                            constraints: BoxConstraints(
                                              maxWidth: Get.width,
                                            ), builder: (BuildContext context) {
                                            return StatefulBuilder(
                                              builder: (context, setModalState)  {

                                                return  Container(
                                                  height: 400, // Or any height you want
                                                  width: Get.width,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black26,
                                                        blurRadius: 10,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width : Get.width,
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                            colors: [
                                                              Utils().border_1,
                                                              Utils().button,
                                                            ],
                                                          ),
                                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
                                                        ),
                                                        child:  Padding(
                                                          padding: const EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 10),
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text("${loansdata['type'].toString()} : ",
                                                                      style: TextStyle(fontSize: 16, color: Utils().background,fontWeight: FontWeight.w600)),
                                                                  Text(loansdata['id'].toString(),
                                                                    style: TextStyle(fontSize: 16,color: Utils().background,fontWeight: FontWeight.w700),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text("Name : ",
                                                                      style: TextStyle(fontSize: 16, color: Utils().background,fontWeight: FontWeight.w500)),
                                                                  Text(loansdata['name'].toString(),
                                                                    style: TextStyle(fontSize: 16,color: Utils().background,fontWeight: FontWeight.w700),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text("Loan Date : ",
                                                                      style: TextStyle(fontSize: 16, color: Utils().background,fontWeight: FontWeight.w500)),
                                                                  Text( DateFormat("dd-MM-yyyy").format(
                                                                    DateTime.parse(loansdata['loan_date']),
                                                                  ),
                                                                    style: TextStyle(fontSize: 16,color: Utils().background,fontWeight: FontWeight.w700),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 18,right: 18),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              width: 600,
                                                              height: 350,
                                                              child: SingleChildScrollView(
                                                                child: Column(
                                                                  children: [
                                                                    Text("Received Loan Instalments",style: TextStyle(
                                                                      fontSize: 16,
                                                                      color: Utils().text,
                                                                      fontWeight: FontWeight.w600,
                                                                    ),),
                                                                    SizedBox(height: 10,),
                                                                    DataTableTheme(
                                                                      data: DataTableThemeData(
                                                                        headingRowHeight: 36, // Reduce header height
                                                                        dataRowMinHeight: 36, // Reduce row height
                                                                        dataRowMaxHeight: 40,
                                                                        horizontalMargin: 8,  // Reduce horizontal margin
                                                                        columnSpacing: 8,     // Already handled in your code
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
                                                                              width: 50,
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "Sr. No",
                                                                                  style: TextStyle(color: Utils().text, fontSize: 12),
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          DataColumn(
                                                                            label: SizedBox(
                                                                              width: 70,
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "Emi Amount",
                                                                                  style: TextStyle(color: Utils().text, fontSize: 12),
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          DataColumn(
                                                                            label: SizedBox(
                                                                              width: 75,
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "Other Amount",
                                                                                  style: TextStyle(color: Utils().text, fontSize: 12),
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          DataColumn(
                                                                            label: SizedBox(
                                                                              width: 70,
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "Penalty",
                                                                                  style: TextStyle(color: Utils().text, fontSize: 12),
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          DataColumn(
                                                                            label: SizedBox(
                                                                              width: 75,
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "Payment Date",
                                                                                  style: TextStyle(color: Utils().text, fontSize: 12),
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          DataColumn(
                                                                            label: SizedBox(
                                                                              width: 70,
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "Action",
                                                                                  style: TextStyle(color: Utils().text, fontSize: 12),
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                        rows: List.generate(
                                                                          payEmiController.loanTransactionHistory.length,
                                                                              (index) {
                                                                            final emiloansdata = payEmiController.loanTransactionHistory[index];
                                                                            return DataRow(
                                                                              cells: [
                                                                                DataCell(SizedBox(
                                                                                  width: 50,
                                                                                  child: Center(
                                                                                    child: Text("${index+ 1}",
                                                                                      style: TextStyle(fontSize: 12, color: Utils().text),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                  ),
                                                                                )),
                                                                                DataCell(SizedBox(
                                                                                  width: isBigScreen()
                                                                                      ? (MediaQuery.of(context).size.width - 75) * 0.0455
                                                                                      : 55,
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      emiloansdata['emi_amount'].toString(),
                                                                                      style: TextStyle(fontSize: 12, color: Utils().text),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                  ),
                                                                                )),
                                                                                DataCell(SizedBox(
                                                                                  width: isBigScreen()
                                                                                      ? (MediaQuery.of(context).size.width - 75) * 0.0455
                                                                                      : 55,
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      emiloansdata['other_amount'].toString(),
                                                                                      style: TextStyle(fontSize: 12, color: Utils().text),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                  ),
                                                                                )),
                                                                                DataCell(SizedBox(
                                                                                  width: isBigScreen()
                                                                                      ? (MediaQuery.of(context).size.width - 75) * 0.0455
                                                                                      : 55,
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      emiloansdata['penalty'].toString(),
                                                                                      style: TextStyle(fontSize: 12, color: Utils().text),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                  ),
                                                                                )),
                                                                                DataCell(SizedBox(
                                                                                  width: 75,
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      DateFormat('dd-MM-yyyy').format(DateTime.parse(emiloansdata['payment_date'].toString())),
                                                                                      style: TextStyle(fontSize: 12, color: Utils().text),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                  ),
                                                                                )),
                                                                                DataCell(
                                                                                  Row(
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        child: GestureDetector(
                                                                                          onTap: () {
                                                                                            payEmiController.payment_id = emiloansdata['id'].toString();
                                                                                            payEmiController.emiAmount.text = emiloansdata['emi_amount'].toString();
                                                                                            payEmiController.penalty.text = emiloansdata['penalty'].toString();
                                                                                            payEmiController.other_amount.text = emiloansdata['other_amount'].toString();

                                                                                            // ✅ Safely parse payment_date from the API
                                                                                            DateTime parsedDate;
                                                                                            try {
                                                                                              // Try to parse backend date (e.g., "2025-11-07" or "2025-11-07T00:00:00")
                                                                                              parsedDate = DateFormat("yyyy-MM-dd").parse(emiloansdata['payment_date']);
                                                                                            } catch (e) {
                                                                                              // If parsing fails, use DateTime.now()
                                                                                              parsedDate = DateTime.now();
                                                                                            }

                                                                                            // ✅ Set both controller text and selected date value
                                                                                            payEmiController.Paid_Date.text = DateFormat("dd-MM-yyyy").format(parsedDate);
                                                                                            payEmiController.selectedUpdatePaidDate = parsedDate;

                                                                                            // ✅ Show dialog
                                                                                            Get.dialog(
                                                                                              Dialog(
                                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                                                                child: Container(
                                                                                                  height: 300,
                                                                                                  width: MediaQuery.of(context).size.width,
                                                                                                  decoration: BoxDecoration(
                                                                                                    color: Utils().background,
                                                                                                    borderRadius: BorderRadius.circular(12),
                                                                                                  ),
                                                                                                  padding: const EdgeInsets.all(16),
                                                                                                  constraints: BoxConstraints(maxWidth: 400),
                                                                                                  child: Column(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      // Header row
                                                                                                      Row(
                                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            "Update Transaction",
                                                                                                            style: TextStyle(
                                                                                                              fontWeight: FontWeight.bold,
                                                                                                              fontSize: 18,
                                                                                                              color: Utils().text,
                                                                                                            ),
                                                                                                          ),
                                                                                                          GestureDetector(
                                                                                                            onTap: () {
                                                                                                              Navigator.pop(context);
                                                                                                            },
                                                                                                            child: Padding(
                                                                                                              padding: const EdgeInsets.only(right: 10, top: 5),
                                                                                                              child: Container(
                                                                                                                height: 30,
                                                                                                                width: 30,
                                                                                                                decoration: BoxDecoration(
                                                                                                                  color: Colors.red,
                                                                                                                  shape: BoxShape.circle,
                                                                                                                  border: Border.all(
                                                                                                                    width: 1,
                                                                                                                    color: Utils().button,
                                                                                                                  ),
                                                                                                                ),
                                                                                                                child: Icon(Icons.close, color: Colors.white),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                      const Padding(
                                                                                                        padding: EdgeInsets.all(8.0),
                                                                                                        child: Divider(),
                                                                                                      ),

                                                                                                      // ✅ Form
                                                                                                      Form(
                                                                                                        key: payEmiController.updateEmiPayment,
                                                                                                        child: Column(
                                                                                                          children: [
                                                                                                            Row(
                                                                                                              spacing: 20,
                                                                                                              children: [
                                                                                                                SizedBox(
                                                                                                                  width: MediaQuery.of(context).size.width * 0.120,
                                                                                                                  child: TextFormField(
                                                                                                                    autofocus: true,
                                                                                                                    keyboardType: TextInputType.number,
                                                                                                                    inputFormatters: [
                                                                                                                      FilteringTextInputFormatter.digitsOnly,
                                                                                                                      LengthLimitingTextInputFormatter(10),
                                                                                                                    ],
                                                                                                                    validator: (value) {
                                                                                                                      if (value == null || value.isEmpty) {
                                                                                                                        return 'Required this field';
                                                                                                                      }
                                                                                                                      return null;
                                                                                                                    },
                                                                                                                    controller: payEmiController.emiAmount,
                                                                                                                    decoration: InputDecoration(
                                                                                                                      labelText: "Emi Amount",
                                                                                                                      labelStyle: TextStyle(
                                                                                                                        fontSize: 12,
                                                                                                                        color: Utils().border_1,
                                                                                                                      ),
                                                                                                                      contentPadding: const EdgeInsets.symmetric(
                                                                                                                          vertical: 12, horizontal: 16),
                                                                                                                      border: OutlineInputBorder(
                                                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                                                        borderSide: BorderSide(
                                                                                                                          color: Utils().border_1,
                                                                                                                          width: 1.5,
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      focusedBorder: OutlineInputBorder(
                                                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                                                        borderSide: BorderSide(
                                                                                                                          color: Utils().button,
                                                                                                                          width: 2,
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                SizedBox(
                                                                                                                  width: MediaQuery.of(context).size.width * 0.120,
                                                                                                                  child: TextFormField(
                                                                                                                    keyboardType: TextInputType.number,
                                                                                                                    inputFormatters: [
                                                                                                                      FilteringTextInputFormatter.digitsOnly,
                                                                                                                      LengthLimitingTextInputFormatter(10),
                                                                                                                    ],
                                                                                                                    controller: payEmiController.penalty,
                                                                                                                    decoration: InputDecoration(
                                                                                                                      labelText: "Penalty",
                                                                                                                      labelStyle: TextStyle(
                                                                                                                        fontSize: 12,
                                                                                                                        color: Utils().border_1,
                                                                                                                      ),
                                                                                                                      contentPadding: const EdgeInsets.symmetric(
                                                                                                                          vertical: 12, horizontal: 16),
                                                                                                                      border: OutlineInputBorder(
                                                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                                                        borderSide: BorderSide(
                                                                                                                          color: Utils().border_1,
                                                                                                                          width: 1.5,
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      focusedBorder: OutlineInputBorder(
                                                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                                                        borderSide: BorderSide(
                                                                                                                          color: Utils().button,
                                                                                                                          width: 2,
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),

                                                                                                            const SizedBox(height: 20),

                                                                                                            Row(
                                                                                                              spacing: 20,
                                                                                                              children: [
                                                                                                                SizedBox(
                                                                                                                  width: MediaQuery.of(context).size.width * 0.120,
                                                                                                                  child: TextFormField(
                                                                                                                    keyboardType: TextInputType.number,
                                                                                                                    inputFormatters: [
                                                                                                                      FilteringTextInputFormatter.digitsOnly,
                                                                                                                      LengthLimitingTextInputFormatter(10),
                                                                                                                    ],
                                                                                                                    controller: payEmiController.other_amount,
                                                                                                                    decoration: InputDecoration(
                                                                                                                      labelText: "Other Amount",
                                                                                                                      labelStyle: TextStyle(
                                                                                                                        fontSize: 12,
                                                                                                                        color: Utils().border_1,
                                                                                                                      ),
                                                                                                                      contentPadding: const EdgeInsets.symmetric(
                                                                                                                          vertical: 12, horizontal: 16),
                                                                                                                      border: OutlineInputBorder(
                                                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                                                        borderSide: BorderSide(
                                                                                                                          color: Utils().border_1,
                                                                                                                          width: 1.5,
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      focusedBorder: OutlineInputBorder(
                                                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                                                        borderSide: BorderSide(
                                                                                                                          color: Utils().button,
                                                                                                                          width: 2,
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                SizedBox(
                                                                                                                  width: MediaQuery.of(context).size.width * 0.120,
                                                                                                                  child: TextFormField(
                                                                                                                    validator: (value) {
                                                                                                                      if (value == null || value.isEmpty) {
                                                                                                                        return 'Required this field';
                                                                                                                      }
                                                                                                                      return null;
                                                                                                                    },
                                                                                                                    onChanged: (value) {
                                                                                                                      if (value.isNotEmpty) {
                                                                                                                        try {
                                                                                                                          payEmiController.selectedUpdatePaidDate =
                                                                                                                              DateFormat('dd-MM-yyyy')
                                                                                                                                  .parseStrict(value);
                                                                                                                        } catch (_) {}
                                                                                                                      }
                                                                                                                    },
                                                                                                                    controller: payEmiController.Paid_Date,
                                                                                                                    decoration: InputDecoration(
                                                                                                                      labelText: "Date",
                                                                                                                      labelStyle: TextStyle(
                                                                                                                        fontSize: 12,
                                                                                                                        color: Utils().border_1,
                                                                                                                      ),
                                                                                                                      contentPadding: const EdgeInsets.symmetric(
                                                                                                                          vertical: 12, horizontal: 16),
                                                                                                                      border: OutlineInputBorder(
                                                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                                                        borderSide: BorderSide(
                                                                                                                          color: Utils().border_1,
                                                                                                                          width: 1.5,
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      focusedBorder: OutlineInputBorder(
                                                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                                                        borderSide: BorderSide(
                                                                                                                          color: Utils().button,
                                                                                                                          width: 2,
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),

                                                                                                      const SizedBox(height: 20),

                                                                                                      Center(
                                                                                                        child: GestureDetector(
                                                                                                          onTap: () async {
                                                                                                            if (payEmiController.updateEmiPayment.currentState!.validate()) {
                                                                                                              await payEmiController.updatePayment(context);
                                                                                                              Get.to(Loans(loans: {}), transition: Transition.noTransition);
                                                                                                            }
                                                                                                          },
                                                                                                          child: Container(
                                                                                                            height: 35,
                                                                                                            width: 150,
                                                                                                            decoration: BoxDecoration(
                                                                                                              borderRadius: BorderRadius.circular(12),
                                                                                                              gradient: LinearGradient(
                                                                                                                colors: [Utils().border_1, Utils().button],
                                                                                                              ),
                                                                                                            ),
                                                                                                            child: const Center(
                                                                                                              child: Text(
                                                                                                                "Update",
                                                                                                                style: TextStyle(
                                                                                                                  fontWeight: FontWeight.bold,
                                                                                                                  color: Colors.white,
                                                                                                                  fontSize: 16,
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                          child: Icon(Icons.edit, color: Utils().button,size: 20,),
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width : 30,
                                                                                        child: GestureDetector(
                                                                                          onTap : (){
                                                                                            Get.dialog(Dialog(
                                                                                              child: Container(
                                                                                                height: 240,
                                                                                                width: 500,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: Colors.white,
                                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                                ),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                                                                                                    child: Column(
                                                                                                      spacing: 8,
                                                                                                        children: [
                                                                                                          Row(
                                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                            children: [
                                                                                                              Text("Delete Transaction",style: TextStyle(
                                                                                                                fontWeight: FontWeight.bold,
                                                                                                                color: Utils().text,
                                                                                                                fontSize: 16,
                                                                                                              ),
                                                                                                              ),
                                                                                                              GestureDetector(
                                                                                                                onTap : (){
                                                                                                                  Get.back();
                                                                                                                },
                                                                                                                child: Icon(Icons.cancel,color: Colors.red[800],))
                                                                                                            ],
                                                                                                          ),
                                                                                                          Divider(color: Utils().text,),
                                                                                                          Text("You Wont To Delete This Transaction?... ",style: TextStyle(
                                                                                                            color: Utils().text,
                                                                                                            fontWeight: FontWeight.w500,
                                                                                                            fontSize: 14,
                                                                                                          ),),
                                                                                                          Text("Transaction Date : ${DateFormat('dd-MM-yyyy').format(DateTime.parse(emiloansdata['payment_date'].toString()))}",style: TextStyle(
                                                                                                            color: Utils().text,
                                                                                                            fontWeight: FontWeight.bold,
                                                                                                            fontSize: 14,
                                                                                                          ),),
                                                                                                          Text("Transaction Amount : ₹${emiloansdata['emi_amount'].toString()} ",style: TextStyle(
                                                                                                            color: Utils().text,
                                                                                                            fontWeight: FontWeight.w500,
                                                                                                            fontSize: 14,
                                                                                                          ),),
                                                                                                          Text("Name : ${emiloansdata['name'].toString()} ",style: TextStyle(
                                                                                                            color: Utils().text,
                                                                                                            fontWeight: FontWeight.bold,
                                                                                                            fontSize: 14,
                                                                                                          ),),
                                                                                                          Row(
                                                                                                              spacing: 8,
                                                                                                            children: [
                                                                                                              Spacer(),
                                                                                                              InkWell(
                                                                                                                onTap: (){
                                                                                                                  Get.back();
                                                                                                                },
                                                                                                                child: Container(
                                                                                                                    height: 35,
                                                                                                                  width: 120,
                                                                                                                  decoration: BoxDecoration(
                                                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                                                    color: Utils().background,
                                                                                                                    border: Border.all(
                                                                                                                        color: Utils().border_1,
                                                                                                                        width: 1,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                    child: Center(child: Text("NO",style: TextStyle(
                                                                                                                      fontWeight: FontWeight.bold,
                                                                                                                      color: Utils().border_1,
                                                                                                                      fontSize: 16,
                                                                                                                    ),),),
                                                                                                                ),
                                                                                                              ),
                                                                                                              InkWell(
                                                                                                                onTap: () async{
                                                                                                                await payEmiController.deleteTransaction(emiloansdata['id'].toString(),context);

                                                                                                                },
                                                                                                                child: Container(
                                                                                                                  height: 35,
                                                                                                                  width: 120,
                                                                                                                  decoration: BoxDecoration(
                                                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                                                    gradient: LinearGradient(
                                                                                                                      colors: [Utils().border_1, Utils().button],
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  child: payEmiController.delete ? CircularProgressIndicator() :Center(child: Text("YES",style: TextStyle(
                                                                                                                    fontWeight: FontWeight.bold,
                                                                                                                    color: Utils().background,
                                                                                                                    fontSize: 16,
                                                                                                                  ),),),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ],
                                                                                                          )
                                                                                                        ],
                                                                                                    ),
                                                                                                  ),
                                                                                              ),
                                                                                            ));
                                                                                          },
                                                                                          child: Icon(Icons.delete, size: 20,color:Colors.red[800]),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 20,),
                                                                    Text("Statement",style: TextStyle(
                                                                      fontSize: 16,
                                                                      color: Utils().text,
                                                                      fontWeight: FontWeight.w600,
                                                                    ),),
                                                                    SizedBox(height: 10,),
                                                                    DataTableTheme(
                                                                      data: DataTableThemeData(
                                                                        headingRowHeight: 36, // Reduce header height
                                                                        dataRowMinHeight: 36, // Reduce row height
                                                                        dataRowMaxHeight: 40,
                                                                        horizontalMargin: 8,  // Reduce horizontal margin
                                                                        columnSpacing: 8,     // Already handled in your code
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
                                                                                width: 50,
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    "Sr. No",
                                                                                    style: TextStyle(color: Utils().text, fontSize: 12),
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            DataColumn(
                                                                              label: SizedBox(
                                                                                width: isBigScreen()
                                                                                    ? (MediaQuery.of(context).size.width - 75) * 0.0999
                                                                                    : 55,
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    "Remarks",
                                                                                    style: TextStyle(color: Utils().text, fontSize: 12),
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            DataColumn(
                                                                              label: SizedBox(
                                                                                width: isBigScreen()
                                                                                    ? (MediaQuery.of(context).size.width - 75) * 0.0400
                                                                                    : 55,
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    "Credit",
                                                                                    style: TextStyle(color: Utils().text, fontSize: 12),
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            DataColumn(
                                                                              label: SizedBox(
                                                                                width: isBigScreen()
                                                                                    ? (MediaQuery.of(context).size.width - 75) * 0.0400
                                                                                    : 55,
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    "Debit",
                                                                                    style: TextStyle(color: Utils().text, fontSize: 12),
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            DataColumn(
                                                                              label: SizedBox(
                                                                                width: 75,
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    "Date",
                                                                                    style: TextStyle(color: Utils().text, fontSize: 12),
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                          rows: [
                                                                            ...List.generate(
                                                                              loansController.balanceData.length,
                                                                                  (index) {
                                                                                final balance = loansController.balanceData[index];
                                                                                return DataRow(
                                                                                  cells: [
                                                                                    DataCell(SizedBox(
                                                                                      width: 50,
                                                                                      child: Center(
                                                                                        child: Text("${index+ 1}",
                                                                                          style: TextStyle(fontSize: 12, color: Utils().text),
                                                                                          textAlign: TextAlign.center,
                                                                                        ),
                                                                                      ),
                                                                                    )),
                                                                                    DataCell(SizedBox(
                                                                                      width: isBigScreen()
                                                                                          ? (MediaQuery.of(context).size.width - 75) * 0.0999
                                                                                          : 55,
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          balance['remarks'].toString(),
                                                                                          style: TextStyle(fontSize: 12, color: Utils().text),
                                                                                          textAlign: TextAlign.center,
                                                                                        ),
                                                                                      ),
                                                                                    )),
                                                                                    DataCell(SizedBox(
                                                                                      width: isBigScreen()
                                                                                          ? (MediaQuery.of(context).size.width - 75) * 0.0400
                                                                                          : 55,
                                                                                      child: Center(
                                                                                        child: Text("₹${balance['credit'].toString()}",
                                                                                          style: TextStyle(fontSize: 12, color: Utils().text),
                                                                                          textAlign: TextAlign.center,
                                                                                        ),
                                                                                      ),
                                                                                    )),
                                                                                    DataCell(SizedBox(
                                                                                      width: isBigScreen()
                                                                                          ? (MediaQuery.of(context).size.width - 75) * 0.0400
                                                                                          : 55,
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          "₹${balance['debit'].round().toString()}",
                                                                                          style: TextStyle(fontSize: 12, color: Utils().text),
                                                                                          textAlign: TextAlign.center,
                                                                                        ),
                                                                                      ),
                                                                                    )),
                                                                                    DataCell(SizedBox(
                                                                                      width: 75,
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          DateFormat('dd-MM-yyyy').format(DateTime.parse(balance['date'].toString())),
                                                                                          style: TextStyle(fontSize: 12, color: Utils().text),
                                                                                          textAlign: TextAlign.center,
                                                                                        ),
                                                                                      ),
                                                                                    )),
                                                                                  ],
                                                                                );
                                                                              },
                                                                            ),
                                                                            DataRow(
                                                                              color: MaterialStateProperty.all(Colors.white), // your custom color
                                                                              cells: [
                                                                                DataCell(Text("")),
                                                                                DataCell(Center(child: Text("Total", style: TextStyle(fontWeight: FontWeight.bold)))),
                                                                                DataCell(Center(child: Text(NumberFormat.currency(
                                                                                  locale: "en_IN",
                                                                                  symbol: '₹',
                                                                                  decimalDigits: 0,
                                                                                ).format(_calculateTotalCredit()),style: TextStyle(color: Utils().text,fontWeight: FontWeight.w600,fontSize: 14),))),
                                                                                DataCell(Center(child: Text(NumberFormat.currency(
                                                                                  locale: "en_IN",
                                                                                  symbol: '₹',
                                                                                  decimalDigits: 0,
                                                                                ).format(_calculateTotalDebit()),style: TextStyle(color: Utils().text,fontWeight: FontWeight.w600,fontSize: 14),))),
                                                                                DataCell(Text("")),
                                                                              ],
                                                                            ),
                                                                          ]
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: SingleChildScrollView(
                                                                child: Column(
                                                                  children: [
                                                                    SizedBox(height: 10,),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      spacing: 18,
                                                                      children: [
                                                                        Card(
                                                                          elevation: 8,
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                              color : Colors.green,
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.only(left: 22,right: 22,top: 10,bottom: 10),
                                                                              child: Center(
                                                                                child: Column(
                                                                                  children: [
                                                                                    Text(
                                                                                      "Paid Amount : ",
                                                                                      style: TextStyle(color: Utils().background,   fontSize: 15,
                                                                                        fontWeight: FontWeight.bold,),
                                                                                    ),
                                                                                    Text(NumberFormat.currency(
                                                                                      locale: 'en_IN', // Indian style formatting
                                                                                      symbol: '₹',
                                                                                      decimalDigits: 0,
                                                                                    ).format(loansdata['emi_paid']), style: TextStyle(color: Utils().background,   fontSize: 15,
                                                                                      fontWeight: FontWeight.bold,),)
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Card(
                                                                          elevation: 8,
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                              color : Colors.red[800],
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.only(left: 22,right: 22,top: 10,bottom: 10),
                                                                              child: Center(
                                                                                child: Column(
                                                                                  children: [
                                                                                    Text(
                                                                                      "Due Amount : ",
                                                                                      style: TextStyle(color: Utils().background,   fontSize: 15,
                                                                                        fontWeight: FontWeight.bold,),
                                                                                    ),
                                                                                    Text(NumberFormat.currency(
                                                                                      locale: 'en_IN', // Indian style formatting
                                                                                      symbol: '₹',
                                                                                      decimalDigits: 0,
                                                                                    ).format(loansdata['emi_pending']), style: TextStyle(color: Utils().background,   fontSize: 15,
                                                                                      fontWeight: FontWeight.bold,),)
                                                                                    // Text(
                                                                                    //   "₹${loansdata['emi_pending'].toString()}",
                                                                                    //   style: TextStyle(color: Utils().background,   fontSize: 15,
                                                                                    //     fontWeight: FontWeight.bold,),
                                                                                    // ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(height: 20,),
                                                                    Card(
                                                                      elevation: 5,
                                                                      color: Utils().background,
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(8),
                                                                            border: Border.all(
                                                                              width: 0.5,
                                                                              color: Utils().border_1,
                                                                            )
                                                                        ),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(15.0),
                                                                          child: Column(
                                                                            children: [
                                                                              Text("Loan Info",style: TextStyle(
                                                                                fontSize: 16,
                                                                                color: Utils().text,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),),
                                                                              Card(
                                                                                elevation: 1,
                                                                                child: Container(
                                                                                  width: 620,
                                                                                  decoration: BoxDecoration(
                                                                                    boxShadow: [
                                                                                      BoxShadow(
                                                                                          offset: Offset(0, 0),
                                                                                          blurRadius: 2,
                                                                                          color: Color(0xff000000).withAlpha(20)
                                                                                      )
                                                                                    ],
                                                                                    borderRadius: BorderRadius.circular(8), // rounded gradient border
                                                                                  ),
                                                                                  child: Container(
                                                                                    margin: const EdgeInsets.all(1), // thickness of border
                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors.white, // inner background
                                                                                      borderRadius: BorderRadius.circular(8), // inner radius (slightly smaller)
                                                                                    ),
                                                                                    child: Row(
                                                                                      spacing: 7,
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(12.0),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              Text("Principal AMT"),
                                                                                              Text(NumberFormat.currency(
                                                                                                locale: 'en_IN', // Indian style formatting
                                                                                                symbol: '₹',
                                                                                                decimalDigits: 0,
                                                                                              ).format(loansdata['principal_amount']),)
                                                                                              // Text("₹${loansdata['principal_amount']}"),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          height: 55,
                                                                                          width: 1,
                                                                                          color: Colors.black26,
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(12.0),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              Text("Interest"),
                                                                                              Text(
                                                                                                (loansdata['interest_per'] == null || loansdata['interest_per'] == 0)
                                                                                                    ? "-"
                                                                                                    : "${loansdata['interest_per']}%",
                                                                                                style: TextStyle(fontSize: 12, color: Utils().text),
                                                                                                textAlign: TextAlign.center,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          height: 55,
                                                                                          width: 1,
                                                                                          color: Colors.black26,
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(12.0),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              Text(
                                                                                                "INT Amount",
                                                                                              ),
                                                                                              Text(
                                                                                                "₹${totalInterest.round()}",
                                                                                                style: TextStyle(fontSize: 12, color: Utils().text),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          height: 55,
                                                                                          width: 1,
                                                                                          color: Colors.black26,
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(12.0),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              Text("Penalty Amount"),
                                                                                              Text(NumberFormat.currency(
                                                                                                locale: 'en_IN', // Indian style formatting
                                                                                                symbol: '₹',
                                                                                                decimalDigits: 0,
                                                                                              ).format(_calculatePenalty()),)
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          height: 55,
                                                                                          width: 1,
                                                                                          color: Colors.black26,
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(12.0),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              Text("Other Amount"),
                                                                                              Text(NumberFormat.currency(
                                                                                                locale: 'en_IN', // Indian style formatting
                                                                                                symbol: '₹',
                                                                                                decimalDigits: 0,
                                                                                              ).format(_calculateOtherAmount()),)
                                                                                              // Text(
                                                                                              //   "₹${loansController.getUserTotalEmi(loansdata).round()}",
                                                                                              // ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        // Container(
                                                                                        //   height: 55,
                                                                                        //   width: 1,
                                                                                        //   color: Colors.black26,
                                                                                        // ),
                                                                                        // Padding(
                                                                                        //   padding: const EdgeInsets.all(12.0),
                                                                                        //   child: Column(
                                                                                        //     children: [
                                                                                        //       Text("Total"),
                                                                                        //       Text(NumberFormat.currency(
                                                                                        //         locale: 'en_IN', // Indian style formatting
                                                                                        //         symbol: '₹',
                                                                                        //         decimalDigits: 0,
                                                                                        //       ).format(loansController.getUserTotalEmi(loansdata).round()),)
                                                                                        //       // Text(
                                                                                        //       //   "₹${loansController.getUserTotalEmi(loansdata).round()}",
                                                                                        //       // ),
                                                                                        //     ],
                                                                                        //   ),
                                                                                        // ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(height: 15,),
                                                                              Text("No of Instalment(Month)",style: TextStyle(
                                                                                fontSize: 16,
                                                                                color: Utils().text,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),),
                                                                              Card(
                                                                                elevation: 1,
                                                                                child: Container(
                                                                                  width : 570,
                                                                                  decoration: BoxDecoration(
                                                                                    boxShadow: [
                                                                                      BoxShadow(
                                                                                          offset: Offset(0, 0),
                                                                                          blurRadius: 2,
                                                                                          color: Color(0xff000000).withAlpha(20)
                                                                                      )
                                                                                    ],
                                                                                    borderRadius: BorderRadius.circular(8), // rounded gradient border
                                                                                  ),
                                                                                  child: Container(
                                                                                    margin: const EdgeInsets.all(1), // thickness of border
                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors.white, // inner background
                                                                                      borderRadius: BorderRadius.circular(8), // inner radius (slightly smaller)
                                                                                    ),
                                                                                    child: Row(
                                                                                      spacing: 15,
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(12.0),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              Text("Emi Amount"),
                                                                                              Text(NumberFormat.currency(
                                                                                                locale: 'en_IN', // Indian style formatting
                                                                                                symbol: '₹',
                                                                                                decimalDigits: 0,
                                                                                              ).format(loansdata['emi_amount']),)
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          height: 55,
                                                                                          width: 1,
                                                                                          color: Colors.black26,
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(12.0),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              Text("Duration"),
                                                                                              Text("${loansdata['tenure']}"),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          height: 55,
                                                                                          width: 1,
                                                                                          color: Colors.black26,
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(12.0),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              Text("Paid : ", style: TextStyle(color: Colors.green)),
                                                                                              Text((emiStatus["Paid"] ?? loansdata['tenure']).toString(), style: TextStyle(color: Colors.green)),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          height: 55,
                                                                                          width: 1,
                                                                                          color: Colors.black26,
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(12.0),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              Text("Due : ", style: TextStyle(color: Colors.red)),
                                                                                              Text("${(emiStatus["Due"] ?? 0).toString()} (${NumberFormat.currency(locale: 'en_IN', // Indian style formatting
                                                                                                symbol: '₹',
                                                                                                decimalDigits: 0,).format(loansdata['due_emi_amount'])})", style: TextStyle(color: Colors.red)),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          height: 55,
                                                                                          width: 1,
                                                                                          color: Colors.black26,
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(12.0),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              Text("Partial : ", style: TextStyle(color: Colors.orange)),
                                                                                              Text((emiStatus["Partial"] ?? 0).toString(), style: TextStyle(color: Colors.orange)),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          );
                                        }
                                    );
                                  }),
                                  DataRow(
                                    color: MaterialStateProperty.all(Colors.white), // your custom color
                                    cells: [
                                      const DataCell(Text("")),
                                      const DataCell(Center(child: Text("Total", style: TextStyle(fontWeight: FontWeight.bold)))),
                                      DataCell(Center(child: Text(NumberFormat.currency(
                                        locale: "en_IN",
                                        symbol: '₹',
                                        decimalDigits: 0,
                                      ).format(_calculateTotalLoanAmount()),style: TextStyle(color: Utils().text,fontWeight: FontWeight.w600,fontSize: 14),))),
                                      const DataCell(Text("")),
                                      DataCell(Center(child: Text(NumberFormat.currency(
                                        locale: "en_IN",
                                        symbol: '₹',
                                        decimalDigits: 0,
                                      ).format(_calculateTotalInterestAmount()),style: TextStyle(color: Utils().text,fontWeight: FontWeight.w600,fontSize: 14),))),                                      DataCell(Center(child: Text(NumberFormat.currency(
                                        locale: "en_IN",
                                        symbol: '₹',
                                        decimalDigits: 0,
                                      ).format(_calculateDownPayment()),style: TextStyle(color: Utils().text,fontWeight: FontWeight.w600,fontSize: 14),))),
                                      DataCell(Center(child: Text(NumberFormat.currency(
                                        locale: "en_IN",
                                        symbol: '₹',
                                        decimalDigits: 0,
                                      ).format(_calculateServiceCharge()),style: TextStyle(color: Utils().text,fontWeight: FontWeight.w600,fontSize: 14),))),
                                      const DataCell(Text("")),
                                      DataCell(Center(child: Text(NumberFormat.currency(
                                        locale: "en_IN",
                                        symbol: '₹',
                                        decimalDigits: 0,
                                      ).format(_calculateEmiAmount()),style: TextStyle(color: Utils().text,fontWeight: FontWeight.w600,fontSize: 14),))),
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
                                      ).format(_calculateEmiPaid()),style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600,fontSize: 14),))),
                                      const DataCell(Text("")),
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
                    );
                  }
              )),
        ],
      ),
    );
  }
  bool isBigScreen(){
    return (MediaQuery.of(context).size.width > 700);
  }
  double _calculateTotalCredit() {
    double total = 0;
    for (var loan in loansController.balanceData) {
      total += double.tryParse(loan['credit'].toString()) ?? 0;
    }
    return total;
  }
  double _calculateTotalDebit() {
    double total = 0;
    for (var loan in loansController.balanceData) {
      total += double.tryParse(loan['debit'].toString()) ?? 0;
    }
    return total;
  }

  double _calculateTotalLoanAmount() {
    double total = 0;
    for (var loan in loansController.loansData) {
      total += double.tryParse(loan['principal_amount'].toString()) ?? 0;
    }
    return total;
  }
  double _calculateDownPayment() {
    double downPayment = 0;
    for (var loan in loansController.loansData) {
      downPayment += double.tryParse(loan['down_payment'].toString()) ?? 0;
    }
    return downPayment;
  }
  double _calculateServiceCharge() {
    double serviceFees = 0;
    for (var loan in loansController.loansData) {
      serviceFees += double.tryParse(loan['service_charge'].toString()) ?? 0;
    }
    return serviceFees;
  }
  double _calculateEmiAmount() {
    double emiAmount = 0;
    for (var loan in loansController.loansData) {
      emiAmount += double.tryParse(loan['emi_amount'].toString()) ?? 0;
    }
    return emiAmount;
  }
  double _calculateEmiPending() {
    double emiPending = 0;
    for (var loan in loansController.loansData) {
      emiPending += double.tryParse(loan['emi_pending'].toString()) ?? 0;
    }
    return emiPending;
  }
  double _calculateEmiPaid() {
    double emiPaid = 0;
    for (var loan in loansController.loansData) {
      emiPaid += double.tryParse(loan['emi_paid'].toString()) ?? 0;
    }
    return emiPaid;
  }
  double _calculateTotalInterestAmount() {
    double totalInterest = 0;
    for (var loan in loansController.loansData) {
      final loanAmount = double.tryParse(loan['principal_amount'].toString()) ?? 0.0;
      final amountEmi = double.tryParse(loan['emi_amount'].toString()) ?? 0.0;
      final tenure = int.tryParse(loan['tenure'].toString()) ?? 0;

      final double regularLoan = (amountEmi * tenure) - loanAmount;
      final double interestLoan = (amountEmi * tenure);

      totalInterest += loan['type'] == "regular" ? regularLoan : interestLoan;
    }
    return totalInterest;
  }
}

