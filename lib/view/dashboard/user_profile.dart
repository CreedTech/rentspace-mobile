// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:getwidget/getwidget.dart';
// import 'package:rentspace/constants/colors.dart';
// import 'package:rentspace/view/actions/add_card.dart';
// import 'package:rentspace/view/actions/bank_and_card.dart';
// import 'package:rentspace/view/actions/contact_us.dart';
// import 'package:rentspace/view/actions/phone_verification_screen.dart';
// import 'package:rentspace/view/actions/share_and_earn.dart';
// import 'package:rentspace/view/actions/view_bvn_and_kyc.dart';
// import 'package:rentspace/view/dashboard/dashboard.dart';
// import 'package:rentspace/view/faqs.dart';
// import 'package:rentspace/view/actions/forgot_password.dart';
// import 'package:rentspace/view/actions/forgot_pin.dart';
// import 'package:rentspace/view/actions/onboarding_page.dart';
// import 'package:settings_ui/settings_ui.dart';
// import 'package:rentspace/constants/firebase_auth_constants.dart';
// import 'package:rentspace/constants/theme_services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:flutter/services.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';
// import 'package:rentspace/constants/db/firebase_db.dart';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:rentspace/controller/user_controller.dart';
// //import 'package:path_provider/path_provider.dart';

// class UserProfile extends StatefulWidget {
//   UserProfile({
//     Key? key,
//   }) : super(key: key);

//   @override
//   _UserProfileState createState() => _UserProfileState();
// }

// final _auth = FirebaseAuth.instance;
// User? _user;
// bool _isEmailVerified = false;
// final LocalAuthentication _localAuthentication = LocalAuthentication();
// String _message = "Not Authorized";
// bool _hasBiometric = false;
// final hasBiometricStorage = GetStorage();
// bool _hasFeeds = true;
// final hasFeedsStorage = GetStorage();

// class _UserProfileState extends State<UserProfile> {
//   File? selectedImage;
//   final UserController userController = Get.find();

//   Future getImage() async {
//     var _image = await ImagePicker().pickImage(source: ImageSource.gallery);

//     setState(() {
//       selectedImage = File(_image!.path); // won't have any error now
//     });
//     uploadImg();
//   }

//   Future updateVerification() async {
//     var userUpdate = FirebaseFirestore.instance.collection('accounts');

//     await userUpdate.doc(userId).update({
//       'has_verified_email': 'true',
//     }).catchError((error) {
//       print(error);
//     });
//   }

//   Future uploadImg() async {
//     var userPinUpdate = FirebaseFirestore.instance.collection('accounts');

//     FirebaseStorage storage = FirebaseStorage.instance;
//     String fileName = basename(selectedImage!.path);
//     Reference ref = storage.ref().child(fileName);
//     UploadTask uploadTask = ref.putFile(selectedImage!);
//     var downloadURL =
//         await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
//     var url = downloadURL.toString();
//     await userPinUpdate.doc(userId).update({
//       'image': url,
//     }).then((value) {
//       Get.back();
//       Get.snackbar(
//         "Profile updated!",
//         'Your profile picture has been updated successfully',
//         animationDuration: const Duration(seconds: 1),
//         backgroundColor: brandOne,
//         colorText: Colors.white,
//         snackPosition: SnackPosition.TOP,
//       );
//     }).catchError((error) {
//       Get.snackbar(
//         "Error",
//         error.toString(),
//         animationDuration: const Duration(seconds: 2),
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     });
//   }

//   @override
//   initState() {
//     super.initState();

//     _user = _auth.currentUser;
//     _isEmailVerified = _user!.emailVerified;

//     checkingForBioMetrics();
//     print(_isEmailVerified);
//   }

//   enableBiometrics() {
//     if (hasBiometricStorage.read('hasBiometric') == null ||
//         hasBiometricStorage.read('hasBiometric') == false) {
//       hasBiometricStorage.write('hasBiometric', true);
//       Get.back();
//       Get.snackbar(
//         "Enabled",
//         "Biometrics enabled",
//         animationDuration: const Duration(seconds: 1),
//         backgroundColor: brandOne,
//         colorText: Colors.white,
//         snackPosition: SnackPosition.TOP,
//       );
//       if (hasBiometricStorage.read('hasBiometric') == false) {
//         setState(
//           () {
//             _hasBiometric = true;
//             hasBiometricStorage.write('hasBiometric', _hasBiometric);
//           },
//         );
//         Get.back();
//         Get.snackbar(
//           "Enabled",
//           "Biometrics enabled",
//           animationDuration: const Duration(seconds: 1),
//           backgroundColor: brandOne,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.TOP,
//         );
//       } else {
//         return;
//       }
//     } else {
//       print(hasBiometricStorage.read('hasBiometric').toString());
//     }
//     //print()
//   }

