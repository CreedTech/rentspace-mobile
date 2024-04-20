// // ignore_for_file: use_build_context_synchronously

// import 'dart:async';
// import 'dart:convert';

// import 'package:bcrypt/bcrypt.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:pinput/pinput.dart';
// import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';

// import '../../api/global_services.dart';
// import '../../constants/app_constants.dart';
// import '../../constants/colors.dart';
// import '../../constants/widgets/custom_dialog.dart';
// import '../../constants/widgets/custom_loader.dart';
// import '../FirstPage.dart';
// import '../actions/fund_wallet.dart';

// class DataScreen extends StatefulWidget {
//   const DataScreen(
//       {super.key,
//       required this.validity,
//       required this.name,
//       required this.amount,
//       required this.userPin,
//       required this.number,
//       required this.billId,
//       required this.mainBalance,
//       required this.dataName});
//   final String validity, name, amount, userPin, number, billId, dataName;
//   final num mainBalance;

//   @override
//   State<DataScreen> createState() => _DataScreenState();
// }

// bool canLoad = false;
// String loadMssg = "Loading services...";

// class _DataScreenState extends State<DataScreen> {
//   final TextEditingController _pinController = TextEditingController();
//   final setDataPinformKey = GlobalKey<FormState>();

//   Future<bool> fetchUserData({bool refresh = true}) async {
//     if (refresh) {
//       await userController.fetchData();
//       setState(() {}); // Move setState inside fetchData
//     }
//     return true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final defaultPinTheme = PinTheme(
//       width: 50,
//       height: 50,
//       textStyle: GoogleFonts.poppins(
//         fontSize: 20,
//         color: Theme.of(context).primaryColor,
//       ),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey, width: 1.0),
//         borderRadius: BorderRadius.circular(5),
//       ),
//     );
//     validatePinOne(pinOneValue) {
//       if (pinOneValue.isEmpty) {
//         return 'pin cannot be empty';
//       }
//       if (pinOneValue.length < 4) {
//         return 'pin is incomplete';
//       }
//       if (int.tryParse(pinOneValue) == null) {
//         return 'enter valid number';
//       }
//       return null;
//     }

//     //Pin
//     final pin = Pinput(
//       useNativeKeyboard: false,
//       obscureText: true,
//       defaultPinTheme: PinTheme(
//         width: 50,
//         height: 50,
//         textStyle: TextStyle(
//           fontSize: 25.sp,
//           color: brandOne,
//         ),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey, width: 1.0),
//           borderRadius: BorderRadius.circular(5),
//         ),
//       ),
//       focusedPinTheme: PinTheme(
//         width: 50,
//         height: 50,
//         textStyle: TextStyle(
//           fontSize: 25.sp,
//           color: brandOne,
//         ),
//         decoration: BoxDecoration(
//           border: Border.all(color: brandOne, width: 2.0),
//           borderRadius: BorderRadius.circular(5),
//         ),
//       ),
//       submittedPinTheme: PinTheme(
//         width: 50,
//         height: 50,
//         textStyle: TextStyle(
//           fontSize: 25.sp,
//           color: brandOne,
//         ),
//         decoration: BoxDecoration(
//           border: Border.all(color: brandOne, width: 2.0),
//           borderRadius: BorderRadius.circular(5),
//         ),
//       ),
//       followingPinTheme: PinTheme(
//         width: 50,
//         height: 50,
//         textStyle: TextStyle(
//           fontSize: 25.sp,
//           color: brandOne,
//         ),
//         decoration: BoxDecoration(
//           border: Border.all(color: brandTwo, width: 2.0),
//           borderRadius: BorderRadius.circular(5),
//         ),
//       ),
//       controller: _pinController,
//       length: 4,
//       androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
//       validator: validatePinOne,
//       onChanged: validatePinOne,
//       onCompleted: (val) async {
//         print(widget.billId);
//         print(widget.userPin);
//         print(widget.validity);
//         print(widget.number);
//         print(widget.name);
//         print(widget.amount);
//         if (BCrypt.checkpw(
//             _pinController.text.trim().toString(), widget.userPin)) {
//           _pinController.clear();
//           EasyLoading.show(
//             indicator: const CustomLoader(),
//             maskType: EasyLoadingMaskType.black,
//             dismissOnTap: false,
//           );
//           if (widget.mainBalance > ((int.tryParse(widget.amount))!)) {
//             EasyLoading.show(
//               indicator: const CustomLoader(),
//               maskType: EasyLoadingMaskType.black,
//               dismissOnTap: false,
//             );
//             const String apiUrl = 'https://api.watupay.com/v1/watubill/vend';
//             const String bearerToken =
//                 'WTP-L-SK-1b434faeb3b8492bbc34b03973ff3683';
//             final response = await http.post(
//               Uri.parse(apiUrl),
//               headers: {
//                 'Authorization': 'Bearer $bearerToken',
//                 "Content-Type": "application/json"
//               },
//               body: jsonEncode(<String, dynamic>{
//                 "channel": widget.billId,
//                 "business_signature": "a390960dfa37469d824ffe6cb80472f6",
//                 'phone_number': widget.number,
//                 'validity': widget.validity,
//                 "name": widget.name,
//                 "amount": widget.amount,
//                 "ignore_duplicate": 1
//               }),
//             );

