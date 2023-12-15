import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_progress_bar/cupertino_progress_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path/path.dart';
import 'package:rentspace/view/actions/add_card.dart';
import 'package:rentspace/view/dashboard/profile.dart';

import '../../constants/colors.dart';
import 'package:get_storage/get_storage.dart';
import '../../constants/db/firebase_db.dart';
import '../../constants/theme_services.dart';
import '../../controller/user_controller.dart';
import '../actions/bank_and_card.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

final _auth = FirebaseAuth.instance;
User? _user;
bool _isEmailVerified = false;
final LocalAuthentication _localAuthentication = LocalAuthentication();
String _message = "Not Authorized";
bool _hasBiometric = false;
final hasBiometricStorage = GetStorage();
bool _hasFeeds = true;
final hasFeedsStorage = GetStorage();

class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  File? selectedImage;
  final UserController userController = Get.find();
  late AnimationController controller;

  Future getImage() async {
    var _image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = File(_image!.path); // won't have any error now
    });
    uploadImg();
  }

  Future updateVerification() async {
    var userUpdate = FirebaseFirestore.instance.collection('accounts');

    await userUpdate.doc(userId).update({
      'has_verified_email': 'true',
    }).catchError((error) {
      print(error);
    });
  }

  Future uploadImg() async {
    var userPinUpdate = FirebaseFirestore.instance.collection('accounts');

    FirebaseStorage storage = FirebaseStorage.instance;
    String fileName = basename(selectedImage!.path);
    Reference ref = storage.ref().child(fileName);
    UploadTask uploadTask = ref.putFile(selectedImage!);
    var downloadURL =
        await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    var url = downloadURL.toString();
    await userPinUpdate.doc(userId).update({
      'image': url,
    }).then((value) {
      Get.back();
      Get.snackbar(
        "Profile updated!",
        'Your profile picture has been updated successfully',
        animationDuration: const Duration(seconds: 1),
        backgroundColor: brandOne,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }).catchError((error) {
      Get.snackbar(
        "Error",
        error.toString(),
        animationDuration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  late double valueNotifier;
  @override
  initState() {
    super.initState();
    userController.user.isEmpty
        ? valueNotifier = 0.0
        : valueNotifier =
            double.tryParse(userController.user[0].finance_health)!;

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {});
    // controller.repeat(reverse: false);

    _user = _auth.currentUser;
    _isEmailVerified = _user!.emailVerified;

    checkingForBioMetrics();
    print(_isEmailVerified);
  }

  enableBiometrics() {
    if (hasBiometricStorage.read('hasBiometric') == null ||
        hasBiometricStorage.read('hasBiometric') == false) {
      hasBiometricStorage.write('hasBiometric', true);
      Get.back();
      Get.snackbar(
        "Enabled",
        "Biometrics enabled",
        animationDuration: const Duration(seconds: 1),
        backgroundColor: brandOne,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      if (hasBiometricStorage.read('hasBiometric') == false) {
        setState(
          () {
            _hasBiometric = true;
            hasBiometricStorage.write('hasBiometric', _hasBiometric);
          },
        );
        Get.back();
        Get.snackbar(
          "Enabled",
          "Biometrics enabled",
          animationDuration: const Duration(seconds: 1),
          backgroundColor: brandOne,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        return;
      }
    } else {
      print(hasBiometricStorage.read('hasBiometric').toString());
    }
    //print()
  }

  disableBiometrics() {
    if (hasBiometricStorage.read('hasBiometric') == null ||
        hasBiometricStorage.read('hasBiometric') == true) {
      hasBiometricStorage.write('hasBiometric', false);
      Get.back();
      Get.snackbar(
        "Disabled",
        "Biometrics disabled",
        animationDuration: const Duration(seconds: 1),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      if (hasBiometricStorage.read('hasBiometric') == true) {
        setState(
          () {
            _hasBiometric = false;
            hasBiometricStorage.write('hasBiometric', _hasBiometric);
          },
        );
        Get.back();
        Get.snackbar(
          "Disabled",
          "Biometrics disabled",
          animationDuration: const Duration(seconds: 1),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        return;
      }
    } else {
      print(hasBiometricStorage.read('hasBiometric').toString());
    }
    //print()
  }

  Future<bool> checkingForBioMetrics() async {
    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    print(canCheckBiometrics);
    return canCheckBiometrics;
  }

  Future<void> _authenticateMe() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticate(
        localizedReason: "Touch fingerprint scanner to enable Biometrics",
      );
      setState(() {
        _message = authenticated ? "Authorized" : "Not Authorized";
      });
      if (authenticated) {
        enableBiometrics();
      } else {
        Get.snackbar(
          "Error",
          "could not authenticate",
          animationDuration: const Duration(seconds: 1),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }

      print("Authenticated");
    } catch (e) {
      print("Not authenticated");
    }
    if (!mounted) return;
  }

  Future<void> _NotAuthenticateMe() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticate(
        localizedReason: "Touch fingerprint scanner to disable Biometrics",
      );
      setState(() {
        _message = authenticated ? "Authorized" : "Not Authorized";
      });

      if (authenticated) {
        disableBiometrics();
      } else {
        Get.snackbar(
          "Error",
          "could not authenticate",
          animationDuration: const Duration(seconds: 1),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }

      print("Authenticated");
    } catch (e) {
      print("Not authenticated");
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                // height: 80,
                width: MediaQuery.of(context).size.width - 20,
                // decoration: BoxDecoration(
                //   color: brandOne,
                //   borderRadius: BorderRadius.circular(20),
                // ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: brandOne, width: 1),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Container(
                            width: 60,
                            height: 60,
                            // padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              // border: Border.all(color: brandOne,width: 2),
                              // color: brandOne,
                              // shape: BoxShape.circle,
                              borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                colorFilter: const ColorFilter.mode(
                                  brandThree,
                                  BlendMode.darken,
                                ),
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  userController.user[0].image,
                                ),
                              ),
                            ),
                            // child: Image.network(
                            //   userController.user[0].image,
                            //   fit: BoxFit.cover,
                            //   // height: 60,
                            //   // width: 60,
                            // ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: brandOne,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${userController.user[0].userFirst} ${userController.user[0].userLast}",
                            style: GoogleFonts.nunito(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              color: brandOne,
                            ),
                          ),
                          const Icon(
                            Iconsax.verify5,
                            color: brandOne,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Wallet ID: ${userController.user[0].userWalletNumber}",
                            style: GoogleFonts.nunito(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w400,
                              color: brandTwo,
                            ),
                          ),
                          const Icon(
                            Iconsax.copy,
                            color: brandTwo,
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                    // CupertinoProgressBar(
                    //   value: ,
                    // ),
                    Container(
                      width: 320,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: brandThree,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: brandOne,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text(
                                    'Financial Health',
                                    style:
                                        GoogleFonts.nunito(color: Colors.white),
                                  ),
                                ),
                                Text(
                                  "${valueNotifier.toInt()}%",
                                  style: GoogleFonts.nunito(color: brandOne, fontWeight: FontWeight.w700,),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FAProgressBar(
                              currentValue: valueNotifier,
                              size: 5,
                              maxValue: 100,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              changeColorValue: 100,
                              changeProgressColor: (valueNotifier < 70)
                                  ? (valueNotifier < 30
                                      ? Colors.red
                                      : Colors.cyan)
                                  : Colors.greenAccent,
                              backgroundColor: const Color(0xffE8E8E8),
                              progressColor: (valueNotifier < 70)
                                  ? (valueNotifier < 30
                                      ? Colors.red
                                      : Colors.cyan)
                                  : Colors.greenAccent,
                              animatedDuration:
                                  const Duration(milliseconds: 300),
                              direction: Axis.horizontal,
                              // verticalDirection: VerticalDirection.up,
                              // displayText: 'mph',
                              formatValueFixed: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // LinearProgressIndicator(
                    //   color: (valueNotifier < 70)
                    //       ? (valueNotifier < 30
                    //           ? Colors.red
                    //           : Colors.cyan)
                    //       : Colors.greenAccent,
                    // ),
                  ],
                ),
                // SizedBox(
                //   height: 50,
                //   child: CircleAvatar(
                //     backgroundColor: Colors.transparent,
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.circular(200),
                //       child: Image.network(
                //         userController.user[0].image,
                //         fit: BoxFit.cover,
                //         height: 60,
                //         width: 60,
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   width: 10,
                // ),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(
                //       "${userController.user[0].userFirst} ${userController.user[0].userLast}",
                //       style: GoogleFonts.nunito(
                //         fontSize: 16.0,
                //         fontWeight: FontWeight.w700,
                //         color: Colors.white,
                //       ),
                //     ),
                //     const SizedBox(
                //       height: 5,
                //     ),
                //     Text(
                //       "Wallet ID: ${userController.user[0].userWalletNumber}",
                //       style: GoogleFonts.nunito(
                //         fontSize: 12.0,
                //         letterSpacing: 0.5,
                //         color: Colors.white,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ],
                // ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: brandTwo.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Iconsax.user,
                    color: brandOne,
                  ),
                ),
                title: Text(
                  'Profile',
                  style: GoogleFonts.nunito(
                    color: brandOne,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Get.to(const ProfilePage());
                  // Navigator.pushNamed(context, RouteList.profile);
                },
                trailing: const Icon(
                  Iconsax.arrow_right_3,
                  color: brandOne,
                ),
              ),
            ),
            // Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: brandTwo.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Iconsax.security_safe,
                    color: brandOne,
                  ),
                ),
                title: Text(
                  'Security',
                  style: GoogleFonts.nunito(
                    color: brandOne,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  // Navigator.pushNamed(context, RouteList.profile);
                },
                trailing: const Icon(
                  Iconsax.arrow_right_3,
                  color: brandOne,
                ),
              ),
            ),
            // Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: brandTwo.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Iconsax.brush_3,
                    color: brandOne,
                  ),
                ),
                title: Text(
                  'Theme',
                  style: GoogleFonts.nunito(
                    color: brandOne,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  ThemeServices().changeThemeMode();
                  // Navigator.pushNamed(context, RouteList.profile);
                },
                trailing: const Icon(
                  Iconsax.arrow_right_3,
                  color: brandOne,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: brandTwo.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Iconsax.share,
                    color: brandOne,
                  ),
                ),
                title: Text(
                  'Referral',
                  style: GoogleFonts.nunito(
                    color: brandOne,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  // Navigator.pushNamed(context, RouteList.profile);
                },
                trailing: const Icon(
                  Iconsax.arrow_right_3,
                  color: brandOne,
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 7),
            //   child: ListTile(
            //     leading: Container(
            //       padding: const EdgeInsets.all(9),
            //       decoration: BoxDecoration(
            //         shape: BoxShape.circle,
            //         color: brandTwo.withOpacity(0.2),
            //       ),
            //       child: const Icon(
            //         Iconsax.share,
            //         color: brandOne,
            //       ),
            //     ),
            //     title: Text(
            //       'Referral',
            //       style: GoogleFonts.nunito(
            //         color: brandOne,
            //         fontSize: 17,
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //     onTap: () {
            //       // Navigator.pushNamed(context, RouteList.profile);
            //     },
            //     trailing: const Icon(
            //       Iconsax.arrow_right_3,
            //       color: brandOne,
            //     ),
            //   ),
            // ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: brandTwo.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Iconsax.card,
                    color: brandOne,
                  ),
                ),
                title: Text(
                  'Bank & Card Details',
                  style: GoogleFonts.nunito(
                    color: brandOne,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  if (userController.user[0].cardCVV == '') {
                    Get.to(const AddCard());
                  } else {
                    Get.to(BankAndCard());
                  }
                },
                trailing: const Icon(
                  Iconsax.arrow_right_3,
                  color: brandOne,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: brandTwo.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Iconsax.call,
                    color: brandOne,
                  ),
                ),
                title: Text(
                  'Contact Us',
                  style: GoogleFonts.nunito(
                    color: brandOne,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  // Navigator.pushNamed(context, RouteList.profile);
                },
                trailing: const Icon(
                  Iconsax.arrow_right_3,
                  color: brandOne,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: brandTwo.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Iconsax.information,
                    color: brandOne,
                  ),
                ),
                title: Text(
                  'FAQs',
                  style: GoogleFonts.nunito(
                    color: brandOne,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  // Navigator.pushNamed(context, RouteList.profile);
                },
                trailing: const Icon(
                  Iconsax.arrow_right_3,
                  color: brandOne,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: const Icon(
                    Iconsax.logout,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  'Logout',
                  style: GoogleFonts.nunito(
                    color: brandOne,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  // Navigator.pushNamed(context, RouteList.profile);
                },
                trailing: const Icon(
                  Iconsax.arrow_right_3,
                  color: brandOne,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
