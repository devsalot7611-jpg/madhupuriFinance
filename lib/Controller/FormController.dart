import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:madhupurifinance/Controller/KycListController.dart';
import 'package:madhupurifinance/Controller/LoginController.dart';
import 'package:madhupurifinance/kycList.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart' as pw;
import 'package:universal_html/html.dart' as html;
import '../Utils.dart';
import '../models/city_pincode_model.dart';

class FormController extends GetxController {

  final KycListController kycListController = Get.put(KycListController());
  final LoginController loginController = Get.put(LoginController());

  TextEditingController searchController = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController referenceName = TextEditingController();
  TextEditingController referenceNumber = TextEditingController();
  TextEditingController referenceNomineeName = TextEditingController();
  TextEditingController idProofNumber = TextEditingController();
  TextEditingController secondaryMobileNumber = TextEditingController();
  //TextEditingController addressProofNumber = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController bankAccNumber = TextEditingController();
  TextEditingController IFSCcode = TextEditingController();
  TextEditingController addressLine1 = TextEditingController();
  TextEditingController addressLine2 = TextEditingController();
  TextEditingController area = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController pinCode = TextEditingController();

  TextEditingController reAddressLine1 = TextEditingController();
  TextEditingController reAddressLine2 = TextEditingController();
  TextEditingController reArea = TextEditingController();
  TextEditingController reDistrict = TextEditingController();
  TextEditingController reState = TextEditingController();
  TextEditingController rePinCode = TextEditingController();


  // RxnString photoID = RxnString();
  // RxnString addressProof = RxnString();


  String editKycStoreId = '';
  String sameAddress = '';
  Rxn<Uint8List> fileBytes = Rxn<Uint8List>();
  RxBool loading = false.obs;

  PincodeModel? pincodeModel;
  PincodeModel? rePinCodeModel;

  RxString userImage = ''.obs;
  Rx<Uint8List?> personImage = Rx<Uint8List?>(null);

  RxString backImage = ''.obs;
  Rx<Uint8List?> backId = Rx<Uint8List?>(null);

  RxString frontId = ''.obs;
  Rx<Uint8List?> idImageFront = Rx<Uint8List?>(null);

  String? selectAddProofIdDoc;
  List documentsID=[];

  List<Map<String, dynamic>> data=[];
  List<Map<String, dynamic>>  dataTwo=[];
  var imageError = false.obs;
  var frontImageError = false.obs;
  var backImageError = false.obs;
  RxString selectPhotoIdDoc = ''.obs;
  RxBool selectPhotoIdDocError = false.obs;
  RxBool isExportingPdf = false.obs;
  RxBool isExportingExcel = false.obs;

  var kycDetailsTable;
  var pincodeTable;

  bool isAddress = false;
  bool remberME = false;
  RxString errorMessage = "".obs;

  // static late String userID;

  Future<String?> getUserID() async {
    final prefs =await SharedPreferences.getInstance();
    String? userId =prefs.getString('userId');
    if(userId != null){
      return userId;
    }
    else {
      return null;
    }
  }

