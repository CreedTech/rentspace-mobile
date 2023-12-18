import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../constants/colors.dart';
import '../../constants/db/firebase_db.dart';
import '../../constants/utils/obscureEmail.dart';
import '../../controller/user_controller.dart';
import '../actions/onboarding_page.dart';
import '../actions/phone_verification_screen.dart';
import '../actions/view_bvn_and_kyc.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

final _auth = FirebaseAuth.instance;
bool _isEmailVerified = false;
User? _user;

class _PersonalDetailsState extends State<PersonalDetails> {
  final UserController userController = Get.find();

  @override
  initState() {
    super.initState();

    _user = _auth.currentUser;
    _isEmailVerified = _user!.emailVerified;

    // checkingForBioMetrics();
    print(_isEmailVerified);
  }

  Future updateVerification() async {
    var userUpdate = FirebaseFirestore.instance.collection('accounts');

    await userUpdate.doc(userId).update({
      'has_verified_email': 'true',
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Personal Info',
          style: GoogleFonts.nunito(
              color: brandOne, fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
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
                          'Full Name',
                          style: GoogleFonts.nunito(
                            color: brandTwo,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle: Text(
                          "${userController.user[0].userFirst} ${userController.user[0].userLast}",
                          style: GoogleFonts.nunito(
                            color: brandOne,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: brandTwo.withOpacity(0.2),
                          ),
                          child: const Icon(
                            Icons.mail_outline,
                            color: brandOne,
                          ),
                        ),
                        title: Text(
                          'Email',
                          style: GoogleFonts.nunito(
                            color: brandTwo,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle:
                            Text(obscureEmail(userController.user[0].email),
                                style: GoogleFonts.nunito(
                                  color: brandOne,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                )),
                        onTap: () async {
                          if (!_isEmailVerified) {
                            await _user!.sendEmailVerification();
                            if (!context.mounted) return;
                            showTopSnackBar(
                              Overlay.of(context),
                              CustomSnackBar.success(
                                backgroundColor: brandOne,
                                message:
                                    'Verification E-mail has been sent to ${obscureEmail(userController.user[0].email)}',
                                textStyle: GoogleFonts.nunito(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            );
                            setState(() {
                              _isEmailVerified = _user!.emailVerified;
                            });
                            updateVerification();

                            _user!.reload();
                          }
                        },
                        trailing: (!_isEmailVerified)
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  'verify',
                                  style:
                                      GoogleFonts.nunito(color: Colors.white),
                                ),
                              )
                            : const Icon(
                                Iconsax.verify5,
                                color: brandOne,
                              ),
                        //  const Icon(
                        //   Iconsax.edit,
                        //   color: brandOne,
                        // ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
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
                          'Phone',
                          style: GoogleFonts.nunito(
                            color: brandTwo,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle: Text(userController.user[0].userPhone,
                            style: GoogleFonts.nunito(
                              color: brandOne,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            )),
                        onTap: () {
                          (userController.user[0].hasVerifiedPhone == 'false' ||
                                  userController.user[0].hasVerifiedPhone == '')
                              ? Get.to(PhoneVerificationScreen())
                              : null;
                        },
                        trailing: (userController.user[0].hasVerifiedPhone ==
                                    'false' ||
                                userController.user[0].hasVerifiedPhone == '')
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  'verify',
                                  style:
                                      GoogleFonts.nunito(color: Colors.white),
                                ),
                              )
                            : const Icon(
                                Iconsax.verify5,
                                color: brandOne,
                              ),
                        //  const Icon(
                        //   Iconsax.edit,
                        //   color: brandOne,
                        // ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 0),
                    //   child: ListTile(
                    //     leading: Container(
                    //       padding: const EdgeInsets.all(9),
                    //       decoration: BoxDecoration(
                    //         shape: BoxShape.circle,
                    //         color: brandTwo.withOpacity(0.2),
                    //       ),
                    //       child: const Icon(
                    //         Iconsax.security,
                    //         color: brandOne,
                    //       ),
                    //     ),
                    //     title: Text(
                    //       'BVN',
                    //       style: GoogleFonts.nunito(
                    //         color: brandTwo,
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.w400,
                    //       ),
                    //     ),
                    //     subtitle: Text(userController.user[0].bvn,
                    //         style: GoogleFonts.nunito(
                    //           color: brandOne,
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.w600,
                    //         )),
                    //     onTap: () {
                    //       if (userController.user[0].bvn == "") {
                    //         Get.to(const BvnPage());
                    //       } else {
                    //         Get.to(ViewBvnAndKyc(
                    //           bvn: userController.user[0].bvn,
                    //           hasVerifiedBvn:
                    //               userController.user[0].hasVerifiedBvn,
                    //           hasVerifiedKyc:
                    //               userController.user[0].hasVerifiedKyc,
                    //           kyc: userController.user[0].kyc,
                    //           idImage: userController.user[0].Idimage,
                    //         ));
                    //       }
                    //     },
                    //     trailing: (userController.user[0].hasVerifiedBvn !=
                    //                 'false' ||
                    //             userController.user[0].hasVerifiedBvn == '')
                    //         ? Container(
                    //             padding: const EdgeInsets.symmetric(
                    //                 horizontal: 20, vertical: 5),
                    //             decoration: BoxDecoration(
                    //               color: brandOne,
                    //               borderRadius: BorderRadius.circular(100),
                    //             ),
                    //             child: Text(
                    //               'Add BVN',
                    //               style:
                    //                   GoogleFonts.nunito(color: Colors.white),
                    //             ),
                    //           )
                    //         : const Icon(
                    //             Iconsax.verify5,
                    //             color: brandOne,
                    //           ),
                    //     //  const Icon(
                    //     //   Iconsax.edit,
                    //     //   color: brandOne,
                    //     // ),
                    //   ),
                    // ),
                 
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
