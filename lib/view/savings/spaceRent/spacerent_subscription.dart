// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:rentspace/constants/colors.dart';
// import 'package:rentspace/controller/app_controller.dart';
// import 'package:rentspace/controller/auth/user_controller.dart';
// import 'package:rentspace/view/terms_and_conditions.dart';
// import 'package:rounded_loading_button/rounded_loading_button.dart';
// import 'package:intl/intl.dart';
// import 'package:rentspace/view/savings/spaceRent/spacerent_payment.dart';
// import 'dart:math';
// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rentspace/constants/db/firebase_db.dart';
// import 'package:pattern_formatter/pattern_formatter.dart';

// import '../../../constants/widgets/custom_dialog.dart';

// class RentSpaceSubscription extends ConsumerStatefulWidget {
//   const RentSpaceSubscription({Key? key}) : super(key: key);

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _RentSpaceSubscriptionState();
// }

// var ch8t = NumberFormat.simpleCurrency(name: 'NGN');
// var varValue = "".obs;
// final _history = [];
// String _userFirst = '';
// String _userLast = '';
// String _userAddress = '';
// String _userMail = '';
// String _hasCalculate = 'true';
// String _hasCreated = 'false';
// String _canShowRent = 'false';
// double _dailyPaymentamount = 0.0;
// // String _userID = '';
// String _id = '';
// String _rentSpaceID = '';
// String _amountValue = "";
// double _rentValue = 0.0;
// double _rentSeventy = 0.0;
// int _daysDifference = 1;
// double _rentThirty = 0.0;
// double _holdingFee = 0.0;
// //savings goals
// double _dailyValue = 0.0;
// double _weeklyValue = 0.0;
// double _monthlyValue = 0.0;
// const _chars = '1234567890';
// Random _rnd = Random();
// var now = DateTime.now();
// var formatter = DateFormat('yyyy-MM-dd');
// String formattedDate = formatter.format(now);

// final TextEditingController _rentAmountController = TextEditingController();
// final TextEditingController _rentAmountOldController = TextEditingController();

// final RoundedLoadingButtonController _dailyController =
//     RoundedLoadingButtonController();
// final RoundedLoadingButtonController _weeklyController =
//     RoundedLoadingButtonController();
// final RoundedLoadingButtonController _monthlyController =
//     RoundedLoadingButtonController();

// final RoundedLoadingButtonController _dailyModalController =
//     RoundedLoadingButtonController();
// final RoundedLoadingButtonController _weeklyModalController =
//     RoundedLoadingButtonController();
// final RoundedLoadingButtonController _monthlyModalController =
//     RoundedLoadingButtonController();

// class _RentSpaceSubscriptionState extends ConsumerState<RentSpaceSubscription> {
//   final UserController userController = Get.find();
//   DateTime _endDate = DateTime.now();

//   // Future<void> _selectEndDate(BuildContext context, rent) async {
//   //   final DateTime? picked = await showDatePicker(
//   //       context: context,
//   //       initialEntryMode: DatePickerEntryMode.calendarOnly,
//   //       builder: (context, child) {
//   //         return Theme(
//   //           data: Theme.of(context).copyWith(
//   //             colorScheme: const ColorScheme.dark(
//   //               primaryContainer: brandTwo,
//   //               primary: brandTwo, // header background color
//   //               onPrimary: Colors.white,
//   //               onBackground: brandTwo,
//   //               // onSecondary: brandTwo,

//   //               outline: brandTwo,
//   //               background: brandTwo,
//   //               onSurface: brandTwo, // body text color
//   //             ),
//   //             textButtonTheme: TextButtonThemeData(
//   //               style: TextButton.styleFrom(
//   //                 foregroundColor: brandTwo, // button text color
//   //               ),
//   //             ),
//   //           ),
//   //           child: child!,
//   //         );
//   //       },
//   //       initialDate: DateTime.now(),
//   //       firstDate: DateTime.now(),
//   //       lastDate: DateTime(2030));
//   //   if (picked != null &&
//   //       picked != DateTime.now() &&
//   //       !picked.difference(DateTime.now()).inDays.isNaN) {
//   //     setState(() {
//   //       _endDate = picked;
//   //       calculateRent(rent);
//   //       _canShowRent = 'true';
//   //     });
//   //   }
//   // }

//   int _calculateMonthsDifference() {
//     final differenceMonths = _endDate
//             .add(const Duration(days: 1))
//             .difference(DateTime.now())
//             .inDays ~/
//         30; // Calculate difference in months

//     return differenceMonths.abs();
//   }

//   int _calculateWeeksDifference() {
//     final differenceMonths = _calculateMonthsDifference();
//     final differenceWeeks = differenceMonths * 4; // Assuming 4 weeks in a month

//     return differenceWeeks.abs();
//   }

//   String _formatWeeksDifference() {
//     final weeksDifference = _calculateWeeksDifference();
//     return '$weeksDifference weeks';
//   }

//   bool isWithinRange() {
//     int monthsDifference = _calculateMonthsDifference();
//     return monthsDifference >= 6 && monthsDifference <= 8;
//   }

//   int _calculateDaysDifference() {
//     final differenceDays =
//         _endDate.add(const Duration(days: 1)).difference(DateTime.now()).inDays;

//     return differenceDays.abs();
//   }

