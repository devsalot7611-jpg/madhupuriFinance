import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:madhupurifinance/Controller/FormController.dart';
import 'package:madhupurifinance/Controller/KycListController.dart';
import 'package:madhupurifinance/Utils.dart';
import 'package:get/get.dart';

import 'kycList.dart';


class Addkyc extends StatefulWidget {
  const Addkyc({super.key});

  @override
  State<Addkyc> createState() => _AddkycState();
}

class _AddkycState extends State<Addkyc> {

  bool isSameAddress = false;
  final FormController formController = Get.put(FormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils().background,
    );
  }
}

class Kyc extends StatefulWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Kyc({super.key, required this.formKey,});
  @override
  State<Kyc> createState() => _KycState();

}

class _KycState extends State<Kyc> {
  final FormController formController = Get.put(FormController());
  final KycListController kycListController = Get.put(KycListController());

  bool saveLoading = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("KYC NO : ${kycListController.kycNo}",style: TextStyle(
                  fontSize: 22,
                  color: Utils().text,
                ),),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    // ✅ Manual validation for images
                    bool isProfileImageSelected = formController.userImage.isNotEmpty || formController.personImage.value != null;
                    bool isFrontImageSelected = formController.backImage.isNotEmpty || formController.backId.value != null;
                    bool isBackImageSelected = formController.frontId.isNotEmpty || formController.idImageFront.value != null;
                    bool isDropdownSelected = formController.selectPhotoIdDoc.value.isNotEmpty;

                    formController.imageError.value = !isProfileImageSelected;
                    formController.frontImageError.value = !isFrontImageSelected;
                    formController.backImageError.value = !isBackImageSelected;
                    formController.selectPhotoIdDocError.value = !isDropdownSelected;

                    if (widget.formKey.currentState!.validate() &&
                        isProfileImageSelected &&
                        isFrontImageSelected &&
                        isBackImageSelected &&
                        isDropdownSelected) {

                      setState(() {
                        saveLoading = true;
                      });

                      await formController.insertDetails(context, formController.isAddress);

                      setState(() {
                        saveLoading = false;
                      });
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Utils().border_1, Utils().button],
                      ),
                    ),
                    child: Center(
                      child: saveLoading
                          ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Utils().background,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        "Save",
                        style: TextStyle(fontSize: 16, color: Utils().background),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 8,),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                    formController.firstName.clear();
                    formController.middleName.clear();
                    formController.lastName.clear();
                    formController.mobileNumber.clear();
                    formController.referenceName.clear();
                    formController.referenceNumber.clear();
                    formController.referenceNomineeName.clear();
                    formController.idProofNumber.clear();
                    //formController.addressProofNumber.clear();
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
                    // formController.photoID.close();
                  },
                  child: Container(
                      height: 40,
                      width: 40,
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

              ],
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Divider(
            height: 1,
            color: Colors.black,
          ),
        )
      ],
    );
  }
}

class EditviewDetails extends StatefulWidget {
  final Map<String, dynamic> data;
  EditviewDetails({super.key, required this.data,});
  @override
  State<EditviewDetails> createState() => _EditviewDetailsState();
}

class _EditviewDetailsState extends State<EditviewDetails> {
  final FormController formController = Get.put(FormController());

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("KYC NO ${widget.data['id']}",style: TextStyle(
              fontSize: 22,
              color: Utils().text,
            ),),
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
                formController.firstName.clear();
                formController.middleName.clear();
                formController.lastName.clear();
                formController.mobileNumber.clear();
                formController.referenceName.clear();
                formController.referenceNumber.clear();
                formController.referenceNomineeName.clear();
                formController.idProofNumber.clear();
                //formController.addressProofNumber.clear();
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
                // formController.photoID.close();
              },
              child: Container(
                  height: 40,
                  width: 40,
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
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Divider(
            height: 1,
            color: Colors.black,
          ),
        )
      ],
    );
  }
}

class viewDetails extends StatefulWidget {
  @override
  State<viewDetails> createState() => _viewDetailsState();
}

class _viewDetailsState extends State<viewDetails> {
  final FormController formController = Get.put(FormController());

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("View KYC",style: TextStyle(
              fontSize: 22,
              color: Utils().text,
            ),),
            IconButton(onPressed: (){
              Get.back();
            }, icon: Icon(Icons.cancel_outlined,color: Utils().text,size: 22,)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Divider(
            height: 1,
            color: Colors.black,
          ),
        )
      ],
    );
  }
}

class userInformation extends StatefulWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  userInformation({super.key, required this.formKey,});
  @override
  State<userInformation> createState() => userInformationState();
}

class userInformationState extends State<userInformation> {

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

