// import 'package:flutter/material.dart';
//
// import 'AddKyc.dart';
// import 'HomeSacreen.dart';
// import 'Utils.dart';
//
// class Editdetails extends StatefulWidget {
//   const Editdetails({super.key});
//
//   @override
//   State<Editdetails> createState() => _EditdetailsState();
// }
//
// class _EditdetailsState extends State<Editdetails> {
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
//                     // height: MediaQuery.of(context).size.height,
//                     width: MediaQuery.of(context).size.width,
//                     color: Utils().background,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             SizedBox(width: 45,),
//                             IconButton(onPressed: (){
//                               Navigator.pop(context);
//                             },
//                                 icon: Icon(Icons.arrow_back_sharp,color: Utils().text,size: 30,)),
//                             SizedBox(width: 10,),
//                             Text("Edit KYC",style: TextStyle(
//                               color: Utils().text,
//                               fontSize: 30,
//                               fontWeight: FontWeight.w700,
//                             ),)
//                           ],
//                         ),
//                         Divider(
//                           height: 2,
//                           color: Utils().text,
//                         ),
//                         userInformation(),
//                         addressInformation(),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             GestureDetector(
//                               onTap: (){},
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
//                   )
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
