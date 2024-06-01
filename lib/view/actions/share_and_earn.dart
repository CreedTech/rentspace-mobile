import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/constants/colors.dart';
// import 'package:rentspace/controller/user_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:rentspace/constants/widgets/separator.dart';
// import 'package:rentspace/view/loan/loan_page.dart';
import 'package:share_plus/share_plus.dart';

import '../../controller/auth/user_controller.dart';

class ShareAndEarn extends StatefulWidget {
  const ShareAndEarn({super.key});

  @override
  _ShareAndEarnState createState() => _ShareAndEarnState();
}

class _ShareAndEarnState extends State<ShareAndEarn> {
  final UserController userController = Get.find();
  var ch8t = NumberFormat.simpleCurrency(name: 'NGN');
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: GestureDetector(
           onTap: () {
                  Get.back();
                },
          child: Row(
            children: [
              const Icon(
                Icons.arrow_back_ios_sharp,
                size: 27,
                color: colorWhite,
              ),
              SizedBox(
                width: 4.h,
              ),
              Text(
                'Referral',
                style: GoogleFonts.lato(
                  color: colorWhite,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: "Invite",
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: ' 1 ',
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: "New User",
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 10.h),
                child: Column(
                  children: [
                    Text(
                      'Get 500 Naira',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        fontSize: 40.0,
                        // letterSpacing: 0.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 10.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 4,
                              child: Column(
                                children: [
                                  Text(
                                    'Step 1',
                                    style: GoogleFonts.lato(
                                      fontSize: 12.0,
                                      // letterSpacing: 0.5,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(9),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: const Icon(
                                      Iconsax.share,
                                      color: brandOne,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    'Share your referral code with your friends',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 8.0,
                                      // letterSpacing: 0.5,
                                      fontWeight: FontWeight.w600,
                                      // fontFamily: "DefaultFontFamily",
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Iconsax.arrow_right_3,
                              color: Colors.white,
                              size: 15,
                            ),
                            const Icon(
                              Iconsax.arrow_right_3,
                              color: Colors.white,
                              size: 15,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 4,
                              child: Column(
                                children: [
                                  Text(
                                    'Step 2',
                                    style: GoogleFonts.lato(
                                      fontSize: 12.0,
                                      // letterSpacing: 0.5,
                                      fontWeight: FontWeight.w700,
                                      // fontFamily: "DefaultFontFamily",
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(9),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: const Icon(
                                      Iconsax.login,
                                      color: brandOne,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    'Friends sign up with your referral code',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 8.0,
                                      // letterSpacing: 0.5,
                                      fontWeight: FontWeight.w600,
                                      // fontFamily: "DefaultFontFamily",
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Iconsax.arrow_right_3,
                              color: Colors.white,
                              size: 15,
                            ),
                            const Icon(
                              Iconsax.arrow_right_3,
                              color: Colors.white,
                              size: 15,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 4,
                              child: Column(
                                children: [
                                  Text(
                                    'Step 3',
                                    style: GoogleFonts.lato(
                                      fontSize: 12.0,
                                      // letterSpacing: 0.5,
                                      fontWeight: FontWeight.w700,
                                      // fontFamily: "DefaultFontFamily",
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(9),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: const Icon(
                                      Iconsax.house_25,
                                      color: brandOne,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    'Friends start using the space rent and you both earn 500 naira',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 8.0,
                                      // letterSpacing: 0.5,
                                      fontWeight: FontWeight.w600,
                                      // fontFamily: "DefaultFontFamily",
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Total cash earned: ",
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: ch8t.format(userController
                                  .userModel!.userDetails![0].referralPoints),
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 20.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'REFERRAL CODE:',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15.w,
                              ),
                              child: const MySeparator(
                                color: brandOne,
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            InkWell(
                              onTap: () {
                                Clipboard.setData(
                                  ClipboardData(
                                    text: userController.userModel!
                                        .userDetails![0].referralCode,
                                  ),
                                );
                                Fluttertoast.showToast(
                                  msg: "Copied to clipboard!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.white,
                                  textColor: brandOne,
                                  fontSize: 16.0,
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    ' ${userController.userModel!.userDetails![0].referralCode}',
                                    style: GoogleFonts.lato(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  const Icon(
                                    Icons.copy,
                                    size: 20,
                                    color: brandOne,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              'You and Your friends can get bonus with your code',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          // width: MediaQuery.of(context).size.width * 2,
                          alignment: Alignment.center,
                          // height: 110.h,
                          child: Column(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width - 50,
                                      50),
                                  backgroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Share.share(
                                    "Hello, click this link to download RentSpace and use my referral code, ${userController.userModel!.userDetails![0].referralCode} to sign up and earn 500 naira! ${Platform.isIOS ? 'https://apps.apple.com/ng/app/rentspace-app/id6469376146' : 'https://play.google.com/store/apps/details?id=com.rentspace.app.android'}",
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.share_outlined,
                                      size: 20,
                                      color: brandOne,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Share and earn!',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                        color: brandOne,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 10.h),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 20.h),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Text(
                              'Referred Users (${userController.userModel!.userDetails![0].referrals})',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 35.w,
                              ),
                              child: MySeparator(
                                color: brandOne.withOpacity(0.2),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            (userController.userModel!.userDetails![0]
                                    .referredUsers.isNotEmpty)
                                ? ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    itemCount: 1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      int reversedIndex = userController
                                              .userModel!
                                              .userDetails![0]
                                              .referredUsers
                                              .length -
                                          1 -
                                          index;
                                      final history = userController
                                          .userModel!
                                          .userDetails![0]
                                          .referredUsers[reversedIndex];
                                      return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        minLeadingWidth: 0,
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: CachedNetworkImage(
                                              imageUrl: history['avatar']
                                                  ['url'],
                                              height: 30.h,
                                              width: 30.w,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) {
                                                return Image.asset(
                                                  'assets/icons/RentSpace-icon.png',
                                                  height: 30.h,
                                                  width: 30.w,
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                              errorWidget:
                                                  (context, url, error) {
                                                return Image.asset(
                                                  'assets/icons/RentSpace-icon.png',
                                                  height: 30.h,
                                                  width: 30.w,
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                              // progressIndicatorBuilder:
                                              //     (context, url, progress) {
                                              //   return const CustomLoader();
                                              // },
                                            ),
                                          ),
                                        ),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${history['lastName']} ${history['firstName']}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.lato(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        subtitle: Text(
                                          history['email'],
                                          style: GoogleFonts.lato(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w300,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        trailing: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: (history[
                                                        'has_received_referral_bonus'] ==
                                                    true)
                                                ? Colors.green
                                                : Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            (history['has_received_referral_bonus'] ==
                                                    false)
                                                ? "waiting"
                                                : 'done',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                              fontSize: 10.0,
                                              // fontFamily: "DefaultFontFamily",
                                              // letterSpacing: 0.5,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        // Text(
                                        //   (history['has_received_referral_bonus'] ==
                                        //           'false')
                                        //       ? 'Successful'
                                        //       : 'Pending',
                                        //   style: GoogleFonts.lato(
                                        //     fontSize: 14,
                                        //     fontWeight: FontWeight.w500,
                                        //     color: Colors.yellow[800],
                                        //   ),
                                        // ),
                                      );
                                    },
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Center(
                                      child: Text(
                                        "No Referred User",
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          // fontFamily: "DefaultFontFamily",
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Container(
                            //       width: 200,
                            //       child: Text(
                            //         ' ${userController.userModel!.userDetails![0].referredUsers[0]}',
                            //         maxLines: 10,
                            //         style: GoogleFonts.lato(
                            //           fontSize: 30.0,
                            //           // letterSpacing: 0.5,
                            //           fontWeight: FontWeight.w700,
                            //           // fontFamily: "DefaultFontFamily",
                            //           color: Theme.of(context).primaryColor,
                            //         ),
                            //       ),
                            //     ),
                            //     InkWell(
                            //       onTap: () {
                            //         Clipboard.setData(
                            //           ClipboardData(
                            //             text: userController.userModel!
                            //                 .userDetails![0].referralCode,
                            //           ),
                            //         );
                            //         Fluttertoast.showToast(
                            //           msg: "Copied to clipboard!",
                            //           toastLength: Toast.LENGTH_SHORT,
                            //           gravity: ToastGravity.CENTER,
                            //           timeInSecForIosWeb: 1,
                            //           backgroundColor: Colors.white,
                            //           textColor: brandOne,
                            //           fontSize: 16.0,
                            //         );
                            //       },
                            //       child: Icon(
                            //         Icons.copy,
                            //         size: 16,
                            //         color: brandOne,
                            //       ),
                            //     ),
                            //   ],
                            // ),

                            SizedBox(
                              height: 10.h,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/referralRecord',
                                );
                                // Get.to(const ReferralRecord());
                              },
                              child: Text(
                                'View All >>',
                                style: GoogleFonts.lato(
                                  decoration: TextDecoration.underline,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: Column(
              //     children: [
              //       // Todo: work on this part ==========
              //       Text(
              //         'REFERRAL CODE: ${userController.userModel!.userDetails![0].referralCode}',
              //         style: GoogleFonts.lato(
              //           fontSize: 16.0,
              //           // letterSpacing: 0.5,
              //           fontWeight: FontWeight.w700,
              //           // fontFamily: "DefaultFontFamily",
              //           color: Theme.of(context).primaryColor,
              //         ),
              //       ),
              //       Text(
              //         'NO OF REFERRED USERS: ${userController.userModel!.userDetails![0].referrals}'
              //             .toString(),
              //         style: GoogleFonts.lato(
              //           fontSize: 14.0,
              //           // letterSpacing: 1.0,
              //           fontWeight: FontWeight.w700,
              //           // fontFamily: "DefaultFontFamily",
              //           color: Theme.of(context).primaryColor,
              //         ),
              //       ),
              //       Text(userController.userModel!.userDetails![0].referredUsers[0])
              //     ],
              //   ),
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              // Image.asset(
              //   "assets/share.png",
              //   width: MediaQuery.of(context).size.width,
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(20.0),
              //   child: Text(
              //     "Participate in our exclusive program and seize the opportunity to earn 500 naira simply by referring friends through your unique code and getting them to save using the Space Rent . As you introduce more friends to our platform, your earnings increase – and the best part is that the money is paid directly to your space wallet.",
              //     textAlign: TextAlign.center,
              //     style: GoogleFonts.lato(
              //       fontSize: 16.0,
              //       // fontFamily: "DefaultFontFamily",
              //       fontWeight: FontWeight.w600,
              //       // letterSpacing: 0.5,
              //       color: Theme.of(context).primaryColor,
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(40.0),
              //   child: Align(
              //     alignment: Alignment.bottomCenter,
              //     child: Container(
              //       // width: MediaQuery.of(context).size.width * 2,
              //       alignment: Alignment.center,
              //       // height: 110.h,
              //       child: Column(
              //         children: [
              //           ElevatedButton(
              //             style: ElevatedButton.styleFrom(
              //               minimumSize: const Size(300, 50),
              //               backgroundColor: brandOne,
              //               elevation: 0,
              //               shape: RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(
              //                   10,
              //                 ),
              //               ),
              //             ),
              //             onPressed: () {
              //               Clipboard.setData(
              //                 ClipboardData(
              //                   text:
              //                       "Sign up with my code: ${userController.userModel!.userDetails![0].referralCode} to earn a free point!",
              //                 ),
              //               );
              //               Fluttertoast.showToast(
              //                 msg:
              //                     "Your referal code has been copied to clipboard!",
              //                 toastLength: Toast.LENGTH_SHORT,
              //                 gravity: ToastGravity.CENTER,
              //                 timeInSecForIosWeb: 1,
              //                 backgroundColor: brandOne,
              //                 textColor: Colors.white,
              //                 fontSize: 16.0,
              //               );
              //               Share.share(
              //                   "Hello, click this link https://play.google.com/store/apps/details?id=com.rentspace.app.android to download RentSpace and use my referal code, ${userController.userModel!.userDetails![0].referralCode} to sign up and earn a point!");
              //             },
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 const Icon(
              //                   Icons.share_outlined,
              //                   size: 30,
              //                   color: Colors.white,
              //                 ),
              //                 const SizedBox(
              //                   width: 10,
              //                 ),
              //                 Text(
              //                   'Share now!',
              //                   textAlign: TextAlign.center,
              //                   style: GoogleFonts.lato(
              //                     color: Colors.white,
              //                     fontSize: 16,
              //                     fontWeight: FontWeight.w700,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