//   String getRandom(int length) => String.fromCharCodes(
//         Iterable.generate(
//           length,
//           (_) => _chars.codeUnitAt(
//             _rnd.nextInt(_chars.length),
//           ),
//         ),
//       );
//   getCurrentUser() async {
//     // var collection = FirebaseFirestore.instance.collection('accounts');
//     // var docSnapshot = await collection.doc(userId).get();
//     // if (docSnapshot.exists) {
//     //   Map<String, dynamic>? data = docSnapshot.data();
//     // }
//     setState(() {
//       // _userFirst = userController.userModel!.userDetails![0].firstName;
//       // _userLast = userController.userModel!.userDetails![0].lastName;
//       // _userAddress = userController.userModel!.userDetails![0].residentialAddress;
//       // _userMail = userController.userModel!.userDetails![0].email;
//       // _userID = userController.userModel!.userDetails![0].rentspaceID;
//       _id = userController.userModel!.userDetails![0].id;
//       // _rentSpaceID = getRandom(20);
//     });
//     print(_id);
//     // print(_rentSpaceID);
//   }

//   @override
//   initState() {
//     super.initState();
//     getCurrentUser();
//   }

//   // calculateRent(rent) {
//   //   print('_calculateDaysDifference()');
//   //   print(_calculateDaysDifference());
//   //   setState(() {
//   //     _rentThirty = (rent - (rent * 0.7));
//   //     _rentSeventy = (rent * 0.7);
//   //     _rentValue = rent;
//   //     _hasCalculate = 'true';
//   //     _hasCreated = 'false';
//   //     _dailyValue = ((rent * 0.7) / _calculateDaysDifference());
//   //     _weeklyValue = ((rent * 0.7) / _calculateWeeksDifference());
//   //     _monthlyValue = ((rent * 0.7) / _calculateMonthsDifference());
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final rentState = ref.watch(appControllerProvider.notifier);
// //validation function

//     validateFunc(text) {
//       if (text.isEmpty) {
//         return 'Can\'t be empty';
//       }
//       if (text.length < 1) {
//         return 'Too short';
//       }
//       if ((int.tryParse(text.trim().replaceAll(',', ''))! >= 1) &&
//           (int.tryParse(text.trim().replaceAll(',', ''))! < 5000)) {
//         return 'minimum amount is ₦5,000';
//       }
//       if (int.tryParse(text.trim().replaceAll(',', '')) == null) {
//         return 'enter valid number';
//       }
//       if (int.tryParse(text.trim().replaceAll(',', '')) == 0) {
//         return 'number cannot be zero';
//       }
//       if (int.tryParse(text.trim().replaceAll(',', ''))!.isNegative) {
//         return 'enter positive number';
//       }
//       return null;
//     }

//     //validation function
//     validateOldFunc(text) {
//       if (text.isEmpty) {
//         return 'Can\'t be empty';
//       }
//       if (text.length < 1) {
//         return 'Too short';
//       }
//       if (int.tryParse(text.trim().replaceAll(',', '')) == 0) {
//         return 'number cannot be zero';
//       }
//       if ((int.tryParse(text.trim().replaceAll(',', ''))! >= 1) &&
//           (int.tryParse(text.trim().replaceAll(',', ''))! < 1000)) {
//         return 'minimum amount is ₦1,000';
//       }
//       if (int.tryParse(text.trim().replaceAll(',', '')) == null) {
//         return 'enter valid number';
//       }
//       if (int.tryParse(text.trim().replaceAll(',', ''))!.isNegative) {
//         return 'enter positive number';
//       }
//       return null;
//     }

// ///////calculate rent
//     calculateRent(rent) {
//       print('_calculateDaysDifference()');
//       print(_calculateDaysDifference());
//       setState(() {
//         _rentThirty = (rent - (rent * 0.7));
//         _rentSeventy = (rent * 0.7);
//         _holdingFee = 0.01 * _rentSeventy;
//         _rentValue = rent;
//         _hasCalculate = 'true';
//         _hasCreated = 'false';
//         _dailyValue = ((rent * 0.7) / _calculateDaysDifference());
//         _weeklyValue = ((rent * 0.7) / _calculateWeeksDifference());
//         _monthlyValue = ((rent * 0.7) / _calculateMonthsDifference());
//       });
//     }

// /////get savingsID
//     String getRandom(int length) => String.fromCharCodes(
//           Iterable.generate(
//             length,
//             (_) => _chars.codeUnitAt(
//               _rnd.nextInt(_chars.length),
//             ),
//           ),
//         );

