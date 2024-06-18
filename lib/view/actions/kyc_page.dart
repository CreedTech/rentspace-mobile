// import 'package:animated_custom_dropdown/custom_dropdown.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:rentspace/constants/colors.dart';
// import 'package:get/get.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:io';
// import 'package:path/path.dart' as p;
// import 'package:rentspace/constants/db/firebase_db.dart';
// import 'package:rentspace/constants/icons.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// // import 'package:firebase_storage/firebase_storage.dart';
// import 'package:rentspace/controller/user_controller.dart';
// import 'package:rentspace/view/actions/add_card.dart';

// import 'dart:math';
// import 'package:intl/intl.dart' as intl;
// import 'package:intl/intl.dart';
// import 'dart:async';

// import 'package:rentspace/view/actions/fund_wallet.dart';
// import 'package:rentspace/view/actions/onboarding_page.dart';
// import 'package:rentspace/view/dashboard/dashboard.dart';
// import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';

// import '../../constants/widgets/custom_dialog.dart';
// import '../../constants/widgets/custom_loader.dart';
// import '../home_page.dart';
// import 'bvn_and_kyc_confirm_page.dart';

// String _IDImage = "";

// class KycPage extends StatefulWidget {
//   String bvnValue;
//   KycPage({super.key, required this.bvnValue});

//   @override
//   _KycPageState createState() => _KycPageState();
// }

// final TextEditingController _kycController = TextEditingController();
// final TextEditingController kycController = TextEditingController();
// final _kycformKey = GlobalKey<FormState>();
// bool _isUploading = false;

// List<String> item = const <String>[
//   'NIN',
//   'Driver\'s Liscense',
//   'Passport Photograph',
//   'Voters Card',
//   // 'Friends',
// ];

// class _KycPageState extends State<KycPage> {
// //upload image
//   File? selectedImage;
//   PlatformFile? _platformFile;
//   Future selectFile(context) async {
//     final file = await FilePicker.platform.pickFiles(
//         type: FileType.custom, allowedExtensions: ['png', 'jpg', 'jpeg']);

//     if (file != null) {
//       setState(() {
//         selectedImage = File(file.files.single.path!);
//         _platformFile = file.files.first;
//       });
//       uploadImg(context);
//     }
//   }

//   Future uploadImg(context) async {
//     setState(() {
//       _isUploading = true;
//     });
//     var userIdUpdate = FirebaseFirestore.instance.collection('accounts');
//     print('userIdUpdate');
//     print(userIdUpdate);

//     FirebaseStorage storage = FirebaseStorage.instance;
//     print('storage');
//     print(storage);
//     String fileName = p.basename(selectedImage!.path);
//     print('fileName');
//     print(fileName);
//     Reference ref = storage.ref().child(fileName);
//     UploadTask uploadTask = ref.putFile(selectedImage!);
//     var downloadURL =
//         await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
//     var url = downloadURL.toString();
//     await userIdUpdate.doc(userId).update({
//       'id_card': url,
//     }).then((value) {
//       setState(() {
//         _IDImage = url.toString();
//         _isUploading = false;
//       });

//       showTopSnackBar(
//         Overlay.of(context),
//         CustomSnackBar.success(
//           backgroundColor: brandOne,
//           message: 'Your ID card image has been uploaded successfully!!',
//           textStyle: GoogleFonts.lato(
//             fontSize: 14,
//             color: Colors.white,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       );
//     }).catchError((error) {
//       print(error.toString());
//       customErrorDialog(context, 'Error', error.toString());
//     });
//   }

//   //Phone number
//   @override
//   initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final kyc = TextFormField(
//       enableSuggestions: true,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       cursorColor: Theme.of(context).primaryColor,
//       controller: _kycController,
//       style: GoogleFonts.lato(
//         color: Theme.of(context).primaryColor,
//       ),
//       keyboardType: TextInputType.multiline,
//       decoration: InputDecoration(
//         // label: Text(
//         //   "KYC : residential address",
//         //   style: GoogleFonts.lato(
//         //     color: Colors.grey,
//         //     fontSize: 12,
//         //     fontWeight: FontWeight.w400,
//         //   ),
//         // ),
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
//               color: Colors.red, width: 1.0), // Change color to yellow
//         ),
//         filled: false,
//         contentPadding: const EdgeInsets.all(14),
//         fillColor: brandThree,
//         hintText: 'Enter your KYC : residential address...',
//         hintStyle: GoogleFonts.lato(
//           color: Colors.grey,
//           fontSize: 12,
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//       minLines: 3,
//       maxLines: 5,
//       maxLength: 200,
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Address cannot be empty cannot be empty';
//         }

