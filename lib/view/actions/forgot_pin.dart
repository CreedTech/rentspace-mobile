// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:onscreen_num_keyboard/onscreen_num_keyboard.dart';
// import 'package:rentspace/constants/colors.dart';
// import 'package:rentspace/constants/icons.dart';
// import 'package:pinput/pinput.dart';
// import 'package:get/get.dart';

// import '../../constants/widgets/custom_dialog.dart';
// import '../dashboard/confirm_forgot_pin.dart';

// class ForgotPin extends ConsumerStatefulWidget {
//   final String pin;
//   const ForgotPin({super.key, required this.pin});

//   @override
//   _ForgotPinConsumerState createState() => _ForgotPinConsumerState();
// }

// class _ForgotPinConsumerState extends ConsumerState<ForgotPin> {
//   final TextEditingController _pinController = TextEditingController();
//   // final TextEditingController _pinTwoController = TextEditingController();
//   // final TextEditingController _passwordController = TextEditingController();
//   final forgotPinformKey = GlobalKey<FormState>();
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

//   // Future updatePin() async {
//   //   var userPinUpdate = FirebaseFirestore.instance.collection('accounts');
//   //   await userPinUpdate.doc(userId).update({
//   //     'transaction_pin': _pinController.text.trim(),
//   //   }).then((value) {
//   //     Get.back();
//   //     Get.snackbar(
//   //       "PIN updated!",
//   //       'Your transaction PIN has been updated successfully',
//   //       animationDuration: Duration(seconds: 1),
//   //       backgroundColor: brandOne,
//   //       colorText: Colors.white,
//   //       snackPosition: SnackPosition.TOP,
//   //     );
//   //   }).catchError((error) {
//   //     Get.snackbar(
//   //       "Oops",
//   //       "something went wrong, please try again",
//   //       animationDuration: Duration(seconds: 2),
//   //       backgroundColor: Colors.red,
//   //       colorText: Colors.white,
//   //       snackPosition: SnackPosition.BOTTOM,
//   //     );
//   //   });
//   // }

//   void _doSomething() async {
//     if (_pinController.text.trim() == widget.pin) {
//       customErrorDialog(
//           context, "Invalid!", "PIN cannot be the same as existing one.");
//     }
//     // else if (widget.password != _passwordController.text.trim() ||
//     //     _passwordController.text.trim() == "") {
//     //   Get.snackbar(
//     //     "Invalid",
//     //     'Password is incorrect',
//     //     animationDuration: Duration(seconds: 1),
//     //     backgroundColor: Colors.red,
//     //     colorText: Colors.white,
//     //     snackPosition: SnackPosition.BOTTOM,
//     //   );

//     // }
//     else {
//       Get.to(ConfirmForgotPin(
//           // password: _passwordController.text.trim(),
//           pin: _pinController.text.trim()));
//     }
//   }

//   bool obscurity = true;
//   Icon lockIcon = LockIcon().open;
//   @override
//   initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final defaultPinTheme = PinTheme(
//       width: 50,
//       height: 50,
//       textStyle: GoogleFonts.nunito(
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
//       validator: validatePinOne,
//       onChanged: validatePinOne,
//       // onCompleted: _doSomething,
//       closeKeyboardWhenCompleted: true,
//       onCompleted: (val) {
//         FocusScope.of(context).unfocus();
//         Get.to(ConfirmForgotPin(pin: _pinController.text.trim()));
//       },
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
//                         'Change Transaction PIN',
//                         style: GoogleFonts.nunito(
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
//                           key: forgotPinformKey,
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
//               Positioned(
//                 bottom: 20,
//                 left: 0,
//                 right: 0,
//                 child: Align(
//                   alignment: Alignment.bottomCenter,
//                   child: NumericKeyboard(
//                     onKeyboardTap: (String value) {
//                       setState(() {
//                         _pinController.text = _pinController.text + value;
//                       });
//                       print(value);
//                       print(_pinController.text);
//                     },
//                     textStyle: GoogleFonts.nunito(
//                       color: brandOne,
//                       fontSize: 28.sp,
//                     ),
//                     rightButtonFn: () {
//                       if (_pinController.text.isEmpty) return;
//                       setState(() {
//                         _pinController.text = _pinController.text
//                             .substring(0, _pinController.text.length - 1);
//                       });
//                     },
//                     rightButtonLongPressFn: () {
//                       if (_pinController.text.isEmpty) return;
//                       setState(() {
//                         _pinController.text = '';
//                       });
//                     },
//                     rightIcon: const Icon(
//                       Icons.backspace_outlined,
//                       color: Colors.red,
//                     ),
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
