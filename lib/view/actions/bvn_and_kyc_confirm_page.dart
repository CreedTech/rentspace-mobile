// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:google_fonts/google_fonts.dart';

// import 'package:rentspace/constants/colors.dart';
// import 'package:get/get.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:path/path.dart' as p;
// // import 'package:rentspace/constants/db/firebase_db.dart';
// import 'package:rentspace/constants/icons.dart';
// import 'package:http/http.dart' as http;

// import 'package:intl/intl.dart' as intl;
// import 'dart:async';

// import '../../constants/widgets/custom_dialog.dart';

// class BvnAndKycConfirmPage extends StatefulWidget {
//   String bvnValue, kycValue, idCardValue;
//   BvnAndKycConfirmPage({
//     super.key,
//     required this.bvnValue,
//     required this.kycValue,
//     required this.idCardValue,
//   });

//   @override
//   _BvnAndKycConfirmPageState createState() => _BvnAndKycConfirmPageState();
// }

// final TextEditingController _passwordController = TextEditingController();
// final _kycBvnPasswordFormKey = GlobalKey<FormState>();
// bool obscurity = true;
// Icon lockIcon = LockIcon().open;
// String _userPassword = "";
// String _cardHolder = "";
// String _cardCvv = "";
// String _cardExpire = "";
// String _cardNumber = "";

// class _BvnAndKycConfirmPageState extends State<BvnAndKycConfirmPage> {
//   void visibility() {
//     if (obscurity == true) {
//       setState(() {
//         obscurity = false;
//         lockIcon = LockIcon().close;
//       });
//     } else {
//       setState(() {
//         obscurity = true;
//         lockIcon = LockIcon().open;
//       });
//     }
//   }

//   getUser() async {
//     // var collection = FirebaseFirestore.instance.collection('accounts');
//     // var docSnapshot = await collection.doc(userId).get();
//     // if (docSnapshot.exists) {
//     //   Map<String, dynamic>? data = docSnapshot.data();
//     //   setState(() {
//     //     _userPassword = data?['password'];
//     //     _cardCvv = data?['card_cvv'];
//     //     _cardExpire = data?['card_expire'];
//     //     _cardHolder = data?['card_holder'];
//     //     _cardNumber = data?['card_digit'];
//     //   });
//     // }
//   }

//   Future verify(context) async {
//     // var userUpdate = FirebaseFirestore.instance.collection('accounts');

//     // await userUpdate.doc(userId).update({
//     //   'kyc_details': widget.kycValue,
//     //   'bvn': widget.bvnValue,
//     //   'has_verified_bvn': 'true',
//     //   'id_card': widget.idCardValue,
//     //   'status': 'verified'
//     // }).then((value) {
//     //   showTopSnackBar(
//     //     Overlay.of(context),
//     //     CustomSnackBar.success(
//     //       backgroundColor: brandOne,
//     //       message: 'BVN & KYC updated !!.',
//     //       textStyle: GoogleFonts.lato(
//     //         fontSize: 14,
//     //         color: Colors.white,
//     //         fontWeight: FontWeight.w700,
//     //       ),
//     //     ),
//     //   );

