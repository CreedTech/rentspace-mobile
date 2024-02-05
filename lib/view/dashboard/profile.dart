import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/view/actions/onboarding_page.dart';
import 'package:rentspace/view/dashboard/personal_details.dart';

import '../../controller/user_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserController userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          'Profile Settings',
          style: GoogleFonts.nunito(
              color: Theme.of(context).primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.w700),
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
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).cardColor,
                        ),
                        child: const Icon(
                          Iconsax.user,
                          color: brandOne,
                        ),
                      ),
                      title: Text(
                        'Personal Details',
                        style: GoogleFonts.nunito(
                          color: Theme.of(context).primaryColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        Get.to(const PersonalDetails());
                        // Navigator.pushNamed(context, RouteList.profile);
                      },
                      trailing: Icon(
                        Iconsax.arrow_right_3,
                        color: Theme.of(context).primaryColor,
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
                          color: Theme.of(context).cardColor,
                        ),
                        child: const Icon(
                          Iconsax.security,
                          color: brandOne,
                        ),
                      ),
                      title: Text(
                        'BVN & KYC Details',
                        style: GoogleFonts.nunito(
                          color: Theme.of(context).primaryColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        if (userController.user[0].bvn != "") {
                          Get.to(const BvnPage());
                        } else {
                          Get.to(const PersonalDetails());
                          // Get.to(ViewBvnAndKyc(
                          //   bvn: userController.user[0].bvn,
                          //   hasVerifiedBvn:
                          //       userController.user[0].hasVerifiedBvn,
                          //   hasVerifiedKyc:
                          //       userController.user[0].hasVerifiedKyc,
                          //   kyc: userController.user[0].kyc,
                          //   idImage: userController.user[0].Idimage,
                          // ));
                        }
                        // Navigator.pushNamed(context, RouteList.profile);
                      },
                      trailing: Icon(
                        Iconsax.arrow_right_3,
                        color: Theme.of(context).primaryColor,
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
                  //         Iconsax.bank,
                  //         color: brandOne,
                  //       ),
                  //     ),
                  //     title: Text(
                  //       'BVN Details',
                  //       style: GoogleFonts.nunito(
                  //         color: brandOne,
                  //         fontSize: 17,
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ),
                  //     onTap: () {
                  //       // Get.to(ProfilePage());
                  //       // Navigator.pushNamed(context, RouteList.profile);
                  //     },
                  //     trailing: const Icon(
                  //       Iconsax.arrow_right_3,
                  //       color: brandOne,
                  //     ),
                  //   ),
                  // ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