//   disableBiometrics() {
//     if (hasBiometricStorage.read('hasBiometric') == null ||
//         hasBiometricStorage.read('hasBiometric') == true) {
//       hasBiometricStorage.write('hasBiometric', false);
//       Get.back();
//       Get.snackbar(
//         "Disabled",
//         "Biometrics disabled",
//         animationDuration: const Duration(seconds: 1),
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       if (hasBiometricStorage.read('hasBiometric') == true) {
//         setState(
//           () {
//             _hasBiometric = false;
//             hasBiometricStorage.write('hasBiometric', _hasBiometric);
//           },
//         );
//         Get.back();
//         Get.snackbar(
//           "Disabled",
//           "Biometrics disabled",
//           animationDuration: const Duration(seconds: 1),
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       } else {
//         return;
//       }
//     } else {
//       print(hasBiometricStorage.read('hasBiometric').toString());
//     }
//     //print()
//   }

//   Future<bool> checkingForBioMetrics() async {
//     bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
//     print(canCheckBiometrics);
//     return canCheckBiometrics;
//   }

//   Future<void> _authenticateMe() async {
//     bool authenticated = false;
//     try {
//       authenticated = await _localAuthentication.authenticate(
//         localizedReason: "Touch fingerprint scanner to enable Biometrics",
//       );
//       setState(() {
//         _message = authenticated ? "Authorized" : "Not Authorized";
//       });
//       if (authenticated) {
//         enableBiometrics();
//       } else {
//         Get.snackbar(
//           "Error",
//           "could not authenticate",
//           animationDuration: const Duration(seconds: 1),
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       }

//       print("Authenticated");
//     } catch (e) {
//       print("Not authenticated");
//     }
//     if (!mounted) return;
//   }

//   Future<void> _NotAuthenticateMe() async {
//     bool authenticated = false;
//     try {
//       authenticated = await _localAuthentication.authenticate(
//         localizedReason: "Touch fingerprint scanner to disable Biometrics",
//       );
//       setState(() {
//         _message = authenticated ? "Authorized" : "Not Authorized";
//       });

//       if (authenticated) {
//         disableBiometrics();
//       } else {
//         Get.snackbar(
//           "Error",
//           "could not authenticate",
//           animationDuration: const Duration(seconds: 1),
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       }