//         return null;
//       },
//     );

// // final kyc_select_dropdown = DropdownButtonFormField(items: items, onChanged: onChanged)
//     return ModalProgressHUD(
//       inAsyncCall: _isUploading,
//       progressIndicator: const Center(
//         child: CustomLoader(),
//       ),
//       child: Scaffold(
//         backgroundColor: Theme.of(context).canvasColor,
//         appBar: AppBar(
//           backgroundColor: Theme.of(context).canvasColor,
//           elevation: 0.0,
//           leading: GestureDetector(
//             onTap: () {
//               Get.back();
//             },
//             child: Icon(
//               Icons.arrow_back,
//               size: 30,
//               color: Theme.of(context).primaryColor,
//             ),
//           ),
//           centerTitle: true,
//           title: Text(
//             'KYC Details',
//             style: GoogleFonts.lato(
//               color: Theme.of(context).primaryColor,
//               fontSize: 16,
//             ),
//           ),
//         ),
//         body: Stack(
//           children: [
//             ListView(
//               children: [
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Form(
//                         key: _kycformKey,
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(
//                                 top: 12,
//                                 bottom: 12,
//                               ),
//                               child: Container(
//                                 alignment: Alignment.topLeft,
//                                 child: Text(
//                                   'Select Your ID verification Type',
//                                   style: GoogleFonts.lato(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500,
//                                     color: Theme.of(context).primaryColor,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             CustomDropdown(
//                               selectedStyle:
//                                   GoogleFonts.lato(color: brandOne),
//                               hintText: 'Select an option?',
//                               fillColor: brandThree,
//                               items: item,
//                               controller: kycController,
//                               fieldSuffixIcon: Icon(
//                                 Iconsax.arrow_down5,
//                                 size: 25.h,
//                                 color: brandOne,
//                               ),
//                               onChanged: (String val) {
//                                 print(val);
//                               },
//                             ),
//                             // kyc,
//                             const SizedBox(
//                               height: 20,
//                             ),
//                           ],
//                         ),
//                       ),

//                       Text(
//                         "Provide your national identity information. Make sure your face is properly shown on the ID card. Image upload dimension should be 800px x 500px.",
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.lato(
//                           fontSize: 14,
//                           color: Theme.of(context).primaryColor,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),

//                       InkWell(
//                         onTap: () {
//                           showDialog(
//                               context: context,
//                               barrierDismissible: true,
//                               builder: (BuildContext context) {
//                                 return Column(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     AlertDialog.adaptive(
//                                       contentPadding: const EdgeInsets.fromLTRB(
//                                           30, 30, 30, 20),
//                                       elevation: 0,
//                                       alignment: Alignment.bottomCenter,
//                                       insetPadding: const EdgeInsets.all(0),
//                                       scrollable: true,
//                                       title: null,
//                                       shape: const RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(30),
//                                           topRight: Radius.circular(30),
//                                         ),
//                                       ),
//                                       content: SizedBox(
//                                         child: SizedBox(
//                                           width: 400.w,
//                                           child: Column(
//                                             children: [
//                                               Padding(
//                                                 padding: EdgeInsets.symmetric(
//                                                     vertical: 40.h),
//                                                 child: Column(
//                                                   children: [
//                                                     Padding(
//                                                       padding:
//                                                           EdgeInsets.symmetric(
//                                                               vertical: 15.h),
//                                                       child: Align(
//                                                         alignment:
//                                                             Alignment.topCenter,
//                                                         child: Text(
//                                                           'Upload Valid Id Card',
//                                                           style: GoogleFonts
//                                                               .lato(
//                                                             color: brandOne,
//                                                             fontSize: 16,
//                                                             fontWeight:
//                                                                 FontWeight.w500,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Padding(
//                                                       padding: const EdgeInsets
//                                                           .symmetric(
//                                                           vertical: 10),
//                                                       child: Column(
//                                                         children: [
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .all(3),
//                                                             child:
//                                                                 ElevatedButton(
//                                                               onPressed: () {
//                                                                 selectFile(
//                                                                     context);
//                                                               },
//                                                               style:
//                                                                   ElevatedButton
//                                                                       .styleFrom(
//                                                                 minimumSize:
//                                                                     const Size(
//                                                                         200,
//                                                                         50),
//                                                                 maximumSize:
//                                                                     const Size(
//                                                                         200,
//                                                                         50),
//                                                                 backgroundColor:
//                                                                     brandOne,
//                                                                 shape:
//                                                                     RoundedRectangleBorder(
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               8),
//                                                                 ),
//                                                                 textStyle:
//                                                                     const GoogleFonts.lato(
//                                                                         color:
//                                                                             brandFour,
//                                                                         fontSize:
//                                                                             13),
//                                                               ),
//                                                               child: Row(
//                                                                 mainAxisAlignment:
//                                                                     MainAxisAlignment
//                                                                         .center,
//                                                                 children: [
//                                                                   const Icon(
//                                                                     Iconsax
//                                                                         .folder_open,
//                                                                   ),
//                                                                   const SizedBox(
//                                                                     width: 10,
//                                                                   ),
//                                                                   Text(
//                                                                     "Open File",
//                                                                     style:
//                                                                         GoogleFonts.lato(
//                                                                       color: Colors
//                                                                           .white,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w500,
//                                                                       fontSize:
//                                                                           12,
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           const SizedBox(
//                                                             height: 10,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     )
//                                   ],
//                                 );
//                               });

//                           // showDialog(context: context, builder: (_){

//                           // });
//                         },
//                         child: selectedImage == null
//                             ? DottedBorder(
//                                 borderType: BorderType.RRect,
//                                 radius: const Radius.circular(10),
//                                 dashPattern: const [10, 4],
//                                 strokeCap: StrokeCap.round,
//                                 color: Theme.of(context).colorScheme.secondary,
//                                 child: Container(
//                                   width: double.infinity,
//                                   height: 150,
//                                   padding:
//                                       const EdgeInsets.fromLTRB(20, 10, 20, 10),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         Iconsax.folder_open,
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .secondary,
//                                         size: 40,
//                                       ),
//                                       const SizedBox(
//                                         height: 10,
//                                       ),
//                                       Text(
//                                         "Select You File [ jpg, png, jpeg ]",
//                                         style: GoogleFonts.lato(
//                                           color: Theme.of(context).primaryColor,
//                                           fontSize: 12,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             : Container(
//                                 padding: const EdgeInsets.all(20),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Selected File',
//                                       style: GoogleFonts.lato(
//                                         color: Colors.grey.shade400,
//                                         fontSize: 15,
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                     Container(
//                                         padding: const EdgeInsets.all(8),
//                                         decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                             color: Colors.white,
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: Colors.grey.shade200,
//                                                 offset: const Offset(0, 1),
//                                                 blurRadius: 3,
//                                                 spreadRadius: 2,
//                                               )
//                                             ]),
//                                         child: Row(
//                                           children: [
//                                             ClipRRect(
//                                                 borderRadius:
//                                                     BorderRadius.circular(8),
//                                                 child: Image.file(
//                                                   selectedImage!,
//                                                   width: 70,
//                                                 )),
//                                             const SizedBox(
//                                               width: 10,
//                                             ),
//                                             Expanded(
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     _platformFile!.name,
//                                                     style: GoogleFonts.lato(
//                                                       fontSize: 13,
//                                                       color:
//                                                           Colors.grey.shade800,
//                                                     ),
//                                                   ),
//                                                   const SizedBox(
//                                                     height: 5,
//                                                   ),
//                                                   Text(
//                                                     '${(_platformFile!.size / 1024).ceil()} KB',
//                                                     style: GoogleFonts.lato(
//                                                       fontSize: 13,
//                                                       color:
//                                                           Colors.grey.shade800,
//                                                     ),
//                                                   ),
//                                                   const SizedBox(
//                                                     height: 5,
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             const SizedBox(
//                                               width: 10,
//                                             ),
//                                           ],
//                                         )),
//                                     const SizedBox(
//                                       height: 20,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                       ),
//                       // selectedImage != null
//                       //     ? Container(
//                       //         padding: const EdgeInsets.all(20),
//                       //         child: Column(
//                       //           crossAxisAlignment: CrossAxisAlignment.start,
//                       //           children: [
//                       //             Text(
//                       //               'Selected File',
//                       //               style: GoogleFonts.lato(
//                       //                 color: Colors.grey.shade400,
//                       //                 fontSize: 15,
//                       //               ),
//                       //             ),
//                       //             const SizedBox(
//                       //               height: 10,
//                       //             ),
//                       //             Container(
//                       //                 padding: const EdgeInsets.all(8),
//                       //                 decoration: BoxDecoration(
//                       //                   borderRadius: BorderRadius.circular(10),
//                       //                   color: Colors.white,
//                       //                   boxShadow: [
//                       //                     BoxShadow(
//                       //                       color: Colors.grey.shade200,
//                       //                       offset: const Offset(0, 1),
//                       //                       blurRadius: 3,
//                       //                       spreadRadius: 2,
//                       //                     )
//                       //                   ],
//                       //                 ),
//                       //                 child: Row(
//                       //                   children: [
//                       //                     ClipRRect(
//                       //                         borderRadius:
//                       //                             BorderRadius.circular(8),
//                       //                         child: Image.file(
//                       //                           selectedImage!,
//                       //                           width: 70,
//                       //                         )),
//                       //                     const SizedBox(
//                       //                       width: 10,
//                       //                     ),
//                       //                     Expanded(
//                       //                       child: Column(
//                       //                         crossAxisAlignment:
//                       //                             CrossAxisAlignment.start,
//                       //                         children: [
//                       //                           Text(
//                       //                             _platformFile!.name,
//                       //                             style: GoogleFonts.lato(
//                       //                               fontSize: 13,
//                       //                               color: Colors.grey.shade800,
//                       //                             ),
//                       //                           ),
//                       //                           const SizedBox(
//                       //                             height: 5,
//                       //                           ),
//                       //                           Text(
//                       //                             '${(_platformFile!.size / 1024).ceil()} KB',
//                       //                             style: GoogleFonts.lato(
//                       //                               fontSize: 13,
//                       //                               color: Colors.grey.shade800,
//                       //                             ),
//                       //                           ),
//                       //                           const SizedBox(
//                       //                             height: 5,
//                       //                           ),
//                       //                         ],
//                       //                       ),
//                       //                     ),
//                       //                     const SizedBox(
//                       //                       width: 10,
//                       //                     ),
//                       //                   ],
//                       //                 )),
//                       //             const SizedBox(
//                       //               height: 20,
//                       //             ),
//                       //           ],
//                       //         ))
//                       //     : Container(),
//                       // const SizedBox(
//                       //   height: 40,
//                       // ),

//                       // const SizedBox(
//                       //   height: 30,
//                       // ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Positioned(
//               bottom: 50,
//               left: 0,
//               right: 0,
//               child: Center(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30),
//                   child: Container(
//                     // width: MediaQuery.of(context).size.width * 2,
//                     alignment: Alignment.center,
//                     // height: 110.h,
//                     child: Column(
//                       children: [
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             minimumSize: const Size(400, 50),
//                             backgroundColor:
//                                 Theme.of(context).colorScheme.secondary,
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(
//                                 10,
//                               ),
//                             ),
//                           ),
//                           onPressed: () {
//                             if (_kycformKey.currentState!.validate() &&
//                                 _IDImage != "") {
//                               Get.to(BvnAndKycConfirmPage(
//                                   bvnValue: widget.bvnValue,
//                                   kycValue: _kycController.text.trim(),
//                                   idCardValue: _IDImage));
//                             } else {
//                               customErrorDialog(context, 'Error',
//                                   'Please fill in your KYC correctly and upload a valid ID card image to verify.');
//                             }
//                           },
//                           child: const Text(
//                             'Next',
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