  Future<bool> pinCodeApi(
      String pincode, {
        bool forPermanent = false,
      }) async {
    // choose the appropriate controllers
    final areaCtrl     = forPermanent ? reArea     : area;
    final districtCtrl = forPermanent ? reDistrict : district;
    final stateCtrl    = forPermanent ? reState    : state;

    // reset UI & cache
    areaCtrl.clear();
    districtCtrl.clear();
    stateCtrl.clear();

    if (forPermanent) {
      rePinCodeModel = null;
    } else {
      pincodeModel   = null;
    }

    try {
      loading.value = true;

      final userId = await getUserID();
      if (userId == null || userId.isEmpty) return false;

      final response = await http.post(
        Uri.parse(
          '${Utils().baseURL}get_pincode_details',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'pincode': pincode}),
      );

      if (response.statusCode != 200) return false;

      final model   = pincodeModelFromJson(response.body);
      final poList  = model.data.isNotEmpty ? model.data.first.postOffice : [];

      if (model.success != true || poList.isEmpty) return false;

      // cache
      if (forPermanent) {
        rePinCodeModel = model;
      } else {
        pincodeModel   = model;
      }

      // populate
      final po = poList.first;
      areaCtrl.text     = po.name     ?? '';
      districtCtrl.text = po.district ?? '';
      stateCtrl.text    = po.state    ?? '';

      return true;
    } catch (_) {
      return false;
    } finally {
      loading.value = false;
    }
  }



  //api
  Future<List<dynamic>> getDocument(String docType) async {
    documentsID = [];
    try {
      loading.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      loginController.loginUserId = prefs.getString("userId");

      if (loginController.loginUserId == null || loginController.loginUserId!.isEmpty) {
        loading.value = false;
        // Get.snackbar("Error", "User ID missing.");
        return [];
      }

      Map<String, dynamic> document = {
        "user_id": loginController.loginUserId,
        "doc_type": docType,
      };

      final response = await http.post(
        Uri.parse("${Utils().baseURL}${Utils().getDocumentType}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(document),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        documentsID = responseData['documents'] ?? [];
      } else {
        // Get.snackbar("Error", responseData["error"] ?? "Document fetch failed");
      }

      loading.value = false;
    } catch (e) {
      loading.value = false;
      // Get.snackbar("Error", "Something went wrong: ${e.toString()}");
    }

    return documentsID;
  }


  //api
  Future<void> insertDetails(BuildContext context, bool isAddress) async {
    loading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      loginController.loginUserId = prefs.getString("userId");

      if (loginController.loginUserId == null || loginController.loginUserId!.isEmpty) {
        loading.value = false;
        // Get.snackbar("Error", "User ID missing.");
        return;
      }

      Map<String, dynamic> encodeImageData(String path, Uint8List? bytes) {
        if (kIsWeb) {
          if (bytes != null && bytes.isNotEmpty) {
            return {
              "byte": bytes.toList(),
              "extension": "jpg",
            };
          }
        } else {
          if (path.isNotEmpty && File(path).existsSync()) {
            return {
              "byte": File(path).readAsBytesSync().toList(),
              "extension": path.split('.').last,
            };
          }
        }
        return {
          "byte": [],
          "extension": "jpg",
        };
      }

      // // Copy permanent address to residential if checkbox is true
      // 🟢 COPY permanent address if checkbox is checked
      if (isAddress == true) {
        addressLine1.text = reAddressLine1.text;
        addressLine2.text = reAddressLine2.text;
        pinCode.text = rePinCode.text;
        state.text = reState.text;
        area.text = reArea.text;
        district.text = reDistrict.text;
      }

// 🔴 VALIDATION
//       if (firstName.text.trim().isEmpty ||
//           mobileNumber.text.trim().isEmpty ||
//           (selectAddProofIdDoc?.isEmpty ?? true) ||
//           (selectPhotoIdDoc?.isEmpty ?? true) ||
//           idProofNumber.text.trim().isEmpty) {
//         loading.value = false;
//         Get.snackbar("Validation Failed", "Please fill all required fields.");
//         return;
//       }

// 🟡 FINAL DATA MAP
      Map<String, dynamic> details = {
        "user_id": loginController.loginUserId,
        "first_name": firstName.text.trim(),
        "middle_name": middleName.text.trim(),
        "last_name": lastName.text.trim(),
        "mobile_no": mobileNumber.text.trim(),
        "reference_name": referenceName.text.trim(),
        "reference_contact_no": referenceNumber.text.trim(),
        "secondary_mobile_no": secondaryMobileNumber.text.trim(),

        // Bank Info
        "bank_name": bankName.text.trim(),
        "bank_acc_no": bankAccNumber.text.trim(),
        "bank_ifsc_code": IFSCcode.text.trim(),

        // ID Proof
        "profile_id_type": selectPhotoIdDoc.value.toString(),
        "profile_id_no": idProofNumber.text.trim(),
        "profile_img": encodeImageData(userImage.value, personImage.value),
        "profile_id_img": encodeImageData(frontId.value, idImageFront.value),
        "profile_id_img_back": encodeImageData(backImage.value, backId.value),

        // Addresses
        "permanent_address": "${addressLine1.text.trim()}, ${addressLine2.text.trim()}, "
            "${pinCode.text.trim()}, ${area.text.trim()}, ${district.text.trim()}, ${state.text.trim()}",

        "residentical_address": "${reAddressLine1.text.trim()}, ${reAddressLine2.text.trim()}, "
            "${rePinCode.text.trim()}, ${reArea.text.trim()}, ${reDistrict.text.trim()}, ${reState.text.trim()}",

        // Other
        "kyc_fees_amount": "0",
      };



      final response = await http.post(
        Uri.parse("${Utils().baseURL}insert_kyc_details"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(details),
      ); 

      // loading.value = false;

      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        Get.snackbar("KYC Added", "Data submitted successfully");
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => Kyclist(data: {},)));
      } else {
        // Get.snackbar("KYC Failed", responseData['errorMsg'].toString());
      }
    } catch (e) {
      loading.value = false;
      // Get.snackbar("KYC Failed", "responseData['errorMsg'].toString()");
      log("Error: ${e.toString()}");
    }
  }


  //api
  Future<void> updateKycDetails(BuildContext context) async{
    try{
      loading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      loginController.loginUserId = prefs.getString("userId");

      if (loginController.loginUserId == null || loginController.loginUserId!.isEmpty) {
        loading.value = false;
        // Get.snackbar("Error", "User ID missing.");
        return;
      }

      Map<String, dynamic> encodeImageUpdate(String path, Uint8List? bytes) {
        if (kIsWeb) {
          if (bytes != null && bytes.isNotEmpty) {
            return {
              "byte": bytes.toList(),
              "extension": "jpg",
            };
          }
        } else {
          if (path.isNotEmpty && File(path).existsSync()) {
            return {
              "byte": File(path).readAsBytesSync().toList(),
              "extension": path.split('.').last,
            };
          }
        }
        return {
          "byte": [],
          "extension": "jpg",
        };
      }

      Map<String , dynamic> updateDetails = {
        "user_id" : loginController.loginUserId,
        "kyc_code" : editKycStoreId,
        "first_name" : firstName.text.trim(),
        "middle_name" : middleName.text.trim(),
        "last_name" : lastName.text.trim(),
        "mobile_no" : mobileNumber.text.trim(),
        "secondary_mobile_no" : secondaryMobileNumber.text.trim(),
        "bank_name" : bankName.text.trim(),
        "bank_acc_no" : bankAccNumber.text.trim(),
        "bank_ifsc_code" : IFSCcode.text.trim(),
        "profile_id_type": selectPhotoIdDoc.value.toString(),
        "permanent_address":
        "${addressLine1.text.trim()}, ${addressLine2.text.trim()}, ${pinCode.text.trim()},${area.text.trim()}, ${district.text.trim()}, ${state.text.trim()}".trim(),

        "residentical_address" :
        "${reAddressLine1.text.trim()},${reAddressLine2.text.trim()},${rePinCode.text.trim()},${reArea.text.trim()},${reDistrict.text.trim()},${reState.text.trim()}".trim(),
        "kyc_fees_amount" : "0",
        "reference_name" : referenceName.text.trim(),
        "reference_contact_no" : referenceNumber.text.trim(),
        "profile_id_img": encodeImageUpdate(frontId.value, idImageFront.value),
        "profile_id_img_back": encodeImageUpdate(backImage.value, backId.value),
        "profile_img": encodeImageUpdate(userImage.value, personImage.value),
        // "nominee_name" : referenceNomineeName.text.trim(),
        // "address_proof_type": bankName.text.trim(),

      };


      final response = await http.post(
        Uri.parse("${Utils().baseURL}${Utils().updateKycDetails}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updateDetails),
      );

      var responseData = jsonDecode(response.body);

      if(response.statusCode == 200 && responseData['success'] == true){
        Navigator.pop(context);
        showKycDetails();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Kyclist(data: {},)));
      }
      else{
        loading.value = false;
       // Get.snackbar("KYC Failed", responseData['errMsg'] ?? "Unknown error");
      }

    }
    catch(e) {
      loading.value = false;
    //  Get.snackbar("Error", "Something went wrong: ${e.toString()}");
      log("Error: ${e.toString()}");
    }
  }


  //api
  Future<void> showKycDetails() async {
    data.clear();
    dataTwo.clear();

    try {
      loading.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      loginController.loginUserId = prefs.getString("userId");

      if (loginController.loginUserId == null || loginController.loginUserId!.isEmpty) {
        loading.value = false;
        errorMessage.value = "User ID missing.";
        return;
      }

      Map<String, dynamic> requestBody = {
        "user_id": loginController.loginUserId,
      };

      final response = await http.post(
        Uri.parse("${Utils().baseURL}${Utils().getKycDetails}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        if (responseData["kyc_details"] != null && responseData["kyc_details"] is List) {
          data = List<Map<String, dynamic>>.from(responseData["kyc_details"]);
          dataTwo = List<Map<String, dynamic>>.from(responseData["kyc_details"]);
        } else {
          data = [];
          dataTwo = [];
        }
        loading.value = false;
      } else {
        loading.value = false;
        errorMessage.value = responseData['errorMsg']?.toString() ?? "Unknown error occurred";
      }
    } catch (e) {
      loading.value = false;
      errorMessage.value = "Something went wrong: ${e.toString()}";
      log("Error: $e");
    }
  }




  Future<void> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery); // or .gallery

    if (image != null) {
      if (kIsWeb) {
        personImage.value = await image.readAsBytes();
      } else {
        userImage.value = image.path;
      }
    }
  }



  Future<void> addProofFront() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery); // or .gallery

    if (image != null) {
      if (kIsWeb) {
        idImageFront.value = await image.readAsBytes();
      } else {
        frontId.value = image.path;
      }
    }
  }

  Future<void> addProofBack() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery); // or .gallery

    if (image != null) {
      if (kIsWeb) {
        backId.value = await image.readAsBytes();
      } else {
        backImage.value = image.path;
      }
    }
  }

  List runFilter(String enterKeyword) {
    if (enterKeyword.isEmpty) {
      data = List.from(dataTwo);
    } else {
      data = dataTwo.where((item) {
        String firstName = item['first_name']?.toString() ?? "";
        String medileName = item['middle_name']?.toString() ?? "";
        String lastName = item['last_name']?.toString() ?? "";
        String number = item['mobile_no']?.toString() ?? "";
        String kycCode = item['id']?.toString() ?? "";
        String date = item['creation_datetime']?.toString() ?? "";

        return firstName.toLowerCase().contains(enterKeyword.toLowerCase()) ||
            medileName.toLowerCase().contains(enterKeyword.toLowerCase()) ||
            lastName.toLowerCase().contains(enterKeyword.toLowerCase()) ||
            number.toLowerCase().contains(enterKeyword.toLowerCase()) ||
            kycCode.toLowerCase().contains(enterKeyword.toLowerCase()) ||
            date.toLowerCase().contains(enterKeyword.toLowerCase());
      }).toList();
    }
    return data;
  }
  Future<void> generatePdfFromWidget(GlobalKey globalKey) async {
    try {
      final boundary = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        return;
      }

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final imageBytes = byteData!.buffer.asUint8List();

      final pdf = pw.Document();
      final pdfImage = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: pw.PdfPageFormat.a4,
          build: (pw.Context context) => pw.Center(
            child: pw.Image(pdfImage),
          ),
        ),
      );

      await Printing.layoutPdf(
        onLayout: (pw.PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
    }
  }


  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.request();
      if (status.isGranted) return true;
      Get.snackbar("Permission Denied", "Storage permission is required to save files.");
      return false;
    }
    return true; // iOS/web doesn’t need storage permission
  }

  Future<void> exportToPdf(List<Map<String, dynamic>> transactions) async {
    if (!kIsWeb && !await _requestPermission()) return;

    try {
      isExportingPdf.value = true;

      final pdf = pw.Document();

      final logo = pw.MemoryImage(
        (await rootBundle.load("assets/images/mflogo.png")).buffer.asUint8List(),
      );

      pdf.addPage(
        pw.MultiPage(
          pageFormat: pw.PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          header: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(logo, width: 50, height: 50),
                  pw.Text("Pending Emi's Report",
                      style: pw.TextStyle(fontSize: 16)),
                  pw.Text(DateFormat("dd/MM/yyyy").format(DateTime.now()),
                      style: pw.TextStyle(fontSize: 12)),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Divider(),
            ],
          ),
          footer: (context) => pw.Center(
            child: pw.Text("Generated by Madhupuri Finance",
                style: pw.TextStyle(fontSize: 10)),
          ),
          build: (pw.Context context) => [
            pw.SizedBox(height: 20),

            pw.Table(
              columnWidths: {
                0: const pw.FixedColumnWidth(50),
                1: const pw.FixedColumnWidth(180),
                2: const pw.FixedColumnWidth(105),
                3: const pw.FixedColumnWidth(80),
                4: const pw.FixedColumnWidth(115),
                5: const pw.FixedColumnWidth(120),
                6: const pw.FixedColumnWidth(95),
              },
              border: pw.TableBorder.all(width: 0.5),
              children: [
                // Header Row
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Kyc\nID", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Name", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Mob. No.", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("ID\nProof", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("ID\nProof No.", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Address", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("Created\nDate", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                ),

                // Data Rows
                ...List.generate(transactions.length, (index) {
                  final row = transactions[index];
                  return pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['id'].toString(),style: pw.TextStyle(fontSize: 11))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text("${row['first_name']} ${row['middle_name']} ${row['last_name']}",style: pw.TextStyle(fontSize: 11))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['mobile_no'].toString(),style: pw.TextStyle(fontSize: 11))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['profile_id_type'].toString(),style: pw.TextStyle(fontSize: 11))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['profile_id_no'].toString(),style: pw.TextStyle(fontSize: 11))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(row['permanent_address'].toString(),style: pw.TextStyle(fontSize: 11))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(DateFormat("dd/MM/yyyy").format(DateTime.parse(row['creation_datetime'].toString(),),),style: pw.TextStyle(fontSize: 11)),),
                    ],
                  );
                }),
              ],
            ),
          ],
        ),
      );

      if (kIsWeb) {
        // ✅ Web: trigger file download
        final bytes = await pdf.save();
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", "KYC.pdf")
          ..click();
        html.Url.revokeObjectUrl(url);

        Get.snackbar("✅ Success", "PDF downloaded in browser");
      } else {
        // ✅ Android / iOS / Desktop
        Directory? downloadsDir;
        if (Platform.isAndroid) {
          downloadsDir = Directory("/storage/emulated/0/Download");
        } else {
          downloadsDir = await getApplicationDocumentsDirectory();
        }

        final file = File("${downloadsDir.path}/KYC.pdf");
        await file.writeAsBytes(await pdf.save());

        Get.snackbar("✅ Success", "PDF exported: ${file.path}");
      }
    } finally {
      isExportingPdf.value = false;
    }
  }
  Future<void> exportToExcel(List<Map<String, dynamic>> transactions) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['KYC'];

    sheetObject.appendRow([
      TextCellValue("Kyc ID"),
      TextCellValue("Name"),
      TextCellValue("Mob No"),
      TextCellValue("ID Proof"),
      TextCellValue("ID Proof No."),
      TextCellValue("Address"),
      TextCellValue("Created Date"),
    ]);

    for (var row in transactions) {
      sheetObject.appendRow([
        IntCellValue(int.tryParse(row['id'].toString()) ?? 0),
        TextCellValue("${row['first_name']} ${row['middle_name']} ${row['last_name']}"),
        TextCellValue(row['mobile_no'].toString()),
        TextCellValue("${row['profile_id_type']}"),
        TextCellValue(row['profile_id_no'].toString()),
        TextCellValue("${row['permanent_address']}"),
        TextCellValue(
          DateFormat("dd/MM/yyyy").format(
            DateTime.parse(row['creation_datetime'].toString()),
          ),
        ),
      ]);
    }

    if (kIsWeb) {
      // ✅ Web: trigger download in browser
      final bytes = excel.encode()!;
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "KYC.xlsx")
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      // ✅ Mobile/Desktop
      Directory? downloadsDir;
      if (Platform.isAndroid) {
        downloadsDir = Directory("/storage/emulated/0/Download");
      } else {
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      final file = File("${downloadsDir.path}/KYC.xlsx");
      await file.writeAsBytes(excel.encode()!);

      print("✅ Kyc exported: ${file.path}");
    }
  }
}

