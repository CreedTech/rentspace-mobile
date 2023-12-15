import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/view/actions/onboarding_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: GestureDetector(
          onTap: (){
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: brandOne,
          ),
        ),
        title: Text(
          'Profile Settings',
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
                        'Personal Details',
                        style: GoogleFonts.nunito(
                          color: brandOne,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        // Get.to(ProfilePage());
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
                          Iconsax.security,
                          color: brandOne,
                        ),
                      ),
                      title: Text(
                        'BVN & KYC Details',
                        style: GoogleFonts.nunito(
                          color: brandOne,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        Get.to(BvnPage());
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
