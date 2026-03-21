import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PayEmiReceipt extends GetxController {

  /// Generate & Preview PDF
  Future<void> generatePdfReceipt({
    required String loanAmount,
    required String loanID,
    required String KYCID,
    required String name,
    required String loanType,
    required String date,
    required String emiAmount,
    required String penaltyAmount,
    required String otherAmount,
    required String detection,
    required String totalAmount,
  }) async {

    final pdf = pw.Document();
    final Uint8List logoBytes =
    (await rootBundle.load('assets/images/mflogo.png')).buffer.asUint8List();


    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero, // 🔥 REMOVE DEFAULT PADDING

        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Padding(padding: pw.EdgeInsets.all(8),
                child:    pw.Container(
                  height: 380,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.black,
                      width: 1,
                    ),
                    borderRadius: pw.BorderRadius.circular(10),
                  ),
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.all(12),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Image(
                              pw.MemoryImage(logoBytes),
                              height: 70,
                              width: 70,
                            ),
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text("Reg. No. GML / 04 / Bhavnagar / 188 / 2022",style: pw.TextStyle(color: PdfColor.fromHex('#332A60'),fontSize: 14)),
                                pw.SizedBox(height: 5),
                                pw.Text("353, MADHAV DARSHAN, WAGHAWADI ROAD,BHAVNAGAR - 364001. ( GUJ.) INDIA.",style: pw.TextStyle(color: PdfColor.fromHex('#332A60'),fontSize: 12)),
                                pw.SizedBox(height: 5),
                                pw.Text("MOBILE NO : +91 90547 45400",style: pw.TextStyle(color: PdfColor.fromHex('#332A60'),fontSize: 12)),
                              ]
                            )
                          ],
                        ),
                        pw.Divider(),
                        pw.Center(
                          child: pw.RichText(
                            text: pw.TextSpan(
                              children: [
                                pw.TextSpan(
                                  text: 'We Acknowledge receipt of the following monies on Account of the load Available from',
                                  style: pw.TextStyle(color: PdfColor.fromHex('#332A60'),fontSize: 10),
                                ),
                                pw.TextSpan(
                                  text: ' Madhupuri Finance',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold,color: PdfColor.fromHex('#332A60'),fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 12),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Text(
                              "Payment Date: ",
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(date),
                          ],
                        ),
                        pw.SizedBox(height: 12),
                        pw.Row(
                          children: [
                            pw.SizedBox(
                              width: 300,
                              child:  pw.Table(
                                border: pw.TableBorder.all(
                                  color: PdfColors.black,
                                  width: 0.8,
                                ),
                                columnWidths: {
                                  0: pw.FlexColumnWidth(100),
                                  1: pw.FlexColumnWidth(100),
                                },
                                children: [
                                  tableCellRow('Loan Amount', loanAmount),
                                  tableCellRow('Loan ID',  loanID),
                                  tableCellRow('KYC Code', KYCID),
                                  tableCellRow('Cust. Name', name),
                                  tableCellRow('Loan Type', loanType),
                                ],
                              ),
                            ),
                            pw.SizedBox(width: 10),
                            pw.SizedBox(
                              width: 250,
                              child:  pw.Table(
                                border: pw.TableBorder.all(
                                  color: PdfColors.black,
                                  width: 0.8,
                                ),
                                columnWidths: {
                                  0: pw.FlexColumnWidth(150),
                                  1: pw.FlexColumnWidth(100),
                                },
                                children: [
                                  tableCellRow('EMI AMOUNT',emiAmount),
                                  tableCellRow('Penalty AMOUNT',penaltyAmount),
                                  tableCellRow('OTHER AMOUNT',otherAmount),
                                  tableCellRow('DETECTION',detection),
                                  pw.TableRow(children: [
                                    pw.Padding(padding: pw.EdgeInsets.all(6),
                                        child:pw.Text("TOTAL",style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                                    ),
                                    pw.Padding(padding: pw.EdgeInsets.all(6),
                                        child:pw.Text(totalAmount,style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                                    )
                                  ])
                                  // tableCellRow('TOTAL',totalAmount),
                                ],
                              ),
                            ),
                          ]
                        ),
                        pw.SizedBox(height: 80),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("Customer Signature"),
                            pw.Text("CASHIER BRANCH MANAGER STAMP"),
                          ]
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              pw.Padding(padding: pw.EdgeInsets.all(8),
                child:  pw.Container(
                  width: double.infinity,
                  height: 1,
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        color: PdfColors.grey700,
                        width: 2,
                        style: pw.BorderStyle.dotted,
                      ),
                    ),
                  ),
                ),
              ),

              pw.Padding(padding: pw.EdgeInsets.all(8),
                child:    pw.Container(
                  height: 380,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.black,
                      width: 1,
                    ),
                    borderRadius: pw.BorderRadius.circular(10),
                  ),
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.all(12),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Image(
                              pw.MemoryImage(logoBytes),
                              height: 70,
                              width: 70,
                            ),
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text("Reg. No. GML / 04 / Bhavnagar / 188 / 2022",style: pw.TextStyle(color: PdfColor.fromHex('#332A60'),fontSize: 14)),
                                  pw.SizedBox(height: 5),
                                  pw.Text("353, MADHAV DARSHAN, WAGHAWADI ROAD,BHAVNAGAR - 364001. ( GUJ.) INDIA.",style: pw.TextStyle(color: PdfColor.fromHex('#332A60'),fontSize: 12)),
                                  pw.SizedBox(height: 5),
                                  pw.Text("MOBILE NO : +91 90547 45400",style: pw.TextStyle(color: PdfColor.fromHex('#332A60'),fontSize: 12)),
                                ]
                            )
                          ],
                        ),
                        pw.Divider(),
                        pw.Center(
                          child: pw.RichText(
                            text: pw.TextSpan(
                              children: [
                                pw.TextSpan(
                                  text: 'We Acknowledge receipt of the following monies on Account of the load Available from',
                                  style: pw.TextStyle(color: PdfColor.fromHex('#332A60'),fontSize: 10),
                                ),
                                pw.TextSpan(
                                  text: ' Madhupuri Finance',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold,color: PdfColor.fromHex('#332A60'),fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 12),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Text(
                              "Payment Date: ",
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(date),
                          ],
                        ),
                        pw.SizedBox(height: 12),
                        pw.Row(
                            children: [
                              pw.SizedBox(
                                width: 300,
                                child:  pw.Table(
                                  border: pw.TableBorder.all(
                                    color: PdfColors.black,
                                    width: 0.8,
                                  ),
                                  columnWidths: {
                                    0: pw.FlexColumnWidth(100),
                                    1: pw.FlexColumnWidth(100),
                                  },
                                  children: [
                                    tableCellRow('Loan Amount', loanAmount),
                                    tableCellRow('Loan ID',  loanID),
                                    tableCellRow('KYC Code', KYCID),
                                    tableCellRow('Cust. Name', name),
                                    tableCellRow('Loan Type', loanType),
                                  ],
                                ),
                              ),
                              pw.SizedBox(width: 10),
                              pw.SizedBox(
                                width: 250,
                                child:  pw.Table(
                                  border: pw.TableBorder.all(
                                    color: PdfColors.black,
                                    width: 0.8,
                                  ),
                                  columnWidths: {
                                    0: pw.FlexColumnWidth(150),
                                    1: pw.FlexColumnWidth(100),
                                  },
                                  children: [

                                    tableCellRow('EMI AMOUNT',emiAmount),
                                    tableCellRow('PENALTY AMOUNT',penaltyAmount),
                                    tableCellRow('OTHER AMOUNT',otherAmount),
                                    tableCellRow('DETECTION',detection),
                                    pw.TableRow(children: [
                                      pw.Padding(padding: pw.EdgeInsets.all(6),
                                          child:pw.Text("TOTAL",style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                                      ),
                                      pw.Padding(padding: pw.EdgeInsets.all(6),
                                          child:pw.Text(totalAmount,style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                                      )
                                    ])
                                    // tableCellRow('TOTAL',totalAmount),
                                  ],
                                ),
                              ),
                            ]
                        ),
                        pw.SizedBox(height: 80),
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text("Customer Signature"),
                              pw.Text("CASHIER BRANCH MANAGER STAMP"),
                            ]
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              pw.SizedBox(
                height: 10,
              ),
            ],
          );
        },
      ),
    );

    /// Preview / Print / Download
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
  pw.Widget tableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.TableRow tableCellRow(
      String desc,
      String amount,
      ) {
    return pw.TableRow(
      children: [
        tableCell(desc),
        tableCell(amount, align: pw.TextAlign.left),
      ],
    );
  }

  pw.Widget tableCell(String text, {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 10),
        textAlign: align,
      ),
    );
  }

}