  //bool isAddress = false;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Utils().background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
                color: Utils().border_1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Text("User Information",style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Utils().text,
                      fontSize: 22,
                    ),),
                  ),
                  Divider(),
                  SizedBox(height: 10,),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start  ,
                      children: [
                        Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                formController.getImage();
                                formController.imageError.value = false; // clear error on tap
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
                                  border: Border.all(
                                    color: formController.imageError.value ? Colors.red : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                                child: formController.userImage.isEmpty && formController.personImage.value == null
                                    ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.cloud_upload, color: Colors.grey),
                                      Text(
                                        "Upload Profile\nImage",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 10, color: Utils().text),
                                      ),
                                    ],
                                  ),
                                )
                                    : null,
                              ),
                            ),
                            if (formController.imageError.value)
                              Padding(
                                padding: const EdgeInsets.only(top: 5, left: 5),
                                child: Text(
                                  "Required this field",
                                  style: TextStyle(color: Colors.red, fontSize: 12),
                                ),
                              )
                          ],
                        )),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start  ,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      // height: 36,
                                      child: TextFormField(
                                        textCapitalization: TextCapitalization.characters,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Requried this field';
                                          }
                                          return null; // validation passed
                                        },
                                        onChanged: (value) {
                                          // Force uppercase display
                                          final upperText = value.toUpperCase();
                                          if (formController.firstName.text != upperText) {
                                            formController.firstName.value = formController.firstName.value.copyWith(
                                              text: upperText,
                                              selection: TextSelection.collapsed(offset: upperText.length),
                                            );
                                          }
                                        },
                                        controller: formController.firstName,
                                        decoration: InputDecoration(
                                          labelText: "First Name",
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
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    SizedBox(
                                      width:  MediaQuery.of(context).size.width * 0.100,
                                      // height: 36,
                                      child: TextFormField(
                                        textCapitalization: TextCapitalization.characters,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Requried this field';
                                          }
                                          return null; // validation passed
                                        },
                                        onChanged: (value) {
                                          // Force uppercase display
                                          final upperText = value.toUpperCase();
                                          if (formController.middleName.text != upperText) {
                                            formController.middleName.value = formController.middleName.value.copyWith(
                                              text: upperText,
                                              selection: TextSelection.collapsed(offset: upperText.length),
                                            );
                                          }
                                        },
                                        controller: formController.middleName,
                                        // maxLines: 2,
                                        decoration: InputDecoration(
                                          labelText: "Middle Name",
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
                                    Spacer(),
                                    SizedBox(
                                      width:  MediaQuery.of(context).size.width * 0.100,
                                      // height: 36,
                                      child: TextFormField(
                                        textCapitalization: TextCapitalization.characters,
                                        onChanged: (value) {
                                          // Force uppercase display
                                          final upperText = value.toUpperCase();
                                          if (formController.lastName.text != upperText) {
                                            formController.lastName.value = formController.lastName.value.copyWith(
                                              text: upperText,
                                              selection: TextSelection.collapsed(offset: upperText.length),
                                            );
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Requried this field';
                                          }
                                          return null; // validation passed
                                        },
                                        controller: formController.lastName,
                                        //maxLines: 2,
                                        decoration: InputDecoration(
                                          labelText: "Last Name",
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
                                    Spacer(),
                                    SizedBox(
                                      width:  MediaQuery.of(context).size.width * 0.120,
                                      // height: 36,
                                      child: TextFormField(
                                        maxLength: 10,
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
                                        controller: formController.mobileNumber,
                                        // maxLines: 2,
                                        decoration: InputDecoration(
                                          labelText: "Mobile Number",
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
                                    Spacer(),
                                    SizedBox(
                                      width:  MediaQuery.of(context).size.width * 0.150,
                                      // height: 36,
                                      child: TextFormField(
                                        maxLength: 10,
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
                                        controller:formController.secondaryMobileNumber,
                                        //maxLines: 2,
                                        decoration: InputDecoration(
                                          labelText: " Secondary Mobile Number",
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
                                    Spacer(),
                                    SizedBox(
                                      width:  MediaQuery.of(context).size.width * 0.130,
                                      // height: 36,
                                      child: TextFormField(
                                        textCapitalization: TextCapitalization.characters,
                                        onChanged: (value) {
                                          // Force uppercase display
                                          final upperText = value.toUpperCase();
                                          if (formController.referenceName.text != upperText) {
                                            formController.referenceName.value = formController.referenceName.value.copyWith(
                                              text: upperText,
                                              selection: TextSelection.collapsed(offset: upperText.length),
                                            );
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Requried this field';
                                          }
                                          return null; // validation passed
                                        },
                                        controller: formController.referenceName,
                                        //maxLines: 2,
                                        decoration: InputDecoration(
                                          labelText: "Reference Name",
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
                                    Spacer(),
                                    SizedBox(
                                      width:  MediaQuery.of(context).size.width * 0.120,
                                      // height: 36,
                                      child: TextFormField(
                                        maxLength: 10,
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
                                        controller:formController.referenceNumber,
                                        //maxLines: 2,
                                        decoration: InputDecoration(
                                          labelText: " Refrencer Mobile Number",
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width:  MediaQuery.of(context).size.width * 0.100,
                                      // height: 36,
                                      child: TextFormField(
                                        textCapitalization: TextCapitalization.characters,
                                        onChanged: (value) {
                                          // Force uppercase display
                                          final upperText = value.toUpperCase();
                                          if (formController.bankName.text != upperText) {
                                            formController.bankName.value = formController.bankName.value.copyWith(
                                              text: upperText,
                                              selection: TextSelection.collapsed(offset: upperText.length),
                                            );
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Requried this field';
                                          }
                                          return null; // validation passed
                                        },
                                        controller: formController.bankName,
                                        // maxLines: 2,
                                        decoration: InputDecoration(
                                          labelText: "Bank name",
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
                                      width:  MediaQuery.of(context).size.width * 0.120,
                                      // height: 36,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Requried this field';
                                          }
                                          return null; // validation passed
                                        },
                                        controller: formController.bankAccNumber,
                                        // maxLines: 2,
                                        decoration: InputDecoration(
                                          labelText: "Bank acc number",
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
                                      width:  MediaQuery.of(context).size.width * 0.100,
                                      // height: 36,
                                      child: TextFormField(
                                        textCapitalization: TextCapitalization.characters,
                                        onChanged: (value) {
                                          // Force uppercase display
                                          final upperText = value.toUpperCase();
                                          if (formController.IFSCcode.text != upperText) {
                                            formController.IFSCcode.value = formController.IFSCcode.value.copyWith(
                                              text: upperText,
                                              selection: TextSelection.collapsed(offset: upperText.length),
                                            );
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Requried this field';
                                          }
                                          return null; // validation passed
                                        },
                                        controller: formController.IFSCcode,
                                        // maxLines: 2,
                                        decoration: InputDecoration(
                                          labelText: "IFSC code",
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
                                    Obx(() => Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.130,
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
                                                  fontSize: 12,
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
                                    SizedBox(
                                      // height: 45,
                                      width:  MediaQuery.of(context).size.width * 0.140,
                                      // height: 36,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Requried this field';
                                          }
                                          return null; // validation passed
                                        },
                                        controller: formController.idProofNumber,
                                        // maxLines: 2,
                                        decoration: InputDecoration(
                                          labelText: "Photo ID Proof Number",
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
                                    Obx(() => Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            formController.addProofFront();
                                            formController.frontImageError.value = false; // Clear error on tap
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 0.1,
                                            height: MediaQuery.of(context).size.width * 0.05,
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
                                              border: Border.all(
                                                color: formController.frontImageError.value ? Colors.red : Colors.transparent,
                                                width: 1.5,
                                              ),
                                            ),
                                            child: formController.frontId.isEmpty && formController.idImageFront.value == null
                                                ? Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.cloud_upload, color: Colors.grey),
                                                  Text(
                                                    "Upload Front\nImage",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 10, color: Utils().text),
                                                  ),
                                                ],
                                              ),
                                            )
                                                : null,
                                          ),
                                        ),
                                        if (formController.frontImageError.value)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Required this field",
                                              style: TextStyle(color: Colors.red, fontSize: 12),
                                            ),
                                          ),
                                      ],
                                    )),
                                    Obx(() => Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            formController.addProofBack();
                                            formController.backImageError.value = false; // Clear error on tap
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 0.1,
                                            height: MediaQuery.of(context).size.width * 0.05,
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
                                              border: Border.all(
                                                color: formController.backImageError.value ? Colors.red : Colors.transparent,
                                                width: 1.5,
                                              ),
                                            ),
                                            child: formController.backImage.isEmpty && formController.backId.value == null
                                                ? Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.cloud_upload, color: Colors.grey),
                                                  Text(
                                                    "Upload Back\nImage",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 10, color: Utils().text),
                                                  ),
                                                ],
                                              ),
                                            )
                                                : null,
                                          ),
                                        ),
                                        if (formController.backImageError.value)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Required this field",
                                              style: TextStyle(color: Colors.red, fontSize: 12),
                                            ),
                                          ),
                                      ],
                                    )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            // height: 260,
            // width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Utils().background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
                color: Utils().border_1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8,bottom: 4,top: 4),// (એડ્રેસની માહિતી)
                      child: Text("Address Information",style: TextStyle(
                        color: Utils().text,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 8,bottom: 4),// (કાયમી સરનામું)
                    child: Text("Permanent Address",style: TextStyle(
                      color: Utils().text,
                      fontSize: 18,
                    ),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        // height: 50,
                        width: MediaQuery.of(context).size.width * 0.20,
                        child: TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          onChanged: (value) {
                            // Force uppercase display
                            final upperText = value.toUpperCase();
                            if (formController.addressLine1.text != upperText) {
                              formController.addressLine1.value = formController.addressLine1.value.copyWith(
                                text: upperText,
                                selection: TextSelection.collapsed(offset: upperText.length),
                              );
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required this field';
                            }
                            if (value.contains(",")) {
                              return 'Comma (,) is not allowed';
                            }
                            return null; // validation passed
                          },
                          controller: formController.addressLine1,
                          // maxLines: 2,
                          decoration: InputDecoration(
                            labelText: "User Address Line 1",
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
                        // height: 50,
                        width: MediaQuery.of(context).size.width * 0.20,
                        child: TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          onChanged: (value) {
                            // Force uppercase display
                            final upperText = value.toUpperCase();
                            if (formController.addressLine2.text != upperText) {
                              formController.addressLine2.value = formController.addressLine2.value.copyWith(
                                text: upperText,
                                selection: TextSelection.collapsed(offset: upperText.length),
                              );
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required this field';
                            }
                            if (value.contains(",")) {
                              return 'Comma (,) is not allowed';
                            }
                            return null; // validation passed
                          },
                          controller: formController.addressLine2,
                          // maxLines: 2,
                          decoration: InputDecoration(
                            labelText: "User Address Line 2",
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
                        width: MediaQuery.of(context).size.width * 0.11,
                        child: TextFormField(
                          controller: formController.pinCode,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required field';
                            } else if (value.length != 6) {
                              return 'PIN must be 6 digits';
                            }
                            return null;
                          },
                          onChanged: (value) async {
                            // 1️⃣ Less than 6 digits → clear all fields and model
                            if (value.length < 6) {
                              formController.area.clear();
                              formController.district.clear();
                              formController.state.clear();
                              formController.pincodeModel = null;
                              return;
                            }

                            // 2️⃣ Exactly 6 digits → call API and set data if valid
                            if (value.length == 6) {
                              // Clear old data before fetching new
                              formController.area.clear();
                              formController.district.clear();
                              formController.state.clear();
                              formController.pincodeModel = null;

                              await formController.pinCodeApi(value); // API call

                              final poList = formController.pincodeModel?.data.first.postOffice;
                              final po = (poList != null && poList.isNotEmpty) ? poList.first : null;

                              if (po == null) {
                                // No result → do nothing (keep fields blank)
                                return;
                              }

                              // ✅ Valid response → populate the fields
                              formController.area.text     = po.name ??'';
                              formController.district.text = po.district ?? '';
                              formController.state.text    = po.state ?? '';
                            }
                          },

                          decoration: InputDecoration(
                            labelText: 'Pin Code',
                            labelStyle: TextStyle(fontSize: 12,color: Utils().border_1,),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Utils().button, width: 1.5),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Utils().button, width: 2),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        // height: 50,
                        width: MediaQuery.of(context).size.width * 0.11,
                        child: TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          onChanged: (value) {
                            // Force uppercase display
                            final upperText = value.toUpperCase();
                            if (formController.area.text != upperText) {
                              formController.area.value = formController.area.value.copyWith(
                                text: upperText,
                                selection: TextSelection.collapsed(offset: upperText.length),
                              );
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required this field';
                            }
                            if (value.contains(",")) {
                              return 'Comma (,) is not allowed';
                            }
                            return null; // validation passed
                          },
                          controller: formController.area,
                          // maxLines: 2,
                          decoration: InputDecoration(
                            labelText: "area",
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
                        // height: 50,
                        width: MediaQuery.of(context).size.width * 0.11,
                        child: TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          onChanged: (value) {
                            // Force uppercase display
                            final upperText = value.toUpperCase();
                            if (formController.district.text != upperText) {
                              formController.district.value = formController.district.value.copyWith(
                                text: upperText,
                                selection: TextSelection.collapsed(offset: upperText.length),
                              );
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required this field';
                            }
                            if (value.contains(",")) {
                              return 'Comma (,) is not allowed';
                            }
                            return null; // validation passed
                          },
                          controller: formController.district,
                          // maxLines: 2,
                          decoration: InputDecoration(
                            labelText: "District",
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
                        // height: 50,
                        width: MediaQuery.of(context).size.width * 0.11,
                        child: TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          onChanged: (value) {
                            // Force uppercase display
                            final upperText = value.toUpperCase();
                            if (formController.state.text != upperText) {
                              formController.state.value = formController.state.value.copyWith(
                                text: upperText,
                                selection: TextSelection.collapsed(offset: upperText.length),
                              );
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required this field';
                            }
                            if (value.contains(",")) {
                              return 'Comma (,) is not allowed';
                            }
                            return null; // validation passed
                          },
                          controller: formController.state,
                          // maxLines: 2,
                          decoration: InputDecoration(
                            labelText: "State",
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
                  // SizedBox(height: 10,),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8), // (રહેઠાણનું સરનામું)
                        child: Text("Residencial Address",style: TextStyle(
                          color: Utils().text,
                          fontSize: 18,
                        ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 22),
                        child: SizedBox(
                          width: 280,
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              "Same As Permanent Address",
                              style: TextStyle(
                                color: Utils().border_1,
                                fontSize: 16,
                              ),
                            ),
                            value: formController.isAddress,
                            onChanged: (val) {
                              setState(() {
                                formController.isAddress = val ?? false;

                                if (formController.isAddress==true) {
                                  // Copy permanent address to residential fields immediately
                                  formController.reAddressLine1.text = formController.addressLine1.text;
                                  formController.reAddressLine2.text = formController.addressLine2.text;
                                  formController.rePinCode.text = formController.pinCode.text;
                                  formController.reState.text = formController.state.text;
                                  formController.reArea.text = formController.area.text;
                                  formController.reDistrict.text = formController.district.text;
                                } else {
                                  // Optional: clear fields if unchecked
                                  formController.reAddressLine1.clear();
                                  formController.reAddressLine2.clear();
                                  formController.rePinCode.clear();
                                  formController.reState.clear();
                                  formController.reArea.clear();
                                  formController.reDistrict.clear();
                                }
                              });
                            },
                          ),

                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Visibility(
                      visible: !formController.isAddress,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            // height: 50,
                            width: MediaQuery.of(context).size.width * 0.20,
                            child: TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              onChanged: (value) {
                                // Force uppercase display
                                final upperText = value.toUpperCase();
                                if (formController.reAddressLine1.text != upperText) {
                                  formController.reAddressLine1.value = formController.reAddressLine1.value.copyWith(
                                    text: upperText,
                                    selection: TextSelection.collapsed(offset: upperText.length),
                                  );
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required this field';
                                }
                                if (value.contains(",")) {
                                  return 'Comma (,) is not allowed';
                                }
                                return null; // validation passed
                              },
                              controller: formController.reAddressLine1,
                              // maxLines: 2,
                              decoration: InputDecoration(
                                labelText: "User Address Line 1",
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
                            // height: 50,
                            width: MediaQuery.of(context).size.width * 0.20,
                            child: TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              onChanged: (value) {
                                // Force uppercase display
                                final upperText = value.toUpperCase();
                                if (formController.reAddressLine2.text != upperText) {
                                  formController.reAddressLine2.value = formController.reAddressLine2.value.copyWith(
                                    text: upperText,
                                    selection: TextSelection.collapsed(offset: upperText.length),
                                  );
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required this field';
                                }
                                if (value.contains(",")) {
                                  return 'Comma (,) is not allowed';
                                }
                                return null; // validation passed
                              },
                              controller: formController.reAddressLine2,
                              // maxLines: 2,
                              decoration: InputDecoration(
                                labelText: "User Address Line 2",
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
                            width: MediaQuery.of(context).size.width * 0.11,
                            child: TextFormField(
                              controller: formController.rePinCode,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6),
                              ],
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Required field';
                                if (v.length != 6)         return 'PIN must be 6 digits';
                                return null;
                              },
                              onChanged: (value) async {
                                /* 👉  A.  < 6 chars  → blank the three linked fields.   */
                                if (value.length < 6) {
                                  formController.reArea.clear();
                                  formController.reDistrict.clear();
                                  formController.reState.clear();
                                  formController.rePinCodeModel = null;   // drop old data
                                  return;
                                }

                                /* 👉  B.  exactly 6 chars → fetch + populate on success */
                                if (value.length == 6) {
                                  // show blanks while we load
                                  formController.reArea.clear();
                                  formController.reDistrict.clear();
                                  formController.reState.clear();
                                  formController.rePinCodeModel = null;

                                  final ok = await formController.pinCodeApi(
                                    value,
                                    forPermanent: true,      // tells the helper which set to fill
                                  );

                                  if (!ok) return;           // invalid code → keep blanks

                                  // success: controllers already filled inside pinCodeApi
                                }
                              },

                              decoration: InputDecoration(
                                labelText: 'Pin Code',
                                labelStyle: TextStyle(fontSize: 12,
                                  color: Utils().border_1,
                                ),
                                contentPadding:
                                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                            // height: 50,
                            width: MediaQuery.of(context).size.width * 0.11,
                            child: TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              onChanged: (value) {
                                // Force uppercase display
                                final upperText = value.toUpperCase();
                                if (formController.reArea.text != upperText) {
                                  formController.reArea.value = formController.reArea.value.copyWith(
                                    text: upperText,
                                    selection: TextSelection.collapsed(offset: upperText.length),
                                  );
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required this field';
                                }
                                if (value.contains(",")) {
                                  return 'Comma (,) is not allowed';
                                }
                                return null; // validation passed
                              },
                              controller: formController.reArea,
                              // maxLines: 2,
                              decoration: InputDecoration(
                                labelText: "area",
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
                            // height: 50,
                            width: MediaQuery.of(context).size.width * 0.11,
                            child: TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              onChanged: (value) {
                                // Force uppercase display
                                final upperText = value.toUpperCase();
                                if (formController.reDistrict.text != upperText) {
                                  formController.reDistrict.value = formController.reDistrict.value.copyWith(
                                    text: upperText,
                                    selection: TextSelection.collapsed(offset: upperText.length),
                                  );
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required this field';
                                }
                                if (value.contains(",")) {
                                  return 'Comma (,) is not allowed';
                                }
                                return null; // validation passed
                              },
                              controller: formController.reDistrict,
                              // maxLines: 2,
                              decoration: InputDecoration(
                                labelText: "District",
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
                            // height: 50,
                            width: MediaQuery.of(context).size.width * 0.11,
                            child: TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              onChanged: (value) {
                                // Force uppercase display
                                final upperText = value.toUpperCase();
                                if (formController.reState.text != upperText) {
                                  formController.reState.value = formController.reState.value.copyWith(
                                    text: upperText,
                                    selection: TextSelection.collapsed(offset: upperText.length),
                                  );
                                }
                              },
                              //dev change
                              onFieldSubmitted: (value) async {
                                await formController.insertDetails(context, formController.isAddress);
                                if(widget.formKey.currentState!.validate())
                                {
                                  Navigator.pushReplacement(
                                      context, MaterialPageRoute(builder: (_) => Kyclist(data: {},)));
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required this field';
                                }
                                if (value.contains(",")) {
                                  return 'Comma (,) is not allowed';
                                }
                                return null; // validation passed
                              },
                              controller: formController.reState,
                              // maxLines: 2,
                              decoration: InputDecoration(
                                labelText: "State",
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
                      )),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


class Edit extends StatefulWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, dynamic> data;
  Edit({super.key, required this.data , required this.formKey});
  @override
  State<Edit> createState() => _EditState();

}

class _EditState extends State<Edit> {
  final FormController formController = Get.put(FormController());
  final KycListController kycListController = Get.put(KycListController());

  bool updateLoading = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("Edit KYC ${widget.data['id']}",style: TextStyle(
                  fontSize: 22,
                  color: Utils().text,
                ),),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    if(widget.formKey.currentState!.validate())
                    {
                      setState(() {
                        updateLoading = true;
                      });
                      await formController.updateKycDetails(context);
                      Get.to(Kyclist(data: {}));
                      setState(() {
                        updateLoading = false;
                      });
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 200,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Utils().border_1,
                          Utils().button,
                        ])
                    ),
                    child: Center(
                      child: updateLoading
                          ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Utils().background,
                          strokeWidth: 2,
                        ),
                      )
                          : Text("Update",style: TextStyle(
                          fontSize: 16,
                          color: Utils().background
                      ),),
                    ),
                  ),
                ),
                SizedBox(width: 8,),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                      height: 40,
                      width: 40,
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
              ],
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Divider(
            height: 1,
            color: Colors.black,
          ),
        )
      ],
    );
  }
}






