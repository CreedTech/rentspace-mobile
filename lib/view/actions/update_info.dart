// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart' as intl;
// import 'package:intl/intl.dart';
// import 'package:rentspace/constants/widgets/custom_dialog.dart';
// import 'package:rentspace/view/dva/create_dva.dart';
// import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';

// import '../../constants/colors.dart';
// import '../../constants/db/firebase_db.dart';
// import '../../constants/widgets/custom_loader.dart';
// import '../../controller/user_controller.dart';

// class UpdateUserInfo extends StatefulWidget {
//   const UpdateUserInfo({super.key});

//   @override
//   State<UpdateUserInfo> createState() => _UpdateUserInfoState();
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

// class _UpdateUserInfoState extends State<UpdateUserInfo> {
//   final UserController userController = Get.find();
//   final form = intl.NumberFormat.decimalPattern();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String collectionName = 'dva';

//   DateTime selectedDate = DateTime.now();
//   TextEditingController dateController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();
//   final updateInfoFormKey = GlobalKey<FormState>();
//   final int minimumAge = 18;
//   String? selectedGender;
//   late int genderValue;

//   updateUserInfo() async {
//     try {
//       EasyLoading.show(
//         indicator: const CustomLoader(),
//         maskType: EasyLoadingMaskType.black,
//         dismissOnTap: false,
//       );

//       var accountUpdate = FirebaseFirestore.instance.collection('accounts');
//       await accountUpdate.doc(userId).update({
//         'dva_username': _usernameController.text.trim(),
//         'gender': genderValue.toString(),
//         'date_of_birth': dateController.text,
//         'address': _addressController.text,
//         "activities": FieldValue.arrayUnion(
//           [
//             "$formattedDate \nAccount Info Updated",
//           ],
//         ),
//       });

//       EasyLoading.dismiss(); // Dismiss the loading indicator on success
//       if (!context.mounted) return;
//       showDialog(
//           context: context,
//           barrierDismissible: true,
//           builder: (BuildContext context) {
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 AlertDialog.adaptive(
//                   contentPadding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
//                   elevation: 0,
//                   alignment: Alignment.bottomCenter,
//                   insetPadding: const EdgeInsets.all(0),
//                   scrollable: true,
//                   title: null,
//                   shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                   ),
//                   content: SizedBox(
//                     child: SizedBox(
//                       width: 400,
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 40),
//                             child: Column(
//                               children: [
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 15),
//                                   child: Align(
//                                     alignment: Alignment.topCenter,
//                                     child: Text(
//                                       'Information updated Successfully!!',
//                                       style: GoogleFonts.poppins(
//                                         color: brandTwo,
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 10),
//                                   child: Column(
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.all(3),
//                                         child: ElevatedButton(
//                                           onPressed: () {
//                                             // Get.to(
//                                             //     const FundWallet());
//                                             Get.to(const CreateDVA());
//                                           },
//                                           style: ElevatedButton.styleFrom(
//                                             minimumSize: const Size(200, 50),
//                                             maximumSize: const Size(300, 50),

//                                             backgroundColor: brandTwo,
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                             ),
//                                             // padding: const EdgeInsets
//                                             //     .symmetric(
//                                             //     horizontal:
//                                             //         50,
//                                             //     vertical:
//                                             //         10),
//                                             textStyle: const TextStyle(
//                                                 color: brandFour, fontSize: 13),
//                                           ),
//                                           child: const Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               // Icon(Iconsax
//                                               //     .card),
//                                               SizedBox(
//                                                 width: 10,
//                                               ),
//                                               Text(
//                                                 "Next",
//                                                 style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontWeight: FontWeight.w700,
//                                                   fontSize: 16,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         height: 10,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             );
//           });
//     } catch (error) {
//       EasyLoading.dismiss(); // Dismiss the loading indicator on error

//       int startBracketIndex = error.toString().indexOf('[');
//       int endBracketIndex = error.toString().indexOf(']');
//       String nError = "";
//       if (startBracketIndex != -1 && endBracketIndex != -1) {
//         nError = error.toString().substring(0, startBracketIndex) +
//             error.toString().substring(endBracketIndex + 1);
//       } else {
//         nError = error.toString();
//       }

//       if (!context.mounted) return;

//       showTopSnackBar(
//         Overlay.of(context),
//         CustomSnackBar.error(
//           // backgroundColor: brandOne,
//           message: nError,
//           textStyle: GoogleFonts.poppins(
//             fontSize: 14,
//             color: Colors.white,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       );
//     }
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
//   Widget build(BuildContext context) {
//     validateAddress(address) {
//       if (address.isEmpty) {
//         return 'Address cannot be empty';
//       }

//       return null;
//     }

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

