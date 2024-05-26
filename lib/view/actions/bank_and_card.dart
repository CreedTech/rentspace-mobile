// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../controller/auth/user_controller.dart';

// class BankAndCard extends StatefulWidget {
//   const BankAndCard({
//     super.key,
//   });

//   @override
//   _BankAndCardState createState() => _BankAndCardState();
// }

// var obxData = " ".obs;

// class _BankAndCardState extends State<BankAndCard> {
//   final UserController userController = Get.find();
//   bool isCvvFocused = false;
//   bool useGlassMorphism = false;
//   bool useBackgroundImage = false;
//   OutlineInputBorder? border;

//   @override
//   initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Scaffold(
//         backgroundColor: Theme.of(context).canvasColor,
//         appBar: AppBar(
//           centerTitle: true,
//           elevation: 0,
//           leading: GestureDetector(
//             onTap: () {
//               Get.back();
//             },
//             child: Icon(
//               Icons.arrow_back,
//               color: Theme.of(context).primaryColor,
//             ),
//           ),
//           title: Text(
//             'Bank & Card Details',
//             style: GoogleFonts.lato(
//                 color: Theme.of(context).primaryColor,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700),
//           ),
//         ),
//         body: const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//           child: Column(
//             // mainAxisAlignment: MainAxisAlignment.center,
//             // crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // (
//               //         userController.userModel!.userDetails[0].accountNumber != "")
//               //     ? Column(
//               //         children: [
//               //           FlipCard(
//               //             front: Neumorphic(
//               //               style: NeumorphicStyle(
//               //                   shape: NeumorphicShape.concave,
//               //                   boxShape: NeumorphicBoxShape.roundRect(
//               //                       BorderRadius.circular(15)),
//               //                   depth: 0,
//               //                   // lightSource: LightSource.topLeft,
//               //                   color: Colors.white),
//               //               child: Container(
//               //                 height: 220,
//               //                 padding: const EdgeInsets.fromLTRB(
//               //                     30.0, 10.0, 20.0, 0.0),
//               //                 decoration: const BoxDecoration(color: brandOne),
//               //                 child: Row(
//               //                   mainAxisAlignment:
//               //                       MainAxisAlignment.spaceBetween,
//               //                   children: [
//               //                     Column(
//               //                       crossAxisAlignment:
//               //                           CrossAxisAlignment.start,
//               //                       children: [
//               //                         const SizedBox(
//               //                           height: 20,
//               //                         ),
//               //                         Row(
//               //                           children: [
//               //                             Image.asset(
//               //                               "assets/icons/chip.png",
//               //                               height: 50,
//               //                               width: 50,
//               //                             ),
//               //                           ],
//               //                         ),
//               //                         const SizedBox(
//               //                           height: 20,
//               //                         ),
//               //                         Row(
//               //                           children: [
//               //                             Text(
//               //                               "XXXX XXXX XXXX ${userController.user[0].cardDigit.substring(5, 9)}",
//               //                               style: GoogleFonts.lato(
//               //                                 fontSize: 20.0,
//               //                                 // letterSpacing: 2.0,
//               //                                 // fontFamily: "DefaultFontFamily",
//               //                                 color: Colors.white,
//               //                               ),
//               //                               textAlign: TextAlign.center,
//               //                             ),
//               //                           ],
//               //                         ),
//               //                         const SizedBox(
//               //                           height: 10,
//               //                         ),
//               //                         Row(
//               //                           children: [
//               //                             Text(
//               //                               userController.user[0].cardExpire,
//               //                               style: GoogleFonts.lato(
//               //                                 fontSize: 15.0,
//               //                                 // letterSpacing: 2.0,
//               //                                 // fontFamily: "DefaultFontFamily",
//               //                                 color: Colors.white,
//               //                               ),
//               //                               textAlign: TextAlign.center,
//               //                             ),
//               //                           ],
//               //                         ),
//               //                         const SizedBox(
//               //                           height: 10,
//               //                         ),
//               //                         Row(
//               //                           children: [
//               //                             Text(
//               //                               userController.user[0].cardHolder,
//               //                               style: GoogleFonts.lato(
//               //                                 fontSize: 20.0,
//               //                                 // letterSpacing: 2.0,
//               //                                 // fontFamily: "DefaultFontFamily",
//               //                                 color: Colors.white,
//               //                                 fontWeight: FontWeight.bold,
//               //                               ),
//               //                               overflow: TextOverflow.ellipsis,
//               //                               //textAlign: TextAlign.center,
//               //                             ),
//               //                           ],
//               //                         ),
//               //                       ],
//               //                     ),
//               //                   ],
//               //                 ),
//               //               ),
//               //             ),
//               //             back: Neumorphic(
//               //               style: NeumorphicStyle(
//               //                   shape: NeumorphicShape.concave,
//               //                   boxShape: NeumorphicBoxShape.roundRect(
//               //                       BorderRadius.circular(12)),
//               //                   depth: 0,
//               //                   lightSource: LightSource.topLeft,
//               //                   color: Theme.of(context).canvasColor),
//               //               child: Container(
//               //                 height: 220,
//               //                 padding: const EdgeInsets.fromLTRB(
//               //                     0.0, 10.0, 0.0, 0.0),
//               //                 decoration: const BoxDecoration(color: brandOne),
//               //                 child: Column(
//               //                   children: [
//               //                     Row(
//               //                       mainAxisAlignment: MainAxisAlignment.start,
//               //                       children: [
//               //                         Padding(
//               //                           padding: const EdgeInsets.fromLTRB(
//               //                               20.0, 10.0, 20.0, 5.0),
//               //                           child: Text(
//               //                             "",
//               //                             style: GoogleFonts.lato(
//               //                               fontSize: 14.0,
//               //                               // fontFamily: "DefaultFontFamily",
//               //                               //letterSpacing: 1.0,