//     //   showDialog(
//     //       context: context,
//     //       barrierDismissible: true,
//     //       builder: (BuildContext context) {
//     //         return Column(
//     //           mainAxisAlignment: MainAxisAlignment.end,
//     //           children: [
//     //             AlertDialog(
//     //               contentPadding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
//     //               elevation: 0,
//     //               alignment: Alignment.bottomCenter,
//     //               insetPadding: const EdgeInsets.all(0),
//     //               scrollable: true,
//     //               title: null,
//     //               shape: const RoundedRectangleBorder(
//     //                 borderRadius: BorderRadius.only(
//     //                   topLeft: Radius.circular(30),
//     //                   topRight: Radius.circular(30),
//     //                 ),
//     //               ),
//     //               content: SizedBox(
//     //                 child: SizedBox(
//     //                   width: MediaQuery.of(context).size.width,
//     //                   child: Column(
//     //                     children: [
//     //                       Padding(
//     //                         padding: const EdgeInsets.symmetric(vertical: 40),
//     //                         child: Column(
//     //                           children: [
//     //                             Padding(
//     //                               padding:
//     //                                   const EdgeInsets.symmetric(vertical: 15),
//     //                               child: Align(
//     //                                 alignment: Alignment.topCenter,
//     //                                 child: Text(
//     //                                   'Your BVN & KYC has been updated successfully.\n Proceed to add Card',
//     //                                   textAlign: TextAlign.center,
//     //                                   style: GoogleFonts.lato(
//     //                                     color: Theme.of(context).primaryColor,
//     //                                     fontSize: 20,
//     //                                     fontWeight: FontWeight.w500,
//     //                                   ),
//     //                                 ),
//     //                               ),
//     //                             ),
//     //                             Padding(
//     //                               padding:
//     //                                   const EdgeInsets.symmetric(vertical: 10),
//     //                               child: Row(
//     //                                 mainAxisAlignment: MainAxisAlignment.center,
//     //                                 children: [
//     //                                   Padding(
//     //                                     padding: const EdgeInsets.all(3),
//     //                                     child: ElevatedButton(
//     //                                       onPressed: () {
//     //                                         Get.back();
//     //                                         Get.to(const AddCard());
//     //                                       },
//     //                                       style: ElevatedButton.styleFrom(
//     //                                         backgroundColor: Theme.of(context)
//     //                                             .colorScheme
//     //                                             .secondary,
//     //                                         shape: RoundedRectangleBorder(
//     //                                           borderRadius:
//     //                                               BorderRadius.circular(8),
//     //                                         ),
//     //                                         padding: const EdgeInsets.symmetric(
//     //                                             horizontal: 40, vertical: 15),
//     //                                         textStyle: const GoogleFonts.lato(
//     //                                             color: brandFour, fontSize: 13),
//     //                                       ),
//     //                                       child: const Text(
//     //                                         "Proceed",
//     //                                         style: GoogleFonts.lato(
//     //                                           color: Colors.white,
//     //                                           fontWeight: FontWeight.w700,
//     //                                           fontSize: 16,
//     //                                         ),
//     //                                       ),
//     //                                     ),
//     //                                   ),
//     //                                   const SizedBox(
//     //                                     width: 10,
//     //                                   ),
//     //                                   Padding(
//     //                                     padding: const EdgeInsets.all(3),
//     //                                     child: ElevatedButton(
//     //                                       onPressed: () {
//     //                                         for (int i = 0; i < 4; i++) {
//     //                                           Get.back();
//     //                                         }
//     //                                       },
//     //                                       style: ElevatedButton.styleFrom(
//     //                                         backgroundColor: Colors.red,
//     //                                         shape: RoundedRectangleBorder(
//     //                                           borderRadius:
//     //                                               BorderRadius.circular(8),
//     //                                         ),
//     //                                         padding: const EdgeInsets.symmetric(
//     //                                             horizontal: 40, vertical: 15),
//     //                                         textStyle: const GoogleFonts.lato(
//     //                                             color: brandFour, fontSize: 13),
//     //                                       ),
//     //                                       child: const Text(
//     //                                         "Dismiss",
//     //                                         style: GoogleFonts.lato(
//     //                                           color: Colors.white,
//     //                                           fontWeight: FontWeight.w700,
//     //                                           fontSize: 16,
//     //                                         ),
//     //                                       ),
//     //                                     ),
//     //                                   ),
//     //                                   const SizedBox(
//     //                                     height: 10,
//     //                                   ),
//     //                                 ],
//     //                               ),
//     //                             ),
//     //                           ],
//     //                         ),
//     //                       ),
//     //                     ],
//     //                   ),
//     //                 ),
//     //               ),
//     //             )
//     //           ],
//     //         );
//     //       });
//     // }).catchError((error) {
//     //   customErrorDialog(context, 'Error', error.toString());
//     // });
//   }

//   //Textform field

//   @override
//   initState() {
//     getUser();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final password = TextFormField(
//       enableSuggestions: true,
//       cursorColor: Theme.of(context).primaryColor,
//       controller: _passwordController,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       obscureText: obscurity,
//       style: GoogleFonts.lato(
//         color: Theme.of(context).primaryColor,
//       ),
//       keyboardType: TextInputType.text,
//       decoration: InputDecoration(
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10.0),
//           borderSide: const BorderSide(
//             color: Color(0xffE0E0E0),
//           ),
//         ),
//         focusedBorder: const OutlineInputBorder(
//           borderSide: BorderSide(color: brandOne, width: 1.0),
//         ),
//         enabledBorder: const OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Color(0xffE0E0E0),
//           ),
//         ),
//         errorBorder: const OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.red,
//             width: 1.0,
//           ),
//         ),
//         suffix: InkWell(
//           onTap: visibility,
//           child: lockIcon,
//         ),
//         suffixIconColor: Colors.black,
//         filled: false,
//         contentPadding: const EdgeInsets.all(14),
//         hintText: 'Enter Password to Submit',
//         hintStyle: GoogleFonts.lato(
//           color: Colors.grey,
//           fontSize: 12,
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//       validator: (val) {
//         if (val == null || val.isEmpty) {
//           return 'Input your password';
//         }
//         return null;
//       },
//     );

