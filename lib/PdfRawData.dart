import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:madhupurifinance/Controller/FormController.dart';
import 'package:madhupurifinance/Controller/KycListController.dart';
import 'package:madhupurifinance/Controller/LoginController.dart';
import 'package:madhupurifinance/Controller/loansController.dart';
import 'package:pdf/pdf.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'Utils.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/widgets.dart' as pw;
class PdfRawData{


  late final Map<String, dynamic> data;
  final String gujaratiText = '''
પ્રતિ
પ્રબંધક
મધુપુરી ફાઇનાન્સ
ભાવનગર શાખા

મહોદય/મહોદયા,

હું/અમે ...................(હવે પછી આ દસ્તાવેજમાં દેણદાર તરીકે દર્શાવેલા) આપને રૂ .................. (રૂપિયા શબ્દોમાં .......................................................................નું કરજ) .......... ગ્રામ (સંપૂર્ણ વજન) ના સોનાના આભુષણો/ચેક/ચીજવસ્તુઓ (હવે પછી આ દસ્તાવેજમાં સોના તરીકે દર્શાવેલા) આ સાથે રજુ કરીએ છીએ જેની વિગતો અલગ રીતે દર્શાવેલ છે.

તેની અવેજમાં કરજ આપવા અરજ કરીએ છીએ કે, કરજદાર નીચે જણાવ્યા પ્રમાણેના દસ્તાવેજો કે જે મધુપુરી ફાઇનાન્સ કંપનીના ધારા/નિયમો પ્રમાણે જરૂરી છે તે રજુ કરેલ છે.

હું/અમે વચન આપીએ છીએ કે, જયારે માગણી કરવામાં આવશે ત્યારે મધુપુરી ફાઇનાન્સ અથવા તેના હુકમ મુજબ ભાવનગર શાખા/ઓફિસ/તે જગ્યાએ રૂ .......................% પ્રતિ વર્ષ વ્યાજ સાથે રૂ ........................... ચૂકવીશું.
''';
  getFormNo(){
    return "1";
  }
  getBytes(imageUrl)async {
    try{
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        final Uint8List imageBytes = response.bodyBytes;
        return pw.MemoryImage(imageBytes);
      }
    }catch(_){}
    return null;
  }

  generatePDF(content)async{
    final FormController formController = Get.put(FormController());
    final KycListController kycListController = Get.put(KycListController());
    ByteData byteData = await rootBundle.load("assets/images/NewPdfForm1.png");
    final image = pw.MemoryImage(byteData.buffer.asUint8List());
    String formNo = content==null?getFormNo():"";
    final pdf = pw.Document();

    final profileImage = content==null?null:await getBytes(content['profile_img']);
    final forntImage = content==null?null:await getBytes(content['profile_id_img']);
    final backImage = content==null?null:await getBytes(content['profile_id_img_back']);
    await formController.getDocument("photo_id");
    List<dynamic> proofDocs = await formController.getDocument("photo_id");
    print("dev jhsfksdhksjdghkjdfg");
    print("$proofDocs");

    String address = content==null?"":content['permanent_address'];
    String residentical = content==null?"":content['residentical_address'];
    List<String> parts = content==null?[]:address.split(',').where((e) => e.trim().isNotEmpty).toList();
    List<String> residenticalAdd = content==null?[]:residentical.split(',').where((e) => e.trim().isNotEmpty).toList();
    String addressLine1 = content==null?"":parts.length > 0 ? parts[0] : '';
    String addressLine2 = content==null?"":parts.length > 1 ? parts[1] : '';
    String pinCode = content==null?"":parts.length > 2 ? parts[2] : '';
    String area = content==null?"":parts.length > 3 ? parts[3] : '';
    String district = content==null?"":parts.length > 4 ? parts[4] : '';
    String state = content==null?"":parts.length > 5 ? parts[5] : '';

    String AddressLine1 = content==null?"":residenticalAdd.length > 0 ? residenticalAdd[0] : '';
    String AddressLine2 = content==null?"":residenticalAdd.length > 1 ? residenticalAdd[1] : '';
    String Pincode = content==null?"":residenticalAdd.length > 2 ? residenticalAdd[2] : '';
    String Area = content==null?"":residenticalAdd.length > 3 ? residenticalAdd[3] : '';
    String District = content==null?"":residenticalAdd.length > 4 ? residenticalAdd[4] : '';
    String State = content==null?"":residenticalAdd.length > 5 ? residenticalAdd[5] : '';

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
              pw.Positioned(
                left: 450,
                top: 12,
                child: pw.Container(
                  width: 270,
                  child:  pw.Text(kycListController.formNo.toString(),style: pw.TextStyle(color: PdfColor.fromInt(0xff222744),fontSize: 11)),
                ),
              ),
              pw.Positioned(
                right: 700,
                left: 0,
                  child: pw.Container(
                height: 674,
                width: 10 ,
                color: PdfColor.fromInt(0xff222744),
              )),
              pw.Positioned(
                  right: 0,
                  child: pw.Container(
                    height: 674,
                    width: 0.2,
                    color: PdfColor.fromInt(0xff222744),
                  )),
              pw.Positioned(
                left: 448,
                top: 30,
                child: pw.Container(
                  width: 270,
                  child:  pw.Text(content==null?"":content['id'].toString(),style: pw.TextStyle(color: PdfColor.fromInt(0xff222744),fontSize: 11)),),
              ),
              pw.Positioned(
                left: 380,
                top: 115,
                child: pw.Container(
                  width: 75,
                  height: 100,
                  child:  profileImage==null?pw.Container():pw.Image(profileImage),
              ),
              ),
              pw.Positioned(
                left: 105,
                top: 123,
                child: pw.Container(
                  width: 283,
                  child: pw.Row(
                    children: [
                      pw.Text(content==null?"":content['first_name'].toString(),style: pw.TextStyle(color: PdfColor.fromInt(0xff222744),fontSize: 9,)),
                      pw.SizedBox(width: 4),
                      pw.Text(content==null?"":content['middle_name'].toString(),style: pw.TextStyle(color: PdfColor.fromInt(0xff222744),fontSize: 9,)),
                      pw.SizedBox(width: 4),
                      pw.Text(content==null?"":content['last_name'].toString(),style: pw.TextStyle(color: PdfColor.fromInt(0xff222744),fontSize: 9,)),
                    ]
                  )
                ),
                ),
              pw.Positioned(
                left: 110,
                top: 142,
                child: pw.Container(
                  width: 270,
                  child:  pw.Text(content==null?"":content['mobile_no'].toString(),style: pw.TextStyle(color: PdfColor.fromInt(0xff222744),fontSize: 9,)),),
                ),
              pw.Positioned(
                left: 139,
                top: 161,
                child: pw.Container(
                  width: 230,
                  child: pw.Text(content==null?"":content['reference_name'].toString(),style: pw.TextStyle(color: PdfColor.fromInt(0xff222744),fontSize: 9,)),),
                ),
              pw.Positioned(
                left: 175,
                top: 180,
                child: pw.Container(
                  width: 200,
                  child: pw.Text( content==null?"":content['reference_contact_no'].toString(),style: pw.TextStyle(color: PdfColor.fromInt(0xff222744),fontSize: 9,)),),
                ),
              pw.Positioned(
                left: 215,
                top: 142,
                child: pw.Container(
                  width: 210,
                  child: pw.Text(content==null?"":content['secondary_mobile_no'].toString(),style: pw.TextStyle(color: PdfColor.fromInt(0xff222744),fontSize: 9,)),),
                ),
              pw.Positioned(
                left: 45,
                top: 229,
                child: pw.Container(
                  width: 65,
                  child: pw.Text(content==null?"":content['bank_name'].toString(),style: pw.TextStyle(color: PdfColor.fromInt(0xff222744),fontSize: 9,)),),
                ),
              pw.Positioned(
                left: 182,
                top: 229,
                child: pw.Container(
                  width: 115,
                  child: pw.Text(content==null?"":content['bank_acc_no'].toString(),style: pw.TextStyle(color: PdfColor.fromInt(0xff222744),fontSize: 9,)),),
                ),
              pw.Positioned(
                left: 349,
                top: 229,
                child: pw.Container(
                  width: 115,
                  child: pw.Text(content==null?"":content['bank_ifsc_code'].toString(),style: pw.TextStyle(color: PdfColor.fromInt(0xff222744),fontSize: 9,)),),
                ),
              pw.Positioned(
                left: 87,
                top: 289,
                child: pw.Container(
                  width: 400,
                  child: pw.Row(
                    children: [
                      pw.Text(content==null?"":addressLine1,style: pw.TextStyle(color: PdfColor.fromInt(0xff222744),fontSize: 9,)),
                      pw.SizedBox(width: 5),
                      pw.Text(content==null?"":addressLine2,style: pw.TextStyle(color: PdfColor.fromInt(0xff222744),fontSize: 9,)),
                    ]
                  )),
                ),
              pw.Positioned(
                left: 63,
                top: 308,
                child: pw.Container(
                  width: 60,
                  child: pw.Text(content==null?"":pinCode,style: pw.TextStyle(color: PdfColor.fromInt(0xff222744),fontSize: 9,)),),
              ),
              pw.Positioned(
                left: 169,
                top: 308,
                child: pw.Container(
                  width: 65,
          child:  pw.Text(content==null?"":district,style: pw.TextStyle(color: PdfColor.fromInt(0xff222744),fontSize: 9,)),)),
              pw.Positioned(
                left: 278,
                top: 308,
                child: pw.Container(
                  width: 45,
                  child: pw.Text(content==null?"":state,style: pw.TextStyle(color: PdfColor.fromInt(0xff222744),fontSize: 9,)),),
                ),
              pw.Positioned(
                left: 390,
                top: 308,
                child: pw.Container(
                  width: 200,
                  child: pw.Text(content==null?"":area,style: pw.TextStyle(color: PdfColor.fromInt(0xff222744),fontSize: 9,)),),
              ),
              pw.Positioned(
                left: 88,
                top: 347,
                child: pw.Container(
                  width: 400,
                  child: pw.Row(
                    children: [
                      pw.Text(content==null?"":AddressLine1,style: pw.TextStyle(color: PdfColor.fromInt(0xff222744),fontSize: 9,)),
                      pw.SizedBox(width: 5),
                      pw.Text(content==null?"":AddressLine2,style: pw.TextStyle(color: PdfColor.fromInt(0xff222744),fontSize: 9,))
                    ]
                  ),),
                ),
              pw.Positioned(
                left: 64,
                top: 366,
                child: pw.Container(
                  width: 55,
                  child: pw.Text(content==null?"":Pincode,style: pw.TextStyle(color: PdfColor.fromInt(0xff222744),fontSize: 9,)),),
              ),
              pw.Positioned(
                left: 170,
                top: 366,
                child: pw.Container(
                  width: 65,
                  child: pw.Text(content==null?"":District,style: pw.TextStyle(color: PdfColor.fromInt(0xff222744),fontSize: 9,)),),
                ),
              pw.Positioned(
                left: 280,
                top: 366,
                child: pw.Container(
                  width: 45,
                  child:  pw.Text(content==null?"":State,style: pw.TextStyle(color: PdfColor.fromInt(0xff222744),fontSize: 9,)),),
                ),
              pw.Positioned(
                left: 392,
                top: 366,
                child: pw.Container(
                  width: 200,
                  child: pw.Text(content==null?"":Area,style: pw.TextStyle(color: PdfColor.fromInt(0xff222744),fontSize: 9)),),
              ),
              pw.Positioned(
                top: 405,
                child:pw.SizedBox(
                height: 30,
                child:  pw.ListView.builder(
                  direction: pw.Axis.horizontal,
                    itemBuilder: (context, index) {
                  return pw.Row(
                      children: [
                        pw.SizedBox(width: 5),
                        pw.Container(
                          height: 10,
                          width: 10,
                          padding: pw.EdgeInsets.all(2),
                          decoration: pw.BoxDecoration(
                            color: content==null?PdfColors.white:(content['profile_id_type'].toString().toUpperCase()==formController.documentsID[index]['name'].toString().toUpperCase()?PdfColors.black:PdfColors.white),
                            border: pw.Border.all(
                              color: PdfColors.black,
                            )
                          ),
                        ),
                        pw.SizedBox(width: 2),
                        pw.Text(formController.documentsID[index]['name'].toString(),
                            style: pw.TextStyle(
                                color: PdfColor.fromInt(0xff222744),
                            fontSize: 9,
                            )),
                      ]
                  );
                }, itemCount: formController.documentsID.length),
              ),),
              pw.Positioned(
                  left: 4,
                  top: 435,
                  child: pw.Text(content==null?"":content["profile_id_no"].toString(),style: pw.TextStyle(
                color: PdfColor.fromInt(0xff222744),fontSize: 9,
              ))),
              pw.Positioned(
                top: 445,
                left: 4,
                child: pw.SizedBox(
                  width: 200,
                  child: pw.Divider(
                    height: 1,
                    color: PdfColor.fromInt(0xff222744),
                  ),
                )
              ),
              pw.Positioned(
                top: 450,
                  left: 70,
                  child:pw.Row(
                  children: [
                    pw.Container(
                      height:70,
                      width: 180,
                      color: PdfColors.grey200,
                      child: forntImage==null?pw.Container():pw.Image(forntImage),
                    ),
                    pw.SizedBox(width: 10),
                    pw.Container(
                      height:70,
                      width: 180,
                      color: PdfColors.grey200,
                      child: backImage==null?pw.Container():pw.Image(backImage),
                    ),
                  ]
              )),
            ],
          );
        },
      ),
    );


    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
  Widget printForm(formNo,content){

    return Container(
      width: PdfPageFormat.a4.width,
      height: PdfPageFormat.a4.height,
      color: Colors.white,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.asset("assets/images/mflogo.png",width: 75,height: 75,),
                    // child:  Image(image, width: 75, height: 75),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: SizedBox(
                          width: 397,
                          // color: Utils().text.fromHex('332A60'),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    children: [
                                      Text("Reg.No.GML/04/Bhavnagar/188/2022",style: TextStyle(
                                          fontSize: 12,
                                          color: Utils().text,
                                          fontWeight: FontWeight.bold
                                      )),
                                      SizedBox(width: 85),
                                      Text("Form NO. :",style: TextStyle(
                                          fontSize: 12,
                                          color: Utils().text
                                      )),
                                    ]
                                ),
                                Row(
                                    children: [
                                      Text("Reg. Office : ",style: TextStyle(
                                          fontSize: 12,
                                          color: Utils().text,
                                          fontWeight: FontWeight.bold
                                      )),
                                      SizedBox(width: 10),
                                      Text("353, MADHAV DARSHAN, WAGHAWADI ROAD,\nBHAVNAGAR - 364001. ( GUJ.) INDIA.",style: TextStyle(
                                        fontSize: 9,
                                        color: Utils().text,
                                      ),maxLines: 2),
                                      SizedBox(width: 22),
                                      Text("KYC NO. : ",style: TextStyle(
                                          fontSize: 12,
                                          color: Utils().text
                                      )),
                                    ]
                                ),
                                Row(
                                    children: [
                                      Text("MOBILE NO :",style: TextStyle(
                                          fontSize: 12,
                                          color: Utils().text,
                                          fontWeight: FontWeight.bold
                                      )),
                                      SizedBox(width: 10),
                                      Text("+91 90547 45400",style: TextStyle(
                                          fontSize: 9,
                                          color: Utils().text
                                      ),),
                                    ]
                                ),
                                Text("નમૂના નંબર ૧૧ ( જુઓ નિયમ ૧૪ )",style: TextStyle(
                                  fontSize: 12,
                                  // font: semiBold,
                                  color: Utils().text,
                                  fontWeight: FontWeight.bold,
                                )),
                              ]
                          )
                      )
                  )
                ]
            ),
            Container(
                height: 5,
                width: 700,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Utils().text
                )
            ),
            SizedBox(height: 10),
            Text("User Information (ગ્રાહકની માહિતી)",style: TextStyle(
                fontWeight: FontWeight.bold,
                // font: Baloo,
                color: Utils().text,
                fontSize: 12
            )),
            Divider(
                height: 1.5,
                color: Utils().text
            ),
            Row(
                children: [
                  SizedBox(
                      width: 460,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                children: [
                                  Text("Full Name (ગ્રાહકનું નામ) : ",style: TextStyle(
                                    // font: regular,
                                    color: Utils().text,
                                    fontSize: 9,
                                  )),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          height: 1,
                                          color: Colors.black,
                                        )
                                      ],
                                    ),
                                  ),
                                ]
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text("Mobile Number(મોબાઈલ નંબર) : ",style: TextStyle(
                                  // font: regular,
                                  color: Utils().text,
                                  fontSize: 9,
                                )),
                                Expanded(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Divider(
                                        height: 1,
                                        color: Colors.black,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text("Reference Name (રેફરેન્સ આપનારનું નામ)  : ",style: TextStyle(
                                  // font: regular,
                                  color: Utils().text,
                                  fontSize: 9,
                                )),
                                Expanded(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Divider(
                                        height: 1,
                                        color: Colors.black,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text("Reference mobile no. ( રેફરેન્સ આપનારનો મોબાઈલ નં.) : ",style: TextStyle(
                                  // font: regular,
                                  color: Utils().text,
                                  fontSize: 9,
                                )),
                                Expanded(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Divider(
                                        height: 1,
                                        color: Colors.black,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text("secondary mobile number (સેકેંડરી મોબાઈલ નં.) : ",style: TextStyle(
                                  // font: regular,
                                  color: Utils().text,
                                  fontSize: 9,
                                )),
                                Expanded(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Divider(
                                        height: 1,
                                        color: Colors.black,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ]
                      )
                  ),
                  SizedBox(width: 10),
                  Padding(padding: EdgeInsets.only(top: 5,bottom: 5),
                    child:   Container(
                      width: 94,
                      height: 113,
                      color: Colors.grey.shade200,
                      child: Center(child: Icon(Icons.person,color: Colors.white,)),
                    ),
                  ),
                ]
            ),
            Text("Bank details",style: TextStyle(
                color: Utils().text,
                fontSize: 12,
                fontWeight: FontWeight.bold
            ),),
            Divider(
              height: 1.5,
              color: Utils().text,
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Row(
                  children: [
                    Text("Bank name",style: TextStyle( color: Utils().text,
                      fontSize: 9,),),
                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 90,
                          child: Divider(
                            height: 1,
                            color: Utils().text,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(width: 5,),
                Row(
                  children: [
                    Text("Bank Acc number",style: TextStyle( color: Utils().text,
                      fontSize: 9,),),
                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 150,
                          child: Divider(
                            height: 1,
                            color: Utils().text,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(width: 5,),
                Row(
                  children: [
                    Text("IFSC code",style: TextStyle( color: Utils().text,
                      fontSize: 9,),),
                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 150,
                          child: Divider(
                            height: 1,
                            color: Utils().text,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 10,),
            Text("Address Information (એડ્રેસની માહિતી)",style: TextStyle(
              // font: gujarati,
                color: Utils().text,
                fontSize: 12,
                fontWeight: FontWeight.bold
            )),
            Divider(
              height: 1.5,
              color: Utils().text,
            ),
            SizedBox(height: 10),
            Text("Permanent Address (કાયમી સરનામું) ",style: TextStyle(
                fontWeight: FontWeight.bold,
                // font: gujarati,
                color: Utils().text,
                fontSize: 12
            )),
            SizedBox(height: 10),
            Row(
                children: [
                  Text("Address ( ગ્રાહકનું સરનામું) : ",style: TextStyle(
                    // font: regular,
                    color: Utils().text,
                    fontSize: 9,
                  )),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          height: 1,
                          color: Utils().text,
                        ),
                      ],
                    ),
                  )
                ]
            ),
            SizedBox(height: 20),
            Row(
                children: [
                  Row(
                    children: [
                      Text("Area (વિસ્તાર) : ",style: TextStyle(
                        // font: regular,
                        color: Utils().text,
                        fontSize: 9,
                      )),
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 80,
                            child: Divider(
                              height: 1,
                              color: Utils().text,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text("District (જિલ્લો) : ",style: TextStyle(
                        // font: regular,
                        color: Utils().text,
                        fontSize: 9,
                      )),
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 70,
                            child: Divider(
                              height: 1,
                              color: Utils().text,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text("State (રાજ્ય) : ",style: TextStyle(
                        // font: regular,
                        color: Utils().text,
                        fontSize: 9,
                      )),
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 70,
                            child: Divider(
                              height: 1,
                              color: Utils().text,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text("Pincode (પિન કોડ) : ",style: TextStyle(
                        // font: regular,
                        color: Utils().text,
                        fontSize: 9,
                      )),
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 70,
                            child: Divider(
                              height: 1,
                              color: Utils().text,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ]
            ),
            SizedBox(height: 15),
            Text("Residencial Address (રહેઠાણનું સરનામું)",style: TextStyle(
                fontWeight: FontWeight.bold,
                // font: gujarati,
                color: Utils().text,
                fontSize: 12
            )),
            SizedBox(height: 10),
            Row(
                children: [
                  Text("Address ( ગ્રાહકનું સરનામું) : ",style: TextStyle(
                    // font: regular,
                    color: Utils().text,
                    fontSize: 9,
                  )),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          height: 1,
                          color: Utils().text,
                        ),
                      ],
                    ),
                  )
                ]
            ),
            SizedBox(height: 20),
            Row(
                children: [
                  Row(
                    children: [
                      Text("Area (વિસ્તાર) : ",style: TextStyle(
                        // font: regular,
                        color: Utils().text,
                        fontSize: 9,
                      )),
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 80,
                            child: Divider(
                              height: 1,
                              color: Utils().text,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text("District (જિલ્લો) : ",style: TextStyle(
                        // font: regular,
                        color: Utils().text,
                        fontSize: 9,
                      )),
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 70,
                            child: Divider(
                              height: 1,
                              color: Utils().text,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text("State (રાજ્ય) : ",style: TextStyle(
                        // font: regular,
                        color: Utils().text,
                        fontSize: 9,
                      )),
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 70,
                            child: Divider(
                              height: 1,
                              color: Utils().text,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text("Pincode (પિન કોડ) : ",style: TextStyle(
                        // font: regular,
                        color: Utils().text,
                        fontSize: 9,
                      )),
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 70,
                            child: Divider(
                              height: 1,
                              color: Utils().text,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ]
            ),
            SizedBox(height: 10),
            Text("ID PROOF Information (Id પુરાવાની માહિતી)",
                style: TextStyle(
                  color: Utils().text,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 8),
            Divider(
              height: 1.5,
              color: Utils().text,
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 20,
              width: PdfPageFormat.a4.width,
              // child: ListView.builder(
              //   scrollDirection: Axis.horizontal,
              //   itemCount: formController.documentsID.length+1,
              //   itemBuilder: (context, index) {
              //     return index==formController.documentsID.length?
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         SizedBox(
              //           height: 18,
              //         ),
              //         SizedBox(
              //           width : MediaQuery.of(context).size.width,
              //           child: Divider(
              //             height: 1,
              //             color: Utils().text,
              //           ),
              //         ),
              //       ],
              //     ):
              //     Row(
              //       children: [
              //         Icon(Icons.check_box_outline_blank,size: 9,),
              //         Text(formController.documentsID[index]['name'].toString(),  // Default text when null
              //           style: TextStyle(
              //             color: Utils().text,
              //             fontSize: 9,
              //           ),
              //         ),
              //         SizedBox(width: 9,),
              //       ],
              //     );
              //   },),
            ),
            SizedBox(height: 10),
            Text("Information (માહિતી)",style: TextStyle(
              // font: gujarati,
                color: Utils().text,
                fontSize: 12,
                fontWeight: FontWeight.bold
            )),
            SizedBox(height: 10),
            Divider(
                height: 1.5,
                color: Utils().text
            ),
            SizedBox(height: 20),
            Container(
                width: 700,
                child:Text('''પ્રતિ પ્રબંધક મધુપુરી ફાઇનાન્સ ભાવનગર શાખા મહોદય/મહોદયા હું/અમે.. ...................(હવે પછી આ દસ્તાવેજમાં દેણદાર તરીકે દર્શાવેલા) આપને રૂા..............(રૂપિયા શબ્દોમાં.......................................................................નું કરજ..........ગ્રામ (સંપૂર્ણ વજન) ના સોનાના આભુષણો/ચેક/ચીજવસ્તુઓ (હવે પછીઆ દસ્તાવેજમાં સોના તરીકે દર્શાવેલા) આ સાથે રજુ કરીએ છીએ જેની વિગતો અલગ રીતે દર્શાવેલ છે. તેની અવેજમાં કરજ આપવા અરજ કરીએ છીએ કે, કરજદાર નીચે જણાવ્યા પ્રમાણેના દસ્તાવેજો કે જે મધુપુરી ફાઇનાન્સ કંપની ધારા/નિયમો પ્રમાણે જરૂરી છે એ રજુ કરેલ છે.
                      હું/અમે વચન આપીએ છીએ કે, જયારે માગણી કરવામાં આવશે ત્યારે મધુપુરી ફાઇનાન્સ અથવા તેના હુકમ પ્રમાણે ભાવનગર શાખા/ઓફીસ/તે જગ્યાએ રૂ।.......................% પ્રતિ વર્ષ વ્યાજ સાથે રૂ।...........................ચુકવીશું.''',
                    style: TextStyle(
                      // font: Baloo,
                        color: Utils().text,
                        fontSize: 9
                    ),
                    textAlign: TextAlign.justify
                )
            ),
            SizedBox(
              height: 30 ,
            ),
            Row(
                children: [
                  SizedBox(width: 450,),
                  Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.5,
                              color: Utils().text
                          )
                      ),
                      child: Center(
                          child: Text("1Rs.",style: TextStyle(
                            // font: regular,
                              color: Utils().text,
                              fontSize: 10
                          ))
                      )
                  )
                ]
            ),
            Row(
                children: [
                  Text("Owner Signature (માલિકની સહી)",style: TextStyle(
                    // font: regular,
                      color: Utils().text,
                      fontSize: 9
                  )),
                  SizedBox(width: 180),
                  Text("Customer Signature (ગ્રાહકની સહી)",style: TextStyle(
                    // font: regular,
                      color: Utils().text,
                      fontSize: 9
                  )),
                ]
            )
          ]
      ),
    );
  }
  Future<Uint8List?> captureWidgetAsImage(Widget widget, {double pixelRatio = 3.0}) async {
    final repaintBoundary = RenderRepaintBoundary();

    // Create an offscreen widget tree with MediaQuery and Directionality
    final wrappedWidget = Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(size: Size(1080, 1920)), // Adjust if needed
        child: RepaintBoundary(child: widget),
      ),
    );

    final renderAdapter = RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: wrappedWidget,
    );

    final buildOwner = BuildOwner(focusManager: FocusManager());
    final rootElement = renderAdapter.attachToRenderTree(buildOwner);

    // Do manual layout/rendering
    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    final pipelineOwner = PipelineOwner();
    pipelineOwner.rootNode = RenderView(
      view: PlatformDispatcher.instance.views.first,
      configuration: const ViewConfiguration(

      ),
      child: repaintBoundary,
    );

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    // Wait a frame to ensure rendering finishes
    await Future.delayed(const Duration(milliseconds: 50));

    final image = await repaintBoundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

}