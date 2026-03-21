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


class DownloadForm extends StatefulWidget {
  DownloadForm({Key? key}) : super(key: key);
  @override
  State<DownloadForm> createState() => DownloadFormState();
}

class DownloadFormState extends State<DownloadForm> {
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
          child: pw.Image(image,height: PdfPageFormat.a4.height,width: PdfPageFormat.a4.width),
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
                  children: [
                    Column(
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
                                                    Text("Form NO.:______",style: TextStyle(
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
                                                    Text("KYC NO.:______",style: TextStyle(
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
                                                    SizedBox(width: 142),
                                                    Text("Loan ID.:______ ",style: TextStyle(
                                                        fontSize: 12,
                                                        color: Utils().text
                                                    )),
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
                          ///User Information
                          Container(
                              height: 5,
                              width: 700,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: Utils().text
                              )
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 130,
                            width: Get.width,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Utils().text,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text("User Information (ગ્રાહકની માહિતી)",style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            // font: Baloo,
                                            color: Utils().text,
                                            fontSize: 12
                                        )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 2,right: 6),
                                        child: Divider(
                                            height: 1.5,
                                            color: Utils().text
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5),
                                                child: Text("CUSTOMER NAME (ગ્રાહકનું નામ)",style: TextStyle(
                                                  color: Utils().text,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w400,
                                                ),),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5),
                                                child: Container(
                                                  height: 14,
                                                  width: 250,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(2),
                                                    color: Utils().pdfBox,
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        color: Colors.black, // or any color you prefer
                                                        width: 1.0,
                                                      )
                                                    )
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 20,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("CUSTOMER MOBILE NUMBER (ગ્રાહકનો મોબાઈલ નંબર)",style: TextStyle(
                                                color: Utils().text,
                                                fontSize: 9,
                                                fontWeight: FontWeight.w400,
                                              ),),
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 14,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(2),
                                                        color: Utils().pdfBox,
                                                        border: Border(
                                                            bottom: BorderSide(
                                                              color: Colors.black, // or any color you prefer
                                                              width: 1.0,
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                  SizedBox(width: 10,),
                                                  Container(
                                                    height: 14,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(2),
                                                        color: Utils().pdfBox,
                                                        border: Border(
                                                            bottom: BorderSide(
                                                              color: Colors.black, // or any color you prefer
                                                              width: 1.0,
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(left: 5),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("CUSTOMER ADDRESS (ગ્રાહકનું સરનામું)",style: TextStyle(
                                              color: Utils().text,
                                              fontSize: 9,
                                              fontWeight: FontWeight.w400,
                                            ),),
                                            Container(
                                              height: 14,
                                              width: 478,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(2),
                                                  color: Utils().pdfBox,
                                                  border: Border(
                                                      bottom: BorderSide(
                                                        color: Colors.black, // or any color you prefer
                                                        width: 1.0,
                                                      )
                                                  )
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(left: 5),
                                        child: Row(
                                          spacing: 8,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Pincode (પિન કોડ) ",style: TextStyle(
                                                  color: Utils().text,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w400,
                                                ),),
                                                Container(
                                                  height: 14,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(2),
                                                      color: Utils().pdfBox,
                                                      border: Border(
                                                          bottom: BorderSide(
                                                            color: Colors.black, // or any color you prefer
                                                            width: 1.0,
                                                          )
                                                      )
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("District (જિલ્લો)",style: TextStyle(
                                                  color: Utils().text,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w400,
                                                ),),
                                                Container(
                                                  height: 14,
                                                  width: 130,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(2),
                                                      color: Utils().pdfBox,
                                                      border: Border(
                                                          bottom: BorderSide(
                                                            color: Colors.black, // or any color you prefer
                                                            width: 1.0,
                                                          )
                                                      )
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("State (રાજ્ય)",style: TextStyle(
                                                  color: Utils().text,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w400,
                                                ),),
                                                Container(
                                                  height: 14,
                                                  width: 110,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(2),
                                                      color: Utils().pdfBox,
                                                      border: Border(
                                                          bottom: BorderSide(
                                                            color: Colors.black, // or any color you prefer
                                                            width: 1.0,
                                                          )
                                                      )
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Area (વિસ્તાર)",style: TextStyle(
                                                  color: Utils().text,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w400,
                                                ),),
                                                Container(
                                                  height: 14,
                                                  width: 132,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(2),
                                                      color: Utils().pdfBox,
                                                      border: Border(
                                                          bottom: BorderSide(
                                                            color: Colors.black, // or any color you prefer
                                                            width: 1.0,
                                                          )
                                                      )
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )

                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Container(
                                    width: 94,
                                    height: 113,
                                    color: Colors.grey.shade200,
                                    child: Center(child: Icon(Icons.person,color: Colors.white,)),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          ///GARANTOR Information
                          SizedBox(height: 10,),
                          Container(
                            height: 116,
                            width: Get.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(
                                      color: Utils().text,
                                    width: 1
                                  )
                              ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// 1
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5,bottom: 2,top: 4),
                                        child: Text("GARANTOR INFORMATION 1 (બાંયધરની માહિતી)",style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Utils().text
                                        ),),
                                      ),
                                      Divider(
                                        height: 1.5,
                                        color: Utils().text,
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(left: 5,bottom: 2,top: 4),
                                        child: Text("GARANTOR NAME 1 (બાંયધરનું નામ ૧)",style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Utils().text,
                                          fontSize: 9
                                        ),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5,bottom: 2),
                                        child: Container(
                                          height: 14,
                                          width: 280,
                                          decoration: BoxDecoration(
                                            color: Utils().pdfBox,
                                              border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.black, // or any color you prefer
                                                    width: 1.0,
                                                  )
                                              ),
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(left: 5,bottom: 2,top:4),
                                        child: Row(
                                          spacing: 55,
                                          children: [
                                            Text("GARANTOR MOBILE NO.\n(બાંયધરનો મોબાઈલ નં.)",style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Utils().text,
                                                fontSize: 9
                                            ),),
                                            Text("GARANTOR SIGNATURE\n(બાંયધરની સહી)",style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Utils().text,
                                                fontSize: 9
                                            ),),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5,),                                        child: Row(
                                          spacing: 30,
                                          children: [
                                            Container(
                                              height: 14,
                                              width: 125,
                                              decoration: BoxDecoration(
                                                color: Utils().pdfBox,
                                                  border: Border(
                                                      bottom: BorderSide(
                                                        color: Colors.black, // or any color you prefer
                                                        width: 1.0,
                                                      )
                                                  ),
                                                borderRadius: BorderRadius.circular(2),
                                              ),
                                            ),
                                            Container(
                                              height: 14,
                                              width: 125,
                                              decoration: BoxDecoration(
                                                color: Utils().pdfBox,
                                                  border: Border(
                                                      bottom: BorderSide(
                                                        color: Colors.black, // or any color you prefer
                                                        width: 1.0,
                                                      )
                                                  ),
                                                borderRadius: BorderRadius.circular(2),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                /// 2
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5,bottom: 2,top: 4),
                                        child: Text("GARANTOR INFORMATION 2 (બાંયધરની માહિતી)",style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Utils().text
                                        ),),
                                      ),
                                      Divider(
                                        height: 1.5,
                                        color: Utils().text,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5,bottom: 2,top: 4),
                                        child: Text("GARANTOR NAME 2 (બાંયધરનું નામ ૨)",style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Utils().text,
                                            fontSize: 9
                                        ),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5,bottom: 2),
                                        child: Container(
                                          height: 14,
                                          width: 280,
                                          decoration: BoxDecoration(
                                            color: Utils().pdfBox,
                                              border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.black, // or any color you prefer
                                                    width: 1.0,
                                                  )
                                              ),
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5,bottom: 2,top:4),
                                        child: Row(
                                          spacing: 55,
                                          children: [
                                            Text("GARANTOR MOBILE NO.\n(બાંયધરનો મોબાઈલ નં.)",style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Utils().text,
                                                fontSize: 9
                                            ),),
                                            Text("GARANTOR SIGNATURE\n(બાંયધરની સહી)",style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Utils().text,
                                                fontSize: 9
                                            ),),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5,),                                        child: Row(
                                        spacing: 30,
                                        children: [
                                          Container(
                                            height: 14,
                                            width: 125,
                                            decoration: BoxDecoration(
                                              color: Utils().pdfBox,
                                                border: Border(
                                                    bottom: BorderSide(
                                                      color: Colors.black, // or any color you prefer
                                                      width: 1.0,
                                                    )
                                                ),
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                          ),
                                          Container(
                                            height: 14,
                                            width: 125,
                                            decoration: BoxDecoration(
                                              color: Utils().pdfBox,
                                                border: Border(
                                                    bottom: BorderSide(
                                                      color: Colors.black, // or any color you prefer
                                                      width: 1.0,
                                                    )
                                                ),
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                          ),
                                        ],
                                      ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ///ID PROOF Bank Details
                          SizedBox(height: 10,),
                          Container(
                            height: 120,
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Utils().text,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5,bottom: 2,top: 4),
                                        child: Text("ID PROOF Information (Id પ્રૂફની માહિતીું)",style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Utils().text
                                        ),),
                                      ),
                                      Divider(
                                        color: Utils().text,
                                        height: 1,
                                      ),
                                      SizedBox(height: 65,),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Container(
                                          height: 14,
                                          width: 272,
                                          decoration: BoxDecoration(
                                            color: Utils().pdfBox,
                                              border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.black, // or any color you prefer
                                                    width: 1.0,
                                                  )
                                              )
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5,bottom: 2,top: 4),
                                        child: Text("Bank Details (બેંકની વિગતો)",style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Utils().text
                                        ),),
                                      ),
                                      Divider(
                                        color: Utils().text,
                                        height: 1,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4,bottom: 4),
                                        child: Text("Bank Name (બેંક નામ)",style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w400,
                                          color: Utils().text
                                        ),),
                                      ),
                                      Container(
                                        height: 14,
                                        width: 272,
                                        decoration: BoxDecoration(
                                          color: Utils().pdfBox,
                                            border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.black, // or any color you prefer
                                                  width: 1.0,
                                                )
                                            ),
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10,bottom: 5),
                                        child: Row(
                                          children: [
                                            Text("Bank Acc. No. (બેંક એકાઉન્ટ નં.)",style: TextStyle(
                                              color: Utils().text,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 9
                                            ),),
                                            Text("IFSC code (ifsc કોડ )",style: TextStyle(
                                                color: Utils().text,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 9
                                            ),),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        spacing: 10,
                                        children: [
                                         Container(
                                           height: 14,
                                           width: 135,
                                           decoration: BoxDecoration(
                                             color: Utils().pdfBox,
                                               border: Border(
                                                   bottom: BorderSide(
                                                     color: Colors.black, // or any color you prefer
                                                     width: 1.0,
                                                   )
                                               ),
                                             borderRadius: BorderRadius.circular(2),
                                           ),
                                         ),
                                          Container(
                                            height: 14,
                                            width: 135,
                                            decoration: BoxDecoration(
                                              color: Utils().pdfBox,
                                                border: Border(
                                                    bottom: BorderSide(
                                                      color: Colors.black, // or any color you prefer
                                                      width: 1.0,
                                                    )
                                                ),
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            height: 112,
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Utils().text,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5,top: 2,bottom: 4),
                                  child: Text("Loan Information (લોનની માહિતી)",style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Utils().text
                                  ),),
                                ),
                                Divider(
                                  color: Utils().text,
                                  height: 1,
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text("LOAN TYPE",style: TextStyle(
                                        fontSize: 9,
                                        color: Utils().text,
                                        fontWeight: FontWeight.w400,
                                      ),),
                                    ),
                                    SizedBox(width: 105,),
                                    Text("LOAN AMOUNT",style: TextStyle(
                                      fontSize: 9,
                                      color: Utils().text,
                                      fontWeight: FontWeight.w400,
                                    ),),
                                    SizedBox(width: 85,),
                                    Text("DOWN PAYMENT",style: TextStyle(
                                      fontSize: 9,
                                      color: Utils().text,
                                      fontWeight: FontWeight.w400,
                                    ),),
                                    SizedBox(width: 85,),
                                    Text("EMI AMOUNT",style: TextStyle(
                                      fontSize: 9,
                                      color: Utils().text,
                                      fontWeight: FontWeight.w400,
                                    ),),
                                  ],
                                ),
                                Row(
                                  spacing: 43,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Container(
                                        height: 14,
                                        width: 110,
                                        decoration: BoxDecoration(
                                          color: Utils().pdfBox,
                                            border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.black, // or any color you prefer
                                                  width: 1.0,
                                                )
                                            ),
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 14,
                                      width: 110,
                                      decoration: BoxDecoration(
                                        color: Utils().pdfBox,
                                          border: Border(
                                              bottom: BorderSide(
                                                color: Colors.black, // or any color you prefer
                                                width: 1.0,
                                              )
                                          ),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Text(" ₹ ",style: TextStyle(fontSize: 9),),
                                    ),
                                    Container(
                                      height: 14,
                                      width: 110,
                                      decoration: BoxDecoration(
                                        color: Utils().pdfBox,
                                          border: Border(
                                              bottom: BorderSide(
                                                color: Colors.black, // or any color you prefer
                                                width: 1.0,
                                              )
                                          ),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Text(" ₹ ",style: TextStyle(fontSize: 9),),
                                    ),
                                    Container(
                                      height: 14,
                                      width: 110,
                                      decoration: BoxDecoration(
                                        color: Utils().pdfBox,
                                          border: Border(
                                              bottom: BorderSide(
                                                color: Colors.black, // or any color you prefer
                                                width: 1.0,
                                              )
                                          ),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Text(" ₹ ",style: TextStyle(fontSize: 9),),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text("SERVICE CHARGE",style: TextStyle(
                                        fontSize: 9,
                                        color: Utils().text,
                                        fontWeight: FontWeight.w400,
                                      ),),
                                    ),
                                    SizedBox(width: 80,),
                                    Text("LOAN DURATION",style: TextStyle(
                                      fontSize: 9,
                                      color: Utils().text,
                                      fontWeight: FontWeight.w400,
                                    ),),
                                    SizedBox(width: 80,),
                                    Text("LOAN DATE",style: TextStyle(
                                      fontSize: 9,
                                      color: Utils().text,
                                      fontWeight: FontWeight.w400,
                                    ),),
                                    SizedBox(width: 100,),
                                    Text("CLOSING DATE",style: TextStyle(
                                      fontSize: 9,
                                      color: Utils().text,
                                      fontWeight: FontWeight.w400,
                                    ),),

                                  ],
                                ),
                                Row(
                                  spacing: 43,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Container(
                                        height: 14,
                                        width: 110,
                                        decoration: BoxDecoration(
                                          color: Utils().pdfBox,
                                          border: Border(
                                              bottom: BorderSide(
                                                color: Colors.black, // or any color you prefer
                                                width: 1.0,
                                              )
                                          ),
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                        child: Text(" ₹ ",style: TextStyle(fontSize: 9),),
                                      ),
                                    ),
                                    Container(
                                      height: 14,
                                      width: 110,
                                      decoration: BoxDecoration(
                                        color: Utils().pdfBox,
                                          border: Border(
                                              bottom: BorderSide(
                                                color: Colors.black, // or any color you prefer
                                                width: 1.0,
                                              )
                                          ),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    Container(
                                      height: 14,
                                      width: 110,
                                      decoration: BoxDecoration(
                                        color: Utils().pdfBox,
                                          border: Border(
                                              bottom: BorderSide(
                                                color: Colors.black, // or any color you prefer
                                                width: 1.0,
                                              )
                                          ),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    Container(
                                      height: 14,
                                      width: 110,
                                      decoration: BoxDecoration(
                                        color: Utils().pdfBox,
                                          border: Border(
                                              bottom: BorderSide(
                                                color: Colors.black, // or any color you prefer
                                                width: 1.0,
                                              )
                                          ),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            height: 200,
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Utils().text,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5,bottom: 4,top: 2),
                                  child: Text("Information (માહિતી)",style: TextStyle(
                                    // font: gujarati,
                                      color: Utils().text,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold
                                  )),
                                ),
                                Divider(
                                  height: 1,
                                  color: Utils().text,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4,right: 4,top: 5),
                                  child: SizedBox(
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
                                ),
                                SizedBox(height: 40,),
                                Row(
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 4),
                                            child: Text("----------------------------------"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 4),
                                            child: Text("Owner Signature (માલિકની સહી)",style: TextStyle(
                                              // font: regular,
                                                color: Utils().text,
                                                fontSize: 9
                                            )),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 190),
                                      Row(
                                        spacing: 10,
                                        children: [
                                          Column(
                                            children: [
                                              Text("----------------------------------"),
                                              Text("Customer Signature (ગ્રાહકની સહી)",style: TextStyle(
                                                // font: regular,
                                                  color: Utils().text,
                                                  fontSize: 9
                                              )),
                                            ],
                                          ),
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
                                        ],
                                      ),
                                    ]
                                ),
                              ],
                            ),
                          )
                        ]
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}