//     final rentAmount = TextFormField(
//       enableSuggestions: true,
//       cursorColor: Theme.of(context).primaryColor,
//       controller: _rentAmountController,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       validator: validateFunc,
//       // update the state variable when the text changes
//       onChanged: (text) {
//         setState(() {
//           _amountValue = "";
//           _rentValue = 0.0;
//           _rentSeventy = 0.0;
//           _rentThirty = 0.0;
//           _holdingFee = 0.0;
//           _hasCalculate = 'true';
//           _hasCreated = 'false';
//           _canShowRent = 'false';
//         });
//         setState(() => _amountValue = text);
//       },
//       style: GoogleFonts.nunito(
//         color: Theme.of(context).primaryColor,
//       ),
//       keyboardType: TextInputType.number,
//       inputFormatters: [ThousandsFormatter()],
//       decoration: InputDecoration(
//         label: Text(
//           "How much is your rent per year?",
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
//               color: Colors.red, width: 2.0), // Change color to yellow
//         ),
//         filled: false,
//         contentPadding: const EdgeInsets.all(14),
//         hintText: 'Rent amount in Naira',
//         hintStyle: GoogleFonts.nunito(
//           color: Colors.grey,
//           fontSize: 12,
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//     );
//     // final rentAmountOld = TextFormField(
//     //   enableSuggestions: true,
//     //   cursorColor: Theme.of(context).primaryColor,
//     //   controller: _rentAmountOldController,
//     //   autovalidateMode: AutovalidateMode.onUserInteraction,
//     //   validator: validateOldFunc,
//     //   // update the state variable when the text changes
//     //   onChanged: (text) => setState(() => _amountValue = text),
//     //   style: GoogleFonts.nunito(
//     //     color: Theme.of(context).primaryColor,
//     //   ),
//     //   inputFormatters: [ThousandsFormatter()],
//     //   keyboardType: TextInputType.number,
//     //   decoration: InputDecoration(
//     //     label: Text(
//     //       "How much of your rent is left?",
//     //       style: GoogleFonts.nunito(
//     //         color: Colors.grey,
//     //         fontSize: 12,
//     //         fontWeight: FontWeight.w400,
//     //       ),
//     //     ),
//     //     border: OutlineInputBorder(
//     //       borderRadius: BorderRadius.circular(10.0),
//     //       borderSide: const BorderSide(
//     //         color: Color(0xffE0E0E0),
//     //       ),
//     //     ),
//     //     focusedBorder: const OutlineInputBorder(
//     //       borderSide: BorderSide(color: brandOne, width: 2.0),
//     //     ),
//     //     enabledBorder: const OutlineInputBorder(
//     //       borderSide: BorderSide(
//     //         color: Color(0xffE0E0E0),
//     //       ),
//     //     ),
//     //     errorBorder: const OutlineInputBorder(
//     //       borderSide: BorderSide(
//     //           color: Colors.red, width: 2.0), // Change color to yellow
//     //     ),
//     //     filled: false,
//     //     contentPadding: const EdgeInsets.all(14),
//     //     hintText: 'Rent amount in Naira',
//     //     hintStyle: GoogleFonts.nunito(
//     //       color: Colors.grey,
//     //       fontSize: 12,
//     //       fontWeight: FontWeight.w400,
//     //     ),
//     //   ),
//     // );

//     // ignore: no_leading_underscores_for_local_identifiers
//     Future<void> _selectEndDate(BuildContext context, rent) async {
//       final DateTime? picked = await showDatePicker(
//           context: context,
//           initialEntryMode: DatePickerEntryMode.calendarOnly,
//           builder: (context, child) {
//             return Theme(
//               data: Theme.of(context).copyWith(
//                 colorScheme: const ColorScheme.dark(
//                   primaryContainer: brandOne,
//                   primary: brandOne, // header background color
//                   onPrimary: Colors.white,
//                   onBackground: brandOne,
//                   // onSecondary: brandTwo,

//                   outline: brandOne,
//                   background: brandOne,
//                   onSurface: brandOne, // body text color
//                 ),
//                 textButtonTheme: TextButtonThemeData(
//                   style: TextButton.styleFrom(
//                     foregroundColor: brandOne, // button text color
//                   ),
//                 ),
//               ),
//               child: child!,
//             );
//           },
//           initialDate: DateTime.now(),
//           firstDate: DateTime.now(),
//           lastDate: DateTime(2030));
//       if (picked != null &&
//           picked != DateTime.now() &&
//           !picked.difference(DateTime.now()).inDays.isNaN) {
//         setState(() {
//           _endDate = picked;
//           if (validateFunc(
//                   _rentAmountController.text.trim().replaceAll(',', '')) ==
//               null) {
//             calculateRent(double.tryParse(
//                 _rentAmountController.text.trim().replaceAll(',', '')));
//           } else {
//             if (context.mounted) {
//               customErrorDialog(
//                   context, 'Invalid', "Please enter valid amount to proceed.");
//             }
//           }
//           // calculateRent(rent);
//           _canShowRent = 'true';
//         });
//       }
//     }

