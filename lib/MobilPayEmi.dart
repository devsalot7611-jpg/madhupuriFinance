import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:madhupurifinance/Controller/HomeLoanController.dart';
import 'package:madhupurifinance/Controller/PayEmiController.dart';
import 'package:madhupurifinance/Controller/loansController.dart';
import 'package:madhupurifinance/Utils.dart';

class MobilPayEmi extends StatefulWidget {
  const MobilPayEmi({super.key});

  @override
  State<MobilPayEmi> createState() => _MobilPayEmiState();
}

class _MobilPayEmiState extends State<MobilPayEmi> {

  final PayEmiController payEmiController = Get.put(PayEmiController());
  final LoansController loansController = Get.put(LoansController());
  final HomeLoanController homeLoanController = Get.put(HomeLoanController());
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
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: payEmiController.devSelectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      payEmiController.devSelectedDate = picked;                   // store raw date
      _dateCtrl.text =
          DateFormat('dd-MM-yyyy').format(picked);            // update field
    }
  }
  @override
  @override
  void initState() {
    super.initState();
    payEmiController.paymentDate.text =
        DateFormat('dd-MM-yyyy').format(DateTime.now());
    payEmiController.devSelectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _dateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (payEmiController.paymentDate.text.isEmpty) {
      payEmiController.paymentDate.text =
          DateFormat('dd-MM-yyyy').format(DateTime.now());
      payEmiController.devSelectedDate = DateTime.now();
    }
    return Scaffold(
      backgroundColor: Utils().background,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Utils().background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text("PayEmi",style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w400,
          color: Utils().text,
        ),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16,right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Name        :",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Utils().text,
                              fontSize: 14
                          ),),
                          SizedBox(width: 5,),
                          Text(payEmiController.mobilName.toString(),
                            style: TextStyle(fontSize: 14,color: Utils().text),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Text("KYC ID      :",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Utils().text,
                              fontSize: 14
                          ),),
                          SizedBox(width: 5,),
                          Text(payEmiController.mobilKycID.toString(),
                            style: TextStyle(fontSize: 14,color: Utils().text),
                          )
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Text("loan Date :",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Utils().text,
                              fontSize: 14
                          ),),
                          SizedBox(width: 3,),
                          Text(
                            DateFormat('dd-MM-yyyy').format(DateTime.parse(payEmiController.mobilLoanDate.toString())),
                            style: TextStyle(fontSize: 14, color: Utils().text),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Loan ID                :",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Utils().text,
                              fontSize: 14
                          ),),
                          SizedBox(width: 3,),
                          Text(payEmiController.mobilLoanId.toString(),
                            style: TextStyle(fontSize: 14,color: Utils().text),
                          )
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Text("Loan Amount      :",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Utils().text,
                              fontSize: 14
                          ),),
                          SizedBox(width: 3,),
                          Text(payEmiController.mobilLoanAmount.toString(),
                            style: TextStyle(fontSize: 14,color: Utils().text),
                          )
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Text("Old pending Emi :",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Utils().text,
                              fontSize: 14
                          ),),
                          SizedBox(width: 3,),
                          Text( payEmiController.mobilOldPendingEmi.toString(),
                            style: TextStyle(fontSize: 14,color: Utils().text),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Form(
                  key: payEmiController.emiFormKye,
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Emi Amount",style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Utils().text,
                      fontSize: 16
                  ),),
                  SizedBox(
                    width:  Get.width,
                    child: TextFormField(
                      autofocus: true,
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
                      controller: payEmiController.emiPreMonth,
                      decoration: InputDecoration(
                        labelText: "Emi Amount",
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
                  Text("Penalty",style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Utils().text,
                      fontSize: 16
                  ),),
                  SizedBox(
                    width: Get.width,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, // Allows only digits
                        LengthLimitingTextInputFormatter(10),   // Optional: Limit to 10 digits
                      ],
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Requried this field';
                      //   }
                      //   return null; // validation passed
                      // },
                      controller: payEmiController.penalty,
                      decoration: InputDecoration(
                        labelText: "Penalty",
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
                  Text("Other Amount",style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Utils().text,
                      fontSize: 16
                  ),),
                  SizedBox(
                    width: Get.width,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, // Allows only digits
                        LengthLimitingTextInputFormatter(10),   // Optional: Limit to 10 digits
                      ],
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Requried this field';
                      //   }
                      //   return null; // validation passed
                      // },
                      controller: payEmiController.other_amount,
                      decoration: InputDecoration(
                        labelText: "Other Amount",
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
                  Text("Emi Date",style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Utils().text,
                      fontSize: 16
                  ),),
                  SizedBox(
                      width:  Get.width,
                      child: TextFormField(
                        controller: payEmiController.paymentDate,
                        onChanged: (value){
                          payEmiController.devSelectedDate = DateFormat('dd-MM-yyyy').parseStrict(value);
                        },
                        validator: (value) =>
                        (value == null || value.isEmpty) ? 'Required this field' : null,
                        decoration: InputDecoration(
                          labelText: 'Emi date',
                          labelStyle: TextStyle(fontSize: 12, color: Utils().border_1),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_month_outlined, color: Utils().border_1),
                            onPressed: () => _pickDate(), // will update .text
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
                      )
                  ),
                ],
              )),
              SizedBox(height: 20,),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    if(payEmiController.emiFormKye.currentState!.validate()){
                      setState(() {
                        loansController.addLoans.value = true;
                      });
                      await payEmiController.PaymentReceived(context,payEmiController.mobilLoanId.toString());
                      // payEmiController.success  ?? initMethodCalling();
                      if(payEmiController.success != null && payEmiController.success == "true")
                      {
                        initMethodCalling();
                      }
                      // ?  : Text("");
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
                          "Pay Emi",
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
  }
}