//             print(response.body);
//             if (response.statusCode == 200) {
//               EasyLoading.dismiss();
//               String authToken =
//                   await GlobalService.sharedPreferencesManager.getAuthToken();
//               print(authToken);
//               try {
//                 EasyLoading.show(
//                   indicator: const CustomLoader(),
//                   maskType: EasyLoadingMaskType.black,
//                   dismissOnTap: false,
//                 );
//                 final addUtility = await http.post(
//                   Uri.parse(
//                       AppConstants.BASE_URL + AppConstants.ADD_UTILITY_HISTORY),
//                   headers: {
//                     'Authorization': 'Bearer $authToken',
//                     "Content-Type": "application/json"
//                   },
//                   body: jsonEncode(<String, dynamic>{
//                     "amount": widget.amount,
//                     'biller': '${widget.dataName.toUpperCase()} DATA',
//                     "transactionType": "Data Subscription",
//                     "description": 'Data Subscription to ${widget.number}',
//                   }),
//                 );
//                 print(addUtility);
//                 print(addUtility.body);
//                 EasyLoading.dismiss();
//               } on TimeoutException {
//                 throw http.Response('Network Timeout', 500);
//               } on http.ClientException catch (e) {
//                 print('Error while getting data is $e');
//                 throw http.Response('HTTP Client Exception: $e', 500);
//               } catch (e) {
//                 print(e);
//                 EasyLoading.dismiss();
//                 customErrorDialog(
//                     context, "Oops", 'Something Went wrong. Try Again Later!');
//               } finally {
//                 EasyLoading.dismiss();
//               }
//               _pinController.clear();
//               // _dataNumberController.clear();
//               setState(() {
//                 canLoad = true;
//               });
//               EasyLoading.show(
//                 indicator: const CustomLoader(),
//                 maskType: EasyLoadingMaskType.black,
//                 dismissOnTap: false,
//               );
//               // Get.to(FirstPage());
//               await fetchUserData(refresh: true);
//               showTopSnackBar(
//                 Overlay.of(context),
//                 CustomSnackBar.success(
//                   backgroundColor: Colors.green,
//                   message: 'You just earned a Space point!',
//                   textStyle: GoogleFonts.poppins(
//                     fontSize: 14,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               );
//             } else {
//               setState(() {
//                 canLoad = true;
//               });
//               EasyLoading.dismiss();
//               // Error handling
//               _pinController.clear();
//               // _dataNumberController.clear();

//               customErrorDialog(context, "Error", "Try again later");
//             }
//           } else {
//             EasyLoading.dismiss();
//             showDialog(
//                 context: context,
//                 barrierDismissible: false,
//                 builder: (BuildContext context) {
//                   return Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       AlertDialog(
//                         contentPadding:
//                             const EdgeInsets.fromLTRB(30, 30, 30, 20),
//                         elevation: 0,
//                         alignment: Alignment.bottomCenter,
//                         insetPadding: const EdgeInsets.all(0),
//                         scrollable: true,
//                         title: null,
//                         shape: const RoundedRectangleBorder(
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(30),
//                             topRight: Radius.circular(30),
//                           ),
//                         ),
//                         content: SizedBox(
//                           width: MediaQuery.of(context).size.width,
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 40),
//                                 child: Column(
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           vertical: 15),
//                                       child: Align(
//                                         alignment: Alignment.topCenter,
//                                         child: Text(
//                                           'Insufficient fund. You need to fund your wallet to perform this transaction.',
//                                           textAlign: TextAlign.center,
//                                           style: GoogleFonts.poppins(
//                                             color: brandOne,
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           vertical: 10),
//                                       child: Column(
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.all(3),
//                                             child: ElevatedButton(
//                                               onPressed: () {
//                                                 FocusScope.of(context)
//                                                     .unfocus();
//                                                 Get.back();
//                                                 Get.to(const FundWallet());
//                                               },
//                                               style: ElevatedButton.styleFrom(
//                                                 backgroundColor:
//                                                     Theme.of(context)
//                                                         .colorScheme
//                                                         .secondary,
//                                                 shape: RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(8),
//                                                 ),
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 60,
//                                                         vertical: 15),
//                                                 textStyle: const TextStyle(
//                                                     color: brandFour,
//                                                     fontSize: 13),
//                                               ),
//                                               child: const Text(
//                                                 "Fund Wallet",
//                                                 style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontWeight: FontWeight.w700,
//                                                   fontSize: 16,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(
//                                             height: 10,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   );
//                 });
//           }
//         } else {
//           EasyLoading.dismiss();
//           _pinController.clear();
//           if (context.mounted) {
//             customErrorDialog(
//                 context, "Invalid PIN", 'Enter correct PIN to proceed');
//           }
//         }
//       },
//       closeKeyboardWhenCompleted: true,
//       keyboardType: TextInputType.number,
//     );