//     return Obx(
//       () => Scaffold(
//         backgroundColor: Theme.of(context).canvasColor,
//         appBar: AppBar(
//           elevation: 0.0,
//           backgroundColor: Theme.of(context).canvasColor,
//           leading: GestureDetector(
//             onTap: () {
//               resetCalculator();
//               Get.back();
//             },
//             child: Icon(
//               Icons.close,
//               size: 30,
//               color: Theme.of(context).primaryColor,
//             ),
//           ),
//         ),
//         body: Stack(
//           children: [
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20.0, 5, 20, 5),
//               child: ListView(
//                 shrinkWrap: true,
//                 physics: const ClampingScrollPhysics(),
//                 children: [
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Center(
//                     child: Text(
//                       "We Simplified the process for you$varValue",
//                       style: GoogleFonts.nunito(
//                         fontSize: 20.sp,
//                         fontWeight: FontWeight.bold,
//                         // letterSpacing: 0.5,
//                         color: Theme.of(context).primaryColor,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   (_hasCalculate == 'true')
//                       ? Text(
//                           "$varValue",
//                           style: GoogleFonts.nunito(
//                             fontSize: 14,
//                             color: Theme.of(context).primaryColor,
//                           ),
//                         )
//                       : const Text(""),
//                   //rent amount input
//                   (_hasCalculate == 'true')
//                       ? Column(
//                           children: [
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             rentAmount,
//                             const SizedBox(
//                               height: 20,
//                             ),
//                           ],
//                         )
//                       : const Text(""),

//                   (!isWithinRange())
//                       ? const Text("")
//                       : Column(
//                           children: [
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Text(
//                               'Your rent will be due in ${_calculateDaysDifference()} days',
//                               textAlign: TextAlign.center,
//                               style: GoogleFonts.nunito(
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.w500,
//                                 color: Theme.of(context).primaryColor,
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             Text(
//                               'Your rent will be due in approximately ${_formatWeeksDifference()}',
//                               textAlign: TextAlign.center,
//                               style: GoogleFonts.nunito(
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.w500,
//                                 color: Theme.of(context).primaryColor,
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             Text(
//                               'Your rent will be due in approximately ${_calculateMonthsDifference()} months',
//                               textAlign: TextAlign.center,
//                               style: GoogleFonts.nunito(
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.w500,
//                                 color: Theme.of(context).primaryColor,
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 30,
//                             ),
//                           ],
//                         ),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                     child: Column(
//                       children: [
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             minimumSize: const Size(100, 50),
//                             backgroundColor: brandOne,
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(
//                                 10,
//                               ),
//                             ),
//                           ),
//                           onPressed: () => _selectEndDate(
//                               context,
//                               _rentAmountController.text
//                                   .trim()
//                                   .replaceAll(',', '')),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.calendar_month_outlined,
//                                 color: Colors.white,
//                                 size: 18.sp,
//                               ),
//                               const SizedBox(
//                                 width: 10,
//                               ),
//                               Text(
//                                 'Select on calendar',
//                                 textAlign: TextAlign.center,
//                                 style: GoogleFonts.nunito(
//                                   color: Colors.white,
//                                   fontSize: 14.sp,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(
//                     height: 20,
//                   ),

//                   const SizedBox(
//                     height: 20,
//                   ),

//                   (_canShowRent == 'true' &&
//                           (_rentAmountController.text
//                                   .trim()
//                                   .replaceAll(',', '')
//                                   .isNotEmpty &&
//                               validateFunc(_rentAmountController.text
//                                       .trim()
//                                       .replaceAll(',', '')) ==
//                                   null &&
//                               int.tryParse(_rentAmountController.text
//                                       .trim()
//                                       .replaceAll(',', '')) !=
//                                   null))
//                       ? (!isWithinRange())
//                           ? Builder(builder: (context) {
//                               // customErrorDialog(
//                               //     context,
//                               //     'Invalid date',
//                               //     'Date Must be within 6-11 months');
//                               return Center(
//                                 child: Text(
//                                   "Invalid date. Pick a different date (minimum of 6 months and maximum of 8 months).",
//                                   textAlign: TextAlign.center,
//                                   style: GoogleFonts.nunito(
//                                     fontSize: 12.sp,
//                                     color: Colors.red,
//                                   ),
//                                 ),
//                               );
//                             })
//                           : (_rentSeventy != 0.0)
//                               ? Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   width: MediaQuery.of(context).size.width,
//                                   padding:
//                                       const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         "",
//                                         style: GoogleFonts.nunito(
//                                           fontSize: 16,
//                                           color: Theme.of(context).primaryColor,
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         height: 50,
//                                       ),
//                                       ////////Daily payment
//                                       ElevatedButton(
//                                         style: ElevatedButton.styleFrom(
//                                           minimumSize: const Size(300, 50),
//                                           maximumSize: const Size(400, 50),
//                                           backgroundColor: brandOne,
//                                           elevation: 0,
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(
//                                               10,
//                                             ),
//                                           ),
//                                         ),
//                                         onPressed: () async {
//                                           // Timer(const Duration(seconds: 1), () {
//                                           //   _dailyModalController.stop();
//                                           // });
//                                           var userUpdate = FirebaseFirestore
//                                               .instance
//                                               .collection('accounts');
//                                           var updateRent = FirebaseFirestore
//                                               .instance
//                                               .collection('rent_space');

//                                           await updateRent.add({
//                                             // 'user_id': _userID,
//                                             'id': _id,
//                                             // 'rentspace_id': _rentSpaceID,
//                                             'date': formattedDate,
//                                             'interval_amount': _dailyValue,
//                                             'target_amount': _rentValue,
//                                             'paid_amount': 0,
//                                             'interval': 'daily',
//                                             'has_paid': 'false',
//                                             'status': 'active',
//                                             'history': _history,
//                                             'is_new': 'true',
//                                             'no_of_payments':
//                                                 _calculateDaysDifference()
//                                                     .toString(),
//                                             'current_payment': '0',
//                                             'token': ''
//                                           });
//                                           await userUpdate.doc(userId).update({
//                                             'has_rent': 'true',
//                                             "activities": FieldValue.arrayUnion(
//                                               [
//                                                 "$formattedDate\nRentSpace created\n${ch8t.format(double.tryParse(_rentValue.toString())).toString()} target amount.",
//                                               ],
//                                             ),
//                                           }).then((value) {
//                                             Get.bottomSheet(
//                                               isDismissible: true,
//                                               SizedBox(
//                                                 height: 400,
//                                                 child: ClipRRect(
//                                                   borderRadius:
//                                                       const BorderRadius.only(
//                                                     topLeft:
//                                                         Radius.circular(30.0),
//                                                     topRight:
//                                                         Radius.circular(30.0),
//                                                   ),
//                                                   child: Container(
//                                                     color: Theme.of(context)
//                                                         .canvasColor,
//                                                     padding: const EdgeInsets
//                                                         .fromLTRB(10, 5, 10, 5),
//                                                     child: Column(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .center,
//                                                       children: [
//                                                         const SizedBox(
//                                                           height: 50,
//                                                         ),
//                                                         const Icon(
//                                                           Icons
//                                                               .check_circle_outline,
//                                                           color: brandOne,
//                                                           size: 80,
//                                                         ),
//                                                         const SizedBox(
//                                                           height: 20,
//                                                         ),
//                                                         Text(
//                                                           'RentSpace created',
//                                                           style: GoogleFonts
//                                                               .nunito(
//                                                             fontSize: 16.sp,
//                                                             color: Theme.of(
//                                                                     context)
//                                                                 .primaryColor,
//                                                           ),
//                                                         ),
//                                                         Column(
//                                                           children: [
//                                                             Row(
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .center,
//                                                               children: [
//                                                                 Text(
//                                                                   'Total Rent: ',
//                                                                   style:
//                                                                       GoogleFonts
//                                                                           .nunito(
//                                                                     fontSize:
//                                                                         16.sp,
//                                                                     color: Theme.of(
//                                                                             context)
//                                                                         .primaryColor,
//                                                                   ),
//                                                                 ),
//                                                                 Text(
//                                                                   ch8t
//                                                                       .format(double.tryParse(
//                                                                           _amountValue
//                                                                               .toString()))
//                                                                       .toString(),
//                                                                   overflow:
//                                                                       TextOverflow
//                                                                           .clip,
//                                                                   style:
//                                                                       GoogleFonts
//                                                                           .nunito(
//                                                                     fontSize:
//                                                                         16.sp,
//                                                                     color: Theme.of(
//                                                                             context)
//                                                                         .primaryColor,
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                             Row(
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .center,
//                                                               children: [
//                                                                 Text(
//                                                                   'Holding Fee: ',
//                                                                   style:
//                                                                       GoogleFonts
//                                                                           .nunito(
//                                                                     fontSize:
//                                                                         16.sp,
//                                                                     color: Theme.of(
//                                                                             context)
//                                                                         .primaryColor,
//                                                                   ),
//                                                                 ),
//                                                                 Text(
//                                                                   ch8t
//                                                                       .format(double.tryParse(
//                                                                           _holdingFee
//                                                                               .toString()))
//                                                                       .toString(),
//                                                                   overflow:
//                                                                       TextOverflow
//                                                                           .clip,
//                                                                   style:
//                                                                       GoogleFonts
//                                                                           .nunito(
//                                                                     fontSize:
//                                                                         16.sp,
//                                                                     color: Theme.of(
//                                                                             context)
//                                                                         .primaryColor,
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         const SizedBox(
//                                                           height: 30,
//                                                         ),
//                                                         Align(
//                                                           alignment: Alignment
//                                                               .bottomCenter,
//                                                           child: Container(
//                                                             // width: MediaQuery.of(context).size.width * 2,
//                                                             alignment: Alignment
//                                                                 .center,
//                                                             // height: 110.h,
//                                                             child: Column(
//                                                               children: [
//                                                                 ElevatedButton(
//                                                                   style: ElevatedButton
//                                                                       .styleFrom(
//                                                                     minimumSize:
//                                                                         const Size(
//                                                                             300,
//                                                                             50),
//                                                                     backgroundColor:
//                                                                         brandOne,
//                                                                     elevation:
//                                                                         0,
//                                                                     shape:
//                                                                         RoundedRectangleBorder(
//                                                                       borderRadius:
//                                                                           BorderRadius
//                                                                               .circular(
//                                                                         10,
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                   onPressed:
//                                                                       () async {
//                                                                     Get.back();
//                                                                     // Get.to(
//                                                                     //     SpaceRentFunding(
//                                                                     //   amount: _dailyValue
//                                                                     //       .toInt(),
//                                                                     //   date:
//                                                                     //       formattedDate,
//                                                                     //   interval:
//                                                                     //       'daily',
//                                                                     //   numPayment:
//                                                                     //       0,
//                                                                     //   refId:
//                                                                     //       _rentSpaceID,
//                                                                     //   userID:
//                                                                     //       _id,
//                                                                     // ));
//                                                                     resetCalculator();
//                                                                   },
//                                                                   child: Text(
//                                                                     'Proceed To Payment',
//                                                                     textAlign:
//                                                                         TextAlign
//                                                                             .center,
//                                                                     style: GoogleFonts
//                                                                         .nunito(
//                                                                       color: Colors
//                                                                           .white,
//                                                                       fontSize:
//                                                                           14.sp,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w500,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         const SizedBox(
//                                                           height: 20,
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             );
//                                           }).catchError((error) {
//                                             customErrorDialog(context, 'Oops!!',
//                                                 'Something went wrong, try again later');
//                                             showDialog(
//                                                 context: context,
//                                                 barrierDismissible: false,
//                                                 builder:
//                                                     (BuildContext context) {
//                                                   return AlertDialog(
//                                                     shape:
//                                                         RoundedRectangleBorder(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10),
//                                                     ),
//                                                     title: null,
//                                                     elevation: 0,
//                                                     content: SizedBox(
//                                                       height: 250,
//                                                       child: Column(
//                                                         children: [
//                                                           GestureDetector(
//                                                             onTap: () {
//                                                               Navigator.of(
//                                                                       context)
//                                                                   .pop();
//                                                             },
//                                                             child: Align(
//                                                               alignment:
//                                                                   Alignment
//                                                                       .topRight,
//                                                               child: Container(
//                                                                 decoration:
//                                                                     BoxDecoration(
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               30),
//                                                                   // color: brandOne,
//                                                                 ),
//                                                                 child:
//                                                                     const Icon(
//                                                                   Iconsax
//                                                                       .close_circle,
//                                                                   color:
//                                                                       brandOne,
//                                                                   size: 30,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           const Align(
//                                                             alignment: Alignment
//                                                                 .center,
//                                                             child: Icon(
//                                                               Iconsax
//                                                                   .warning_24,
//                                                               color: Colors.red,
//                                                               size: 75,
//                                                             ),
//                                                           ),
//                                                           const SizedBox(
//                                                             height: 12,
//                                                           ),
//                                                           Text(
//                                                             'Oops!!',
//                                                             style: GoogleFonts
//                                                                 .nunito(
//                                                               color: Colors.red,
//                                                               fontSize: 28,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w800,
//                                                             ),
//                                                           ),
//                                                           const SizedBox(
//                                                             height: 5,
//                                                           ),
//                                                           Text(
//                                                             'Oops! \n Something went wrong, try again later',
//                                                             textAlign: TextAlign
//                                                                 .center,
//                                                             style: GoogleFonts
//                                                                 .nunito(
//                                                                     color:
//                                                                         brandOne,
//                                                                     fontSize:
//                                                                         18),
//                                                           ),
//                                                           const SizedBox(
//                                                             height: 10,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 });
//                                             //
//                                           });
//                                         },
//                                         child: Text(
//                                           'Save ${ch8t.format(double.tryParse(_dailyValue.toString())).toString()} daily for ${_calculateDaysDifference()} days',
//                                           textAlign: TextAlign.center,
//                                           style: GoogleFonts.nunito(
//                                             color: Colors.white,
//                                             fontSize: 14.sp,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ),

//                                       const SizedBox(
//                                         height: 10,
//                                       ),
//                                       ////////Weekly payment
//                                       ElevatedButton(
//                                         style: ElevatedButton.styleFrom(
//                                           minimumSize: const Size(300, 50),
//                                           maximumSize: const Size(400, 50),
//                                           backgroundColor: brandOne,
//                                           elevation: 0,
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(
//                                               10,
//                                             ),
//                                           ),
//                                         ),
//                                         onPressed: () async {
//                                           _weeklyModalController.stop();
//                                           var userUpdate = FirebaseFirestore
//                                               .instance
//                                               .collection('accounts');
//                                           var updateRent = FirebaseFirestore
//                                               .instance
//                                               .collection('rent_space');

//                                           await updateRent.add({
//                                             'id': _id,
//                                             // 'user_id': _userID,
//                                             'rentspace_id': _rentSpaceID,
//                                             'date': formattedDate,
//                                             'interval_amount': _weeklyValue,
//                                             'target_amount': _rentValue,
//                                             'paid_amount': 0,
//                                             'interval': 'weekly',
//                                             'has_paid': 'false',
//                                             'status': 'active',
//                                             'history': _history,
//                                             'is_new': 'true',
//                                             'no_of_payments':
//                                                 _calculateWeeksDifference()
//                                                     .toString(),
//                                             'current_payment': '0',
//                                             'token': ''
//                                           });
//                                           await userUpdate.doc(userId).update({
//                                             'has_rent': 'true',
//                                             "activities": FieldValue.arrayUnion(
//                                               [
//                                                 "$formattedDate\nRentSpace created\n${ch8t.format(double.tryParse(_rentValue.toString())).toString()} target amount.",
//                                               ],
//                                             ),
//                                           }).then((value) {
//                                             Get.bottomSheet(
//                                               isDismissible: true,
//                                               SizedBox(
//                                                 height: 300,
//                                                 child: ClipRRect(
//                                                   borderRadius:
//                                                       const BorderRadius.only(
//                                                     topLeft:
//                                                         Radius.circular(30.0),
//                                                     topRight:
//                                                         Radius.circular(30.0),
//                                                   ),
//                                                   child: Container(
//                                                     color: Theme.of(context)
//                                                         .canvasColor,
//                                                     padding: const EdgeInsets
//                                                         .fromLTRB(10, 5, 10, 5),
//                                                     child: Column(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .center,
//                                                       children: [
//                                                         const SizedBox(
//                                                           height: 50,
//                                                         ),
//                                                         const Icon(
//                                                           Icons
//                                                               .check_circle_outline,
//                                                           color: brandOne,
//                                                           size: 80,
//                                                         ),
//                                                         const SizedBox(
//                                                           height: 20,
//                                                         ),
//                                                         Text(
//                                                           'RentSpace created',
//                                                           style: GoogleFonts
//                                                               .nunito(
//                                                             fontSize: 16.sp,
//                                                             color: Theme.of(
//                                                                     context)
//                                                                 .primaryColor,
//                                                           ),
//                                                         ),
//                                                         const SizedBox(
//                                                           height: 30,
//                                                         ),
//                                                         Align(
//                                                           alignment: Alignment
//                                                               .bottomCenter,
//                                                           child: Container(
//                                                             // width: MediaQuery.of(context).size.width * 2,
//                                                             alignment: Alignment
//                                                                 .center,
//                                                             // height: 110.h,
//                                                             child: Column(
//                                                               children: [
//                                                                 ElevatedButton(
//                                                                   style: ElevatedButton
//                                                                       .styleFrom(
//                                                                     minimumSize:
//                                                                         const Size(
//                                                                             300,
//                                                                             50),
//                                                                     backgroundColor:
//                                                                         brandOne,
//                                                                     elevation:
//                                                                         0,
//                                                                     shape:
//                                                                         RoundedRectangleBorder(
//                                                                       borderRadius:
//                                                                           BorderRadius
//                                                                               .circular(
//                                                                         10,
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                   onPressed:
//                                                                       () async {
//                                                                     Get.back();
//                                                                     // Get.to(
//                                                                     //     SpaceRentFunding(
//                                                                     //   amount: _weeklyValue
//                                                                     //       .toInt(),
//                                                                     //   date:
//                                                                     //       formattedDate,
//                                                                     //   interval:
//                                                                     //       'weekly',
//                                                                     //   numPayment:
//                                                                     //       0,
//                                                                     //   refId:
//                                                                     //       _rentSpaceID,
//                                                                     //   userID:
//                                                                     //       _id,
//                                                                     // ));
//                                                                     resetCalculator();
//                                                                   },
//                                                                   child: Text(
//                                                                     'Proceed To Payment',
//                                                                     textAlign:
//                                                                         TextAlign
//                                                                             .center,
//                                                                     style: GoogleFonts
//                                                                         .nunito(
//                                                                       color: Colors
//                                                                           .white,
//                                                                       fontSize:
//                                                                           14.sp,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w500,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         const SizedBox(
//                                                           height: 20,
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             );
//                                           }).catchError((error) {
//                                             customErrorDialog(context, 'Oops!!',
//                                                 'Something went wrong, try again later');
//                                             // showDialog(
//                                             //     context: context,
//                                             //     barrierDismissible: false,
//                                             //     builder: (BuildContext context) {
//                                             //       return AlertDialog(
//                                             //         shape: RoundedRectangleBorder(
//                                             //           borderRadius:
//                                             //               BorderRadius.circular(10),
//                                             //         ),
//                                             //         title: null,
//                                             //         elevation: 0,
//                                             //         content: SizedBox(
//                                             //           height: 250,
//                                             //           child: Column(
//                                             //             children: [
//                                             //               GestureDetector(
//                                             //                 onTap: () {
//                                             //                   Navigator.of(context)
//                                             //                       .pop();
//                                             //                 },
//                                             //                 child: Align(
//                                             //                   alignment: Alignment
//                                             //                       .topRight,
//                                             //                   child: Container(
//                                             //                     decoration:
//                                             //                         BoxDecoration(
//                                             //                       borderRadius:
//                                             //                           BorderRadius
//                                             //                               .circular(
//                                             //                                   30),
//                                             //                       // color: brandOne,
//                                             //                     ),
//                                             //                     child: const Icon(
//                                             //                       Iconsax
//                                             //                           .close_circle,
//                                             //                       color: brandOne,
//                                             //                       size: 30,
//                                             //                     ),
//                                             //                   ),
//                                             //                 ),
//                                             //               ),
//                                             //               const Align(
//                                             //                 alignment:
//                                             //                     Alignment.center,
//                                             //                 child: Icon(
//                                             //                   Iconsax.warning_24,
//                                             //                   color: Colors.red,
//                                             //                   size: 75,
//                                             //                 ),
//                                             //               ),
//                                             //               const SizedBox(
//                                             //                 height: 12,
//                                             //               ),
//                                             //               Text(
//                                             //                 'Oops!!',
//                                             //                 style:
//                                             //                     GoogleFonts.nunito(
//                                             //                   color: Colors.red,
//                                             //                   fontSize: 28,
//                                             //                   fontWeight:
//                                             //                       FontWeight.w800,
//                                             //                 ),
//                                             //               ),
//                                             //               const SizedBox(
//                                             //                 height: 5,
//                                             //               ),
//                                             //               Text(
//                                             //                 'Oops! \n Something went wrong, try again later',
//                                             //                 textAlign:
//                                             //                     TextAlign.center,
//                                             //                 style:
//                                             //                     GoogleFonts.nunito(
//                                             //                         color: brandOne,
//                                             //                         fontSize: 18),
//                                             //               ),
//                                             //               const SizedBox(
//                                             //                 height: 10,
//                                             //               ),
//                                             //             ],
//                                             //           ),
//                                             //         ),
//                                             //       );
//                                             //     });
//                                           });
//                                         },
//                                         child: Text(
//                                           'Save ${ch8t.format(double.tryParse(_weeklyValue.toString())).toString()} weekly for ${_calculateWeeksDifference()} weeks',
//                                           textAlign: TextAlign.center,
//                                           style: GoogleFonts.nunito(
//                                             color: Colors.white,
//                                             fontSize: 14.sp,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ),

//                                       const SizedBox(
//                                         height: 10,
//                                       ),
//                                       ////////Monthly payment
//                                       ElevatedButton(
//                                         style: ElevatedButton.styleFrom(
//                                           minimumSize: const Size(300, 50),
//                                           maximumSize: const Size(400, 50),
//                                           backgroundColor: brandOne,
//                                           elevation: 0,
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(
//                                               10,
//                                             ),
//                                           ),
//                                         ),
//                                         onPressed: () async {
//                                           _monthlyModalController.stop();
//                                           var userUpdate = FirebaseFirestore
//                                               .instance
//                                               .collection('accounts');
//                                           var updateRent = FirebaseFirestore
//                                               .instance
//                                               .collection('rent_space');

//                                           await updateRent.add({
//                                             'id': _id,
//                                             // 'user_id': _userID,
//                                             'rentspace_id': _rentSpaceID,
//                                             'date': formattedDate,
//                                             'interval_amount': _monthlyValue,
//                                             'target_amount': _rentValue,
//                                             'paid_amount': 0,
//                                             'interval': 'monthly',
//                                             'has_paid': 'false',
//                                             'status': 'active',
//                                             'history': _history,
//                                             'is_new': 'true',
//                                             'no_of_payments':
//                                                 _calculateMonthsDifference()
//                                                     .toString(),
//                                             'current_payment': '0',
//                                             'token': ''
//                                           });
//                                           await userUpdate.doc(userId).update({
//                                             'has_rent': 'true',
//                                             "activities": FieldValue.arrayUnion(
//                                               [
//                                                 "$formattedDate\nRentSpace created\n${ch8t.format(double.tryParse(_rentValue.toString())).toString()} target amount.",
//                                               ],
//                                             ),
//                                           }).then((value) {
//                                             Get.bottomSheet(
//                                               isDismissible: true,
//                                               SizedBox(
//                                                 height: 300,
//                                                 child: ClipRRect(
//                                                   borderRadius:
//                                                       const BorderRadius.only(
//                                                     topLeft:
//                                                         Radius.circular(30.0),
//                                                     topRight:
//                                                         Radius.circular(30.0),
//                                                   ),
//                                                   child: Container(
//                                                     color: Theme.of(context)
//                                                         .canvasColor,
//                                                     padding: const EdgeInsets
//                                                         .fromLTRB(10, 5, 10, 5),
//                                                     child: Column(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .center,
//                                                       children: [
//                                                         const SizedBox(
//                                                           height: 50,
//                                                         ),
//                                                         const Icon(
//                                                           Icons
//                                                               .check_circle_outline,
//                                                           color: brandOne,
//                                                           size: 80,
//                                                         ),
//                                                         const SizedBox(
//                                                           height: 20,
//                                                         ),
//                                                         Text(
//                                                           'RentSpace created',
//                                                           style: GoogleFonts
//                                                               .nunito(
//                                                             fontSize: 16.sp,
//                                                             color: Theme.of(
//                                                                     context)
//                                                                 .primaryColor,
//                                                           ),
//                                                         ),
//                                                         const SizedBox(
//                                                           height: 30,
//                                                         ),
//                                                         Align(
//                                                           alignment: Alignment
//                                                               .bottomCenter,
//                                                           child: Container(
//                                                             // width: MediaQuery.of(context).size.width * 2,
//                                                             alignment: Alignment
//                                                                 .center,
//                                                             // height: 110.h,
//                                                             child: Column(
//                                                               children: [
//                                                                 ElevatedButton(
//                                                                   style: ElevatedButton
//                                                                       .styleFrom(
//                                                                     minimumSize:
//                                                                         const Size(
//                                                                             300,
//                                                                             50),
//                                                                     backgroundColor:
//                                                                         brandOne,
//                                                                     elevation:
//                                                                         0,
//                                                                     shape:
//                                                                         RoundedRectangleBorder(
//                                                                       borderRadius:
//                                                                           BorderRadius
//                                                                               .circular(
//                                                                         10,
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                   onPressed:
//                                                                       () async {
//                                                                     Get.back();
//                                                                     // Get.to(
//                                                                     //     SpaceRentFunding(
//                                                                     //   amount: _monthlyValue
//                                                                     //       .toInt(),
//                                                                     //   date:
//                                                                     //       formattedDate,
//                                                                     //   interval:
//                                                                     //       'monthly',
//                                                                     //   numPayment:
//                                                                     //       0,
//                                                                     //   refId:
//                                                                     //       _rentSpaceID,
//                                                                     //   userID:
//                                                                     //       _id,
//                                                                     // ));
//                                                                     resetCalculator();
//                                                                   },
//                                                                   child: Text(
//                                                                     'Proceed To Payment',
//                                                                     textAlign:
//                                                                         TextAlign
//                                                                             .center,
//                                                                     style: GoogleFonts
//                                                                         .nunito(
//                                                                       color: Colors
//                                                                           .white,
//                                                                       fontSize:
//                                                                           14.sp,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w500,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         const SizedBox(
//                                                           height: 20,
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             );
//                                           }).catchError((error) {
//                                             customErrorDialog(context, 'Oops!!',
//                                                 'Something went wrong, try again later');
//                                           });
//                                         },
//                                         child: Text(
//                                           'Save ${ch8t.format(double.tryParse(_monthlyValue.toString())).toString()} monthly for ${_calculateMonthsDifference()} months',
//                                           textAlign: TextAlign.center,
//                                           style: GoogleFonts.nunito(
//                                             color: Colors.white,
//                                             fontSize: 14.sp,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         height: 20,
//                                       ),
//                                       InkWell(
//                                         onTap: () {
//                                           Get.to(const TermsAndConditions());
//                                         },
//                                         child: Text(
//                                           "By proceeding, you agree with our terms and conditions",
//                                           style: GoogleFonts.nunito(
//                                             decoration:
//                                                 TextDecoration.underline,
//                                             color: Colors.red,
//                                             fontSize: 12.sp,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         height: 50,
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               : const Text("")
//                       : const Text(""),
//                   // : const Text(""),
//                   const SizedBox(
//                     height: 50,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   resetCalculator() {
//     setState(() {
//       _amountValue = "";
//       _rentValue = 0.0;
//       _rentSeventy = 0.0;
//       _rentThirty = 0.0;
//       _holdingFee = 0.0;
//       _hasCalculate = 'true';
//       _hasCreated = 'false';
//       _canShowRent = 'false';
//     });
//     _rentAmountController.clear();
//     _rentAmountOldController.clear();
//   }
// }