//     return Scaffold(
//       backgroundColor: Theme.of(context).canvasColor,
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).canvasColor,
//         elevation: 0.0,
//         leading: GestureDetector(
//           onTap: () {
//             Get.back();
//           },
//           child: Icon(
//             Icons.arrow_back,
//             size: 30,
//             color: Theme.of(context).primaryColor,
//           ),
//         ),
//         centerTitle: true,
//         title: Text(
//           'Confirm Details',
//           style: GoogleFonts.lato(
//               color: Theme.of(context).primaryColor,
//               fontSize: 16,
//               fontWeight: FontWeight.w700),
//         ),
//       ),
//       body: Stack(
//         children: [
//           // Positioned.fill(
//           //   child: Opacity(
//           //     opacity: 0.3,
//           //     child: Image.asset(
//           //       'assets/icons/RentSpace-icon.png',
//           //       fit: BoxFit.cover,
//           //     ),
//           //   ),
//           // ),
//           ListView(
//             children: [
//               // const SizedBox(
//               //   height: 50,
//               // ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
//                 child: Column(
//                   children: [
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         gradient: const LinearGradient(
//                           begin: Alignment.topRight,
//                           end: Alignment.bottomLeft,
//                           colors: [
//                             gradientOne,
//                             gradientTwo,
//                           ],
//                         ),
//                       ),
//                       padding:
//                           const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "BVN: ${widget.bvnValue}",
//                             style: GoogleFonts.lato(
//                               fontSize: 18.0,
//                               color: Colors.white,
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           Text(
//                             "KYC: ${widget.kycValue}",
//                             style: GoogleFonts.lato(
//                               fontSize: 18.0,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(0.0, 5, 0, 5),
//                       child: Text(
//                         "ID card:",
//                         style: GoogleFonts.lato(
//                           fontSize: 18,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     //ID Cardvalue
//                     Container(
//                       decoration: BoxDecoration(
//                         color: brandTwo,
//                         borderRadius: BorderRadius.circular(0),
//                       ),
//                       width: MediaQuery.of(context).size.width,
//                       padding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
//                       child: Image.network(
//                         widget.idCardValue,
//                         height: 200,
//                         fit: BoxFit.fitWidth,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     const SizedBox(
//                       height: 10.0,
//                     ),
//                     Form(
//                       key: _kycBvnPasswordFormKey,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 10),
//                             child: Text(
//                               'Enter Password to Submit',
//                               style: GoogleFonts.lato(
//                                 color: Theme.of(context).primaryColor,
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 16,
//                                 // fontFamily: "DefaultFontFamily",
//                               ),
//                             ),
//                           ),
//                           password,
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 60,
//                     ),

//                     Center(
//                       child: Container(
//                         // width: MediaQuery.of(context).size.width * 2,
//                         alignment: Alignment.center,
//                         // height: 110.h,
//                         child: Column(
//                           children: [
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 minimumSize: const Size(400, 50),
//                                 backgroundColor:
//                                     // _kycBvnPasswordFormKey
//                                     //         .currentState!
//                                     //         .validate()
//                                     //     ?
//                                     Theme.of(context).colorScheme.secondary
//                                 // : brandThree
//                                 ,
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(
//                                     10,
//                                   ),
//                                 ),
//                               ),
//                               onPressed: () {
//                                 if (_kycBvnPasswordFormKey.currentState!
//                                         .validate() &&
//                                     _userPassword != "" &&
//                                     _passwordController.text.trim() ==
//                                         _userPassword) {
//                                   verify(context);
//                                 } else {
//                                   customErrorDialog(
//                                       context,
//                                       'Incorrect password! ',
//                                       'Please enter the correct password to proceed.');
//                                 }
//                               },
//                               child: const Text(
//                                 'Submit',
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     const SizedBox(
//                       height: 30,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
