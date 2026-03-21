import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Controller/FormController.dart';
import 'Controller/KycListController.dart';
import 'Utils.dart';
import 'kycList.dart';


class MobilAddKyc extends StatefulWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  MobilAddKyc({super.key,required this.formKey,});

  @override
  State<MobilAddKyc> createState() => _MobilAddKycState();
}

class _MobilAddKycState extends State<MobilAddKyc> {

  final FormController formController = Get.put(FormController());
  final KycListController kycListController = Get.put(KycListController());

  bool isKycChecked = false;

  List<dynamic> photoIdDoc = [];
  List<dynamic> addressDoc = [];




  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    photoIdDoc = await formController.getDocument("photo_id");
    addressDoc = await formController.getDocument("address");
    setState(() {});
  }

  final ValueNotifier<bool> isSameAddress = ValueNotifier(false);

  bool isAddress = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils().background,
      appBar: AppBar(
        backgroundColor: Utils().background,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Kyclist(data: {},),));}, icon: Icon(Icons.arrow_back,color: Utils().text,),),
            Text("Add KYC : ${kycListController.kycNo}",style: TextStyle(
              color: Utils().text,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 12,right: 12),
          child: Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Center(
                  child: Obx(() => Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () {
                        formController.getImage();
                        print("open image");
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Utils().picture,
                          borderRadius: BorderRadius.circular(11),
                          image: formController.personImage.value != null
                              ? DecorationImage(
                            image: MemoryImage(formController.personImage.value!),
                            fit: BoxFit.contain,
                          )
                              : formController.userImage.isNotEmpty
                              ? DecorationImage(
                            image: FileImage(File(formController.userImage.value)),
                            fit: BoxFit.contain,
                          )
                              : null,
                        ),
                        child: formController.userImage.isEmpty && formController.personImage.value == null
                            ? Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_upload,color: Colors.grey,),
                              Text(
                                textAlign: TextAlign.center,
                                "Upload Profile\nImage",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Utils().text,
                                ),
                              ),
                            ],
                          ),
                        )
                            : null,
                      ),
                    ),
                  )),
                ),
                Text("First Name",style: TextStyle(
                  color: Utils().text,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requried this field';
                      }
                      return null; // validation passed
                    },
                    controller: formController.firstName,
                    decoration: InputDecoration(
                      labelText: "First Name",
                      labelStyle: TextStyle(
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
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Text("Middle Name",style: TextStyle(
                  color: Utils().text,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requried this field';
                      }
                      return null; // validation passed
                    },
                    controller: formController.middleName,
                    decoration: InputDecoration(
                      labelText: "Middle Name",
                      labelStyle: TextStyle(
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
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Text("Last Name",style: TextStyle(
                  color: Utils().text,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requried this field';
                      }
                      return null; // validation passed
                    },
                    controller: formController.lastName,
                    decoration: InputDecoration(
                      labelText: "Last Name",
                      labelStyle: TextStyle(
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
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Text("Mobile Number",style: TextStyle(
                  color: Utils().text,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requried this field';
                      }
                      return null; // validation passed
                    },
                    controller: formController.mobileNumber,
                    decoration: InputDecoration(
                      labelText: "Mobile Number",
                      labelStyle: TextStyle(
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
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Text("Reference Name",style: TextStyle(
                  color: Utils().text,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requried this field';
                      }
                      return null; // validation passed
                    },
                    controller: formController.referenceName,
                    decoration: InputDecoration(
                      labelText: "Reference Name",
                      labelStyle: TextStyle(
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
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Text("Reference mobile Number",style: TextStyle(
                  color: Utils().text,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requried this field';
                      }
                      return null; // validation passed
                    },
                    controller: formController.referenceNumber,
                    decoration: InputDecoration(
                      labelText: "Reference mobile Number",
                      labelStyle: TextStyle(
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
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Text("Secondary mobile number",style: TextStyle(
                  color: Utils().text,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requried this field';
                      }
                      return null; // validation passed
                    },
                    controller: formController.secondaryMobileNumber,
                    decoration: InputDecoration(
                      labelText: "Secondary mobile number",
                      labelStyle: TextStyle(
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
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),

                Text("Bank name",style: TextStyle(
                  color: Utils().text,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requried this field';
                      }
                      return null; // validation passed
                    },
                    controller: formController.bankName,
                    decoration: InputDecoration(
                      labelText: "Bank name",
                      labelStyle: TextStyle(
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
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Text("Bank Acc number",style: TextStyle(
                  color: Utils().text,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requried this field';
                      }
                      return null; // validation passed
                    },
                    controller: formController.bankAccNumber,
                    decoration: InputDecoration(
                      labelText: "Bank Acc Number",
                      labelStyle: TextStyle(
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
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Text("IFSC Code",style: TextStyle(
                  color: Utils().text,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requried this field';
                      }
                      return null; // validation passed
                    },
                    controller: formController.IFSCcode,
                    decoration: InputDecoration(
                      labelText: "IFSC Code",
                      labelStyle: TextStyle(
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
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Upload Front Image",style: TextStyle(
                          color: Utils().text,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),),
                        Obx(() => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              formController.addProofFront();
                              print("open image");
                            },
                            child: Container(
                              height: 90,
                              width: 200,
                              decoration: BoxDecoration(
                                color: Utils().picture,
                                borderRadius: BorderRadius.circular(11),
                                image: formController.idImageFront.value != null
                                    ? DecorationImage(
                                  image: MemoryImage(formController.idImageFront.value!),
                                  fit: BoxFit.contain,
                                )
                                    : formController.frontId.isNotEmpty
                                    ? DecorationImage(
                                  image: FileImage(File(formController.frontId.value)),
                                  fit: BoxFit.contain,
                                )
                                    : null,
                              ),
                              child: formController.frontId.isEmpty && formController.idImageFront.value == null
                                  ? Center(
                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.cloud_upload,color: Colors.grey,),
                                    Text(
                                      textAlign: TextAlign.center,
                                      "Upload Front Image",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Utils().text,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  : null,
                            ),
                          ),
                        ))
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Upload Back Image",style: TextStyle(
                          color: Utils().text,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),),
                        Obx(() => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              formController.addProofBack();
                              print("open image");
                            },
                            child: Container(
                              height: 90,
                              width: 200,
                              decoration: BoxDecoration(
                                color: Utils().picture,
                                borderRadius: BorderRadius.circular(11),
                                image: formController.backId.value != null
                                    ? DecorationImage(
                                  image: MemoryImage(formController.backId.value!),
                                  fit: BoxFit.contain,
                                )
                                    : formController.backImage.isNotEmpty
                                    ? DecorationImage(
                                  image: FileImage(File(formController.backImage.value)),
                                  fit: BoxFit.contain,
                                )
                                    : null,
                              ),
                              child: formController.backImage.isEmpty && formController.backId.value == null
                                  ? Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.cloud_upload,color: Colors.grey,),
                                    Text(
                                      textAlign: TextAlign.center,
                                      "Upload Back Image",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Utils().text,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  : null,
                            ),
                          ),
                        )),
                      ],
                    ),
                  ],
                ),
                Text("Select Photo ID Proof",style: TextStyle(
                  color: Utils().text,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),),
                Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Utils().background,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1.5,
                          color: formController.selectPhotoIdDocError.value
                              ? Colors.red
                              : Utils().border_1,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: formController.selectPhotoIdDoc.value.isEmpty
                              ? null
                              : formController.selectPhotoIdDoc.value,
                          hint: Text(
                            "Select Photo ID Proof",
                            style: TextStyle(
                              color: Utils().border_1,
                              fontSize: 14,
                            ),
                          ),
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down_rounded,
                              color: Utils().border_1, size: 20),
                          dropdownColor: Utils().background,
                          items: photoIdDoc.map((e) {
                            return DropdownMenuItem<String>(
                              value: e['name'].toString(),
                              child: Text(
                                e['name'].toString(),
                                style: TextStyle(color: Utils().border_1),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            formController.selectPhotoIdDoc.value = newValue ?? '';
                            formController.selectPhotoIdDocError.value = false;
                          },
                        ),
                      ),
                    ),
                    if (formController.selectPhotoIdDocError.value)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 4),
                        child: Text(
                          "Required this field",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                )),
                Text("Profile prof Number",style: TextStyle(
                  color: Utils().text,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requried this field';
                      }
                      return null; // validation passed
                    },
                    controller: formController.idProofNumber,
                    decoration: InputDecoration(
                      labelText: "photo id proof number",
                      labelStyle: TextStyle(
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
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Text("Perment address",style: TextStyle(
                  color: Utils().text,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),),
                Text("Address Line 1",style: TextStyle(
                  color: Utils().text,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requried this field';
                      }
                      return null; // validation passed
                    },
                    controller: formController.addressLine1,
                    decoration: InputDecoration(
                      labelText: "Perment Address",
                      labelStyle: TextStyle(
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
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Text("Address Line 2",style: TextStyle(
                  color: Utils().text,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requried this field';
                      }
                      return null; // validation passed
                    },
                    controller: formController.addressLine2,
                    decoration: InputDecoration(
                      labelText: "Perment Address",
                      labelStyle: TextStyle(
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
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Pin code",style: TextStyle(
                      color: Utils().text,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),),
                    Text("Area",style: TextStyle(
                      color: Utils().text,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),),
                    Text("State",style: TextStyle(
                      color: Utils().text,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),),
                    Text("District",style: TextStyle(
                      color: Utils().text,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),),

                  ],
                ),
                Row(
                  spacing: 5,
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 80,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Requried this field';
                            }
                            return null; // validation passed
                          },
                          keyboardType: TextInputType.number,
                          onChanged: (value) async {
                            if(value.length == 6){
                              await formController.pinCodeApi(value);
                              formController.area.text = formController.pincodeModel!.data.first.postOffice[0].name.toString();
                              formController.district.text = formController.pincodeModel!.data.first.postOffice[0].district.toString();
                              formController.state.text = formController.pincodeModel!.data.first.postOffice[0].state.toString();
                            }
                          },
                          controller: formController.pinCode,
                          // maxLines: 2,
                          decoration: InputDecoration(
                            labelText: "Pin Code",
                            labelStyle: TextStyle(
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
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 80,
                        child: TextFormField(

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Requried this field';
                            }
                            return null; // validation passed
                          },
                          controller: formController.area,
                          decoration: InputDecoration(
                            labelText: "Area",
                            labelStyle: TextStyle(
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
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 80,
                        child: TextFormField(

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Requried this field';
                            }
                            return null; // validation passed
                          },
                          controller: formController.state,
                          decoration: InputDecoration(
                            labelText: "State",
                            labelStyle: TextStyle(
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
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 80,
                        child: TextFormField(

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Requried this field';
                            }
                            return null; // validation passed
                          },
                          controller: formController.district,
                          decoration: InputDecoration(
                            labelText: "District",
                            labelStyle: TextStyle(
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
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Same As Permeant Address",style: TextStyle(
                    color: Utils().border_1,
                    fontSize: 16,
                  ),),
                  value: isAddress,
                  onChanged: (val) {
                    isAddress= !isAddress;
                    setState(() {
                    });
                  },
                ),
                Visibility(
                    visible: !isAddress,
                    child: Column(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Residential address",style: TextStyle(
                          color: Utils().text,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),),
                        Text("Address Line 1",style: TextStyle(
                          color: Utils().text,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Requried this field';
                              }
                              return null; // validation passed
                            },
                            controller: formController.reAddressLine1,
                            decoration: InputDecoration(
                              labelText: "AddressLine1",
                              labelStyle: TextStyle(
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
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text("Address Line 2",style: TextStyle(
                          color: Utils().text,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Requried this field';
                              }
                              return null; // validation passed
                            },
                            controller: formController.reAddressLine2,
                            decoration: InputDecoration(
                              labelText: "AddressLine2",
                              labelStyle: TextStyle(
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
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Pin code",style: TextStyle(
                              color: Utils().text,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),),
                            Text("Area",style: TextStyle(
                              color: Utils().text,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),),
                            Text("State",style: TextStyle(
                              color: Utils().text,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),),
                            Text("District",style: TextStyle(
                              color: Utils().text,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),),

                          ],
                        ),
                        Row(
                          spacing: 5,
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Requried this field';
                                    }
                                    return null; // validation passed
                                  },
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) async {
                                    if(value.length == 6){
                                      await formController.pinCodeApi(value);
                                      formController.area.text = formController.pincodeModel!.data.first.postOffice[0].name.toString();
                                      formController.district.text = formController.pincodeModel!.data.first.postOffice[0].district.toString();
                                      formController.state.text = formController.pincodeModel!.data.first.postOffice[0].state.toString();
                                    }
                                  },
                                  controller: formController.rePinCode,
                                  // maxLines: 2,
                                  decoration: InputDecoration(
                                    labelText: "Pin Code",
                                    labelStyle: TextStyle(
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
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                child: TextFormField(

                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Requried this field';
                                    }
                                    return null; // validation passed
                                  },
                                  controller: formController.reArea,
                                  decoration: InputDecoration(
                                    labelText: "Area",
                                    labelStyle: TextStyle(
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
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                child: TextFormField(

                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Requried this field';
                                    }
                                    return null; // validation passed
                                  },
                                  controller: formController.reState,
                                  decoration: InputDecoration(
                                    labelText: "State",
                                    labelStyle: TextStyle(
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
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                child: TextFormField(

                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Requried this field';
                                    }
                                    return null; // validation passed
                                  },
                                  controller: formController.reDistrict,
                                  decoration: InputDecoration(
                                    labelText: "District",
                                    labelStyle: TextStyle(
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
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                )),
                Center(
                  child:  GestureDetector(
                    onTap: ()  async {
                      if(widget.formKey.currentState!.validate())
                      {
                        await formController.insertDetails(context, formController.isAddress);

                      }
                    },
                    child: Container(
                      height: 35,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        gradient: LinearGradient(
                          colors: [Utils().border_1, Utils().button],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Save",
                          style: TextStyle(fontSize: 16, color: Utils().background),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