class EdituserInformation extends StatefulWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, dynamic> data;
  @override
  State<EdituserInformation> createState() => _EdituserInformationState();
  EdituserInformation({super.key, required this.data, required this.formKey});
}

class _EdituserInformationState extends State<EdituserInformation> {


  final FormController formController = Get.put(FormController());

  // bool isKycChecked = false;
  List<dynamic> photoIdDoc = [];
  List<dynamic> addressDoc = [];
  // bool isAddress = false;


  @override
  void initState() {
    super.initState();
    initData();
    formController.editKycStoreId = widget.data['id'].toString();
    widget.data['id'].toString();
    widget.data['profile_img'].toString();
    widget.data['profile_id_img'].toString();
    widget.data['profile_id_img_back'].toString();
    formController.firstName.text = widget.data['first_name'].toString();
    formController.middleName.text = widget.data['middle_name'].toString();
    formController.lastName.text = widget.data['last_name'].toString();
    formController.mobileNumber.text = widget.data['mobile_no'].toString();
    formController.secondaryMobileNumber.text = widget.data['secondary_mobile_no'].toString();
    formController.bankName.text = widget.data['bank_name'].toString();
    formController.bankAccNumber.text = widget.data['bank_acc_no'].toString();
    formController.IFSCcode.text = widget.data['bank_ifsc_code'].toString();
    formController.idProofNumber.text = widget.data['profile_id_no'].toString();
    formController.referenceName.text = widget.data['reference_name'].toString();
    formController.referenceNumber.text = widget.data['reference_contact_no'].toString();
    formController.selectAddProofIdDoc = widget.data['profile_id_type'].toString();
    //formController.addressProofNumber.text = widget.data['address_proof_no'].toString();
    String address = widget.data['permanent_address'];
    print("object address ${address}");
    String residentical = widget.data['residentical_address'];
    print("second address ${residentical}");

    List<String> parts = address.split(',').where((e) => e.trim().isNotEmpty).toList();
    List<String> residenticalAdd = residentical.split(',').where((e) => e.trim().isNotEmpty).toList();

    String addressLine1 = parts.length > 0 ? parts[0] : '';
    formController.addressLine1.text = addressLine1;
    print("addressLine1 dev: $addressLine1");

    String addressLine2 = parts.length > 1 ? parts[1] : '';
    formController.addressLine2.text = addressLine2;

    String pinCode = parts.length > 2 ? parts[2] : '';
    formController.pinCode.text = pinCode;

    String area = parts.length > 3 ? parts[3] : '';
    formController.area.text = area;

    String district = parts.length > 4 ? parts[4] : '';
    formController.district.text = district;

    String state = parts.length > 5 ? parts[5] : '';
    formController.state.text = state;

    String AddressLine1 = residenticalAdd.length > 0 ? residenticalAdd[0] : '';
    formController.reAddressLine1.text = AddressLine1;

    String AddressLine2 = residenticalAdd.length > 1 ? residenticalAdd[1] : '';
    formController.reAddressLine2.text = AddressLine2;

    String Pincode = residenticalAdd.length > 2 ? residenticalAdd[2] : '';
    formController.rePinCode.text = Pincode;

    String Area = residenticalAdd.length > 3 ? residenticalAdd[3] : '';
    formController.reArea.text = Area;

    String District = residenticalAdd.length > 4 ? residenticalAdd[4] : '';
    formController.reDistrict.text = District;

    String State = residenticalAdd.length > 5 ? residenticalAdd[5] : '';
    formController.reState.text = State;
  }

