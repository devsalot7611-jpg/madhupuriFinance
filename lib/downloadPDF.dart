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
import 'dart:html' as html;
class Downloadpdf extends StatefulWidget {
  Downloadpdf({Key? key,}) : super(key: key);
  @override
  State<Downloadpdf> createState() => DownloadpdfState();
}

class DownloadpdfState extends State<Downloadpdf> {
  final TextEditingController _textController = TextEditingController();
  final GlobalKey _globalKey = GlobalKey();
  final FormController formController = Get.put(FormController());

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

  Future<Uint8List> _capturePng() async {
    RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final blob = html.Blob([pngBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "screenshot.png")
        ..click();
      html.Url.revokeObjectUrl(url); // Clean up the URL
    }
    return byteData!.buffer.asUint8List();
  }

  bool isloader = false;

  Future<void> generatePdf() async {
    setState(() {
      isloader = true;
    });

    final imageBytes = await _capturePng();

    final pdf = pw.Document();
    final image = pw.MemoryImage(imageBytes);

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

    setState(() {
      isloader = false;
    });
  }
  List<dynamic> photoIdDoc = [];
  @override
  void initState() {
    super.initState();
    loadDocuments();
    // widget.IDproof['name'];
    // print("djfsjdhfjhfdsjdfsdf ${widget.IDproof}");
    print("jhgasdjhgsdjagshdjahsgdajsghd ${formController.documentsID}");
  }

  void loadDocuments() async {
    photoIdDoc = await formController.getDocument("photo_id");
    setState(() {}); // Refresh UI after data is loaded

  }
  // late String addressLine1;
  // late String addressLine2;
  // late String pinCode;
  // late String area;
  // late String district;
  // late String state;
  //
  //
  //
  // late String AddressLine1;
  // late String AddressLine2;
  // late String Pincode;
  // late String Area;
  // late String District;
  // late String State;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Utils().background,
          title: Text('PDF Generator'),
          actions: [
            IconButton(onPressed: (){
              print("pdf download");
              generatePdf();
              setState(() {
                isloader == true;
              });
            }, icon: isloader?CircularProgressIndicator():Icon(Icons.download))
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: RepaintBoundary(
              key: _globalKey,
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
                      SizedBox(height: 6),
                      Text("Permanent Address (કાયમી સરનામું) ",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          // font: gujarati,
                          color: Utils().text,
                          fontSize: 12
                      )),
                      SizedBox(height: 6),
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
                      SizedBox(height: 10),
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
                      Text("Residencial Address (રહેઠાણનું સરનામું)",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          // font: gujarati,
                          color: Utils().text,
                          fontSize: 12
                      )),
                      SizedBox(height: 6),
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
                      SizedBox(height: 10),
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
                        height: 120,
                      ),
                      SizedBox(height: 10),
                      // Text("Information (માહિતી)",style: TextStyle(
                      //   // font: gujarati,
                      //     color: Utils().text,
                      //     fontSize: 12,
                      //     fontWeight: FontWeight.bold
                      // )),
                      SizedBox(height: 6),
                      // Divider(
                      //     height: 1.5,
                      //     color: Utils().text
                      // ),
                      SizedBox(height: 6),
                      Container(
                          width: 700,
                      //     child:Text('''પ્રતિ પ્રબંધક મધુપુરી ફાઇનાન્સ ભાવનગર શાખા મહોદય/મહોદયા હું/અમે.. ...................(હવે પછી આ દસ્તાવેજમાં દેણદાર તરીકે દર્શાવેલા) આપને રૂા..............(રૂપિયા શબ્દોમાં.......................................................................નું કરજ..........ગ્રામ (સંપૂર્ણ વજન) ના સોનાના આભુષણો/ચેક/ચીજવસ્તુઓ (હવે પછીઆ દસ્તાવેજમાં સોના તરીકે દર્શાવેલા) આ સાથે રજુ કરીએ છીએ જેની વિગતો અલગ રીતે દર્શાવેલ છે. તેની અવેજમાં કરજ આપવા અરજ કરીએ છીએ કે, કરજદાર નીચે જણાવ્યા પ્રમાણેના દસ્તાવેજો કે જે મધુપુરી ફાઇનાન્સ કંપની ધારા/નિયમો પ્રમાણે જરૂરી છે એ રજુ કરેલ છે.
                      // હું/અમે વચન આપીએ છીએ કે, જયારે માગણી કરવામાં આવશે ત્યારે મધુપુરી ફાઇનાન્સ અથવા તેના હુકમ પ્રમાણે ભાવનગર શાખા/ઓફીસ/તે જગ્યાએ રૂ।.......................% પ્રતિ વર્ષ વ્યાજ સાથે રૂ।...........................ચુકવીશું.''',
                      //         style: TextStyle(
                      //           // font: Baloo,
                      //             color: Utils().text,
                      //             fontSize: 9
                      //         ),
                      //         textAlign: TextAlign.justify
                      //     )
                      ),
                      SizedBox(
                        height: 20,
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
}