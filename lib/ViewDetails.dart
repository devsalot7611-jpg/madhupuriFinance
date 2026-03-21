// import 'package:flutter/material.dart';
// import 'package:madhupurifinance/Controller/FormController.dart';
// import 'package:madhupurifinance/EditDetails.dart';
// import 'package:madhupurifinance/HomeSacreen.dart';
// import 'package:madhupurifinance/Utils.dart';
// import 'AddKyc.dart';
// import 'package:get/get.dart';
//
// class ViewDetails extends StatefulWidget {
//   const ViewDetails({super.key});
//
//   @override
//   State<ViewDetails> createState() => _ViewDetailsState();
// }
//
// class _ViewDetailsState extends State<ViewDetails> {
//
//   final FormController formController = Get.put(FormController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Utils().background,
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           appBar(),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     color: Utils().background,
//                     child: Column( // Removed Expanded from here
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 IconButton(
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                   icon: Icon(Icons.arrow_back_sharp, color: Utils().text, size: 30),
//                                 ),
//                                 SizedBox(width: 10),
//                                 Text(
//                                   "KYC Details",
//                                   style: TextStyle(
//                                     color: Utils().text,
//                                     fontSize: 30,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(10.0),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   // Navigator.push(context, MaterialPageRoute(builder: (context) => Editdetails()));
//                                 },
//                                 child: Container(
//                                   height: 60,
//                                   width: 130,
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(colors: [
//                                       Utils().border_1,
//                                       Utils().button,
//                                     ]),
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         "Edit",
//                                         style: TextStyle(
//                                           color: Utils().background,
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.w400,
//                                         ),
//                                       ),
//                                       Icon(Icons.edit, size: 20, color: Utils().background),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Divider(
//                           height: 2,
//                           color: Utils().text,
//                         ),
//                         userInformation(),
//                         addressInformation(),
//                         Description(),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             GestureDetector(
//                               onTap: (){
//                                 print("First Name : - ${formController.firstName.text}");
//                               },
//                               child: Container(
//                                 height: 40,
//                                 width: 200,
//                                 decoration: BoxDecoration(
//                                     gradient: LinearGradient(colors: [
//                                       Utils().border_1,
//                                       Utils().button,
//                                     ])
//                                 ),
//                                 child: Center(
//                                   child: Text("Save",style: TextStyle(
//                                       fontSize: 16,
//                                       color: Utils().background
//                                   ),),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 50,),
//                             GestureDetector(
//                               onTap: (){},
//                               child: Container(
//                                 height: 40,
//                                 width: 200,
//                                 decoration: BoxDecoration(
//                                     border: Border.all(
//                                       width: 1,
//                                       color: Utils().button,
//                                     )
//                                 ),
//                                 child: Center(
//                                   child: Text("Clear Data",style: TextStyle(
//                                       fontSize: 16,
//                                       color: Utils().button
//                                   ),),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 20,),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class Description extends StatelessWidget {
//
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Padding(
//         padding: const EdgeInsets.only(left: 30,right: 30,top: 35,bottom: 10),
//         child: Container(
//           height: 300,
//           decoration: BoxDecoration(
//             color: Utils().background,
//             borderRadius: BorderRadius.circular(30),
//             border: Border.all(
//               width: 1,
//               color: Utils().border_1,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.25),
//                 blurRadius: 10,
//                 offset: Offset(0, 0),
//               ),
//             ],
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Description (માહિતી)",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 12),
//                 Text('''પ્રતિ
// પ્રબંધક મધુપુરી ફાઇનાન્સ ભાવનગર શાખા
// મહોદય/મહોદયા
// હું/અમે ......................................(હવે પછી આ દસ્તાવેજમાં દેણદાર તરીકે દર્શાવેલા) આપને રૂા..............(રૂપિયા શબ્દોમાં .......................................................................નું કરજ..........ગ્રામ (સંપૂર્ણ વજન) ના સોનાના આભુષણો/ચેક/ચીજવસ્તુઓ (હવે પછી આ દસ્તાવેજમાં સોના તરીકે દર્શાવેલા) આ સાથે રજુ કરીએ છીએ જેની વિગતો અલગ રીતે દર્શાવેલ છે. તેની અવેજમાં કરજ આપવા અરજ કરીએ છીએ કે, કરજદાર નીચે જણાવ્યા પ્રમાણેના દસ્તાવેજો કે જે મધુપુરી ફાઇનાન્સ કંપની ધારા/નિયમો પ્રમાણે જરૂરી છે એ રજુ કરેલ છે.
// હું/અમે વચન આપીએ છીએ કે, જયારે માગણી કરવામાં આવશે ત્યારે મધુપુરી ફાઇનાન્સ અથવા તેના હુકમ પ્રમાણે ભાવનગર શાખા/ઓફીસ/તે જગ્યાએ રૂ।.......................% પ્રતિ વર્ષ વ્યાજ સાથે રૂ।...........................ચુકવીશું.''',
//                   textAlign: TextAlign.justify,
//                   style: TextStyle(
//                     fontSize: 14,
//                     height: 1.5,
//                   ),
//                 ),
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Text("Owner Signature (માલિકની સહી)",style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w400,
//                         color: Utils().hintText
//                     ),),
//                     Text("User Signature (ગ્રાહકની સહી)",style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w400,
//                         color: Utils().hintText
//                     ),),
//                     Container(
//                       height: 90,
//                       width: 90,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           width: 1,
//                         ),
//                       ),
//                       child: Center(
//                         child: Text("1 Rs.",style: TextStyle(
//
//                         ),),
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         )
//
//     );
//   }
// }