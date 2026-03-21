
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:madhupurifinance/AddKyc.dart';
import 'package:madhupurifinance/Controller/FormController.dart';
import 'package:madhupurifinance/Controller/KycListController.dart';
import 'package:madhupurifinance/DownloadForm.dart';
import 'package:madhupurifinance/HomeSacreen.dart';
import 'package:madhupurifinance/PdfRawData.dart';
import 'package:madhupurifinance/Utils.dart';
import 'package:madhupurifinance/downloadPDF.dart';
import 'package:madhupurifinance/mobilAddKyc.dart';
import 'package:madhupurifinance/mobileEdit.dart';
import 'package:madhupurifinance/mobileUi.dart';
import 'package:madhupurifinance/pdf.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'Controller/LoginController.dart';
import 'package:get/get.dart';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

import 'Controller/loansController.dart';


class Kyclist extends StatefulWidget {
  final Map<String, dynamic> data;
  const Kyclist({super.key, required this.data});

  @override
  State<Kyclist> createState() => _KyclistState();
}

class _KyclistState extends State<Kyclist> {


  final FormController formController = Get.put(FormController());
  final LoansController loansController = Get.put(LoansController());
  bool isKycChecked = false;
  final ScrollController horizontalScroll = ScrollController();
  final ScrollController verticalScroll = ScrollController();
  final double width = 10;
  final KycListController kycListController = Get.put(KycListController());
  final LoginController loginController = Get.put(LoginController());
  var selectIndex;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showData();
    Utils.activeIndex = Utils.KYC;
    // downloadIndicators = List.generate(formController.data.length, (_) => false);
    // clearForm();
  }
  void clearForm() {
    // Clear image paths
    formController.userImage.value = '';
    formController.backImage.value = '';
    formController.frontId.value = '';

    // Also reset file or preview variables if needed
    formController.personImage.value = null;
    formController.backId.value = null;
    formController.idImageFront.value = null;

    // Clear text fields if neede
    //... clear other fields too
  }
  // List<bool> downloadIndicators = [];


  showData() async {
    setState(() {
      formController.data.clear();
    });
    await formController.showKycDetails();
    setState(() {

    });
  }
 // Initialize based on data length

