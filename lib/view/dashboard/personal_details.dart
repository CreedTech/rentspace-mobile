// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../constants/colors.dart';
import '../../constants/utils/obscureEmail.dart';
// import '../../controller/user_controller.dart';
import '../../controller/auth/user_controller.dart';
import '../actions/onboarding_page.dart';

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
    print(_isEmailVerified);
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
          style: GoogleFonts.poppins(
              color: Theme.of(context).primaryColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600),
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
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).cardColor,
                          ),
                          child: const Icon(
                            Iconsax.user,
                            color: brandOne,
                            // size: 20,
                          ),
                        ),
                        title: Text(
                          'Full Name',
                          style: GoogleFonts.poppins(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle: Text(
                          "${userController.userModel!.userDetails![0].lastName.capitalize} ${userController.userModel!.userDetails![0].firstName.capitalize}"
                              .toUpperCase(),
                          style: GoogleFonts.poppins(
                            color: Theme.of(context).primaryColor,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).cardColor,
                          ),
                          child: const Icon(
                            Iconsax.smileys,
                            color: brandOne,
                            // size: 20,
                          ),
                        ),
                        title: Text(
                          'User Name',
                          style: GoogleFonts.poppins(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle: Text(
                          userController.userModel!.userDetails![0].userName!
                              .toUpperCase(),
                          style: GoogleFonts.poppins(
                            color: Theme.of(context).primaryColor,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).cardColor,
                          ),
                          child: const Icon(
                            Icons.mail_outline,
                            color: brandOne,
                          ),
                        ),
                        title: Text(
                          'Email',
                          style: GoogleFonts.poppins(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle: Text(
                            obscureEmail(userController
                                .userModel!.userDetails![0].email!),
                            style: GoogleFonts.poppins(
                              color: Theme.of(context).primaryColor,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            )),
                        onTap: () async {},
                        trailing: Icon(
                          Iconsax.verify5,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        //  const Icon(
                        //   Iconsax.edit,
                        //   color: brandOne,
                        // ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).cardColor,
                          ),
                          child: const Icon(
                            Iconsax.call,
                            color: brandOne,
                          ),
                        ),
                        title: Text(
                          'Phone',
                          style: GoogleFonts.poppins(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle: Text(
                            userController
                                .userModel!.userDetails![0].phoneNumber!,
                            style: GoogleFonts.poppins(
                              color: Theme.of(context).primaryColor,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            )),
                        // onTap: () {
                        //   (userController.userModel!.userDetails![0]
                        //               .hasVerifiedPhone ==
                        //           false)
                        //       ? Get.to(PhoneVerificationScreen())
                        //       : null;
                        // },
                        trailing: (userController.userModel!.userDetails![0]
                                    .hasVerifiedPhone ==
                                true)
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
                                      GoogleFonts.poppins(color: Colors.white),
                                ),
                              )
                            : Icon(
                                Iconsax.verify5,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).cardColor,
                          ),
                          child: const Icon(
                            Iconsax.security,
                            color: brandOne,
                          ),
                        ),
                        title: Text(
                          'BVN',
                          style: GoogleFonts.poppins(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle: Text(
                            (userController.userModel!.userDetails![0].bvn !=
                                    "")
                                ? obscureBVN(userController
                                    .userModel!.userDetails![0].bvn)
                                : '',
                            style: GoogleFonts.poppins(
                              color: Theme.of(context).primaryColor,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            )),
                        onTap: () {
                          if (userController.userModel!.userDetails![0].bvn ==
                              "") {
                            Get.to(BvnPage(
                                email: userController
                                    .userModel!.userDetails![0].email));
                          }
                        },
                        trailing: (userController.userModel!.userDetails![0]
                                    .hasVerifiedBvn ==
                                false)
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                decoration: BoxDecoration(
                                  color: brandOne,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  'Add BVN',
                                  style:
                                      GoogleFonts.poppins(color: Colors.white),
                                ),
                              )
                            : Icon(
                                Iconsax.verify5,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        //  const Icon(
                        //   Iconsax.edit,
                        //   color: brandOne,
                        // ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).cardColor,
                          ),
                          child: const Icon(
                            Icons.location_on_outlined,
                            color: brandOne,
                          ),
                        ),
                        title: Text(
                          'Address',
                          style: GoogleFonts.poppins(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle: Text(
                          // (userController.userModel!.userDetails![0].residentialAddress != "")
                          //     ?
                          userController.userModel!.userDetails![0]
                              .residentialAddress.capitalize!
                          // : 'Add Your Address for KYC Verification'
                          ,
                          style: GoogleFonts.poppins(
                            color: Theme.of(context).primaryColor,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            // decoration: TextDecoration.
                          ),
                        ),
                        // onTap: () {
                        //   if (userController.user[0].bvn == "") {
                        //     Get.to(const BvnPage());
                        //   }
                        // },
                        trailing: Icon(
                          Iconsax.verify5,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        //  const Icon(
                        //   Iconsax.edit,
                        //   color: brandOne,
                        // ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).cardColor,
                          ),
                          child: const Icon(
                            Icons.date_range_outlined,
                            color: brandOne,
                          ),
                        ),
                        title: Text(
                          'Date Of Birth',
                          style: GoogleFonts.poppins(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle: Text(
                          userController.userModel!.userDetails![0].dateOfBirth
                              .toString(),
                          style: GoogleFonts.poppins(
                            color: Theme.of(context).primaryColor,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            // decoration: TextDecoration.
                          ),
                        ),
                        // onTap: () {
                        //   if (userController.user[0].bvn == "") {
                        //     Get.to(const BvnPage());
                        //   }
                        // },
                        trailing: Icon(
                          Iconsax.verify5,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        //  const Icon(
                        //   Iconsax.edit,
                        //   color: brandOne,
                        // ),
                      ),
                    ),
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