//     Future<void> _selectDate(BuildContext context) async {
//       final DateTime? picked = await showDatePicker(
//           initialEntryMode: DatePickerEntryMode.calendarOnly,
//           context: context,
//           builder: (context, child) {
//             return Theme(
//               data: Theme.of(context).copyWith(
//                 colorScheme: const ColorScheme.dark(
//                   primaryContainer: brandTwo,
//                   primary: brandTwo, // header background color
//                   onPrimary: Colors.white,
//                   onBackground: brandTwo,
//                   // onSecondary: brandTwo,

//                   outline: brandTwo,
//                   background: brandTwo,
//                   onSurface: brandTwo, // body text color
//                 ),
//                 textButtonTheme: TextButtonThemeData(
//                   style: TextButton.styleFrom(
//                     foregroundColor: brandTwo, // button text color
//                   ),
//                 ),
//               ),
//               child: child!,
//             );
//           },
//           initialDate: selectedDate,
//           firstDate: DateTime(1900),
//           lastDate: DateTime.now());
//       if (picked != null && picked != selectedDate) {
//         final int age = DateTime.now().year - picked.year;
//         if (age < minimumAge) {
//           // Show an error message or handle the validation as needed.
//           if (!context.mounted) return;
//           showTopSnackBar(
//             Overlay.of(context),
//             CustomSnackBar.error(
//               // backgroundColor: brandOne,
//               message: 'Error! :(. Age must be at least $minimumAge years.',
//               textStyle: GoogleFonts.poppins(
//                 fontSize: 14,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           );
//         } else {
//           setState(() {
//             selectedDate = picked;
//             dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
//           });
//         }
//       }
//     }

//     final dob = TextFormField(
//       controller: dateController,
//       cursorColor: Colors.black,
//       style: const TextStyle(
//         color: Colors.black,
//       ),
//       readOnly: true,
//       onTap: () => _selectDate(context),
//       decoration: InputDecoration(
//         labelText: 'Date of Birth',
//         labelStyle: GoogleFonts.poppins(
//           color: Colors.grey,
//           fontSize: 12,
//           fontWeight: FontWeight.w400,
//         ),
//         suffixIcon: const Icon(
//           Icons.calendar_today,
//           color: brandOne,
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
//               color: Colors.red, width: 2.0), // Change color to yellow
//         ),
//         filled: false,
//         contentPadding: const EdgeInsets.all(14),
//       ),
//     );

//     final address = TextFormField(
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       enableSuggestions: true,
//       cursorColor: Colors.black,
//       style: const TextStyle(
//         color: Colors.black,
//       ),

//       minLines: 3,
//       keyboardType: TextInputType.multiline,
//       controller: _addressController,
//       maxLines: null,
//       decoration: InputDecoration(
//         label: Text(
//           "Enter your address",
//           style: GoogleFonts.poppins(
//             color: Colors.grey,
//             fontSize: 12,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         hintText: 'Enter your address...',
//         hintStyle: GoogleFonts.poppins(
//           color: Colors.grey,
//           fontSize: 12,
//           fontWeight: FontWeight.w400,
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
//               color: Colors.red, width: 2.0), // Change color to yellow
//         ),
//         filled: false,
//         contentPadding: const EdgeInsets.all(14),
//       ),
//       validator: validateAddress,
//       // labelText: 'Email Address',
//     );

//     final gender = DropdownButtonFormField(
//       style: GoogleFonts.poppins(
//         color: brandOne,
//         fontSize: 16,
//         fontWeight: FontWeight.w600,
//       ),
//       items: ['Male', 'Female', 'Other']
//           .map((value) => DropdownMenuItem(
//                 value: value,
//                 child: Text(value),
//               ))
//           .toList(),
//       value: selectedGender,
//       onChanged: (String? newValue) {
//         setState(() {
//           selectedGender = newValue!;
//           genderValue = selectedGender == 'Male' ? 1 : 2;
//         });
//         print(genderValue);
//       },
//       decoration: InputDecoration(
//         hintText: 'Choose Gender',
//         hintStyle: GoogleFonts.poppins(
//           color: Colors.grey,
//           fontSize: 12,
//           fontWeight: FontWeight.w400,
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
//               color: Colors.red, width: 2.0), // Change color to yellow
//         ),
//         contentPadding: const EdgeInsets.all(14),
//       ),
//     );