  initData() async {
    photoIdDoc = await formController.getDocument("photo_id");
    addressDoc = await formController.getDocument("address");
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key : widget.formKey,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Utils().background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
                color: Utils().border_1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Text("User Information",style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Utils().text,
                      fontSize: 22,
                    ),),
                  ),
                  Divider(),
                  SizedBox(height: 10,),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start  ,
                      children: [
                        Obx(() => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              formController.getImage();
                              print("open image");
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.width * 0.11>100?100:MediaQuery.of(context).size.width * 0.11,
                              width: MediaQuery.of(context).size.width * 0.11>100?100:MediaQuery.of(context).size.width * 0.11,
                              decoration: BoxDecoration(
                                color: Utils().picture,
                                borderRadius: BorderRadius.circular(11),
                                // image: formController.personImage.value != null
                                //     ? DecorationImage(
                                //   image: MemoryImage(formController.personImage.value!),
                                //   fit: BoxFit.contain,
                                // )
                                //     : formController.userImage.isNotEmpty
                                //     ? DecorationImage(
                                //   image: FileImage(File(formController.userImage.value)),
                                //   fit: BoxFit.contain,
                                // )
                                //     : null,
                              ),
                              child: formController.personImage.value != null? Image(
                                image: MemoryImage(formController.personImage.value!),
                                fit: BoxFit.contain,
                              ):widget.data['profile_img'] != null && widget.data['profile_img'].isNotEmpty ? Image.network(
                                widget.data['profile_img'].toString(),
                                fit: BoxFit.contain,
                              ) : Icon(
                                Icons.account_circle, // Default icon when there's no image
                                size: 50,
                                color: Utils().border_1, // Change to any color you prefer
                              ),
                            ),
                          ),
                        )),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start  ,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      // height: 36,
                                      child: TextFormField(
                                        textCapitalization: TextCapitalization.characters,
                                        onChanged: (value) {
                                          // Force uppercase display
                                          final upperText = value.toUpperCase();
                                          if (formController.firstName.text != upperText) {
                                            formController.firstName.value = formController.firstName.value.copyWith(
                                              text: upperText,
                                              selection: TextSelection.collapsed(offset: upperText.length),
                                            );
                                          }
                                        },
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
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    SizedBox(
                                      width:  MediaQuery.of(context).size.width * 0.100,
                                      // height: 36,
                                      child: TextFormField(
                                        textCapitalization: TextCapitalization.characters,
                                        onChanged: (value) {
                                          // Force uppercase display
                                          final upperText = value.toUpperCase();
                                          if (formController.middleName.text != upperText) {
                                            formController.middleName.value = formController.middleName.value.copyWith(
                                              text: upperText,
                                              selection: TextSelection.collapsed(offset: upperText.length),
                                            );
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Requried this field';
                                          }
                                          return null; // validation passed
                                        },
                                        controller: formController.middleName,
                                        // maxLines: 2,
                                        decoration: InputDecoration(
                                          labelText: "Middle Name",
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
                                    Spacer(),
                                    SizedBox(
                                      width:  MediaQuery.of(context).size.width * 0.100,
                                      // height: 36,
                                      child: TextFormField(
                                        textCapitalization: TextCapitalization.characters,
                                        onChanged: (value) {
                                          // Force uppercase display
                                          final upperText = value.toUpperCase();
                                          if (formController.lastName.text != upperText) {
                                            formController.lastName.value = formController.lastName.value.copyWith(
                                              text: upperText,
                                              selection: TextSelection.collapsed(offset: upperText.length),
                                            );
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Requried this field';
                                          }
                                          return null; // validation passed
                                        },
                                        controller: formController.lastName,
                                        //maxLines: 2,
                                        decoration: InputDecoration(
                                          labelText: "Last Name",
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
                                    Spacer(),
                                    SizedBox(
                                      width:  MediaQuery.of(context).size.width * 0.120,
                                      // height: 36,
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
                                        controller: formController.mobileNumber,
                                        // maxLines: 2,
                                        decoration: InputDecoration(
                                          labelText: "Mobile Number",
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
                                    Spacer(),
                                    SizedBox(
                                      width:  MediaQuery.of(context).size.width * 0.150,
                                      // height: 36,
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
                                        controller:formController.secondaryMobileNumber,
                                        //maxLines: 2,
                                        decoration: InputDecoration(
                                          labelText: " Secondary Mobile Number",
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
                                    Spacer(),
                                    SizedBox(
                                      width:  MediaQuery.of(context).size.width * 0.130,
                                      // height: 36,
                                      child: TextFormField(
                                        textCapitalization: TextCapitalization.characters,
                                        onChanged: (value) {
                                          // Force uppercase display
                                          final upperText = value.toUpperCase();
                                          if (formController.referenceName.text != upperText) {
                                            formController.referenceName.value = formController.referenceName.value.copyWith(
                                              text: upperText,
                                              selection: TextSelection.collapsed(offset: upperText.length),
                                            );
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Requried this field';
                                          }
                                          return null; // validation passed
                                        },
                                        controller: formController.referenceName,
                                        //maxLines: 2,
                                        decoration: InputDecoration(
                                          labelText: "Reference Name",
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
                                    Spacer(),
                                    SizedBox(
                                      width:  MediaQuery.of(context).size.width * 0.120,
                                      // height: 36,
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
                                        controller:formController.referenceNumber,
                                        //maxLines: 2,
                                        decoration: InputDecoration(
                                          labelText: " Refrencer Mobile Number",
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width:  MediaQuery.of(context).size.width * 0.100,
                                      // height: 36,
                                      child: TextFormField(
                                        textCapitalization: TextCapitalization.characters,
                                        onChanged: (value) {
                                          // Force uppercase display
                                          final upperText = value.toUpperCase();
                                          if (formController.bankName.text != upperText) {
                                            formController.bankName.value = formController.bankName.value.copyWith(
                                              text: upperText,
                                              selection: TextSelection.collapsed(offset: upperText.length),
                                            );
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Requried this field';
                                          }
                                          return null; // validation passed
                                        },
                                        controller: formController.bankName,
                                        // maxLines: 2,
                                        decoration: InputDecoration(
                                          labelText: "Bank name",
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
                                      width:  MediaQuery.of(context).size.width * 0.120,
                                      // height: 36,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Requried this field';
                                          }
                                          return null; // validation passed
                                        },
                                        controller: formController.bankAccNumber,
                                        // maxLines: 2,
                                        decoration: InputDecoration(
                                          labelText: "Bank acc number",
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
                                      width:  MediaQuery.of(context).size.width * 0.100,
                                      // height: 36,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Requried this field';
                                          }
                                          return null; // validation passed
                                        },
                                        controller: formController.IFSCcode,
                                        // maxLines: 2,
                                        decoration: InputDecoration(
                                          labelText: "IFSC code",
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
                                    DropdownButtonHideUnderline(
                                      child: Container(
                                        width:  MediaQuery.of(context).size.width * 0.130,
                                        height:  36,
                                        padding: EdgeInsets.symmetric(horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: Utils().background,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            width: 1.5,
                                            color: Utils().border_1,
                                          ),
                                        ),
                                        child: DropdownButton<String>(
                                          value: formController.selectPhotoIdDoc.value.isEmpty
                                              ? null
                                              : formController.selectPhotoIdDoc.value,
                                          hint: Text(
                                            "${formController.selectAddProofIdDoc.toString()}", // (એડ્રેસ પુરાવાના પસંદ કરો)
                                            style: TextStyle(
                                              color: Utils().border_1,
                                              fontSize: 12,
                                            ),
                                          ),
                                          isExpanded: true,
                                          icon: Icon(Icons.keyboard_arrow_down_rounded,
                                              color: Utils().border_1, size: 20),
                                          dropdownColor: Utils().background,
                                          items: photoIdDoc.map((e) {
                                            return DropdownMenuItem<String>(
                                              value: e['name'].toString(),
                                              child: Text(e['name'].toString(),
                                                  style: TextStyle(color: Utils().border_1,fontSize: 12)),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            formController.selectPhotoIdDoc.value = newValue ?? '';
                                            formController.selectPhotoIdDocError.value = false;
                                            setState(() {
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      // height: 45,
                                      width:  MediaQuery.of(context).size.width * 0.140,
                                      // height: 36,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Requried this field';
                                          }
                                          return null; // validation passed
                                        },
                                        controller: formController.idProofNumber,
                                        // maxLines: 2,
                                        decoration: InputDecoration(
                                          labelText: "Photo ID Proof Number",
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
                                    Obx(() => Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          formController.addProofFront();
                                          print("open image");
                                        },
                                        child: Container(
                                          width:  MediaQuery.of(context).size.width * 0.1,
                                          height:  MediaQuery.of(context).size.width * 0.05,
                                          decoration: BoxDecoration(
                                            color: Utils().picture,
                                            borderRadius: BorderRadius.circular(11),
                                            // image: formController.idImageFront.value != null
                                            //     ? DecorationImage(
                                            //   image: MemoryImage(formController.idImageFront.value!),
                                            //   fit: BoxFit.contain,
                                            // )
                                            //     : formController.frontId.isNotEmpty
                                            //     ? DecorationImage(
                                            //   image: FileImage(File(formController.frontId.value)),
                                            //   fit: BoxFit.contain,
                                            // )
                                            //     : null,
                                          ),
                                          child: formController.idImageFront.value != null? Image(
                                            image: MemoryImage(formController.idImageFront.value!),
                                            fit: BoxFit.contain,
                                          ):widget.data['profile_id_img'] != null && widget.data['profile_id_img'].isNotEmpty ? Image.network(
                                            widget.data['profile_id_img'].toString(),
                                            fit: BoxFit.contain,
                                          ) : Icon(
                                            Icons.account_circle, // Default icon when there's no image
                                            size: 50,
                                            color: Utils().border_1, // Change to any color you prefer
                                          ),
                                        ),
                                      ),
                                    )),
                                    Obx(() => Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          formController.addProofBack();
                                          print("open image");
                                        },
                                        child: Container(
                                          width:  MediaQuery.of(context).size.width * 0.1,
                                          height:  MediaQuery.of(context).size.width * 0.05,
                                          decoration: BoxDecoration(
                                            color: Utils().picture,
                                            borderRadius: BorderRadius.circular(11),
                                            // image: formController.backId.value != null
                                            //     ? DecorationImage(
                                            //   image: MemoryImage(formController.backId.value!),
                                            //   fit: BoxFit.contain,
                                            // )
                                            //     : formController.backImage.isNotEmpty
                                            //     ? DecorationImage(
                                            //   image: FileImage(File(formController.backImage.value)),
                                            //   fit: BoxFit.contain,
                                            // )
                                            //     : null,
                                          ),
                                          child: formController.backId.value != null? Image(
                                            image: MemoryImage(formController.backId.value!),
                                            fit: BoxFit.contain,
                                          ):widget.data['profile_id_img_back'] != null && widget.data['profile_id_img_back'].isNotEmpty ? Image.network(
                                            widget.data['profile_id_img_back'].toString(),
                                            fit: BoxFit.contain,
                                          ) : Icon(
                                            Icons.account_circle, // Default icon when there's no image
                                            size: 50,
                                            color: Utils().border_1, // Change to any color you prefer
                                          ),
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            // height: 260,
            // width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Utils().background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
                color: Utils().border_1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8,bottom: 4,top: 4),// (એડ્રેસની માહિતી)
                      child: Text("Address Information",style: TextStyle(
                        color: Utils().text,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 8,bottom: 4),// (કાયમી સરનામું)
                    child: Text("Permanent Address",style: TextStyle(
                      color: Utils().text,
                      fontSize: 18,
                    ),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        // height: 50,
                        width: MediaQuery.of(context).size.width * 0.20,
                        child: TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          onChanged: (value) {
                            // Force uppercase display
                            final upperText = value.toUpperCase();
                            if (formController.addressLine1.text != upperText) {
                              formController.addressLine1.value = formController.addressLine1.value.copyWith(
                                text: upperText,
                                selection: TextSelection.collapsed(offset: upperText.length),
                              );
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required this field';
                            }
                            if (value.contains(",")) {
                              return 'Comma (,) is not allowed';
                            }
                            return null; // validation passed
                          },
                          controller: formController.addressLine1,
                          // maxLines: 2,
                          decoration: InputDecoration(
                            labelText: "User Address Line 1",
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
                        // height: 50,
                        width: MediaQuery.of(context).size.width * 0.20,
                        child: TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          onChanged: (value) {
                            // Force uppercase display
                            final upperText = value.toUpperCase();
                            if (formController.addressLine2.text != upperText) {
                              formController.addressLine2.value = formController.addressLine2.value.copyWith(
                                text: upperText,
                                selection: TextSelection.collapsed(offset: upperText.length),
                              );
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required this field';
                            }
                            if (value.contains(",")) {
                              return 'Comma (,) is not allowed';
                            }
                            return null; // validation passed
                          },
                          controller: formController.addressLine2,
                          // maxLines: 2,
                          decoration: InputDecoration(
                            labelText: "User Address Line 2",
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
                        width: MediaQuery.of(context).size.width * 0.11,
                        child: TextFormField(
                          controller: formController.pinCode,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required field';
                            }
                            return null;
                          },
                          onChanged: (value) async {
                            // 1️⃣ Less than 6 digits → clear all fields and model
                            if (value.length < 6) {
                              formController.area.clear();
                              formController.district.clear();
                              formController.state.clear();
                              formController.pincodeModel = null;
                              return;
                            }

                            // 2️⃣ Exactly 6 digits → call API and set data if valid
                            if (value.length == 6) {
                              // Clear old data before fetching new
                              formController.area.clear();
                              formController.district.clear();
                              formController.state.clear();
                              formController.pincodeModel = null;

                              await formController.pinCodeApi(value); // API call

                              final poList = formController.pincodeModel?.data.first.postOffice;
                              final po = (poList != null && poList.isNotEmpty) ? poList.first : null;

                              if (po == null) {
                                // No result → do nothing (keep fields blank)
                                return;
                              }

                              // ✅ Valid response → populate the fields
                              formController.area.text     = po.name ?? '';
                              formController.district.text = po.district ?? '';
                              formController.state.text    = po.state ?? '';
                            }
                          },

                          decoration: InputDecoration(
                            labelText: 'Pin Code',
                            labelStyle: TextStyle(fontSize: 12,color: Utils().border_1,),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Utils().button, width: 1.5),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Utils().button, width: 2),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        // height: 50,
                        width: MediaQuery.of(context).size.width * 0.11,
                        child: TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          onChanged: (value) {
                            // Force uppercase display
                            final upperText = value.toUpperCase();
                            if (formController.area.text != upperText) {
                              formController.area.value = formController.area.value.copyWith(
                                text: upperText,
                                selection: TextSelection.collapsed(offset: upperText.length),
                              );
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Requried this field';
                            }
                            return null; // validation passed
                          },
                          controller: formController.area,
                          // maxLines: 2,
                          decoration: InputDecoration(
                            labelText: "area",
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
                        // height: 50,
                        width: MediaQuery.of(context).size.width * 0.11,
                        child: TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          onChanged: (value) {
                            // Force uppercase display
                            final upperText = value.toUpperCase();
                            if (formController.district.text != upperText) {
                              formController.district.value = formController.district.value.copyWith(
                                text: upperText,
                                selection: TextSelection.collapsed(offset: upperText.length),
                              );
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Requried this field';
                            }
                            return null; // validation passed
                          },
                          controller: formController.district,
                          // maxLines: 2,
                          decoration: InputDecoration(
                            labelText: "District",
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
                        // height: 50,
                        width: MediaQuery.of(context).size.width * 0.11,
                        child: TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          onChanged: (value) {
                            // Force uppercase display
                            final upperText = value.toUpperCase();
                            if (formController.state.text != upperText) {
                              formController.state.value = formController.state.value.copyWith(
                                text: upperText,
                                selection: TextSelection.collapsed(offset: upperText.length),
                              );
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Requried this field';
                            }
                            return null; // validation passed
                          },
                          controller: formController.state,
                          // maxLines: 2,
                          decoration: InputDecoration(
                            labelText: "State",
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
                  // SizedBox(height: 10,),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8), // (રહેઠાણનું સરનામું)
                        child: Text("Residencial Address",style: TextStyle(
                          color: Utils().text,
                          fontSize: 18,
                        ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 22),
                        child: SizedBox(
                          width: 280,
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              "Same As Permanent Address",
                              style: TextStyle(
                                color: Utils().border_1,
                                fontSize: 16,
                              ),
                            ),
                            value: formController.isAddress,
                            onChanged: (val) {
                              setState(() {
                                formController.isAddress = val ?? false;

                                if (formController.isAddress==true) {
                                  // Copy permanent address to residential fields immediately
                                  formController.reAddressLine1.text = formController.addressLine1.text;
                                  formController.reAddressLine2.text = formController.addressLine2.text;
                                  formController.rePinCode.text = formController.pinCode.text;
                                  formController.reState.text = formController.state.text;
                                  formController.reArea.text = formController.area.text;
                                  formController.reDistrict.text = formController.district.text;
                                } else {
                                  // Optional: clear fields if unchecked
                                  formController.reAddressLine1.clear();
                                  formController.reAddressLine2.clear();
                                  formController.rePinCode.clear();
                                  formController.reState.clear();
                                  formController.reArea.clear();
                                  formController.reDistrict.clear();
                                }
                              });
                            },
                          ),

                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Visibility(
                      visible: !formController.isAddress,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            // height: 50,
                            width: MediaQuery.of(context).size.width * 0.20,
                            child: TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              onChanged: (value) {
                                // Force uppercase display
                                final upperText = value.toUpperCase();
                                if (formController.reAddressLine1.text != upperText) {
                                  formController.reAddressLine1.value = formController.reAddressLine1.value.copyWith(
                                    text: upperText,
                                    selection: TextSelection.collapsed(offset: upperText.length),
                                  );
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Requried this field';
                                }
                                return null; // validation passed
                              },
                              controller: formController.reAddressLine1,
                              // maxLines: 2,
                              decoration: InputDecoration(
                                labelText: "User Address Line 1",
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
                            // height: 50,
                            width: MediaQuery.of(context).size.width * 0.20,
                            child: TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              onChanged: (value) {
                                // Force uppercase display
                                final upperText = value.toUpperCase();
                                if (formController.reAddressLine2.text != upperText) {
                                  formController.reAddressLine2.value = formController.reAddressLine2.value.copyWith(
                                    text: upperText,
                                    selection: TextSelection.collapsed(offset: upperText.length),
                                  );
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Requried this field';
                                }
                                return null; // validation passed
                              },
                              controller: formController.reAddressLine2,
                              // maxLines: 2,
                              decoration: InputDecoration(
                                labelText: "User Address Line 2",
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
                            width: MediaQuery.of(context).size.width * 0.11,
                            child: TextFormField(
                              controller: formController.rePinCode,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6),
                              ],
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Required field';
                                if (v.length != 6)         return 'PIN must be 6 digits';
                                return null;
                              },
                              onChanged: (value) async {
                                /* 👉  A.  < 6 chars  → blank the three linked fields.   */
                                if (value.length < 6) {
                                  formController.reArea.clear();
                                  formController.reDistrict.clear();
                                  formController.reState.clear();
                                  formController.rePinCodeModel = null;   // drop old data
                                  return;
                                }
                                if (value.length == 6) {
                                  // show blanks while we load
                                  formController.reArea.clear();
                                  formController.reDistrict.clear();
                                  formController.reState.clear();
                                  formController.rePinCodeModel = null;

                                  final ok = await formController.pinCodeApi(
                                    value,
                                    forPermanent: true,      // tells the helper which set to fill
                                  );

                                  if (!ok) return;           // invalid code → keep blanks

                                  // success: controllers already filled inside pinCodeApi
                                }
                              },

                              decoration: InputDecoration(
                                labelText: 'Pin Code',
                                labelStyle: TextStyle(fontSize: 12,
                                  color: Utils().border_1,
                                ),
                                contentPadding:
                                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                            // height: 50,
                            width: MediaQuery.of(context).size.width * 0.11,
                            child: TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              onChanged: (value) {
                                // Force uppercase display
                                final upperText = value.toUpperCase();
                                if (formController.reArea.text != upperText) {
                                  formController.reArea.value = formController.reArea.value.copyWith(
                                    text: upperText,
                                    selection: TextSelection.collapsed(offset: upperText.length),
                                  );
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Requried this field';
                                }
                                return null; // validation passed
                              },
                              controller: formController.reArea,
                              // maxLines: 2,
                              decoration: InputDecoration(
                                labelText: "area",
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
                            // height: 50,
                            width: MediaQuery.of(context).size.width * 0.11,
                            child: TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              onChanged: (value) {
                                // Force uppercase display
                                final upperText = value.toUpperCase();
                                if (formController.reDistrict.text != upperText) {
                                  formController.reDistrict.value = formController.reDistrict.value.copyWith(
                                    text: upperText,
                                    selection: TextSelection.collapsed(offset: upperText.length),
                                  );
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Requried this field';
                                }
                                return null; // validation passed
                              },
                              controller: formController.reDistrict,
                              // maxLines: 2,
                              decoration: InputDecoration(
                                labelText: "District",
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
                            // height: 50,
                            width: MediaQuery.of(context).size.width * 0.11,
                            child: TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              onChanged: (value) {
                                // Force uppercase display
                                final upperText = value.toUpperCase();
                                if (formController.reState.text != upperText) {
                                  formController.reState.value = formController.reState.value.copyWith(
                                    text: upperText,
                                    selection: TextSelection.collapsed(offset: upperText.length),
                                  );
                                }
                              },
                              onFieldSubmitted: (value)async {
                                if(widget.formKey.currentState!.validate())
                                {
                                  await formController.updateKycDetails(context);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Kyclist(data: {},)));

                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Requried this field';
                                }
                                return null; // validation passed
                              },
                              controller: formController.reState,
                              // maxLines: 2,
                              decoration: InputDecoration(
                                labelText: "State",
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
                      )),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


class editAddressInformation extends StatefulWidget {
  @override
  State<editAddressInformation> createState() => _EditAddressInformationState();
}

class _EditAddressInformationState extends State<editAddressInformation> {


  final ValueNotifier<bool> isSameAddress = ValueNotifier(false);

  bool isAddress = false;
  final FormController formController = Get.put(FormController());
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      // width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Utils().background,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 1,
          color: Utils().border_1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8,bottom: 4,top: 4),// (એડ્રેસની માહિતી)
            child: Text("Address Information",style: TextStyle(
              color: Utils().text,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8,bottom: 4),// (કાયમી સરનામું)
            child: Text("Permanent Address",style: TextStyle(
              color: Utils().text,
              fontSize: 18,
            ),),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 50,
                width: 320,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Requried this field';
                    }
                    return null; // validation passed
                  },
                  controller: formController.addressLine1,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: "User Address Line 1",
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
              SizedBox(
                height: 50,
                width: 320,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Requried this field';
                    }
                    return null; // validation passed
                  },
                  controller: formController.addressLine2,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: "User Address Line 2",
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
              SizedBox(
                height: 50,
                width: 180,
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
                  maxLines: 2,
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
              SizedBox(
                height: 50,
                width: 180,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Requried this field';
                    }
                    return null; // validation passed
                  },
                  controller: formController.area,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: "area",
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
              SizedBox(
                height: 50,
                width: 180,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Requried this field';
                    }
                    return null; // validation passed
                  },
                  controller: formController.district,
                  maxLines: 2,
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
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                width: 180,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Requried this field';
                    }
                    return null; // validation passed
                  },
                  controller: formController.state,
                  maxLines: 2,
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
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8), // (રહેઠાણનું સરનામું)
                child: Text("Residencial Address",style: TextStyle(
                  color: Utils().text,
                  fontSize: 18,
                ),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: SizedBox(
                  width: 280,
                  child: CheckboxListTile(
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
                ),
              ),
            ],
          ),
          SizedBox(height: 5,),
          Visibility(
              visible: !isAddress,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 50,
                    width: 320,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requried this field';
                        }
                        return null; // validation passed
                      },
                      controller: formController.reAddressLine1,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: "User Address Line 1",
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
                  SizedBox(
                    height: 50,
                    width: 320,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requried this field';
                        }
                        return null; // validation passed
                      },
                      controller: formController.reAddressLine2,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: "User Address Line 2",
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
                  SizedBox(
                    height: 50,
                    width: 180,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requried this field';
                        }
                        return null; // validation passed
                      },
                      onChanged: (value) async {
                        if(value.length == 6){
                          await formController.pinCodeApi(value);
                          formController.reArea.text = formController.pincodeModel!.data.first.postOffice[0].name.toString();
                          formController.reDistrict.text = formController.pincodeModel!.data.first.postOffice[0].district.toString();
                          formController.reState.text = formController.pincodeModel!.data.first.postOffice[0].state.toString();
                        }
                      },
                      controller: formController.rePinCode,
                      maxLines: 2,
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
                  SizedBox(
                    height: 50,
                    width: 180,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requried this field';
                        }
                        return null; // validation passed
                      },
                      controller: formController.reArea,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: "area",
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
                  SizedBox(
                    height: 50,
                    width: 180,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requried this field';
                        }
                        return null; // validation passed
                      },
                      controller: formController.reDistrict,
                      maxLines: 2,
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
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: 180,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requried this field';
                        }
                        return null; // validation passed
                      },
                      controller: formController.reState,
                      maxLines: 2,
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
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}





class viewUserInformation extends StatefulWidget {
  final Map<String, dynamic> data;
  @override
  State<viewUserInformation> createState() => _viewUserInformationState();
  const viewUserInformation({super.key, required this.data,});
}

class _viewUserInformationState extends State<viewUserInformation> {


  final FormController formController = Get.put(FormController());

  bool isKycChecked = false;
  List<dynamic> photoIdDoc = [];
  List<dynamic> addressDoc = [];


  @override
  void initState() {
    super.initState();
    initData();
    formController.editKycStoreId = widget.data['id'].toString();
    widget.data['id'].toString();
    widget.data['profile_img'].toString();
    widget.data['profile_id_img'].toString();
    widget.data['profile_id_img_back'].toString();
    formController.firstName.text = widget.data['first_name'].toString();
    formController.middleName.text = widget.data['middle_name'].toString();
    formController.lastName.text = widget.data['last_name'].toString();
    formController.mobileNumber.text = widget.data['mobile_no'].toString();
    formController.secondaryMobileNumber.text = widget.data['secondary_mobile_no'].toString();
    formController.bankName.text = widget.data['bank_name'].toString();
    formController.bankAccNumber.text = widget.data['bank_acc_no'].toString();
    formController.IFSCcode.text = widget.data['bank_ifsc_code'].toString();
    // formController.idProofNumber.text = widget.data['profile_id_type'].toString();
    formController.idProofNumber.text = widget.data['profile_id_no'].toString();
    formController.referenceName.text = widget.data['reference_name'].toString();
    formController.referenceNumber.text = widget.data['reference_contact_no'].toString();
    //formController.addressProofNumber.text = widget.data['address_proof_no'].toString();
    String address = widget.data['permanent_address'];
    String residentical = widget.data['residentical_address'];


    List<String> parts = address.split(',').where((e) => e.trim().isNotEmpty).toList();
    List<String> residenticalAdd = residentical.split(',').where((e) => e.trim().isNotEmpty).toList();

    String addressLine1 = parts.length > 0 ? parts[0] : '';
    formController.addressLine1.text = addressLine1;
    print("addressLine1 dev: $addressLine1");

    String addressLine2 = parts.length > 1 ? parts[1] : '';
    formController.addressLine2.text = addressLine2;

    String pinCode = parts.length > 2 ? parts[2] : '';
    formController.pinCode.text = pinCode;

    String area = parts.length > 3 ? parts[3] : '';
    formController.area.text = area;

    String district = parts.length > 4 ? parts[4] : '';
    formController.district.text = district;

    String state = parts.length > 5 ? parts[5] : '';
    formController.state.text = state;

    String AddressLine1 = residenticalAdd.length > 0 ? residenticalAdd[0] : '';
    formController.reAddressLine1.text = AddressLine1;

    String AddressLine2 = residenticalAdd.length > 1 ? residenticalAdd[1] : '';
    formController.reAddressLine2.text = AddressLine2;

    String Pincode = residenticalAdd.length > 2 ? residenticalAdd[2] : '';
    formController.rePinCode.text = Pincode;


    String Area = residenticalAdd.length > 3 ? residenticalAdd[3] : '';
    formController.reArea.text = Area;

    String District = residenticalAdd.length > 4 ? residenticalAdd[4] : '';
    formController.reDistrict.text = District;

    String State = residenticalAdd.length > 5 ? residenticalAdd[5] : '';
    formController.reState.text = State;
  }

  initData() async {
    photoIdDoc = await formController.getDocument("photo_id");
    addressDoc = await formController.getDocument("address");
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Utils().background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: Utils().border_1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Text("User Information",style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Utils().text,
                    fontSize: 22,
                  ),),
                ),
                Divider(),
                SizedBox(height: 10,),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start  ,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          onTap: () {
                            Get.dialog(Dialog(
                              child: Container(
                                height: 300,
                                width: 200,
                                // color: Colors.blue,
                                child: widget.data['profile_img'] != null && widget.data['profile_img'].isNotEmpty
                                    ? Image.network(
                                  widget.data['profile_img'].toString(),
                                  fit: BoxFit.fitHeight,
                                ) : Icon(
                                  Icons.account_circle, // Default icon when there's no image
                                  size: 50,
                                  color: Utils().border_1, // Change to any color you prefer
                                ),
                              ),
                            ));
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.width * 0.11>100?100:MediaQuery.of(context).size.width * 0.11,
                            width: MediaQuery.of(context).size.width * 0.11>100?100:MediaQuery.of(context).size.width * 0.11,
                            decoration: BoxDecoration(
                              color: Utils().picture,
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: widget.data['profile_img'] != null && widget.data['profile_img'].isNotEmpty
                                ? Image.network(
                              widget.data['profile_img'].toString(),
                              fit: BoxFit.contain,
                            ) : Icon(
                              Icons.account_circle, // Default icon when there's no image
                              size: 50,
                              color: Utils().border_1, // Change to any color you prefer
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start  ,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.100,
                                    // height: 36,
                                    child: TextFormField(
                                      readOnly: true,
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
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  SizedBox(
                                    width:  MediaQuery.of(context).size.width * 0.100,
                                    // height: 36,
                                    child: TextFormField(
                                      readOnly: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Requried this field';
                                        }
                                        return null; // validation passed
                                      },
                                      controller: formController.middleName,
                                      // maxLines: 2,
                                      decoration: InputDecoration(
                                        labelText: "Middle Name",
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
                                  Spacer(),
                                  SizedBox(
                                    width:  MediaQuery.of(context).size.width * 0.100,
                                    // height: 36,
                                    child: TextFormField(
                                      readOnly: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Requried this field';
                                        }
                                        return null; // validation passed
                                      },
                                      controller: formController.lastName,
                                      //maxLines: 2,
                                      decoration: InputDecoration(
                                        labelText: "Last Name",
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
                                  Spacer(),
                                  SizedBox(
                                    width:  MediaQuery.of(context).size.width * 0.120,
                                    // height: 36,
                                    child: TextFormField(
                                      readOnly: true,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Requried this field';
                                        }
                                        return null; // validation passed
                                      },
                                      controller: formController.mobileNumber,
                                      // maxLines: 2,
                                      decoration: InputDecoration(
                                        labelText: "Mobile Number",
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
                                  Spacer(),
                                  SizedBox(
                                    width:  MediaQuery.of(context).size.width * 0.150,
                                    // height: 36,
                                    child: TextFormField(
                                      readOnly: true,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Requried this field';
                                        }
                                        return null; // validation passed
                                      },
                                      controller:formController.secondaryMobileNumber,
                                      //maxLines: 2,
                                      decoration: InputDecoration(
                                        labelText: " Secondary Mobile Number",
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
                                  Spacer(),
                                  SizedBox(
                                    width:  MediaQuery.of(context).size.width * 0.130,
                                    // height: 36,
                                    child: TextFormField(
                                      readOnly: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Requried this field';
                                        }
                                        return null; // validation passed
                                      },
                                      controller: formController.referenceName,
                                      //maxLines: 2,
                                      decoration: InputDecoration(
                                        labelText: "Reference Name",
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
                                  Spacer(),
                                  SizedBox(
                                    width:  MediaQuery.of(context).size.width * 0.120,
                                    // height: 36,
                                    child: TextFormField(
                                      readOnly: true,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Requried this field';
                                        }
                                        return null; // validation passed
                                      },
                                      controller:formController.referenceNumber,
                                      //maxLines: 2,
                                      decoration: InputDecoration(
                                        labelText: " Refrencer Mobile Number",
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width:  MediaQuery.of(context).size.width * 0.100,
                                    // height: 36,
                                    child: TextFormField(
                                      readOnly: true,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Requried this field';
                                        }
                                        return null; // validation passed
                                      },
                                      controller: formController.bankName,
                                      // maxLines: 2,
                                      decoration: InputDecoration(
                                        labelText: "Bank name",
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
                                    width:  MediaQuery.of(context).size.width * 0.120,
                                    // height: 36,
                                    child: TextFormField(
                                      readOnly: true,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Requried this field';
                                        }
                                        return null; // validation passed
                                      },
                                      controller: formController.bankAccNumber,
                                      // maxLines: 2,
                                      decoration: InputDecoration(
                                        labelText: "Bank acc number",
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
                                    width:  MediaQuery.of(context).size.width * 0.100,
                                    // height: 36,
                                    child: TextFormField(
                                      readOnly: true,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Requried this field';
                                        }
                                        return null; // validation passed
                                      },
                                      controller: formController.IFSCcode,
                                      // maxLines: 2,
                                      decoration: InputDecoration(
                                        labelText: "IFSC code",
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
                                  Container(
                                    width:  MediaQuery.of(context).size.width * 0.130,
                                    height:  36,
                                    padding: EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Utils().background,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 1.5,
                                        color: Utils().border_1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text("${widget.data['profile_id_type'].toString()}",  style: TextStyle(
                                        color: Utils().border_1,
                                        fontSize: 12,
                                      ),),
                                    ),
                                  ),
                                  SizedBox(
                                    // height: 45,
                                    width:  MediaQuery.of(context).size.width * 0.140,
                                    // height: 36,
                                    child: TextFormField(
                                      readOnly: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Requried this field';
                                        }
                                        return null; // validation passed
                                      },
                                      controller: formController.idProofNumber,
                                      // maxLines: 2,
                                      decoration: InputDecoration(
                                        labelText: "Photo ID Proof Number",
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
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: GestureDetector(
                                      onTap: (){
                                        Get.dialog(Dialog(
                                          child: Container(
                                            height: 300,
                                            width: 200,
                                            // color: Colors.blue,
                                            child: widget.data['profile_id_img'] != null && widget.data['profile_id_img'].isNotEmpty
                                                ? Image.network(
                                              widget.data['profile_id_img'].toString(),
                                              fit: BoxFit.fitHeight,
                                            ) : Icon(
                                              Icons.account_circle, // Default icon when there's no image
                                              size: 50,
                                              color: Utils().border_1, // Change to any color you prefer
                                            ),
                                          ),
                                        ));
                                      },
                                      child: Container(
                                        width:  MediaQuery.of(context).size.width * 0.1,
                                        height:  MediaQuery.of(context).size.width * 0.05,
                                        decoration: BoxDecoration(
                                          color: Utils().picture,
                                          borderRadius: BorderRadius.circular(11),
                                        ),
                                        child: widget.data['profile_id_img'] != null && widget.data['profile_id_img'].isNotEmpty
                                            ? Image.network(
                                          widget.data['profile_id_img'].toString(),
                                          fit: BoxFit.contain,
                                        ) : Icon(
                                          Icons.account_circle, // Default icon when there's no image
                                          size: 50,
                                          color: Utils().border_1, // Change to any color you prefer
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: GestureDetector(
                                      onTap: (){
                                        Get.dialog(Dialog(
                                          child: Container(
                                            height: 300,
                                            width: 200,
                                            // color: Colors.blue,
                                            child: widget.data['profile_id_img_back'] != null && widget.data['profile_id_img_back'].isNotEmpty
                                                ? Image.network(
                                              widget.data['profile_id_img_back'].toString(),
                                              fit: BoxFit.fitHeight,
                                            ) : Icon(
                                              Icons.account_circle, // Default icon when there's no image
                                              size: 50,
                                              color: Utils().border_1, // Change to any color you prefer
                                            ),
                                          ),
                                        ));
                                      },
                                      child: Container(
                                        width:  MediaQuery.of(context).size.width * 0.1,
                                        height:  MediaQuery.of(context).size.width * 0.05,
                                        decoration: BoxDecoration(
                                          color: Utils().picture,
                                          borderRadius: BorderRadius.circular(11),
                                        ),
                                        child: widget.data['profile_id_img_back'] != null && widget.data['profile_id_img_back'].isNotEmpty
                                            ? Image.network(
                                          widget.data['profile_id_img_back'].toString(),
                                          fit: BoxFit.contain,
                                        ) : Icon(
                                          Icons.account_circle, // Default icon when there's no image
                                          size: 50,
                                          color: Utils().border_1, // Change to any color you prefer
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 10,bottom: 3),
                //   child: CheckboxListTile(
                //     title: Text(
                //       "Pay The KYC Fees",
                //       style: TextStyle(
                //         color: Utils().text,
                //         fontWeight: FontWeight.w600,
                //         fontSize: 16,
                //       ),
                //     ),
                //     value: isKycChecked,
                //     onChanged: (value) {
                //       setState(() {
                //         isKycChecked = value ?? false;
                //       });
                //     },
                //     activeColor: Utils().button,
                //     checkColor: Colors.white,
                //     contentPadding: EdgeInsets.zero,
                //     controlAffinity: ListTileControlAffinity.leading,
                //   ),
                // ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10,),
        Container(
          // height: 260,
          // width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Utils().background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: Utils().border_1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8,bottom: 4,top: 4),// (એડ્રેસની માહિતી)
                    child: Text("Address Information",style: TextStyle(
                      color: Utils().text,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),),
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 8,bottom: 4),// (કાયમી સરનામું)
                  child: Text("Permanent Address",style: TextStyle(
                    color: Utils().text,
                    fontSize: 18,
                  ),),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      // height: 50,
                      width: MediaQuery.of(context).size.width * 0.20,
                      child: TextFormField(
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Requried this field';
                          }
                          return null; // validation passed
                        },
                        controller: formController.addressLine1,
                        // maxLines: 2,
                        decoration: InputDecoration(
                          labelText: "User Address Line 1",
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
                      // height: 50,
                      width: MediaQuery.of(context).size.width * 0.20,
                      child: TextFormField(
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Requried this field';
                          }
                          return null; // validation passed
                        },
                        controller: formController.addressLine2,
                        // maxLines: 2,
                        decoration: InputDecoration(
                          labelText: "User Address Line 2",
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
                      // height: 50,
                      width: MediaQuery.of(context).size.width * 0.11,
                      child: TextFormField(
                        readOnly: true,
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
                      // height: 50,
                      width: MediaQuery.of(context).size.width * 0.11,
                      child: TextFormField(
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Requried this field';
                          }
                          return null; // validation passed
                        },
                        controller: formController.area,
                        // maxLines: 2,
                        decoration: InputDecoration(
                          labelText: "area",
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
                      // height: 50,
                      width: MediaQuery.of(context).size.width * 0.11,
                      child: TextFormField(
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Requried this field';
                          }
                          return null; // validation passed
                        },
                        controller: formController.district,
                        // maxLines: 2,
                        decoration: InputDecoration(
                          labelText: "District",
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
                      // height: 50,
                      width: MediaQuery.of(context).size.width * 0.11,
                      child: TextFormField(
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Requried this field';
                          }
                          return null; // validation passed
                        },
                        controller: formController.state,
                        // maxLines: 2,
                        decoration: InputDecoration(
                          labelText: "State",
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
                // SizedBox(height: 10,),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8), // (રહેઠાણનું સરનામું)
                      child: Text("Residencial Address",style: TextStyle(
                        color: Utils().text,
                        fontSize: 18,
                      ),),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 22),
                    //   child: SizedBox(
                    //     width: 280,
                    //     child: CheckboxListTile(
                    //       contentPadding: EdgeInsets.zero,
                    //       title: Text("Same As Permeant Address",style: TextStyle(
                    //         color: Utils().border_1,
                    //         fontSize: 16,
                    //       ),),
                    //       value: isAddress,
                    //       onChanged: (val) {
                    //         isAddress= !isAddress;
                    //         setState(() {
                    //         });
                    //       },
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: 5,),
                Visibility(
                  // visible: !isAddress,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          // height: 50,
                          width: MediaQuery.of(context).size.width * 0.20,
                          child: TextFormField(
                            readOnly: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Requried this field';
                              }
                              return null; // validation passed
                            },
                            controller: formController.reAddressLine1,
                            // maxLines: 2,
                            decoration: InputDecoration(
                              labelText: "User Address Line 1",
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
                          // height: 50,
                          width: MediaQuery.of(context).size.width * 0.20,
                          child: TextFormField(
                            readOnly: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Requried this field';
                              }
                              return null; // validation passed
                            },
                            controller: formController.reAddressLine2,
                            // maxLines: 2,
                            decoration: InputDecoration(
                              labelText: "User Address Line 2",
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
                          // height: 50,
                          width: MediaQuery.of(context).size.width * 0.11,
                          child: TextFormField(
                            readOnly: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Requried this field';
                              }
                              return null; // validation passed
                            },
                            onChanged: (value) async {
                              if(value.length == 6){
                                await formController.pinCodeApi(value);
                                formController.reArea.text = formController.pincodeModel!.data.first.postOffice[0].name.toString();
                                formController.reDistrict.text = formController.pincodeModel!.data.first.postOffice[0].district.toString();
                                formController.reState.text = formController.pincodeModel!.data.first.postOffice[0].state.toString();
                              }
                            },
                            controller: formController.rePinCode,
                            // maxLines: 2,
                            decoration: InputDecoration(
                              labelText: "Pin Code",
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
                          // height: 50,
                          width: MediaQuery.of(context).size.width * 0.11,
                          child: TextFormField(
                            readOnly: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Requried this field';
                              }
                              return null; // validation passed
                            },
                            controller: formController.reArea,
                            // maxLines: 2,
                            decoration: InputDecoration(
                              labelText: "area",
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
                          // height: 50,
                          width: MediaQuery.of(context).size.width * 0.11,
                          child: TextFormField(
                            readOnly: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Requried this field';
                              }
                              return null; // validation passed
                            },
                            controller: formController.reDistrict,
                            // maxLines: 2,
                            decoration: InputDecoration(
                              labelText: "District",
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
                          // height: 50,
                          width: MediaQuery.of(context).size.width * 0.11,
                          child: TextFormField(
                            readOnly: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Requried this field';
                              }
                              return null; // validation passed
                            },
                            controller: formController.reState,
                            // maxLines: 2,
                            decoration: InputDecoration(
                              labelText: "State",
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
                    )),
                SizedBox(height: 10,),
              ],
            ),
          ),
        )
      ],
    );
  }
}