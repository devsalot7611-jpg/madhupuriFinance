import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madhupurifinance/kycList.dart';

import 'Controller/FormController.dart';
import 'Utils.dart';

class Mobileui extends StatefulWidget {
  final Map<String, dynamic> data;
   const Mobileui({super.key, required this.data});

  @override
  State<Mobileui> createState() => _MobileuiState();
}

class _MobileuiState extends State<Mobileui> {

  final FormController formController = Get.put(FormController());

  void initState() {
    super.initState();
    // initData();
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

    String Pincode = parts.length > 2 ? residenticalAdd[2] : '';
    formController.rePinCode.text = Pincode;


    String Area = residenticalAdd.length > 3 ? residenticalAdd[3] : '';
    formController.reArea.text = Area;

    String District = residenticalAdd.length > 4 ? residenticalAdd[4] : '';
    formController.reDistrict.text = District;

    String State = residenticalAdd.length > 5 ? residenticalAdd[5] : '';
    formController.reState.text = State;
  }

  // initData() async {
  //   photoIdDoc = await formController.getDocument("photo_id");
  //   addressDoc = await formController.getDocument("address");
  //   setState(() {});
  // }

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
            Text("View Details : ${widget.data['id'].toString()} ",style: TextStyle(
              color: Utils().text,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 12,right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 100,
                    width: 100,
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
              Text("First Name",style: TextStyle(
              color: Utils().text,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),),
              SizedBox(
                width: MediaQuery.of(context).size.width,
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
                  readOnly: true,
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
                  readOnly: true,
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
                  readOnly: true,
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
                  readOnly: true,
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
                  readOnly: true,
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
                  readOnly: true,
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
                  readOnly: true,
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
                  readOnly: true,
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
                  readOnly: true,
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
                      Text("profile id image front",style: TextStyle(
                        color: Utils().text,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 90,
                          width: 200,
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
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("profile id image back",style: TextStyle(
                        color: Utils().text,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 90,
                          width: 200,
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
                    ],
                  ),
                ],
              ),
              Text("Select Photo ID Proof",style: TextStyle(
                color: Utils().text,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),),
              DropdownButtonHideUnderline(
                child: Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
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
                    child: Text(widget.data['profile_id_type'].toString(),style: TextStyle(
                      color: Utils().text,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),),
                  ),
                ),
              ),
              Text("Profile prof Number",style: TextStyle(
                color: Utils().text,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  readOnly: true,
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
                  readOnly: true,
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
                  readOnly: true,
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
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Requried this field';
                          }
                          return null; // validation passed
                        },
                        controller: formController.pinCode,
                        decoration: InputDecoration(
                          labelText: "Pincode",
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
                        readOnly: true,
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
                        readOnly: true,
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
                        readOnly: true,
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
                  readOnly: true,
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
                  readOnly: true,
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
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Requried this field';
                          }
                          return null; // validation passed
                        },
                        controller: formController.rePinCode,
                        decoration: InputDecoration(
                          labelText: "Pin code",
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
                        readOnly: true,
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
                        readOnly: true,
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
                        readOnly: true,
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
              SizedBox(height: 10,)
            ],
          ),
        ),
      ),
    );
  }
}