//     return Scaffold(
//       backgroundColor: Theme.of(context).canvasColor,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
//           child: Stack(
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
//                 child: Column(
//                   children: [
//                     Align(
//                       alignment: Alignment.center,
//                       child: Text(
//                         'Enter PIN to Proceed',
//                         style: GoogleFonts.poppins(
//                           color: Theme.of(context).primaryColor,
//                           fontWeight: FontWeight.w700,
//                           fontSize: 20,
//                           // fontFamily: "DefaultFontFamily",
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 40.h,
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Form(
//                           key: setDataPinformKey,
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 8.0,
//                               horizontal: 14,
//                             ),
//                             child: pin,
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size(250, 50),
//                       backgroundColor: brandOne,
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(
//                           10,
//                         ),
//                       ),
//                     ),
//                     onPressed: () async {
//                       FocusScope.of(context).unfocus();
//                       if (setDataPinformKey.currentState!.validate()) {
//                         if (BCrypt.checkpw(
//                             _pinController.text.trim().toString(),
//                             widget.userPin)) {
//                           _pinController.clear();

//                           EasyLoading.show(
//                             indicator: const CustomLoader(),
//                             maskType: EasyLoadingMaskType.black,
//                             dismissOnTap: false,
//                           );

//                           if (widget.mainBalance >
//                               ((int.tryParse(widget.amount))!)) {
//                             const String apiUrl =
//                                 'https://api.watupay.com/v1/watubill/vend';
//                             const String bearerToken =
//                                 'WTP-L-SK-1b434faeb3b8492bbc34b03973ff3683';
//                             final response = await http.post(
//                               Uri.parse(apiUrl),
//                               headers: {
//                                 'Authorization': 'Bearer $bearerToken',
//                                 "Content-Type": "application/json"
//                               },
//                               body: jsonEncode(<String, dynamic>{
//                                 "channel": widget.billId,
//                                 "business_signature":
//                                     "a390960dfa37469d824ffe6cb80472f6",
//                                 'phone_number': widget.number,
//                                 'validity': widget.validity,
//                                 "name": widget.name,
//                                 "amount": widget.amount,
//                                 "ignore_duplicate": 1
//                               }),
//                             );

//                             if (response.statusCode == 200) {
//                               EasyLoading.dismiss();
//                               String authToken = await GlobalService
//                                   .sharedPreferencesManager
//                                   .getAuthToken();
//                               try {
//                                 EasyLoading.show(
//                                   indicator: const CustomLoader(),
//                                   maskType: EasyLoadingMaskType.black,
//                                   dismissOnTap: false,
//                                 );
//                                 final addUtility = await http.post(
//                                   Uri.parse(AppConstants.BASE_URL +
//                                       AppConstants.ADD_UTILITY_HISTORY),
//                                   headers: {
//                                     'Authorization': 'Bearer $authToken',
//                                     "Content-Type": "application/json"
//                                   },
//                                   body: jsonEncode(<String, dynamic>{
//                                     "amount": widget.amount,
//                                     'biller':
//                                         '${widget.dataName.toUpperCase()} DATA',
//                                     "transactionType": "Data Subscription",
//                                     "description":
//                                         'Electricity Payment to ${widget.number}',
//                                   }),
//                                 );
//                                 EasyLoading.dismiss();
//                               } on TimeoutException {
//                                 throw http.Response('Network Timeout', 500);
//                               } on http.ClientException catch (e) {
//                                 print('Error while getting data is $e');
//                                 throw http.Response(
//                                     'HTTP Client Exception: $e', 500);
//                               } catch (e) {
//                                 print(e);
//                                 EasyLoading.dismiss();
//                                 customErrorDialog(context, "Oops",
//                                     'Something Went wrong. Try Again Later!');
//                               } finally {
//                                 EasyLoading.dismiss();
//                               }
//                               _pinController.clear();
//                               // _dataNumberController.clear();
//                               setState(() {
//                                 canLoad = true;
//                               });
//                               EasyLoading.show(
//                                 indicator: const CustomLoader(),
//                                 maskType: EasyLoadingMaskType.black,
//                                 dismissOnTap: false,
//                               );
//                               showTopSnackBar(
//                                 Overlay.of(context),
//                                 CustomSnackBar.success(
//                                   backgroundColor: brandOne,
//                                   message: 'You just earned a Space point!',
//                                   textStyle: GoogleFonts.poppins(
//                                     fontSize: 14,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               );
//                             } else {
//                               setState(() {
//                                 canLoad = true;
//                               });
//                               EasyLoading.dismiss();
//                               // Error handling
//                               _pinController.clear();
//                               // _dataNumberController.clear();

//                               customErrorDialog(
//                                   context, "Error", "Try again later");
//                             }
//                           } else {
//                             EasyLoading.dismiss();
//                             showDialog(
//                                 context: context,
//                                 barrierDismissible: false,
//                                 builder: (BuildContext context) {
//                                   return Column(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       AlertDialog(
//                                         contentPadding:
//                                             const EdgeInsets.fromLTRB(
//                                                 30, 30, 30, 20),
//                                         elevation: 0,
//                                         alignment: Alignment.bottomCenter,
//                                         insetPadding: const EdgeInsets.all(0),
//                                         scrollable: true,
//                                         title: null,
//                                         shape: const RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.only(
//                                             topLeft: Radius.circular(30),
//                                             topRight: Radius.circular(30),
//                                           ),
//                                         ),
//                                         content: SizedBox(
//                                           width:
//                                               MediaQuery.of(context).size.width,
//                                           child: Column(
//                                             children: [
//                                               Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         vertical: 40),
//                                                 child: Column(
//                                                   children: [
//                                                     Padding(
//                                                       padding: const EdgeInsets
//                                                           .symmetric(
//                                                           vertical: 15),
//                                                       child: Align(
//                                                         alignment:
//                                                             Alignment.topCenter,
//                                                         child: Text(
//                                                           'Insufficient fund. You need to fund your wallet to perform this transaction.',
//                                                           textAlign:
//                                                               TextAlign.center,
//                                                           style: GoogleFonts
//                                                               .poppins(
//                                                             color: brandOne,
//                                                             fontSize: 16,
//                                                             fontWeight:
//                                                                 FontWeight.w600,
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
//                                                                 FocusScope.of(
//                                                                         context)
//                                                                     .unfocus();
//                                                                 Get.back();
//                                                                 Get.to(
//                                                                     const FundWallet());
//                                                               },
//                                                               style:
//                                                                   ElevatedButton
//                                                                       .styleFrom(
//                                                                 backgroundColor: Theme.of(
//                                                                         context)
//                                                                     .colorScheme
//                                                                     .secondary,
//                                                                 shape:
//                                                                     RoundedRectangleBorder(
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               8),
//                                                                 ),
//                                                                 padding: const EdgeInsets
//                                                                     .symmetric(
//                                                                     horizontal:
//                                                                         60,
//                                                                     vertical:
//                                                                         15),
//                                                                 textStyle:
//                                                                     const TextStyle(
//                                                                         color:
//                                                                             brandFour,
//                                                                         fontSize:
//                                                                             13),
//                                                               ),
//                                                               child: const Text(
//                                                                 "Fund Wallet",
//                                                                 style:
//                                                                     TextStyle(
//                                                                   color: Colors
//                                                                       .white,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w700,
//                                                                   fontSize: 16,
//                                                                 ),
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
//                                       )
//                                     ],
//                                   );
//                                 });
//                           }
//                         } else {
//                           EasyLoading.dismiss();
//                           _pinController.clear();
//                           if (context.mounted) {
//                             customErrorDialog(context, "Invalid PIN",
//                                 'Enter correct PIN to proceed');
//                           }
//                         }
//                       } else {
//                         EasyLoading.dismiss();
//                         customErrorDialog(context, "Incomplete",
//                             "Fill the field correctly to proceed");
//                       }
//                     },
//                     child: const Text(
//                       'Proceed',
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
