import 'dart:convert';

PincodeModel pincodeModelFromJson(String str) => PincodeModel.fromJson(json.decode(str));

String pincodeModelToJson(PincodeModel data) => json.encode(data.toJson());

class PincodeModel {
  bool success;
  String errorMsg;
  List<Datum> data;

  PincodeModel({
    required this.success,
    required this.errorMsg,
    required this.data,
  });

  factory PincodeModel.fromJson(Map<String, dynamic> json) => PincodeModel(
    success: json["success"],
    errorMsg: json["errorMsg"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "errorMsg": errorMsg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String message;
  String status;
  List<PostOffice> postOffice;

  Datum({
    required this.message,
    required this.status,
    required this.postOffice,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    message: json["Message"],
    status: json["Status"],
    postOffice: List<PostOffice>.from(json["PostOffice"].map((x) => PostOffice.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Message": message,
    "Status": status,
    "PostOffice": List<dynamic>.from(postOffice.map((x) => x.toJson())),
  };
}

class PostOffice {
  String name;
  dynamic description;
  String branchType;
  String deliveryStatus;
  String circle;
  String district;
  String division;
  String region;
  String block;
  String state;
  String country;
  String pincode;

  PostOffice({
    required this.name,
    required this.description,
    required this.branchType,
    required this.deliveryStatus,
    required this.circle,
    required this.district,
    required this.division,
    required this.region,
    required this.block,
    required this.state,
    required this.country,
    required this.pincode,
  });

  factory PostOffice.fromJson(Map<String, dynamic> json) => PostOffice(
    name: json["Name"],
    description: json["Description"],
    branchType: json["BranchType"],
    deliveryStatus: json["DeliveryStatus"],
    circle: json["Circle"],
    district: json["District"],
    division: json["Division"],
    region: json["Region"],
    block: json["Block"],
    state: json["State"],
    country: json["Country"],
    pincode: json["Pincode"],
  );

  Map<String, dynamic> toJson() => {
    "Name": name,
    "Description": description,
    "BranchType": branchType,
    "DeliveryStatus": deliveryStatus,
    "Circle": circle,
    "District": district,
    "Division": division,
    "Region": region,
    "Block": block,
    "State": state,
    "Country": country,
    "Pincode": pincode,
  };
}