bool downloadIndicators = false;
  bool indicater = false;
  bool pdfLoader = false;
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text("KYCs",style: TextStyle(
                  fontSize: isBigScreen() ? 22 : 16,
                  fontWeight: FontWeight.w700,
                  color: Utils().text,
                ),),
              ),
              SizedBox(width: MediaQuery.of(context).size.width*0.06,),
              Expanded(
                child: SizedBox(
                  height: isBigScreen() ? 35 : 30,
                  // width: MediaQuery.of(context).size.width * 0.300,
                  child: TextField(
                    controller: formController.searchController,
                    onChanged: (value) {
                      setState(() {
                        formController.runFilter(value);
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
                      print("dev kyc No : ${kycListController.kycNo}");
                      final screenWidth = MediaQuery.of(context).size.width;
                      final formKey = GlobalKey<FormState>();
                      await kycListController.kycID();
                      // Clear form fields
                        formController.firstName.clear();
                        formController.middleName.clear();
                        formController.lastName.clear();
                        formController.mobileNumber.clear();
                        formController.referenceName.clear();
                        formController.referenceNumber.clear();
                        formController.referenceNomineeName.clear();
                        formController.idProofNumber.clear();
                        formController.bankName.clear();
                        formController.bankAccNumber.clear();
                        formController.IFSCcode.clear();
                        formController.secondaryMobileNumber.clear();
                        formController.addressLine1.clear();
                        formController.addressLine2.clear();
                        formController.area.clear();
                        formController.district.clear();
                        formController.state.clear();
                        formController.pinCode.clear();
                        formController.reAddressLine1.clear();
                        formController.reAddressLine2.clear();
                        formController.reArea.clear();
                        formController.reDistrict.clear();
                        formController.reState.clear();
                        formController.rePinCode.clear();
                        formController.userImage.value = '';
                        formController.personImage.value = null;
                        formController.backImage.value = '';
                        formController.backId.value = null;
                        formController.frontId.value = '';
                        formController.idImageFront.value = null;

                        // 🧼 Reset error flags
                        formController.imageError.value = false;
                        formController.frontImageError.value = false;
                        formController.backImageError.value = false;
                      formController.selectPhotoIdDoc.value = '';
                      formController.selectPhotoIdDocError.value = false;

                      clearForm();

                      if (screenWidth > 700) {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          constraints: BoxConstraints(
                            maxWidth: screenWidth,
                          ),
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setModalState) {
                                return SingleChildScrollView(
                                  child: Container(
                                    width: screenWidth,
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
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Kyc(formKey: formKey),
                                        SizedBox(height: 10),
                                        userInformation(formKey: formKey),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MobilAddKyc(formKey: formKey),
                          ),
                        );
                      }
                    },
                      child: Container(
                      padding: EdgeInsets.all(4),
                      // width: isBigScreen() ? MediaQuery.of(context).size.width * 0.05 : MediaQuery.of(context).size.width * 0.010 ,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(colors: [
                            Utils().border_1,
                            Utils().button,
                          ])
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.add,color: Utils().addKyc,size: 14,),
                            Text("Add KYC",style: TextStyle(
                                fontSize: isBigScreen() ? 14 :12,
                                fontWeight: FontWeight.w500,
                                color: Utils().addKyc
                            ),),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),

                  GestureDetector(
                    // onTap: (){
                    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DownloadForm()));
                    // },
                    onTap: () async {
                      setState(() {
                        kycListController.pdfLoader = true.obs;
                      });
                      // loans
                      await kycListController.FomrNumber();
                      Get.to(generatePdf());
                      await PdfRawData().generatePDF(null);
                      setState(() {
                        kycListController.pdfLoader = false.obs;
                      });
                    },

                    child: Obx(() => Container(
                      padding: EdgeInsets.all(4),
                      height: 30,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(colors: [
                          Utils().border_1,
                          Utils().button,
                        ]),
                      ),
                      child: Center(
                        child:  kycListController.pdfLoader.value
                            ? CircularProgressIndicator(
                          strokeWidth: 1,
                          color: Utils().background,
                        )
                            : Row(
                              children: [
                                Icon(Icons.download,color: Colors.white,size: 14,),
                                Text("KYC Form", style: TextStyle(color: Colors.white)),
                              ],
                            ),
                      ),
                    )),
                  ),
                  SizedBox(width: 10,),
                  Obx(() {
                    final isExporting = formController.isExportingPdf.value;

                    return GestureDetector(
                      onTap: () async {
                        if (!isExporting) {
                          await formController.exportToPdf(formController.data);
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
                      ) :
                      SizedBox(
                          height: 50,
                          width: 50,
                          child: SvgPicture.asset("assets/images/pdf.svg")),
                    );
                  }),
                  SizedBox(width: 20),
                  Obx(() {
                    return GestureDetector(
                      onTap: () async {
                        if (!formController.isExportingExcel.value) {
                          await formController.exportToExcel(formController.data);
                        }
                      },
                      child: formController.isExportingExcel.value
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
                ],
              ),

            ],
          ),
          SizedBox(height: 5,),

          formController.dataTwo.isEmpty?Center(
            child: formController.errorMessage.value.isEmpty?CircularProgressIndicator():Text(formController.errorMessage.value,style: TextStyle(color: Colors.red),),
          ):formController.data.isEmpty?Center(
            child: Center(
              child: Text("No KYC found similar to your search."),
            ),
          ): Expanded(child: LayoutBuilder(
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
                          // Table header (not scrollable vertically)
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                // begin: Alignment.centerLeft, // Start from the left
                                // end: Alignment.centerRight,  // End at the right
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
                                DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0350:20,child: Center(child: Text('KYC\nID',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)))),
                                DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.041:50,child: Center(child: Text('Profile',style: TextStyle(color: Colors.white),)))),
                                DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.18:150,child: Center(child: Text('Name',style: TextStyle(color: Colors.white),)))),
                                DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.08:90,child: Center(child: Text('Mobile',style: TextStyle(color: Colors.white),)))),
                                DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.08:100,child: Center(child: Text('ID Proof',style: TextStyle(color: Colors.white),)))),
                                DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0990:150,child: Center(child: Text('ID Proof Number',style: TextStyle(color: Colors.white),)))),
                                DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.252:130,child: Center(child: Text('Address',style: TextStyle(color: Colors.white),)))),
                                DataColumn(label: SizedBox(width:isBigScreen()?(MediaQuery.of(context).size.width-75)*0.099:100,child: Center(child: Text('Created Date',style: TextStyle(color: Colors.white),)))),
                                DataColumn(label: SizedBox(width:75,child: Center(child: Text('Actions',style: TextStyle(color: Colors.white),)))),
                              ],
                              rows: [],
                            ),
                          ),

                          // Scrollable DataTable rows
                          Expanded(
                            child: SingleChildScrollView(
                              child: DataTable(
                                dataRowMinHeight: 27,
                                dataRowMaxHeight: 32,
                                border: TableBorder.all(
                                  color: Colors.black12,
                                  width: 1.0,
                                ),
                                showCheckboxColumn: false,
                                columnSpacing: 5,
                                headingRowHeight: 0,
                                columns: [
                                  DataColumn(label: SizedBox(width: 0,height: 0,child: Text('ID'))),
                                  DataColumn(label: SizedBox(width: 0,height: 0,child: Text('ID'))),
                                  DataColumn(label: SizedBox(width: 0,height: 0,child: Text('ID'))),
                                  DataColumn(label: SizedBox(width: 0,height: 0,child: Text('ID'))),
                                  DataColumn(label: Container(width: 0,height: 0,child: Text('ID'))),
                                  DataColumn(label: Container(width: 0,height: 0,child: Text('ID'))),
                                  DataColumn(label: Container(width: 0,height: 0,child: Text('ID'))),
                                  DataColumn(label: Container(width: 0,height: 0,child: Text('ID'))),
                                  DataColumn(label: Container(width: 0,height: 0,child: Text('ID'))),
                                ],
                                rows:
                                List.generate(formController.data.length, (index) {
                                  final data = formController.data[index];
                                  return DataRow(cells: [
                                    DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0350:20,child: Center(child: Text(data['id'].toString(),style: TextStyle(fontSize: 12),)))),
                                    DataCell(Image.network(
                                      data['profile_img'].toString(),
                                      height: 30,
                                      width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.034:40,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset("assets/images/no-image.png",
                                            height: 30, width: 50);
                                      },
                                    )),
                                    DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.18:150, child: Center(child: Text("${data['first_name']} ${data['middle_name']} ${data['last_name']}",style: TextStyle(fontSize: 12),maxLines: 2,)))),
                                    DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.08:100,child: Center(child: Text(data['mobile_no'].toString())))),
                                    // DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0900:150, child: Text(data['reference_name'].toString(), overflow: TextOverflow.ellipsis,),)),
                                    // DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0920:150,child: Text(data['reference_contact_no'].toString(),style: TextStyle(fontSize: 12),))),
                                    // DataCell(Container(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0980:150,child: Text(data['secondary_mobile_no'].toString(),style: TextStyle(fontSize: 12),))),
                                    // DataCell(Container(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0900:110,child: Text(data['bank_name'].toString(),style: TextStyle(fontSize: 12),))),
                                    // DataCell(Container(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.1:130,child: Text('${data['bank_acc_no'].toString()}',style: TextStyle(fontSize: 12),))),
                                    // DataCell(Container(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0800:150,child: Text('${data['bank_ifsc_code'].toString()}',style: TextStyle(fontSize: 12),))),
                                    DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0800:130,child: Center(child: Text('${data['profile_id_type'].toString()}',style: TextStyle(fontSize: 12),)))),
                                    DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.0990:130,child: Center(child: Text('${data['profile_id_no'].toString()}',style: TextStyle(fontSize: 12),)))),
                                    DataCell(SizedBox(width: isBigScreen()?(MediaQuery.of(context).size.width-75)*0.252:130,child: Center(child: Text('${data['permanent_address'].toString()}',style: TextStyle(fontSize: 12),maxLines: 2,overflow: TextOverflow.ellipsis,)))),
                                    DataCell(
                                      SizedBox(
                                        width: isBigScreen() ? (MediaQuery.of(context).size.width-75) * 0.1 : 100,
                                        child: Center(
                                          child: Text(
                                            DateFormat("dd-MM-yyyy").format(
                                              DateTime.parse(data['creation_datetime']),
                                            ),
                                            style: TextStyle(fontSize: 14), // 👈 Set your desired font size here
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(SizedBox(
                                      width: 72,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: IconButton(
                                              icon: Icon(Icons.remove_red_eye_rounded,size: 18,
                                                  color: Utils().button),
                                               padding: EdgeInsets.all(0),
                                              onPressed: () {
                                                formController.firstName.clear();
                                                formController.middleName.clear();
                                                formController.lastName.clear();
                                                formController.mobileNumber.clear();
                                                formController.referenceName.clear();
                                                formController.referenceNumber.clear();
                                                formController.referenceNomineeName.clear();
                                                formController.idProofNumber.clear();
                                                formController.bankName.clear();
                                                formController.bankAccNumber.clear();
                                                formController.IFSCcode.clear();
                                                formController.secondaryMobileNumber.clear();
                                                formController.addressLine1.clear();
                                                formController.addressLine2.clear();
                                                formController.area.clear();
                                                formController.district.clear();
                                                formController.state.clear();
                                                formController.pinCode.clear();
                                                formController.reAddressLine1.clear();
                                                formController.reAddressLine2.clear();
                                                formController.reArea.clear();
                                                formController.reDistrict.clear();
                                                formController.reState.clear();
                                                formController.rePinCode.clear();
                                                formController.userImage.value = '';
                                                formController.personImage.value = null;
                                                formController.backImage.value = '';
                                                formController.backId.value = null;
                                                formController.frontId.value = '';
                                                formController.idImageFront.value = null;

                                                // 🧼 Reset error flags
                                                formController.imageError.value = false;
                                                formController.frontImageError.value = false;
                                                formController.backImageError.value = false;
                                                formController.selectPhotoIdDoc.value = '';
                                                formController.selectPhotoIdDocError.value = false;
                                                final screenWidth = MediaQuery.of(context).size.width;

                                                if (screenWidth > 700) {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    backgroundColor: Colors.transparent,
                                                    constraints: BoxConstraints(
                                                      maxWidth: screenWidth,
                                                    ),
                                                    builder: (context) {
                                                      return StatefulBuilder(
                                                        builder: (context, setModalState) {
                                                          return Container(
                                                            width: screenWidth,
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
                                                            padding: EdgeInsets.all(10),
                                                            child: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                EditviewDetails(data: formController.data[index]),
                                                                SizedBox(height: 10),
                                                                viewUserInformation(data: formController.data[index]),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Mobileui(data: formController.data[index],),));
                                                }
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: IconButton(
                                              icon: Icon(Icons.edit, color: Utils().button, size: 18),
                                              padding: EdgeInsets.all(0),
                                              iconSize: 18,
                                              onPressed: () {
                                                final formKey = GlobalKey<FormState>();
                                                final screenWidth = MediaQuery.of(context).size.width;
                                                if (index >= 0 && index < formController.data.length) {
                                                  final currentData = formController.data[index];

                                                  if (screenWidth > 700) {
                                                    showModalBottomSheet(
                                                      constraints: BoxConstraints(
                                                        maxWidth: screenWidth,
                                                      ),
                                                      context: context,
                                                      isScrollControlled: true,
                                                      backgroundColor: Colors.transparent,
                                                      builder: (context) {
                                                        return StatefulBuilder(
                                                          builder: (context, setModalState) {
                                                            return Container(
                                                              width: screenWidth,
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
                                                              padding: EdgeInsets.all(10),
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  // problem
                                                                  Edit(data: currentData, formKey: formKey),
                                                                  SizedBox(height: 10),
                                                                  EdituserInformation(data: currentData, formKey: formKey),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => MobileEdit(data: currentData, formKey: formKey),
                                                      ),
                                                    );
                                                  }
                                                } else {
                                                  print("Invalid index: $index");
                                                }
                                              },
                                            ),
                                           ),
                                          SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: selectIndex == index && downloadIndicators
                                                ? CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Utils().button),
                                            )
                                                : IconButton(
                                              icon: Icon(Icons.download, color: Utils().button, size: 18),
                                              padding: EdgeInsets.all(0),
                                              onPressed: () async {
                                                selectIndex = index;
                                                await kycListController.FomrNumber();
                                                setState(() => downloadIndicators = true);
                                                await PdfRawData().generatePDF(formController.data[index]);
                                                setState(() => downloadIndicators = false);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                  ],
                                  onSelectChanged: (select){
                                    formController.firstName.clear();
                                    formController.middleName.clear();
                                    formController.lastName.clear();
                                    formController.mobileNumber.clear();
                                    formController.referenceName.clear();
                                    formController.referenceNumber.clear();
                                    formController.referenceNomineeName.clear();
                                    formController.idProofNumber.clear();
                                    formController.bankName.clear();
                                    formController.bankAccNumber.clear();
                                    formController.IFSCcode.clear();
                                    formController.secondaryMobileNumber.clear();
                                    formController.addressLine1.clear();
                                    formController.addressLine2.clear();
                                    formController.area.clear();
                                    formController.district.clear();
                                    formController.state.clear();
                                    formController.pinCode.clear();
                                    formController.reAddressLine1.clear();
                                    formController.reAddressLine2.clear();
                                    formController.reArea.clear();
                                    formController.reDistrict.clear();
                                    formController.reState.clear();
                                    formController.rePinCode.clear();
                                    formController.userImage.value = '';
                                    formController.personImage.value = null;
                                    formController.backImage.value = '';
                                    formController.backId.value = null;
                                    formController.frontId.value = '';
                                    formController.idImageFront.value = null;

                                    // 🧼 Reset error flags
                                    formController.imageError.value = false;
                                    formController.frontImageError.value = false;
                                    formController.backImageError.value = false;
                                    formController.selectPhotoIdDoc.value = '';
                                    formController.selectPhotoIdDocError.value = false;
                                    final screenWidth = MediaQuery.of(context).size.width;

                                    if (screenWidth > 700) {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        constraints: BoxConstraints(
                                          maxWidth: screenWidth,
                                        ),
                                        builder: (context) {
                                          return StatefulBuilder(
                                            builder: (context, setModalState) {
                                              return Container(
                                                width: screenWidth,
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
                                                padding: EdgeInsets.all(10),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    EditviewDetails(data: formController.data[index]),
                                                    SizedBox(height: 10),
                                                    viewUserInformation(data: formController.data[index]),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    } else {
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Mobileui(data: formController.data[index],),));
                                    }
                                  });
                                }),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
          ))
        ],
      ),
    );
  }
  Future<void> generatePdf() async {
    print("PDF BUILDING STARTED");
    ByteData byteData = await rootBundle.load("assets/images/form.png");

    final pdf = pw.Document();
    final image = pw.MemoryImage(byteData.buffer.asUint8List());
    print("MEMORY IMAGE RECEIVED");

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pw.Center(
          child: pw.Image(image,height: PdfPageFormat.a4.height-28,width: PdfPageFormat.a4.width-28),
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );

    // setState(() {
    //   isloader = false;
    // });
  }




  Future<void> detailsPDF() async {
    print("PDF BUILDING STARTED");
    ByteData byteData = await rootBundle.load("assets/images/detailsForm.png");

    final pdf = pw.Document();
    final image = pw.MemoryImage(byteData.buffer.asUint8List());
    print("MEMORY IMAGE RECEIVED");

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Stack(
            children: [
              pw.Container(
                height: PdfPageFormat.a4.height,
                width: PdfPageFormat.a4.width,
                child: pw.Image(image,),
              ),
              // pw.Text("${widget.data['first_name'].toString()}",style: pw.TextStyle(color: PdfColors.red,)),
            ],
          );
        },
      ),
    );


    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );

    // setState(() {
    //   isloader = false;
    // });
  }
  bool isBigScreen(){
    return (MediaQuery.of(context).size.width > 700);
  }

}

