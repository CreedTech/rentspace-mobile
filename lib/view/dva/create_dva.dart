// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:lottie/lottie.dart';
// import 'package:rentspace/constants/colors.dart';
// import 'package:get/get.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart' as intl;
// import 'package:intl/intl.dart';
// import 'package:rentspace/constants/db/firebase_db.dart';
// import 'package:rentspace/constants/widgets/custom_dialog.dart';
// import 'package:rentspace/controller/user_controller.dart';
// import 'package:rentspace/constants/theme_services.dart';
// import 'package:get_storage/get_storage.dart';
// import 'dart:io';
// import 'package:getwidget/getwidget.dart';
// import 'package:rentspace/view/actions/wallet_funding.dart';
// import 'package:pattern_formatter/pattern_formatter.dart';
// import 'dart:async';
// import 'dart:math';
// import 'package:http/http.dart' as http;
// import 'package:rentspace/view/home_page.dart';
// import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'dart:convert';

// import 'package:top_snackbar_flutter/top_snack_bar.dart';

// import '../../constants/widgets/custom_loader.dart';

// class CreateDVA extends StatefulWidget {
//   const CreateDVA({Key? key}) : super(key: key);

//   @override
//   _CreateDVAState createState() => _CreateDVAState();
// }

// var now = DateTime.now();
// var formatter = DateFormat('yyyy-MM-dd');
// String formattedDate = formatter.format(now);
// CollectionReference users = FirebaseFirestore.instance.collection('accounts');
// CollectionReference allUsers =
//     FirebaseFirestore.instance.collection('accounts');
// String _mssg = "";
// String vName = "";
// String vNum = "";
// bool notLoading = true;

// class _CreateDVAState extends State<CreateDVA> {
//   final UserController userController = Get.find();
//   final form = intl.NumberFormat.decimalPattern();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String collectionName = 'dva';

//   TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _bvnController = TextEditingController();
//   final bvnformKey = GlobalKey<FormState>();
//   var _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
//   Random _rnd = Random();
//   String _payUrl = "";
//   String getRandom(int length) => String.fromCharCodes(
//         Iterable.generate(
//           length,
//           (_) => _chars.codeUnitAt(
//             _rnd.nextInt(_chars.length),
//           ),
//         ),
//       );

//   doSomething() {
//     print(userController.user[0].date_of_birth!);
//     print(userController.user[0].gender!);
//     print(userController.user[0].address);
//     print(userController.user[0].email);
//     print(userController.user[0].userFirst);
//     print(userController.user[0].userLast);
//     print(_bvnController.text.trim());
//     print(userController.user[0].dvaUsername);
//     print(userController.user[0].userPhone.replaceFirst('+234', ''));
//   }