//               //                               color: Colors.white,
//               //                             ),
//               //                           ),
//               //                         ),
//               //                       ],
//               //                     ),
//               //                     const SizedBox(
//               //                       height: 5,
//               //                     ),
//               //                     Container(
//               //                       color: Colors.black,
//               //                       height: 40,
//               //                     ),
//               //                     Padding(
//               //                       padding: const EdgeInsets.fromLTRB(
//               //                           40.0, 20.0, 40.0, 5.0),
//               //                       child: Container(
//               //                         color: Colors.white,
//               //                         width: MediaQuery.of(context).size.width,
//               //                         padding: const EdgeInsets.fromLTRB(
//               //                             5.0, 4.0, 5.0, 4.0),
//               //                         child: Text(
//               //                           userController.user[0].cardCVV,
//               //                           style: GoogleFonts.lato(
//               //                             fontSize: 14.0,
//               //                             // fontFamily: "DefaultFontFamily",
//               //                             //letterSpacing: 1.0,

//               //                             color: Colors.black,
//               //                           ),
//               //                           textAlign: TextAlign.end,
//               //                         ),
//               //                       ),
//               //                     ),
//               //                     Padding(
//               //                       padding: const EdgeInsets.fromLTRB(
//               //                           20.0, 10.0, 20.0, 5.0),
//               //                       child: Text(
//               //                         "This card is the property of your Bank Name and is issued to the cardholder subject to the terms and conditions associated with the account. Unauthorized use, duplication, or disclosure of this card is strictly prohibited. If found, please return to your Bank Address. The cardholder is responsible for the safety and security of this card. Any loss, theft, or unauthorized use must be reported immediately to your Bank Customer Service Number",
//               //                         style: GoogleFonts.lato(
//               //                           fontSize: 6.0,
//               //                           color: Colors.white,
//               //                           // fontFamily: "DefaultFontFamily",
//               //                         ),
//               //                       ),
//               //                     ),
//               //                   ],
//               //                 ),
//               //               ),
//               //             ),
//               //           ),
//               //           SizedBox(
//               //             height: 80.h,
//               //           ),
//               //           Padding(
//               //             padding: const EdgeInsets.all(10.0),
//               //             child: Text(
//               //               'Bank Details',
//               //               style: GoogleFonts.lato(
//               //                 fontSize: 17,
//               //                 fontWeight: FontWeight.w700,
//               //                 color: Theme.of(context).primaryColor,
//               //               ),
//               //             ),
//               //           ),
//               //           Container(
//               //             width: double.infinity,
//               //             padding: const EdgeInsets.symmetric(
//               //                 vertical: 20, horizontal: 25),
//               //             decoration: BoxDecoration(
//               //               color: brandTwo.withOpacity(0.2),
//               //               borderRadius: BorderRadius.circular(10),
//               //             ),
//               //             child: Column(
//               //               mainAxisAlignment: MainAxisAlignment.start,
//               //               crossAxisAlignment: CrossAxisAlignment.start,
//               //               children: [
//               //                 Text(
//               //                   userController.user[0].accountName,
//               //                   style: GoogleFonts.lato(
//               //                     fontSize: 16.0,
//               //                     // fontFamily: "DefaultFontFamily",
//               //                     // letterSpacing: 0.5,
//               //                     fontWeight: FontWeight.w400,
//               //                     color: Theme.of(context).primaryColor,
//               //                   ),
//               //                 ),
//               //                 const SizedBox(
//               //                   height: 10,
//               //                 ),
//               //                 Text(
//               //                   userController.user[0].bankName,
//               //                   style: GoogleFonts.lato(
//               //                     fontSize: 12.0,
//               //                     // fontFamily: "DefaultFontFamily",
//               //                     // letterSpacing: 0.5,
//               //                     fontWeight: FontWeight.w700,
//               //                     color: Theme.of(context).primaryColor,
//               //                   ),
//               //                 ),
//               //                 const SizedBox(
//               //                   height: 10,
//               //                 ),
//               //                 Text(
//               //                   userController.user[0].accountNumber,
//               //                   style: GoogleFonts.lato(
//               //                     color: Theme.of(context).primaryColor,
//               //                   ),
//               //                 ),
//               //               ],
//               //             ),
//               //           ),
//               //           const SizedBox(
//               //             height: 50,
//               //           ),
//               //           Row(
//               //             mainAxisAlignment: MainAxisAlignment.spaceAround,
//               //             children: [
//               //               ElevatedButton(
//               //                 style: ElevatedButton.styleFrom(
//               //                   minimumSize: const Size(150, 50),
//               //                   backgroundColor: brandOne,
//               //                   elevation: 0,
//               //                   shape: RoundedRectangleBorder(
//               //                     borderRadius: BorderRadius.circular(
//               //                       10,
//               //                     ),
//               //                   ),
//               //                 ),
//               //                 onPressed: () {
//               //                   Get.to(const AddCard());
//               //                 },
//               //                 child: Text(
//               //                   'Update',
//               //                   textAlign: TextAlign.center,
//               //                   style: GoogleFonts.lato(
//               //                     color: Colors.white,
//               //                     fontWeight: FontWeight.w700,
//               //                     fontSize: 16,
//               //                   ),
//               //                 ),
//               //               ),
//               //               ElevatedButton(
//               //                 style: ElevatedButton.styleFrom(
//               //                   minimumSize: const Size(150, 50),
//               //                   backgroundColor: Colors.red,
//               //                   elevation: 0,
//               //                   shape: RoundedRectangleBorder(
//               //                     borderRadius: BorderRadius.circular(
//               //                       10,
//               //                     ),
//               //                   ),
//               //                 ),
//               //                 onPressed: () {
//               //                   // _doSomething();
//               //                   Get.bottomSheet(
//               //                     SizedBox(
//               //                       height: 250,
//               //                       child: ClipRRect(
//               //                         borderRadius: const BorderRadius.only(
//               //                           topLeft: Radius.circular(30.0),
//               //                           topRight: Radius.circular(30.0),
//               //                         ),
//               //                         child: Container(
//               //                           color: Theme.of(context).canvasColor,
//               //                           padding: const EdgeInsets.fromLTRB(
//               //                               10, 5, 10, 5),
//               //                           child: Column(
//               //                             children: [
//               //                               const SizedBox(
//               //                                 height: 50,
//               //                               ),
//               //                               Text(
//               //                                 'Are you sure you want to delete this card?',
//               //                                 style: GoogleFonts.lato(
//               //                                   fontSize: 18,
//               //                                   fontWeight: FontWeight.w600,
//               //                                   // fontFamily: "DefaultFontFamily",
//               //                                   color: Theme.of(context)
//               //                                       .primaryColor,
//               //                                 ),
//               //                               ),
//               //                               const SizedBox(
//               //                                 height: 30,
//               //                               ),
//               //                               //card
//               //                               Row(
//               //                                 mainAxisAlignment:
//               //                                     MainAxisAlignment.center,
//               //                                 children: [
//               //                                   Padding(
//               //                                     padding:
//               //                                         const EdgeInsets.all(3),
//               //                                     child: ElevatedButton(
//               //                                       onPressed: () async {
//               //                                         // var userHealthUpdate =
//               //                                         //     FirebaseFirestore
//               //                                         //         .instance
//               //                                         //         .collection(
//               //                                         //             'accounts');
//               //                                         // await userHealthUpdate
//               //                                         //     .doc(userId)
//               //                                         //     .update({
//               //                                         //   'card_digit': '',
//               //                                         //   'card_cvv': '',
//               //                                         //   'card_expire': '',
//               //                                         //   'card_holder': '',
//               //                                         // }).then((value) {
//               //                                         //   Get.back();
//               //                                         //   print(userId);
//               //                                         //   showTopSnackBar(
//               //                                         //     Overlay.of(context),
//               //                                         //     CustomSnackBar
//               //                                         //         .success(
//               //                                         //       backgroundColor:
//               //                                         //           brandOne,
//               //                                         //       message:
//               //                                         //           'Your card has been deleted successfully',
//               //                                         //       textStyle:
//               //                                         //           GoogleFonts
//               //                                         //               .lato(
//               //                                         //         fontSize: 14,
//               //                                         //         color:
//               //                                         //             Colors.white,
//               //                                         //         fontWeight:
//               //                                         //             FontWeight
//               //                                         //                 .w700,
//               //                                         //       ),
//               //                                         //     ),
//               //                                         //   );
//               //                                         //   // Get.snackbar(
//               //                                         //   //   "deleted!",
//               //                                         //   //   'Your card has been deleted successfully',
//               //                                         //   //   animationDuration:
//               //                                         //   //       const Duration(
//               //                                         //   //           seconds: 1),
//               //                                         //   //   backgroundColor: brandOne,
//               //                                         //   //   colorText: Colors.white,
//               //                                         //   //   snackPosition:
//               //                                         //   //       SnackPosition.TOP,
//               //                                         //   // );
//               //                                         //   Get.back();
//               //                                         // }).catchError((error) {
//               //                                         //   customErrorDialog(
//               //                                         //       context,
//               //                                         //       "Error",
//               //                                         //       error.toString());
//               //                                         // });
//               //                                       },
//               //                                       style: ElevatedButton
//               //                                           .styleFrom(
//               //                                         backgroundColor:
//               //                                             Colors.red,
//               //                                         shape:
//               //                                             RoundedRectangleBorder(
//               //                                           borderRadius:
//               //                                               BorderRadius
//               //                                                   .circular(8),
//               //                                         ),
//               //                                         padding: const EdgeInsets
//               //                                             .symmetric(
//               //                                             horizontal: 40,
//               //                                             vertical: 15),
//               //                                         textStyle:
//               //                                             const TextStyle(
//               //                                                 color: brandFour,
//               //                                                 fontSize: 13),
//               //                                       ),
//               //                                       child: const Text(
//               //                                         "Yes",
//               //                                         style: TextStyle(
//               //                                           color: Colors.white,
//               //                                           fontWeight:
//               //                                               FontWeight.w700,
//               //                                           fontSize: 16,
//               //                                         ),
//               //                                       ),
//               //                                     ),
//               //                                   ),
//               //                                   const SizedBox(
//               //                                     width: 20,
//               //                                   ),
//               //                                   Padding(
//               //                                     padding:
//               //                                         const EdgeInsets.all(3),
//               //                                     child: ElevatedButton(
//               //                                       onPressed: () {
//               //                                         Get.back();
//               //                                       },
//               //                                       style: ElevatedButton
//               //                                           .styleFrom(
//               //                                         backgroundColor: brandTwo,
//               //                                         shape:
//               //                                             RoundedRectangleBorder(
//               //                                           borderRadius:
//               //                                               BorderRadius
//               //                                                   .circular(8),
//               //                                         ),
//               //                                         padding: const EdgeInsets
//               //                                             .symmetric(
//               //                                             horizontal: 40,
//               //                                             vertical: 15),
//               //                                         textStyle:
//               //                                             const TextStyle(
//               //                                                 color: brandFour,
//               //                                                 fontSize: 13),
//               //                                       ),
//               //                                       child: const Text(
//               //                                         "No",
//               //                                         style: TextStyle(
//               //                                           color: Colors.white,
//               //                                           fontWeight:
//               //                                               FontWeight.w700,
//               //                                           fontSize: 16,
//               //                                         ),
//               //                                       ),
//               //                                     ),
//               //                                   ),
//               //                                 ],
//               //                               ),

