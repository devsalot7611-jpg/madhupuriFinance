import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:madhupurifinance/Controller/loansController.dart';
import 'package:madhupurifinance/Utils.dart';

import 'Controller/FormController.dart';
import 'Controller/KycListController.dart';
import 'Controller/PayEmiController.dart';

class MobileAddLoan extends StatefulWidget {
  const MobileAddLoan({super.key});

  @override
  State<MobileAddLoan> createState() => _MobileAddLoanState();
}

class _MobileAddLoanState extends State<MobileAddLoan> {

  final LoansController loansController = Get.put(LoansController());
  final FormController formController = Get.put(FormController());
  final PayEmiController payEmiController = Get.put(PayEmiController());
  final double width = 10;
  final ScrollController horizontalScroll = ScrollController();
  bool downloadIndicators = false;
  final KycListController kycListController = Get.put(KycListController());
  bool loanPdf = false;
  bool loanPdfEmpty = false;
  var selectIndex;
  var payIndex;
  var pdfIndex;

  late final TextEditingController _dateCtrl;
  void initMethodCalling() async{
    setState(() {
      loansController.loansData.clear();
      loansController.loans.clear();
    });
    await loansController.getLoans();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Utils.activeIndex = Utils.LOANS;
    initMethodCalling();

    payEmiController.paymentDate = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(DateTime.now()),

    );
  }
  void dispose() {
    payEmiController.paymentDate.dispose();
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
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Utils().background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text("Add Loan",style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w400,
          color: Utils().text,
        ),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16,right: 16),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                  key: loansController.loansKey,
                  child: Column(
                    spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Full Name",style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Utils().text,
                    fontSize: 16,
                  ),),
                  SizedBox(
                    width:  Get.width,
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
                          width: Get.width,
                          child: ListTile(
                            title: Row(
                              children: [
                                Text(value["id"].toString(),style: TextStyle(fontSize: 12,color: Utils().text,fontWeight: FontWeight.bold),),
                                SizedBox(width: 5,),
                                Text("${value["first_name"].toString()} ${value["middle_name"].toString()} ${value["last_name"].toString()}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Utils().text),),
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
                  Text("KYC ID",style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Utils().text,
                    fontSize: 16,
                  ),),
                  SizedBox(
                    width: Get.width,
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
                  Text("principal amount",style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Utils().text,
                    fontSize: 16,
                  ),),
                  SizedBox(
                    width:Get.width,
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
                      controller: loansController.totalAmount,
                      decoration: InputDecoration(
                        labelText: "principal amount",
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
                  Text("Down Payment",style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Utils().text,
                    fontSize: 16,
                  ),),
                  SizedBox(
                    width:  Get.width,
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
                  Text("Duration",style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Utils().text,
                    fontSize: 16,
                  ),),
                  SizedBox(
                    width: Get.width,
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
                      controller: loansController.durationEmi,
                      decoration: InputDecoration(
                        labelText: "Duration",
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
                  Text("Emi Amount",style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Utils().text,
                    fontSize: 16,
                  ),),
                  SizedBox(
                    width: Get.width,
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
                      controller: loansController.monthEmi,
                      decoration: InputDecoration(
                        labelText: "emi amount",
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
                  Text("Loan Date",style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Utils().text,
                    fontSize: 16,
                  ),),
                  SizedBox(
                    width: Get.width,
                    child: TextFormField(
                      onChanged: (value) {
                        try {
                          loansController.selectedLoanDate = DateFormat('dd-MM-yyyy').parseStrict(value);
                        } catch (e) {
                          loansController.selectedLoanDate = DateTime.now(); // fallback
                          print("Invalid date format entered: $e");
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
                ],
              )),
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
                      width: Get.width * 0.500,
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
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}
