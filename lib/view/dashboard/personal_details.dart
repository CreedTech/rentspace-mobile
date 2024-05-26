// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';

import '../../constants/colors.dart';
// import '../../constants/utils/obscureEmail.dart';
// import '../../controller/user_controller.dart';
import '../../controller/auth/user_controller.dart';
// import '../actions/onboarding_page.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

// final _auth = FirebaseAuth.instance;
bool _isEmailVerified = false;
// User? _user;

class _PersonalDetailsState extends State<PersonalDetails> {
  final UserController userController = Get.find();

  @override
  initState() {
    super.initState();

    // _user = _auth.currentUser;
    _isEmailVerified =
        userController.userModel!.userDetails![0].hasVerifiedEmail;

    // checkingForBioMetrics();
    // print(_isEmailVerified);
  }

  Future updateVerification() async {
    // var userUpdate = FirebaseFirestore.instance.collection('accounts');

    // await userUpdate.doc(userId).update({
    //   'has_verified_email': 'true',
    // }).catchError((error) {
    //   print(error);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F8),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xffF6F6F8),
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios_sharp,
                size: 27,
                color: colorBlack,
              ),
            ),
            SizedBox(
              width: 4.h,
            ),
            Text(
              'Account Details',
              style: GoogleFonts.lato(
                color: colorBlack,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 15.h,
            horizontal: 24.w,
          ),
          child: ListView(
            children: [
              Column(
                children: [
                  Container(
                    width: 42.5,
                    height: 42.5,
                    // padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        colorFilter: const ColorFilter.mode(
                          brandThree,
                          BlendMode.darken,
                        ),
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          userController.userModel!.userDetails![0].avatar,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${userController.userModel!.userDetails![0].firstName.capitalizeFirst} ${userController.userModel!.userDetails![0].lastName.capitalizeFirst}",
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: colorBlack,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 17, top: 17, right: 17, bottom: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1), // Shadow color
                      spreadRadius: 0.5, // Spread radius
                      blurRadius: 2, // Blur radius
                      offset: const Offset(0, 3), // Offset
                    ),
                  ],
                  color: colorWhite,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0,
                      // horizontalTitleGap: 0,
                      minLeadingWidth: 0,

                      title: Text(
                        "${userController.userModel!.userDetails![0].userName.capitalizeFirst}",
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colorBlack,
                        ),
                      ),
                      subtitle: Text(
                        "Username",
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: colorBlack,
                        ),
                      ),
                      trailing: Wrap(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: userController
                                      .userModel!.userDetails![0].userName,
                                ),
                              );
                              Fluttertoast.showToast(
                                msg: "Copied to clipboard!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.SNACKBAR,
                                timeInSecForIosWeb: 1,
                                backgroundColor: brandOne,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            },
                            child: Image.asset(
                              'assets/icons/copy_icon.png',
                              width: 24,
                              height: 24,
                              color: colorBlack,
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            'Copy',
                            style: GoogleFonts.lato(
                              color: brandTwo,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Color(0xffC9C9C9),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0,
                      // horizontalTitleGap: 0,
                      minLeadingWidth: 0,

                      title: Text(
                        userController.userModel!.userDetails![0].dvaNumber,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colorBlack,
                        ),
                      ),
                      subtitle: Text(
                        "Account Number",
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: colorBlack,
                        ),
                      ),
                      trailing: Wrap(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: userController
                                      .userModel!.userDetails![0].dvaNumber,
                                ),
                              );
                              Fluttertoast.showToast(
                                msg: "Copied to clipboard!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.SNACKBAR,
                                timeInSecForIosWeb: 1,
                                backgroundColor: brandOne,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            },
                            child: Image.asset(
                              'assets/icons/copy_icon.png',
                              width: 24,
                              height: 24,
                              color: colorBlack,
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            'Copy',
                            style: GoogleFonts.lato(
                              color: brandTwo,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 17, top: 17, right: 17, bottom: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1), // Shadow color
                      spreadRadius: 0.5, // Spread radius
                      blurRadius: 2, // Blur radius
                      offset: const Offset(0, 3), // Offset
                    ),
                  ],
                  color: colorWhite,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0,
                      // horizontalTitleGap: 0,
                      minLeadingWidth: 0,

                      title: Text(
                        "${userController.userModel!.userDetails![0].firstName.capitalizeFirst} ${userController.userModel!.userDetails![0].lastName.capitalizeFirst}",
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff787878),
                        ),
                      ),
                      subtitle: Text(
                        "Username",
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff787878),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.keyboard_arrow_right,
                        color: colorBlack,
                        size: 20,
                      ),
                    ),
                    const Divider(
                      color: Color(0xffC9C9C9),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0,
                      // horizontalTitleGap: 0,
                      minLeadingWidth: 0,

                      title: Text(
                        userController.userModel!.userDetails![0].userName
                            .capitalizeFirst!,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff787878),
                        ),
                      ),
                      subtitle: Text(
                        "Account Number",
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff787878),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.keyboard_arrow_right,
                        color: colorBlack,
                        size: 20,
                      ),
                    ),
                    const Divider(
                      color: Color(0xffC9C9C9),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0,
                      // horizontalTitleGap: 0,
                      minLeadingWidth: 0,

                      title: Text(
                        userController.userModel!.userDetails![0]
                            .residentialAddress.capitalizeFirst!,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff787878),
                        ),
                      ),
                      subtitle: Text(
                        "Address",
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff787878),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.keyboard_arrow_right,
                        color: colorBlack,
                        size: 20,
                      ),
                    ),
                    const Divider(
                      color: Color(0xffC9C9C9),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0,
                      // horizontalTitleGap: 0,
                      minLeadingWidth: 0,

                      title: Text(
                        userController.userModel!.userDetails![0].phoneNumber,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff787878),
                        ),
                      ),
                      subtitle: Text(
                        "Phone Number",
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff787878),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.keyboard_arrow_right,
                        color: colorBlack,
                        size: 20,
                      ),
                    ),
                    const Divider(
                      color: Color(0xffC9C9C9),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0,
                      // horizontalTitleGap: 0,
                      minLeadingWidth: 0,

                      title: Text(
                        userController.userModel!.userDetails![0].email,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff787878),
                        ),
                      ),
                      subtitle: Text(
                        "Email",
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff787878),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.keyboard_arrow_right,
                        color: colorBlack,
                        size: 20,
                      ),
                    ),
                    const Divider(
                      color: Color(0xffC9C9C9),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0,
                      // horizontalTitleGap: 0,
                      minLeadingWidth: 0,

                      title: Text(
                        userController.userModel!.userDetails![0].dateOfBirth,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff787878),
                        ),
                      ),
                      subtitle: Text(
                        "Date of Birth",
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff787878),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.keyboard_arrow_right,
                        color: colorBlack,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              // Column(
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 2),
              //       child: ListTile(
              //         leading: Container(
              //           padding: const EdgeInsets.all(7),
              //           decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             color: Theme.of(context).cardColor,
              //           ),
              //           child: const Icon(
              //             Iconsax.user,
              //             color: brandOne,
              //             // size: 20,
              //           ),
              //         ),
              //         title: Text(
              //           'Full Name',
              //           style: GoogleFonts.lato(
              //             color: Theme.of(context).primaryColor,
              //             fontSize: 12,
              //             fontWeight: FontWeight.w400,
              //           ),
              //         ),
              //         subtitle: Text(
              //           "${userController.userModel!.userDetails![0].lastName.capitalize} ${userController.userModel!.userDetails![0].firstName.capitalize}"
              //               .toUpperCase(),
              //           style: GoogleFonts.lato(
              //             color: Theme.of(context).primaryColor,
              //             fontSize: 13,
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 2),
              //       child: ListTile(
              //         leading: Container(
              //           padding: const EdgeInsets.all(7),
              //           decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             color: Theme.of(context).cardColor,
              //           ),
              //           child: const Icon(
              //             Iconsax.smileys,
              //             color: brandOne,
              //             // size: 20,
              //           ),
              //         ),
              //         title: Text(
              //           'User Name',
              //           style: GoogleFonts.lato(
              //             color: Theme.of(context).primaryColor,
              //             fontSize: 12,
              //             fontWeight: FontWeight.w400,
              //           ),
              //         ),
              //         subtitle: Text(
              //           userController.userModel!.userDetails![0].userName!
              //               .toUpperCase(),
              //           style: GoogleFonts.lato(
              //             color: Theme.of(context).primaryColor,
              //             fontSize: 13,
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 2),
              //       child: ListTile(
              //         leading: Container(
              //           padding: const EdgeInsets.all(7),
              //           decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             color: Theme.of(context).cardColor,
              //           ),
              //           child: const Icon(
              //             Icons.mail_outline,
              //             color: brandOne,
              //           ),
              //         ),
              //         title: Text(
              //           'Email',
              //           style: GoogleFonts.lato(
              //             color: Theme.of(context).primaryColor,
              //             fontSize: 12,
              //             fontWeight: FontWeight.w400,
              //           ),
              //         ),
              //         subtitle: Text(
              //             obscureEmail(
              //                 userController.userModel!.userDetails![0].email!),
              //             style: GoogleFonts.lato(
              //               color: Theme.of(context).primaryColor,
              //               fontSize: 13,
              //               fontWeight: FontWeight.w600,
              //             )),
              //         onTap: () async {},
              //         trailing: Icon(
              //           Iconsax.verify5,
              //           color: Theme.of(context).colorScheme.secondary,
              //         ),
              //         //  const Icon(
              //         //   Iconsax.edit,
              //         //   color: brandOne,
              //         // ),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 2),
              //       child: ListTile(
              //         leading: Container(
              //           padding: const EdgeInsets.all(7),
              //           decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             color: Theme.of(context).cardColor,
              //           ),
              //           child: const Icon(
              //             Iconsax.call,
              //             color: brandOne,
              //           ),
              //         ),
              //         title: Text(
              //           'Phone',
              //           style: GoogleFonts.lato(
              //             color: Theme.of(context).primaryColor,
              //             fontSize: 12,
              //             fontWeight: FontWeight.w400,
              //           ),
              //         ),
              //         subtitle: Text(
              //             userController
              //                 .userModel!.userDetails![0].phoneNumber!,
              //             style: GoogleFonts.lato(
              //               color: Theme.of(context).primaryColor,
              //               fontSize: 13,
              //               fontWeight: FontWeight.w600,
              //             )),
              //         // onTap: () {
              //         //   (userController.userModel!.userDetails![0]
              //         //               .hasVerifiedPhone ==
              //         //           false)
              //         //       ? Get.to(PhoneVerificationScreen())
              //         //       : null;
              //         // },
              //         trailing: (userController.userModel!.userDetails![0]
              //                     .hasVerifiedPhone ==
              //                 true)
              //             ? Container(
              //                 padding: const EdgeInsets.symmetric(
              //                     horizontal: 20, vertical: 5),
              //                 decoration: BoxDecoration(
              //                   color: Colors.green,
              //                   borderRadius: BorderRadius.circular(100),
              //                 ),
              //                 child: Text(
              //                   'verify',
              //                   style: GoogleFonts.lato(color: Colors.white),
              //                 ),
              //               )
              //             : Icon(
              //                 Iconsax.verify5,
              //                 color: Theme.of(context).colorScheme.secondary,
              //               ),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 2),
              //       child: ListTile(
              //         leading: Container(
              //           padding: const EdgeInsets.all(7),
              //           decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             color: Theme.of(context).cardColor,
              //           ),
              //           child: const Icon(
              //             Iconsax.security,
              //             color: brandOne,
              //           ),
              //         ),
              //         title: Text(
              //           'BVN',
              //           style: GoogleFonts.lato(
              //             color: Theme.of(context).primaryColor,
              //             fontSize: 12,
              //             fontWeight: FontWeight.w400,
              //           ),
              //         ),
              //         subtitle: Text(
              //             (userController.userModel!.userDetails![0].bvn != "")
              //                 ? obscureBVN(
              //                     userController.userModel!.userDetails![0].bvn)
              //                 : '',
              //             style: GoogleFonts.lato(
              //               color: Theme.of(context).primaryColor,
              //               fontSize: 13,
              //               fontWeight: FontWeight.w600,
              //             )),
              //         onTap: () {
              //           if (userController.userModel!.userDetails![0].bvn ==
              //               "") {
              //             Get.to(BvnPage(
              //                 email: userController
              //                     .userModel!.userDetails![0].email));
              //           }
              //         },
              //         trailing: (userController
              //                     .userModel!.userDetails![0].hasVerifiedBvn ==
              //                 false)
              //             ? Container(
              //                 padding: const EdgeInsets.symmetric(
              //                     horizontal: 20, vertical: 5),
              //                 decoration: BoxDecoration(
              //                   color: brandOne,
              //                   borderRadius: BorderRadius.circular(100),
              //                 ),
              //                 child: Text(
              //                   'Add BVN',
              //                   style: GoogleFonts.lato(color: Colors.white),
              //                 ),
              //               )
              //             : Icon(
              //                 Iconsax.verify5,
              //                 color: Theme.of(context).colorScheme.secondary,
              //               ),
              //         //  const Icon(
              //         //   Iconsax.edit,
              //         //   color: brandOne,
              //         // ),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 2),
              //       child: ListTile(
              //         leading: Container(
              //           padding: const EdgeInsets.all(7),
              //           decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             color: Theme.of(context).cardColor,
              //           ),
              //           child: const Icon(
              //             Icons.location_on_outlined,
              //             color: brandOne,
              //           ),
              //         ),
              //         title: Text(
              //           'Address',
              //           style: GoogleFonts.lato(
              //             color: Theme.of(context).primaryColor,
              //             fontSize: 12,
              //             fontWeight: FontWeight.w400,
              //           ),
              //         ),
              //         subtitle: Text(
              //           // (userController.userModel!.userDetails![0].residentialAddress != "")
              //           //     ?
              //           userController.userModel!.userDetails![0]
              //               .residentialAddress.capitalize!
              //           // : 'Add Your Address for KYC Verification'
              //           ,
              //           style: GoogleFonts.lato(
              //             color: Theme.of(context).primaryColor,
              //             fontSize: 13,
              //             fontWeight: FontWeight.w600,
              //             // decoration: TextDecoration.
              //           ),
              //         ),
              //         // onTap: () {
              //         //   if (userController.user[0].bvn == "") {
              //         //     Get.to(const BvnPage());
              //         //   }
              //         // },
              //         trailing: Icon(
              //           Iconsax.verify5,
              //           color: Theme.of(context).colorScheme.secondary,
              //         ),
              //         //  const Icon(
              //         //   Iconsax.edit,
              //         //   color: brandOne,
              //         // ),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 2),
              //       child: ListTile(
              //         leading: Container(
              //           padding: const EdgeInsets.all(7),
              //           decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             color: Theme.of(context).cardColor,
              //           ),
              //           child: const Icon(
              //             Icons.date_range_outlined,
              //             color: brandOne,
              //           ),
              //         ),
              //         title: Text(
              //           'Date Of Birth',
              //           style: GoogleFonts.lato(
              //             color: Theme.of(context).primaryColor,
              //             fontSize: 12,
              //             fontWeight: FontWeight.w400,
              //           ),
              //         ),
              //         subtitle: Text(
              //           userController.userModel!.userDetails![0].dateOfBirth
              //               .toString(),
              //           style: GoogleFonts.lato(
              //             color: Theme.of(context).primaryColor,
              //             fontSize: 13,
              //             fontWeight: FontWeight.w600,
              //             // decoration: TextDecoration.
              //           ),
              //         ),
              //         // onTap: () {
              //         //   if (userController.user[0].bvn == "") {
              //         //     Get.to(const BvnPage());
              //         //   }
              //         // },
              //         trailing: Icon(
              //           Iconsax.verify5,
              //           color: Theme.of(context).colorScheme.secondary,
              //         ),
              //         //  const Icon(
              //         //   Iconsax.edit,
              //         //   color: brandOne,
              //         // ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