//   createNewDVA() async {
//     setState(() {
//       notLoading = false;
//     });
//     EasyLoading.show(
//       indicator: const CustomLoader(),
//       maskType: EasyLoadingMaskType.black,
//       dismissOnTap: true,
//     );
//     const String apiUrl = 'https://api-d.squadco.com/virtual-account';
//     const String bearerToken = 'sk_5e03078e1a38fc96de55b1ffaa712ccb1e30965d';
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {
//         'Authorization': 'Bearer $bearerToken',
//         "Content-Type": "application/json"
//       },
//       body: jsonEncode(<String, String>{
//         "customer_identifier":
//             "SPACER/${userController.user[0].dvaUsername} ${userController.user[0].userFirst} ${userController.user[0].userLast}",
//         "first_name": "SPACER/ - ${userController.user[0].dvaUsername}",
//         "last_name": userController.user[0].userLast,
//         "mobile_num":
//             "0${userController.user[0].userPhone.replaceFirst('+234', '')}",
//         "email": userController.user[0].email,
//         "bvn": _bvnController.text.trim(),
//         "dob": userController.user[0].date_of_birth!,
//         "address": userController.user[0].address,
//         "gender": userController.user[0].gender!
//       }),
//     );
//     // EasyLoading.dismiss();
//     if (response.statusCode == 200) {
//       Map<String, dynamic> parsedJson = json.decode(response.body);
//       var updateLiquidate = FirebaseFirestore.instance.collection('dva');
//       setState(() {
//         vNum = parsedJson['data']['virtual_account_number'];
//         vName = parsedJson['data']['customer_identifier'];
//       });
//       await updateLiquidate.add({
//         'dva_name': vName,
//         'dva_date': formattedDate,
//         'dva_number': vNum,
//         'dva_username': userController.user[0].dvaUsername,
//       }).then((value) async {
//         var walletUpdate = FirebaseFirestore.instance.collection('accounts');
//         await walletUpdate.doc(userId).update({
//           'has_dva': 'true',
//           'dva_name': vName,
//           'dva_number': vNum,
//           'dva_username': userController.user[0].dvaUsername,
//           'dva_date': formattedDate,
//           "activities": FieldValue.arrayUnion(
//             [
//               "$formattedDate \nDVA Created",
//             ],
//           ),
//         });
//         setState(() {
//           notLoading = true;
//         });
//         EasyLoading.dismiss();
//         if (!context.mounted) return;
//         Get.bottomSheet(
//           isDismissible: false,
//           SizedBox(
//             height: 400,
//             child: ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(30.0),
//                 topRight: Radius.circular(30.0),
//               ),
//               child: Container(
//                 color: Theme.of(context).canvasColor,
//                 padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const SizedBox(
//                       height: 30,
//                     ),
//                     // const Icon(
//                     //   Icons
//                     //       .check_circle_outline,
//                     //   color: brandOne,
//                     //   size: 80,
//                     // ),
//                     Image.asset(
//                       'assets/check.png',
//                       width: 80,
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       'Wallet Successfully Created',
//                       style: GoogleFonts.nunito(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w700,
//                         // fontFamily:
//                         //     "DefaultFontFamily",
//                         color: Theme.of(context).primaryColor,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Text(
//                       'DVA Name: $vName',
//                       style: GoogleFonts.nunito(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         // fontFamily:
//                         //     "DefaultFontFamily",
//                         color: Theme.of(context).primaryColor,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Text(
//                       'DVA Number: $vNum',
//                       style: GoogleFonts.nunito(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         // fontFamily:
//                         //     "DefaultFontFamily",
//                         color: Theme.of(context).primaryColor,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Text(
//                       'DVA Bank: GTBank',
//                       style: GoogleFonts.nunito(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         // fontFamily:
//                         //     "DefaultFontFamily",
//                         color: Theme.of(context).primaryColor,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(
//                       height: 30,
//                     ),
//                     Align(
//                       alignment: Alignment.bottomCenter,
//                       child: Container(
//                         // width: MediaQuery.of(context).size.width * 2,
//                         alignment: Alignment.center,
//                         // height: 110.h,
//                         child: Column(
//                           children: [
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 minimumSize: const Size(300, 50),
//                                 backgroundColor: brandTwo,
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(
//                                     10,
//                                   ),
//                                 ),
//                               ),
//                               onPressed: () {
//                                 Get.to(const HomePage());
//                                 // for (int i = 0; i < 2; i++) {
//                                 //   Get.to(HomePage());
//                                 // }
//                               },
//                               child: Text(
//                                 'Go to HomePage',
//                                 textAlign: TextAlign.center,
//                                 style: GoogleFonts.nunito(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     // GFButton(
//                     //   onPressed: () {
//                     //     Get.to(
//                     //         HomePage());
//                     //     // for (int i = 0; i < 2; i++) {
//                     //     //   Get.to(HomePage());
//                     //     // }
//                     //   },
//                     //   icon: const Icon(
//                     //     Icons
//                     //         .arrow_right_outlined,
//                     //     size: 30,
//                     //     color:
//                     //         Colors.white,
//                     //   ),
//                     //   color: brandOne,
//                     //   text: "Done",
//                     //   shape: GFButtonShape
//                     //       .pills,
//                     //   fullWidthButton:
//                     //       true,
//                     // ),

//                     const SizedBox(
//                       height: 20,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       }).catchError((error) {
//         setState(() {
//           notLoading = true;
//         });
//         EasyLoading.dismiss();
//         if (context.mounted) {
//           customErrorDialog(
//             context,
//             'Oops',
//             'Something went wrong, try again later',
//           );
//         }
//         // errorDialog(context, "Oops", "Something went wrong, try again later");
//         // Get.snackbar(
//         //   "Oops",
//         //   "Something went wrong, try again later",
//         //   animationDuration: const Duration(seconds: 2),
//         //   backgroundColor: Colors.red,
//         //   colorText: Colors.white,
//         //   snackPosition: SnackPosition.BOTTOM,
//         // );
//       });
//     } else {
//       setState(() {
//         notLoading = true;
//       });
//       EasyLoading.dismiss();
//       if (!context.mounted) return;
//       if (context.mounted) {
//         customErrorDialog(
//           context,
//           'Error!',
//           'Something went wrong',
//         );
//       }
//       // errorDialog(context, "Error!", "Something went wrong");
//       // Get.snackbar(
//       //   "Error!",
//       //   "something went wrong",
//       //   animationDuration: const Duration(seconds: 1),
//       //   backgroundColor: Colors.red,
//       //   colorText: Colors.white,
//       //   snackPosition: SnackPosition.BOTTOM,
//       // );
//       print(
//           'Request failed with status: ${response.statusCode}, ${response.body}');
//     }
//   }

//   doSommething() {
//     print('Printing');
//     print(_bvnController.text.trim());
//     print('userController.user[0].dvaUsername');
//     print(userController.user[0].dvaUsername);
//     print('userController.user[0].date_of_birth');
//     // print(userController.user[0].date_of_birth);
//     print('userController.user[0].address');
//     print(userController.user[0].address);
//     print('userController.user[0].gender');
//     // print(userController.user[0].gender);
//   }

//   checkUserNameValidity() async {
//     QuerySnapshot querySnapshot =
//         await _firestore.collection(collectionName).get();

//     for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
//       Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;
//       if (data != null &&
//           data['dva_username'].toString().toLowerCase() ==
//               _usernameController.text.trim().toLowerCase()) {
//         setState(() {
//           _mssg = "username exists, choose another.";
//         });
//       } else {
//         setState(() {
//           _mssg = "username is available.";
//         });
//       }
//     }
//   }

//   @override
//   initState() {
//     super.initState();
//     _usernameController.clear();
//     setState(() {
//       _mssg = "";
//       vNum = "";
//       vName = "";
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     validateUsername(usernameValue) {
//       bool hasSpecial =
//           usernameValue.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
//       if (usernameValue.isEmpty) {
//         return 'username cannot be empty';
//       }

//       if ((_usernameController.text.trim().replaceAll(',', '')).length < 7) {
//         return 'username must contain at least 7 characters';
//       }
//       if (hasSpecial) {
//         return 'username cannot include special character';
//       }
//       return '';
//     }

//     validateBvn(bvnValue) {
//       if (bvnValue.isEmpty) {
//         return 'BVN cannot be empty';
//       }
//       if (bvnValue.length < 11) {
//         return 'BVN is invalid';
//       }
//       if (int.tryParse(bvnValue) == null) {
//         return 'enter valid BVN';
//       }
//       return null;
//     }

//     final username = TextFormField(
//       enableSuggestions: true,
//       cursorColor: Colors.black,
//       controller: _usernameController,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       validator: validateUsername,
//       onChanged: (e) {
//         if (_usernameController.text.trim().length >= 7) {
//           checkUserNameValidity();
//         }
//       },
//       maxLength: 10,
//       style: const TextStyle(
//         color: Colors.black,
//       ),
//       keyboardType: TextInputType.text,
//       decoration: InputDecoration(
//         label: const Text(
//           "Choose new username",
//           style: TextStyle(
//             color: Colors.grey,
//           ),
//         ),
//         prefixText: "SPACER/",
//         prefixStyle: const TextStyle(
//           color: Colors.grey,
//           fontSize: 13,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10.0),
//           borderSide: const BorderSide(color: brandOne, width: 2.0),
//         ),
//         focusedBorder: const OutlineInputBorder(
//           borderSide: BorderSide(color: brandOne, width: 2.0),
//         ),
//         enabledBorder: const OutlineInputBorder(
//           borderSide: BorderSide(color: brandOne, width: 2.0),
//         ),
//         errorBorder: const OutlineInputBorder(
//           borderSide: BorderSide(color: brandOne, width: 2.0),
//         ),
//         filled: true,
//         fillColor: brandThree,
//         hintText: 'can contain letters and numbers',
//         hintStyle: const TextStyle(
//           color: Colors.grey,
//           fontSize: 13,
//         ),
//       ),
//     );

//     final bvn = TextFormField(
//       enableSuggestions: true,
//       cursorColor: Colors.black,
//       controller: _bvnController,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       validator: validateBvn,
//       style: const TextStyle(
//         color: Colors.black,
//       ),
//       keyboardType: TextInputType.phone,
//       maxLengthEnforcement: MaxLengthEnforcement.enforced,
//       maxLength: 11,
//       decoration: InputDecoration(
//         label: Text(
//           "11 digits BVN",
//           style: GoogleFonts.nunito(
//             color: Colors.grey,
//             fontSize: 12,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10.0),
//           borderSide: const BorderSide(
//             color: Color(0xffE0E0E0),
//           ),
//         ),
//         focusedBorder: const OutlineInputBorder(
//           borderSide: BorderSide(color: brandOne, width: 2.0),
//         ),
//         enabledBorder: const OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Color(0xffE0E0E0),
//           ),
//         ),
//         errorBorder: const OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.red,
//             width: 2.0,
//           ),
//         ),
//         filled: false,
//         // fillColor: brandThree,
//         hintText: 'e.g 12345678900',
//         contentPadding: const EdgeInsets.all(14),
//         hintStyle: GoogleFonts.nunito(
//           color: Colors.grey,
//           fontSize: 12,
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//     );

//     return Scaffold(
//       backgroundColor: Theme.of(context).canvasColor,
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).canvasColor,
//         elevation: 0.0,
//         automaticallyImplyLeading: false,
//         actions: [
//           GestureDetector(
//             onTap: () {
//               Get.to(const HomePage());
//             },
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//               decoration: const BoxDecoration(
//                   // borderRadius: BorderRadius.circular(100),
//                   ),
//               child: Text(
//                 'Skip',
//                 style: GoogleFonts.nunito(
//                   color: brandOne,
//                   decoration: TextDecoration.underline,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           (notLoading)
//               ? Padding(
//                   padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 2),
//                   child: ListView(
//                     children: [
//                       Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(10.0),
//                             child: Text(
//                               "Complete your setup to Create your Personalized Free Dedicated Virtual Account (DVA)",
//                               textAlign: TextAlign.center,
//                               style: GoogleFonts.nunito(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w700,
//                                 // fontFamily: "DefaultFontFamily",
//                                 // letterSpacing: 0.5,
//                                 color: Theme.of(context).primaryColor,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 50,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
//                             child: Form(
//                               key: bvnformKey,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // const SizedBox(
//                                   //   height: 50,
//                                   // ),
//                                   Padding(
//                                     padding:
//                                         const EdgeInsets.symmetric(vertical: 3),
//                                     child: Text(
//                                       'Enter BVN',
//                                       style: GoogleFonts.nunito(
//                                         color: brandOne,
//                                         fontWeight: FontWeight.w700,
//                                         fontSize: 16,
//                                         // fontFamily: "DefaultFontFamily",
//                                       ),
//                                     ),
//                                   ),
//                                   bvn,
//                                   // Text(
//                                   //   _mssg,
//                                   //   style: GoogleFonts.nunito(
//                                   //     color: brandOne,
//                                   //     fontWeight: FontWeight.w700,
//                                   //     fontSize: 16,
//                                   //     // fontFamily: "DefaultFontFamily",
//                                   //   ),
//                                   // ),

//                                   const SizedBox(
//                                     height: 120,
//                                   ),
//                                   Align(
//                                     alignment: Alignment.bottomCenter,
//                                     child: Container(
//                                       // width: MediaQuery.of(context).size.width * 2,
//                                       alignment: Alignment.center,
//                                       // height: 110.h,
//                                       child: Column(
//                                         children: [
//                                           ElevatedButton(
//                                             style: ElevatedButton.styleFrom(
//                                               minimumSize: const Size(400, 50),
//                                               backgroundColor: brandTwo,
//                                               elevation: 0,
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(
//                                                   10,
//                                                 ),
//                                               ),
//                                             ),
//                                             onPressed: () {
//                                               if (bvnformKey.currentState!
//                                                   .validate()) {
//                                                 // createNewDVA();
//                                                 createNewDVA();
//                                                 // doSomething();
//                                               } else {
//                                                 if (context.mounted) {
//                                                   customErrorDialog(
//                                                     context,
//                                                     'Invalid!!',
//                                                     'Fill the form properly to proceed',
//                                                   );
//                                                 }
//                                                 // errorDialog(
//                                                 //     context,
//                                                 //     'Invalid!!',
//                                                 //     'Fill the form properly to proceed');
//                                                 // Get.snackbar(
//                                                 //   "Invalid",
//                                                 //   "Fill the form properly to proceed",
//                                                 //   animationDuration:
//                                                 //       const Duration(
//                                                 //           seconds: 1),
//                                                 //   backgroundColor: Colors.red,
//                                                 //   colorText: Colors.white,
//                                                 //   snackPosition:
//                                                 //       SnackPosition.BOTTOM,
//                                                 // );
//                                               }
//                                             },
//                                             child: const Text(
//                                               'Activate DVA',
//                                               textAlign: TextAlign.center,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: 30,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           // Text(
//                           //   "Choose New Username",
//                           //   style: TextStyle(
//                           //     fontSize: 20.0,
//                           //     fontFamily: "DefaultFontFamily",
//                           //     letterSpacing: 1.0,
//                           //     color: Theme.of(context).primaryColor,
//                           //   ),
//                           // ),
//                           // const SizedBox(
//                           //   height: 20,
//                           // ),
//                           // username,
//                           // const SizedBox(
//                           //   height: 5,
//                           // ),
//                           // Text(
//                           //   _mssg,
//                           //   style: TextStyle(
//                           //     fontSize: 14.0,
//                           //     fontFamily: "DefaultFontFamily",
//                           //     letterSpacing: 0.5,
//                           //     color: (_mssg == "username is available.")
//                           //         ? Theme.of(context).primaryColor
//                           //         : Colors.red,
//                           //   ),
//                           // ),
//                           // const SizedBox(
//                           //   height: 40,
//                           // ),
//                           // GFButton(
//                           //   onPressed: () {
//                           //     if (bvnformKey.currentState!.validate()) {
//                           //       // createNewDVA();
//                           //       doSommething();
//                           //     } else {
//                           //       Get.snackbar(
//                           //         "Invalid",
//                           //         "Fill the form properly to proceed",
//                           //         animationDuration: const Duration(seconds: 1),
//                           //         backgroundColor: Colors.red,
//                           //         colorText: Colors.white,
//                           //         snackPosition: SnackPosition.BOTTOM,
//                           //       );
//                           //     }
//                           //   },
//                           //   shape: GFButtonShape.pills,
//                           //   fullWidthButton: true,
//                           //   color: brandOne,
//                           //   child: const Text(
//                           //     'Activate DVA',
//                           //     style: TextStyle(
//                           //       color: Colors.white,
//                           //       fontSize: 13,
//                           //       fontFamily: "DefaultFontFamily",
//                           //     ),
//                           //   ),
//                           // ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 )
//               : Container(
//                   height: double.infinity,
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                       // image: DecorationImage(
//                       //     image: AssetImage("assets/icons/RentSpace-icon.png"),
//                       //     fit: BoxFit.cover,
//                       //     opacity: 0.1),
//                       ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       // const SizedBox(
//                       //   height: 50,
//                       // ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "Creating DVA...",
//                             style: GoogleFonts.nunito(
//                               fontSize: 20,
//                               // fontFamily: "DefaultFontFamily",
//                               color: Theme.of(context).primaryColor,
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 30,
//                           ),
//                         ],
//                       ),
//                       // const SizedBox(
//                       //   height: 10,
//                       // ),
//                       // const CircularProgressIndicator(
//                       //   color: brandOne,
//                       // ),
//                       Lottie.asset(
//                         'assets/loader.json',
//                         width: 100,
//                         height: 100,
//                       ),
//                     ],
//                   ),
//                 ),
//         ],
//       ),
//     );
//   }
// }
