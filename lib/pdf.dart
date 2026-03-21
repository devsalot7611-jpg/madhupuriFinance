import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:madhupurifinance/Controller/FormController.dart';
import 'package:madhupurifinance/Utils.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import 'PdfRawData.dart';



class Pdf extends StatefulWidget {
  const Pdf({super.key});

  @override
  State<Pdf> createState() => _PdfState();
}

class _PdfState extends State<Pdf> {
  @override
  Widget build(BuildContext context) {
    return pdfWidget();
  }
}
 generatePdf() async {
      final FormController formController = Get.put(FormController());
    final GlobalKey globalKey = GlobalKey();
    Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: RepaintBoundary(
              key: globalKey,
              child: Container(
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
                                                SizedBox(width: 10),
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
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: formController.documentsID.length+1,
                          itemBuilder: (context, index) {
                            return index==formController.documentsID.length?
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 18,
                                ),
                                SizedBox(
                                  width : MediaQuery.of(context).size.width,
                                  child: Divider(
                                    height: 1,
                                    color: Utils().text,
                                  ),
                                ),
                              ],
                            ):
                            Row(
                              children: [
                                Icon(Icons.check_box_outline_blank,size: 9,),
                                Text(formController.documentsID[index]['name'].toString(),  // Default text when null
                                  style: TextStyle(
                                    color: Utils().text,
                                    fontSize: 9,
                                  ),
                                ),
                                SizedBox(width: 9,),
                              ],
                            );
                          },),
                      ),
                      SizedBox(height: 10),
                      // Text("Information (માહિતી)",style: TextStyle(
                      //   // font: gujarati,
                      //     color: Utils().text,
                      //     fontSize: 12,
                      //     fontWeight: FontWeight.bold
                      // )),
                      SizedBox(height: 10),
                      Divider(
                          height: 1.5,
                          color: Utils().text
                      ),
                      SizedBox(height: 20),
                      // Container(
                      //     width: 700,
                      //     child:Text('''પ્રતિ પ્રબંધક મધુપુરી ફાઇનાન્સ ભાવનગર શાખા મહોદય/મહોદયા હું/અમે.. ...................(હવે પછી આ દસ્તાવેજમાં દેણદાર તરીકે દર્શાવેલા) આપને રૂા..............(રૂપિયા શબ્દોમાં.......................................................................નું કરજ..........ગ્રામ (સંપૂર્ણ વજન) ના સોનાના આભુષણો/ચેક/ચીજવસ્તુઓ (હવે પછીઆ દસ્તાવેજમાં સોના તરીકે દર્શાવેલા) આ સાથે રજુ કરીએ છીએ જેની વિગતો અલગ રીતે દર્શાવેલ છે. તેની અવેજમાં કરજ આપવા અરજ કરીએ છીએ કે, કરજદાર નીચે જણાવ્યા પ્રમાણેના દસ્તાવેજો કે જે મધુપુરી ફાઇનાન્સ કંપની ધારા/નિયમો પ્રમાણે જરૂરી છે એ રજુ કરેલ છે.
                      // હું/અમે વચન આપીએ છીએ કે, જયારે માગણી કરવામાં આવશે ત્યારે મધુપુરી ફાઇનાન્સ અથવા તેના હુકમ પ્રમાણે ભાવનગર શાખા/ઓફીસ/તે જગ્યાએ રૂ।.......................% પ્રતિ વર્ષ વ્યાજ સાથે રૂ।...........................ચુકવીશું.''',
                      //         style: TextStyle(
                      //           // font: Baloo,
                      //             color: Utils().text,
                      //             fontSize: 9
                      //         ),
                      //         textAlign: TextAlign.justify
                      //     )
                      // ),
                      SizedBox(
                        height: 50,
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
              ),
            ),
          ),
        )
    );
      print("object 2");
      print("${globalKey.currentState ==null}");
    RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      print("object 22");
    ui.Image image2 = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image2.toByteData(format: ui.ImageByteFormat.png);
    final imageBytes =
     byteData?.buffer.asUint8List();
      print("object 3");

    final pdf = pw.Document();
    // final image = pw.MemoryImage(imageBytes);

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

Widget pdfWidget() {
  bool isloader = false;
  GlobalKey<FormState> globalKey = GlobalKey();
  final FormController formController = Get.put(FormController());
  return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Utils().background,
        title: Text('PDF Generator'),
        actions: [
          IconButton(onPressed: (){
            generatePdf();
            print("pdf download");
              isloader == true;
          }, icon: isloader?CircularProgressIndicator():Icon(Icons.download))
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: RepaintBoundary(
            key: globalKey,
            child: Container(
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
                                              SizedBox(width: 10),
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
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: formController.documentsID.length+1,
                        itemBuilder: (context, index) {
                          return index==formController.documentsID.length?
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 18,
                              ),
                              SizedBox(
                                width : MediaQuery.of(context).size.width,
                                child: Divider(
                                  height: 1,
                                  color: Utils().text,
                                ),
                              ),
                            ],
                          ):
                          Row(
                            children: [
                              Icon(Icons.check_box_outline_blank,size: 9,),
                              Text(formController.documentsID[index]['name'].toString(),  // Default text when null
                                style: TextStyle(
                                  color: Utils().text,
                                  fontSize: 9,
                                ),
                              ),
                              SizedBox(width: 9,),
                            ],
                          );
                        },),
                    ),
                    SizedBox(height: 10),
                    // Text("Information (માહિતી)",style: TextStyle(
                    //   // font: gujarati,
                    //     color: Utils().text,
                    //     fontSize: 12,
                    //     fontWeight: FontWeight.bold
                    // )),
                    SizedBox(height: 10),
                    // Divider(
                    //     height: 1.5,
                    //     color: Utils().text
                    // ),
                    SizedBox(height: 20),
                    // Container(
                    //     width: 700,
                    //     child:Text('''પ્રતિ પ્રબંધક મધુપુરી ફાઇનાન્સ ભાવનગર શાખા મહોદય/મહોદયા હું/અમે.. ...................(હવે પછી આ દસ્તાવેજમાં દેણદાર તરીકે દર્શાવેલા) આપને રૂા..............(રૂપિયા શબ્દોમાં.......................................................................નું કરજ..........ગ્રામ (સંપૂર્ણ વજન) ના સોનાના આભુષણો/ચેક/ચીજવસ્તુઓ (હવે પછીઆ દસ્તાવેજમાં સોના તરીકે દર્શાવેલા) આ સાથે રજુ કરીએ છીએ જેની વિગતો અલગ રીતે દર્શાવેલ છે. તેની અવેજમાં કરજ આપવા અરજ કરીએ છીએ કે, કરજદાર નીચે જણાવ્યા પ્રમાણેના દસ્તાવેજો કે જે મધુપુરી ફાઇનાન્સ કંપની ધારા/નિયમો પ્રમાણે જરૂરી છે એ રજુ કરેલ છે.
                    //   હું/અમે વચન આપીએ છીએ કે, જયારે માગણી કરવામાં આવશે ત્યારે મધુપુરી ફાઇનાન્સ અથવા તેના હુકમ પ્રમાણે ભાવનગર શાખા/ઓફીસ/તે જગ્યાએ રૂ।.......................% પ્રતિ વર્ષ વ્યાજ સાથે રૂ।...........................ચુકવીશું.''',
                    //         style: TextStyle(
                    //           // font: Baloo,
                    //             color: Utils().text,
                    //             fontSize: 9
                    //         ),
                    //         textAlign: TextAlign.justify
                    //     )
                    // ),
                    SizedBox(
                      height: 80,
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
            ),
          ),
        ),
      )
  );
}