//       print("Authenticated");
//     } catch (e) {
//       print("Not authenticated");
//     }
//     if (!mounted) return;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).cardColor,
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Opacity(
//               opacity: 0.1,
//               child: Image.asset(
//                 'assets/icons/RentSpace-icon.png',
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           ListView(
//             scrollDirection: Axis.vertical,
//             shrinkWrap: true,
//             physics: const ClampingScrollPhysics(),
//             children: [
//               const SizedBox(
//                 height: 20,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Container(
//                   height: 80,
//                   width: MediaQuery.of(context).size.width - 20,
//                   decoration: BoxDecoration(
//                     color: brandOne,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       const SizedBox(
//                         width: 20,
//                       ),
//                       SizedBox(
//                         height: 50,
//                         child: CircleAvatar(
//                           backgroundColor: Colors.transparent,
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(200),
//                             child: Image.network(
//                               userController.user[0].image,
//                               fit: BoxFit.cover,
//                               height: 50,
//                               width: 50,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "${userController.user[0].userFirst} ${userController.user[0].userLast}",
//                             style: const TextStyle(
//                               fontSize: 15.0,
//                               letterSpacing: 0.5,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                               fontFamily: "DefaultFontFamily",
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           Text(
//                             "Wallet ID: ${userController.user[0].userWalletNumber}",
//                             style: const TextStyle(
//                               fontSize: 12.0,
//                               letterSpacing: 0.5,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontFamily: "DefaultFontFamily",
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Theme.of(context).canvasColor,
//                   ),
//                   padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Personal details',
//                               style: TextStyle(
//                                 fontSize: 14.0,
//                                 letterSpacing: 1.0,
//                                 fontWeight: FontWeight.bold,
//                                 fontFamily: "DefaultFontFamily",
//                                 color: Theme.of(context).primaryColor,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       ListTile(
//                         leading: Icon(
//                           Icons.email,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                         title: Text(
//                           userController.user[0].email,
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontSize: 12,
//                             fontFamily: "DefaultFontFamily",
//                             fontWeight: FontWeight.bold,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         subtitle: (!_isEmailVerified)
//                             ? const Text(
//                                 'click to verify E-mail',
//                                 style: TextStyle(
//                                   color: Colors.red,
//                                   fontWeight: FontWeight.bold,
//                                   fontFamily: "DefaultFontFamily",
//                                   fontSize: 12,
//                                 ),
//                               )
//                             : const Text(
//                                 'E-mail Verified',
//                                 style: TextStyle(
//                                   color: Colors.greenAccent,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold,
//                                   fontFamily: "DefaultFontFamily",
//                                 ),
//                               ),
//                         onTap: () async {
//                           if (!_isEmailVerified) {
//                             await _user!.sendEmailVerification();
//                             Get.snackbar(
//                               "Sent",
//                               "Verification E-mail has been sent to ${userController.user[0].email}",
//                               animationDuration: const Duration(seconds: 2),
//                               backgroundColor: brandOne,
//                               colorText: Colors.white,
//                               snackPosition: SnackPosition.TOP,
//                             );
//                             setState(() {
//                               _isEmailVerified = _user!.emailVerified;
//                             });
//                             updateVerification();

//                             _user!.reload();
//                           }
//                         },
//                       ),
//                       ListTile(
//                         onTap: () {
//                           (userController.user[0].hasVerifiedPhone == 'false' ||
//                                   userController.user[0].hasVerifiedPhone == '')
//                               ? Get.to(PhoneVerificationScreen())
//                               : null;
//                         },
//                         leading: Icon(
//                           Icons.phone,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                         title: Text(
//                           userController.user[0].userPhone,
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontSize: 12,
//                             fontFamily: "DefaultFontFamily",
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         subtitle: (userController.user[0].hasVerifiedPhone ==
//                                     'false' ||
//                                 userController.user[0].hasVerifiedPhone == '')
//                             ? const Text(
//                                 'Click to verify phone number',
//                                 style: TextStyle(
//                                   color: Colors.red,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 12,
//                                   fontFamily: "DefaultFontFamily",
//                                 ),
//                               )
//                             : const Text(
//                                 'Verified',
//                                 style: TextStyle(
//                                   color: Colors.greenAccent,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold,
//                                   fontFamily: "DefaultFontFamily",
//                                 ),
//                               ),
//                       ),
//                       ListTile(
//                         leading: Icon(
//                           Icons.calendar_month,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                         title: Text(
//                           userController.user[0].accountDate,
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: "DefaultFontFamily",
//                           ),
//                         ),
//                         subtitle: Text(
//                           'Joined',
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: "DefaultFontFamily",
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               //////////////////
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Theme.of(context).canvasColor,
//                   ),
//                   padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Update info',
//                               style: TextStyle(
//                                 fontSize: 14.0,
//                                 letterSpacing: 1.0,
//                                 fontWeight: FontWeight.bold,
//                                 fontFamily: "DefaultFontFamily",
//                                 color: Theme.of(context).primaryColor,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       ListTile(
//                         onTap: () {
//                           if (userController.user[0].cardCVV == '') {
//                             Get.to(const AddCard());
//                           } else {
//                             Get.to(BankAndCard());
//                           }
//                         },
//                         leading: Icon(
//                           Icons.refresh,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                         title: Text(
//                           'Bank & Card',
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: "DefaultFontFamily",
//                           ),
//                         ),
//                         subtitle: Text(
//                           'update your bank and card details',
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: "DefaultFontFamily",
//                           ),
//                         ),
//                         trailing: Icon(
//                           Icons.arrow_right_outlined,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                       ),
//                       ListTile(
//                         onTap: () {
//                           if (userController.user[0].bvn == "") {
//                             Get.to(BvnPage(userController
//                                 .userModel!.userDetails![0].email));
//                           } else {
//                             Get.to(ViewBvnAndKyc(
//                               bvn: userController.user[0].bvn,
//                               hasVerifiedBvn:
//                                   userController.user[0].hasVerifiedBvn,
//                               hasVerifiedKyc:
//                                   userController.user[0].hasVerifiedKyc,
//                               kyc: userController.user[0].kyc,
//                               idImage: userController.user[0].Idimage,
//                             ));
//                           }
//                         },
//                         leading: Icon(
//                           Icons.logout,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                         title: Text(
//                           'BVN & KYC',
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontSize: 12,
//                             fontFamily: "DefaultFontFamily",
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         subtitle: Text(
//                           'manage your BVN & KYC details',
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: "DefaultFontFamily",
//                           ),
//                         ),
//                         trailing: Icon(
//                           Icons.arrow_right_outlined,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               //////////////////////
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Theme.of(context).canvasColor,
//                   ),
//                   padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Actions',
//                               style: TextStyle(
//                                 fontSize: 14.0,
//                                 letterSpacing: 1.0,
//                                 fontFamily: "DefaultFontFamily",
//                                 fontWeight: FontWeight.bold,
//                                 color: Theme.of(context).primaryColor,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       ListTile(
//                         onTap: () {
//                           getImage();
//                         },
//                         leading: Icon(
//                           Icons.person,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                         title: Text(
//                           'Change profile picture',
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: "DefaultFontFamily",
//                           ),
//                         ),
//                         subtitle: Text(
//                           'change your account profile picture',
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: "DefaultFontFamily",
//                           ),
//                         ),
//                         trailing: Icon(
//                           Icons.arrow_right_outlined,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                       ),
//                       ListTile(
//                         onTap: () {
//                           Get.to(const ForgotPassword());
//                         },
//                         leading: Icon(
//                           Icons.refresh,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                         title: Text(
//                           'Reset password',
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: "DefaultFontFamily",
//                           ),
//                         ),
//                         subtitle: Text(
//                           'reset your account password',
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: "DefaultFontFamily",
//                           ),
//                         ),
//                         trailing: Icon(
//                           Icons.arrow_right_outlined,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                       ),
//                       // ListTile(
//                       //   onTap: () {
//                       //     Get.to(ForgotPin(
//                       //       password: userController.user[0].userPassword,
//                       //       pin: userController.user[0].transactionPIN,
//                       //     ));
//                       //   },
//                       //   leading: Icon(
//                       //     Icons.pin,
//                       //     color: Theme.of(context).primaryColor,
//                       //   ),
//                       //   title: Text(
//                       //     'Reset transaction PIN',
//                       //     style: TextStyle(
//                       //       color: Theme.of(context).primaryColor,
//                       //       fontSize: 12,
//                       //       fontWeight: FontWeight.bold,
//                       //       fontFamily: "DefaultFontFamily",
//                       //     ),
//                       //   ),
//                       //   subtitle: Text(
//                       //     'reset your 4 digit transaction PIN',
//                       //     style: TextStyle(
//                       //       color: Theme.of(context).primaryColor,
//                       //       fontSize: 12,
//                       //       fontFamily: "DefaultFontFamily",
//                       //       fontWeight: FontWeight.bold,
//                       //     ),
//                       //   ),
//                       //   trailing: Icon(Icons.arrow_right_outlined,
//                       //       color: Theme.of(context).primaryColor),
//                       // ),
//                       ListTile(
//                         onTap: () {
//                           Get.to(const ContactUsPage());
//                         },
//                         leading: Icon(
//                           Icons.call,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                         title: Text(
//                           'Contact us',
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: "DefaultFontFamily",
//                           ),
//                         ),
//                         subtitle: Text(
//                           'we are social, contact us for help & support',
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: "DefaultFontFamily",
//                           ),
//                         ),
//                         trailing: Icon(
//                           Icons.arrow_right_outlined,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                       ),
//                       ListTile(
//                         onTap: () {
//                           Get.to(const FaqsPage());
//                         },
//                         leading: Icon(
//                           Icons.bookmark,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                         title: Text(
//                           'FAQs',
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: "DefaultFontFamily",
//                           ),
//                         ),
//                         subtitle: Text(
//                           'see frequently asked questions from RentSpacers',
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontSize: 12,
//                             fontFamily: "DefaultFontFamily",
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         trailing: Icon(
//                           Icons.arrow_right_outlined,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                       ),
//                       ListTile(
//                         onTap: () {
//                           (hasBiometricStorage.read('hasBiometric') != null &&
//                                   hasBiometricStorage.read('hasBiometric') ==
//                                       true)
//                               ? _NotAuthenticateMe()
//                               : _authenticateMe();
//                         },
//                         leading: Icon(
//                           Icons.fingerprint,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                         title: Text(
//                           'Biometrics',
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontSize: 12,
//                             fontFamily: "DefaultFontFamily",
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         subtitle:
//                             (hasBiometricStorage.read('hasBiometric') != null &&
//                                     hasBiometricStorage.read('hasBiometric') ==
//                                         true)
//                                 ? const Text(
//                                     'disable biometric login',
//                                     style: TextStyle(
//                                       color: Colors.red,
//                                       fontSize: 12,
//                                       fontFamily: "DefaultFontFamily",
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   )
//                                 : const Text(
//                                     'enable biometric login for added security',
//                                     style: TextStyle(
//                                       color: Colors.greenAccent,
//                                       fontSize: 12,
//                                       fontFamily: "DefaultFontFamily",
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                         trailing: Icon(
//                           Icons.arrow_right_outlined,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                       ),
//                       ListTile(
//                         onTap: () {
//                           ThemeServices().changeThemeMode();
//                         },
//                         leading: themeChange.isSavedDarkMode()
//                             ? Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(20.0),
//                                 ),
//                                 padding: const EdgeInsets.all(2),
//                                 child: const Icon(
//                                   Icons.light_mode,
//                                   color: brandOne,
//                                 ),
//                               )
//                             : Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.black,
//                                   borderRadius: BorderRadius.circular(20.0),
//                                 ),
//                                 padding: const EdgeInsets.all(2),
//                                 child: const Icon(
//                                   Icons.dark_mode,
//                                   color: brandOne,
//                                 ),
//                               ),
//                         //color: Theme.of(context).iconTheme.color),
//                         title: Text(
//                           themeChange.isSavedDarkMode()
//                               ? "light mode".tr
//                               : "dark mode".tr,
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontSize: 12,
//                             fontFamily: "DefaultFontFamily",
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         trailing: Icon(
//                           Icons.arrow_right_outlined,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                       ),
//                       ListTile(
//                         onTap: () async {
//                           Get.bottomSheet(
//                             SizedBox(
//                               height: 200,
//                               child: ClipRRect(
//                                 borderRadius: const BorderRadius.only(
//                                   topLeft: Radius.circular(30.0),
//                                   topRight: Radius.circular(30.0),
//                                 ),
//                                 child: Container(
//                                   color: Theme.of(context).canvasColor,
//                                   padding:
//                                       const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                                   child: Column(
//                                     children: [
//                                       const SizedBox(
//                                         height: 50,
//                                       ),
//                                       Text(
//                                         'Are you sure you want to logout? This will immediately close the app!',
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           fontFamily: "DefaultFontFamily",
//                                           fontWeight: FontWeight.bold,
//                                           color: Theme.of(context).primaryColor,
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         height: 30,
//                                       ),
//                                       //card
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           InkWell(
//                                             onTap: () {
//                                               Get.back();
//                                             },
//                                             child: Container(
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width /
//                                                   4,
//                                               decoration: BoxDecoration(
//                                                 color: brandTwo,
//                                                 borderRadius:
//                                                     BorderRadius.circular(20),
//                                               ),
//                                               padding:
//                                                   const EdgeInsets.fromLTRB(
//                                                       20, 5, 20, 5),
//                                               child: const Text(
//                                                 'No',
//                                                 style: TextStyle(
//                                                   fontSize: 12,
//                                                   color: Colors.white,
//                                                   fontFamily:
//                                                       "DefaultFontFamily",
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(
//                                             width: 20,
//                                           ),
//                                           InkWell(
//                                             onTap: () async {
//                                               await auth.signOut().then(
//                                                 (value) {
//                                                   GetStorage().erase();
//                                                 },
//                                               ).then((value) => {exit(0)});
//                                             },
//                                             child: Container(
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width /
//                                                   4,
//                                               decoration: BoxDecoration(
//                                                 color: Colors.red,
//                                                 borderRadius:
//                                                     BorderRadius.circular(20),
//                                               ),
//                                               padding:
//                                                   const EdgeInsets.fromLTRB(
//                                                       20, 5, 20, 5),
//                                               child: const Text(
//                                                 'Yes',
//                                                 style: TextStyle(
//                                                   fontSize: 12,
//                                                   color: Colors.white,
//                                                   fontFamily:
//                                                       "DefaultFontFamily",
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),

//                                       //card
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                         leading: Icon(
//                           Icons.power_settings_new,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                         title: Text(
//                           'Logout',
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontSize: 12,
//                             fontFamily: "DefaultFontFamily",
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         subtitle: Text(
//                           'Logout from account',
//                           style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontSize: 12,
//                             fontFamily: "DefaultFontFamily",
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         trailing: Icon(
//                           Icons.arrow_right_outlined,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Text(
//                 'RentSpace v1.0.10',
//                 style: TextStyle(
//                   color: Theme.of(context).primaryColor,
//                   fontSize: 12,
//                   fontFamily: "DefaultFontFamily",
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(
//                 height: 80,
//               ),
//               InkWell(
//                 onLongPress: () {
//                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                     content: Text("Viola! You found it!"),
//                     duration: Duration(milliseconds: 800),
//                   ));
//                 },
//                 child: const Text(""),
//               ),
//               const SizedBox(
//                 height: 50,
//               ),
//             ],
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Get.to(const ShareAndEarn());
//         },
//         child: const Icon(
//           Icons.share_outlined,
//           size: 30,
//           color: Colors.white,
//         ),
//         backgroundColor: brandOne,
//       ),
//     );
//   }
// }