//     final username = TextFormField(
//       enableSuggestions: true,
//       cursorColor: Colors.black,
//       controller: _usernameController,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       style: const TextStyle(
//         color: Colors.black,
//       ),
//       keyboardType: TextInputType.text,
//       validator: validateUsername,
//       onChanged: (e) {
//         if (_usernameController.text.trim().length >= 7) {
//           checkUserNameValidity();
//         }
//       },
//       maxLength: 10,
//       decoration: InputDecoration(
//         label: Text(
//           "Choose new username",
//           style: GoogleFonts.poppins(
//             color: Colors.grey,
//             fontSize: 12,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         prefixText: "SPACER/",
//         prefixStyle: GoogleFonts.poppins(
//           color: Colors.grey,
//           fontSize: 13,
//           fontWeight: FontWeight.w400,
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
//               color: Colors.red, width: 2.0), // Change color to yellow
//         ),
//         filled: false,
//         contentPadding: const EdgeInsets.all(14),
//         hintText: 'can contain letters and numbers',
//         hintStyle: GoogleFonts.poppins(
//           color: Colors.grey,
//           fontSize: 12,
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//     );

//     @override
//     initState() {
//       super.initState();
//       _usernameController.clear();
//       setState(() {
//         _mssg = "";
//         // vNum = "";
//         vName = "";
//       });
//     }

//     return Scaffold(
//       backgroundColor: Theme.of(context).canvasColor,
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).canvasColor,
//         elevation: 0.0,
//         automaticallyImplyLeading: false,
//         // leading: GestureDetector(
//         //   onTap: () {
//         //     Get.back();
//         //   },
//         //   child: const Icon(
//         //     Icons.arrow_back,
//         //     size: 25,
//         //     color: Color(0xff4E4B4B),
//         //   ),
//         // ),
//         title: const Text(
//           'Update Your Information',
//           style: TextStyle(
//             color: Color(0xff4E4B4B),
//             fontWeight: FontWeight.w700,
//             fontSize: 16,
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 3),
//                     child: Text(
//                       'Update Your Info to Link your BVN',
//                       style: GoogleFonts.poppins(
//                         color: Colors.black,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 16,
//                         // fontFamily: "DefaultFontFamily",
//                       ),
//                     ),
//                   ),
//                   Form(
//                     key: updateInfoFormKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(
//                           height: 30,
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 3),
//                               child: Text(
//                                 'User Name',
//                                 style: GoogleFonts.poppins(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 16,
//                                   // fontFamily: "DefaultFontFamily",
//                                 ),
//                               ),
//                             ),
//                             username,
//                             Text(
//                               _mssg,
//                               style: GoogleFonts.poppins(
//                                 fontSize: 14.0,
//                                 // fontFamily: "DefaultFontFamily",
//                                 // letterSpacing: 0.5,
//                                 color: (_mssg == "username is available.")
//                                     ? Theme.of(context).primaryColor
//                                     : Colors.red,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 3),
//                               child: Text(
//                                 'Date Of Birth',
//                                 style: GoogleFonts.poppins(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 16,
//                                   // fontFamily: "DefaultFontFamily",
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         dob,
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 3),
//                               child: Text(
//                                 'Residential Address',
//                                 style: GoogleFonts.poppins(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 16,
//                                   // fontFamily: "DefaultFontFamily",
//                                 ),
//                               ),
//                             ),
//                             address,
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 3),
//                               child: Text(
//                                 'Gender',
//                                 style: GoogleFonts.poppins(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 16,
//                                   // fontFamily: "DefaultFontFamily",
//                                 ),
//                               ),
//                             ),
//                             gender,
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         const SizedBox(
//                           height: 50,
//                         ),
//                         Align(
//                           alignment: Alignment.bottomCenter,
//                           child: Container(
//                             // width: MediaQuery.of(context).size.width * 2,
//                             alignment: Alignment.center,
//                             // height: 110.h,
//                             child: Column(
//                               children: [
//                                 ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     minimumSize: const Size(300, 50),
//                                     backgroundColor: brandTwo,
//                                     elevation: 0,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(
//                                         10,
//                                       ),
//                                     ),
//                                   ),
//                                   onPressed: () {
//                                     // _doSomething();
//                                     if (updateInfoFormKey.currentState!
//                                         .validate()) {
//                                       // createNewDVA();
//                                       updateUserInfo();
//                                     } else {
//                                       customErrorDialog(
//                                           context, 'Invalid', 'Fill the form properly to proceed');
//                                       // Get.snackbar(
//                                       //   "Invalid",
//                                       //   "Fill the form properly to proceed",
//                                       //   animationDuration:
//                                       //       const Duration(seconds: 1),
//                                       //   backgroundColor: Colors.red,
//                                       //   colorText: Colors.white,
//                                       //   snackPosition: SnackPosition.BOTTOM,
//                                       // );
//                                     }
//                                   },
//                                   child: Text(
//                                     'Continue',
//                                     textAlign: TextAlign.center,
//                                     style: GoogleFonts.poppins(
//                                       color: Colors.white,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w700,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