//               //                               //card
//               //                             ],
//               //                           ),
//               //                         ),
//               //                       ),
//               //                     ),
//               //                   );
//               //                 },
//               //                 child: Text('Delete',
//               //                     textAlign: TextAlign.center,
//               //                     style: GoogleFonts.lato(
//               //                       color: Colors.white,
//               //                       fontWeight: FontWeight.w700,
//               //                       fontSize: 16,
//               //                     )),
//               //               ),
//               //             ],
//               //           ),
//               //         ],
//               //       )
//               //     : Center(
//               //         child: Column(
//               //           children: [
//               //             Image.asset('assets/card_empty.png'),
//               //             Text(
//               //               'No Bank Details Or Card Details Added Yet',
//               //               style: GoogleFonts.lato(
//               //                   fontSize: 17, fontWeight: FontWeight.w700),
//               //             ),
//               //             const SizedBox(
//               //               height: 40,
//               //             ),
//               //             ElevatedButton(
//               //               style: ElevatedButton.styleFrom(
//               //                 minimumSize: const Size(350, 50),
//               //                 backgroundColor: brandOne,
//               //                 elevation: 0,
//               //                 shape: RoundedRectangleBorder(
//               //                   borderRadius: BorderRadius.circular(
//               //                     10,
//               //                   ),
//               //                 ),
//               //               ),
//               //               onPressed: () {
//               //                 Get.to(const AddCard());
//               //               },
//               //               child: Text(
//               //                 'Add Details',
//               //                 textAlign: TextAlign.center,
//               //                 style: GoogleFonts.lato(
//               //                   color: Colors.white,
//               //                   fontWeight: FontWeight.w700,
//               //                   fontSize: 16,
//               //                 ),
//               //               ),
//               //             ),
//               //           ],
//               //         ),
//               //       ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
